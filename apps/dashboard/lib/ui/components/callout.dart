import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'callout.g.dart';

/// The sizes a callout comes in. Pixel values are at 100% theme scaling.
enum UiCalloutSize {
  /// 14px text with 12px padding and an 8px gap.
  size1,

  /// 14px text with 16px padding and a 12px gap. The default.
  size2,

  /// 16px text with 24px padding and a 16px gap.
  size3,
}

/// The looks a callout comes in.
enum UiCalloutVariant {
  /// A tinted accent fill.
  soft,

  /// A faint accent fill inside a 1px accent frame.
  surface,

  /// No fill inside a 1px accent frame.
  outline,
}

/// The Ui Callout recipe.
///
/// It reads top to bottom: the size, the color the icon and text share, then
/// the variant's fill and frame.
///
/// [highContrast] moves the text and icon to accent step 12.
@MixWidget(target: RemixCallout.new)
CalloutStyler uiCalloutStyle({
  UiCalloutVariant variant = .soft,
  UiCalloutSize size = .size2,
  bool highContrast = false,
  CalloutStyler style = const CalloutStyler.create(),
}) => _scale(size)
    .merge(_content(highContrast))
    .merge(switch (variant) {
      .soft => CalloutStyler().color(UiTokens.accentA3()),
      .surface => _surface(),
      .outline => _outline(),
    })
    .merge(style);

/// The text, icon, padding, gap and corner size of each step.
CalloutStyler _scale(UiCalloutSize size) {
  final (:padding, :gap, :text, :icon, :radius) = switch (size) {
    .size1 => (
      padding: UiTokens.space3(),
      gap: UiTokens.space2(),
      text: UiTokens.text2,
      icon: UiTokens.space4(),
      radius: UiTokens.radius3(),
    ),
    .size2 => (
      padding: UiTokens.space4(),
      gap: UiTokens.space3(),
      text: UiTokens.text2,
      icon: UiTokens.space4(),
      radius: UiTokens.radius4(),
    ),
    .size3 => (
      padding: UiTokens.space5(),
      gap: UiTokens.space4(),
      text: UiTokens.text3,
      icon: UiTokens.spinnerSize3(),
      radius: UiTokens.radius5(),
    ),
  };

  return CalloutStyler(
    container: .direction(.horizontal)
        .mainAxisSize(.min)
        .crossAxisAlignment(.start)
        .spacing(gap)
        .padding(EdgeInsetsGeometryMix.all(padding)),
    text: .style(text.mix()),
    icon: .size(icon),
  ).borderRadius(.all(radius));
}

/// The one color the icon and text share.
CalloutStyler _content(bool highContrast) {
  final color = highContrast
      ? UiTokens.accent12()
      : UiTokens.accentContentAlpha();

  return CalloutStyler().iconColor(color).textColor(color);
}

CalloutStyler _surface() => CalloutStyler()
    .color(UiTokens.accentA2())
    .containerEffects(
      .behindContent(uiInsetSurface(strokes: [UiTokens.accentA6()])),
    );

CalloutStyler _outline() => CalloutStyler().containerEffects(
  .behindContent(uiInsetSurface(strokes: [UiTokens.accentA7()])),
);
