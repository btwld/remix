part of 'select.dart';

/// A customizable select component that supports single and multiple selection modes,
/// various styles, and behaviors. The select component integrates with the Mix styling
/// system and follows Remix design patterns.
///
/// ## Example
///
/// ```dart
/// RxSelect(
///   selectedValue: _value,
///   onSelectedValueChanged: (value) {
///     setState(() {
///       _value = value;
///     });
///   },
///   items: Options.values
///       .map((e) => RxSelectItem(value: e, label: e.name.capitalize()))
///       .toList(),
///   style: RxSelectStyle()
///     ..trigger.container.width(200)
///     ..trigger.container.flex.mainAxisAlignment.spaceBetween(),
///   child: RxSelectTrigger(
///     label: _value?.name.capitalize() ?? 'Select an item',
///   ),
/// )
/// ```
class RxSelect<T> extends StatefulWidget {
  const RxSelect({
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
    this.enableTypeAhead = true,
    this.typeAheadDebounceTime = const Duration(milliseconds: 500),
    this.style,
    this.variants = const [],
  })  : selectedValues = null,
        onSelectedValuesChanged = null;

  /// The target widget that triggers the select dropdown.
  /// This should typically be a [RxSelectTrigger].
  final Widget child;

  /// The menu widget to display when the dropdown is open.
  /// This should be a [RxNakedSelectMenu] containing [RxSelectItem] widgets.
  final List<Widget> items;

  /// Called when the menu closes, either through selection or external interaction.
  final VoidCallback? onClose;

  /// The currently selected value in single selection mode.
  /// Only used when [allowMultiple] is false.
  final T? selectedValue;

  /// Called when the selected value changes in single selection mode.
  /// Only used when [allowMultiple] is false.
  final ValueChanged<T?>? onSelectedValueChanged;

  /// The set of currently selected values in multiple selection mode.
  /// Required when [allowMultiple] is true.
  final Set<T>? selectedValues;

  /// Called when selected values change in multiple selection mode.
  /// Only used when [allowMultiple] is true.
  final ValueChanged<Set<T>>? onSelectedValuesChanged;

  /// Whether the select is enabled and can be interacted with.
  /// When false, all interaction is disabled and the trigger shows a forbidden cursor.
  final bool enabled;

  /// Semantic label for accessibility.
  /// Used by screen readers to identify the select component.
  final String? semanticLabel;

  /// Whether to automatically close the dropdown when an item is selected.
  /// Set to false to keep the menu open after selection, useful for multiple selection.
  final bool closeOnSelect;

  /// Whether to automatically focus the menu when opened.
  /// When true, enables immediate keyboard navigation.
  final bool autofocus;

  /// Whether to enable type-ahead selection for quick keyboard navigation.
  /// When true, typing characters will focus matching items.
  final bool enableTypeAhead;

  /// Duration before resetting the type-ahead search buffer.
  /// Controls how long to wait between keystrokes when matching items.
  final Duration typeAheadDebounceTime;

  /// Called when the menu is opened.
  final VoidCallback? onOpen;

  /// {@macro remix.component.style}
  final RxSelectStyle? style;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  @override
  State<RxSelect<T>> createState() => _RxSelectState<T>();
}

class _RxSelectState<T> extends State<RxSelect<T>>
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

  RxSelectStyle get _style =>
      RxSelectStyle._default().merge(widget.style ?? RxSelectStyle());

  @override
  Widget build(BuildContext context) {
    return StyleScope<RxSelectStyle>(
      style: _style,
      variants: widget.variants,
      child: MixBuilder(
        style: Style(_style),
        builder: (context) {
          final spec = SelectSpec.of(context);

          final animatedData = spec.menuContainer.animated ??
              const AnimatedData(
                duration: Duration(milliseconds: 150),
                curve: Curves.easeInOut,
              );

          return NakedSelect<T>(
            menu: _AnimatedOverlayMenu(
              controller: animationController,
              data: animatedData,
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
            removalDelay: animatedData.duration,
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

class _AnimatedOverlayMenu extends StatefulWidget {
  const _AnimatedOverlayMenu({
    required this.controller,
    required this.data,
    required this.menuContainer,
    required this.items,
  });

  final AnimationController controller;
  final AnimatedData data;
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

    widget.controller.duration = widget.data.duration;
    fadeAnimation = CurvedAnimation(
      parent: widget.controller,
      curve: widget.data.curve,
    );
    scaleAnimation = CurvedAnimation(
      parent: widget.controller,
      curve: widget.data.curve,
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

class RxSelectTrigger extends StatefulWidget implements Disableable {
  const RxSelectTrigger({
    super.key,
    this.enabled = true,
    this.semanticLabel,
    this.cursor = SystemMouseCursors.click,
    this.enableHapticFeedback = true,
    this.focusNode,
    required this.label,
    this.trailingIcon = Icons.keyboard_arrow_down,
  }) : child = null;

  const RxSelectTrigger.raw({
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
  State<RxSelectTrigger> createState() => _RxSelectTriggerState();
}

class _RxSelectTriggerState extends State<RxSelectTrigger>
    with MixControllerMixin, DisableableMixin {
  StyleScope<RxSelectStyle> get styleScope {
    final style = StyleScope.of<RxSelectStyle>(context);
    if (style == null) {
      throw Exception(
        'RxSelectTrigger should be used inside a RxSelect. '
        'Make sure RxSelect is wrapping RxSelectTrigger.',
      );
    }

    return style;
  }

  @override
  Widget build(BuildContext context) {
    return NakedSelectTrigger(
      onHoverState: (value) {
        mixController.hovered = value;
      },
      onPressedState: (value) {
        mixController.pressed = value;
      },
      onFocusState: (value) {
        mixController.focused = value;
      },
      semanticLabel: widget.semanticLabel,
      cursor: widget.cursor,
      enableHapticFeedback: widget.enableHapticFeedback,
      focusNode: widget.focusNode,
      child: RemixBuilder(
        builder: (context) {
          final spec = SelectSpec.of(context);

          final defaultChild = spec.trigger.container.flex(
            direction: Axis.horizontal,
            children: [
              spec.trigger.label(widget.label),
              if (widget.trailingIcon != null) Icon(widget.trailingIcon!),
            ],
          );

          return IconTheme(
            data: spec.trigger.icon,
            child:
                spec.trigger.container.box(child: widget.child ?? defaultChild),
          );
        },
        style: Style(styleScope.style).applyVariants(styleScope.variants),
        controller: mixController,
      ),
    );
  }
}

class RxSelectItem<T> extends StatefulWidget implements Disableable {
  const RxSelectItem({
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

  const RxSelectItem.raw({
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
  State<RxSelectItem<T>> createState() => _RxSelectItemState<T>();
}

class _RxSelectItemState<T> extends State<RxSelectItem<T>>
    with MixControllerMixin, DisableableMixin {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final inherited = NakedSelectInherited.maybeOf<T>(context);

    if (inherited == null) {
      throw Exception(
        'RxSelectItem should be used inside a RxSelect. '
        'Make sure RxSelect is wrapping RxSelectItem.',
      );
    }

    mixController.selected = inherited.isSelected(context, widget.value);
  }

  StyleScope<RxSelectStyle> get _styleScope =>
      StyleScope.of<RxSelectStyle>(context)!;

  @override
  Widget build(BuildContext context) {
    return NakedSelectItem<T>(
      value: widget.value,
      onHoverState: (value) {
        mixController.hovered = value;
      },
      onPressedState: (value) {
        mixController.pressed = value;
      },
      onFocusState: (value) {
        mixController.focused = value;
      },
      onSelectState: (value) {
        mixController.selected = value;
      },
      enabled: widget.enabled,
      semanticLabel: widget.semanticLabel,
      cursor: widget.cursor,
      enableHapticFeedback: widget.enableHapticFeedback,
      focusNode: widget.focusNode,
      child: RemixBuilder(
        builder: (context) {
          final spec = SelectSpec.of(context);

          final defaultChild = spec.item.container.flex(
            direction: Axis.horizontal,
            children: [Text(widget.label), Icon(widget.trailingIcon)],
          );

          return IconTheme(
            data: spec.item.icon,
            child: DefaultTextStyle(
              style: spec.item.textStyle,
              child: spec.item.container.box(
                child: widget.child ?? defaultChild,
              ),
            ),
          );
        },
        style: Style(_styleScope.style).applyVariants(_styleScope.variants),
        controller: mixController,
      ),
    );
  }
}
