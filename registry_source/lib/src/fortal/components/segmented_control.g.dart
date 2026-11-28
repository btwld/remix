// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'segmented_control.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal SegmentedControl recipe.
///
/// A muted track inside a 1px border holds content-width segments. One raised
/// pill, the surface fill with a border and the resting shadow, glides to the
/// selected segment on the snappy spring. Labels are muted until hovered,
/// pressed or selected, and never change weight.
///
/// Content icons use 16px (12px at size 1) rather than the ambient icon size.
/// Control and item styles may override these defaults.
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
