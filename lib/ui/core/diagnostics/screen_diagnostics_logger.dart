import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:fold_pokedex/ui/core/diagnostics/device_posture.dart';
import 'package:fold_pokedex/ui/core/diagnostics/ios_fold_posture_channel.dart';
import 'package:fold_pokedex/ui/core/diagnostics/screen_snapshot.dart';

/// Logs window size, orientation, and foldable posture changes to the
/// console whenever they affect this screen's layout.
///
/// Mix this into a screen's [State] to get automatic diagnostics without
/// wiring up an observer manually:
///
/// ```dart
/// class _HomeScreenState extends State<HomeScreen>
///     with ScreenDiagnosticsLogger<HomeScreen> {
///   // Nothing else needed; changes are logged as they happen.
/// }
/// ```
///
/// Size, orientation, and breakpoint changes rely on
/// [State.didChangeDependencies], which Flutter calls whenever the
/// [MediaQuery] this widget reads from changes. On iOS, fold posture updates
/// additionally arrive from [IosFoldPostureChannel]. Logging is a no-op
/// outside of debug builds.
mixin ScreenDiagnosticsLogger<T extends StatefulWidget> on State<T> {
  ScreenSnapshot? _lastSnapshot;
  DevicePosture? _lastIosPosture;
  StreamSubscription<DevicePosture>? _iosPostureSubscription;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      _iosPostureSubscription = IosFoldPostureChannel().watch().listen(
        _logIosPostureIfChanged,
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (kDebugMode) _logSnapshotIfChanged();
  }

  @override
  void dispose() {
    unawaited(_iosPostureSubscription?.cancel());
    super.dispose();
  }

  void _logSnapshotIfChanged() {
    final snapshot = ScreenSnapshot.of(context);
    final previous = _lastSnapshot;
    if (snapshot == previous) return;
    _lastSnapshot = snapshot;

    logDiagnostic(
      previous == null ? snapshot.describe() : previous.diffFrom(snapshot),
    );
  }

  void _logIosPostureIfChanged(DevicePosture posture) {
    if (posture == _lastIosPosture) return;
    _lastIosPosture = posture;

    logDiagnostic('posture (native): ${posture.name}');
  }

  /// Emits a diagnostic [message] for this screen.
  ///
  /// Writes to `dart:developer`'s log by default; overridable so tests can
  /// capture messages without depending on a VM service listener.
  @visibleForTesting
  void logDiagnostic(String message) {
    developer.log(message, name: 'screen_diagnostics (${widget.runtimeType})');
  }
}
