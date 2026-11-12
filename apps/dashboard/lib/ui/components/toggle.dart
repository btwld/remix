import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'toggle.g.dart';

/// The sizes a toggle comes in. Pixel values are at 100% theme scaling.
enum UiToggleSize {
  /// 24px tall, with 12px text.
  size1,

  /// 32px tall, with 14px text. The default.
  size2,

  /// 40px tall, with 16px text.
  size3,
}

/// The looks a toggle comes in.
enum UiToggleVariant {
  /// No fill or frame until hovered; an accent tint when on.
  ghost,

  /// A 1px gray frame; an accent tint and frame when on.
  outline,
}

/// The Ui Toggle recipe.
///
/// It reads top to bottom: what every toggle shares, then the size, then the
/// variant's colors for rest, hover, press, on, focus and disabled.
///
/// [highContrast] moves the label and icon of the on state to accent step 12.
@MixWidget(target: RemixToggle.new)
ToggleStyler uiToggleStyle({
  UiToggleVariant variant = .ghost,
  UiToggleSize size = .size2,
  bool highContrast = false,
  ToggleStyler style = const ToggleStyler.create(),
}) => _base()
    .merge(_scale(size))
    .merge(switch (variant) {
      .ghost => _ghost(highContrast),
      .outline => _outline(highContrast),
    })
    .wrap(uiTouchTarget())
    .onDisabled(.containerEffects(.outline(.style(.none))))
    .merge(style);

/// What every toggle shares: a medium-weight label and icon in gray 12.
ToggleStyler _base() => ToggleStyler()
    .container(.mainAxisSize(.min))
    .labelColor(UiTokens.gray12())
    .iconColor(UiTokens.gray12())
    .labelFontWeight(UiTokens.fontWeightMedium());

/// The height, padding, corner, text and icon size of each step.
///
/// The heights are the Button height scale, with content centered in it.
ToggleStyler _scale(UiToggleSize size) => switch (size) {
  .size1 => ToggleStyler(
    container: FlexBoxStyler()
        .padding(.horizontal(UiTokens.space2()))
        .borderRadius(.all(UiTokens.radius2()))
        .spacing(UiTokens.space1()),
    label: .style(UiTokens.text1.mix()),
    icon: .size(UiTokens.space3()),
  ).minHeight(UiTokens.space5()),
  .size2 => ToggleStyler(
    container: FlexBoxStyler()
        .padding(.horizontal(UiTokens.space3()))
        .borderRadius(.all(UiTokens.radius2()))
        .spacing(UiTokens.space1()),
    label: .style(UiTokens.text2.mix()),
    icon: .size(UiTokens.space4()),
  ).minHeight(UiTokens.space6()),
  .size3 => ToggleStyler(
    container: FlexBoxStyler()
        .padding(.horizontal(UiTokens.space4()))
        .borderRadius(.all(UiTokens.radius3()))
        .spacing(UiTokens.space2()),
    label: .style(UiTokens.text3.mix()),
    icon: .size(UiTokens.spinnerSize3()),
  ).minHeight(UiTokens.space7()),
};

ToggleStyler _ghost(bool highContrast) => ToggleStyler()
    .color(const Color(0x00000000))
    .onHovered(.color(UiTokens.grayA3()))
    .onPressed(.color(UiTokens.grayA4()))
    .onSelected(
      ToggleStyler()
          .color(UiTokens.accent3())
          .merge(_onContent(highContrast))
          .onHovered(.color(UiTokens.accent4()))
          .onPressed(.color(UiTokens.accent5())),
    )
    .onFocusVisible(.containerEffects(uiFocusOutline()))
    .onDisabled(_disabled());

ToggleStyler _outline(bool highContrast) => ToggleStyler()
    .color(const Color(0x00000000))
    .border(
      .color(UiTokens.gray7())
          .width(UiTokens.borderWidth1())
          .strokeAlign(BorderSide.strokeAlignInside),
    )
    .onHovered(.color(UiTokens.grayA3()))
    .onPressed(.color(UiTokens.grayA4()))
    .onSelected(
      ToggleStyler()
          .color(UiTokens.accentA3())
          .merge(_onContent(highContrast))
          .border(.color(UiTokens.accentA5()))
          .onHovered(.color(UiTokens.accentA4()))
          .onPressed(.color(UiTokens.accentA5())),
    )
    .onFocusVisible(.containerEffects(uiFocusOutline()))
    .onDisabled(
      _disabled().border(
        .color(UiTokens.grayA6())
            .width(UiTokens.borderWidth1())
            .strokeAlign(BorderSide.strokeAlignInside),
      ),
    );

/// The accent label and icon of the on state.
ToggleStyler _onContent(bool highContrast) {
  final color = highContrast ? UiTokens.accent12() : UiTokens.accentContent();

  return ToggleStyler().labelColor(color).iconColor(color);
}

/// A gray fill, label and icon.
ToggleStyler _disabled() => ToggleStyler()
    .color(UiTokens.grayA3())
    .labelColor(UiTokens.gray8())
    .iconColor(UiTokens.gray8());
