import 'package:flutter_test/flutter_test.dart';
import 'package:fold_pokedex/ui/core/diagnostics/device_posture.dart';
import 'package:fold_pokedex/ui/core/diagnostics/ios_fold_posture_channel.dart';

void main() {
  group('IosFoldPostureChannel.watch', () {
    test('emits nothing on non-iOS test hosts', () async {
      // flutter test always runs on the host OS (Windows/macOS/Linux CI
      // runners), never as an actual iOS process, so this exercises the
      // real "not iOS" branch rather than a mock.
      final events = await IosFoldPostureChannel().watch().toList();

      expect(events, isEmpty);
    });

    test('the returned stream completes without emitting DevicePosture', () {
      expect(IosFoldPostureChannel().watch(), emitsDone);
    });
  });

  test('DevicePosture has the three documented values', () {
    expect(DevicePosture.values, [
      DevicePosture.flat,
      DevicePosture.halfOpened,
      DevicePosture.unknown,
    ]);
  });
}
