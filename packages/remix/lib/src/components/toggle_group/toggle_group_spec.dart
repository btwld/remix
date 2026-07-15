part of 'toggle_group.dart';

/// Resolved visual properties for a [RemixToggleGroup].
@MixableSpec()
class RemixToggleGroupSpec with _$RemixToggleGroupSpec {
  /// Layout and decoration for the group container.
  @override
  final StyleSpec<FlexBoxSpec> container;

  /// Default visual style for every option in the group.
  @override
  final StyleSpec<RemixToggleGroupItemSpec> item;

  const RemixToggleGroupSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<RemixToggleGroupItemSpec>? item,
  }) : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
       item = item ?? const StyleSpec(spec: RemixToggleGroupItemSpec());
}

/// Resolved visual properties for an item in a [RemixToggleGroup].
@MixableSpec()
class RemixToggleGroupItemSpec with _$RemixToggleGroupItemSpec {
  /// Layout and decoration for the item content.
  @override
  final StyleSpec<FlexBoxSpec> container;

  /// Text style for the optional label.
  @override
  final StyleSpec<TextSpec> label;

  /// Icon style for the optional icon.
  @override
  final StyleSpec<IconSpec> icon;

  const RemixToggleGroupItemSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
  }) : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
       label = label ?? const StyleSpec(spec: TextSpec()),
       icon = icon ?? const StyleSpec(spec: IconSpec());
}
