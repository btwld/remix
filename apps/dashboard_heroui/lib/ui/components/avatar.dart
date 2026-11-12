import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'avatar.g.dart';

/// HeroUI avatar variants: the `default` fill, or a tinted (`soft`) fill in
/// the avatar's color.
enum UiAvatarVariant {
  /// The neutral `default` fill.
  defaultAvatar,

  /// A tinted fill in the avatar's color.
  soft,
}

/// HeroUI avatar sizes: 32px, 40px, and 48px.
enum UiAvatarSize {
  /// 32px.
  sm,

  /// 40px. The default.
  md,

  /// 48px.
  lg,
}

/// HeroUI recipe for [RemixAvatar].
///
/// The label is HeroUI's `Avatar.Fallback`; images are Remix's
/// `foregroundImage`, which falls back to the label when it fails to load.
@MixWidget(target: RemixAvatar.new)
AvatarStyler uiAvatarStyle({
  UiAvatarVariant variant = .defaultAvatar,
  UiColor color = .defaultColor,
  UiAvatarSize size = .md,
  AvatarStyler style = const AvatarStyler.create(),
}) {
  final metrics = _metrics(size);
  final soft = uiSoft(color);
  final dimension = uiAvatarDimension(size);

  return AvatarStyler()
      .size(dimension, dimension)
      .borderRadius(.all(metrics.radius))
      .clipBehavior(.antiAlias)
      .color(variant == .soft ? soft.fill : UiTokens.defaultColor())
      .label(
        .style(metrics.text.mix()).fontWeight(.w500).color(soft.foreground),
      )
      .icon(.color(soft.foreground))
      .merge(style);
}

/// `--avatar-size`: `size-8`, `size-10` (base), `size-12`.
double uiAvatarDimension(UiAvatarSize size) => switch (size) {
  .sm => 32,
  .md => 40,
  .lg => 48,
};

typedef _Metrics = ({Radius radius, TextStyleToken text});

/// `.avatar` (`size-10 rounded-3xl`) and the `--sm` / `--lg` overrides; the
/// fallback is `text-sm`, `text-xs` on `--sm`, `text-base` on `--lg`.
_Metrics _metrics(UiAvatarSize size) => switch (size) {
  .sm => (radius: UiTokens.radius2xl(), text: UiTokens.textXs),
  .md => (radius: UiTokens.radius3xl(), text: UiTokens.textSm),
  .lg => (radius: UiTokens.radius3xl(), text: UiTokens.textBase),
};
