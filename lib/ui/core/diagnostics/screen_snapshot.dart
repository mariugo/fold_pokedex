import 'dart:ui' show DisplayFeature, DisplayFeatureState;

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:fold_pokedex/ui/core/diagnostics/device_posture.dart';
import 'package:fold_pokedex/ui/core/diagnostics/screen_breakpoint.dart';

/// A point-in-time snapshot of the window size, orientation, and foldable
/// posture, as reported by [MediaQuery].
///
/// Compare two snapshots with [diffFrom] to describe only what changed, e.g.
/// after the user folds, unfolds, or rotates the device.
///
/// [devicePosture] is derived from `MediaQueryData.displayFeatures`, which
/// the Flutter engine only populates on Android today. On other platforms it
/// is always [DevicePosture.unknown]; see `IosFoldPostureChannel` for the
/// native-backed iOS counterpart.
final class ScreenSnapshot extends Equatable {
  /// Creates a snapshot from already-extracted values.
  const new({
    required this.size,
    required this.orientation,
    required this.breakpoint,
    required this.displayFeatures,
    required this.devicePosture,
  });

  /// Builds a snapshot from the [MediaQuery] visible to [context].
  factory of(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return ScreenSnapshot(
      size: mediaQuery.size,
      orientation: mediaQuery.orientation,
      breakpoint: ScreenBreakpoint.fromWidth(mediaQuery.size.width),
      displayFeatures: mediaQuery.displayFeatures,
      devicePosture: _postureFrom(mediaQuery.displayFeatures),
    );
  }

  static DevicePosture _postureFrom(List<DisplayFeature> displayFeatures) {
    if (displayFeatures.isEmpty) return DevicePosture.unknown;
    final isHalfOpened = displayFeatures.any(
      (feature) => feature.state == DisplayFeatureState.postureHalfOpened,
    );
    return isHalfOpened ? DevicePosture.halfOpened : DevicePosture.flat;
  }

  /// The window size in logical pixels.
  final Size size;

  /// The current portrait/landscape orientation.
  final Orientation orientation;

  /// The layout breakpoint classified from [size].
  final ScreenBreakpoint breakpoint;

  /// Hinges, folds, and cutouts reported by the OS, if any.
  final List<DisplayFeature> displayFeatures;

  /// The fold posture derived from [displayFeatures].
  final DevicePosture devicePosture;

  /// A one-line, human-readable description of this snapshot.
  String describe() {
    return 'size: $size, orientation: ${orientation.name}, '
        'breakpoint: ${breakpoint.name}, posture: ${devicePosture.name}, '
        'displayFeatures: ${_describeFeatures(displayFeatures)}';
  }

  /// Describes only the fields that differ between this snapshot and [next].
  ///
  /// Returns an empty string if nothing changed.
  String diffFrom(ScreenSnapshot next) {
    final displayFeaturesChanged = !listEquals(
      displayFeatures,
      next.displayFeatures,
    );
    final displayFeaturesDiff =
        'displayFeatures: ${_describeFeatures(displayFeatures)} -> '
        '${_describeFeatures(next.displayFeatures)}';
    final changes = <String>[
      if (size != next.size) 'size: $size -> ${next.size}',
      if (orientation != next.orientation)
        'orientation: ${orientation.name} -> ${next.orientation.name}',
      if (breakpoint != next.breakpoint)
        'breakpoint: ${breakpoint.name} -> ${next.breakpoint.name}',
      if (devicePosture != next.devicePosture)
        'posture: ${devicePosture.name} -> ${next.devicePosture.name}',
      if (displayFeaturesChanged) displayFeaturesDiff,
    ];
    return changes.join(', ');
  }

  static String _describeFeatures(List<DisplayFeature> features) {
    if (features.isEmpty) return 'none';
    return features.map((f) => '${f.type.name}(${f.state.name})').join(', ');
  }

  @override
  List<Object?> get props => [
    size,
    orientation,
    breakpoint,
    displayFeatures,
    devicePosture,
  ];
}
