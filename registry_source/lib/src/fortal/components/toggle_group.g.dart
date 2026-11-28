// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toggle_group.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal ToggleGroup recipe: items inside a padded 1px frame, with one
/// fill that glides to the item that is on.
///
/// It reads top to bottom: the frame, the gliding fill, the item's look for
/// rest, hover, press, on, focus and disabled, then the size.
///
/// [highContrast] draws resting item text in ink and the frame in the strong
/// border.
class FortalToggleGroup<T> extends StatelessWidget {
  const FortalToggleGroup({
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

  /// The accent's indicator mixed into the surface behind the on item.
  const FortalToggleGroup.soft({
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
  }) : variant = FortalToggleGroupVariant.soft;

  /// The muted fill inside a 1px border behind the on item.
  const FortalToggleGroup.surface({
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
  }) : variant = FortalToggleGroupVariant.surface;

  final FortalToggleGroupVariant variant;

  final FortalToggleGroupSize size;

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
      style: fortalToggleGroupStyle(
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
