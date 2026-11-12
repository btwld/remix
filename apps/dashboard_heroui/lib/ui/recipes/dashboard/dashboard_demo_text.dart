import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../theme/theme.dart';

/// The text sizes the demo uses, named as HeroUI's typography names them.
///
/// The theme carries only `text-xs`, `text-sm` and `text-base`; the headings
/// set Tailwind's larger sizes over `text-base`, as `UiTypography` does,
/// so the demo does not need the `typography` item and its fonts package.
enum UiDashboardTextType { h3, h4, h6, bodySm, bodyXs }

/// One run of demo copy in HeroUI's type scale.
///
/// Headings are semibold and tightly tracked. [emphasized] makes body copy
/// medium, HeroUI's weight for labels and titles; [muted] uses `muted`.
class UiDashboardText extends StatelessWidget {
  const UiDashboardText(
    this.value, {
    super.key,
    this.type = .bodySm,
    this.emphasized = false,
    this.muted = false,
  });

  /// The text to show.
  final String value;

  /// The text size and weight preset.
  final UiDashboardTextType type;

  /// Whether to use the semibold weight.
  final bool emphasized;

  /// Whether to use the muted foreground color.
  final bool muted;

  @override
  Widget build(BuildContext context) => StyledText(
    value,
    style: uiDashboardTextStyle(
      type: type,
      emphasized: emphasized,
      muted: muted,
    ),
  );
}

/// The style [UiDashboardText] draws with, for widgets that take a
/// [TextStyler].
TextStyler uiDashboardTextStyle({
  UiDashboardTextType type = .bodySm,
  bool emphasized = false,
  bool muted = false,
}) {
  final (token, size, height, heading) = switch (type) {
    .h3 => (UiTokens.textBase, 24.0, 32.0, true),
    .h4 => (UiTokens.textBase, 20.0, 28.0, true),
    .h6 => (UiTokens.textBase, 16.0, 24.0, true),
    .bodySm => (UiTokens.textSm, 14.0, 20.0, false),
    .bodyXs => (UiTokens.textXs, 12.0, 16.0, false),
  };
  return TextStyler()
      .style(token.mix())
      .fontSize(size)
      .height(height / size)
      .fontWeight(
        heading
            ? FontWeight.w600
            : (emphasized ? FontWeight.w500 : FontWeight.w400),
      )
      .color(muted ? UiTokens.muted() : UiTokens.foreground())
      .merge(heading ? TextStyler().letterSpacing(_tracking * size) : null);
}

/// `tracking-tight` on headings.
const _tracking = -0.025;

/// The toast every demo action reports itself with, in the scope's style.
void uiDashboardToast(BuildContext context, String title) => showRemixToast(
  context,
  RemixToastData(title: title, icon: RemixIcons.checkCircle),
);

/// A single choice among a few values, drawn as HeroUI's primary tabs pill.
///
/// HeroUI has no segmented control, and a choice that only changes a value
/// has no panels for a tab list to control, so this is a
/// [RemixSegmentedControl]: one labelled group of options, as the
/// other presets' demos use. It wears the `tabs` recipe's primary look, restated from the
/// same tokens: the `default` list with its `p-1` inset and
/// `calc(var(--radius) * 2.5)` corners, and `h-8 px-4` `text-sm` medium
/// segments in `muted`, the chosen one raised on `segment` with
/// `segment-foreground` and the surface shadow. Segments share one width, as
/// every segmented control's do.
class UiDashboardSegments<T extends Object> extends StatelessWidget {
  const UiDashboardSegments({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.semanticLabel,
  });

  final List<({T value, String label})> items;

  /// The value of the chosen item.
  final T selectedValue;

  /// Called with the value of the item the user picks.
  final ValueChanged<T> onChanged;

  /// The group's accessible label.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => RemixSegmentedControl<T>(
    semanticLabel: semanticLabel,
    selectedValue: selectedValue,
    onChanged: onChanged,
    style: uiDashboardSegmentsStyle(),
    items: [
      for (final item in items)
        RemixSegmentedControlItem(value: item.value, label: item.label),
    ],
  );
}

/// The primary tabs pill as a [RemixSegmentedControl] style.
SegmentedControlStyler uiDashboardSegmentsStyle() => SegmentedControlStyler()
    .color(UiTokens.defaultColor())
    .borderRadius(.all(_segmentsRadius()))
    .padding(.all(_segmentsInset))
    .mainAxisSize(.min)
    .spacing(0)
    .item(
      SegmentedControlItemStyler()
          .minHeight(_segmentHeight)
          .padding(.horizontal(_segmentPaddingX))
          .borderRadius(.all(UiTokens.radius3xl()))
          .label(
            .style(
              UiTokens.textSm.mix(),
            ).fontWeight(.w500).color(UiTokens.muted()),
          )
          // Unchosen segments fade on hover; the chosen one restores it.
          .onHovered(SegmentedControlItemStyler().wrap(.opacity(_hoverOpacity)))
          .onSelected(
            SegmentedControlItemStyler()
                .color(UiTokens.segment())
                .label(.color(UiTokens.segmentForeground()))
                .containerEffects(uiSurfaceEffects())
                .wrap(.opacity(1)),
          )
          .onFocusVisible(
            SegmentedControlItemStyler().containerEffects(uiFocusRing()),
          )
          .onDisabled(
            SegmentedControlItemStyler().wrap(
              .opacity(UiTokens.disabledOpacity),
            ),
          )
          .animate(UiTokens.smoothMotion),
    );

/// `.tabs__list`: `p-1`, with `calc(var(--radius) * 2.5)` corners.
const _segmentsInset = 4.0;
final _segmentsRadius = uiRadius(UiTokens.radiusLg, scale: 2.5);

/// `.tabs__tab`: `h-8 px-4`, and `opacity-70` while hovered.
const _segmentHeight = 32.0;
const _segmentPaddingX = 16.0;
const _hoverOpacity = .7;

/// A secondary checkbox on a card, with a resting `muted` edge.
///
/// The secondary fill, `default`, is nearly the card's `surface` in both
/// modes, so an unchecked box would show no edge. `muted` clears 3:1 against
/// `surface` in both modes (4.83 light, 6.74 dark); no border token does. The outline sits inside the
/// box, so it keeps its 16px, and goes once the box is checked or
/// indeterminate, where the accent fill marks it. Keyboard focus still swaps
/// it for the focus ring.
final uiDashboardCardCheckboxStyle = CheckboxStyler()
    .containerEffects(
      RemixBoxEffectsMix(
        outline: BorderSideMix(
          color: UiTokens.muted(),
          width: _checkboxEdgeWidth,
        ),
        outlineOffset: -_checkboxEdgeWidth,
      ),
    )
    .onSelected(.containerEffects(.outline(.style(.none))))
    .onIndeterminate(.containerEffects(.outline(.style(.none))));

/// HeroUI's `border-width`.
const _checkboxEdgeWidth = 1.0;
