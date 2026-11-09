// ignore: unused_import
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'textfield.dart';

part 'combobox.g.dart';

/// Fortal editable-field sizes, matching TextField.
enum FortalComboboxSize { size1, size2, size3 }

/// Fortal editable-field treatments.
enum FortalComboboxVariant { surface, soft }

/// Fortal's editable suggestions recipe, promoted from the demo's polish story.
///
/// The field shares TextField's recipe. Suggestions use the Select panel's
/// token roles with growing rows and separate hover, keyboard and press fills.
/// Remix owns filtering callbacks, traversal, acceptance, fades and scrollbar.
/// Eligible suggestions have no persistent selected or per-option disabled
/// state; acceptance writes the value into the field. A custom field builder
/// owns its editor styling. Caller overrides merge last.
@MixWidget(target: RemixCombobox.new)
ComboboxStyler fortalComboboxStyle({
  FortalComboboxVariant variant = .surface,
  FortalComboboxSize size = .size2,
  ComboboxStyler style = const ComboboxStyler.create(),
}) {
  final text = switch (size) {
    .size1 => FortalTokens.text1,
    .size2 => FortalTokens.text2,
    .size3 => FortalTokens.text3,
  };
  return ComboboxStyler()
      .field(
        fortalTextFieldStyle(
          variant: switch (variant) {
            .surface => .surface,
            .soft => .soft,
          },
          size: switch (size) {
            .size1 => .size1,
            .size2 => .size2,
            .size3 => .size3,
          },
        ),
      )
      .panel(
        ComboboxPanelStyler()
            .margin(.top(FortalTokens.space2()))
            .scrollbarColor(FortalTokens.gray9())
            .borderRadius(.all(FortalTokens.radius3()))
            .color(FortalTokens.colorPanel())
            .padding(.all(FortalTokens.space1()))
            .border(.all(.color(FortalTokens.gray7()).width(1)))
            .decoration(
              BoxDecorationMix.create(boxShadow: FortalTokens.shadow3.mix()),
            ),
      )
      .option(
        ComboboxOptionStyler()
            .minHeight(
              size == .size1 ? FortalTokens.space5() : FortalTokens.space6(),
            )
            .padding(
              .symmetric(
                horizontal: FortalTokens.space3(),
                vertical: _optionPaddingY(),
              ),
            )
            .margin(.bottom(1))
            .borderRadius(.all(FortalTokens.radius2()))
            .border(
              .all(
                .color(FortalTokens.accent8().withValues(alpha: 0)).width(1),
              ),
            )
            .label(TextStyler(style: text.mix()).color(FortalTokens.gray12()))
            .onHovered(.color(FortalTokens.accentA3()))
            .onFocused(
              .color(
                FortalTokens.accentA5(),
              ).border(.all(.color(FortalTokens.accent8()).width(1))),
            )
            .onPressed(.color(FortalTokens.accentA7())),
      )
      .merge(style);
}

// SpaceToken placeholders cannot participate in arithmetic before resolution.
final _optionPaddingY = ContextToken<double>(
  (context) => FortalTokens.space3.resolve(context) / 2,
);
