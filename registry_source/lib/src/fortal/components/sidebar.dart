import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'text.dart';
import 'toggle.dart';
import 'tooltip.dart';

part 'sidebar.g.dart';

const _sectionLabelLetterSpacing = 0.7;

/// The Fortal Sidebar recipe.
///
/// It paints the solid panel surface with a trailing edge border,
/// pads the scrolling destination region, keeps section labels compact and
/// muted, separates sections with the `space2` token, and reuses the
/// ghost `size2` toggle treatment inside full-width destinations with a
/// 40-logical-pixel minimum height. The footer carries the divider that
/// separates account content from navigation. [highContrast] strengthens
/// section content without changing layout.
/// [panelPadding] applies host-owned insets inside the painted panel surface.
///
/// The recipe sets no panel width and no header padding. The host can supply
/// expanded/collapsed widths to the widget for coordinated animation, or size
/// the panel itself. Header metrics usually match the app bar beside it: a
/// `FortalTokens.space9` height lines the header up with `app_bar`.
@MixWidget(target: RemixSidebar.new)
SidebarStyler fortalSidebarStyle({
  bool highContrast = false,
  bool collapsed = false,
  EdgeInsetsGeometry? panelPadding,
  SidebarStyler style = const SidebarStyler.create(),
}) {
  final horizontalPadding = collapsed
      ? _horizontalPaddingCollapsed()
      : _horizontalPaddingExpanded();
  final destinationLeftPadding = collapsed
      ? _destinationLeftPaddingCollapsed()
      : _destinationLeftPaddingExpanded();
  final destinationRightPadding = collapsed
      ? _destinationRightPaddingCollapsed()
      : _destinationRightPaddingExpanded();
  final selectedContent = FortalTokens.accent12();

  return SidebarStyler(
    container:
        FlexBoxStyler(padding: EdgeInsetsGeometryMix.maybeValue(panelPadding))
            .color(FortalTokens.colorPanelSolid())
            .border(
              .end(
                .color(
                  FortalTokens.grayA5(),
                ).width(FortalTokens.borderWidth1()),
              ),
            ),
    content: FlexBoxStyler()
        .spacing(FortalTokens.space2())
        .padding(
          .only(
            left: horizontalPadding,
            right: horizontalPadding,
            top: FortalTokens.space4(),
            bottom: FortalTokens.space4(),
          ),
        ),
    footer: BoxStyler().border(
      .top(.color(FortalTokens.gray6()).width(FortalTokens.borderWidth1())),
    ),
    sectionLabel: fortalTextStyle(size: .size1, weight: .medium)
        .color(highContrast ? FortalTokens.gray12() : FortalTokens.gray11())
        .uppercase()
        .letterSpacing(_sectionLabelLetterSpacing)
        .wrap(
          .padding(
            .symmetric(
              horizontal: FortalTokens.space4(),
              vertical: FortalTokens.space2(),
            ),
          ),
        ),
    tooltip: fortalTooltipStyle(),
    destinations: FlexBoxStyler().spacing(0),
    destination:
        fortalToggleStyle(
              variant: .ghost,
              size: .size2,
              highContrast: highContrast,
            )
            .minHeight(FortalTokens.sidebarDestinationMinHeight())
            // Selected rows sit a step above the hover fill with full-contrast
            // content. The shared ghost toggle's accent3 fill matches the
            // gray hover fill under the default accent.
            .onSelected(
              ToggleStyler()
                  .color(FortalTokens.accent5())
                  .labelColor(selectedContent)
                  .iconColor(selectedContent)
                  .onHovered(ToggleStyler().color(FortalTokens.accent6()))
                  .onPressed(ToggleStyler().color(FortalTokens.accent7())),
            )
            // Keeps labels clear of the row edges once text outgrows the
            // minimum height.
            .padding(
              .only(
                left: destinationLeftPadding,
                right: destinationRightPadding,
                top: FortalTokens.space2(),
                bottom: FortalTokens.space2(),
              ),
            )
            .container(
              FlexBoxStyler().mainAxisSize(.max).mainAxisAlignment(.start),
            ),
  ).merge(style);
}

/// The panel's inset on both sides, between the rail's `space2` and the
/// expanded `space3`.
///
/// Both endpoints resolve before interpolation, so theme scaling stays live.
/// While the sidebar animates, the inset follows its expansion.
double _inset(BuildContext context, {required bool collapsed}) {
  final expansion =
      RemixSidebar.maybeAnimationOf(context)?.expansion ??
      (collapsed ? 0.0 : 1.0);
  final rail = FortalTokens.space2.resolve(context);
  final expanded = FortalTokens.space3.resolve(context);

  return rail + (expanded - rail) * expansion;
}

/// Repays the narrowing panel inset on the leading side so icons hold still.
///
/// Icons stay `space3 + space4` from the panel's leading edge: expanded rows
/// start at `space4`, and the rail's narrower inset is added back here. A 72px
/// dashboard rail then settles each icon on its center line. The trailing side
/// keeps the toggle's `space3`. Sides are physical so this merges with the
/// toggle's own horizontal padding; the text direction picks the leading one.
double _destinationInset(
  BuildContext context, {
  required bool collapsed,
  required bool left,
}) {
  final trailing = FortalTokens.space3.resolve(context);
  final leading = (Directionality.of(context) == TextDirection.ltr) == left;
  if (!leading) return trailing;

  return trailing +
      FortalTokens.space4.resolve(context) -
      _inset(context, collapsed: collapsed);
}

final _horizontalPaddingExpanded = ContextToken<double>(
  (context) => _inset(context, collapsed: false),
);

final _horizontalPaddingCollapsed = ContextToken<double>(
  (context) => _inset(context, collapsed: true),
);

final _destinationLeftPaddingExpanded = ContextToken<double>(
  (context) => _destinationInset(context, collapsed: false, left: true),
);

final _destinationLeftPaddingCollapsed = ContextToken<double>(
  (context) => _destinationInset(context, collapsed: true, left: true),
);

final _destinationRightPaddingExpanded = ContextToken<double>(
  (context) => _destinationInset(context, collapsed: false, left: false),
);

final _destinationRightPaddingCollapsed = ContextToken<double>(
  (context) => _destinationInset(context, collapsed: true, left: false),
);
