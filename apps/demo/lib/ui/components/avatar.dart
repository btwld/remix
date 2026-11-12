import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'avatar.g.dart';

/// The sizes an avatar comes in. Pixel values are at 100% theme scaling.
enum FortalAvatarSize {
  /// 24px square.
  size1,

  /// 32px square.
  size2,

  /// 40px square. The default.
  size3,

  /// 48px square.
  size4,

  /// 64px square.
  size5,

  /// 80px square.
  size6,

  /// 96px square.
  size7,

  /// 128px square.
  size8,

  /// 160px square.
  size9,
}

/// The looks an avatar comes in.
enum FortalAvatarVariant {
  /// A tinted accent fill under accent text.
  soft,

  /// The accent's solid fill under its contrast text.
  solid,
}

/// The Fortal Avatar recipe.
///
/// It reads top to bottom: the size and fallback text, then the variant's
/// colors. The corners turn into a circle when the theme radius is `full`.
///
/// [highContrast] moves the solid fill, and the text of the soft variant, to
/// accent step 12.
///
/// [fallbackLength] selects the pinned one- or two-character fallback
/// typography. Pass `2` when [RemixAvatar.label] contains two initials.
@MixWidget(target: RemixAvatar.new)
AvatarStyler fortalAvatarStyle({
  FortalAvatarVariant variant = .soft,
  FortalAvatarSize size = .size3,
  bool highContrast = false,
  int fallbackLength = 1,
  AvatarStyler style = const AvatarStyler.create(),
}) => _base(size, fallbackLength: fallbackLength)
    .merge(switch (variant) {
      .soft => _soft(highContrast),
      .solid => _solid(highContrast),
    })
    .merge(style);

/// The square, corner, fallback text and icon size of each step.
AvatarStyler _base(FortalAvatarSize size, {required int fallbackLength}) {
  final (:dimension, :icon, :radius) = switch (size) {
    .size1 => (
      dimension: FortalTokens.space5(),
      icon: FortalTokens.space3(),
      radius: FortalTokens.radius2OrFull(),
    ),
    .size2 => (
      dimension: FortalTokens.space6(),
      icon: FortalTokens.space4(),
      radius: FortalTokens.radius2OrFull(),
    ),
    .size3 => (
      dimension: FortalTokens.space7(),
      icon: FortalTokens.avatarIconSize3(),
      radius: FortalTokens.radius3OrFull(),
    ),
    .size4 => (
      dimension: FortalTokens.space8(),
      icon: FortalTokens.space5(),
      radius: FortalTokens.radius3OrFull(),
    ),
    .size5 => (
      dimension: FortalTokens.space9(),
      icon: FortalTokens.space6(),
      radius: FortalTokens.radius4OrFull(),
    ),
    .size6 => (
      dimension: FortalTokens.avatarSize6(),
      icon: FortalTokens.space7(),
      radius: FortalTokens.radius5OrFull(),
    ),
    .size7 => (
      dimension: FortalTokens.avatarSize7(),
      icon: FortalTokens.space8(),
      radius: FortalTokens.radius5OrFull(),
    ),
    .size8 => (
      dimension: FortalTokens.avatarSize8(),
      icon: FortalTokens.space9(),
      radius: FortalTokens.radius6OrFull(),
    ),
    .size9 => (
      dimension: FortalTokens.avatarSize9(),
      icon: FortalTokens.avatarIconSize9(),
      radius: FortalTokens.radius6OrFull(),
    ),
  };

  return AvatarStyler()
      .clipBehavior(.hardEdge)
      .label(
        TextStyler(
          style: _fallbackText(size, fallbackLength).mix(),
        ).fontWeight(FortalTokens.fontWeightMedium()),
      )
      .icon(.size(icon).color(FortalTokens.accentContentAlpha()))
      .size(dimension, dimension)
      .borderRadius(.all(radius));
}

/// The fallback text style. The first four sizes have a one-character and a
/// two-character style; larger sizes have one.
TextStyleToken _fallbackText(FortalAvatarSize size, int fallbackLength) =>
    switch ((size, fallbackLength == 2)) {
      (.size1, false) => FortalTokens.avatarFallback1One,
      (.size1, true) => FortalTokens.avatarFallback1Two,
      (.size2, false) => FortalTokens.avatarFallback2One,
      (.size2, true) => FortalTokens.avatarFallback2Two,
      (.size3, false) => FortalTokens.avatarFallback3One,
      (.size3, true) => FortalTokens.avatarFallback3Two,
      (.size4, false) => FortalTokens.avatarFallback4One,
      (.size4, true) => FortalTokens.avatarFallback4Two,
      (.size5, _) => FortalTokens.avatarFallback5,
      (.size6, _) => FortalTokens.avatarFallback6,
      (.size7, _) => FortalTokens.avatarFallback7,
      (.size8, _) => FortalTokens.avatarFallback8,
      (.size9, _) => FortalTokens.avatarFallback9,
    };

AvatarStyler _soft(bool highContrast) {
  final content = highContrast
      ? FortalTokens.accent12()
      : FortalTokens.accentContentAlpha();

  return AvatarStyler()
      .color(FortalTokens.accentA3())
      .labelColor(content)
      .iconColor(content);
}

AvatarStyler _solid(bool highContrast) {
  final content = highContrast
      ? FortalTokens.accent1()
      : FortalTokens.accentContrast();

  return AvatarStyler()
      .color(
        highContrast ? FortalTokens.accent12() : FortalTokens.accentSolid(),
      )
      .labelColor(content)
      .iconColor(content);
}
