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
    this.style = const AccordionStyle.create(),
    this.defaultTrailingIcon = Icons.keyboard_arrow_down_rounded,
  });

  final List<RemixAccordionItem<T>> children;
  final List<T> initialExpandedValues;
  final RemixAccordionController<T>? controller;
  final AccordionStyle style;
  final IconData defaultTrailingIcon;

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
      style: DefaultAccordionStyle.merge(widget.style),
      defaultTrailingIcon: widget.defaultTrailingIcon,
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
    required this.defaultTrailingIcon,
  });

  static _InheritedAccordionStyle of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedAccordionStyle>()!;
  }

  final AccordionStyle style;
  final IconData defaultTrailingIcon;

  @override
  bool updateShouldNotify(_InheritedAccordionStyle oldWidget) {
    return style != oldWidget.style ||
        defaultTrailingIcon != oldWidget.defaultTrailingIcon;
  }
}

// Accordion Item Widget
class RemixAccordionItem<T> extends StatefulWidget with Disableable, Focusable {
  RemixAccordionItem({
    super.key,
    required String title,
    required this.child,
    required this.value,
    this.focusNode,
    this.enabled = true,
    this.trailingIconBuilder,
    IconData? leadingIcon,
  }) : header = RemixLabel(title, icon: leadingIcon);

  final Widget header;
  final Widget child;
  final bool enabled;
  final T value;
  final FocusNode? focusNode;
  final Widget Function(bool)? trailingIconBuilder;

  @override
  State<RemixAccordionItem<T>> createState() => _RemixAccordionItemState<T>();
}

class _RemixAccordionItemState<T> extends State<RemixAccordionItem<T>>
    with WidgetStateMixin, DisableableMixin {
  static const _kAnimationDuration = Duration(milliseconds: 100);
  static const _kAnimationCurve = Curves.easeInOut;

  @override
  Widget build(BuildContext context) {
    final inheritedData = _InheritedAccordionStyle.of(context);

    return StyleBuilder(
      style: inheritedData.style,
      builder: (context, spec) {
        return spec.itemContainer(
          child: NakedAccordionItem<T>(
            trigger: (_, isExpanded, toggle) {
              // Update state after frame
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  controller.selected = isExpanded;
                }
              });

              return GestureDetector(
                onTap: widget.enabled ? toggle : null,
                child: MouseRegion(
                  onEnter: (_) => controller.hovered = true,
                  onExit: (_) => controller.hovered = false,
                  child: spec.headerContainer(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        child: DefaultTextStyle(
                          style: TextStyle(
                            color: spec.titleStyle.style?.color,
                            fontSize: spec.titleStyle.style?.fontSize,
                            fontWeight: spec.titleStyle.style?.fontWeight,
                          ),
                          child: IconTheme(
                            data: IconThemeData(
                              size: spec.leadingIcon.size,
                              color: spec.leadingIcon.color,
                            ),
                            child: widget.header,
                          ),
                        ),
                      ),
                      if (widget.trailingIconBuilder != null)
                        widget.trailingIconBuilder!(isExpanded)
                      else
                        Icon(
                          inheritedData.defaultTrailingIcon,
                          size: spec.trailingIcon.size,
                          color: spec.trailingIcon.color,
                        ),
                    ],
                  ),
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
            child: DefaultTextStyle(
              style: TextStyle(
                color: spec.contentStyle.style?.color,
                fontSize: spec.contentStyle.style?.fontSize,
                fontWeight: spec.contentStyle.style?.fontWeight,
              ),
              child: spec.contentContainer(child: widget.child),
            ),
          ),
        );
      },
    );
  }
}
