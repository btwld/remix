part of 'callout.dart';

/// A message row with optional text, icon, or custom content.
///
/// With [title], the title and [text] stack in the [CalloutSpec.content]
/// column. With [onDismiss], a close button ends the row.
///
/// ## Example
///
/// ```dart
/// RemixCallout(
///   text: 'This is a callout message!',
/// )
/// ```
class RemixCallout extends StatelessWidget {
  /// Creates a callout widget with optional text, icon, or custom [child]. At
  /// least one of [text], [title], or [child] must be provided.
  const RemixCallout({
    super.key,
    String? text,
    this.title,
    this.icon,
    Widget? child,
    this.onDismiss,
    this.dismissLabel,
    this.style = const CalloutStyler.create(),
    this.styleSpec,
  }) : text = text,
       child = child,
       assert(
         text != null || title != null || child != null,
         'Provide text, title, or child to RemixCallout.',
       ),
       assert(
         onDismiss == null || dismissLabel != null,
         'A RemixCallout with onDismiss needs a localized dismissLabel.',
       );

  static final styleFrom = CalloutStyler.new;

  /// The text to display in the callout; under [title], its description.
  final String? text;

  /// An optional heading above [text].
  final String? title;

  /// Called by the close button at the end of the row. The button is shown
  /// only when non-null; the callout does not hide itself.
  final VoidCallback? onDismiss;

  /// The close button's localized accessible name. Required with [onDismiss].
  final String? dismissLabel;

  /// The icon to display in the callout.
  final IconData? icon;

  /// Optional custom child content for the callout body.
  final Widget? child;

  /// The style configuration for the callout.
  final CalloutStyler style;

  /// Optional raw style spec that bypasses fluent style resolution.
  final CalloutSpec? styleSpec;

  Widget? _closeButton(CalloutSpec spec) {
    final onDismiss = this.onDismiss;
    if (onDismiss == null) return null;

    final button = RemixIconButton(
      icon: null,
      iconBuilder: (context, iconSpec, _) => RemixPathIcon(
        glyph: RemixPathGlyph.cross,
        styleSpec: StyleSpec(spec: iconSpec),
      ),
      semanticLabel: dismissLabel!,
      onPressed: onDismiss,
    );

    return switch (spec.closeButton) {
      final style? => StyleProvider<IconButtonSpec>(
        style: style,
        child: button,
      ),
      null => button,
    };
  }

  Widget? _message(CalloutSpec spec) {
    final text = this.text?.isNotEmpty == true
        ? StyledText(this.text!, styleSpec: spec.text)
        : null;
    final title = this.title;
    if (title == null) return text;

    return ColumnBox(
      styleSpec: spec.content,
      children: [
        StyledText(title, styleSpec: spec.title),
        ?text,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return RemixStyleSpecBuilder<CalloutSpec>(
      style: CalloutStyler()
          .content(
            FlexBoxStyler().mainAxisSize(.min).crossAxisAlignment(.start),
          )
          .merge(style),
      styleSpec: styleSpec,
      builder: (context, spec) {
        final closeButton = _closeButton(spec);

        if (child != null) {
          return RemixFlexBoxAdapter(
            styleSpec: spec.container,
            direction: Axis.horizontal,
            containerEffects: spec.containerEffects,
            children: [
              // RowBox resolves to a Flex. A loose fit gives custom content a
              // bounded maximum width without forcing it to fill the callout.
              Flexible(child: child!),
              ?closeButton,
            ],
          );
        }

        final List<Widget> children = [];

        if (icon != null || spec.icon.spec.icon != null) {
          children.add(StyledIcon(icon: icon, styleSpec: spec.icon));
        }

        if (_message(spec) case final message?) {
          children.add(
            // RowBox resolves to a Flex. A loose fit lets text wrap while
            // preserving its intrinsic width for short messages.
            Flexible(child: message),
          );
        }

        if (closeButton != null) children.add(closeButton);

        return RemixFlexBoxAdapter(
          styleSpec: spec.container,
          direction: Axis.horizontal,
          containerEffects: spec.containerEffects,
          children: children,
        );
      },
    );
  }
}
