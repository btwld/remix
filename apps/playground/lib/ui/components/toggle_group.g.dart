// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toggle_group.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's ToggleGroup recipe.
///
/// Toggles that share one selection, drawn as one control: options edge to edge
/// with no gap, the strip rounded and clipped as a whole, and the outline
/// variant drawing one outline around the strip. Each option has the single
/// toggle's states: `muted` under the pointer, `accent` while on.
///
/// `item` is the default every `RemixToggleGroupItem` resolves against, so one
/// recipe styles the strip and its options.
class PlaygroundToggleGroup<T> extends StatelessWidget {
  const PlaygroundToggleGroup({
    super.key,
    this.variant = .ghost,
    this.size = .medium,
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

  /// No fill and no border until an option is hovered or on.
  const PlaygroundToggleGroup.ghost({
    super.key,
    this.size = .medium,
    this.style = const ToggleGroupStyler.create(),
    required this.items,
    required this.selectedValue,
    this.onChanged,
    this.enabled = true,
    this.orientation = .horizontal,
    this.loop = true,
    this.semanticLabel,
    this.excludeSemantics = false,
  }) : variant = PlaygroundToggleGroupVariant.ghost;

  /// An `input` outline around the whole group, so the set is visible while
  /// off.
  const PlaygroundToggleGroup.outline({
    super.key,
    this.size = .medium,
    this.style = const ToggleGroupStyler.create(),
    required this.items,
    required this.selectedValue,
    this.onChanged,
    this.enabled = true,
    this.orientation = .horizontal,
    this.loop = true,
    this.semanticLabel,
    this.excludeSemantics = false,
  }) : variant = PlaygroundToggleGroupVariant.outline;

  final PlaygroundToggleGroupVariant variant;

  final PlaygroundToggleGroupSize size;

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
  Widget build(BuildContext context) {
    return RemixToggleGroup<T>(
      key: this.key,
      style: playgroundToggleGroupStyle(
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
