/// A layout breakpoint derived from the current window width.
///
/// Matches the compact/medium/expanded thresholds used across the app's
/// adaptive layouts.
enum ScreenBreakpoint {
  /// Width below 600, e.g. a folded phone or a single-pane phone screen.
  compact,

  /// Width between 600 and 840, e.g. an unfolded phone or a small tablet.
  medium,

  /// Width of 840 or above, e.g. an unfolded tablet or a foldable in
  /// landscape.
  expanded;

  /// Classifies [width] into the matching [ScreenBreakpoint].
  static ScreenBreakpoint fromWidth(double width) {
    if (width < 600) return ScreenBreakpoint.compact;
    if (width < 840) return ScreenBreakpoint.medium;
    return ScreenBreakpoint.expanded;
  }
}
