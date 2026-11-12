import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'callout.g.dart';

/// The sizes a callout comes in. Pixel values are at 100% theme scaling.
enum FortalCalloutSize {
  /// 14px text with 12px padding and an 8px gap.
  size1,

  /// 14px text with 16px padding and a 12px gap. The default.
  size2,

  /// 16px text with 24px padding and a 16px gap.
  size3,
}

/// The looks a callout comes in.
enum FortalCalloutVariant {
  /// A tinted accent fill.
  soft,

  /// A faint accent fill inside a 1px accent frame.
  surface,

  /// No fill inside a 1px accent frame.
  outline,
}

/// The Fortal Callout recipe.
///
/// It reads top to bottom: the size, the color the icon and text share, then
/// the variant's fill and frame.
///
/// [highContrast] moves the text and icon to accent step 12.
@MixWidget(target: RemixCallout.new)
CalloutStyler fortalCalloutStyle({
  FortalCalloutVariant variant = .soft,
  FortalCalloutSize size = .size2,
  bool highContrast = false,
  CalloutStyler style = const CalloutStyler.create(),
}) => _scale(size)
    .merge(_content(highContrast))
    .merge(switch (variant) {
      .soft => CalloutStyler().color(FortalTokens.accentA3()),
      .surface => _surface(),
      .outline => _outline(),
    })
    .merge(style);

/// The text, icon, padding, gap and corner size of each step.
CalloutStyler _scale(FortalCalloutSize size) {
  final (:padding, :gap, :text, :icon, :radius) = switch (size) {
    .size1 => (
      padding: FortalTokens.space3(),
      gap: FortalTokens.space2(),
      text: FortalTokens.text2,
      icon: FortalTokens.space4(),
      radius: FortalTokens.radius3(),
    ),
    .size2 => (
      padding: FortalTokens.space4(),
      gap: FortalTokens.space3(),
      text: FortalTokens.text2,
      icon: FortalTokens.space4(),
      radius: FortalTokens.radius4(),
    ),
    .size3 => (
      padding: FortalTokens.space5(),
      gap: FortalTokens.space4(),
      text: FortalTokens.text3,
      icon: FortalTokens.spinnerSize3(),
      radius: FortalTokens.radius5(),
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
      ? FortalTokens.accent12()
      : FortalTokens.accentContentAlpha();

  return CalloutStyler().iconColor(color).textColor(color);
}

CalloutStyler _surface() => CalloutStyler()
    .color(FortalTokens.accentA2())
    .containerEffects(
      .behindContent(fortalInsetSurface(strokes: [FortalTokens.accentA6()])),
    );

CalloutStyler _outline() => CalloutStyler().containerEffects(
  .behindContent(fortalInsetSurface(strokes: [FortalTokens.accentA7()])),
);
