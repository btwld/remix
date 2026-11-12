// ignore: unused_import
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'textfield.dart';

part 'combobox.g.dart';

/// The sizes a combobox's field comes in, matching the text field.
enum FortalComboboxSize {
  /// A 24px field with 12px text.
  size1,

  /// A 32px field with 14px text. The default.
  size2,

  /// A 40px field with 16px text.
  size3,
}

/// The looks a combobox's field comes in, matching the text field.
enum FortalComboboxVariant {
  /// The `gray2` fill inside a 1px neutral frame.
  surface,

  /// An accent tint inside a 1px accent ring.
  soft,
}

/// The Fortal Combobox recipe: an editable field with a panel of suggestions.
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
            .border(
              .all(
                .color(FortalTokens.gray7()).width(FortalTokens.borderWidth1()),
              ),
            )
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
                .color(
                  _optionReservedBorderColor(),
                ).width(FortalTokens.borderWidth1()),
              ),
            )
            .label(TextStyler(style: text.mix()).color(FortalTokens.gray12()))
            .onHovered(.color(FortalTokens.accentA3()))
            .onFocused(
              .color(FortalTokens.accentA5()).border(
                .all(
                  .color(
                    FortalTokens.accent8(),
                  ).width(FortalTokens.borderWidth1()),
                ),
              ),
            )
            .onPressed(.color(FortalTokens.accentA7())),
      )
      .merge(style);
}

// SpaceToken placeholders cannot participate in arithmetic before resolution.
final _optionPaddingY = ContextToken<double>(
  (context) => FortalTokens.space3.resolve(context) / 2,
);

// Resolved before merging so the transparent reservation cannot tint a later
// keyboard ring or caller border override.
final _optionReservedBorderColor = ContextToken<Color>(
  (context) => FortalTokens.accent8.resolve(context).withValues(alpha: 0),
);
