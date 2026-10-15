import 'package:remix/remix.dart';

import 'dashboard_demo_ui.dart';

/// How much attention a run of text asks for.
///
/// Ui ships the type scale, the weights, and the gray steps, but no opinion
/// about which step carries content, so the example settles that once here.
/// Three tiers is what the dashboard actually needs: an activity row puts all
/// of them side by side.
enum TextTone {
  /// `gray-12` — text the eye lands on.
  strong(UiTokens.gray12),

  /// `gray-11` — supporting copy next to [strong].
  muted(UiTokens.gray11),

  /// `gray-10` — metadata that should recede even beside [muted].
  subtle(UiTokens.gray10);

  const TextTone(this._color);
  final ColorToken _color;
}

/// Dashboard body text at a Ui [size].
///
/// This starts from `uiTextStyle()` so the scale, weights, and flow
/// behaviour stay the preset's; the only thing layered on top is the neutral
/// tone, which is the one opinion the preset does not ship. Text that wants
/// [strong] and nothing else should use [UiText] directly rather than this
/// helper.
///
/// Callers that need more than a weight or tone change chain onto the result
/// rather than reintroducing an inline `TextStyler`.
TextStyler dashboardText(
  UiTextSize size, {
  UiTextWeight? weight,
  TextTone tone = TextTone.strong,
}) => uiTextStyle(size: size, weight: weight).color(tone._color());

/// Single-line [dashboardText] that ellipsizes, for text sharing a row with a
/// fixed-width neighbour.
TextStyler dashboardTextLine(
  UiTextSize size, {
  UiTextWeight? weight,
  TextTone tone = TextTone.strong,
}) => uiTextStyle(
  size: size,
  weight: weight,
  truncate: true,
).color(tone._color());
