//? Custom debug logger for Tazrout dashboard.
//? Mirrors the Python logging convention — tagged print statements
//? with severity levels, saved to a rotating .log file.
//? Use AppLogger instead of print() everywhere in the project.

//& Imports
import 'dart:io';
import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

//& Log Level Enum
//? Defines severity tiers for filtering output
enum LogLevel { debug, info, warning, error, critical }

//& AppLogger Class
class AppLogger {
  //& Configuration
  //? Log file saved next to the running executable.
  //* Max log file size before rotation: 1MB
  static const String _logFileName = 'tazrout.log';
  static const int _maxFileSizeBytes = 1024 * 1024;

  //& ANSI color constants
  static const String _reset  = '\x1B[0m';
  static const String _grey   = '\x1B[90m';   //? DEBUG
  static const String _cyan   = '\x1B[36m';   //? INFO
  static const String _yellow = '\x1B[33m';   //? WARN
  static const String _red    = '\x1B[31m';   //? ERROR
  static const String _redBold = '\x1B[1;31m'; //? CRITICAL
  static const String _green  = '\x1B[32m';   //? THEME
  static const String _blue   = '\x1B[34m';   //? NAV
  static const String _magenta = '\x1B[35m';  //? NET
  static const String _white  = '\x1B[37m';   //? STATE

  //& Prefix Mapping
  //* Map each level to its color and plain text label
  static String _prefix(LogLevel level) {
    switch (level) {
      case LogLevel.debug:    return '${_grey}[DEBUG]   $_reset';
      case LogLevel.info:     return '${_cyan}[INFO]    $_reset';
      case LogLevel.warning:  return '${_yellow}[WARN]    $_reset';
      case LogLevel.error:    return '${_red}[ERROR]   $_reset';
      case LogLevel.critical: return '${_redBold}[CRITICAL]$_reset';
    }
  }

  //& Tag Color Mapping
  //* Domain tag colors
  static String _tagColor(String tag) {
    switch (tag) {
      case 'THEME': return _green;
      case 'NAV':   return _blue;
      case 'NET':   return _magenta;
      case 'STATE': return _white;
      default:      return _cyan;
    }
  }

  //& Core Log Method
  //* Only prints in debug mode — silent in release builds
  //* Format: [LEVEL] HH:MM:SS.mmm | TAG | message
  static void _log(LogLevel level, String tag, String message, [Object? error, StackTrace? stackTrace]) {
    final timestamp = DateFormat('HH:mm:ss.SSS').format(DateTime.now());
    
    final line =
      '${_prefix(level)}${_grey}${timestamp}$_reset '
      '${_tagColor(tag)}[$tag]$_reset $message';

    if (kDebugMode) {
      dev.log(
        line,
        name: tag,
        time: DateTime.now(),
        level: _getDevLogLevel(level),
        error: error,
        stackTrace: stackTrace,
      );
    }

    //* Strip ANSI codes for file output — keep terminal output colored
    final plainLine = line.replaceAll(RegExp(r'\x1B\[[0-9;]*m'), '');
    _writeToFile(plainLine + (error != null ? ' | Error: $error' : ''));
  }

  static int _getDevLogLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
      case LogLevel.critical:
        return 1200;
    }
  }

  //& Public Logging Methods
  static void debug(String tag, String message) => _log(LogLevel.debug, tag, message);
  static void info(String tag, String message) => _log(LogLevel.info, tag, message);
  static void warning(String tag, String message) => _log(LogLevel.warning, tag, message);
  
  static void error(String tag, String message, [Object? exception, StackTrace? stackTrace]) {
    _log(LogLevel.error, tag, message, exception, stackTrace);
  }

  static void critical(String tag, String message, [Object? exception, StackTrace? stackTrace]) {
    _log(LogLevel.critical, tag, message, exception, stackTrace);
  }

  //& Specialty Loggers
  //? Dedicated methods for domain-specific events

  //* Theme resolution — logs which color token was applied and in which mode
  static void theme(String token, String hexValue, String mode) =>
    _log(LogLevel.debug, 'THEME', '$token → $hexValue ($mode)');

  //* Navigation events
  static void nav(String from, String to) =>
    _log(LogLevel.info, 'NAV', '$from → $to');

  //* API calls
  static void net(String method, String endpoint, int? statusCode) =>
    _log(LogLevel.info, 'NET', '$method $endpoint ${statusCode ?? "pending"}');

  //* State changes
  static void state(String provider, String change) =>
    _log(LogLevel.debug, 'STATE', '$provider: $change');

  //& File Writing
  //* Appends formatted log line to tazrout.log next to the executable
  //* Rotates file if size exceeds _maxFileSizeBytes
  static Future<void> _writeToFile(String line) async {
    try {
      //* Resolve log path relative to executable — stays inside project
      final executableDir = File(Platform.resolvedExecutable).parent.path;
      final file = File('$executableDir/$_logFileName');

      if (await file.exists()) {
        final size = await file.length();
        if (size > _maxFileSizeBytes) {
          //* Rotation: Simple rename current to .old and start fresh
          final oldFile = File('${file.path}.old');
          if (await oldFile.exists()) await oldFile.delete();
          await file.rename(oldFile.path);
        }
      }

      await file.writeAsString('$line\n', mode: FileMode.append, flush: true);
    } catch (e) {
      // Fallback if file writing fails
      debugPrint('Failed to write to log file: $e');
    }
  }

  //& Session Separator
  //* Call once at app startup in main.dart to mark new session in log file
  static Future<void> startSession() async {
    final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    final separator = '\n' + '=' * 80 + '\n' +
                      'NEW SESSION STARTED AT $timestamp' + '\n' +
                      '=' * 80 + '\n';
    await _writeToFile(separator);
  }
}
