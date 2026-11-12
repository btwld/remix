// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'segmented_control.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's SegmentedControl recipe.
///
/// One control in parts: a recessed `muted` track with the chosen segment
/// lifted onto it, drawn like the filled tab list so the two read as a family.
/// It takes no variant; a second look would be a toggle group.
///
/// `item` is the default every `RemixSegmentedControlItem` resolves against, so
/// one recipe styles the track and its segments.
class PlaygroundSegmentedControl<T extends Object> extends StatelessWidget {
  const PlaygroundSegmentedControl({
    super.key,
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
      style: playgroundSegmentedControlStyle(style: this.style),
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
