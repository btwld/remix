import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'avatar.g.dart';

/// Deui avatar variants: the `default` fill, or a tinted (`soft`) fill in
/// the avatar's color.
enum DeuiAvatarVariant {
  /// The neutral `default` fill.
  defaultAvatar,

  /// A tinted fill in the avatar's color.
  soft,
}

/// Deui avatar sizes: 32px, 40px, and 48px.
enum DeuiAvatarSize {
  /// 32px.
  sm,

  /// 40px. The default.
  md,

  /// 48px.
  lg,
}

/// Deui recipe for [RemixAvatar].
///
/// The label is Deui's `Avatar.Fallback`; images are Remix's
/// `foregroundImage`, which falls back to the label when it fails to load.
@MixWidget(target: RemixAvatar.new)
AvatarStyler deuiAvatarStyle({
  DeuiAvatarVariant variant = .defaultAvatar,
  DeuiColor color = .defaultColor,
  DeuiAvatarSize size = .md,
  AvatarStyler style = const AvatarStyler.create(),
}) {
  final metrics = _metrics(size);
  final soft = deuiSoft(color);
  final dimension = deuiAvatarDimension(size);

  return AvatarStyler()
      .size(dimension, dimension)
      .borderRadius(.all(metrics.radius))
      .clipBehavior(.antiAlias)
      .color(variant == .soft ? soft.fill : DeuiTokens.defaultColor())
      .label(
        .style(metrics.text.mix()).fontWeight(.w500).color(soft.foreground),
      )
      .icon(.color(soft.foreground))
      .merge(style);
}

/// `--avatar-size`: `size-8`, `size-10` (base), `size-12`.
double deuiAvatarDimension(DeuiAvatarSize size) => switch (size) {
  .sm => 32,
  .md => 40,
  .lg => 48,
};

typedef _Metrics = ({Radius radius, TextStyleToken text});

/// `.avatar` (`size-10 rounded-3xl`) and the `--sm` / `--lg` overrides; the
/// fallback is `text-sm`, `text-xs` on `--sm`, `text-base` on `--lg`.
_Metrics _metrics(DeuiAvatarSize size) => switch (size) {
  .sm => (radius: DeuiTokens.radius3xl(), text: DeuiTokens.textXs),
  .md => (radius: DeuiTokens.radius3xl(), text: DeuiTokens.textSm),
  .lg => (radius: DeuiTokens.radius3xl(), text: DeuiTokens.textBase),
};
