part of 'select.dart';

/// A customizable select component that supports single selection modes,
/// various styles, and behaviors. The select component integrates with the Mix styling
/// system and follows Remix design patterns.
///
/// ## Example
///
/// ```dart
/// RemixSelect<String>(
///   selectedValue: _value,
///   onSelectedValueChanged: (value) {
///     setState(() {
///       _value = value;
///     });
///   },
///   items: ['Option 1', 'Option 2', 'Option 3']
///       .map((e) => RemixSelectItem(value: e, label: e))
///       .toList(),
///   style: SelectStyle(),
///   child: RemixSelectTrigger(
///     label: _value ?? 'Select an item',
///   ),
/// )
/// ```
class RemixSelect<T> extends StatefulWidget {
  const RemixSelect({
    super.key,
    required this.child,
    required this.items,
    this.onClose,
    this.onOpen,
    this.selectedValue,
    this.onSelectedValueChanged,
    this.enabled = true,
    this.semanticLabel,
    this.closeOnSelect = true,
    this.autofocus = true,
    this.style,
    this.variants = const [],
  });

  /// The target widget that triggers the select dropdown.
  /// This should typically be a [RemixSelectTrigger].
  final Widget child;

  /// The menu items to display when the dropdown is open.
  /// This should be a list of [RemixSelectItem] widgets.
  final List<Widget> items;

  /// Called when the menu closes, either through selection or external interaction.
  final VoidCallback? onClose;

  /// The currently selected value in single selection mode.
  final T? selectedValue;

  /// Called when the selected value changes in single selection mode.
  final ValueChanged<T?>? onSelectedValueChanged;

  /// Whether the select is enabled and can be interacted with.
  /// When false, all interaction is disabled and the trigger shows a forbidden cursor.
  final bool enabled;

  /// Semantic label for accessibility.
  /// Used by screen readers to identify the select component.
  final String? semanticLabel;

  /// Whether to automatically close the dropdown when an item is selected.
  /// Set to false to keep the menu open after selection.
  final bool closeOnSelect;

  /// Whether to automatically focus the menu when opened.
  /// When true, enables immediate keyboard navigation.
  final bool autofocus;

  /// Called when the menu is opened.
  final VoidCallback? onOpen;

  /// The style configuration for the select.
  final SelectStyle? style;

  /// List of style variants to apply.
  final List<Variant> variants;

  @override
  State<RemixSelect<T>> createState() => _RemixSelectState<T>();
}

class _RemixSelectState<T> extends State<RemixSelect<T>> {
  SelectStyle get _style =>
      DefaultSelectStyle.merge(widget.style ?? SelectStyle());

  @override
  Widget build(BuildContext context) {
    return StyleBuilder(
      style: _style,
      builder: (context, spec) {
        // Simplified implementation for demonstration
        // In a real implementation, this would integrate with NakedSelect
        // and handle menu positioning, animations, etc.
        return GestureDetector(
          onTap: widget.enabled
              ? () {
                  // Show menu logic here
                  widget.onOpen?.call();
                }
              : null,
          child: widget.child,
        );
      },
    );
  }
}

class RemixSelectTrigger extends StatefulWidget implements Disableable {
  const RemixSelectTrigger({
    super.key,
    this.enabled = true,
    this.semanticLabel,
    this.cursor = SystemMouseCursors.click,
    this.enableHapticFeedback = true,
    this.focusNode,
    required this.label,
    this.trailingIcon = Icons.keyboard_arrow_down,
  }) : child = null;

  const RemixSelectTrigger.raw({
    super.key,
    this.enabled = true,
    this.semanticLabel,
    this.cursor = SystemMouseCursors.click,
    this.enableHapticFeedback = true,
    this.focusNode,
    required this.child,
  })  : label = '',
        trailingIcon = null;

  /// The child widget to display in the trigger.
  /// This is used when the raw constructor is used.
  final Widget? child;

  /// Whether the trigger is enabled and can be interacted with.
  /// When false, all interaction is disabled.
  @override
  final bool enabled;

  /// The label to display on the trigger.
  final String label;

  /// Semantic label for accessibility.
  /// Used by screen readers to identify the trigger.
  final String? semanticLabel;

  /// The cursor to show when hovering over the trigger.
  /// Defaults to [SystemMouseCursors.click].
  final MouseCursor cursor;

  /// Whether to provide haptic feedback when tapped.
  /// Defaults to true.
  final bool enableHapticFeedback;

  /// Optional focus node to control focus behavior.
  /// If not provided, a new focus node will be created.
  final FocusNode? focusNode;

  /// The icon to display on the trigger.
  final IconData? trailingIcon;

  @override
  State<RemixSelectTrigger> createState() => _RemixSelectTriggerState();
}

class _RemixSelectTriggerState extends State<RemixSelectTrigger>
    with MixControllerMixin, DisableableMixin {
  @override
  Widget build(BuildContext context) {
    return NakedButton(
      onPressed: widget.enabled ? () {} : null,
      onHoverState: (state) => stateController.hovered = state,
      onPressedState: (state) => stateController.pressed = state,
      onFocusState: (state) => stateController.focused = state,
      semanticLabel: widget.semanticLabel,
      cursor: widget.cursor,
      enableHapticFeedback: widget.enableHapticFeedback,
      focusNode: widget.focusNode,
      child: StyleBuilder(
        style: DefaultSelectStyle,
        builder: (context, spec) {
          final triggerSpec = spec.trigger;

          final defaultChild = triggerSpec.container.flex(
            direction: Axis.horizontal,
            children: [
              triggerSpec.label(widget.label),
              if (widget.trailingIcon != null) Icon(widget.trailingIcon!),
            ],
          );

          return IconTheme(
            data: triggerSpec.icon,
            child:
                triggerSpec.container.box(child: widget.child ?? defaultChild),
          );
        },
        controller: stateController,
      ),
    );
  }
}

class RemixSelectItem<T> extends StatefulWidget implements Disableable {
  const RemixSelectItem({
    super.key,
    required this.value,
    required this.label,
    this.trailingIcon = Icons.check,
    this.enabled = true,
    this.semanticLabel,
    this.cursor = SystemMouseCursors.click,
    this.enableHapticFeedback = true,
    this.focusNode,
  }) : child = null;

  const RemixSelectItem.raw({
    super.key,
    required this.value,
    required this.child,
    this.enabled = true,
    this.semanticLabel,
    this.cursor = SystemMouseCursors.click,
    this.enableHapticFeedback = true,
    this.focusNode,
  })  : label = '',
        trailingIcon = Icons.check;

  /// The value associated with this item.
  /// This value will be passed to the select's onChange callback when selected.
  final T value;

  /// The label to display on the item.
  final String label;

  /// The icon to display on the item.
  final IconData trailingIcon;

  /// Whether this item is enabled and can be selected.
  /// When false, all interaction is disabled.
  @override
  final bool enabled;

  /// Semantic label for accessibility.
  /// Used by screen readers to identify the item.
  final String? semanticLabel;

  /// The cursor to show when hovering over this item.
  /// Defaults to [SystemMouseCursors.click].
  final MouseCursor cursor;

  /// Whether to provide haptic feedback when selected.
  /// Defaults to true.
  final bool enableHapticFeedback;

  /// Optional focus node to control focus behavior.
  /// If not provided, a new focus node will be created.
  final FocusNode? focusNode;

  /// The icon to display on the item.
  final Widget? child;

  @override
  State<RemixSelectItem<T>> createState() => _RemixSelectItemState<T>();
}

class _RemixSelectItemState<T> extends State<RemixSelectItem<T>>
    with MixControllerMixin, DisableableMixin {
  @override
  Widget build(BuildContext context) {
    return NakedButton(
      onPressed: widget.enabled
          ? () {
              // Handle selection logic here
            }
          : null,
      onHoverState: (state) => stateController.hovered = state,
      onPressedState: (state) => stateController.pressed = state,
      onFocusState: (state) => stateController.focused = state,
      enabled: widget.enabled,
      semanticLabel: widget.semanticLabel,
      cursor: widget.cursor,
      enableHapticFeedback: widget.enableHapticFeedback,
      focusNode: widget.focusNode,
      child: StyleBuilder(
        style: DefaultSelectStyle,
        builder: (context, spec) {
          final itemSpec = spec.item;

          final defaultChild = itemSpec.container.flex(
            direction: Axis.horizontal,
            children: [Text(widget.label), Icon(widget.trailingIcon)],
          );

          return IconTheme(
            data: itemSpec.icon,
            child: DefaultTextStyle(
              style: itemSpec.textStyle,
              child: itemSpec.container.box(
                child: widget.child ?? defaultChild,
              ),
            ),
          );
        },
        controller: stateController,
      ),
    );
  }
}
