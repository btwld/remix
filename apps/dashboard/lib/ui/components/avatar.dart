import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'avatar.g.dart';

/// The sizes an avatar comes in. Pixel values are at 100% theme scaling.
enum UiAvatarSize {
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
enum UiAvatarVariant {
  /// A tinted accent fill under accent text.
  soft,

  /// The accent's solid fill under its contrast text.
  solid,
}

/// The Ui Avatar recipe.
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
AvatarStyler uiAvatarStyle({
  UiAvatarVariant variant = .soft,
  UiAvatarSize size = .size3,
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
AvatarStyler _base(UiAvatarSize size, {required int fallbackLength}) {
  final (:dimension, :icon, :radius) = switch (size) {
    .size1 => (
      dimension: UiTokens.space5(),
      icon: UiTokens.space3(),
      radius: UiTokens.radius2OrFull(),
    ),
    .size2 => (
      dimension: UiTokens.space6(),
      icon: UiTokens.space4(),
      radius: UiTokens.radius2OrFull(),
    ),
    .size3 => (
      dimension: UiTokens.space7(),
      icon: UiTokens.avatarIconSize3(),
      radius: UiTokens.radius3OrFull(),
    ),
    .size4 => (
      dimension: UiTokens.space8(),
      icon: UiTokens.space5(),
      radius: UiTokens.radius3OrFull(),
    ),
    .size5 => (
      dimension: UiTokens.space9(),
      icon: UiTokens.space6(),
      radius: UiTokens.radius4OrFull(),
    ),
    .size6 => (
      dimension: UiTokens.avatarSize6(),
      icon: UiTokens.space7(),
      radius: UiTokens.radius5OrFull(),
    ),
    .size7 => (
      dimension: UiTokens.avatarSize7(),
      icon: UiTokens.space8(),
      radius: UiTokens.radius5OrFull(),
    ),
    .size8 => (
      dimension: UiTokens.avatarSize8(),
      icon: UiTokens.space9(),
      radius: UiTokens.radius6OrFull(),
    ),
    .size9 => (
      dimension: UiTokens.avatarSize9(),
      icon: UiTokens.avatarIconSize9(),
      radius: UiTokens.radius6OrFull(),
    ),
  };

  return AvatarStyler()
      .clipBehavior(.hardEdge)
      .label(
        TextStyler(
          style: _fallbackText(size, fallbackLength).mix(),
        ).fontWeight(UiTokens.fontWeightMedium()),
      )
      .icon(.size(icon).color(UiTokens.accentContentAlpha()))
      .size(dimension, dimension)
      .borderRadius(.all(radius));
}

/// The fallback text style. The first four sizes have a one-character and a
/// two-character style; larger sizes have one.
TextStyleToken _fallbackText(UiAvatarSize size, int fallbackLength) =>
    switch ((size, fallbackLength == 2)) {
      (.size1, false) => UiTokens.avatarFallback1One,
      (.size1, true) => UiTokens.avatarFallback1Two,
      (.size2, false) => UiTokens.avatarFallback2One,
      (.size2, true) => UiTokens.avatarFallback2Two,
      (.size3, false) => UiTokens.avatarFallback3One,
      (.size3, true) => UiTokens.avatarFallback3Two,
      (.size4, false) => UiTokens.avatarFallback4One,
      (.size4, true) => UiTokens.avatarFallback4Two,
      (.size5, _) => UiTokens.avatarFallback5,
      (.size6, _) => UiTokens.avatarFallback6,
      (.size7, _) => UiTokens.avatarFallback7,
      (.size8, _) => UiTokens.avatarFallback8,
      (.size9, _) => UiTokens.avatarFallback9,
    };

AvatarStyler _soft(bool highContrast) {
  final content = highContrast
      ? UiTokens.accent12()
      : UiTokens.accentContentAlpha();

  return AvatarStyler()
      .color(UiTokens.accentA3())
      .labelColor(content)
      .iconColor(content);
}

AvatarStyler _solid(bool highContrast) {
  final content = highContrast ? UiTokens.accent1() : UiTokens.accentContrast();

  return AvatarStyler()
      .color(highContrast ? UiTokens.accent12() : UiTokens.accentSolid())
      .labelColor(content)
      .iconColor(content);
}
