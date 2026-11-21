// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toggle_group.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal ToggleGroup recipe: a segmented control, a 1px gray frame around
/// items that share it.
///
/// It reads top to bottom: the frame, the item's colors for rest, hover,
/// press, selected, focus and disabled, then the size.
///
/// [highContrast] moves the selected item's label and icon to accent step 12.
class UiToggleGroup<T> extends StatelessWidget {
  const UiToggleGroup({
    super.key,
    this.variant = .soft,
    this.size = .size2,
    this.highContrast = false,
    this.style = const ToggleGroupStyler.create(),
    required this.items,
    required this.selectedValue,
    this.onChanged,
    this.enabled = true,
    this.orientation = .horizontal,
    this.loop = true,
    this.semanticLabel,
    this.excludeSemantics = false,
  });

  /// An accent tint behind the selected item.
  const UiToggleGroup.soft({
    super.key,
    this.size = .size2,
    this.highContrast = false,
    this.style = const ToggleGroupStyler.create(),
    required this.items,
    required this.selectedValue,
    this.onChanged,
    this.enabled = true,
    this.orientation = .horizontal,
    this.loop = true,
    this.semanticLabel,
    this.excludeSemantics = false,
  }) : variant = UiToggleGroupVariant.soft;

  /// A faint accent surface behind the selected item.
  const UiToggleGroup.surface({
    super.key,
    this.size = .size2,
    this.highContrast = false,
    this.style = const ToggleGroupStyler.create(),
    required this.items,
    required this.selectedValue,
    this.onChanged,
    this.enabled = true,
    this.orientation = .horizontal,
    this.loop = true,
    this.semanticLabel,
    this.excludeSemantics = false,
  }) : variant = UiToggleGroupVariant.surface;

  final UiToggleGroupVariant variant;

  final UiToggleGroupSize size;

  final bool highContrast;

  final ToggleGroupStyler style;

  final List<RemixToggleGroupItem<T>> items;

  final T? selectedValue;

  final ValueChanged<T?>? onChanged;

  final bool enabled;

  final Axis orientation;

  final bool loop;

  final String? semanticLabel;

  final bool excludeSemantics;

  @override
  Widget build(BuildContext _) {
    return RemixToggleGroup<T>(
      style: uiToggleGroupStyle(
        variant: variant,
        size: size,
        highContrast: highContrast,
        style: style,
      ),
      items: items,
      selectedValue: selectedValue,
      onChanged: onChanged,
      enabled: enabled,
      orientation: orientation,
      loop: loop,
      semanticLabel: semanticLabel,
      excludeSemantics: excludeSemantics,
    );
  }
}
