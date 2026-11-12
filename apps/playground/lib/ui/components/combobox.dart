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
/// The field reuses [playgroundTextFieldStyle], with its focus, error and
/// disabled treatments; the panel and rows follow the Select recipe.
///
/// Keyboard highlight is `accent` with a `ring` border, hover a lighter tint,
/// press a primary tint. Suggestions are eligible values only, so Remix has no
/// per-option disabled or selected state.
///
/// A custom `fieldBuilder` owns its field recipe; custom `optionBuilder`
/// content inherits the row's text style.
@MixWidget(target: RemixCombobox.new)
ComboboxStyler playgroundComboboxStyle({
  ComboboxStyler style = const ComboboxStyler.create(),
}) => ComboboxStyler()
    .field(playgroundTextFieldStyle())
    .panel(
      ComboboxPanelStyler()
          .margin(.top(PlaygroundTokens.s2))
          .minWidth(PlaygroundTokens.panelMinWidth)
          .maxHeight(PlaygroundTokens.panelMaxHeight)
          .scrollbarColor(
            playgroundTint(PlaygroundTokens.mutedForeground, 0.35)(),
          )
          .color(PlaygroundTokens.popover())
          .border(
            .color(
              PlaygroundTokens.border(),
            ).width(PlaygroundTokens.strokeHairline),
          )
          .borderRadius(.all(PlaygroundTokens.radiusMd()))
          .padding(.all(PlaygroundTokens.s1))
          .containerEffects(.behindContent(PlaygroundShadow.md.effects)),
    )
    .option(
      ComboboxOptionStyler()
          .minHeight(PlaygroundTokens.controlSm)
          .margin(.bottom(1))
          .padding(
            .symmetric(
              horizontal: PlaygroundTokens.s2,
              vertical: PlaygroundTokens.s1_5,
            ),
          )
          .borderRadius(.all(PlaygroundTokens.radiusSm()))
          .border(
            .color(
              playgroundTint(PlaygroundTokens.ring, 0)(),
            ).width(PlaygroundTokens.strokeHairline),
          )
          .label(
            .style(
              PlaygroundTokens.textSm.mix(),
            ).color(PlaygroundTokens.popoverForeground()),
          )
          .onHovered(
            _highlighted(playgroundTint(PlaygroundTokens.accent, 0.85)()),
          )
          .onFocused(
            _highlighted(PlaygroundTokens.accent()).border(
              .color(
                PlaygroundTokens.ring(),
              ).width(PlaygroundTokens.strokeHairline),
            ),
          )
          .onPressed(
            _highlighted(
              playgroundTint(PlaygroundTokens.primary, 0.18, dark: 0.2)(),
            ),
          ),
    )
    .merge(style);

ComboboxOptionStyler _highlighted(Color fill) => ComboboxOptionStyler()
    .color(fill)
    .label(.color(PlaygroundTokens.accentForeground()));
