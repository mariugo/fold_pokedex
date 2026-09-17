import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:fold_pokedex/ui/core/diagnostics/device_posture.dart';

/// Reports fold posture changes on iOS via a native platform channel.
///
/// Flutter does not populate `MediaQuery.displayFeatures` on iOS (unlike
/// Android, which gets it for free from `androidx.window`). iPhone Duo has no
/// documented public API that simply reports "flat" vs "half-opened" either —
/// Apple's guidance pushes apps toward reacting to size class and
/// `reservedRegion` changes instead. The native counterpart to this channel,
/// `ios/Runner/FoldPostureStreamHandler.swift`, approximates posture from
/// those two signals.
///
/// This has not been built or run — there is no Mac/Xcode in this workspace
/// to verify it against the real iOS 27 SDK. Treat both sides as scaffolding
/// to verify on real hardware before relying on it.
class IosFoldPostureChannel {
  static const EventChannel _channel = EventChannel(
    'fold_pokedex/fold_posture',
  );

  /// A broadcast stream of posture changes reported by the native side.
  ///
  /// Emits nothing on platforms other than iOS.
  Stream<DevicePosture> watch() {
    if (kIsWeb || !Platform.isIOS) return const Stream.empty();

    return _channel.receiveBroadcastStream().map((event) {
      return switch (event) {
        'flat' => DevicePosture.flat,
        'halfOpened' => DevicePosture.halfOpened,
        _ => DevicePosture.unknown,
      };
    });
  }
}
