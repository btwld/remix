part of 'accordion.dart';

// Controller
class RemixAccordionController<T> extends NakedAccordionController<T> {
  RemixAccordionController({super.min, super.max});
}

// Main Accordion Widget
class RemixAccordion<T> extends StatefulWidget {
  const RemixAccordion({
    super.key,
    required this.children,
    this.initialExpandedValues = const [],
    this.controller,
    this.style = const RemixAccordionStyle.create(),
    this.defaultTrailing = Icons.keyboard_arrow_down_rounded,
  });

  final List<RemixAccordionItem<T>> children;
  final List<T> initialExpandedValues;
  final RemixAccordionController<T>? controller;
  final RemixAccordionStyle style;
  final IconData defaultTrailing;

  @override
  State<RemixAccordion<T>> createState() => _RemixAccordionState<T>();
}

class _RemixAccordionState<T> extends State<RemixAccordion<T>> {
  late final NakedAccordionController<T> _controller =
      widget.controller ?? RemixAccordionController<T>();

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedAccordionStyle(
      style: DefaultRemixAccordionStyle.merge(widget.style),
      defaultTrailing: widget.defaultTrailing,
      child: NakedAccordion<T>(
        controller: _controller,
        initialExpandedValues: widget.initialExpandedValues,
        children: widget.children,
      ),
    );
  }
}

// Inherited widget for style propagation
class _InheritedAccordionStyle extends InheritedWidget {
  const _InheritedAccordionStyle({
    required super.child,
    required this.style,
    required this.defaultTrailing,
  });

  static _InheritedAccordionStyle of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedAccordionStyle>()!;
  }

  final RemixAccordionStyle style;
  final IconData defaultTrailing;

  @override
  bool updateShouldNotify(_InheritedAccordionStyle oldWidget) {
    return style != oldWidget.style ||
        defaultTrailing != oldWidget.defaultTrailing;
  }
}

// Accordion Item Widget
class RemixAccordionItem<T> extends StatefulWidget with HasEnabled, HasFocused {
  RemixAccordionItem({
    super.key,
    required String title,
    required this.child,
    required this.value,
    this.focusNode,
    this.autofocus = false,
    this.enabled = true,
    this.trailingBuilder,
    IconData? leading,
  }) : header = RemixLabel(title, leading: leading);

  final Widget header;
  final Widget child;
  final bool enabled;
  final T value;
  final bool autofocus;
  final FocusNode? focusNode;
  final Widget Function(bool)? trailingBuilder;

  @override
  State<RemixAccordionItem<T>> createState() => _RemixAccordionItemState<T>();
}

class _RemixAccordionItemState<T> extends State<RemixAccordionItem<T>>
    with HasWidgetStateController, HasEnabledState {
  static const _kAnimationDuration = Duration(milliseconds: 100);
  static const _kAnimationCurve = Curves.easeInOut;

  @override
  Widget build(BuildContext context) {
    final inheritedData = _InheritedAccordionStyle.of(context);
    final accordionState =
        context.findAncestorStateOfType<_RemixAccordionState<T>>();

    if (accordionState == null) {
      return const SizedBox.shrink();
    }

    // Listen to accordion controller changes
    return ListenableBuilder(
      listenable: accordionState._controller,
      builder: (context, _) {
        // Check if this item is expanded
        final isExpanded = accordionState._controller.contains(widget.value);

        // Set the selected state to match expanded state for styling
        // This is safe here because ListenableBuilder only rebuilds when state changes
        controller.selected = isExpanded;

        return StyleBuilder(
          style: inheritedData.style,
          controller: controller,
          builder: (context, spec) {
            final ItemContainer = spec.itemContainer;
            final ContentContainer = spec.contentContainer;

            return ItemContainer(
              child: NakedAccordionItem<T>(
                trigger: (_, isExpanded) {
                  // The trigger is purely for building UI
                  // No state updates should happen here
                  final HeaderContainer = spec.headerContainer;

                  return HeaderContainer(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        child: widget.header,
                      ),
                      if (widget.trailingBuilder != null)
                        widget.trailingBuilder!(isExpanded)
                      else
                        Icon(
                          inheritedData.defaultTrailing,
                          size: spec.trailing.size,
                          color: spec.trailing.color,
                        ),
                    ],
                  );
                },
                value: widget.value,
                transitionBuilder: (child) => AnimatedSwitcher(
                  duration: _kAnimationDuration,
                  switchInCurve: _kAnimationCurve,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SizeTransition(
                        sizeFactor: animation,
                        axisAlignment: -1,
                        child: child,
                      ),
                    );
                  },
                  child: child,
                ),
                onHoverChange: (state) => controller.hovered = state,
                onPressChange: (state) => controller.pressed = state,
                onFocusChange: (state) => controller.focused = state,
                enabled: widget.enabled,
                focusNode: widget.focusNode,
                child: ContentContainer(child: widget.child),
              ),
            );
          },
        );
      },
    );
  }
}
