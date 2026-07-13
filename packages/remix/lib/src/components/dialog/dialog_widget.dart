part of 'dialog.dart';

/// Shows a customizable dialog.
///
/// ## Example
///
/// ```dart
/// await showRemixDialog<String>(
///   context: context,
///   builder: (context) => RemixDialog(
///     title: 'Delete Item',
///     description: 'Are you sure you want to delete this item?',
///     actions: [
///       TextButton(
///         onPressed: () => Navigator.pop(context, 'cancel'),
///         child: Text('Cancel'),
///       ),
///       TextButton(
///         onPressed: () => Navigator.pop(context, 'delete'),
///         child: Text('Delete'),
///       ),
///     ],
///   ),
/// )
/// ```
Future<T?> showRemixDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? barrierColor,
  bool barrierDismissible = true,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  Duration transitionDuration = const Duration(milliseconds: 400),
  RouteTransitionsBuilder? transitionBuilder,
  bool requestFocus = true,
  TraversalEdgeBehavior? traversalEdgeBehavior,
}) {
  final scope = MixScope.of(context);

  return showNakedDialog(
    context: context,
    barrierColor: barrierColor ?? Colors.black54,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
    transitionDuration: transitionDuration,
    transitionBuilder: transitionBuilder,
    requestFocus: requestFocus,
    traversalEdgeBehavior: traversalEdgeBehavior,
    builder: (context) => MixScope(
      tokens: scope.tokens,
      orderOfModifiers: scope.orderOfModifiers,
      child: builder(context),
    ),
  );
}

/// A customizable dialog component.
///
/// ## Example
///
/// ```dart
/// RemixDialog(
///   title: 'Delete Item',
///   description: 'Are you sure you want to delete this item?',
///   actions: [
///     RemixButton(
///       label: 'Cancel',
///       onPressed: () => Navigator.pop(context),
///     ),
///     RemixButton(
///       label: 'Delete',
///       onPressed: () => Navigator.pop(context),
///     ),
///   ],
/// )
/// ```
class RemixDialog extends StatelessWidget {
  const RemixDialog({
    super.key,
    this.child,
    this.title,
    this.description,
    this.actions,
    this.modal = true,
    this.semanticLabel,
    this.style = const RemixDialogStyle.create(),
    this.styleSpec,
  }) : assert(
         child != null || title != null || description != null,
         'Either child, title, or description must be provided',
       );

  /// Custom body content.
  ///
  /// Composes with [title], [description], and [actions] in [AlertDialog]
  /// order. Alone, placed directly in the container (no default column).
  final Widget? child;

  /// Dialog title text.
  final String? title;

  /// Dialog description text.
  final String? description;

  /// Action buttons (typically placed at the bottom).
  final List<Widget>? actions;

  /// Whether to block background content interaction.
  final bool modal;

  /// Semantic label for accessibility.
  final String? semanticLabel;

  /// The style configuration for the dialog.
  final RemixDialogStyle style;
  final RemixDialogSpec? styleSpec;

  static final styleFrom = RemixDialogStyle.new;

  @override
  Widget build(BuildContext context) {
    return NakedDialog(
      modal: modal,
      semanticLabel: semanticLabel ?? title,
      child: RemixStyleBuilder(
        style: style,
        styleSpec: styleSpec,
        builder: (context, spec) {
          final hasActions = actions != null && actions!.isNotEmpty;
          final isLoneChild =
              child != null &&
              title == null &&
              description == null &&
              !hasActions;

          // Skip the default column so a fully custom body keeps its layout.
          if (isLoneChild) {
            return Box(styleSpec: spec.container, child: child!);
          }

          // title → description → child → actions; never discard provided content.
          return Box(
            styleSpec: spec.container,
            child: Column(
              mainAxisAlignment: .start,
              mainAxisSize: .min,
              crossAxisAlignment: .start,
              children: [
                if (title != null) StyledText(title!, styleSpec: spec.title),
                if (description != null)
                  StyledText(description!, styleSpec: spec.description),
                if (child != null) child!,
                if (hasActions)
                  FlexBox(styleSpec: spec.actions, children: actions!),
              ],
            ),
          );
        },
      ),
    );
  }
}
