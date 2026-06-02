part of 'icon_button.dart';

@MixableSpec()
class RemixIconButtonSpec with _$RemixIconButtonSpec {
  @override
  final StyleSpec<BoxSpec> container;
  @override
  final StyleSpec<IconSpec> icon;
  @override
  final StyleSpec<RemixSpinnerSpec> spinner;

  const RemixIconButtonSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<IconSpec>? icon,
    StyleSpec<RemixSpinnerSpec>? spinner,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       icon = icon ?? const StyleSpec(spec: IconSpec()),
       spinner = spinner ?? const StyleSpec(spec: RemixSpinnerSpec());
}
