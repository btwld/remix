import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

/// Space outside the compact panel so the scrim can still be tapped.
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
class HeroUiSidebarLayout extends StatelessWidget {
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
  Widget build(BuildContext context) => RemixSidebarLayout(
    sidebar: sidebar,
    body: body,
    header: header,
    compactBreakpoint: compactBreakpoint,
    inlineWidth: collapsed ? collapsedWidth : sidebarWidth,
    compactOpen: compactOpen,
    onCompactOpenChanged: onCompactOpenChanged,
    compactBarrierColorBuilder: (context) =>
        MixScope.tokenOf(HeroUiTokens.backdrop, context),
    compactPanelBuilder: _buildCompactPanel,
  );

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
        child: child,
      ),
    );
  }
}

/// Scope available from [HeroUiSidebarLayout] and its compact navigation sheet.
typedef HeroUiSidebarLayoutScope = RemixSidebarLayoutScope;
