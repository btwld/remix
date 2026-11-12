import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'toggle.g.dart';

/// The sizes a toggle comes in. Pixel values are at 100% theme scaling.
enum FortalToggleSize {
  /// 24px tall, with 12px text.
  size1,

  /// 32px tall, with 14px text. The default.
  size2,

  /// 40px tall, with 16px text.
  size3,
}

/// The looks a toggle comes in.
enum FortalToggleVariant {
  /// No fill or frame until hovered; an accent tint when on.
  ghost,

  /// A 1px gray frame; an accent tint and frame when on.
  outline,
}

/// The Fortal Toggle recipe.
///
/// It reads top to bottom: what every toggle shares, then the size, then the
/// variant's colors for rest, hover, press, on, focus and disabled.
///
/// [highContrast] moves the label and icon of the on state to accent step 12.
@MixWidget(target: RemixToggle.new)
ToggleStyler fortalToggleStyle({
  FortalToggleVariant variant = .ghost,
  FortalToggleSize size = .size2,
  bool highContrast = false,
  ToggleStyler style = const ToggleStyler.create(),
}) => _base()
    .merge(_scale(size))
    .merge(switch (variant) {
      .ghost => _ghost(highContrast),
      .outline => _outline(highContrast),
    })
    .wrap(fortalTouchTarget())
    .onDisabled(.containerEffects(.outline(.style(.none))))
    .merge(style);

/// What every toggle shares: a medium-weight label and icon in gray 12.
ToggleStyler _base() => ToggleStyler()
    .container(.mainAxisSize(.min))
    .labelColor(FortalTokens.gray12())
    .iconColor(FortalTokens.gray12())
    .labelFontWeight(FortalTokens.fontWeightMedium());

/// The height, padding, corner, text and icon size of each step.
///
/// The heights are the Button height scale, with content centered in it.
ToggleStyler _scale(FortalToggleSize size) => switch (size) {
  .size1 => ToggleStyler(
    container: FlexBoxStyler()
        .padding(.horizontal(FortalTokens.space2()))
        .borderRadius(.all(FortalTokens.radius2()))
        .spacing(FortalTokens.space1()),
    label: .style(FortalTokens.text1.mix()),
    icon: .size(FortalTokens.space3()),
  ).minHeight(FortalTokens.space5()),
  .size2 => ToggleStyler(
    container: FlexBoxStyler()
        .padding(.horizontal(FortalTokens.space3()))
        .borderRadius(.all(FortalTokens.radius2()))
        .spacing(FortalTokens.space1()),
    label: .style(FortalTokens.text2.mix()),
    icon: .size(FortalTokens.space4()),
  ).minHeight(FortalTokens.space6()),
  .size3 => ToggleStyler(
    container: FlexBoxStyler()
        .padding(.horizontal(FortalTokens.space4()))
        .borderRadius(.all(FortalTokens.radius3()))
        .spacing(FortalTokens.space2()),
    label: .style(FortalTokens.text3.mix()),
    icon: .size(FortalTokens.spinnerSize3()),
  ).minHeight(FortalTokens.space7()),
};

ToggleStyler _ghost(bool highContrast) => ToggleStyler()
    .color(const Color(0x00000000))
    .onHovered(.color(FortalTokens.grayA3()))
    .onPressed(.color(FortalTokens.grayA4()))
    .onSelected(
      ToggleStyler()
          .color(FortalTokens.accent3())
          .merge(_onContent(highContrast))
          .onHovered(.color(FortalTokens.accent4()))
          .onPressed(.color(FortalTokens.accent5())),
    )
    .onFocusVisible(.containerEffects(fortalFocusOutline()))
    .onDisabled(_disabled());

ToggleStyler _outline(bool highContrast) => ToggleStyler()
    .color(const Color(0x00000000))
    .border(
      .color(FortalTokens.gray7())
          .width(FortalTokens.borderWidth1())
          .strokeAlign(BorderSide.strokeAlignInside),
    )
    .onHovered(.color(FortalTokens.grayA3()))
    .onPressed(.color(FortalTokens.grayA4()))
    .onSelected(
      ToggleStyler()
          .color(FortalTokens.accentA3())
          .merge(_onContent(highContrast))
          .border(.color(FortalTokens.accentA5()))
          .onHovered(.color(FortalTokens.accentA4()))
          .onPressed(.color(FortalTokens.accentA5())),
    )
    .onFocusVisible(.containerEffects(fortalFocusOutline()))
    .onDisabled(
      _disabled().border(
        .color(FortalTokens.grayA6())
            .width(FortalTokens.borderWidth1())
            .strokeAlign(BorderSide.strokeAlignInside),
      ),
    );

/// The accent label and icon of the on state.
ToggleStyler _onContent(bool highContrast) {
  final color = highContrast
      ? FortalTokens.accent12()
      : FortalTokens.accentContent();

  return ToggleStyler().labelColor(color).iconColor(color);
}

/// A gray fill, label and icon.
ToggleStyler _disabled() => ToggleStyler()
    .color(FortalTokens.grayA3())
    .labelColor(FortalTokens.gray8())
    .iconColor(FortalTokens.gray8());
