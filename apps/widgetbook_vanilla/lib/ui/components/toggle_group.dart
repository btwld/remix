import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';

part 'toggle_group.g.dart';

/// The visual weights this application offers for a toggle group.
///
/// The same two the single toggle offers, because a group is a row of them.
enum VanillaToggleGroupVariant {
  /// No fill and no border until an option is hovered or on.
  ghost,

  /// An `input` outline around the whole group, so the set is visible while
  /// off.
  outline,
}

/// The control densities this application offers for a toggle group.
///
/// These are compact, web-oriented defaults. A touch-first application should
/// raise them to meet platform hit-target guidance.
enum VanillaToggleGroupSize {
  /// 32px minimum height.
  small,

  /// 36px minimum height. The default.
  medium,

  /// 40px minimum height.
  large,
}

/// The application's ToggleGroup recipe.
///
/// Toggles that share one selection, drawn as one control: options edge to edge
/// with no gap, the strip rounded and clipped as a whole, and the outline
/// variant drawing one outline around the strip. Each option has the single
/// toggle's states: `muted` under the pointer, `accent` while on.
///
/// `item` is the default every `RemixToggleGroupItem` resolves against, so one
/// recipe styles the strip and its options.
@MixWidget(target: RemixToggleGroup.new)
ToggleGroupStyler vanillaToggleGroupStyle({
  VanillaToggleGroupVariant variant = .ghost,
  VanillaToggleGroupSize size = .medium,
  ToggleGroupStyler style = const ToggleGroupStyler.create(),
}) {
  final height = switch (size) {
    .small => VanillaTokens.controlSm,
    .medium => VanillaTokens.controlMd,
    .large => VanillaTokens.controlLg,
  };

  return ToggleGroupStyler()
      .direction(.horizontal)
      .mainAxisSize(.min)
      .spacing(0)
      .borderRadius(.all(VanillaTokens.radiusMd()))
      // Rounds the first and last options, which are square.
      .clipBehavior(Clip.antiAlias)
      // No shadow: the strip has no effects layer, and a decoration shadow
      // under its transparent fill shows through as a gray wash.
      .merge(
        variant == .outline
            ? ToggleGroupStyler().border(
                .color(
                  VanillaTokens.input(),
                ).width(VanillaTokens.strokeHairline),
              )
            : null,
      )
      .item(
        _content(VanillaTokens.foreground())
            .color(_transparent)
            .direction(.horizontal)
            .mainAxisSize(.min)
            .mainAxisAlignment(.center)
            .crossAxisAlignment(.center)
            .minHeight(height)
            .padding(.horizontal(VanillaTokens.s3))
            .spacing(VanillaTokens.s2)
            .label(
              .style(VanillaTokens.textSm.mix()).fontWeight(FontWeight.w500),
            )
            .icon(.size(VanillaTokens.icon))
            .onHovered(switch (variant) {
              .ghost => _content(
                VanillaTokens.mutedForeground(),
              ).color(VanillaTokens.muted()),
              .outline => _content(
                VanillaTokens.accentForeground(),
              ).color(VanillaTokens.accent()),
            })
            .onSelected(
              _content(
                VanillaTokens.accentForeground(),
              ).color(VanillaTokens.accent()),
            )
            // Inside the option: the strip clips its options, so an outside
            // ring on the first or last would be cut off.
            .onFocusVisible(.containerEffects(vanillaFocusRing(inset: true)))
            // Declared last so it wins over every other state fragment.
            .onDisabled(
              ToggleGroupItemStyler()
                  .containerEffects(.outline(.style(.none)))
                  .wrap(.opacity(VanillaTokens.disabledOpacity)),
            ),
      )
      .merge(style);
}

const _transparent = Color(0x00000000);

/// One content color for the label and the icons.
ToggleGroupItemStyler _content(Color foreground) =>
    ToggleGroupItemStyler().label(.color(foreground)).icon(.color(foreground));
