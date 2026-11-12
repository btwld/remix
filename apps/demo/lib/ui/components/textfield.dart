// `DragStartBehavior` and `MaxLengthEnforcement` appear in the generated
// FortalTextField/FortalTextArea constructors, so they must be visible from
// this library even though nothing here references them directly.
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'textfield.g.dart';

/// The sizes a text field comes in. Pixel values are at 100% theme scaling.
enum FortalTextFieldSize {
  /// 24px tall, with 12px text.
  size1,

  /// 32px tall, with 14px text. The default.
  size2,

  /// 40px tall, with 16px text.
  size3,
}

/// The looks a text field comes in.
enum FortalTextFieldVariant {
  /// The `gray2` fill inside a 1px neutral frame, with neutral text.
  surface,

  /// An accent tint inside a 1px accent ring, with accent-colored text.
  soft,
}

/// The Fortal TextField recipe.
///
/// It reads top to bottom: what every text input shares, then the size, then
/// the variant's colors for rest and disabled, then the error state.
@MixWidget(target: RemixTextField.new)
TextFieldStyler fortalTextFieldStyle({
  FortalTextFieldVariant variant = .surface,
  FortalTextFieldSize size = .size2,
  TextFieldStyler style = const TextFieldStyler.create(),
}) => _input(
  size: _fieldSize(size),
  look: switch (variant) {
    .surface => _surface(),
    .soft => _soft(),
  },
).merge(style);

/// The sizes a text area comes in. Pixel values are at 100% theme scaling.
enum FortalTextAreaSize {
  /// At least 48px tall, with 12px text.
  size1,

  /// At least 64px tall, with 14px text. The default.
  size2,

  /// At least 80px tall, with 16px text.
  size3,
}

/// The looks a text area comes in.
enum FortalTextAreaVariant {
  /// The `gray2` fill inside a 1px neutral frame, with neutral text.
  surface,

  /// An accent tint inside a 1px accent ring, with accent-colored text.
  soft,
}

/// The Fortal TextArea recipe: the text field's looks on a taller box whose
/// content starts at the top.
@MixWidget(target: RemixTextArea.new)
TextFieldStyler fortalTextAreaStyle({
  FortalTextAreaVariant variant = .surface,
  FortalTextAreaSize size = .size2,
  TextFieldStyler style = const TextFieldStyler.create(),
}) => _input(
  size: _areaSize(size),
  look: switch (variant) {
    .surface => _surface(),
    .soft => _soft(),
  },
).merge(style);

/// A text field or area: the shared base, then [size] and [look], then the
/// error and disabled states.
TextFieldStyler _input({
  required TextFieldStyler size,
  required TextFieldStyler look,
}) => _base()
    .merge(size)
    .merge(look)
    .variant(ContextVariant.widgetState(.error), _error())
    .onDisabled(.containerEffects(.outline(.style(.none))))
    // The input container sits inside Remix's chrome gesture detector.
    // An outer wrapper would reserve space without accepting its taps.
    .container(BoxStyler().wrap(fortalTouchTarget()));

/// What every text input shares: label and helper text, cursor, icon color,
/// and the focus ring.
///
/// The empty effect layers give the variant's state fragments layers to
/// replace.
TextFieldStyler _base() =>
    TextFieldStyler(
          helperText: .style(FortalTokens.text1.mix()),
          label: .style(FortalTokens.text2.mix()),
          cursorWidth: 1.5,
          containerEffects: RemixBoxEffectsMix(
            behindContent: RemixBoxEffectLayerMix(),
            overContent: RemixBoxEffectLayerMix(),
          ),
        )
        .wrap(
          .iconTheme(color: FortalTokens.gray11(), size: FortalTokens.space4()),
        )
        // A text input rings on any focus, as a browser does.
        .onFocused(.containerEffects(fortalFocusOutline()));

/// The box and text of a text field: one line, centered.
TextFieldStyler _fieldSize(FortalTextFieldSize size) {
  final (:height, :paddingX, :spacing, :radius, :text) = switch (size) {
    .size1 => (
      height: FortalTokens.space5(),
      paddingX: FortalTokens.space2(),
      spacing: FortalTokens.space2(),
      radius: FortalTokens.radius2OrFull(),
      text: FortalTokens.text1,
    ),
    .size2 => (
      height: FortalTokens.space6(),
      paddingX: FortalTokens.space2(),
      spacing: FortalTokens.space2(),
      radius: FortalTokens.radius2OrFull(),
      text: FortalTokens.text2,
    ),
    .size3 => (
      height: FortalTokens.space7(),
      paddingX: FortalTokens.space3(),
      spacing: FortalTokens.space3(),
      radius: FortalTokens.radius3OrFull(),
      text: FortalTokens.text3,
    ),
  };

  return _sized(
    minHeight: height,
    paddingX: paddingX,
    paddingY: _fieldPaddingY(size)(),
    spacing: spacing,
    radius: radius,
    crossAxisAlignment: .center,
    text: text,
  );
}

/// The box and text of a text area: at least a few lines, starting at the top.
TextFieldStyler _areaSize(FortalTextAreaSize size) {
  final (
    :minHeight,
    :paddingX,
    :paddingY,
    :spacing,
    :radius,
    :text,
  ) = switch (size) {
    .size1 => (
      minHeight: FortalTokens.space8(),
      paddingX: FortalTokens.space2(),
      paddingY: FortalTokens.space1(),
      spacing: FortalTokens.space2(),
      radius: FortalTokens.radius2(),
      text: FortalTokens.text1,
    ),
    .size2 => (
      minHeight: FortalTokens.space9(),
      paddingX: FortalTokens.space2(),
      paddingY: FortalTokens.space2(),
      spacing: FortalTokens.space2(),
      radius: FortalTokens.radius2(),
      text: FortalTokens.text2,
    ),
    .size3 => (
      minHeight: FortalTokens.textAreaMinHeight3(),
      paddingX: FortalTokens.space3(),
      paddingY: FortalTokens.space2(),
      spacing: FortalTokens.space3(),
      radius: FortalTokens.radius3(),
      text: FortalTokens.text3,
    ),
  };

  return _sized(
    minHeight: minHeight,
    paddingX: paddingX,
    paddingY: paddingY,
    spacing: spacing,
    radius: radius,
    crossAxisAlignment: .start,
    text: text,
  );
}

/// A text input's box and its text and hint style.
///
/// The hint keeps its line height at the bottom of the line only, so the
/// placeholder sits where typed text will.
TextFieldStyler _sized({
  required double minHeight,
  required double paddingX,
  required double paddingY,
  required double spacing,
  required Radius radius,
  required CrossAxisAlignment crossAxisAlignment,
  required TextStyleToken text,
}) => TextFieldStyler(
  container: BoxStyler()
      .minHeight(minHeight)
      .padding(.symmetric(horizontal: paddingX, vertical: paddingY))
      .borderRadius(.all(radius))
      .clipBehavior(.antiAlias),
  spacing: spacing,
  crossAxisAlignment: crossAxisAlignment,
  text: .style(text.mix()),
  hintText: .style(text.mix()).textHeightBehavior(
    TextHeightBehaviorMix()
        .applyHeightToFirstAscent(false)
        .applyHeightToLastDescent(true),
  ),
);

/// Vertical padding that centers one line of text in a field's height.
///
/// This keeps the 24, 32 and 40px field heights and a centered baseline at 1x,
/// while leaving the text line unconstrained as MediaQuery text scaling
/// increases. The frame is an inset effect, not a layout-consuming border.
ContextToken<double> _fieldPaddingY(FortalTextFieldSize size) =>
    ContextToken<double>((context) {
      final (height, text) = switch (size) {
        .size1 => (FortalTokens.space5, FortalTokens.text1),
        .size2 => (FortalTokens.space6, FortalTokens.text2),
        .size3 => (FortalTokens.space7, FortalTokens.text3),
      };
      final style = text.resolve(context);

      return (height.resolve(context) - style.fontSize! * style.height!) / 2;
    });

/// The `gray2` fill with a neutral frame and neutral text.
TextFieldStyler _surface() =>
    TextFieldStyler(
          text: .color(
            FortalTokens.gray12(),
          ).selectionColor(FortalTokens.focusA5()),
          hintText: .color(FortalTokens.grayA11()),
          cursorColor: FortalTokens.gray12(),
          helperText: .color(FortalTokens.gray11()),
          label: .color(
            FortalTokens.gray12(),
          ).fontWeight(FortalTokens.fontWeightMedium()),
        )
        .color(FortalTokens.gray2())
        // An unlabeled field relies on its border to be found at all.
        .merge(
          _effects(
            over: fortalInsetSurface(strokes: [FortalTokens.controlBorder()]),
          ),
        )
        .onDisabled(
          _disabledText()
              .hintText(.color(_disabledNeutralPlaceholder()))
              .color(FortalTokens.gray2())
              .merge(
                _effects(
                  behind: RemixBoxEffectLayerMix(
                    gradients: [
                      RemixLinearGradientMix(
                        colors: [FortalTokens.grayA2(), FortalTokens.grayA2()],
                      ),
                    ],
                  ),
                  over: fortalInsetSurface(strokes: [FortalTokens.grayA6()]),
                ),
              ),
        );

/// An accent tint with accent-colored text and a regular weight.
TextFieldStyler _soft() =>
    TextFieldStyler(
          text: .fontWeight(FortalTokens.fontWeightRegular()),
          hintText: .fontWeight(FortalTokens.fontWeightRegular()),
          cursorColor: FortalTokens.accent12(),
          helperText: .color(
            FortalTokens.gray11(),
          ).fontWeight(FortalTokens.fontWeightRegular()),
          label: .color(
            FortalTokens.gray12(),
          ).fontWeight(FortalTokens.fontWeightMedium()),
        )
        .textColor(FortalTokens.accent12())
        .text(.selectionColor(FortalTokens.accentA5()))
        .onEnabled(.hintText(.color(FortalTokens.accentContentAlpha())))
        // Base-level icon overrides remain available while enabled.
        .wrap(.iconTheme(color: FortalTokens.accentContent()))
        .color(FortalTokens.accentA3())
        // A blank soft field shows no text, hint or border of its own, and its
        // tint alone is far below 3:1; the accent-8 ring keeps it findable. It
        // is the base so caller base overrides still win; disabled clears it.
        .merge(
          _effects(over: fortalInsetSurface(strokes: [FortalTokens.focus8()])),
        )
        .onDisabled(
          _disabledText()
              .hintText(.color(_disabledSoftPlaceholder()))
              .wrap(.iconTheme(color: FortalTokens.accent10()))
              .color(FortalTokens.grayA3())
              .merge(_effects(over: RemixBoxEffectLayerMix(shadows: const []))),
        );

/// Gray text and cursor for a disabled input, with no focus ring.
///
/// The disabled colors apply on raw focus too, matching the enabled input's
/// `:focus-within` behavior.
TextFieldStyler _disabledText() => TextFieldStyler(
  text: .color(FortalTokens.grayA11()).selectionColor(FortalTokens.grayA5()),
  cursorColor: FortalTokens.grayA11(),
).containerEffects(RemixBoxEffectsMix(outline: BorderSideMix(style: .none)));

/// The error ring and text colors, shown over whichever variant is active.
TextFieldStyler _error() => TextFieldStyler(
  helperText: .color(FortalTokens.error11()),
  label: .color(FortalTokens.error11()),
  cursorColor: FortalTokens.error9(),
  containerEffects: RemixBoxEffectsMix(
    overContent: RemixBoxEffectLayerMix(
      shadows: [
        RemixBoxShadowMix(
          kind: .inset,
          color: FortalTokens.error8(),
          spreadRadius: FortalTokens.borderWidth1(),
        ),
      ],
    ),
  ),
);

/// Sets the layer [over] the content, and empties the layer behind it or sets
/// [behind].
TextFieldStyler _effects({
  RemixBoxEffectLayerMix? behind,
  required RemixBoxEffectLayerMix over,
}) => TextFieldStyler()
    .containerEffects(
      RemixBoxEffectsMix.behindContent(behind ?? RemixBoxEffectLayerMix()),
    )
    .containerEffects(RemixBoxEffectsMix.overContent(over));

/// The hint color of a disabled neutral input: gray-alpha-10 at half opacity.
final _disabledNeutralPlaceholder = ContextToken<Color>((context) {
  final color = FortalTokens.grayA10.resolve(context);

  return color.withValues(alpha: color.a * 0.5);
});

/// The hint color of a disabled soft input: accent step 12 at half opacity.
final _disabledSoftPlaceholder = ContextToken<Color>(
  (context) => FortalTokens.accent12.resolve(context).withValues(alpha: 0.5),
);
