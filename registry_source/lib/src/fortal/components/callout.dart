import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../theme/theme.dart';

part 'callout.g.dart';

/// The sizes a callout comes in. Pixel values are at 100% theme scaling.
enum FortalCalloutSize {
  /// A 12px title over 12px text, 12px padding, an 8px gap and a 16px icon.
  size1,

  /// A 13px title over 12px text, 16px padding, a 12px gap and an 18px icon.
  /// The default.
  size2,

  /// A 15px title over 13px text, 20px padding, a 12px gap and a 20px icon.
  size3,
}

/// The looks a callout comes in.
enum FortalCalloutVariant {
  /// A tinted accent fill.
  soft,

  /// A resting card: the surface fill in a 1px border with a soft shadow.
  /// The default.
  surface,

  /// No fill inside a 1px strong border.
  outline,
}

/// What a callout is about. It picks the icon's color and its default glyph.
///
/// Visual only: it adds no live-region announcement.
enum FortalCalloutIntent {
  /// The accent's text color and an info glyph.
  accent,

  /// The info color and an info glyph. The default.
  info,

  /// The success color and a check glyph.
  success,

  /// The warning color and a warning glyph.
  warning,

  /// The error color and a crossed circle glyph.
  error,
}

bool _themeHighContrast(BuildContext context) =>
    FortalTheme.maybeOf(context)?.highContrast ?? false;

/// Picks [contrast] when the recipe flag or the theme asks for high contrast.
ContextToken<Color> _lift(
  bool highContrast,
  MixToken<Color> rest,
  MixToken<Color> contrast,
) => ContextToken<Color>(
  (context) => highContrast || _themeHighContrast(context)
      ? contrast.resolve(context)
      : rest.resolve(context),
);

/// The Fortal Callout recipe.
///
/// The default is a resting card: a 13px medium title over 12px secondary
/// text, with only the icon tinted by [intent]. It reads top to bottom: the
/// size, the intent's icon, the text colors, then the variant's fill and frame.
///
/// [highContrast], or the theme's high contrast, moves the icon and text to
/// the foreground and the frames to gray 10, which holds 3:1 on the card.
@MixWidget(target: RemixCallout.new)
CalloutStyler fortalCalloutStyle({
  FortalCalloutVariant variant = .surface,
  FortalCalloutSize size = .size2,
  FortalCalloutIntent intent = .info,
  bool highContrast = false,
  CalloutStyler style = const CalloutStyler.create(),
}) => _scale(size)
    .merge(_intent(intent, highContrast))
    .merge(_text(highContrast))
    .merge(switch (variant) {
      .soft => CalloutStyler().color(FortalTokens.accentA3()),
      .surface => _surface(highContrast),
      .outline => _outline(highContrast),
    })
    .merge(style);

/// The padding, gap, corner, icon and type of each step. Every variant keeps
/// a 1px frame, drawn or transparent, so content sits at the same inset.
CalloutStyler _scale(FortalCalloutSize size) {
  final (:padding, :gap, :icon, :title, :text, :radius) = switch (size) {
    .size1 => (
      padding: FortalTokens.space3(),
      gap: FortalTokens.space2(),
      icon: FortalTokens.space4(),
      title: FortalTokens.text1,
      text: FortalTokens.text1,
      radius: FortalTokens.radius3(),
    ),
    .size2 => (
      padding: FortalTokens.space4(),
      gap: FortalTokens.space3(),
      icon: FortalTokens.space18(),
      title: FortalTokens.text2,
      text: FortalTokens.text1,
      radius: FortalTokens.radius4(),
    ),
    .size3 => (
      padding: FortalTokens.space20(),
      gap: FortalTokens.space3(),
      icon: FortalTokens.space20(),
      title: FortalTokens.text3,
      text: FortalTokens.text2,
      radius: FortalTokens.radius5(),
    ),
  };

  return CalloutStyler(
        container: .direction(.horizontal)
            .mainAxisSize(.min)
            .crossAxisAlignment(.start)
            .spacing(gap)
            .padding(EdgeInsetsGeometryMix.all(padding)),
        title: TextStyler()
            .style(title.mix())
            .fontWeight(FortalTokens.fontWeightMedium()),
        text: .style(text.mix()),
        content: .spacing(FortalTokens.space1()),
        // The glyph sits 1px low so it centers on the title's first line.
        icon: IconStyler()
            .size(icon)
            .wrap(.padding(EdgeInsetsGeometryMix.only(top: 1))),
        closeButton: _closeButton(),
      )
      .border(
        .color(const Color(0x00000000)).width(FortalTokens.borderWidth1()),
      )
      .borderRadius(.all(radius));
}

CalloutStyler _intent(FortalCalloutIntent intent, bool highContrast) {
  final (color, glyph) = switch (intent) {
    .accent => (FortalTokens.accentContentAlpha, RemixIcons.info),
    .info => (FortalTokens.info, RemixIcons.info),
    .success => (FortalTokens.success, RemixIcons.check),
    .warning => (FortalTokens.warning, RemixIcons.warning),
    .error => (FortalTokens.error11, RemixIcons.closeCircle),
  };

  return CalloutStyler(
    icon: IconStyler()
        .icon(glyph)
        .color(_lift(highContrast, color, FortalTokens.gray12)()),
  );
}

/// The title takes the foreground; the text below it the secondary gray.
CalloutStyler _text(bool highContrast) => CalloutStyler(
  title: .color(FortalTokens.gray12()),
  text: .color(_lift(highContrast, FortalTokens.gray11, FortalTokens.gray12)()),
);

CalloutStyler _surface(bool highContrast) => CalloutStyler()
    .color(FortalTokens.colorSurface())
    .border(
      .color(_lift(highContrast, FortalTokens.gray7, FortalTokens.gray10)()),
    )
    .decoration(BoxDecorationMix.create(boxShadow: FortalTokens.shadow1.mix()));

CalloutStyler _outline(bool highContrast) => CalloutStyler().border(
  .color(_lift(highContrast, FortalTokens.gray8, FortalTokens.gray10)()),
);

/// A 28px round ghost button pulled 5px up and 6px out, so its glyph centers
/// on the title line and hugs the edge.
IconButtonStyler _closeButton() => IconButtonStyler()
    .size(28, 28)
    .alignment(.center)
    .borderRadius(.all(FortalTokens.radiusCircle()))
    .icon(IconStyler().size(FortalTokens.space4()).color(FortalTokens.gray10()))
    .color(const Color(0x00000000))
    .wrap(.transform(transform: Matrix4.translationValues(6, -5, 0)))
    .onHovered(
      IconButtonStyler()
          .color(FortalTokens.gray3())
          .icon(.color(FortalTokens.gray12())),
    )
    .onPressed(IconButtonStyler().scale(.96))
    .animate(.easeOut(FortalMotion.fast));
