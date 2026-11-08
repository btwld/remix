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
/// [playgroundTextFieldStyle], including its focus, error and disabled treatments;
/// the panel and rows follow the application's Select recipe.
///
/// Keyboard highlight, hover and press use the same accent surface. Suggestions
/// are eligible values only: Remix has no per-option disabled or selected
/// state. The disabled treatment belongs to the editor. Custom field builders
/// own their field recipe; custom option content inherits the row's text style.
@MixWidget(target: RemixCombobox.new)
ComboboxStyler playgroundComboboxStyle({
  ComboboxStyler style = const ComboboxStyler.create(),
}) => ComboboxStyler()
    .field(playgroundTextFieldStyle())
    .panel(
      BoxStyler()
          .margin(.top(PlaygroundTokens.s1))
          .color(PlaygroundTokens.popover())
          .border(
            .color(
              PlaygroundTokens.border(),
            ).width(PlaygroundTokens.strokeHairline),
          )
          .borderRadius(.all(PlaygroundTokens.radiusMd()))
          .padding(.all(PlaygroundTokens.s1))
          .shadows(PlaygroundShadow.md.box),
    )
    .option(
      ComboboxOptionStyler()
          .padding(
            .symmetric(
              horizontal: PlaygroundTokens.s2,
              vertical: PlaygroundTokens.s1_5,
            ),
          )
          .borderRadius(.all(PlaygroundTokens.radiusSm()))
          .label(
            .style(
              PlaygroundTokens.textSm.mix(),
            ).color(PlaygroundTokens.popoverForeground()),
          )
          .onHovered(_highlighted())
          .onFocused(_highlighted())
          .onPressed(_highlighted()),
    )
    .merge(style);

ComboboxOptionStyler _highlighted() => ComboboxOptionStyler()
    .color(PlaygroundTokens.accent())
    .label(.color(PlaygroundTokens.accentForeground()));
