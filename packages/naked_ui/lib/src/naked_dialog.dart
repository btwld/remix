import 'dart:ui' show SemanticsRole;

import 'package:flutter/widgets.dart';

import 'utilities/intents.dart';
import 'utilities/reduced_motion.dart';

/// Displays an urgent modal alert dialog without default styling.
///
/// The [builder] returns only the visual contents. This helper adds the single
/// [NakedDialog] semantics wrapper, requires a non-empty caller-localized
/// [semanticLabel], and keeps outside-barrier dismissal disabled by default.
/// Escape and platform Back safely cancel the route with a null result.
/// Enabling [barrierDismissible] also requires a non-empty localized
/// [barrierLabel]. Consumers remain responsible for an explicit safe cancel
/// action and for testing every supported cancellation path.
///
/// An attached and focusable [initialFocusNode] receives focus after the route
/// opens. Otherwise a descendant autofocus request is honored, falling back to
/// the first traversable descendant. The node remains owned by the caller and
/// is never disposed by Naked UI. For irreversible work, prefer the least
/// destructive action; long structured content may instead use a non-action
/// focus target near its beginning.
///
/// Like [showNakedDialog], the route's transitions are skipped while reduced
/// motion is requested.
Future<T?> showNakedAlertDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  required Color barrierColor,
  required String semanticLabel,
  String? barrierLabel,
  bool barrierDismissible = false,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  Duration transitionDuration = const Duration(milliseconds: 400),
  RouteTransitionsBuilder? transitionBuilder,
  FocusNode? initialFocusNode,
}) {
  if (semanticLabel.trim().isEmpty) {
    throw ArgumentError.value(
      semanticLabel,
      'semanticLabel',
      'Alert dialogs require a non-empty localized semantic label.',
    );
  }
  if (barrierDismissible &&
      (barrierLabel == null || barrierLabel.trim().isEmpty)) {
    throw ArgumentError.value(
      barrierLabel,
      'barrierLabel',
      'Dismissible alert barriers require a non-empty localized label.',
    );
  }

  return showNakedDialog<T>(
    context: context,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    barrierDismissible: barrierDismissible,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
    transitionDuration: transitionDuration,
    transitionBuilder: transitionBuilder,
    requestFocus: true,
    builder: (context) {
      Widget dialog = NakedDialog(
        semanticsRole: SemanticsRole.alertDialog,
        semanticLabel: semanticLabel,
        child: _NakedAlertDialogFocus(
          initialFocusNode: initialFocusNode,
          child: builder(context),
        ),
      );
      if (!barrierDismissible) {
        dialog = _withDialogDismissShortcut(context, dialog);
      }
      return dialog;
    },
  );
}

Widget _withDialogDismissShortcut(BuildContext context, Widget child) {
  return Shortcuts(
    shortcuts: NakedIntentActions.dialog.shortcuts,
    child: Actions(
      actions: NakedIntentActions.dialog.actions(
        onDismiss: () => Navigator.of(context).maybePop(),
      ),
      child: child,
    ),
  );
}

class _NakedAlertDialogFocus extends StatefulWidget {
  const _NakedAlertDialogFocus({
    required this.initialFocusNode,
    required this.child,
  });

  final FocusNode? initialFocusNode;
  final Widget child;

  @override
  State<_NakedAlertDialogFocus> createState() => _NakedAlertDialogFocusState();
}

class _NakedAlertDialogFocusState extends State<_NakedAlertDialogFocus> {
  @override
  void initState() {
    super.initState();
    _scheduleFocusRequest();
  }

  @override
  void didUpdateWidget(_NakedAlertDialogFocus oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialFocusNode != oldWidget.initialFocusNode) {
      _scheduleFocusRequest();
    }
  }

  void _scheduleFocusRequest() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final focusNode = widget.initialFocusNode;
      final scope = FocusScope.of(context);
      if (focusNode != null &&
          focusNode.context != null &&
          focusNode.canRequestFocus &&
          focusNode.ancestors.contains(scope)) {
        focusNode.requestFocus();
        return;
      }

      final firstFocus = FocusTraversalGroup.maybeOf(
        context,
      )?.findFirstFocus(scope, ignoreCurrentFocus: true);
      if (firstFocus != null &&
          firstFocus != scope &&
          firstFocus.canRequestFocus) {
        scope.autofocus(firstFocus);
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Displays a headless dialog without default styling.
///
/// Unlike [showDialog], imposes no visuals—appearance is fully controlled by
/// [builder]. The [barrierColor] is required and controls both visual scrim
/// and barrier hit testing.
///
/// Returns a [Future] with the value passed to [Navigator.pop], or null if dismissed.
///
/// The route's transitions, including the barrier fade, are skipped while the
/// user asks to reduce motion: when [MediaQueryData.disableAnimations] is set
/// or the platform reports `AccessibilityFeatures.reduceMotion`, which iOS
/// sets for Reduce Motion. [transitionDuration] is then ignored and
/// [transitionBuilder] sees a completed animation.
///
/// The setting is read from [context] when the dialog opens and from the
/// dialog's own subtree when it is dismissed. A dialog that opened without
/// motion also closes without it, and a request made while it is open skips the
/// exit. Withdrawing the request while the dialog is open does not bring the
/// exit back.
///
/// Example:
/// ```dart
/// final result = await showNakedDialog<String>(
///   context: context,
///   barrierColor: Colors.black54,
///   barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
///   builder: (context) => NakedDialog(
///     semanticLabel: 'Confirmation Dialog',
///     child: YourCustomContent(),
///   ),
/// );
/// ```
///
/// See also:
/// - [showDialog], the Material-styled dialog for typical apps.
Future<T?> showNakedDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  required Color barrierColor,
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
  final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
  final CapturedThemes themes = InheritedTheme.capture(
    from: context,
    to: navigator.context,
  );

  return navigator.push<T>(
    _NakedDialogRoute<T>(
      reducedMotion: reducedMotionOf(context),
      pageBuilder:
          (
            BuildContext routeContext,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            final Widget content = builder(routeContext);
            // Keeps the BlockSemantics in a modal NakedDialog from also hiding
            // the barrier's dismiss node when the page is visible on the first
            // frame, as it is under reduced motion.
            Widget wrapped = Semantics(
              container: true,
              child: FocusTraversalGroup(child: content),
            );

            if (barrierDismissible) {
              wrapped = _withDialogDismissShortcut(routeContext, wrapped);
            }

            return themes.wrap(wrapped);
          },
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      transitionDuration: transitionDuration,
      transitionBuilder: transitionBuilder,
      settings: routeSettings,
      requestFocus: requestFocus,
      anchorPoint: anchorPoint,
      traversalEdgeBehavior:
          traversalEdgeBehavior ?? TraversalEdgeBehavior.closedLoop,
    ),
  );
}

class _NakedDialogRoute<T> extends RawDialogRoute<T> {
  _NakedDialogRoute({
    required bool reducedMotion,
    required super.pageBuilder,
    required super.barrierDismissible,
    required super.barrierColor,
    required super.barrierLabel,
    required super.transitionDuration,
    required super.transitionBuilder,
    required super.settings,
    required super.requestFocus,
    required super.anchorPoint,
    required super.traversalEdgeBehavior,
  }) : _reducedMotion = reducedMotion;

  bool _reducedMotion;

  @override
  Duration get transitionDuration =>
      _reducedMotion ? Duration.zero : super.transitionDuration;

  @override
  bool didPop(T? result) {
    // The route's controller fixes its durations when the route is installed.
    final context = subtreeContext;
    if (context != null) {
      _reducedMotion = _reducedMotion || reducedMotionOf(context);
      controller!.reverseDuration = reverseTransitionDuration;
    }

    return super.didPop(result);
  }
}

/// Provides modal dialog semantics and accessibility.
///
/// When [modal] is true, blocks background content interaction and
/// configures screen reader route semantics.
///
/// See also:
/// - [showNakedDialog], the function that displays dialogs.
class NakedDialog extends StatelessWidget {
  /// Creates a semantic wrapper for dialog [child].
  const NakedDialog({
    super.key,
    required this.child,
    this.modal = true,
    this.semanticLabel,
    this.excludeSemantics = false,
    this.semanticsRole = SemanticsRole.dialog,
  }) : assert(
         semanticsRole == SemanticsRole.dialog ||
             semanticsRole == SemanticsRole.alertDialog,
         'NakedDialog only supports dialog and alertDialog semantics roles.',
       );

  /// The dialog content.
  final Widget child;

  /// Whether to block background content interaction.
  final bool modal;

  /// Semantic label for accessibility.
  final String? semanticLabel;

  /// Whether to exclude this widget from the semantic tree.
  ///
  /// When true, the widget and its children are hidden from accessibility services.
  final bool excludeSemantics;

  /// The dialog role exposed to accessibility services.
  ///
  /// Use [SemanticsRole.alertDialog] only for urgent or destructive
  /// confirmations that require the user's immediate attention.
  final SemanticsRole semanticsRole;

  @override
  Widget build(BuildContext context) {
    Widget dialog = excludeSemantics
        ? ExcludeSemantics(child: child)
        : Semantics(
            role: semanticsRole,
            container: true,
            explicitChildNodes: true,
            scopesRoute: modal,
            namesRoute: modal,
            label: semanticLabel,
            child: child,
          );

    if (modal && !excludeSemantics) {
      dialog = BlockSemantics(child: dialog);
    }

    return dialog;
  }
}
