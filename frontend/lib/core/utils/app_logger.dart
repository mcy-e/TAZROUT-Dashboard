//? Custom debug logger for Tazrout dashboard.
//? Mirrors the Python logging convention — tagged print statements
//? with severity levels, saved to a rotating .log file.
//? Use AppLogger instead of print() everywhere in the project.

//& Imports
import 'dart:io';
import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

//& Log Level Enum
//? Defines severity tiers for filtering output
enum LogLevel { debug, info, warning, error, critical }

//& AppLogger Class
class AppLogger {
  //& Configuration
  //? Log file saved to app documents directory as tazrout.log
  //? File is appended, not overwritten, on each session
  //* Max log file size before rotation: 1MB
  static const String _logFileName = 'tazrout.log';
  static const int _maxFileSizeBytes = 1024 * 1024;

  //& Prefix Convention
  static String _getLevelPrefix(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '[DEBUG]    🔍';
      case LogLevel.info:
        return '[INFO]     ✅';
      case LogLevel.warning:
        return '[WARN]     ⚠️';
      case LogLevel.error:
        return '[ERROR]    ❌';
      case LogLevel.critical:
        return '[CRITICAL] 🔥';
    }
  }

  //& Core Log Method
  //* Only prints in debug mode — silent in release builds
  //* Format: [LEVEL] HH:MM:SS.mmm | TAG | message
  static void _log(LogLevel level, String tag, String message, [Object? error, StackTrace? stackTrace]) {
    final timestamp = DateFormat('HH:mm:ss.SSS').format(DateTime.now());
    final prefix = _getLevelPrefix(level);
    final logLine = '$prefix $timestamp | $tag | $message';

    if (kDebugMode) {
      dev.log(
        logLine,
        name: tag,
        time: DateTime.now(),
        level: _getDevLogLevel(level),
        error: error,
        stackTrace: stackTrace,
      );
    }

    _writeToFile(logLine + (error != null ? ' | Error: $error' : ''));
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
    _log(LogLevel.debug, 'THEME', '🎨 $token → $hexValue ($mode)');

  //* Navigation events
  static void nav(String from, String to) =>
    _log(LogLevel.info, 'NAV', '🧭 $from → $to');

  //* API calls
  static void net(String method, String endpoint, int? statusCode) =>
    _log(LogLevel.info, 'NET', '🌐 $method $endpoint ${statusCode ?? "pending"}');

  //* State changes
  static void state(String provider, String change) =>
    _log(LogLevel.debug, 'STATE', '📦 $provider: $change');

  //& File Writing
  //* Appends formatted log line to tazrout.log in app documents dir
  //* Rotates file if size exceeds _maxFileSizeBytes
  static Future<void> _writeToFile(String line) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_logFileName');

      if (await file.exists()) {
        final size = await file.length();
        if (size > _maxFileSizeBytes) {
          //* Rotation: Simple rename current to .old and start fresh
          final oldFile = File('${directory.path}/$_logFileName.old');
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
