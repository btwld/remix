part of 'accordion.dart';

typedef RemixAccordionController<T> = NakedAccordionController<T>;

/// A purely behavioral accordion group component that manages expansion state.
///
/// The [RemixAccordionGroup] manages which accordion items are expanded/collapsed
/// and enforces min/max expansion constraints through its controller.
/// It provides no styling - wrap it in your own container if you need layout styling.
/// Each [RemixAccordion] item must be styled individually.
///
/// ## Example
///
/// ```dart
/// Column(
///   children: [
///     RemixAccordionGroup<String>(
///       controller: RemixAccordionController<String>(min: 0, max: 1),
///       children: [
///         RemixAccordion<String>(
///           value: 'item1',
///           title: 'First Item',
///           style: itemStyle,
///           child: Text('First content'),
///         ),
///         RemixAccordion<String>(
///           value: 'item2',
///           title: 'Second Item',
///           style: itemStyle,
///           child: Text('Second content'),
///         ),
///       ],
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
  });

  /// Accordion items to render.
  final List<Widget> children;

  /// Controller that manages expanded values.
  final RemixAccordionController<T> controller;

  /// Values expanded on the first build when the controller is empty.
  final List<T> initialExpandedValues;

  @override
  Widget build(BuildContext context) {
    return NakedAccordionGroup<T>(
      controller: controller,
      initialExpandedValues: initialExpandedValues,
      children: children,
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
    this.leadingIcon,
    this.trailingIcon,
    this.builder,
    this.enabled = true,
    this.mouseCursor = SystemMouseCursors.click,
    this.enableFeedback = true,
    this.autofocus = false,
    this.focusNode,
    this.onFocusChange,
    this.onHoverChange,
    this.onPressChange,
    this.semanticLabel,
    this.style = const RemixAccordionStyle.create(),
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

  /// Optional leading icon for the trigger.
  final IconData? leadingIcon;

  /// Optional trailing icon for the trigger.
  final IconData? trailingIcon;

  /// Custom builder for the trigger.
  final NakedAccordionTriggerBuilder<T>? builder;

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
  final RemixAccordionStyle style;

  static late final styleFrom = RemixAccordionStyle.new;

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
            if (leadingIcon != null)
              StyledIcon(icon: leadingIcon!, styleSpec: spec.leadingIcon),
            if (title != null)
              Expanded(child: StyledText(title!, styleSpec: spec.title)),
            StyledIcon(
              icon:
                  trailingIcon ?? (state.isExpanded ? Icons.remove : Icons.add),
              styleSpec: spec.trailingIcon,
            ),
          ],
        );
      },
    );
  }

  Widget _buildTransitionWrapper(Widget panel) {
    return Builder(
      builder: (context) {
        // Access accordion controller from scope to check expanded state
        final scope = NakedAccordionScope.of<T>(context);
        final isExpanded = scope.controller.contains(value);

        // Build the animation style based on expanded state
        final animationStyle = isExpanded
            ? RemixAccordionStyle().content(
                BoxStyler()
                    .maxHeight(1000)
                    .animate(AnimationConfig.easeOut(200.ms)),
              )
            : RemixAccordionStyle().content(
                BoxStyler()
                    .maxHeight(0)
                    .paddingY(0)
                    .clipBehavior(Clip.hardEdge)
                    .animate(AnimationConfig.easeOut(200.ms)),
              );

        // Merge with user's content style
        final mergedStyle = style.merge(animationStyle);

        return StyleBuilder(
          style: mergedStyle,
          builder: (context, spec) {
            return Box(styleSpec: spec.content, child: panel);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return NakedAccordion<T>(
      value: value,
      transitionBuilder: _buildTransitionWrapper,
      enabled: enabled,
      mouseCursor: mouseCursor,
      enableFeedback: enableFeedback,
      autofocus: autofocus,
      focusNode: focusNode,
      onFocusChange: onFocusChange,
      onHoverChange: onHoverChange,
      onPressChange: onPressChange,
      semanticLabel: semanticLabel ?? title,
      child: child,
      builder: builder ?? _buildDefaultTrigger,
    );
  }
}
