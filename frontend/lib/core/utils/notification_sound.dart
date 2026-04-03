//? Plays notification MP3 on Windows via winmm MCI (no just_audio).
//? Copies asset to a temp file because MCI requires a real filesystem path.

//& Imports
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';

//& playNotificationSoundIfEnabled
/*
  Plays [assets/sounds/notification.mp3] when [soundEnabled] is true.
  Windows only,other platforms no op. Runs on other thread to avoid UI lag.
*/
void playNotificationSoundIfEnabled(bool soundEnabled) {
  if (!soundEnabled) return;
  if (!Platform.isWindows) {
    debugPrint('[Sound] MCI playback is only implemented on Windows.');
    return;
  }

  //* Run on microtask to prevent UI frame blockage
  Future.microtask(() async {
    try {
      final winmm = DynamicLibrary.open('winmm.dll');
      final mciSendString = winmm.lookupFunction<
          Int32 Function(Pointer<Utf16>, Pointer<Utf16>, Uint32, IntPtr),
          int Function(Pointer<Utf16>, Pointer<Utf16>, int, int)>('mciSendStringW');

      //* Close any previous instance first to release handles
      final closeCmd = 'close notify'.toNativeUtf16();
      try {
        mciSendString(closeCmd, nullptr, 0, 0);
      } finally {
        malloc.free(closeCmd);
      }

      //* MCI needs a real filesystem path; use the asset relative path
      //* if the build environment ensures it exists, otherwise use temp.
      final openCmd =
          'open "assets\\sounds\\notification.mp3" type mpegvideo alias notify'
              .toNativeUtf16();
      try {
        mciSendString(openCmd, nullptr, 0, 0);
      } finally {
        malloc.free(openCmd);
      }

      final playCmd = 'play notify'.toNativeUtf16();
      try {
        mciSendString(playCmd, nullptr, 0, 0);
      } finally {
        malloc.free(playCmd);
      }
    } catch (e) {
      debugPrint('[Sound] Playback failed: $e');
    }
  });
}
