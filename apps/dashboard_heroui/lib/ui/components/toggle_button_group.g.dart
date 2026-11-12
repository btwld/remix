// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toggle_button_group.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixToggleGroup]: toggle buttons joined into one pill,
/// or [detached] with a gap.
///
/// Remix's group selects one item at a time; HeroUI's also offers multiple
/// selection. Items share the toggle button's looks without its pressed scale
/// (`.toggle-button-group .toggle-button:active`). The focus ring is drawn
/// inside each item, as upstream's `ring-inset`, so the group's clip keeps it,
/// except at the joined pill's rounded ends.
class UiToggleButtonGroup<T> extends StatelessWidget {
  const UiToggleButtonGroup({
    super.key,
    this.variant = .defaultToggle,
    this.size = .md,
    this.iconOnly = false,
    this.detached = false,
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

  const UiToggleButtonGroup.defaultToggle({
    super.key,
    this.size = .md,
    this.iconOnly = false,
    this.detached = false,
    this.style = const ToggleGroupStyler.create(),
    required this.items,
    required this.selectedValue,
    this.onChanged,
    this.enabled = true,
    this.orientation = .horizontal,
    this.loop = true,
    this.semanticLabel,
    this.excludeSemantics = false,
  }) : variant = UiToggleButtonVariant.defaultToggle;

  const UiToggleButtonGroup.ghost({
    super.key,
    this.size = .md,
    this.iconOnly = false,
    this.detached = false,
    this.style = const ToggleGroupStyler.create(),
    required this.items,
    required this.selectedValue,
    this.onChanged,
    this.enabled = true,
    this.orientation = .horizontal,
    this.loop = true,
    this.semanticLabel,
    this.excludeSemantics = false,
  }) : variant = UiToggleButtonVariant.ghost;

  final UiToggleButtonVariant variant;

  final UiToggleButtonSize size;

  final bool iconOnly;

  final bool detached;

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
      style: uiToggleButtonGroupStyle(
        variant: this.variant,
        size: this.size,
        iconOnly: this.iconOnly,
        detached: this.detached,
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
