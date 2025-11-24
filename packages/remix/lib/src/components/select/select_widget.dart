part of 'select.dart';

// ============================================================================
// DATA CLASSES - Trigger and Select Item
// ============================================================================

/// Data class representing a select trigger.
///
/// Used with [RemixSelect] to define the trigger button that opens the dropdown.
/// Displays placeholder text when no value is selected, or the selected value's label.
class RemixSelectTrigger {
  /// Placeholder text to display when no value is selected.
  final String placeholder;

  /// Optional icon to display before the label/placeholder.
  /// When provided, icon appears in leading position (before text).
  final IconData? icon;

  const RemixSelectTrigger({required this.placeholder, this.icon});
}

/// Data class representing a selectable option.
///
/// Used with [RemixSelect]'s items list to define selectable options.
class RemixSelectItem<T> {
  /// The value associated with this option.
  /// Passed to onChanged callback when selected.
  final T value;

  /// The text label to display.
  final String label;

  /// Whether this option can be selected.
  final bool enabled;

  /// The style for the item.
  final RemixSelectMenuItemStyle style;

  /// Semantic label for accessibility.
  final String? semanticLabel;

  const RemixSelectItem({
    required this.value,
    required this.label,
    this.enabled = true,
    this.style = const RemixSelectMenuItemStyle.create(),
    this.semanticLabel,
  });
}

// ============================================================================
// REMIX SELECT - Main select widget
// ============================================================================

/// A customizable select component with data-driven API.
///
/// Uses a simple, declarative API with data classes for trigger and items.
/// Form input component for selecting a single value from a dropdown list.
///
/// ## Example
///
/// ```dart
/// RemixSelect<String>(
///   trigger: RemixSelectTrigger(placeholder: 'Select a fruit'),
///   items: [
///     RemixSelectItem(value: 'apple', label: 'Apple'),
///     RemixSelectItem(value: 'banana', label: 'Banana'),
///     RemixSelectItem(value: 'orange', label: 'Orange'),
///   ],
///   selectedValue: selectedValue,
///   onChanged: (value) => setState(() => selectedValue = value),
/// )
/// ```
class RemixSelect<T> extends StatefulWidget {
  const RemixSelect({
    super.key,
    required this.trigger,
    required this.items,
    this.selectedValue,
    this.targetAnchor,
    this.followerAnchor,
    this.onChanged,
    this.onOpen,
    this.onClose,
    this.enabled = true,
    this.semanticLabel,
    this.closeOnSelect = true,
    this.focusNode,
    this.style = const RemixSelectStyle.create(),
  });

  /// The trigger data that defines the select's button.
  final RemixSelectTrigger trigger;

  /// The list of selectable items.
  final List<RemixSelectItem<T>> items;

  /// The currently selected value.
  final T? selectedValue;

  /// The target anchor for the dropdown.
  final Alignment? targetAnchor;

  /// The follower anchor for the dropdown.
  final Alignment? followerAnchor;

  /// Called when the selected value changes.
  final ValueChanged<T?>? onChanged;

  /// Called when the dropdown opens.
  final VoidCallback? onOpen;

  /// Called when the dropdown closes.
  final VoidCallback? onClose;

  /// Whether the select is enabled and can be interacted with.
  final bool enabled;

  /// Semantic label for accessibility.
  final String? semanticLabel;

  /// Whether to automatically close the dropdown when an item is selected.
  final bool closeOnSelect;

  /// Optional focus node to control focus behavior.
  final FocusNode? focusNode;

  /// The style configuration for the select.
  final RemixSelectStyle style;

  static late final styleFrom = RemixSelectStyle.new;

  @override
  State<RemixSelect<T>> createState() => _RemixSelectState<T>();
}

class _RemixSelectState<T> extends State<RemixSelect<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 150),
      vsync: this,
    );
  }

  RemixSelectStyle _buildStyle() {
    return RemixSelectStyle()
        .menuContainer(
          FlexBoxStyler().mainAxisSize(.min).wrap(.intrinsicWidth()),
        )
        .merge(widget.style);
  }

  Widget _buildOverlayMenu(RemixSelectSpec spec) {
    return _AnimatedOverlayMenu(
      controller: animationController,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
      menuContainer: spec.menuContainer,
      children: widget.items
          .map((item) => _RemixSelectItemWidget<T>(data: item))
          .toList(),
    );
  }

  String _getDisplayLabel() {
    if (widget.selectedValue == null) return widget.trigger.placeholder;

    // Find the selected item and get its label
    for (final item in widget.items) {
      if (item.value == widget.selectedValue) {
        return item.label;
      }
    }

    // Gracefully degrade in release mode - show placeholder
    return widget.trigger.placeholder;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NakedSelect<T>(
      overlayBuilder: (context, info) {
        return StyleBuilder<RemixSelectSpec>(
          style: _buildStyle(),
          builder: (context, spec) => _buildOverlayMenu(spec),
        );
      },
      value: widget.selectedValue,
      onChanged: widget.onChanged,
      closeOnSelect: widget.closeOnSelect,
      enabled: widget.enabled,
      triggerFocusNode: widget.focusNode,
      semanticLabel: widget.semanticLabel,
      positioning: OverlayPositionConfig(
        targetAnchor: widget.targetAnchor ?? Alignment.bottomCenter,
        followerAnchor: widget.followerAnchor ?? Alignment.topCenter,
      ),
      onOpen: () {
        animationController.forward();
        widget.onOpen?.call();
      },
      onClose: () {
        animationController.reverse();
        widget.onClose?.call();
      },
      builder: (context, state, _) {
        return StyleBuilder<RemixSelectSpec>(
          style: _buildStyle(),
          controller: NakedState.controllerOf(context),
          builder: (context, spec) {
            return _RemixSelectTriggerWidget(
              trigger: widget.trigger,
              displayLabel: _getDisplayLabel(),
              isOpen: state.isOpen,
              styleSpec: spec.trigger,
            );
          },
        );
      },
    );
  }
}

class _AnimatedOverlayMenu extends StatefulWidget {
  const _AnimatedOverlayMenu({
    required this.controller,
    required this.duration,
    required this.curve,
    required this.menuContainer,
    required this.children,
  });

  final AnimationController controller;
  final Duration duration;
  final Curve curve;
  final StyleSpec<FlexBoxSpec> menuContainer;
  final List<Widget> children;

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
            child: ColumnBox(
              styleSpec: widget.menuContainer,
              children: widget.children,
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// INTERNAL WIDGETS - Trigger, Item, and Label
// ============================================================================

/// Internal widget for rendering the select trigger.
class _RemixSelectTriggerWidget extends StatelessWidget {
  const _RemixSelectTriggerWidget({
    required this.trigger,
    required this.displayLabel,
    required this.isOpen,
    required this.styleSpec,
  });

  final RemixSelectTrigger trigger;
  final String displayLabel;
  final bool isOpen;
  final StyleSpec<RemixSelectTriggerSpec> styleSpec;

  @override
  Widget build(BuildContext context) {
    return StyleSpecBuilder<RemixSelectTriggerSpec>(
      styleSpec: styleSpec,
      builder: (context, spec) {
        return RowBox(
          styleSpec: spec.container,
          children: [
            if (trigger.icon != null)
              StyledIcon(icon: trigger.icon!, styleSpec: spec.icon),
            // ignore: avoid-flexible-outside-flex
            Expanded(child: StyledText(displayLabel, styleSpec: spec.label)),
            StyledIcon(
              icon: isOpen
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              styleSpec: spec.icon,
            ),
          ],
        );
      },
    );
  }
}

/// Internal widget for rendering a selectable item.
class _RemixSelectItemWidget<T> extends StatelessWidget {
  const _RemixSelectItemWidget({required this.data});

  final RemixSelectItem<T> data;

  @override
  Widget build(BuildContext context) {
    return NakedSelect.Option<T>(
      enabled: data.enabled,
      semanticLabel: data.semanticLabel ?? data.label,
      value: data.value,
      builder: (context, states, _) {
        return StyleBuilder(
          style: data.style,
          controller: NakedState.controllerOf(context),
          builder: (context, spec) {
            return StyleSpecBuilder<RemixSelectMenuItemSpec>(
              styleSpec: StyleSpec(spec: spec),
              builder: (context, spec) {
                return RowBox(
                  styleSpec: spec.container,
                  children: [
                    // ignore: avoid-flexible-outside-flex
                    Expanded(
                      child: StyledText(data.label, styleSpec: spec.text),
                    ),
                    if (states.isSelected)
                      StyledIcon(icon: Icons.check, styleSpec: spec.icon),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
