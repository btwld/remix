// Codegen validates the expanded optionsBuilder signature, including FutureOr,
// before emitting its typedef. Keep that type visible to the generator.
// ignore: unused_import
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';
import 'textfield.dart';

part 'combobox.g.dart';

/// The application's Combobox recipe.
///
/// The field reuses [vanillaTextFieldStyle], with its focus, error and
/// disabled treatments; the panel and rows follow the Select recipe.
///
/// Keyboard highlight is `accent` with a `ring` border, hover a lighter tint,
/// press a primary tint. Suggestions are eligible values only, so Remix has no
/// per-option disabled or selected state.
@MixWidget(target: RemixCombobox.new)
ComboboxStyler vanillaComboboxStyle({
  ComboboxStyler style = const ComboboxStyler.create(),
}) => ComboboxStyler()
    .field(vanillaTextFieldStyle())
    .panel(
      ComboboxPanelStyler()
          .margin(.top(VanillaTokens.s2))
          .minWidth(VanillaTokens.panelMinWidth)
          .maxHeight(VanillaTokens.panelMaxHeight)
          .scrollbarColor(vanillaTint(VanillaTokens.mutedForeground, 0.35)())
          .color(VanillaTokens.popover())
          .border(
            .color(VanillaTokens.border()).width(VanillaTokens.strokeHairline),
          )
          .borderRadius(.all(VanillaTokens.radiusMd()))
          .padding(.all(VanillaTokens.s1))
          .containerEffects(.behindContent(VanillaShadow.md.effects)),
    )
    .option(
      ComboboxOptionStyler()
          .minHeight(VanillaTokens.controlSm)
          .margin(.bottom(1))
          .padding(
            .symmetric(
              horizontal: VanillaTokens.s2,
              vertical: VanillaTokens.s1_5,
            ),
          )
          .borderRadius(.all(VanillaTokens.radiusSm()))
          .border(
            .color(
              vanillaTint(VanillaTokens.ring, 0)(),
            ).width(VanillaTokens.strokeHairline),
          )
          .label(
            .style(
              VanillaTokens.textSm.mix(),
            ).color(VanillaTokens.popoverForeground()),
          )
          .onHovered(_highlighted(vanillaTint(VanillaTokens.accent, 0.85)()))
          .onFocused(
            _highlighted(VanillaTokens.accent()).border(
              .color(VanillaTokens.ring()).width(VanillaTokens.strokeHairline),
            ),
          )
          .onPressed(
            _highlighted(vanillaTint(VanillaTokens.primary, 0.18, dark: 0.2)()),
          ),
    )
    .merge(style);

ComboboxOptionStyler _highlighted(Color fill) => ComboboxOptionStyler()
    .color(fill)
    .label(.color(VanillaTokens.accentForeground()));
