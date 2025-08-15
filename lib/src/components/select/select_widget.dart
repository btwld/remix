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
    this.selectedValues,
    this.onSelectedValuesChanged,
    this.multiSelect = false,
    this.enabled = true,
    this.semanticLabel,
    this.closeOnSelect = true,
    this.autofocus = true,
    this.enableTypeAhead = true,
    this.typeAheadDebounceTime = const Duration(milliseconds: 500),
    this.style = const SelectStyle.create(),
  })  : assert(
          !(multiSelect == true && selectedValue != null),
          'Cannot use selectedValue with multiSelect mode',
        ),
        assert(
          !(multiSelect == false && selectedValues != null),
          'Cannot use selectedValues without multiSelect mode',
        );

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

  /// The currently selected values in multi-selection mode.
  final Set<T>? selectedValues;

  /// Called when the selected values change in multi-selection mode.
  final ValueChanged<Set<T>>? onSelectedValuesChanged;

  /// Whether to enable multi-selection mode.
  /// When true, multiple items can be selected.
  final bool multiSelect;

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

  /// Whether to enable type-ahead selection for quick keyboard navigation.
  /// When true, typing characters will focus matching items.
  final bool enableTypeAhead;

  /// Duration before resetting the type-ahead search buffer.
  /// Controls how long to wait between keystrokes when matching items.
  final Duration typeAheadDebounceTime;

  /// The style configuration for the select.
  final SelectStyle style;

  @override
  State<RemixSelect<T>> createState() => _RemixSelectState<T>();
}

class _RemixSelectState<T> extends State<RemixSelect<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  SelectStyle get _style => DefaultSelectStyle.merge(widget.style);

  @override
  Widget build(BuildContext context) {
    return StyleProvider<SelectSpec>(
      style: _style,
      child: StyleBuilder(
        style: _style,
        builder: (context, spec) {
          // Use default animation values since AnimatedData doesn't exist in Mix 2.0
          const duration = Duration(milliseconds: 150);
          const curve = Curves.easeInOut;

          if (widget.multiSelect) {
            // Multi-selection mode
            return _MultiSelectWrapper<T>(
              menu: _AnimatedOverlayMenu(
                controller: animationController,
                duration: duration,
                curve: curve,
                menuContainer: spec.menuContainer,
                items: widget.items,
              ),
              selectedValues: widget.selectedValues ?? {},
              onSelectedValuesChanged: widget.onSelectedValuesChanged,
              onStateChange: (value) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (value == OverlayChildLifecycleState.present) {
                    animationController.forward();
                  }
                });

                if (value == OverlayChildLifecycleState.pendingRemoval) {
                  animationController.reverse();
                }
              },
              removalDelay: duration,
              onClose: widget.onClose,
              onOpen: widget.onOpen,
              enabled: widget.enabled,
              semanticLabel: widget.semanticLabel,
              closeOnSelect: widget.closeOnSelect,
              autofocus: widget.autofocus,
              enableTypeAhead: widget.enableTypeAhead,
              typeAheadDebounceTime: widget.typeAheadDebounceTime,
              child: widget.child,
            );
          } // Single selection mode (existing behavior)

          return NakedSelect<T>(
            menu: _AnimatedOverlayMenu(
              controller: animationController,
              duration: duration,
              curve: curve,
              menuContainer: spec.menuContainer,
              items: widget.items,
            ),
            onClose: widget.onClose,
            onOpen: widget.onOpen,
            selectedValue: widget.selectedValue,
            onStateChange: (value) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (value == OverlayChildLifecycleState.present) {
                  animationController.forward();
                }
              });

              if (value == OverlayChildLifecycleState.pendingRemoval) {
                animationController.reverse();
              }
            },
            removalDelay: duration,
            onSelectedValueChanged: widget.onSelectedValueChanged,
            enabled: widget.enabled,
            semanticLabel: widget.semanticLabel,
            closeOnSelect: widget.closeOnSelect,
            autofocus: widget.autofocus,
            enableTypeAhead: widget.enableTypeAhead,
            typeAheadDebounceTime: widget.typeAheadDebounceTime,
            child: widget.child,
          );
        },
      ),
    );
  }
}

/// A wrapper widget for multi-selection mode that manages multiple selected values.
class _MultiSelectWrapper<T> extends StatefulWidget {
  const _MultiSelectWrapper({
    required this.menu,
    required this.selectedValues,
    required this.onSelectedValuesChanged,
    required this.child,
    required this.onStateChange,
    required this.removalDelay,
    this.onClose,
    this.onOpen,
    this.enabled = true,
    this.semanticLabel,
    this.closeOnSelect = false, // Default to false for multi-select
    this.autofocus = true,
    this.enableTypeAhead = true,
    this.typeAheadDebounceTime = const Duration(milliseconds: 500),
  });

  final Widget menu;
  final Set<T> selectedValues;
  final ValueChanged<Set<T>>? onSelectedValuesChanged;
  final Widget child;
  final ValueChanged<OverlayChildLifecycleState> onStateChange;
  final Duration removalDelay;
  final VoidCallback? onClose;
  final VoidCallback? onOpen;
  final bool enabled;
  final String? semanticLabel;
  final bool closeOnSelect;
  final bool autofocus;
  final bool enableTypeAhead;
  final Duration typeAheadDebounceTime;

  @override
  State<_MultiSelectWrapper<T>> createState() => _MultiSelectWrapperState<T>();
}

class _MultiSelectWrapperState<T> extends State<_MultiSelectWrapper<T>> {
  late Set<T> _selectedValues;

  @override
  void initState() {
    super.initState();
    _selectedValues = Set.of(widget.selectedValues);
  }

  void _handleItemSelection(T value) {
    setState(() {
      if (_selectedValues.contains(value)) {
        _selectedValues.remove(value);
      } else {
        _selectedValues.add(value);
      }
    });
    widget.onSelectedValuesChanged?.call(_selectedValues);
  }

  @override
  void didUpdateWidget(covariant _MultiSelectWrapper<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!setEquals(oldWidget.selectedValues, widget.selectedValues)) {
      _selectedValues = Set.of(widget.selectedValues);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use NakedSelect with custom handling for multi-selection
    return NakedSelect<T>(
      menu: widget.menu,
      onClose: widget.onClose,
      onOpen: widget.onOpen,
      selectedValue: null, // We don't use single selection
      onStateChange: widget.onStateChange,
      removalDelay: widget.removalDelay,
      onSelectedValueChanged: (value) {
        if (value != null) {
          _handleItemSelection(value);
        }
      },
      enabled: widget.enabled,
      semanticLabel: widget.semanticLabel,
      closeOnSelect: widget.closeOnSelect,
      autofocus: widget.autofocus,
      enableTypeAhead: widget.enableTypeAhead,
      typeAheadDebounceTime: widget.typeAheadDebounceTime,
      child: widget.child,
    );
  }
}

class _AnimatedOverlayMenu extends StatefulWidget {
  const _AnimatedOverlayMenu({
    required this.controller,
    required this.duration,
    required this.curve,
    required this.menuContainer,
    required this.items,
  });

  final AnimationController controller;
  final Duration duration;
  final Curve curve;
  final BoxSpec menuContainer;
  final List<Widget> items;

  @override
  State<_AnimatedOverlayMenu> createState() => _AnimatedOverlayMenuState();
}

class _AnimatedOverlayMenuState extends State<_AnimatedOverlayMenu> {
  late final Animation<double> fadeAnimation;
  late final Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    widget.controller.duration = widget.duration;
    fadeAnimation = CurvedAnimation(
      parent: widget.controller,
      curve: widget.curve,
    );
    scaleAnimation = CurvedAnimation(
      parent: widget.controller,
      curve: widget.curve,
    ).drive(Tween<double>(begin: 0.95, end: 1.0));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: fadeAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: scaleAnimation.value,
          child: Opacity(
            opacity: fadeAnimation.value,
            child: widget.menuContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: widget.items,
              ),
            ),
          ),
        );
      },
    );
  }
}

class RemixSelectTrigger extends StatefulWidget with Disableable, Focusable {
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
    with WidgetStateMixin, DisableableMixin {
  @override
  Widget build(BuildContext context) {
    final inheritedStyle = StyleProvider.maybeOf<SelectSpec>(context);

    return NakedSelectTrigger(
      onHoveredState: (value) => controller.hovered = value,
      onPressedState: (value) => controller.pressed = value,
      onFocusedState: (value) => controller.focused = value,
      semanticLabel: widget.semanticLabel,
      cursor: widget.cursor,
      enableHapticFeedback: widget.enableHapticFeedback,
      focusNode: widget.focusNode,
      child: StyleBuilder(
        style: inheritedStyle ?? const SelectStyle.create(),
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
        controller: controller,
      ),
    );
  }
}

class RemixSelectItem<T> extends StatefulWidget with Disableable, Focusable {
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
    with WidgetStateMixin, DisableableMixin {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Check if we're in multi-select mode by looking for MultiSelectWrapper ancestor
    final isMultiSelect =
        context.findAncestorWidgetOfExactType<_MultiSelectWrapper>() != null;

    // For multi-select, check if the value is in the selected set
    if (isMultiSelect) {
      final multiSelectWrapper =
          context.findAncestorStateOfType<_MultiSelectWrapperState<T>>();
      if (multiSelectWrapper != null) {
        controller.selected =
            multiSelectWrapper._selectedValues.contains(widget.value);
      }
    } else {
      final inherited = NakedSelectScope.of<T>(context);
      controller.selected = inherited.isSelected(context, widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get style from provider in build method
    final styleFromProvider = StyleProvider.maybeOf<SelectSpec>(context);
    // Check if we're in multi-select mode
    final isMultiSelect =
        context.findAncestorWidgetOfExactType<_MultiSelectWrapper>() != null;

    return NakedSelectItem<T>(
      value: widget.value,
      onHoveredState: (value) => controller.hovered = value,
      onPressedState: (value) => controller.pressed = value,
      onFocusedState: (value) => controller.focused = value,
      enabled: widget.enabled,
      semanticLabel: widget.semanticLabel,
      cursor: widget.cursor,
      enableHapticFeedback: widget.enableHapticFeedback,
      focusNode: widget.focusNode,
      child: StyleBuilder(
        style: styleFromProvider ?? const SelectStyle.create(),
        builder: (context, spec) {
          final itemSpec = spec.item;

          // Use checkbox icon for multi-select, check icon for single select
          final IconData selectionIcon = isMultiSelect
              ? (controller.selected
                  ? Icons.check_box
                  : Icons.check_box_outline_blank)
              : widget.trailingIcon;

          final defaultChild = itemSpec.container.flex(
            direction: Axis.horizontal,
            children: [Text(widget.label), Icon(selectionIcon)],
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
        controller: controller,
      ),
    );
  }
}
