// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'segmented_control.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Ui SegmentedControl recipe.
///
/// The track is a gray tint blended over the surface. The selected item sits
/// on a raised fill with a 1px edge, and turns medium weight.
///
/// Content icons use the size's 12, 16 or 20px default rather than the ambient
/// icon size. Control and item styles may override these defaults.
class UiSegmentedControl<T extends Object> extends StatelessWidget {
  const UiSegmentedControl({
    super.key,
    this.variant = .surface,
    this.size = .size2,
    this.style = const SegmentedControlStyler.create(),
    required this.items,
    required this.selectedValue,
    this.onChanged,
    this.enabled = true,
    this.orientation = .horizontal,
    this.loop = true,
    this.semanticLabel,
    this.excludeSemantics = false,
  });

  /// A gray track with a raised surface under the selected item.
  const UiSegmentedControl.surface({
    super.key,
    this.size = .size2,
    this.style = const SegmentedControlStyler.create(),
    required this.items,
    required this.selectedValue,
    this.onChanged,
    this.enabled = true,
    this.orientation = .horizontal,
    this.loop = true,
    this.semanticLabel,
    this.excludeSemantics = false,
  }) : variant = UiSegmentedControlVariant.surface;

  final UiSegmentedControlVariant variant;

  final UiSegmentedControlSize size;

  final SegmentedControlStyler style;

  final List<RemixSegmentedControlItem<T>> items;

  final T? selectedValue;

  final ValueChanged<T>? onChanged;

  final bool enabled;

  final Axis orientation;

  final bool loop;

  final String? semanticLabel;

  final bool excludeSemantics;

  @override
  Widget build(BuildContext context) {
    return RemixSegmentedControl<T>(
      key: this.key,
      style: uiSegmentedControlStyle(
        variant: this.variant,
        size: this.size,
        style: this.style,
      ),
      items: this.items,
      selectedValue: this.selectedValue,
      onChanged: this.onChanged,
      enabled: this.enabled,
      orientation: this.orientation,
      loop: this.loop,
      semanticLabel: this.semanticLabel,
      excludeSemantics: this.excludeSemantics,
    );
  }
}
