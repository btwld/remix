import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';

part 'toggle.g.dart';

/// The visual weights this application offers for a toggle.
enum PlaygroundToggleVariant {
  /// No fill and no border until the toggle is hovered or on.
  ghost,

  /// An `input` outline, so the control is visible while off.
  outline,
}

/// The control densities this application offers for a toggle.
///
/// The same 32/36/40px heights the button uses, because a toggle usually sits
/// in a row beside one.
///
/// These are compact, web-oriented defaults. A touch-first application should
/// raise them to meet platform hit-target guidance.
enum PlaygroundToggleSize {
  /// 32px minimum height.
  small,

  /// 36px minimum height. The default.
  medium,

  /// 40px minimum height.
  large,
}

/// The application's Toggle recipe.
///
/// A button that stays pressed. Remix owns the on/off semantics. A toggle that
/// is on sits on `accent` in `accentForeground`; a ghost toggle under the
/// pointer sits on `muted`. In the shipped themes those are the same gray, so
/// "on" is told from "pointed at" by its full-strength content, and a toggle
/// that is on stays on under the pointer. An outline toggle hovers onto `accent`
/// and keeps its outline in every state.
@MixWidget(target: RemixToggle.new)
ToggleStyler playgroundToggleStyle({
  PlaygroundToggleVariant variant = .ghost,
  PlaygroundToggleSize size = .medium,
  ToggleStyler style = const ToggleStyler.create(),
}) {
  final metrics = _metricsFor(size);

  return _content(PlaygroundTokens.foreground())
      .animate(PlaygroundTokens.motion)
      .color(_transparent)
      .direction(.horizontal)
      .mainAxisSize(.min)
      .mainAxisAlignment(.center)
      .crossAxisAlignment(.center)
      .minHeight(metrics.minHeight)
      // Equal to the height, so an icon-only toggle is square.
      .minWidth(metrics.minHeight)
      .padding(.horizontal(metrics.paddingX))
      .spacing(PlaygroundTokens.s2)
      .borderRadius(.all(PlaygroundTokens.radiusMd()))
      .label(.style(PlaygroundTokens.textSm.mix()).fontWeight(FontWeight.w500))
      .icon(.size(PlaygroundTokens.icon))
      .merge(switch (variant) {
        .ghost => ToggleStyler().onHovered(
          _content(
            PlaygroundTokens.mutedForeground(),
          ).color(PlaygroundTokens.muted()),
        ),
        .outline =>
          ToggleStyler()
              .border(
                .color(
                  PlaygroundTokens.input(),
                ).width(PlaygroundTokens.strokeHairline),
              )
              // In the effects layer: the toggle is transparent, and a
              // decoration shadow would show through it.
              .containerEffects(.behindContent(PlaygroundShadow.xs.effects))
              .onHovered(
                _content(
                  PlaygroundTokens.accentForeground(),
                ).color(PlaygroundTokens.accent()),
              ),
      })
      // After the variant's hover, so a toggle that is on stays on under the
      // pointer.
      .onSelected(
        _content(
          PlaygroundTokens.accentForeground(),
        ).color(PlaygroundTokens.accent()),
      )
      .onFocusVisible(
        ToggleStyler()
            .containerEffects(playgroundFocusRing())
            .merge(
              variant == .outline
                  ? ToggleStyler().border(playgroundFocusBorder())
                  : null,
            ),
      )
      // Declared last so it wins; the ring is cleared because a disabled
      // control that still rings reads as actionable.
      .onDisabled(
        ToggleStyler()
            .containerEffects(.outline(.style(.none)))
            .wrap(.opacity(PlaygroundTokens.disabledOpacity)),
      )
      .merge(style);
}

const _transparent = Color(0x00000000);

/// Height and side inset for one [PlaygroundToggleSize]: 32px with a 6px inset,
/// 36px with 8, and 40px with 10.
typedef _PlaygroundToggleMetrics = ({double minHeight, double paddingX});

_PlaygroundToggleMetrics _metricsFor(PlaygroundToggleSize size) =>
    switch (size) {
      .small => (
        minHeight: PlaygroundTokens.controlSm,
        paddingX: PlaygroundTokens.s1_5,
      ),
      .medium => (
        minHeight: PlaygroundTokens.controlMd,
        paddingX: PlaygroundTokens.s2,
      ),
      .large => (
        minHeight: PlaygroundTokens.controlLg,
        paddingX: PlaygroundTokens.s2_5,
      ),
    };

/// One content color for the label and the icons.
ToggleStyler _content(Color foreground) =>
    ToggleStyler().label(.color(foreground)).icon(.color(foreground));
