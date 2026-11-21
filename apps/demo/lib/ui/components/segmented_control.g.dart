// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'segmented_control.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal SegmentedControl recipe.
///
/// The track is a gray tint blended over the surface. The selected item sits
/// on a raised fill with a 1px edge, and turns medium weight.
///
/// Content icons use the size's 12, 16 or 20px default rather than the ambient
/// icon size. Control and item styles may override these defaults.
class FortalSegmentedControl<T extends Object> extends StatelessWidget {
  const FortalSegmentedControl({
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
  });

  final FortalSegmentedControlSize size;

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
  Widget build(BuildContext _) {
    return RemixSegmentedControl<T>(
      style: fortalSegmentedControlStyle(size: size, style: style),
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
