import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

/// Accessible name for the compact navigation sheet's dialog barrier.
const _closeNavigationLabel = 'Close navigation';

/// Accessible name for the compact navigation sheet itself.
const _navigationSemanticLabel = 'Navigation';

/// A width, in logical pixels, reserved outside the compact sheet so its
/// scrim stays reachable on narrow screens.
const _compactSheetBarrierGutter = 56.0;

/// The sheet's `separator` edge, as wide as the sidebar's.
const _separatorWidth = 1.0;

/// A layout widget that pairs a [sidebar] with a [body].
///
/// An extension: HeroUI web 3.2.6 has no layout family to port. The
/// structure is the other presets' sidebar layout; the compact sheet sits on
/// the page `background` with a `separator` edge over the `backdrop` scrim.
///
/// At or above [compactBreakpoint] width, the layout displays [sidebar] in a
/// row beside an expanded column containing [header] and [body]. The sidebar
/// animates width transitions between [collapsedWidth] and [sidebarWidth]
/// based on [collapsed].
///
/// Below [compactBreakpoint] width, the layout hides the inline sidebar and
/// presents it inside a modal sheet pinned to the start edge. The sheet is
/// controlled through [HeroUiSidebarLayoutScope] or the [compactOpen] property.
///
/// When [compactOpen] is `null`, the layout manages sheet visibility
/// internally. When [compactOpen] is non-null, the host controls visibility and
/// must update [compactOpen] to `false` when [onCompactOpenChanged] requests
/// dismissal.
///
/// ```dart
/// HeroUiSidebarLayout(
///   sidebar: HeroUiSidebar<AppPage>(
///     sections: sections,
///     selectedValue: page,
///     onSelected: (value) {
///       setState(() => page = value);
///       HeroUiSidebarLayoutScope.of(context).closeCompact();
///     },
///   ),
///   header: const HeroUiAppBar(title: 'Overview'),
///   body: PageBody(page: page),
/// )
/// ```
class HeroUiSidebarLayout extends StatefulWidget {
  const HeroUiSidebarLayout({
    super.key,
    required this.sidebar,
    required this.body,
    this.header,
    this.compactBreakpoint = 720,
    this.sidebarWidth = 256,
    this.collapsedWidth = 72,
    this.collapsed = false,
    this.compactOpen,
    this.onCompactOpenChanged,
  }) : assert(compactBreakpoint > 0),
       assert(sidebarWidth > 0),
       assert(collapsedWidth > 0 && collapsedWidth <= sidebarWidth);

  /// The navigation sidebar widget.
  ///
  /// Rendered inline in wide layouts and inside a modal sheet in compact layouts.
  final Widget sidebar;

  /// The primary content widget displayed alongside or below the sidebar.
  final Widget body;

  /// The optional header widget displayed above [body].
  ///
  /// When present, the header handles top safe-area insets, and [body] removes
  /// its top padding to avoid duplicate insets.
  final Widget? header;

  /// The available-width threshold, in logical pixels, below which the
  /// layout switches to its compact presentation.
  final double compactBreakpoint;

  /// The sidebar width in wide mode when [collapsed] is `false`.
  final double sidebarWidth;

  /// The sidebar width in wide mode when [collapsed] is `true`.
  final double collapsedWidth;

  /// Whether the sidebar renders at [collapsedWidth] instead of [sidebarWidth].
  final bool collapsed;

  /// Whether the compact navigation sheet is open.
  ///
  /// When `null`, the layout manages the open state internally.
  final bool? compactOpen;

  /// Called when the compact navigation sheet open state changes.
  ///
  /// Updating [compactOpen] directly does not invoke this callback.
  final ValueChanged<bool>? onCompactOpenChanged;

  @override
  State<HeroUiSidebarLayout> createState() => _HeroUiSidebarLayoutState();
}

class _HeroUiSidebarLayoutState extends State<HeroUiSidebarLayout> {
  bool _selfOpen = false;
  bool _sheetShowing = false;

  /// The layout's presentation as of its most recent build, so [_openCompact]
  /// can no-op while wide even when called outside that build.
  bool _isCompact = false;

  /// The route [showRemixDialog] pushed for the open sheet, captured from
  /// inside its own builder via `ModalRoute.of` so [_removeSheetRoute] can
  /// close exactly that route on the Navigator that actually owns it,
  /// rather than popping whatever a bare `Navigator.of(context)` finds.
  Route<void>? _sheetRoute;

  bool get _effectiveOpen => widget.compactOpen ?? _selfOpen;

  void _setOpen(bool value) {
    if (_effectiveOpen == value) return;
    if (widget.compactOpen == null) {
      setState(() => _selfOpen = value);
    }
    widget.onCompactOpenChanged?.call(value);
  }

  // No-op while wide, so open state never carries over to the next compact
  // presentation.
  void _openCompact() {
    if (!_isCompact) return;
    _setOpen(true);
  }

  void _closeCompact() => _setOpen(false);

  void _reconcileSheet(bool isCompact) {
    _isCompact = isCompact;
    final desiredOpen = isCompact && _effectiveOpen;
    if (desiredOpen == _sheetShowing) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_isCompact && _effectiveOpen) {
        if (!_sheetShowing) _pushSheet();
      } else if (_sheetShowing) {
        _removeSheetRoute();
      }
    });
  }

  void _removeSheetRoute() {
    final route = _sheetRoute;
    if (route == null || !route.isActive) return;
    route.navigator?.removeRoute(route);
  }

  Future<void> _pushSheet() async {
    _sheetShowing = true;
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    await showRemixDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: _closeNavigationLabel,
      barrierColor: MixScope.tokenOf(HeroUiTokens.backdrop, context),
      transitionDuration: reduceMotion
          ? Duration.zero
          : const Duration(milliseconds: 250),
      builder: (dialogContext) {
        _sheetRoute = ModalRoute.of(dialogContext);
        final available = MediaQuery.sizeOf(dialogContext).width;
        final width = math.min(
          widget.sidebarWidth,
          math.max(0.0, available - _compactSheetBarrierGutter),
        );
        return PopScope<void>(
          canPop: widget.compactOpen == null,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _closeCompact();
          },
          child: HeroUiSidebarLayoutScope._(
            isCompact: true,
            isCompactOpen: true,
            openCompact: _openCompact,
            closeCompact: _closeCompact,
            child: Box(
              style: BoxStyler().alignment(.centerStart),
              // A foreground border paints the panel edge without shrinking
              // `width` by the border's own stroke width.
              child: Box(
                style: BoxStyler()
                    .width(width)
                    .height(.infinity)
                    .color(HeroUiTokens.background())
                    .foregroundDecoration(
                      BoxDecorationMix(
                        border: BorderDirectionalMix(
                          end: BorderSideMix(
                            color: HeroUiTokens.separator(),
                            width: _separatorWidth,
                          ),
                        ),
                      ),
                    ),
                child: RemixDialog(
                  semanticLabel: _navigationSemanticLabel,
                  child: widget.sidebar,
                ),
              ),
            ),
          ),
        );
      },
    );
    // Reached once, however the route completed: a user dismissal or
    // _removeSheetRoute above.
    _sheetRoute = null;
    _sheetShowing = false;
    if (mounted) _setOpen(false);
  }

  @override
  void dispose() {
    final route = _sheetRoute;
    if (route != null) {
      // Navigator mutations must wait until the current tree update finishes.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final navigator = route.navigator;
        if (navigator != null && navigator.mounted && route.isActive) {
          navigator.removeRoute(route);
        }
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < widget.compactBreakpoint;
        _reconcileSheet(isCompact);

        return HeroUiSidebarLayoutScope._(
          isCompact: isCompact,
          // Anded with isCompact so it can't read true while wide.
          isCompactOpen: isCompact && _effectiveOpen,
          openCompact: _openCompact,
          closeCompact: _closeCompact,
          child: isCompact ? _body() : _wideRow(),
        );
      },
    );
  }

  Widget _wideRow() {
    final policy = FocusTraversalGroup.maybeOf(context);
    return RemixReducedMotionBuilder(
      builder: (context, reduceMotion) => RowBox(
        style: FlexBoxStyler().crossAxisAlignment(.stretch),
        children: [
          AnimatedContainer(
            width: widget.collapsed
                ? widget.collapsedWidth
                : widget.sidebarWidth,
            duration: reduceMotion
                ? Duration.zero
                : const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            // Grouped so Tab finishes one pane before the other, rather than
            // zigzagging between controls that sit at similar heights.
            child: FocusTraversalGroup(policy: policy, child: widget.sidebar),
          ),
          Expanded(
            child: FocusTraversalGroup(
              policy: policy,
              child: _body(besideSidebar: true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body({bool besideSidebar = false}) {
    final header = widget.header;
    final ltr = Directionality.of(context) == TextDirection.ltr;

    // Beside the sidebar, the column never touches the start edge, so it
    // must not keep clear of a start inset such as a landscape notch. A header
    // sits against the top edge and keeps clear of the top inset itself, so
    // the body below must not reserve it a second time: a scroll view
    // otherwise pads its content by MediaQuery's top inset. Both wrappers
    // read this widget's MediaQuery, so neither undoes the other.
    Widget inset(Widget child, {bool removeTop = false}) =>
        MediaQuery.removePadding(
          context: context,
          removeTop: removeTop,
          removeLeft: besideSidebar && ltr,
          removeRight: besideSidebar && !ltr,
          child: child,
        );

    return ColumnBox(
      style: FlexBoxStyler().crossAxisAlignment(.stretch),
      children: [
        if (header != null) inset(header),
        // The body's wrapper stays mounted either way so its state survives
        // a header coming or going.
        Expanded(
          child: RepaintBoundary(
            child: inset(widget.body, removeTop: header != null),
          ),
        ),
      ],
    );
  }
}

/// An inherited scope that provides compact layout state and controls.
///
/// Descendants of [HeroUiSidebarLayout] and its compact navigation sheet can
/// read this scope to observe compact mode or toggle the sheet.
class HeroUiSidebarLayoutScope extends InheritedWidget {
  // Assigns the private fields explicitly rather than through private named
  // parameters, a Dart 3.12 feature, so installing this layout does not raise
  // the application's language floor.
  const HeroUiSidebarLayoutScope._({
    required this.isCompact,
    required this.isCompactOpen,
    required VoidCallback openCompact,
    required VoidCallback closeCompact,
    required super.child,
  }) : _openCompact = openCompact, // ignore: prefer_initializing_formals
       _closeCompact = closeCompact; // ignore: prefer_initializing_formals

  /// Whether the layout is currently in its compact presentation.
  final bool isCompact;

  /// Whether the compact sheet is currently open.
  ///
  /// Always `false` outside a compact presentation.
  final bool isCompactOpen;

  final VoidCallback _openCompact;
  final VoidCallback _closeCompact;

  /// Opens the compact sheet.
  ///
  /// Has no effect when the layout is not compact.
  void openCompact() => _openCompact();

  /// Closes the compact sheet.
  ///
  /// Has no effect when the sheet is already closed.
  void closeCompact() => _closeCompact();

  /// Returns the nearest [HeroUiSidebarLayoutScope] from [context].
  ///
  /// Throws a [FlutterError] if no [HeroUiSidebarLayout] ancestor is found.
  static HeroUiSidebarLayoutScope of(BuildContext context) {
    final scope = maybeOf(context);
    if (scope == null) {
      throw FlutterError(
        'HeroUiSidebarLayoutScope.of requires a HeroUiSidebarLayout ancestor.',
      );
    }
    return scope;
  }

  /// Returns the nearest [HeroUiSidebarLayoutScope] from [context], or `null` if none exists.
  static HeroUiSidebarLayoutScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HeroUiSidebarLayoutScope>();

  @override
  bool updateShouldNotify(HeroUiSidebarLayoutScope oldWidget) =>
      isCompact != oldWidget.isCompact ||
      isCompactOpen != oldWidget.isCompactOpen;
}
