part of 'avatar.dart';

/// Resolved visual properties for a [RemixAvatar].
@MixableSpec(
  target: RemixAvatar.new,
  extraStylerMixins: [RemixBoxStylerMixin, LabelStyleMixin, IconStyleMixin],
)
class AvatarSpec with _$AvatarSpec {
  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<BoxSpec> container;
  @override
  final StyleSpec<TextSpec> label;
  @override
  final StyleSpec<IconSpec> icon;

  /// How a loaded image, or the fallback of a failed one, appears.
  ///
  /// Null swaps the image in on its first frame, the behavior before this
  /// field existed. Images that load synchronously, such as cached ones,
  /// never animate.
  @override
  final RemixAvatarImageTransition? imageTransition;

  const AvatarSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
    this.imageTransition,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       label = label ?? const StyleSpec(spec: TextSpec()),
       icon = icon ?? const StyleSpec(spec: IconSpec());
}

/// Backward-compatible name for [AvatarSpec].
///
/// The generated style API is based on [AvatarSpec], so resolved values use
/// `AvatarSpec` as their runtime type.
typedef RemixAvatarSpec = AvatarSpec;
