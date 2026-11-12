import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';
import 'toggle.dart';
import 'tooltip.dart';

part 'sidebar.g.dart';

/// The application's Sidebar recipe.
///
/// The navigation panel down one edge of a shell: the `sidebar` surface with a
/// `sidebarBorder` edge, 32px destinations that sit on `sidebarAccent` while
/// hovered or current, and one 8px inset so labels, destinations and the footer
/// share a left edge.
///
/// It sets no width: the host sizes the panel, which is often also a drawer. It
/// does not pad the header either, whose metrics should line up with the app
/// bar: give it the `app_bar` item's toolbar height and bottom hairline.
///
/// It depends on the `toggle` and `tooltip` items. A destination is a toggle
/// (`SidebarSpec` takes a `ToggleStyler`), so the ghost toggle recipe keeps a
/// selected destination and a selected toggle the same color; in a collapsed
/// icon rail each label appears in the application's tooltip recipe.
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
          ).width(PlaygroundTokens.strokeHairline),
        ),
      ),
  content: FlexBoxStyler()
      .padding(.all(PlaygroundTokens.s2))
      .spacing(PlaygroundTokens.s4),
  footer: BoxStyler()
      .border(
        .top(
          .color(
            PlaygroundTokens.sidebarBorder(),
          ).width(PlaygroundTokens.strokeHairline),
        ),
      )
      .padding(.all(PlaygroundTokens.s2)),
  // The quietest text in the panel: `sidebarForeground` at 70% (4.5:1 on the
  // surface in both themes), inset like the destinations below it.
  sectionLabel: TextStyler()
      .style(PlaygroundTokens.textXs.mix())
      .fontWeight(FontWeight.w500)
      .color(playgroundTint(PlaygroundTokens.sidebarForeground, 0.7)())
      .wrap(
        .padding(
          .symmetric(
            horizontal: PlaygroundTokens.s2,
            vertical: PlaygroundTokens.s2,
          ),
        ),
      ),
  destinations: FlexBoxStyler().spacing(PlaygroundTokens.s1),
  destination: _destinationStyle(),
  tooltip: playgroundTooltipStyle(),
).merge(style);

/// One destination: the ghost toggle retuned as a navigation row. Hovered and
/// current rows sit on `sidebarAccent`; the current one is also medium weight,
/// which tells it from a hovered row where the two share a surface.
ToggleStyler _destinationStyle() {
  final highlighted = ToggleStyler()
      .color(PlaygroundTokens.sidebarAccent())
      .label(.color(PlaygroundTokens.sidebarAccentForeground()))
      .icon(.color(PlaygroundTokens.sidebarAccentForeground()));

  final resolved = playgroundToggleStyle(variant: .ghost, size: .small)
      .container(.mainAxisSize(.max).mainAxisAlignment(.start))
      .minHeight(PlaygroundTokens.controlSm)
      // The reference is `h-8 p-2`, where the line overruns the padding.
      // Flutter lays it out inside, so 6px vertically keeps the row at 32.
      .padding(
        .symmetric(
          horizontal: PlaygroundTokens.s2,
          vertical: PlaygroundTokens.s1_5,
        ),
      )
      .spacing(PlaygroundTokens.s2)
      .label(
        .fontWeight(
          FontWeight.w400,
        ).color(PlaygroundTokens.sidebarForeground()),
      )
      .icon(.color(PlaygroundTokens.sidebarForeground()))
      .onHovered(highlighted)
      .onSelected(highlighted.label(.fontWeight(FontWeight.w500)));

  return ToggleStyler.create(
    container: resolved.$container,
    label: resolved.$label,
    icon: resolved.$icon,
    variants: resolved.$variants,
    modifier: resolved.$modifier,
  );
}
