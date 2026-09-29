import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/scale.dart';
import '../theme/tokens.dart';
import 'toggle.dart';
import 'tooltip.dart';

part 'sidebar.g.dart';

/// The application's Sidebar recipe.
///
/// A sidebar is the navigation panel down one edge of an application shell.
/// Remix owns the rendering, the header/content/footer stacking, Tab traversal
/// across destinations, the selection semantics, and the navigation
/// landmark; this recipe owns the panel surface, the region insets, the
/// section rhythm, and the label type.
///
/// It takes no variant and no size. There is one panel per shell, and the
/// thing that actually varies between applications — how wide it is — is not
/// the recipe's to decide: the host sizes the panel, because the same panel
/// is usually presented as a drawer at narrow widths and the drawer's width
/// is a layout decision. Nothing here sets a width, and nothing here pads the
/// header, whose metrics normally have to line up with an application top bar.
///
/// This recipe **depends on the `toggle` and `tooltip` items**, which is why
/// its registry entry lists both beside `theme`. A destination is a toggle: it
/// is a control that stays pressed, and `SidebarSpec` takes its style as a
/// `ToggleStyler` field. Handing it the application's own ghost toggle recipe
/// is what keeps a selected destination and a selected toggle the same colour
/// without restating one component inside another. The same reasoning covers
/// the tooltip: when the host collapses the panel to an icon rail, each
/// destination's label appears in the application's own tooltip recipe.
///
/// The panel is shadcn's sidebar: the `sidebar` surface, a step apart from
/// the page, with a `sidebarBorder` edge. Destinations are 32px rows that sit
/// on `sidebarAccent` while hovered or current, and the current one is set at
/// medium weight. Everything shares one 8px inset, so labels, destinations,
/// and the footer line up on one left edge.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it:
///
/// ```dart
/// PlaygroundSidebar(
///   style: SidebarStyler().width(_shellSidebarWidth),
///   sections: sections,
///   selectedValue: current,
///   onSelected: go,
/// )
/// ```
@MixWidget(target: RemixSidebar.new)
SidebarStyler playgroundSidebarStyle({
  SidebarStyler style = const SidebarStyler.create(),
}) => SidebarStyler(
  container: FlexBoxStyler()
      .color(PlaygroundTokens.sidebar())
      .border(
        .end(
          .color(
            PlaygroundTokens.sidebarBorder(),
          ).width(PlaygroundStroke.hairline),
        ),
      ),
  content: FlexBoxStyler()
      .padding(.all(PlaygroundSpace.s2))
      .spacing(PlaygroundSpace.s4),
  footer: BoxStyler()
      .border(
        .top(
          .color(
            PlaygroundTokens.sidebarBorder(),
          ).width(PlaygroundStroke.hairline),
        ),
      )
      .padding(.all(PlaygroundSpace.s2)),
  // shadcn's `SidebarGroupLabel`: a 32px row of `textXs` at medium weight in
  // `sidebarForeground` at 70%, inset like the destinations below it. It is
  // the quietest text in the panel, so it reads as a heading for the
  // destinations rather than as one of them.
  sectionLabel: TextStyler()
      .style(PlaygroundTokens.textXs.mix())
      .fontWeight(FontWeight.w500)
      .color(_labelColor())
      .wrap(
        .padding(
          .symmetric(
            horizontal: PlaygroundSpace.s2,
            vertical: PlaygroundSpace.s2,
          ),
        ),
      ),
  destinations: FlexBoxStyler().spacing(PlaygroundSpace.s1),
  destination: _destinationStyle(),
  // A collapsed rail shows each destination's label in the application's own
  // tooltip, so it reads like every other tooltip in the app.
  tooltip: playgroundTooltipStyle(),
).merge(style);

/// The section label's color: `sidebarForeground` at 70%, which clears 4.5:1
/// on the `sidebar` surface in both themes.
final _labelColor = playgroundTint(
  PlaygroundTokens.sidebarForeground,
  _labelAlpha,
);

/// See [_labelColor].
const _labelAlpha = 0.7;

/// One destination: the application's own ghost toggle, retuned to shadcn's
/// `SidebarMenuButton`.
///
/// A 32px row with an 8px inset on every side and an 8px gap, set in `textSm`
/// at regular weight in `sidebarForeground`. Hovered and current rows sit on
/// `sidebarAccent`; the current one is also set at medium weight, which is
/// what tells it from a hovered row in the shipped themes, where the two
/// share a surface.
ToggleStyler _destinationStyle() {
  final highlighted = ToggleStyler()
      .color(PlaygroundTokens.sidebarAccent())
      .label(.color(PlaygroundTokens.sidebarAccentForeground()))
      .icon(.color(PlaygroundTokens.sidebarAccentForeground()));

  return playgroundToggleStyle(variant: .ghost, size: .small)
      .container(.mainAxisSize(.max).mainAxisAlignment(.start))
      .minHeight(PlaygroundSize.controlSm)
      .padding(.all(PlaygroundSpace.s2))
      .spacing(PlaygroundSpace.s2)
      .label(
        .fontWeight(
          FontWeight.w400,
        ).color(PlaygroundTokens.sidebarForeground()),
      )
      .icon(.color(PlaygroundTokens.sidebarForeground()))
      .onHovered(highlighted)
      .onSelected(highlighted.label(.fontWeight(FontWeight.w500)));
}
