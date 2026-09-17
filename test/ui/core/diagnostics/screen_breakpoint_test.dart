import 'package:flutter_test/flutter_test.dart';
import 'package:fold_pokedex/ui/core/diagnostics/screen_breakpoint.dart';

void main() {
  group('ScreenBreakpoint.fromWidth', () {
    test('classifies widths below 600 as compact', () {
      expect(ScreenBreakpoint.fromWidth(0), ScreenBreakpoint.compact);
      expect(ScreenBreakpoint.fromWidth(599.9), ScreenBreakpoint.compact);
    });

    test('classifies widths between 600 and 840 as medium', () {
      expect(ScreenBreakpoint.fromWidth(600), ScreenBreakpoint.medium);
      expect(ScreenBreakpoint.fromWidth(839.9), ScreenBreakpoint.medium);
    });

    test('classifies widths of 840 and above as expanded', () {
      expect(ScreenBreakpoint.fromWidth(840), ScreenBreakpoint.expanded);
      expect(ScreenBreakpoint.fromWidth(2000), ScreenBreakpoint.expanded);
    });
  });
}
