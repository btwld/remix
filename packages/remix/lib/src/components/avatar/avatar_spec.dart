part of 'avatar.dart';

@MixableSpec()
class RemixAvatarSpec extends Spec<RemixAvatarSpec>
    with Diagnosticable, _$RemixAvatarSpecMethods {
  @override
  final StyleSpec<BoxSpec> container;
  @override
  final StyleSpec<TextSpec> text;
  @override
  final StyleSpec<IconSpec> icon;

  const RemixAvatarSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? text,
    StyleSpec<IconSpec>? icon,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       text = text ?? const StyleSpec(spec: TextSpec()),
       icon = icon ?? const StyleSpec(spec: IconSpec());
}
