import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fold_pokedex/ui/core/diagnostics/ios_fold_posture_channel.dart';
import 'package:fold_pokedex/ui/core/diagnostics/screen_diagnostics_logger.dart';
import 'package:integration_test/integration_test.dart';

class _DiagnosedScreen extends StatefulWidget {
  const new();

  @override
  State<_DiagnosedScreen> createState() => _DiagnosedScreenState();
}

class _DiagnosedScreenState extends State<_DiagnosedScreen>
    with ScreenDiagnosticsLogger<_DiagnosedScreen> {
  @override
  Widget build(BuildContext context) => const SizedBox();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Unlike the widget tests in test/, this runs against a real platform
  // channel implementation on a real device/simulator, which is the only way
  // to exercise `IosFoldPostureChannel` end to end. It has not been run
  // against a real iOS device — there is no Mac/Xcode in this workspace — so
  // treat it as a starting point to verify once one is available. On Android
  // it should already pass today, since `watch()` is a documented no-op
  // there.
  testWidgets(
    'ScreenDiagnosticsLogger does not crash when mixed into a real screen',
    (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: _DiagnosedScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('IosFoldPostureChannel.watch does not throw on this platform', (
    tester,
  ) async {
    final subscription = IosFoldPostureChannel().watch().listen((_) {});
    await tester.pump(const Duration(milliseconds: 500));
    await subscription.cancel();

    expect(tester.takeException(), isNull);
  });
}
