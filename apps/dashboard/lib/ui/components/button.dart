import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'base_button.dart';

part 'button.g.dart';

/// The sizes a button comes in.
///
/// Type, icon and corner sizes step with the height. Pixel values are at 100%
/// theme scaling. A ghost button has no minimum height: it is as tall as its
/// text and padding.
enum UiButtonSize {
  /// 24px tall, with 12px text.
  size1,

  /// 32px tall, with 14px text. The default.
  size2,

  /// 40px tall, with 16px text.
  size3,

  /// 48px tall, with 18px text.
  size4,
}

/// The visual weights a button comes in, from most to least emphasis.
enum UiButtonVariant {
  /// The accent's solid fill under its contrast label.
  solid,

  /// A tinted accent fill under accent text.
  soft,

  /// A faint accent surface inside a 1px accent frame.
  surface,

  /// No fill inside a 1px accent frame.
  outline,

  /// Accent text alone, with a tint under the pointer.
  ghost,
}

/// The Ui Button recipe.
///
/// It reads top to bottom: what every button shares, then the size, then the
/// variant's colors for each state, then focus and disabled. [style] merges
/// last, so a call site can override any part of it.
///
/// [highContrast] strengthens a variant: the solid fill, and the text of every
/// other variant, move to accent step 12.
///
/// An icon takes the size's icon size rather than the ambient `IconTheme`. An
/// icon size in [style] overrides it.
@MixWidget(target: RemixButton.new)
ButtonStyler uiButtonStyle({
  UiButtonVariant variant = .solid,
  UiButtonSize size = .size2,
  bool highContrast = false,
  ButtonStyler style = const ButtonStyler.create(),
}) {
  return _base()
      .merge(_scale(size))
      .merge(variant == .ghost ? _ghostLayout(size) : _controlLayout(size))
      .merge(switch (variant) {
        .solid => _solid(highContrast),
        .soft => _soft(highContrast),
        .surface => _surface(highContrast),
        .outline => _outline(highContrast),
        .ghost => _ghost(highContrast),
      })
      // Hover and press arrive quickly. These merge into the variant's own
      // hover and press fragments, which set the colors.
      .onHovered(ButtonStyler().animate(_activeMotion))
      .onPressed(ButtonStyler().animate(_activeMotion))
      .onFocusVisible(.containerEffects(uiFocusOutline()))
      // A disabled button never rings: this switches the outline off,
      // whatever color and width the focus fragment gives it.
      .onDisabled(.containerEffects(.outline(.style(.none))))
      .wrap(uiTouchTarget())
      .merge(style);
}

/// How fast hover and press arrive.
final _activeMotion = AnimationConfig.ease(const Duration(milliseconds: 40));

/// How fast every other change settles: the return to rest, focus, disabled.
final _restMotion = AnimationConfig.ease(const Duration(milliseconds: 120));

/// The loading spinner sits back from the label it replaces.
const _spinnerOpacity = 0.65;

/// One full spinner revolution.
const _spinnerRevolution = Duration(milliseconds: 800);

/// A fill that paints nothing.
const _transparent = Color(0x00000000);

/// What every button shares, whatever its size or variant.
ButtonStyler _base() => ButtonStyler()
    .animate(_restMotion)
    .direction(.horizontal)
    .mainAxisSize(.min)
    .spinner(
      SpinnerStyler()
          .opacity(_spinnerOpacity)
          .leafRadius(UiTokens.radius1())
          .duration(_spinnerRevolution),
    );

/// The text, icon, spinner and corner sizes of each step.
///
/// The corners turn into a pill when the theme radius is `full`.
ButtonStyler _scale(UiButtonSize size) => switch (size) {
  .size1 =>
    ButtonStyler()
        .label(.style(UiTokens.text1.mix()))
        .icon(.size(UiTokens.space3()))
        .spinner(.size(UiTokens.space3()))
        .borderRadius(.all(UiTokens.radius1OrFull())),
  .size2 =>
    ButtonStyler()
        .label(.style(UiTokens.text2.mix()))
        .icon(.size(UiTokens.space4()))
        .spinner(.size(UiTokens.space4()))
        .borderRadius(.all(UiTokens.radius2OrFull())),
  // `spinnerSize3` is the 20px step the spacing scale has no name for.
  .size3 =>
    ButtonStyler()
        .label(.style(UiTokens.text3.mix()))
        .icon(.size(UiTokens.spinnerSize3()))
        .spinner(.size(UiTokens.space4()))
        .borderRadius(.all(UiTokens.radius3OrFull())),
  .size4 =>
    ButtonStyler()
        .label(.style(UiTokens.text4.mix()))
        .icon(.size(UiTokens.space5()))
        .spinner(.size(UiTokens.spinnerSize3()))
        .borderRadius(.all(UiTokens.radius4OrFull())),
};

/// The box of a solid, soft, surface or outline button: a minimum height,
/// padding on the sides only, a medium label and slightly quieter icons.
ButtonStyler _controlLayout(UiButtonSize size) {
  final box = switch (size) {
    .size1 =>
      ButtonStyler()
          .minHeight(UiTokens.space5())
          .padding(.horizontal(UiTokens.space2()))
          .spacing(UiTokens.space1()),
    .size2 =>
      ButtonStyler()
          .minHeight(UiTokens.space6())
          .padding(.horizontal(UiTokens.space3()))
          .spacing(UiTokens.space2()),
    .size3 =>
      ButtonStyler()
          .minHeight(UiTokens.space7())
          .padding(.horizontal(UiTokens.space4()))
          .spacing(UiTokens.space3()),
    .size4 =>
      ButtonStyler()
          .minHeight(UiTokens.space8())
          .padding(.horizontal(UiTokens.space5()))
          .spacing(UiTokens.space3()),
  };

  return box
      .label(.fontWeight(UiTokens.fontWeightMedium()))
      .icon(.opacity(0.9));
}

/// The box of a ghost button, which sits in a line of content like text.
///
/// It has no minimum height and a regular-weight label. Its padding gives the
/// hover tint room, and a negative margin of the same size cancels that
/// padding in layout, so the label lines up with the content around it.
ButtonStyler _ghostLayout(UiButtonSize size) {
  final box = switch (size) {
    .size1 || .size2 =>
      ButtonStyler()
          .padding(
            .symmetric(
              horizontal: UiTokens.space2(),
              vertical: UiTokens.space1(),
            ),
          )
          .margin(
            .symmetric(
              horizontal: UiTokens.baseButtonGhostMarginX12(),
              vertical: UiTokens.baseButtonGhostMarginY12(),
            ),
          )
          .spacing(UiTokens.space1()),
    .size3 =>
      ButtonStyler()
          .padding(
            .symmetric(
              horizontal: UiTokens.space3(),
              vertical: UiTokens.space2(),
            ),
          )
          .margin(
            .symmetric(
              horizontal: UiTokens.baseButtonGhostMarginX3(),
              vertical: UiTokens.baseButtonGhostMarginY3(),
            ),
          )
          .spacing(UiTokens.space2()),
    .size4 =>
      ButtonStyler()
          .padding(
            .symmetric(
              horizontal: UiTokens.space4(),
              vertical: UiTokens.space2(),
            ),
          )
          .margin(
            .symmetric(
              horizontal: UiTokens.baseButtonGhostMarginX4(),
              vertical: UiTokens.baseButtonGhostMarginY4(),
            ),
          )
          .spacing(UiTokens.space2()),
  };

  return box.label(.fontWeight(UiTokens.fontWeightRegular()));
}

/// Solid: the accent's labelled fill, or its strongest step at high contrast.
///
/// Hover and press recolor the fill and nothing else, so the label, icons,
/// spinner and focus ring keep their colors.
ButtonStyler _solid(bool highContrast) => highContrast
    ? _content(UiTokens.gray1())
          .color(UiTokens.accent12())
          .onHovered(.color(uiHighContrastHoverFill()))
          .onPressed(.color(uiHighContrastPressedFill()))
          .onDisabled(_solidDisabled())
    : _content(UiTokens.accentContrast())
          .color(UiTokens.accentSolid())
          .onHovered(.color(UiTokens.accentSolidHover()))
          .onPressed(.color(uiSolidPressedFill()))
          .onDisabled(_solidDisabled());

/// A disabled solid button, which also drops any filter the caller added.
ButtonStyler _solidDisabled() =>
    _disabledContent().color(UiTokens.grayA3()).wrap(uiClearFilter());

/// Soft: a tinted accent fill that deepens a step on hover and on press.
ButtonStyler _soft(bool highContrast) => _content(_accentText(highContrast))
    .color(UiTokens.accentA3())
    .onHovered(.color(UiTokens.accentA4()))
    .onPressed(.color(UiTokens.accentA5()))
    .onDisabled(_disabledContent().color(UiTokens.grayA3()));

/// Surface: a faint accent surface inside a frame that strengthens on hover.
ButtonStyler _surface(bool highContrast) => _content(_accentText(highContrast))
    .color(UiTokens.accentSurface())
    .containerEffects(_frame([UiTokens.accentA7()]))
    .onHovered(.containerEffects(_frame([UiTokens.accentA8()])))
    .onPressed(
      ButtonStyler()
          .color(UiTokens.accentA3())
          .containerEffects(_frame([UiTokens.accentA8()])),
    )
    .onDisabled(
      _disabledContent()
          .color(UiTokens.grayA2())
          .containerEffects(_frame([UiTokens.grayA6()])),
    );

/// Outline: a frame with no fill, tinted on hover and on press.
///
/// High contrast adds a gray line to the accent one.
ButtonStyler _outline(bool highContrast) => _content(_accentText(highContrast))
    .containerEffects(
      _frame(
        highContrast
            ? [UiTokens.accentA7(), UiTokens.grayA11()]
            : [UiTokens.accentA8()],
      ),
    )
    .onHovered(.color(UiTokens.accentA2()))
    .onPressed(.color(UiTokens.accentA3()))
    .onDisabled(
      _disabledContent()
          .color(_transparent)
          .containerEffects(_frame([UiTokens.grayA7()])),
    );

/// Ghost: accent text alone, with a tint under the pointer.
ButtonStyler _ghost(bool highContrast) => _content(_accentText(highContrast))
    .color(_transparent)
    .onHovered(.color(UiTokens.accentA3()))
    .onPressed(.color(UiTokens.accentA4()))
    .onDisabled(_disabledContent().color(_transparent));

/// One color for the label, the icons and the spinner.
ButtonStyler _content(Color color) => ButtonStyler()
    .label(.color(color))
    .icon(.color(color))
    .spinner(.color(color));

/// The text color of the soft, surface, outline and ghost variants.
Color _accentText(bool highContrast) =>
    highContrast ? UiTokens.accent12() : UiTokens.accentContentAlpha();

/// Disabled content: gray, with the spinner at full strength rather than its
/// usual 65%.
ButtonStyler _disabledContent() =>
    _content(UiTokens.grayA8()).spinner(.opacity(1));

/// A crisp 1px line just inside the button's edge, one for each of [colors].
RemixBoxEffectsMix _frame(List<Color> colors) =>
    .behindContent(uiInsetSurface(strokes: colors));
