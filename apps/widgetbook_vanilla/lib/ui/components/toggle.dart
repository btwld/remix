import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';

part 'toggle.g.dart';

/// The visual weights this application offers for a toggle.
enum VanillaToggleVariant {
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
enum VanillaToggleSize {
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
ToggleStyler vanillaToggleStyle({
  VanillaToggleVariant variant = .ghost,
  VanillaToggleSize size = .medium,
  ToggleStyler style = const ToggleStyler.create(),
}) {
  final metrics = _metricsFor(size);

  return _content(VanillaTokens.foreground())
      .animate(VanillaTokens.motion)
      .color(_transparent)
      .direction(.horizontal)
      .mainAxisSize(.min)
      .mainAxisAlignment(.center)
      .crossAxisAlignment(.center)
      .minHeight(metrics.minHeight)
      // Equal to the height, so an icon-only toggle is square.
      .minWidth(metrics.minHeight)
      .padding(.horizontal(metrics.paddingX))
      .spacing(VanillaTokens.s2)
      .borderRadius(.all(VanillaTokens.radiusMd()))
      .label(.style(VanillaTokens.textSm.mix()).fontWeight(FontWeight.w500))
      .icon(.size(VanillaTokens.icon))
      .merge(switch (variant) {
        .ghost => ToggleStyler().onHovered(
          _content(
            VanillaTokens.mutedForeground(),
          ).color(VanillaTokens.muted()),
        ),
        .outline =>
          ToggleStyler()
              .border(
                .color(
                  VanillaTokens.input(),
                ).width(VanillaTokens.strokeHairline),
              )
              // In the effects layer: the toggle is transparent, and a
              // decoration shadow would show through it.
              .containerEffects(.behindContent(VanillaShadow.xs.effects))
              .onHovered(
                _content(
                  VanillaTokens.accentForeground(),
                ).color(VanillaTokens.accent()),
              ),
      })
      // After the variant's hover, so a toggle that is on stays on under the
      // pointer.
      .onSelected(
        _content(
          VanillaTokens.accentForeground(),
        ).color(VanillaTokens.accent()),
      )
      .onFocusVisible(
        ToggleStyler()
            .containerEffects(vanillaFocusRing())
            .merge(
              variant == .outline
                  ? ToggleStyler().border(vanillaFocusBorder())
                  : null,
            ),
      )
      // Declared last so it wins; the ring is cleared because a disabled
      // control that still rings reads as actionable.
      .onDisabled(
        ToggleStyler()
            .containerEffects(.outline(.style(.none)))
            .wrap(.opacity(VanillaTokens.disabledOpacity)),
      )
      .merge(style);
}

const _transparent = Color(0x00000000);

/// Height and side inset for one [VanillaToggleSize]: 32px with a 6px inset,
/// 36px with 8, and 40px with 10.
typedef _VanillaToggleMetrics = ({double minHeight, double paddingX});

_VanillaToggleMetrics _metricsFor(VanillaToggleSize size) => switch (size) {
  .small => (minHeight: VanillaTokens.controlSm, paddingX: VanillaTokens.s1_5),
  .medium => (minHeight: VanillaTokens.controlMd, paddingX: VanillaTokens.s2),
  .large => (minHeight: VanillaTokens.controlLg, paddingX: VanillaTokens.s2_5),
};

/// One content color for the label and the icons.
ToggleStyler _content(Color foreground) =>
    ToggleStyler().label(.color(foreground)).icon(.color(foreground));
