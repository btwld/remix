part of 'accordion.dart';

typedef RemixAccordionController<T> = NakedAccordionController<T>;

/// A customizable accordion group component.
///
/// ## Example
///
/// ```dart
/// RemixAccordionGroup<String>(
///   controller: RemixAccordionController<String>(min: 0, max: 1),
///   children: [
///     RemixAccordion<String>(
///       value: 'item1',
///       title: 'First Item',
///       child: Text('First content'),
///     ),
///     RemixAccordion<String>(
///       value: 'item2',
///       title: 'Second Item',
///       child: Text('Second content'),
///     ),
///   ],
/// )
/// ```
class RemixAccordionGroup<T> extends StatelessWidget {
  const RemixAccordionGroup({
    super.key,
    required this.children,
    required this.controller,
    this.initialExpandedValues = const [],
    this.style = const RemixAccordionStyle.create(),
  });

  /// Accordion items to render.
  final List<Widget> children;

  /// Controller that manages expanded values.
  final RemixAccordionController<T> controller;

  /// Values expanded on the first build when the controller is empty.
  final List<T> initialExpandedValues;

  /// The style configuration for the accordion group.
  final RemixAccordionStyle style;

  static late final styleFrom = RemixAccordionStyle.new;

  @override
  Widget build(BuildContext context) {
    return NakedAccordionGroup<T>(
      controller: controller,
      initialExpandedValues: initialExpandedValues,
      children: [
        StyleBuilder(
          style: style,
          builder: (context, spec) {
            return FlexBox(styleSpec: spec.container, children: children);
          },
        ),
      ],
    );
  }
}

/// An individual accordion item.
class RemixAccordion<T> extends StatelessWidget {
  const RemixAccordion({
    super.key,
    required this.value,
    required this.child,
    this.title,
    this.icon,
    this.builder,
    this.transitionBuilder,
    this.enabled = true,
    this.mouseCursor = SystemMouseCursors.click,
    this.enableFeedback = true,
    this.autofocus = false,
    this.focusNode,
    this.onFocusChange,
    this.onHoverChange,
    this.onPressChange,
    this.semanticLabel,
    this.style = const RemixAccordionItemStyle.create(),
  }) : assert(
          title != null || builder != null,
          'Either title or builder must be provided',
        );

  /// Unique identifier tracked by the controller.
  final T value;

  /// Content rendered while expanded.
  final Widget child;

  /// Title text for the trigger.
  final String? title;

  /// Optional icon for the trigger.
  final IconData? icon;

  /// Custom builder for the trigger.
  final NakedAccordionTriggerBuilder<T>? builder;

  /// Optional transition builder applied to the expanding panel.
  final Widget Function(Widget panel)? transitionBuilder;

  /// Whether the accordion item is interactive.
  final bool enabled;

  /// Mouse cursor to use when interactive.
  final MouseCursor mouseCursor;

  /// Whether to provide platform feedback on interactions.
  final bool enableFeedback;

  /// Whether the header should autofocus.
  final bool autofocus;

  /// Focus node associated with the header.
  final FocusNode? focusNode;

  /// Called when the header's focus state changes.
  final ValueChanged<bool>? onFocusChange;

  /// Called when the header's hover state changes.
  final ValueChanged<bool>? onHoverChange;

  /// Called when the header's pressed state changes.
  final ValueChanged<bool>? onPressChange;

  /// Semantic label announced for the header.
  final String? semanticLabel;

  /// The style configuration for the accordion item.
  final RemixAccordionItemStyle style;

  static late final styleFrom = RemixAccordionItemStyle.new;

  Widget _buildDefaultTrigger(
    BuildContext context,
    NakedAccordionItemState<T> state,
  ) {
    return StyleBuilder(
      style: style,
      controller: NakedAccordionItemState.controllerOf(context),
      builder: (context, spec) {
        return FlexBox(
          styleSpec: spec.trigger,
          children: [
            if (title != null) StyledText(title!, styleSpec: spec.title),
            StyledIcon(
              icon: icon ??
                  (state.isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down),
              styleSpec: spec.icon,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return NakedAccordion<T>(
      value: value,
      transitionBuilder: transitionBuilder,
      enabled: enabled,
      mouseCursor: mouseCursor,
      enableFeedback: enableFeedback,
      autofocus: autofocus,
      focusNode: focusNode,
      onFocusChange: onFocusChange,
      onHoverChange: onHoverChange,
      onPressChange: onPressChange,
      semanticLabel: semanticLabel ?? title,
      child: StyleBuilder(
        style: style,
        builder: (context, spec) {
          return Box(styleSpec: spec.content, child: child);
        },
      ),
      builder: builder ?? _buildDefaultTrigger,
    );
  }
}
