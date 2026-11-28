import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/computed.dart' show mixOklabPremultiplied;
import '../theme/theme.dart';

part 'toggle.g.dart';

/// The sizes a toggle comes in, at the button heights so the two line up in
/// a row. Pixel values are at 100% theme scaling.
enum FortalToggleSize {
  /// 32px tall, with a 12px corner.
  size1,

  /// 40px tall, with a 14px corner. The default.
  size2,

  /// 44px tall, with a 16px corner.
  size3,
}

/// The looks a toggle comes in.
enum FortalToggleVariant {
  /// No fill or frame until hovered; a tinted fill when on.
  ghost,

  /// A 1px border; a tinted fill inside it when on.
  outline,
}

/// The Fortal Toggle recipe.
///
/// It reads top to bottom: what every toggle shares, then the size, then the
/// variant's look for rest, hover, on, focus and disabled. A toggle is drawn
/// like one item of a toggle group: secondary text that turns to ink under the
/// pointer and when on, over the group's tinted on fill.
///
/// [highContrast] draws the resting text in ink and the border in the strong
/// border.
@MixWidget(target: RemixToggle.new)
ToggleStyler fortalToggleStyle({
  FortalToggleVariant variant = .ghost,
  FortalToggleSize size = .size2,
  bool highContrast = false,
  ToggleStyler style = const ToggleStyler.create(),
}) {
  final border = switch (variant) {
    .ghost => _transparent,
    .outline => highContrast ? FortalTokens.gray8() : FortalTokens.gray7(),
  };

  return _base(highContrast)
      .merge(_scale(size))
      .border(
        .color(border)
            .width(FortalTokens.borderWidth1())
            .strokeAlign(BorderSide.strokeAlignInside),
      )
      .onHovered(_content(FortalTokens.gray12()).color(FortalTokens.gray3()))
      .onSelected(
        _content(
          FortalTokens.gray12(),
        ).color(_onFill()).onHovered(.color(_onFill())),
      )
      .onFocusVisible(.containerEffects(fortalFocusOutline()))
      .onDisabled(
        ToggleStyler()
            .wrap(.opacity(_disabledOpacity))
            .containerEffects(.outline(.style(.none))),
      )
      .wrap(fortalTouchTarget())
      .merge(style);
}

/// How much of a disabled toggle shows.
const _disabledOpacity = 0.45;

const _transparent = Color(0x00000000);

/// Every change of fill, border and text color.
final _motion = AnimationConfig.curve(
  duration: FortalMotion.fast,
  curve: FortalMotion.easeStandard,
);

/// The on fill: the accent's indicator mixed into the surface, 11% in light
/// and 14% in dark. Neutral gray under orla, a faint tint under the others.
const _onFillToken = ContextToken<Color>(_resolveOnFill);

Color _onFill() => _onFillToken();

Color _resolveOnFill(BuildContext context) => mixOklabPremultiplied(
  FortalTokens.gray2.resolve(context),
  FortalTokens.accentIndicator.resolve(context),
  FortalTheme.of(context).isDark ? 0.14 : 0.11,
);

/// What every toggle shares: a medium label and 16px icon in secondary text,
/// no fill and an opaque box.
ToggleStyler _base(bool highContrast) =>
    _content(highContrast ? FortalTokens.gray12() : FortalTokens.gray11())
        .animate(_motion)
        .container(.mainAxisSize(.min))
        .color(_transparent)
        .wrap(.opacity(1))
        .labelFontWeight(FortalTokens.fontWeightMedium());

ToggleStyler _content(Color color) =>
    ToggleStyler().labelColor(color).iconColor(color);

/// The height, padding and corner of each step; the label is 13px and the
/// icon 16px at every size.
ToggleStyler _scale(FortalToggleSize size) {
  final (height, inline, corner) = switch (size) {
    .size1 => (
      FortalTokens.controlHeight1(),
      FortalTokens.space3(),
      FortalTokens.radius3(),
    ),
    .size2 => (
      FortalTokens.controlHeight2(),
      FortalTokens.space4(),
      FortalTokens.radius4(),
    ),
    .size3 => (
      FortalTokens.controlHeight3(),
      FortalTokens.space18(),
      FortalTokens.radius5(),
    ),
  };

  return ToggleStyler(
    container: FlexBoxStyler()
        .padding(.horizontal(inline))
        .borderRadius(.all(corner))
        .spacing(FortalTokens.space2()),
    label: .style(FortalTokens.text2.mix()),
    icon: .size(FortalTokens.space4()),
  ).minHeight(height);
}
