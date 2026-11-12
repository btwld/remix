import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';

part 'toggle_group.g.dart';

/// The visual weights this application offers for a toggle group.
///
/// The same two the single toggle offers, because a group is a row of them.
enum PlaygroundToggleGroupVariant {
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
enum PlaygroundToggleGroupSize {
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
ToggleGroupStyler playgroundToggleGroupStyle({
  PlaygroundToggleGroupVariant variant = .ghost,
  PlaygroundToggleGroupSize size = .medium,
  ToggleGroupStyler style = const ToggleGroupStyler.create(),
}) {
  final height = switch (size) {
    .small => PlaygroundTokens.controlSm,
    .medium => PlaygroundTokens.controlMd,
    .large => PlaygroundTokens.controlLg,
  };

  return ToggleGroupStyler()
      .direction(.horizontal)
      .mainAxisSize(.min)
      .spacing(0)
      .borderRadius(.all(PlaygroundTokens.radiusMd()))
      // Rounds the first and last options, which are square.
      .clipBehavior(Clip.antiAlias)
      // No shadow: the strip has no effects layer, and a decoration shadow
      // under its transparent fill shows through as a gray wash.
      .merge(
        variant == .outline
            ? ToggleGroupStyler().border(
                .color(
                  PlaygroundTokens.input(),
                ).width(PlaygroundTokens.strokeHairline),
              )
            : null,
      )
      .item(
        _content(PlaygroundTokens.foreground())
            .color(_transparent)
            .direction(.horizontal)
            .mainAxisSize(.min)
            .mainAxisAlignment(.center)
            .crossAxisAlignment(.center)
            .minHeight(height)
            .padding(.horizontal(PlaygroundTokens.s3))
            .spacing(PlaygroundTokens.s2)
            .label(
              .style(PlaygroundTokens.textSm.mix()).fontWeight(FontWeight.w500),
            )
            .icon(.size(PlaygroundTokens.icon))
            .onHovered(switch (variant) {
              .ghost => _content(
                PlaygroundTokens.mutedForeground(),
              ).color(PlaygroundTokens.muted()),
              .outline => _content(
                PlaygroundTokens.accentForeground(),
              ).color(PlaygroundTokens.accent()),
            })
            .onSelected(
              _content(
                PlaygroundTokens.accentForeground(),
              ).color(PlaygroundTokens.accent()),
            )
            // Inside the option: the strip clips its options, so an outside
            // ring on the first or last would be cut off.
            .onFocusVisible(.containerEffects(playgroundFocusRing(inset: true)))
            // Declared last so it wins over every other state fragment.
            .onDisabled(
              ToggleGroupItemStyler()
                  .containerEffects(.outline(.style(.none)))
                  .wrap(.opacity(PlaygroundTokens.disabledOpacity)),
            ),
      )
      .merge(style);
}

const _transparent = Color(0x00000000);

/// One content color for the label and the icons.
ToggleGroupItemStyler _content(Color foreground) =>
    ToggleGroupItemStyler().label(.color(foreground)).icon(.color(foreground));
