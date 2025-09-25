part of 'select.dart';

/// Builder function for customizing select trigger rendering.
typedef RemixSelectTriggerBuilder<T> = Widget Function(
  BuildContext context,
  RemixSelectTriggerSpec spec,
  T? selectedValue,
  bool isOpen,
);

/// Builder function for customizing select item rendering.
typedef RemixSelectItemBuilder<T> = Widget Function(
  BuildContext context,
  RemixSelectMenuItemSpec spec,
  T value,
  bool isSelected,
);

/// A customizable select component that supports single selection modes,
/// various styles, and behaviors. The select component integrates with the Mix styling
/// system and follows Remix design patterns.
///
/// ## Example
///
/// ```dart
/// RemixSelect<String>(
///   selectedValue: _value,
///   onChanged: (value) {
///     setState(() {
///       _value = value;
///     });
///   },
///   items: ['Option 1', 'Option 2', 'Option 3']
///       .map((e) => RemixSelectItem(value: e, label: e))
///       .toList(),
///   style: SelectStyle(),
///   triggerBuilder: (context, spec, value, isOpen) {
///     return RowBox(
///       styleSpec: spec.container,
///       children: [
///         Expanded(child: StyledText(value ?? 'Select an item', styleSpec: spec.label)),
///         StyledIcon(
///           icon: isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
///           styleSpec: spec.icon,
///         ),
///       ],
///     );
///   },
/// )
/// ```
class RemixSelect<T> extends StatefulWidget {
  const RemixSelect({
    super.key,
    this.triggerBuilder,
    required this.items,
    this.onClose,
    this.onOpen,
    this.selectedValue,
    this.onChanged,
    this.enabled = true,
    this.semanticLabel,
    this.closeOnSelect = true,
    this.autofocus = false,
    this.focusNode,
    this.style = const RemixSelectStyle.create(),
  });

  /// Optional builder function for customizing the trigger widget.
  /// If null, a default trigger will be created.
  final RemixSelectTriggerBuilder<T>? triggerBuilder;

  /// The menu items to display when the dropdown is open.
  /// This should be a list of [RemixSelectItem] widgets.
  final List<Widget> items;

  /// Called when the menu closes, either through selection or external interaction.
  final VoidCallback? onClose;

  /// The currently selected value in single selection mode.
  final T? selectedValue;

  /// Called when the selected value changes in single selection mode.
  final ValueChanged<T?>? onChanged;

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

  /// Optional focus node to control focus behavior.
  final FocusNode? focusNode;

  /// The style configuration for the select.
  final RemixSelectStyle style;

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

  Widget _buildOverlayMenu(RemixSelectSpec spec) => _AnimatedOverlayMenu(
        controller: animationController,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        menuContainer: spec.menuContainer,
        items: widget.items,
      );

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  RemixSelectStyle get _style => widget.style;

  @override
  Widget build(BuildContext context) {
    return StyleProvider<RemixSelectSpec>(
      style: _style,
      child: StyleBuilder<RemixSelectSpec>(
        style: _style,
        builder: (context, spec) {
          return NakedSelect<T>(
            overlayBuilder: (context, info) => _buildOverlayMenu(spec),
            value: widget.selectedValue,
            onChanged: widget.onChanged,
            closeOnSelect: widget.closeOnSelect,
            enabled: widget.enabled,
            triggerFocusNode: widget.focusNode,
            semanticLabel: widget.semanticLabel,
            onOpen: () {
              animationController.forward();
              widget.onOpen?.call();
            },
            onClose: () {
              animationController.reverse();
              widget.onClose?.call();
            },
            builder: (context, state, _) {
              return StyleSpecBuilder<RemixSelectTriggerSpec>(
                styleSpec: spec.trigger,
                builder: (context, triggerSpec) {
                  if (widget.triggerBuilder != null) {
                    return widget.triggerBuilder!(
                      context,
                      triggerSpec,
                      widget.selectedValue,
                      state.isOpen,
                    );
                  }

                  // Default trigger when no builder provided
                  return RowBox(
                    styleSpec: triggerSpec.container,
                    children: [
                      Expanded(
                        child: StyledText(
                          widget.selectedValue?.toString() ??
                              'Select an option',
                          styleSpec: triggerSpec.label,
                        ),
                      ),
                      StyledIcon(
                        icon: state.isOpen
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        styleSpec: triggerSpec.icon,
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
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
  final StyleSpec<BoxSpec> menuContainer;
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
            child: Box(
              styleSpec: widget.menuContainer,
              child: Column(children: widget.items),
            ),
          ),
        );
      },
    );
  }
}

class RemixSelectItem<T> extends StatelessWidget {
  const RemixSelectItem({
    super.key,
    required this.value,
    this.label,
    this.trailing = Icons.check,
    this.enabled = true,
    this.semanticLabel,
    this.child,
    this.itemBuilder,
    this.style,
  }) : assert(
          label != null || child != null || itemBuilder != null,
          'Must provide either label, child, or itemBuilder',
        );

  /// The value associated with this item.
  /// This value will be passed to the select's onChange callback when selected.
  final T value;

  /// The label to display on the item.
  final String? label;

  /// The icon to display on the item.
  final IconData trailing;

  /// Whether this item is enabled and can be selected.
  /// When false, all interaction is disabled.
  final bool enabled;

  /// Semantic label for accessibility.
  /// Used by screen readers to identify the item.
  final String? semanticLabel;

  /// Custom child widget that overrides the default label and icon layout.
  final Widget? child;

  /// Optional builder function for customizing the item widget.
  /// If provided, overrides label, trailing, and child.
  final RemixSelectItemBuilder<T>? itemBuilder;

  /// Optional style for this specific item.
  /// If provided, overrides the inherited style.
  final RemixSelectStyle? style;

  @override
  Widget build(BuildContext context) {
    // Get style from provider in build method, allow override with style
    final styleFromProvider = StyleProvider.maybeOf<RemixSelectSpec>(context);
    final effectiveStyle =
        style ?? styleFromProvider ?? const RemixSelectStyle.create();

    // NakedSelect.Option handles semantics internally, no outer Semantics needed
    return NakedSelect.Option<T>(
      enabled: enabled,
      semanticLabel: semanticLabel ?? label,
      value: value,
      builder: (context, states, _) {
        return StyleBuilder<RemixSelectSpec>(
          style: effectiveStyle,
          controller: NakedState.controllerOf(context),
          builder: (context, spec) {
            final itemSpec = spec.item;

            // Build item content progressively
            Widget itemContent;

            // Use itemBuilder if provided
            if (itemBuilder != null) {
              itemContent = StyleSpecBuilder<RemixSelectMenuItemSpec>(
                styleSpec: itemSpec,
                builder: (context, resolvedItemSpec) {
                  return itemBuilder!(
                    context,
                    resolvedItemSpec,
                    value,
                    states.isSelected,
                  );
                },
              );
            } else if (child != null) {
              // Use custom child if provided
              itemContent = child!;
            } else if (label != null) {
              // Default content with label using StyleSpecBuilder
              itemContent = StyleSpecBuilder<RemixSelectMenuItemSpec>(
                styleSpec: itemSpec,
                builder: (context, resolvedItemSpec) {
                  return RowBox(
                    styleSpec: resolvedItemSpec.container,
                    children: [
                      StyledText(label!, styleSpec: resolvedItemSpec.text),
                      if (states.isSelected)
                        StyledIcon(
                          icon: trailing,
                          styleSpec: resolvedItemSpec.icon,
                        ),
                    ],
                  );
                },
              );
            } else {
              // Fallback to empty widget
              itemContent = const SizedBox.shrink();
            }

            return itemContent;
          },
        );
      },
    );
  }
}
