part of 'toggle_group.dart';

/// Style configuration for a [RemixToggleGroup] container and its items.
extension RemixToggleGroupStylerRemixHelpers on RemixToggleGroupStyler {
  /// Sets the group background color.
  RemixToggleGroupStyler backgroundColor(Color value) => color(value);

  /// Creates a [RemixToggleGroup] with this style applied.
  RemixToggleGroup<T> call<T>({
    Key? key,
    required List<RemixToggleGroupItem<T>> items,
    required T? selectedValue,
    ValueChanged<T?>? onChanged,
    bool enabled = true,
    Axis orientation = .horizontal,
    bool loop = true,
    String? semanticLabel,
    bool excludeSemantics = false,
  }) {
    return RemixToggleGroup(
      key: key,
      items: items,
      selectedValue: selectedValue,
      onChanged: onChanged,
      enabled: enabled,
      orientation: orientation,
      loop: loop,
      semanticLabel: semanticLabel,
      excludeSemantics: excludeSemantics,
      style: this,
    );
  }

  RemixToggleGroupStyler flex(FlexStyler value) {
    return merge(
      RemixToggleGroupStyler(container: FlexBoxStyler().flex(value)),
    );
  }
}

/// Style configuration for an option in a [RemixToggleGroup].
extension RemixToggleGroupItemStylerRemixHelpers on RemixToggleGroupItemStyler {
  /// Sets the item background color.
  RemixToggleGroupItemStyler backgroundColor(Color value) => color(value);

  /// Sets the item foreground color for both label and icon.
  RemixToggleGroupItemStyler foregroundColor(Color value) {
    return labelColor(value).iconColor(value);
  }

  RemixToggleGroupItemStyler flex(FlexStyler value) {
    return merge(
      RemixToggleGroupItemStyler(container: FlexBoxStyler().flex(value)),
    );
  }
}
