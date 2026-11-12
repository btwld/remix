import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

// The computed fills of the solid Button and IconButton.
//
// Everything else about the two controls is written out in their own recipes.
// These fills are shared because they are calculated rather than picked: each
// one runs a hover or press adjustment over a theme color, so it follows any
// palette, including a custom one.

/// A solid button's fill while pressed.
///
/// The hover fill, darkened under a light label and lightened under a dark
/// one, so the label keeps its contrast either way.
const uiSolidPressedFill = ContextToken<Color>(_solidPressedFill);

Color _solidPressedFill(BuildContext context) {
  final label = UiTokens.accentContrast.resolve(context);
  final fill = UiTokens.accentSolid.resolve(context);
  final hover = UiTokens.accentSolidHover.resolve(context);

  final labelIsLight = label.computeLuminance() > fill.computeLuminance();
  if (labelIsLight) {
    return _filtered(hover, const [.brightness(0.92), .saturate(1.1)]);
  }

  // Lightening a bright hover fill can land back on the idle fill, and the
  // press would then show nothing. Darken it instead.
  final lightened = _filtered(hover, const [.brightness(1.08)]);

  return _isSameFill(lightened, fill)
      ? _filtered(hover, const [.brightness(0.92)])
      : lightened;
}

/// Whether two fills are within two 8-bit steps of each other on every
/// channel, which the eye reads as one color.
bool _isSameFill(Color first, Color second) {
  const tolerance = 2 / 255;

  return (first.r - second.r).abs() <= tolerance &&
      (first.g - second.g).abs() <= tolerance &&
      (first.b - second.b).abs() <= tolerance;
}

/// A high-contrast solid button's fill while hovered: accent step 12 through
/// the hover filter of the active brightness.
const uiHighContrastHoverFill = ContextToken<Color>(_highContrastHoverFill);

Color _highContrastHoverFill(BuildContext context) => _filtered(
  UiTokens.accent12.resolve(context),
  UiTheme.of(context).isDark
      ? const [.contrast(0.88), .saturate(1.3), .brightness(1.18)]
      : const [.contrast(0.88), .saturate(1.1), .brightness(1.1)],
);

/// A high-contrast solid button's fill while pressed: accent step 12 through
/// the press filter of the active brightness.
const uiHighContrastPressedFill = ContextToken<Color>(_highContrastPressedFill);

Color _highContrastPressedFill(BuildContext context) => _filtered(
  UiTokens.accent12.resolve(context),
  UiTheme.of(context).isDark
      ? const [.brightness(0.95), .saturate(1.2)]
      : const [.contrast(0.82), .saturate(1.2), .brightness(1.16)],
);

/// [color] after the CSS filter [operations], applied in order.
///
/// The arithmetic `RemixOrderedColorFilterModifier` applies to a painted
/// subtree, applied to a single color: each operation is a 4×5 color matrix
/// over 0–255 channels, clamped before the next one runs.
Color _filtered(Color color, List<RemixCssColorFilterOperation> operations) {
  var red = color.r * 255;
  var green = color.g * 255;
  var blue = color.b * 255;
  final alpha = color.a * 255;

  for (final operation in operations) {
    if (operation.isIdentity) continue;

    final matrix = operation.matrix;
    double channel(int row) {
      final offset = row * 5;

      return (matrix[offset] * red +
              matrix[offset + 1] * green +
              matrix[offset + 2] * blue +
              matrix[offset + 3] * alpha +
              matrix[offset + 4])
          .clamp(0.0, 255.0);
    }

    (red, green, blue) = (channel(0), channel(1), channel(2));
  }

  return Color.from(
    alpha: color.a,
    red: red / 255,
    green: green / 255,
    blue: blue / 255,
  );
}

/// A CSS filter over a whole button that differs between light and dark.
///
/// The recipes never filter a button: their states recolor the fill, so the
/// label and focus ring keep their own colors. This is for a call site that
/// wants a filter anyway, passed through `style`:
///
/// ```dart
/// ButtonStyler().wrap(
///   uiModeAwareFilter(
///     light: const [.brightness(0.9)],
///     dark: const [.brightness(1.1)],
///   ),
/// )
/// ```
WidgetModifierConfig uiModeAwareFilter({
  required List<RemixCssColorFilterOperation> light,
  required List<RemixCssColorFilterOperation> dark,
}) => WidgetModifierConfig.modifier(
  _ModeAwareFilterMix(light: light, dark: dark),
);

/// Removes a filter set by [uiModeAwareFilter] in a later state.
///
/// A disabled solid button applies it, so a caller's filter never tints the
/// disabled fill.
WidgetModifierConfig uiClearFilter() =>
    uiModeAwareFilter(light: const [], dark: const []);

final class _ModeAwareFilterMix
    extends ModifierMix<RemixOrderedColorFilterModifier> {
  const _ModeAwareFilterMix({required this.light, required this.dark});

  final List<RemixCssColorFilterOperation> light;
  final List<RemixCssColorFilterOperation> dark;

  @override
  RemixOrderedColorFilterModifier resolve(BuildContext context) =>
      RemixOrderedColorFilterModifier(
        UiTheme.of(context).isDark ? dark : light,
      );

  /// A later filter replaces an earlier one; filters do not stack.
  @override
  _ModeAwareFilterMix merge(_ModeAwareFilterMix? other) => other ?? this;

  @override
  List<Object?> get props => [light, dark];
}
