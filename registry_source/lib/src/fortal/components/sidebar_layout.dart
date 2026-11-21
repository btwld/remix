import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

/// A width, in logical pixels, reserved outside the compact sheet so its
/// scrim stays reachable on narrow screens.
const _compactSheetBarrierGutter = 56.0;

/// A Fortal-themed layout widget that pairs a [sidebar] with a [body].
///
/// At or above [compactBreakpoint] width, the layout displays [sidebar] in a
/// row beside an expanded column containing [header] and [body]. The sidebar
/// animates width transitions between [collapsedWidth] and [sidebarWidth]
/// based on [collapsed].
///
/// Below [compactBreakpoint] width, the layout hides the inline sidebar and
/// presents it inside a modal sheet pinned to the start edge. The sheet is
/// controlled through [FortalSidebarLayoutScope] or the [compactOpen] property.
///
/// When [compactOpen] is `null`, the layout manages sheet visibility
/// internally. When [compactOpen] is non-null, the host controls visibility and
/// must update [compactOpen] to `false` when [onCompactOpenChanged] requests
/// dismissal.
///
/// ```dart
/// FortalSidebarLayout(
///   sidebar: FortalSidebar<AppPage>(
///     sections: sections,
///     selectedValue: page,
///     onSelected: (value) {
///       setState(() => page = value);
///       FortalSidebarLayoutScope.of(context).closeCompact();
///     },
///   ),
///   header: const FortalAppBar(title: 'Overview'),
///   body: PageBody(page: page),
/// )
/// ```
class FortalSidebarLayout extends StatefulWidget {
  const FortalSidebarLayout({
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
  State<FortalSidebarLayout> createState() => _FortalSidebarLayoutState();

  Widget _buildCompactPanel(BuildContext context, Widget child) {
    final available = MediaQuery.sizeOf(context).width;
    final width = math.min(
      sidebarWidth,
      math.max(0.0, available - _compactSheetBarrierGutter),
    );
    return Box(
      style: BoxStyler().alignment(.centerStart),
      child: Box(
        style: BoxStyler()
            .width(width)
            .height(.infinity)
            .color(FortalTokens.colorPanelSolid())
            .foregroundDecoration(
              BoxDecorationMix(
                border: BorderDirectionalMix(
                  end: BorderSideMix(
                    color: FortalTokens.grayA5(),
                    width: FortalTokens.borderWidth1(),
                  ),
                ),
              ),
            ),
        child: child,
      ),
    );
  }
}

class _FortalSidebarLayoutState extends State<FortalSidebarLayout> {
  Widget _scoped(Widget child) => Builder(
    builder: (context) => FortalSidebarLayoutScope._(
      RemixSidebarLayoutScope.of(context),
      _closeWhileWide,
      child: child,
    ),
  );

  void _closeWhileWide() {
    if (widget.compactOpen == true) widget.onCompactOpenChanged?.call(false);
  }

  @override
  Widget build(BuildContext context) => RemixSidebarLayout(
    sidebar: _scoped(widget.sidebar),
    body: _scoped(widget.body),
    header: widget.header == null ? null : _scoped(widget.header!),
    compactBreakpoint: widget.compactBreakpoint,
    inlineWidth: widget.collapsed ? widget.collapsedWidth : widget.sidebarWidth,
    compactOpen: widget.compactOpen,
    onCompactOpenChanged: widget.onCompactOpenChanged,
    compactBarrierColorBuilder: (context) =>
        MixScope.tokenOf(FortalTokens.colorOverlay, context),
    compactPanelBuilder: widget._buildCompactPanel,
  );
}

/// Scope available from [FortalSidebarLayout] and its compact navigation sheet.
class FortalSidebarLayoutScope extends InheritedWidget {
  const FortalSidebarLayoutScope._(
    this._layout,
    this._closeWhileWide, {
    required super.child,
  });

  final RemixSidebarLayoutScope _layout;
  final VoidCallback _closeWhileWide;

  /// Whether the layout is currently in its compact presentation.
  bool get isCompact => _layout.isCompact;

  /// Whether the compact sheet is open. Always false while wide.
  bool get isCompactOpen => _layout.isCompactOpen;

  /// Opens the compact sheet. Has no effect while wide.
  void openCompact() => _layout.openCompact();

  /// Requests closure, even while wide if the host still sets compactOpen to true.
  void closeCompact() => isCompact ? _layout.closeCompact() : _closeWhileWide();

  /// Returns the nearest preset scope, or throws if there is no [FortalSidebarLayout].
  static FortalSidebarLayoutScope of(BuildContext context) =>
      maybeOf(context) ??
      (throw FlutterError(
        'FortalSidebarLayoutScope.of requires a '
        'FortalSidebarLayout ancestor.',
      ));

  /// Returns the nearest preset scope, or null if there is no [FortalSidebarLayout].
  static FortalSidebarLayoutScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FortalSidebarLayoutScope>();

  @override
  bool updateShouldNotify(FortalSidebarLayoutScope oldWidget) =>
      isCompact != oldWidget.isCompact ||
      isCompactOpen != oldWidget.isCompactOpen;
}
