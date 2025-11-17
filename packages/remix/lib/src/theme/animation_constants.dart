/// Animation duration constants for Remix components.
///
/// This centralizes animation timing values to ensure consistency across
/// the design system and make it easier to adjust timings globally.
class RemixAnimationDurations {
  const RemixAnimationDurations._();

  /// Fast animation duration (150ms)
  ///
  /// Used for quick transitions like dropdown animations.
  static const fast = Duration(milliseconds: 150);

  /// Normal animation duration (200ms)
  ///
  /// Used for standard UI transitions like accordion expansion and slider thumbs.
  static const normal = Duration(milliseconds: 200);

  /// Tooltip wait duration (300ms)
  ///
  /// Time before a tooltip appears on hover.
  static const tooltipWait = Duration(milliseconds: 300);

  /// Moderate animation duration (400ms)
  ///
  /// Used for dialog transitions.
  static const moderate = Duration(milliseconds: 400);

  /// Slow animation duration (800ms)
  ///
  /// Used for spinner rotations in buttons and icon buttons.
  static const slow = Duration(milliseconds: 800);

  /// Spinner default duration (1000ms)
  ///
  /// Default duration for standalone spinner component rotation.
  static const spinner = Duration(milliseconds: 1000);

  /// Tooltip show duration (1500ms)
  ///
  /// How long a tooltip remains visible.
  static const tooltipShow = Duration(milliseconds: 1500);
}
