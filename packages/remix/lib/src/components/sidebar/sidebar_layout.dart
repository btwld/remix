import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:naked_ui/naked_ui.dart';

import '../../utilities/remix_reduced_motion.dart';
import '../dialog/dialog.dart';

typedef _SheetInputs = ({
  Widget sidebar,
  Widget Function(BuildContext, Widget) panelBuilder,
  String semanticLabel,
  bool canPop,
});

/// Pairs an inline navigation sidebar with a body, or moves it into a modal
/// sheet below [compactBreakpoint]. It does not style either panel.
///
/// Pass the expanded or collapsed [inlineWidth] to select the inline state.
/// The [compactPanelBuilder] supplies the sheet's sizing and appearance.
///
/// ```dart
/// RemixSidebarLayout(
///   compactBreakpoint: 720,
///   inlineWidth: 256,
///   sidebar: const Text('Navigation links'),
///   compactPanelBuilder: (context, sidebar) => Align(
///     alignment: AlignmentDirectional.centerStart,
///     child: SizedBox(width: 256, child: sidebar),
///   ),
///   body: Builder(
///     builder: (context) => RemixButton(
///       label: 'Open navigation',
///       onPressed: RemixSidebarLayoutScope.of(context).openCompact,
///     ),
///   ),
/// )
/// ```
class RemixSidebarLayout extends StatefulWidget {
  const RemixSidebarLayout({
    super.key,
    required this.sidebar,
    required this.body,
    required this.compactBreakpoint,
    required this.inlineWidth,
    required this.compactPanelBuilder,
    this.header,
    this.compactOpen,
    this.onCompactOpenChanged,
    this.compactBarrierColorBuilder,
    this.barrierLabel = 'Close navigation',
    this.semanticLabel = 'Navigation',
  }) : assert(compactBreakpoint > 0),
       assert(inlineWidth > 0);

  /// Navigation content, rendered inline or supplied to [compactPanelBuilder].
  final Widget sidebar;

  /// Main content displayed next to the sidebar or below the header.
  final Widget body;

  /// Optional header expected to handle its own top safe-area inset.
  final Widget? header;

  /// Available width below which the sidebar moves into a modal sheet.
  final double compactBreakpoint;

  /// Target width of the inline sidebar. Changes animate in wide mode.
  final double inlineWidth;

  /// Sizes, positions and decorates the compact sheet around the given child.
  /// The child includes the navigation content and its dialog semantics.
  /// Replacing this builder updates the open sheet without replacing its route.
  /// The builder's context can read [RemixSidebarLayoutScope].
  final Widget Function(BuildContext context, Widget child) compactPanelBuilder;

  /// When non-null, controls visibility. A controlled owner must update this
  /// value to accept a request from [onCompactOpenChanged].
  final bool? compactOpen;

  /// Reports requests to open or close. Updating [compactOpen] does not call it.
  final ValueChanged<bool>? onCompactOpenChanged;

  /// Resolves the scrim color in the layout's context when the sheet opens.
  /// When omitted, the sheet uses Remix's default dialog barrier color.
  final Color Function(BuildContext context)? compactBarrierColorBuilder;

  /// Localized, nonblank name of the dismiss action, read when the sheet opens.
  final String barrierLabel;

  /// Localized, nonblank name of the compact navigation dialog.
  final String semanticLabel;

  @override
  State<RemixSidebarLayout> createState() => _RemixSidebarLayoutState();
}

class _RemixSidebarLayoutState extends State<RemixSidebarLayout> {
  bool _isCompact = false;
  bool _selfOpen = false;
  bool _reconcileScheduled = false;

  /// Holds the sheet until its sidebar unmounts, so a reopened or inline
  /// sidebar cannot mount the same subtree (including nested global keys).
  _CompactSheet? _sheet;

  bool get _isControlled => widget.compactOpen != null;
  bool get _effectiveOpen => widget.compactOpen ?? _selfOpen;
  bool get _shouldOpen => _isCompact && _effectiveOpen;

  _SheetInputs get _sheetInputs => (
    sidebar: widget.sidebar,
    panelBuilder: widget.compactPanelBuilder,
    semanticLabel: widget.semanticLabel,
    canPop: !_isControlled,
  );

  void _setOpen(bool open) {
    if (!mounted || _effectiveOpen == open) return;
    if (!_isControlled) setState(() => _selfOpen = open);
    widget.onCompactOpenChanged?.call(open);
  }

  void _openCompact() {
    if (_isCompact) _setOpen(true);
  }

  void _closeCompact() => _setOpen(false);

  /// Applies navigation and overlay updates after the layout frame.
  void _reconcileSheet() {
    if (_reconcileScheduled || _sheet?.route?.isActive == false) return;
    if ((_shouldOpen ? _sheetInputs : null) == _sheet?.value) return;
    _reconcileScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _reconcileScheduled = false;
      if (!mounted) return;
      final sheet = _sheet;
      if (!_shouldOpen) {
        sheet?.removeRoute();
      } else if (sheet == null) {
        _pushSheet();
      } else if (sheet.route?.isActive != false) {
        sheet.value = _sheetInputs;
      }
    });
  }

  void _pushSheet() {
    final sheet = _CompactSheet(_sheetInputs);
    _sheet = sheet;
    var renderedInputs = sheet.value;

    void requestClose() {
      if (identical(_sheet, sheet) && sheet.route!.isActive) _closeCompact();
    }

    final popped = showRemixDialog<void>(
      context: context,
      barrierLabel: widget.barrierLabel,
      barrierColor: widget.compactBarrierColorBuilder?.call(context),
      transitionDuration: const Duration(milliseconds: 250),
      builder: (context) {
        if (sheet.route == null) {
          final route = sheet.route = ModalRoute.of<void>(context)!;
          unawaited(route.completed.then((_) => _finishSheet(sheet)));
        }
        final route = sheet.route!;
        return ValueListenableBuilder(
          valueListenable: sheet,
          builder: (context, inputs, _) {
            if (route.isActive && mounted && _shouldOpen) {
              renderedInputs = inputs;
            }
            return _buildSheet(renderedInputs, requestClose);
          },
        );
      },
    );
    unawaited(
      popped.then((_) {
        if (identical(_sheet, sheet)) _closeCompact();
        if (sheet.route == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (sheet.route == null) _finishSheet(sheet);
          });
        }
      }),
    );
  }

  Widget _buildSheet(_SheetInputs inputs, VoidCallback requestClose) =>
      PopScope<void>(
        canPop: inputs.canPop,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) requestClose();
        },
        child: RemixSidebarLayoutScope._(
          isCompact: true,
          isCompactOpen: true,
          openCompact: () {},
          closeCompact: requestClose,
          child: Builder(
            builder: (context) => inputs.panelBuilder(
              context,
              NakedDialog(
                semanticLabel: inputs.semanticLabel,
                child: inputs.sidebar,
              ),
            ),
          ),
        ),
      );

  /// Disposes the inputs once the route unmounts, including navigator teardown.
  void _finishSheet(_CompactSheet sheet) {
    sheet.dispose();
    if (mounted) setState(() => _sheet = null);
  }

  @override
  void dispose() {
    final sheet = _sheet;
    if (sheet != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => sheet.removeRoute());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      _isCompact = constraints.maxWidth < widget.compactBreakpoint;
      _reconcileSheet();
      final policy = FocusTraversalGroup.maybeOf(context);

      return RemixSidebarLayoutScope._(
        isCompact: _isCompact,
        isCompactOpen: _shouldOpen,
        openCompact: _openCompact,
        closeCompact: _closeCompact,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_isCompact && _sheet == null)
              RemixReducedMotionBuilder(
                builder: (context, reduceMotion) => AnimatedContainer(
                  width: widget.inlineWidth,
                  duration: reduceMotion
                      ? Duration.zero
                      : const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  child: FocusTraversalGroup(
                    policy: policy,
                    child: widget.sidebar,
                  ),
                ),
              )
            else
              const SizedBox.shrink(),
            Expanded(
              child: FocusTraversalGroup(policy: policy, child: _body(context)),
            ),
          ],
        ),
      );
    },
  );

  Widget _body(BuildContext context) {
    final header = widget.header;
    final ltr = Directionality.of(context) == TextDirection.ltr;
    Widget inset(Widget child, {bool removeTop = false}) =>
        MediaQuery.removePadding(
          context: context,
          removeTop: removeTop,
          removeLeft: !_isCompact && ltr,
          removeRight: !_isCompact && !ltr,
          child: child,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (header != null) inset(header),
        Expanded(
          child: RepaintBoundary(
            child: inset(widget.body, removeTop: header != null),
          ),
        ),
      ],
    );
  }
}

class _CompactSheet extends ValueNotifier<_SheetInputs> {
  _CompactSheet(super.value);

  ModalRoute<void>? route;

  void removeRoute() {
    final route = this.route;
    final navigator = route?.navigator;
    if (route != null &&
        route.isActive &&
        navigator != null &&
        navigator.mounted) {
      navigator.removeRoute(route);
    }
  }
}

/// Read a [RemixSidebarLayout]'s presentation and control its compact sheet.
/// The scope is available in both the main content and the compact sheet.
class RemixSidebarLayoutScope extends InheritedWidget {
  const RemixSidebarLayoutScope._({
    required this.isCompact,
    required this.isCompactOpen,
    required VoidCallback openCompact,
    required VoidCallback closeCompact,
    required super.child,
  }) : _openCompact = openCompact,
       _closeCompact = closeCompact;

  /// Whether the layout is below its compact breakpoint.
  final bool isCompact;

  /// Whether the compact sheet is open. Always false in wide mode.
  final bool isCompactOpen;

  final VoidCallback _openCompact;
  final VoidCallback _closeCompact;

  /// Requests opening the sheet. Has no effect while wide or already open.
  void openCompact() => _openCompact();

  /// Requests closing the sheet. Has no effect when it is already closed.
  void closeCompact() => _closeCompact();

  /// Returns the nearest scope. Throws a [FlutterError] outside a layout.
  static RemixSidebarLayoutScope of(BuildContext context) =>
      maybeOf(context) ??
      (throw FlutterError(
        'RemixSidebarLayoutScope.of requires a RemixSidebarLayout ancestor.',
      ));

  /// Returns the nearest scope, or null if there is no layout ancestor.
  static RemixSidebarLayoutScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<RemixSidebarLayoutScope>();

  @override
  bool updateShouldNotify(RemixSidebarLayoutScope oldWidget) =>
      isCompact != oldWidget.isCompact ||
      isCompactOpen != oldWidget.isCompactOpen;
}
