import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

/// The Fortal BaseButton size scale shared by Button and IconButton.
///
/// Deliberate: this mirrors [FortalBaseButtonVariant]. Button and IconButton
/// each own a size enum, so the shared metrics need a common type — passing the
/// raw `size.index + 1` instead would drop every switch below to a wildcard and
/// defer an unknown size to a runtime throw.
enum FortalBaseButtonSize { size1, size2, size3, size4 }

/// Transition into hover and press, the same 40ms ease as `FortalCard`.
final fortalBaseButtonActiveMotion = AnimationConfig.ease(
  const Duration(milliseconds: 40),
);

/// Transition back to rest and into focus or disabled, the same 120ms ease as
/// `FortalCard`.
final fortalBaseButtonRestMotion = AnimationConfig.ease(
  const Duration(milliseconds: 120),
);

/// Shared Fortal BaseButton metrics used by Button and IconButton recipes.
({
  double height,
  double paddingX,
  double gap,
  Radius radius,
  TextStyleToken text,
  double spinnerSize,
})
fortalBaseButtonMetrics(FortalBaseButtonSize size) => switch (size) {
  .size1 => (
    height: FortalTokens.space5(),
    paddingX: FortalTokens.space2(),
    gap: FortalTokens.space1(),
    radius: FortalTokens.radius1OrFull(),
    text: FortalTokens.text1,
    spinnerSize: FortalTokens.space3(),
  ),
  .size2 => (
    height: FortalTokens.space6(),
    paddingX: FortalTokens.space3(),
    gap: FortalTokens.space2(),
    radius: FortalTokens.radius2OrFull(),
    text: FortalTokens.text2,
    spinnerSize: FortalTokens.space4(),
  ),
  .size3 => (
    height: FortalTokens.space7(),
    paddingX: FortalTokens.space4(),
    gap: FortalTokens.space3(),
    radius: FortalTokens.radius3OrFull(),
    text: FortalTokens.text3,
    spinnerSize: FortalTokens.space4(),
  ),
  .size4 => (
    height: FortalTokens.space8(),
    paddingX: FortalTokens.space5(),
    gap: FortalTokens.space3(),
    radius: FortalTokens.radius4OrFull(),
    text: FortalTokens.text4,
    spinnerSize: FortalTokens.spinnerSize3(),
  ),
};

/// Default icon dimensions shared by text and icon-only button presets.
double fortalBaseButtonIconSize(FortalBaseButtonSize size) => switch (size) {
  .size1 => FortalTokens.space3(),
  .size2 => FortalTokens.space4(),
  .size3 => FortalTokens.spinnerSize3(),
  .size4 => FortalTokens.space5(),
};

/// Content-box metrics for the ghost BaseButton variant.
({double paddingX, double paddingY, double marginX, double marginY, double gap})
fortalBaseButtonGhostMetrics(FortalBaseButtonSize size) => switch (size) {
  .size1 => (
    paddingX: FortalTokens.space2(),
    paddingY: FortalTokens.space1(),
    marginX: FortalTokens.baseButtonGhostMarginX12(),
    marginY: FortalTokens.baseButtonGhostMarginY12(),
    gap: FortalTokens.space1(),
  ),
  .size2 => (
    paddingX: FortalTokens.space2(),
    paddingY: FortalTokens.space1(),
    marginX: FortalTokens.baseButtonGhostMarginX12(),
    marginY: FortalTokens.baseButtonGhostMarginY12(),
    gap: FortalTokens.space1(),
  ),
  .size3 => (
    paddingX: FortalTokens.space3(),
    paddingY: FortalTokens.space2(),
    marginX: FortalTokens.baseButtonGhostMarginX3(),
    marginY: FortalTokens.baseButtonGhostMarginY3(),
    gap: FortalTokens.space2(),
  ),
  .size4 => (
    paddingX: FortalTokens.space4(),
    paddingY: FortalTokens.space2(),
    marginX: FortalTokens.baseButtonGhostMarginX4(),
    marginY: FortalTokens.baseButtonGhostMarginY4(),
    gap: FortalTokens.space2(),
  ),
};

/// Content-box metrics for the ghost IconButton variant.
({double padding, double margin}) fortalIconButtonGhostMetrics(
  FortalBaseButtonSize size,
) => switch (size) {
  .size1 => (
    padding: FortalTokens.space1(),
    margin: FortalTokens.iconButtonGhostMargin1(),
  ),
  .size2 => (
    padding: FortalTokens.space2(),
    margin: FortalTokens.iconButtonGhostMargin2(),
  ),
  .size3 => (
    padding: FortalTokens.space2(),
    margin: FortalTokens.iconButtonGhostMargin3(),
  ),
  .size4 => (
    padding: FortalTokens.space3(),
    margin: FortalTokens.iconButtonGhostMargin4(),
  ),
};

/// Resolves a mode-aware ordered CSS filter at the component build context.
///
/// Fortal's own solid states recolor fills rather than filtering the painted
/// subtree; this remains for callers that deliberately filter a button.
WidgetModifierConfig fortalModeAwareFilter({
  required List<RemixCssColorFilterOperation> light,
  required List<RemixCssColorFilterOperation> dark,
}) => WidgetModifierConfig.modifier(
  _FortalModeAwareFilterMix(light: light, dark: dark),
);

/// Explicit identity filter used to clear a higher-priority state filter.
WidgetModifierConfig fortalClearFilter() =>
    fortalModeAwareFilter(light: const [], dark: const []);

final class _FortalModeAwareFilterMix
    extends ModifierMix<RemixOrderedColorFilterModifier> {
  const _FortalModeAwareFilterMix({required this.light, required this.dark});

  final List<RemixCssColorFilterOperation> light;
  final List<RemixCssColorFilterOperation> dark;

  @override
  RemixOrderedColorFilterModifier resolve(BuildContext context) =>
      RemixOrderedColorFilterModifier(
        FortalTheme.of(context).isDark ? dark : light,
      );

  @override
  _FortalModeAwareFilterMix merge(_FortalModeAwareFilterMix? other) =>
      other ?? this;

  @override
  List<Object?> get props => [light, dark];
}

/// Shared Fortal BaseButton variants implemented by Button and IconButton.
enum FortalBaseButtonVariant { solid, soft, surface, outline, ghost }

/// One visual-state style fragment from the shared BaseButton recipe.
final class FortalBaseButtonStateStyle {
  const FortalBaseButtonStateStyle({
    this.foreground,
    this.background,
    this.effects,
    this.modifier,
    this.spinnerOpacity,
  });

  final Color? foreground;
  final Color? background;
  final RemixBoxEffectsMix? effects;
  final WidgetModifierConfig? modifier;
  final double? spinnerOpacity;
}

/// Visual state styles shared by the concrete Button and IconButton stylers.
final class FortalBaseButtonStateStyles {
  const FortalBaseButtonStateStyles({
    required this.idle,
    required this.hovered,
    required this.pressed,
    required this.disabled,
    required this.focusVisible,
    required this.disabledFocus,
  });

  final FortalBaseButtonStateStyle idle;
  final FortalBaseButtonStateStyle hovered;
  final FortalBaseButtonStateStyle pressed;
  final FortalBaseButtonStateStyle disabled;
  final FortalBaseButtonStateStyle focusVisible;
  final FortalBaseButtonStateStyle disabledFocus;
}

FortalBaseButtonStateStyles fortalBaseButtonStateStyles({
  required FortalBaseButtonVariant variant,
  required bool highContrast,
}) {
  final states = switch (variant) {
    .solid => _solidStateStyles(highContrast: highContrast),
    .soft => _softStateStyles(highContrast: highContrast),
    .surface => _surfaceStateStyles(highContrast: highContrast),
    .outline => _outlineStateStyles(highContrast: highContrast),
    .ghost => _ghostStateStyles(highContrast: highContrast),
  };

  return FortalBaseButtonStateStyles(
    idle: states.idle,
    hovered: states.hovered,
    pressed: states.pressed,
    disabled: states.disabled,
    focusVisible: FortalBaseButtonStateStyle(effects: fortalFocusOutline()),
    disabledFocus: FortalBaseButtonStateStyle(
      effects: RemixBoxEffectsMix.outline(
        BorderSideMix(style: BorderStyle.none),
      ),
    ),
  );
}

typedef _InteractionStateStyles = ({
  FortalBaseButtonStateStyle idle,
  FortalBaseButtonStateStyle hovered,
  FortalBaseButtonStateStyle pressed,
  FortalBaseButtonStateStyle disabled,
});

// Solid hover and press recolor only the fill. The Radix-derived CSS filter
// operations are applied to the fill color itself, never to the painted
// subtree, so the label, icon, spinner and 2px focus ring keep their colors
// (a subtree filter would also dim or lighten the focus ring against the
// unfiltered page) and caller foreground overrides stay in force.
_InteractionStateStyles _solidStateStyles({required bool highContrast}) {
  final foreground = highContrast
      ? FortalTokens.gray1()
      : FortalTokens.accentContrast();

  return (
    idle: FortalBaseButtonStateStyle(
      foreground: foreground,
      background: highContrast
          ? FortalTokens.accent12()
          : FortalTokens.accent9(),
    ),
    hovered: FortalBaseButtonStateStyle(
      background: highContrast
          ? _highContrastHoveredFill()
          : FortalTokens.accent10(),
    ),
    pressed: FortalBaseButtonStateStyle(
      background: highContrast
          ? _highContrastPressedFill()
          : _solidPressedFill(),
    ),
    disabled: FortalBaseButtonStateStyle(
      foreground: FortalTokens.grayA8(),
      background: FortalTokens.grayA3(),
      spinnerOpacity: 1,
      modifier: fortalClearFilter(),
    ),
  );
}

_InteractionStateStyles _softStateStyles({required bool highContrast}) => (
  idle: FortalBaseButtonStateStyle(
    foreground: highContrast
        ? FortalTokens.accent12()
        : FortalTokens.accentA11(),
    background: FortalTokens.accentA3(),
  ),
  hovered: FortalBaseButtonStateStyle(background: FortalTokens.accentA4()),
  pressed: FortalBaseButtonStateStyle(background: FortalTokens.accentA5()),
  disabled: FortalBaseButtonStateStyle(
    foreground: FortalTokens.grayA8(),
    background: FortalTokens.grayA3(),
    spinnerOpacity: 1,
  ),
);

_InteractionStateStyles _surfaceStateStyles({required bool highContrast}) => (
  idle: FortalBaseButtonStateStyle(
    foreground: highContrast
        ? FortalTokens.accent12()
        : FortalTokens.accentA11(),
    background: FortalTokens.accentSurface(),
    effects: RemixBoxEffectsMix.behindContent(
      fortalInsetSurface(strokes: [FortalTokens.accentA7()]),
    ),
  ),
  hovered: FortalBaseButtonStateStyle(
    background: FortalTokens.accentSurface(),
    effects: RemixBoxEffectsMix.behindContent(
      fortalInsetSurface(strokes: [FortalTokens.accentA8()]),
    ),
  ),
  pressed: FortalBaseButtonStateStyle(
    background: FortalTokens.accentA3(),
    effects: RemixBoxEffectsMix.behindContent(
      fortalInsetSurface(strokes: [FortalTokens.accentA8()]),
    ),
  ),
  disabled: FortalBaseButtonStateStyle(
    foreground: FortalTokens.grayA8(),
    background: FortalTokens.grayA2(),
    effects: RemixBoxEffectsMix.behindContent(
      fortalInsetSurface(strokes: [FortalTokens.grayA6()]),
    ),
    spinnerOpacity: 1,
  ),
);

_InteractionStateStyles _outlineStateStyles({required bool highContrast}) {
  final strokes = highContrast
      ? [FortalTokens.accentA7(), FortalTokens.grayA11()]
      : [FortalTokens.accentA8()];
  final effects = RemixBoxEffectsMix.behindContent(
    fortalInsetSurface(strokes: strokes),
  );

  return (
    idle: FortalBaseButtonStateStyle(
      foreground: highContrast
          ? FortalTokens.accent12()
          : FortalTokens.accentA11(),
      effects: effects,
    ),
    hovered: FortalBaseButtonStateStyle(
      background: FortalTokens.accentA2(),
      effects: effects,
    ),
    pressed: FortalBaseButtonStateStyle(
      background: FortalTokens.accentA3(),
      effects: effects,
    ),
    disabled: FortalBaseButtonStateStyle(
      foreground: FortalTokens.grayA8(),
      background: const Color(0x00000000),
      effects: RemixBoxEffectsMix.behindContent(
        fortalInsetSurface(strokes: [FortalTokens.grayA7()]),
      ),
      spinnerOpacity: 1,
    ),
  );
}

_InteractionStateStyles _ghostStateStyles({required bool highContrast}) => (
  idle: FortalBaseButtonStateStyle(
    foreground: highContrast
        ? FortalTokens.accent12()
        : FortalTokens.accentA11(),
    background: const Color(0x00000000),
  ),
  hovered: FortalBaseButtonStateStyle(background: FortalTokens.accentA3()),
  pressed: FortalBaseButtonStateStyle(background: FortalTokens.accentA4()),
  disabled: FortalBaseButtonStateStyle(
    foreground: FortalTokens.grayA8(),
    background: const Color(0x00000000),
    spinnerOpacity: 1,
  ),
);

/// Ordinary solid press: the hover fill darkens under a light label and
/// lightens under a deep on-solid ink, so the label keeps its contrast in
/// both modes and for every palette, including custom ones.
const _solidPressedFill = ContextToken<Color>(_resolveSolidPressedFill);

Color _resolveSolidPressedFill(BuildContext context) {
  final label = FortalTokens.accentContrast.resolve(context);
  final fill = FortalTokens.accent9.resolve(context);
  return _fortalFilteredColor(
    FortalTokens.accent10.resolve(context),
    label.computeLuminance() > fill.computeLuminance()
        ? const [
            RemixCssColorFilterOperation.brightness(0.92),
            RemixCssColorFilterOperation.saturate(1.1),
          ]
        : const [RemixCssColorFilterOperation.brightness(1.08)],
  );
}

const _highContrastHoveredFill = ContextToken<Color>(
  _resolveHighContrastHoveredFill,
);

Color _resolveHighContrastHoveredFill(BuildContext context) =>
    _fortalFilteredColor(
      FortalTokens.accent12.resolve(context),
      FortalTheme.of(context).isDark
          ? const [
              RemixCssColorFilterOperation.contrast(0.88),
              RemixCssColorFilterOperation.saturate(1.3),
              RemixCssColorFilterOperation.brightness(1.18),
            ]
          : const [
              RemixCssColorFilterOperation.contrast(0.88),
              RemixCssColorFilterOperation.saturate(1.1),
              RemixCssColorFilterOperation.brightness(1.1),
            ],
    );

const _highContrastPressedFill = ContextToken<Color>(
  _resolveHighContrastPressedFill,
);

Color _resolveHighContrastPressedFill(BuildContext context) =>
    _fortalFilteredColor(
      FortalTokens.accent12.resolve(context),
      FortalTheme.of(context).isDark
          ? const [
              RemixCssColorFilterOperation.brightness(0.95),
              RemixCssColorFilterOperation.saturate(1.2),
            ]
          : const [
              RemixCssColorFilterOperation.contrast(0.82),
              RemixCssColorFilterOperation.saturate(1.2),
              RemixCssColorFilterOperation.brightness(1.16),
            ],
    );

/// Applies ordered CSS color-filter [operations] to one color with the same
/// matrices and per-function clamping that [RemixOrderedColorFilterModifier]
/// applies to a painted subtree.
Color _fortalFilteredColor(
  Color color,
  List<RemixCssColorFilterOperation> operations,
) {
  var channels = [color.r * 255, color.g * 255, color.b * 255];
  final alpha = color.a * 255;
  for (final operation in operations) {
    if (operation.isIdentity) continue;
    final matrix = operation.matrix;
    channels = [
      for (var row = 0; row < 3; row++)
        (matrix[row * 5] * channels[0] +
                matrix[row * 5 + 1] * channels[1] +
                matrix[row * 5 + 2] * channels[2] +
                matrix[row * 5 + 3] * alpha +
                matrix[row * 5 + 4])
            .clamp(0.0, 255.0),
    ];
  }
  return Color.from(
    alpha: color.a,
    red: channels[0] / 255,
    green: channels[1] / 255,
    blue: channels[2] / 255,
  );
}
