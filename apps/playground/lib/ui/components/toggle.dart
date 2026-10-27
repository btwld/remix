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
/// A toggle is a button that stays pressed. Remix owns the rendering, the
/// pointer and keyboard behavior, and the on/off semantics; this recipe owns
/// the geometry and the off/hover/on/focus/disabled fragments.
///
/// A toggle that is on sits on `accent` in `accentForeground`; a ghost toggle
/// under the pointer sits on `muted` in `mutedForeground`. In the shipped
/// themes the two surfaces are the same gray, so "on" is told from "pointed at"
/// by its full-strength content, and a toggle that is on stays on when hovered.
/// An outline toggle hovers onto `accent` instead, and keeps its outline in
/// every state.
@MixWidget(target: RemixToggle.new)
ToggleStyler playgroundToggleStyle({
  PlaygroundToggleVariant variant = .ghost,
  PlaygroundToggleSize size = .medium,
  ToggleStyler style = const ToggleStyler.create(),
}) {
  return _base(_metricsFor(size))
      .merge(_variantStyle(variant))
      // After the variant's hover, so a toggle that is on stays on under the
      // pointer.
      .onSelected(
        _content(
          PlaygroundTokens.accentForeground(),
        ).color(PlaygroundTokens.accent()),
      )
      .onFocusVisible(_focusVisibleStyle(variant))
      .onDisabled(_disabledStyle())
      .merge(style);
}

/// A fill that paints nothing, used while the toggle is off.
const _noFill = Color(0x00000000);

/// Geometry for one [PlaygroundToggleSize]: 32px with a 6px side inset, 36px with
/// 8, and 40px with 10.
///
/// The minimum width equals the height, so an icon-only toggle is square.
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

/// Layout, typography, and the off appearance shared by both variants.
ToggleStyler _base(_PlaygroundToggleMetrics metrics) =>
    _content(PlaygroundTokens.foreground())
        .animate(PlaygroundTokens.motion)
        .color(_noFill)
        .direction(.horizontal)
        .mainAxisSize(.min)
        .mainAxisAlignment(.center)
        .crossAxisAlignment(.center)
        .minHeight(metrics.minHeight)
        .minWidth(metrics.minHeight)
        .padding(.horizontal(metrics.paddingX))
        .spacing(PlaygroundTokens.s2)
        .borderRadius(.all(PlaygroundTokens.radiusMd()))
        .label(
          .style(PlaygroundTokens.textSm.mix()).fontWeight(FontWeight.w500),
        )
        .icon(.size(PlaygroundTokens.icon));

/// The variant's outline and its hover.
ToggleStyler _variantStyle(PlaygroundToggleVariant variant) =>
    switch (variant) {
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
            .onHovered(
              _content(
                PlaygroundTokens.accentForeground(),
              ).color(PlaygroundTokens.accent()),
            ),
    };

/// Applies one content color to the label and the icons.
ToggleStyler _content(Color foreground) =>
    ToggleStyler().label(.color(foreground)).icon(.color(foreground));

/// The keyboard focus ring: a 3px band of `ring` at half strength.
///
/// An outline rather than a border: `RemixBoxEffects` paints it outside the
/// toggle without taking layout space, so focusing one never reflows the row
/// it sits in. The outline variant also turns its own border `ring`.
ToggleStyler _focusVisibleStyle(PlaygroundToggleVariant variant) {
  final ring = ToggleStyler().containerEffects(playgroundFocusRing());

  return switch (variant) {
    .ghost => ring,
    .outline => ring.border(playgroundFocusBorder()),
  };
}

/// Declared last so it wins over every other state fragment.
///
/// A disabled toggle keeps whatever surface its state gives it and simply
/// fades; the focus ring is cleared because a disabled control that still
/// draws a focus ring reads as actionable.
ToggleStyler _disabledStyle() => ToggleStyler()
    .containerEffects(.outline(.style(.none)))
    .wrap(.opacity(PlaygroundTokens.disabledOpacity));
