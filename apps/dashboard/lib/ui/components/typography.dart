import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

/// The nine steps of this design system's text scale, from [UiTokens].
/// Pixel values are at 100% theme scaling.
enum UiTextSize {
  /// 12px.
  size1,

  /// 14px.
  size2,

  /// 16px. The default for body text.
  size3,

  /// 18px.
  size4,

  /// 20px.
  size5,

  /// 24px.
  size6,

  /// 28px.
  size7,

  /// 36px.
  size8,

  /// 60px.
  size9,
}

/// The font weights of the text scale.
enum UiTextWeight {
  /// Light, 300. For large display text.
  light,

  /// Body text.
  regular,

  /// Labels and emphasis.
  medium,

  /// Headings.
  bold,
}

/// The text style token of a [size] on the scale.
TextStyleToken uiTextSizeToken(UiTextSize size) => switch (size) {
  .size1 => UiTokens.text1,
  .size2 => UiTokens.text2,
  .size3 => UiTokens.text3,
  .size4 => UiTokens.text4,
  .size5 => UiTokens.text5,
  .size6 => UiTokens.text6,
  .size7 => UiTokens.text7,
  .size8 => UiTokens.text8,
  .size9 => UiTokens.text9,
};

/// The font weight token of a [weight].
FontWeightToken uiTextWeightToken(UiTextWeight weight) => switch (weight) {
  .light => UiTokens.fontWeightLight,
  .regular => UiTokens.fontWeightRegular,
  .medium => UiTokens.fontWeightMedium,
  .bold => UiTokens.fontWeightBold,
};

/// [truncate] deliberately wins over [softWrap], forcing one ellipsized line.
TextStyler uiApplyTextFlow(
  TextStyler style, {
  TextAlign? align,
  required bool softWrap,
  required bool truncate,
}) {
  if (align != null) style = style.textAlign(align);
  if (truncate) {
    return style.maxLines(1).softWrap(false).overflow(TextOverflow.ellipsis);
  }

  return style.softWrap(softWrap);
}

/// [style] with the accent's text color, or accent step 12 under
/// [highContrast].
TextStyler uiAccentForeground(TextStyler style, {required bool highContrast}) =>
    style.color(
      highContrast ? UiTokens.accent12() : UiTokens.accentContentAlpha(),
    );

/// The text style of [size], resolved against [context].
///
/// Code, Kbd, and Link derive em-relative geometry from the resolved font size,
/// so unlike the other recipes they cannot stay context-free.
TextStyle uiResolveTextToken(BuildContext context, UiTextSize size) =>
    MixScope.tokenOf(uiTextSizeToken(size), context);

Color uiResolveColor(BuildContext context, ColorToken token) =>
    MixScope.tokenOf(token, context);

/// The theme's radius factor, read back from the resolved `radius1`.
///
/// Derived from the resolved `radius1` rather than duplicating this design
/// system's radius table, so theme radius and scaling changes flow through.
double uiRadiusFactor(BuildContext context) {
  final scaling = UiTheme.of(context).scaling.factor;
  final radius = MixScope.tokenOf(UiTokens.radius1, context);

  return radius.x / (3 * scaling);
}
