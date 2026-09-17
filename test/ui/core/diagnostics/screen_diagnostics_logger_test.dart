import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fold_pokedex/ui/core/diagnostics/screen_diagnostics_logger.dart';

class _DiagnosedScreen extends StatefulWidget {
  const _DiagnosedScreen({super.key});

  @override
  State<_DiagnosedScreen> createState() => _DiagnosedScreenState();
}

class _DiagnosedScreenState extends State<_DiagnosedScreen>
    with ScreenDiagnosticsLogger<_DiagnosedScreen> {
  final messages = <String>[];

  @override
  void logDiagnostic(String message) => messages.add(message);

  @override
  Widget build(BuildContext context) => const SizedBox();
}

Future<_DiagnosedScreenState> _pumpDiagnosedScreen(
  WidgetTester tester,
  Size size, {
  GlobalKey<_DiagnosedScreenState>? key,
}) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  final screenKey = key ?? GlobalKey<_DiagnosedScreenState>();
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(size: size),
      child: _DiagnosedScreen(key: screenKey),
    ),
  );
  return screenKey.currentState!;
}

void main() {
  testWidgets('logs an initial description on first build', (tester) async {
    final state = await _pumpDiagnosedScreen(tester, const Size(400, 800));

    expect(state.messages, hasLength(1));
    expect(state.messages.single, contains('breakpoint: compact'));
  });

  testWidgets('logs a diff when the window is resized', (tester) async {
    final key = GlobalKey<_DiagnosedScreenState>();
    final state = await _pumpDiagnosedScreen(
      tester,
      const Size(400, 800),
      key: key,
    );

    await _pumpDiagnosedScreen(tester, const Size(1350, 841), key: key);

    expect(state.messages, hasLength(2));
    expect(state.messages.last, contains('breakpoint: compact -> expanded'));
  });

  testWidgets('does not log again when nothing changed', (tester) async {
    final state = await _pumpDiagnosedScreen(tester, const Size(400, 800));
    await tester.pump();
    await tester.pump();

    expect(state.messages, hasLength(1));
  });
}
