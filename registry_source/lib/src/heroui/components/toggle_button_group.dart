import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'toggle_button.dart';

part 'toggle_button_group.g.dart';

/// HeroUI recipe for [RemixToggleGroup]: toggle buttons joined into one pill,
/// or [detached] with a gap.
///
/// Remix's group selects one item at a time; HeroUI's also offers multiple
/// selection. Items share the toggle button's looks without its pressed scale
/// (`.toggle-button-group .toggle-button:active`). The focus ring is drawn
/// inside each item, as upstream's `ring-inset`, so the group's clip keeps it,
/// except at the joined pill's rounded ends.
@MixWidget(target: RemixToggleGroup.new)
ToggleGroupStyler heroUiToggleButtonGroupStyle({
  HeroUiToggleButtonVariant variant = .defaultToggle,
  HeroUiToggleButtonSize size = .md,
  bool iconOnly = false,
  bool detached = false,
  ToggleGroupStyler style = const ToggleGroupStyler.create(),
}) {
  final fill = variant.fill?.call() ?? HeroUiTokens.transparent;
  final hover = variant.hover();
  final foreground = variant.foreground();

  var item =
      ToggleGroupItemStyler(
            container: FlexBoxStyler()
                .mainAxisSize(.min)
                .mainAxisAlignment(.center)
                .spacing(heroUiToggleButtonGap),
            label: TextStyler()
                .style(size.text.mix())
                .fontWeight(.w500)
                .color(foreground)
                .softWrap(false)
                .maxLines(1)
                .overflow(TextOverflow.ellipsis),
            icon: IconStyler().size(size.icon.mobile).color(foreground),
          )
          .height(size.height.mobile)
          .color(fill)
          .onBreakpoint(
            const Breakpoint.minWidth(HeroUiTokens.breakpointSm),
            ToggleGroupItemStyler().icon(IconStyler().size(size.icon.desktop)),
          )
          .onBreakpoint(
            const Breakpoint.minWidth(HeroUiTokens.breakpointMd),
            ToggleGroupItemStyler().height(size.height.desktop),
          );

  item = iconOnly
      ? item
            .width(size.height.mobile)
            .onBreakpoint(
              const Breakpoint.minWidth(HeroUiTokens.breakpointMd),
              ToggleGroupItemStyler().width(size.height.desktop),
            )
      : item.padding(.horizontal(size.paddingX));

  item = item
      .onHovered(ToggleGroupItemStyler().color(hover))
      .onPressed(ToggleGroupItemStyler().color(hover))
      .onSelected(
        ToggleGroupItemStyler()
            .color(HeroUiTokens.accentSoft())
            .labelColor(HeroUiTokens.accentSoftForeground())
            .iconColor(HeroUiTokens.accentSoftForeground())
            .onHovered(
              ToggleGroupItemStyler().color(HeroUiTokens.accentSoftHover()),
            )
            .onPressed(
              ToggleGroupItemStyler().color(HeroUiTokens.accentSoftHover()),
            ),
      )
      .onFocusVisible(
        ToggleGroupItemStyler().containerEffects(heroUiInsetFocusRing),
      )
      .onDisabled(
        ToggleGroupItemStyler().wrap(.opacity(HeroUiTokens.disabledOpacity)),
      )
      .animate(HeroUiTokens.fillMotion);

  // Attached items are square inside one rounded, clipped pill.
  final container = detached
      ? FlexBoxStyler().spacing(_detachedGap)
      : FlexBoxStyler()
            .borderRadius(.all(HeroUiTokens.radius3xl()))
            .clipBehavior(.antiAlias);

  return ToggleGroupStyler(
    // Items keep their size and their one-line labels, so a group of long
    // ones is wider than a phone, as upstream's `w-fit` group is. Scrolling
    // the row contains it within the available width, the way the tab strip
    // does, instead of overflowing it. The group's own intrinsic width sizes
    // the viewport, so a group that fits still shrink-wraps and one in an
    // unbounded row still lays out. A vertical group scrolls the same axis:
    // its labels are the part that outgrows the width.
    container: container.wrap(.scrollView(scrollDirection: .horizontal)),
    item: detached ? item.borderRadius(.all(HeroUiTokens.radius3xl())) : item,
  ).merge(style);
}

/// `.toggle-button-group--detached`: `gap-1`.
const _detachedGap = 4.0;
