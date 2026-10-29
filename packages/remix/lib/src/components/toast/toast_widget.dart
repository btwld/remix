part of 'toast.dart';

/// A notification surface: an optional icon, a title, an optional
/// description, an optional action, and an optional close button.
///
/// [RemixToastScope] builds one for every visible toast and owns its
/// lifetime. Build it directly for custom presenters or static previews.
///
/// ## Example
///
/// ```dart
/// RemixToast(
///   title: 'Draft saved',
///   action: RemixToastAction(label: 'Undo', onPressed: undo),
///   onDismiss: dismiss,
///   dismissLabel: 'Dismiss notification',
/// )
/// ```
class RemixToast extends StatefulWidget {
  const RemixToast({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.action,
    this.onDismiss,
    this.dismissLabel,
    this.excludeMessageSemantics = false,
    this.style = const ToastStyler.create(),
    this.styleSpec,
  }) : assert(
         onDismiss == null || dismissLabel != null,
         'A RemixToast with onDismiss needs a localized dismissLabel.',
       );

  static final styleFrom = ToastStyler.new;

  /// Composes widget-owned layout defaults with an incoming Toast style.
  static ToastStyler composeStyle(ToastStyler style) => ToastStyler()
      .container(
        FlexBoxStyler()
            .mainAxisSize(MainAxisSize.min)
            .crossAxisAlignment(CrossAxisAlignment.center),
      )
      .content(
        FlexBoxStyler()
            .mainAxisSize(MainAxisSize.min)
            .crossAxisAlignment(CrossAxisAlignment.start),
      )
      .merge(style);

  final String title;

  final String? description;

  /// A decorative leading icon; always excluded from semantics.
  final IconData? icon;

  final RemixToastAction? action;

  /// Called by the close button. The button is shown only when non-null.
  final VoidCallback? onDismiss;

  /// The close button's localized accessible name. Required with [onDismiss].
  final String? dismissLabel;

  /// Whether to hide [title] and [description] from semantics.
  ///
  /// [RemixToastScope] sets this because its status or alert node already
  /// announces the message; leave it false for standalone toasts.
  final bool excludeMessageSemantics;

  final ToastStyler style;

  /// Optional raw style spec that bypasses fluent style resolution.
  final ToastSpec? styleSpec;

  @override
  State<RemixToast> createState() => _RemixToastState();
}

class _RemixToastState extends State<RemixToast> {
  // The buttons keep their elements, and so their focus, when the layout flips
  // between the arrangements, which are different widget trees.
  final _actionKey = GlobalKey();
  final _closeKey = GlobalKey();

  /// The toast width, in logical pixels at the default text size, below which
  /// an inline action drops beneath the message.
  ///
  /// About 160 for the chrome around the message (padding, icon, action, and
  /// close button) plus about 120 for a message column that stays readable.
  /// The text scale multiplies it, because larger text widens the controls and
  /// narrows what is left for the message.
  static const _minInlineWidth = 280.0;

  static Widget _inheritStyle<S extends Spec<S>>(
    Style<S>? style,
    Widget child,
  ) {
    return style == null ? child : StyleProvider<S>(style: style, child: child);
  }

  /// [container] with its cross axis aligned to the start, so the icon and
  /// close button sit on the first line of a message with the action below it.
  static StyleSpec<FlexBoxSpec> _alignedToTop(
    StyleSpec<FlexBoxSpec> container,
  ) {
    final flex = container.spec.flex ?? const StyleSpec(spec: FlexSpec());
    return container.copyWith(
      spec: container.spec.copyWith(
        flex: flex.copyWith(
          spec: flex.spec.copyWith(crossAxisAlignment: .start),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ToastSpec spec) {
    Widget message = ColumnBox(
      styleSpec: spec.content,
      children: [
        StyledText(widget.title, styleSpec: spec.title),
        if (widget.description case final description?)
          StyledText(description, styleSpec: spec.description),
      ],
    );
    if (widget.excludeMessageSemantics) {
      message = ExcludeSemantics(child: message);
    }

    final action = widget.action;
    final onDismiss = widget.onDismiss;

    final leading = widget.icon != null || spec.icon.spec.icon != null
        ? ExcludeSemantics(
            child: StyledIcon(icon: widget.icon, styleSpec: spec.icon),
          )
        : null;
    final actionButton = action == null
        ? null
        : KeyedSubtree(
            key: _actionKey,
            child: _inheritStyle<ButtonSpec>(
              spec.action,
              RemixButton(label: action.label, onPressed: action.onPressed),
            ),
          );
    final closeButton = onDismiss == null
        ? null
        : KeyedSubtree(
            key: _closeKey,
            child: _inheritStyle<IconButtonSpec>(
              spec.closeButton,
              RemixIconButton(
                icon: null,
                iconBuilder: (context, iconSpec, _) => RemixPathIcon(
                  glyph: RemixPathGlyph.cross,
                  styleSpec: StyleSpec(spec: iconSpec),
                ),
                semanticLabel: widget.dismissLabel!,
                onPressed: onDismiss,
              ),
            ),
          );

    Widget row({required bool actionBelow}) {
      if (!actionBelow) {
        return RemixFlexBoxAdapter(
          styleSpec: spec.container,
          direction: Axis.horizontal,
          containerEffects: spec.containerEffects,
          children: [
            ?leading,
            // A loose fit lets long messages wrap while short ones keep their
            // intrinsic width.
            Flexible(child: message),
            ?actionButton,
            ?closeButton,
          ],
        );
      }

      // Both orders below differ from the geometry: the close button shares
      // the first line with the title, yet it follows the action when read
      // and when tabbing.
      return FocusTraversalGroup(
        policy: WidgetOrderTraversalPolicy(),
        child: RemixFlexBoxAdapter(
          styleSpec: _alignedToTop(spec.container),
          direction: Axis.horizontal,
          containerEffects: spec.containerEffects,
          children: [
            ?leading,
            Flexible(
              child: Semantics(
                container: true,
                explicitChildNodes: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: spec.container.spec.flex?.spec.spacing ?? 0,
                  children: [message, ?actionButton],
                ),
              ),
            ),
            ?closeButton,
          ],
        ),
      );
    }

    if (actionButton == null) return row(actionBelow: false);
    if (spec.actionPlacement == .below) return row(actionBelow: true);

    Widget ordered(int order, Widget child) => Semantics(
      container: true,
      explicitChildNodes: true,
      sortKey: OrdinalSortKey(order.toDouble()),
      child: child,
    );

    // Keep semantic and keyboard order independent of the action's position.
    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: FocusTraversalGroup(
        policy: WidgetOrderTraversalPolicy(),
        child: StyleSpecBuilder<FlexBoxSpec>(
          styleSpec: spec.container,
          builder: (context, container) {
            final box = container.box?.spec;
            final direction = Directionality.of(context);
            final padding = (box?.padding ?? EdgeInsets.zero)
                .add(box?.decoration?.padding ?? EdgeInsets.zero)
                .resolve(direction);
            final scale = MediaQuery.textScalerOf(context).scale(16) / 16;
            return RemixBoxAdapter(
              styleSpec: container.box ?? const StyleSpec(spec: BoxSpec()),
              containerEffects: spec.containerEffects,
              child: _ToastReflow(
                flex: container.flex?.spec ?? const FlexSpec(),
                // The box already applied margins, constraints, and padding.
                minInlineWidth: _minInlineWidth * scale - padding.horizontal,
                hasLeading: leading != null,
                hasClose: closeButton != null,
                children: [
                  ?leading,
                  Flexible(child: ordered(0, message)),
                  ordered(1, actionButton),
                  if (closeButton != null) ordered(2, closeButton),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RemixStyleSpecBuilder<ToastSpec>(
      style: RemixToast.composeStyle(widget.style),
      styleSpec: widget.styleSpec,
      builder: _buildContent,
    );
  }
}
