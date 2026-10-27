import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'text.dart';
import 'toggle.dart';
import 'tooltip.dart';

part 'sidebar.g.dart';

const _sectionLabelHorizontalPadding = 14.0;
const _sectionLabelVerticalPadding = 6.0;
const _sectionLabelLetterSpacing = 0.7;
const _destinationSpacing = 2.0;
const _minimumDestinationTargetHeight = 48.0;

/// Ui-themed preset for [RemixSidebar].
///
/// The recipe paints the solid panel surface with a trailing edge border,
/// pads the scrolling destination region, keeps section labels compact and
/// muted, separates sections with the `space3` token, and reuses the
/// ghost `size2` toggle treatment inside full-width destinations with a
/// 48-logical-pixel minimum height. The footer carries the divider that
/// separates account content from navigation. [highContrast] strengthens
/// section and selected destination content without changing layout.
/// [panelPadding] applies host-owned insets inside the painted panel surface.
///
/// The recipe sets no panel width and no header padding. The host can supply
/// expanded/collapsed widths to the widget for coordinated animation, or size
/// the panel itself. Header metrics usually match the app bar beside it: a
/// `UiTokens.space9` height lines the header up with `app_bar`.
@MixWidget(target: RemixSidebar.new)
SidebarStyler uiSidebarStyle({
  bool highContrast = false,
  bool collapsed = false,
  EdgeInsetsGeometry? panelPadding,
  SidebarStyler style = const SidebarStyler.create(),
}) {
  final horizontalPadding = collapsed
      ? _sidebarHorizontalPaddingCollapsed()
      : _sidebarHorizontalPaddingExpanded();
  final destinationLeftPadding = collapsed
      ? _destinationLeftPaddingCollapsed()
      : _destinationLeftPaddingExpanded();
  final destinationRightPadding = collapsed
      ? _destinationRightPaddingCollapsed()
      : _destinationRightPaddingExpanded();
  return SidebarStyler(
    container:
        FlexBoxStyler(padding: EdgeInsetsGeometryMix.maybeValue(panelPadding))
            .color(UiTokens.colorPanelSolid())
            .border(
              .end(.color(UiTokens.grayA5()).width(UiTokens.borderWidth1())),
            ),
    content: FlexBoxStyler()
        .spacing(UiTokens.space3())
        .padding(
          .only(
            left: horizontalPadding,
            right: horizontalPadding,
            top: UiTokens.space4(),
            bottom: UiTokens.space4(),
          ),
        ),
    footer: BoxStyler().border(
      .top(.color(UiTokens.gray6()).width(UiTokens.borderWidth1())),
    ),
    sectionLabel: uiTextStyle(size: .size1, weight: .medium)
        .color(highContrast ? UiTokens.gray12() : UiTokens.gray11())
        .uppercase()
        .letterSpacing(_sectionLabelLetterSpacing)
        .wrap(
          .padding(
            .symmetric(
              horizontal: _sectionLabelHorizontalPadding,
              vertical: _sectionLabelVerticalPadding,
            ),
          ),
        ),
    tooltip: uiTooltipStyle(),
    destinations: FlexBoxStyler().spacing(_destinationSpacing),
    destination:
        uiToggleStyle(variant: .ghost, size: .size2, highContrast: highContrast)
            .minHeight(_minimumDestinationTargetHeight)
            .padding(
              .only(
                left: destinationLeftPadding,
                right: destinationRightPadding,
              ),
            )
            .container(.mainAxisSize(.max).mainAxisAlignment(.start))
            // RemixSidebar paints a destination's container but not its
            // containerEffects, so the toggle's ring is drawn as a border here.
            .onFocusVisible(
              ToggleStyler().border(
                .color(UiTokens.focusA8())
                    .width(UiTokens.focusRingWidth())
                    .strokeAlign(BorderSide.strokeAlignInside),
              ),
            ),
  ).merge(style);
}

/// Resolve both endpoints before interpolation so theme scaling stays live.
double _resolveSidebarHorizontalPadding(BuildContext context, bool collapsed) {
  final expansion =
      RemixSidebar.maybeAnimationOf(context)?.expansion ??
      (collapsed ? 0.0 : 1.0);
  final rail = UiTokens.space2.resolve(context);
  final expanded = UiTokens.space3.resolve(context);
  return rail + (expanded - rail) * expansion;
}

double _resolveSidebarHorizontalPaddingExpanded(BuildContext context) =>
    _resolveSidebarHorizontalPadding(context, false);

double _resolveSidebarHorizontalPaddingCollapsed(BuildContext context) =>
    _resolveSidebarHorizontalPadding(context, true);

const _sidebarHorizontalPaddingExpanded = ContextToken<double>(
  _resolveSidebarHorizontalPaddingExpanded,
);

const _sidebarHorizontalPaddingCollapsed = ContextToken<double>(
  _resolveSidebarHorizontalPaddingCollapsed,
);

/// Repays the narrowing panel inset on the leading side so icons hold still.
///
/// Icons stay `space3 + space4` from the panel's leading edge: expanded rows
/// start at `space4`, and the rail's narrower inset is added back here. A 72px
/// dashboard rail then settles each icon on its center line. The trailing side
/// keeps the toggle's `space3`. Sides are physical so this merges with the
/// toggle's own horizontal padding; the text direction picks the leading one.
double _resolveDestinationInlinePadding(
  BuildContext context, {
  required bool collapsed,
  required bool left,
}) {
  final trailing = UiTokens.space3.resolve(context);
  final leading = (Directionality.of(context) == TextDirection.ltr) == left;
  if (!leading) return trailing;
  return trailing +
      UiTokens.space4.resolve(context) -
      _resolveSidebarHorizontalPadding(context, collapsed);
}

double _resolveDestinationLeftPaddingExpanded(BuildContext context) =>
    _resolveDestinationInlinePadding(context, collapsed: false, left: true);

double _resolveDestinationLeftPaddingCollapsed(BuildContext context) =>
    _resolveDestinationInlinePadding(context, collapsed: true, left: true);

double _resolveDestinationRightPaddingExpanded(BuildContext context) =>
    _resolveDestinationInlinePadding(context, collapsed: false, left: false);

double _resolveDestinationRightPaddingCollapsed(BuildContext context) =>
    _resolveDestinationInlinePadding(context, collapsed: true, left: false);

const _destinationLeftPaddingExpanded = ContextToken<double>(
  _resolveDestinationLeftPaddingExpanded,
);

const _destinationLeftPaddingCollapsed = ContextToken<double>(
  _resolveDestinationLeftPaddingCollapsed,
);

const _destinationRightPaddingExpanded = ContextToken<double>(
  _resolveDestinationRightPaddingExpanded,
);

const _destinationRightPaddingCollapsed = ContextToken<double>(
  _resolveDestinationRightPaddingCollapsed,
);
