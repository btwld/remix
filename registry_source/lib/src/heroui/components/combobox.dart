// ignore: unused_import
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'textfield.dart';

part 'combobox.g.dart';

/// HeroUI's editable field variants.
enum HeroUiComboboxVariant { primary, secondary }

/// HeroUI v3 ComboBox appearance over Remix's editable suggestions API.
///
/// The field reuses TextField, while the panel and rows follow ComboBox's
/// ListBox (the same anatomy as Select). Remix owns editing, filtering
/// callbacks, traversal, acceptance, overflow fades and the scrollbar.
/// Accepted values appear in the editor; suggestions have no persistent
/// selected or per-option disabled state. Custom field builders own their
/// field appearance, and caller style overrides merge last.
@MixWidget(target: RemixCombobox.new)
ComboboxStyler heroUiComboboxStyle({
  HeroUiComboboxVariant variant = .primary,
  ComboboxStyler style = const ComboboxStyler.create(),
}) => ComboboxStyler()
    .field(
      heroUiTextFieldStyle(
        variant: switch (variant) {
          .primary => .primary,
          .secondary => .secondary,
        },
        // Clear the unstyled Combobox's 48px floor; TextField's intrinsic
        // 24/20px line plus 16px padding supplies HeroUI's 40/36px field.
        style: TextFieldStyler().constraints(.minHeight(0)),
      ),
    )
    .panel(
      ComboboxPanelStyler()
          .margin(.top(_panelGap))
          .padding(.all(_listPadding))
          .borderRadius(.all(HeroUiTokens.radiusPanel()))
          .color(HeroUiTokens.overlay())
          .scrollbarColor(_scrollbar())
          .containerEffects(heroUiSurfaceEffects(overlay: true)),
    )
    .option(
      ComboboxOptionStyler()
          .minHeight(_rowMinHeight)
          .padding(.symmetric(horizontal: _rowPaddingX, vertical: _rowPaddingY))
          .margin(.bottom(_rowGap))
          .borderRadius(.all(HeroUiTokens.radius2xl()))
          .color(HeroUiTokens.overlay())
          .label(
            TextStyler()
                .style(HeroUiTokens.textSm.mix())
                .color(HeroUiTokens.foreground()),
          )
          .onHovered(.color(HeroUiTokens.defaultColor()))
          // The scrolling viewport clips outer row shadows. Paint the
          // keyboard ring inside the row without consuming layout space.
          .onFocused(
            ComboboxOptionStyler().container(
              BoxStyler().foregroundDecoration(
                BoxDecorationMix(
                  border: .all(
                    .color(HeroUiTokens.focus()).width(HeroUiTokens.focusWidth),
                  ),
                  borderRadius: .all(HeroUiTokens.radius2xl()),
                ),
              ),
            ),
          )
          .onPressed(ComboboxOptionStyler().scale(_pressedScale)),
    )
    .merge(style);

final _scrollbar = heroUiAlpha(HeroUiTokens.muted, .35);

// combo-box.css and list-box-item.css, resolved by capture_combobox.mjs.
const _rowMinHeight = 36.0;
const _rowPaddingX = 10.0;
const _rowPaddingY = 6.0;
const _rowGap = 4.0;
const _listPadding = 6.0;
const _panelGap = 8.0;
const _pressedScale = .98;
