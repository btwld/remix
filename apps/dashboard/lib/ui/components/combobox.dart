// ignore: unused_import
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'textfield.dart';

part 'combobox.g.dart';

/// Ui editable-field sizes, matching TextField.
enum UiComboboxSize { size1, size2, size3 }

/// Ui editable-field treatments.
enum UiComboboxVariant { surface, soft }

/// Ui's editable suggestions recipe, promoted from the demo's polish story.
///
/// The field shares TextField's recipe. Suggestions use the Select panel's
/// token roles with growing rows and separate hover, keyboard and press fills.
/// Remix owns filtering callbacks, traversal, acceptance, fades and scrollbar.
/// Eligible suggestions have no persistent selected or per-option disabled
/// state; acceptance writes the value into the field. A custom field builder
/// owns its editor styling. Caller overrides merge last.
@MixWidget(target: RemixCombobox.new)
ComboboxStyler uiComboboxStyle({
  UiComboboxVariant variant = .surface,
  UiComboboxSize size = .size2,
  ComboboxStyler style = const ComboboxStyler.create(),
}) {
  final text = switch (size) {
    .size1 => UiTokens.text1,
    .size2 => UiTokens.text2,
    .size3 => UiTokens.text3,
  };
  return ComboboxStyler()
      .field(
        uiTextFieldStyle(
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
            .margin(.top(UiTokens.space2()))
            .scrollbarColor(UiTokens.gray9())
            .borderRadius(.all(UiTokens.radius3()))
            .color(UiTokens.colorPanel())
            .padding(.all(UiTokens.space1()))
            .border(
              .all(.color(UiTokens.gray7()).width(UiTokens.borderWidth1())),
            )
            .decoration(
              BoxDecorationMix.create(boxShadow: UiTokens.shadow3.mix()),
            ),
      )
      .option(
        ComboboxOptionStyler()
            .minHeight(size == .size1 ? UiTokens.space5() : UiTokens.space6())
            .padding(
              .symmetric(
                horizontal: UiTokens.space3(),
                vertical: _optionPaddingY(),
              ),
            )
            .margin(.bottom(1))
            .borderRadius(.all(UiTokens.radius2()))
            .border(
              .all(
                .color(
                  _optionReservedBorderColor(),
                ).width(UiTokens.borderWidth1()),
              ),
            )
            .label(TextStyler(style: text.mix()).color(UiTokens.gray12()))
            .onHovered(.color(UiTokens.accentA3()))
            .onFocused(
              .color(UiTokens.accentA5()).border(
                .all(.color(UiTokens.accent8()).width(UiTokens.borderWidth1())),
              ),
            )
            .onPressed(.color(UiTokens.accentA7())),
      )
      .merge(style);
}

// SpaceToken placeholders cannot participate in arithmetic before resolution.
final _optionPaddingY = ContextToken<double>(
  (context) => UiTokens.space3.resolve(context) / 2,
);

// Resolve before merging so the transparent reservation cannot tint a later
// keyboard ring or caller border override.
Color _resolveOptionReservedBorderColor(BuildContext context) =>
    UiTokens.accent8.resolve(context).withValues(alpha: 0);

const _optionReservedBorderColor = ContextToken<Color>(
  _resolveOptionReservedBorderColor,
);
