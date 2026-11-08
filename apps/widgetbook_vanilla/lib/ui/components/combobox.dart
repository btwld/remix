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
/// Remix owns editing, filtering callbacks, suggestion traversal, acceptance,
/// overlay geometry and accessibility semantics. This recipe supplies the
/// field, floating suggestions panel and option rows. The field reuses
/// [vanillaTextFieldStyle], including its focus, error and disabled treatments;
/// the panel and rows follow the application's Select recipe.
///
/// Keyboard highlight uses accent, hover a lighter tint, and press a stronger
/// primary tint. Suggestions
/// are eligible values only: Remix has no per-option disabled or selected
/// state. The disabled treatment belongs to the editor. Custom field builders
/// own their field recipe; custom option content inherits the row's text style.
@MixWidget(target: RemixCombobox.new)
ComboboxStyler vanillaComboboxStyle({
  ComboboxStyler style = const ComboboxStyler.create(),
}) => ComboboxStyler()
    .field(vanillaTextFieldStyle())
    .panel(
      ComboboxPanelStyler()
          .margin(.top(VanillaTokens.s2))
          .minWidth(VanillaTokens.panelMinWidth)
          .maxHeight(320)
          .scrollbarColor(VanillaTokens.mutedForeground())
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
          .padding(
            .symmetric(
              horizontal: VanillaTokens.s2,
              vertical: VanillaTokens.s1_5,
            ),
          )
          .borderRadius(.all(VanillaTokens.radiusSm()))
          .label(
            .style(
              VanillaTokens.textSm.mix(),
            ).color(VanillaTokens.popoverForeground()),
          )
          .onHovered(_highlighted(vanillaTint(VanillaTokens.accent, 0.65)()))
          .onFocused(_highlighted().label(.fontWeight(.w500)))
          .onPressed(
            _highlighted(vanillaTint(VanillaTokens.primary, 0.18, dark: 0.2)()),
          ),
    )
    .merge(style);

ComboboxOptionStyler _highlighted([Color? fill]) => ComboboxOptionStyler()
    .color(fill ?? VanillaTokens.accent())
    .label(.color(VanillaTokens.accentForeground()));
