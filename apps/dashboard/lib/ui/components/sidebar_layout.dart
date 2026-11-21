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
/// controlled through [UiSidebarLayoutScope] or the [compactOpen] property.
///
/// When [compactOpen] is `null`, the layout manages sheet visibility
/// internally. When [compactOpen] is non-null, the host controls visibility and
/// must update [compactOpen] to `false` when [onCompactOpenChanged] requests
/// dismissal.
///
/// ```dart
/// UiSidebarLayout(
///   sidebar: UiSidebar<AppPage>(
///     sections: sections,
///     selectedValue: page,
///     onSelected: (value) {
///       setState(() => page = value);
///       UiSidebarLayoutScope.of(context).closeCompact();
///     },
///   ),
///   header: const UiAppBar(title: 'Overview'),
///   body: PageBody(page: page),
/// )
/// ```
class UiSidebarLayout extends StatefulWidget {
  const UiSidebarLayout({
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
  State<UiSidebarLayout> createState() => _UiSidebarLayoutState();

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
            .color(UiTokens.colorPanelSolid())
            .foregroundDecoration(
              BoxDecorationMix(
                border: BorderDirectionalMix(
                  end: BorderSideMix(
                    color: UiTokens.grayA5(),
                    width: UiTokens.borderWidth1(),
                  ),
                ),
              ),
            ),
        child: child,
      ),
    );
  }
}

class _UiSidebarLayoutState extends State<UiSidebarLayout> {
  final _bodyKey = GlobalKey();

  Widget _scoped(Widget child, {Key? key}) => Builder(
    key: key,
    builder: (context) => UiSidebarLayoutScope._(
      RemixSidebarLayoutScope.of(context),
      () => (_bodyKey.currentContext ?? context)
          .getInheritedWidgetOfExactType<RemixSidebarLayoutScope>()!,
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
    body: _scoped(widget.body, key: _bodyKey),
    header: widget.header == null ? null : _scoped(widget.header!),
    compactBreakpoint: widget.compactBreakpoint,
    inlineWidth: widget.collapsed ? widget.collapsedWidth : widget.sidebarWidth,
    compactOpen: widget.compactOpen,
    onCompactOpenChanged: widget.onCompactOpenChanged,
    compactBarrierColorBuilder: (context) =>
        MixScope.tokenOf(UiTokens.colorOverlay, context),
    compactPanelBuilder: widget._buildCompactPanel,
  );
}

/// Scope available from [UiSidebarLayout] and its compact navigation sheet.
class UiSidebarLayoutScope extends InheritedWidget {
  const UiSidebarLayoutScope._(
    this._layout,
    this._currentLayout,
    this._closeWhileWide, {
    required super.child,
  });

  final RemixSidebarLayoutScope _layout;
  final ValueGetter<RemixSidebarLayoutScope> _currentLayout;
  final VoidCallback _closeWhileWide;

  /// Whether the layout is currently in its compact presentation.
  bool get isCompact => _layout.isCompact;

  /// Whether the compact sheet is open. Always false while wide.
  bool get isCompactOpen => _layout.isCompactOpen;

  /// Opens the compact sheet. Has no effect while wide.
  void openCompact() => _currentLayout().openCompact();

  /// Requests closure, even while wide if the host still sets compactOpen to true.
  void closeCompact() {
    final layout = _currentLayout();
    if (layout.isCompact) {
      layout.closeCompact();
    } else {
      _closeWhileWide();
    }
  }

  /// Returns the nearest preset scope, or throws if there is no [UiSidebarLayout].
  static UiSidebarLayoutScope of(BuildContext context) =>
      maybeOf(context) ??
      (throw FlutterError(
        'UiSidebarLayoutScope.of requires a '
        'UiSidebarLayout ancestor.',
      ));

  /// Returns the nearest preset scope, or null if there is no [UiSidebarLayout].
  static UiSidebarLayoutScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<UiSidebarLayoutScope>();

  @override
  bool updateShouldNotify(UiSidebarLayoutScope oldWidget) =>
      isCompact != oldWidget.isCompact ||
      isCompactOpen != oldWidget.isCompactOpen;
}
