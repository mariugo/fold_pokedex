import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fold_pokedex/ui/core/diagnostics/device_posture.dart';
import 'package:fold_pokedex/ui/core/diagnostics/screen_breakpoint.dart';
import 'package:fold_pokedex/ui/core/diagnostics/screen_snapshot.dart';

const _hingeFeature = DisplayFeature(
  bounds: Rect.fromLTWH(0, 0, 20, 800),
  type: DisplayFeatureType.hinge,
  state: DisplayFeatureState.postureHalfOpened,
);

ScreenSnapshot _snapshot({
  Size size = const Size(400, 800),
  Orientation orientation = Orientation.portrait,
  List<DisplayFeature> displayFeatures = const [],
}) {
  return ScreenSnapshot(
    size: size,
    orientation: orientation,
    breakpoint: ScreenBreakpoint.fromWidth(size.width),
    displayFeatures: displayFeatures,
    devicePosture: displayFeatures.isEmpty
        ? DevicePosture.unknown
        : (displayFeatures.any(
                (f) => f.state == DisplayFeatureState.postureHalfOpened,
              )
              ? DevicePosture.halfOpened
              : DevicePosture.flat),
  );
}

void main() {
  group('ScreenSnapshot.of', () {
    testWidgets('derives size, orientation, and breakpoint from MediaQuery', (
      tester,
    ) async {
      late ScreenSnapshot snapshot;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1000, 600)),
          child: Builder(
            builder: (context) {
              snapshot = ScreenSnapshot.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(snapshot.size, const Size(1000, 600));
      expect(snapshot.orientation, Orientation.landscape);
      expect(snapshot.breakpoint, ScreenBreakpoint.expanded);
      expect(snapshot.devicePosture, DevicePosture.unknown);
    });

    testWidgets('reports halfOpened posture when a hinge is half-opened', (
      tester,
    ) async {
      late ScreenSnapshot snapshot;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(
            size: Size(1350, 841),
            displayFeatures: [_hingeFeature],
          ),
          child: Builder(
            builder: (context) {
              snapshot = ScreenSnapshot.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(snapshot.devicePosture, DevicePosture.halfOpened);
    });
  });

  group('ScreenSnapshot.describe', () {
    test('includes every field in a single line', () {
      final snapshot = _snapshot();

      expect(snapshot.describe(), contains('size: Size(400.0, 800.0)'));
      expect(snapshot.describe(), contains('orientation: portrait'));
      expect(snapshot.describe(), contains('breakpoint: compact'));
      expect(snapshot.describe(), contains('posture: unknown'));
      expect(snapshot.describe(), contains('displayFeatures: none'));
    });
  });

  group('ScreenSnapshot.diffFrom', () {
    test('returns an empty string when nothing changed', () {
      final a = _snapshot();
      final b = _snapshot();

      expect(a.diffFrom(b), isEmpty);
    });

    test('describes only the fields that changed', () {
      final folded = _snapshot(size: const Size(673, 841));
      final unfolded = _snapshot(
        size: const Size(1350, 841),
        orientation: Orientation.landscape,
        displayFeatures: const [_hingeFeature],
      );

      final diff = folded.diffFrom(unfolded);

      expect(diff, contains('size: Size(673.0, 841.0) -> Size(1350.0, 841.0)'));
      expect(diff, contains('orientation: portrait -> landscape'));
      expect(diff, contains('breakpoint: medium -> expanded'));
      expect(diff, contains('posture: unknown -> halfOpened'));
      expect(
        diff,
        contains('displayFeatures: none -> hinge(postureHalfOpened)'),
      );
    });
  });

  group('ScreenSnapshot equality', () {
    test('two snapshots with the same values are equal', () {
      expect(_snapshot(), equals(_snapshot()));
    });

    test('snapshots differing in devicePosture are not equal', () {
      expect(
        _snapshot(),
        isNot(equals(_snapshot(displayFeatures: const [_hingeFeature]))),
      );
    });
  });
}
