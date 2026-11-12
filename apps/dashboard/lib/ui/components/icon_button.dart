import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'base_button.dart';

part 'icon_button.g.dart';

/// The sizes an icon button comes in.
///
/// Square at the heights the labelled button is tall, so the two line up in a
/// row. Pixel values are at 100% theme scaling. A ghost icon button has no
/// fixed square: it is the icon and its padding.
enum UiIconButtonSize {
  /// A 24px square around a 12px icon.
  size1,

  /// A 32px square around a 16px icon. The default.
  size2,

  /// A 40px square around a 20px icon.
  size3,

  /// A 48px square around a 24px icon.
  size4,
}

/// The visual weights an icon button comes in, from most to least emphasis.
///
/// The same five the labelled button offers, so a toolbar can mix the two.
enum UiIconButtonVariant {
  /// The accent's solid fill under its contrast icon.
  solid,

  /// A tinted accent fill under an accent icon.
  soft,

  /// A faint accent surface inside a 1px accent frame.
  surface,

  /// No fill inside a 1px accent frame.
  outline,

  /// An accent icon alone, with a tint under the pointer.
  ghost,
}

/// The Ui IconButton recipe.
///
/// It reads top to bottom: what every icon button shares, then the size, then
/// the variant's colors for each state, then focus and disabled. [style]
/// merges last, so a call site can override any part of it.
///
/// The variants restate the labelled button's colors rather than sharing
/// them, so each recipe can be read and edited on its own. Change one and
/// change the other to keep the two a family.
///
/// [highContrast] strengthens a variant: the solid fill, and the icon of every
/// other variant, move to accent step 12.
@MixWidget(target: RemixIconButton.new)
IconButtonStyler uiIconButtonStyle({
  UiIconButtonVariant variant = .solid,
  UiIconButtonSize size = .size2,
  bool highContrast = false,
  IconButtonStyler style = const IconButtonStyler.create(),
}) {
  return _base()
      .merge(_scale(size))
      .merge(variant == .ghost ? _ghostLayout(size) : _squareLayout(size))
      .merge(switch (variant) {
        .solid => _solid(highContrast),
        .soft => _soft(highContrast),
        .surface => _surface(highContrast),
        .outline => _outline(highContrast),
        .ghost => _ghost(highContrast),
      })
      // Hover and press arrive quickly. These merge into the variant's own
      // hover and press fragments, which set the colors.
      .onHovered(IconButtonStyler().animate(_activeMotion))
      .onPressed(IconButtonStyler().animate(_activeMotion))
      .onFocusVisible(.containerEffects(uiFocusOutline()))
      // A disabled icon button never rings: this switches the outline off,
      // whatever color and width the focus fragment gives it.
      .onDisabled(.containerEffects(.outline(.style(.none))))
      .wrap(uiTouchTarget())
      .merge(style);
}

/// How fast hover and press arrive.
final _activeMotion = AnimationConfig.ease(const Duration(milliseconds: 40));

/// How fast every other change settles: the return to rest, focus, disabled.
final _restMotion = AnimationConfig.ease(const Duration(milliseconds: 120));

/// The loading spinner sits back from the icon it replaces.
const _spinnerOpacity = 0.65;

/// One full spinner revolution.
const _spinnerRevolution = Duration(milliseconds: 800);

/// A fill that paints nothing.
const _transparent = Color(0x00000000);

/// What every icon button shares, whatever its size or variant.
IconButtonStyler _base() => IconButtonStyler()
    .animate(_restMotion)
    .spinner(
      SpinnerStyler()
          .opacity(_spinnerOpacity)
          .leafRadius(UiTokens.radius1())
          .duration(_spinnerRevolution),
    );

/// The icon, spinner and corner sizes of each step.
///
/// The corners turn into a circle when the theme radius is `full`.
IconButtonStyler _scale(UiIconButtonSize size) => switch (size) {
  .size1 =>
    IconButtonStyler()
        .icon(.size(UiTokens.space3()))
        .spinner(.size(UiTokens.space3()))
        .borderRadius(.all(UiTokens.radius1OrFull())),
  .size2 =>
    IconButtonStyler()
        .icon(.size(UiTokens.space4()))
        .spinner(.size(UiTokens.space4()))
        .borderRadius(.all(UiTokens.radius2OrFull())),
  // `spinnerSize3` is the 20px step the spacing scale has no name for.
  .size3 =>
    IconButtonStyler()
        .icon(.size(UiTokens.spinnerSize3()))
        .spinner(.size(UiTokens.space4()))
        .borderRadius(.all(UiTokens.radius3OrFull())),
  .size4 =>
    IconButtonStyler()
        .icon(.size(UiTokens.space5()))
        .spinner(.size(UiTokens.spinnerSize3()))
        .borderRadius(.all(UiTokens.radius4OrFull())),
};

/// The box of a solid, soft, surface or outline icon button: a square with
/// the icon in its center.
IconButtonStyler _squareLayout(UiIconButtonSize size) {
  final edge = switch (size) {
    .size1 => UiTokens.space5(),
    .size2 => UiTokens.space6(),
    .size3 => UiTokens.space7(),
    .size4 => UiTokens.space8(),
  };

  return IconButtonStyler().size(edge, edge).alignment(.center);
}

/// The box of a ghost icon button, which sits in a line of content like text.
///
/// Its padding gives the hover tint room, and a negative margin of the same
/// size cancels that padding in layout, so the icon lines up with the content
/// around it.
IconButtonStyler _ghostLayout(UiIconButtonSize size) => switch (size) {
  .size1 =>
    IconButtonStyler()
        .padding(.all(UiTokens.space1()))
        .margin(.all(UiTokens.iconButtonGhostMargin1())),
  .size2 =>
    IconButtonStyler()
        .padding(.all(UiTokens.space2()))
        .margin(.all(UiTokens.iconButtonGhostMargin2())),
  .size3 =>
    IconButtonStyler()
        .padding(.all(UiTokens.space2()))
        .margin(.all(UiTokens.iconButtonGhostMargin3())),
  .size4 =>
    IconButtonStyler()
        .padding(.all(UiTokens.space3()))
        .margin(.all(UiTokens.iconButtonGhostMargin4())),
};

/// Solid: the accent's labelled fill, or its strongest step at high contrast.
///
/// Hover and press recolor the fill and nothing else, so the icon, spinner
/// and focus ring keep their colors.
IconButtonStyler _solid(bool highContrast) => highContrast
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

/// A disabled solid icon button, which also drops any filter the caller
/// added.
IconButtonStyler _solidDisabled() =>
    _disabledContent().color(UiTokens.grayA3()).wrap(uiClearFilter());

/// Soft: a tinted accent fill that deepens a step on hover and on press.
IconButtonStyler _soft(bool highContrast) => _content(_accentIcon(highContrast))
    .color(UiTokens.accentA3())
    .onHovered(.color(UiTokens.accentA4()))
    .onPressed(.color(UiTokens.accentA5()))
    .onDisabled(_disabledContent().color(UiTokens.grayA3()));

/// Surface: a faint accent surface inside a frame that strengthens on hover.
IconButtonStyler _surface(bool highContrast) =>
    _content(_accentIcon(highContrast))
        .color(UiTokens.accentSurface())
        .containerEffects(_frame([UiTokens.accentA7()]))
        .onHovered(.containerEffects(_frame([UiTokens.accentA8()])))
        .onPressed(
          IconButtonStyler()
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
IconButtonStyler _outline(bool highContrast) =>
    _content(_accentIcon(highContrast))
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

/// Ghost: an accent icon alone, with a tint under the pointer.
IconButtonStyler _ghost(bool highContrast) =>
    _content(_accentIcon(highContrast))
        .color(_transparent)
        .onHovered(.color(UiTokens.accentA3()))
        .onPressed(.color(UiTokens.accentA4()))
        .onDisabled(_disabledContent().color(_transparent));

/// One color for the icon and the spinner.
IconButtonStyler _content(Color color) =>
    IconButtonStyler().icon(.color(color)).spinner(.color(color));

/// The icon color of the soft, surface, outline and ghost variants.
Color _accentIcon(bool highContrast) =>
    highContrast ? UiTokens.accent12() : UiTokens.accentContentAlpha();

/// Disabled content: gray, with the spinner at full strength rather than its
/// usual 65%.
IconButtonStyler _disabledContent() =>
    _content(UiTokens.grayA8()).spinner(.opacity(1));

/// A crisp 1px line just inside the button's edge, one for each of [colors].
RemixBoxEffectsMix _frame(List<Color> colors) =>
    .behindContent(uiInsetSurface(strokes: colors));
