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
  const RemixAccordionItem({
    super.key,
    required this.title,
    required this.child,
    required this.value,
    this.focusNode,
    this.autofocus = false,
    this.enabled = true,
    this.leading,
    this.trailing,
  });

  final String title;
  final IconData? leading;
  final Widget? trailing;
  final Widget child;
  final bool enabled;
  final T value;
  final bool autofocus;
  final FocusNode? focusNode;

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
            final ItemContainer = spec.container;
            final ContentContainer = spec.content;

            return ItemContainer(
              child: NakedAccordionItem<T>(
                trigger: (_, isExpanded) {
                  // The trigger is purely for building UI
                  // No state updates should happen here
                  final HeaderContainer = spec.header;

                  return HeaderContainer(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: spec.headerLabel(
                            text: widget.title,
                            leading: widget.leading,
                            trailing:
                                null, // Don't use label's trailing since we handle it separately
                          ),
                        ),
                        // Handle trailing icon with proper styling
                        widget.trailing ??
                            Icon(
                              isExpanded
                                  ? Icons.expand_less
                                  : inheritedData.defaultTrailing,
                              size: spec.headerLabel.spec.trailing.spec.size,
                              color: spec.headerLabel.spec.trailing.spec.color,
                            ),
                      ],
                    ),
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
