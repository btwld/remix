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

/// Fortal text field size presets.
enum FortalTextFieldSize {
  /// Compact text field.
  size1,

  /// Default text field.
  size2,

  /// Large text field.
  size3,
}

/// Fortal text field color variants.
enum FortalTextFieldVariant {
  /// Surface treatment with neutral border and text colors.
  surface,

  /// Soft accent treatment.
  soft,
}

Color _resolveDisabledNeutralTextInputPlaceholder(BuildContext context) {
  final color = FortalTokens.grayA10.resolve(context);
  return color.withValues(alpha: color.a * 0.5);
}

const _disabledNeutralTextInputPlaceholder = ContextToken<Color>(
  _resolveDisabledNeutralTextInputPlaceholder,
);

final _softTextInputDisabledPlaceholder = ContextToken<Color>(
  (context) => FortalTokens.accent12.resolve(context).withValues(alpha: 0.5),
);

/// Fortal-themed preset for [RemixTextField].
@MixWidget(target: RemixTextField.new)
TextFieldStyler fortalTextFieldStyle({
  FortalTextFieldVariant variant = .surface,
  FortalTextFieldSize size = .size2,
  TextFieldStyler style = const TextFieldStyler.create(),
}) {
  final metrics = _fortalTextFieldMetrics(size, bordered: variant != .soft);
  final base = _fortalTextInputBaseStyle(
    container: BoxStyler()
        .height(metrics.height)
        .padding(.horizontal(metrics.paddingX))
        .borderRadius(.all(metrics.radius))
        .clipBehavior(.antiAlias),
    spacing: metrics.spacing,
    crossAxisAlignment: .center,
    text: metrics.text,
  );

  final recipe = switch (variant) {
    .surface => _fortalApplySurfaceTextInput(base),
    .soft => _fortalApplySoftTextInput(base),
  };

  return recipe
      .variant(ContextVariant.widgetState(.error), _fortalTextInputErrorStyle())
      .onDisabled(
        .containerEffects(
          RemixBoxEffectsMix(outline: BorderSideMix(style: .none)),
        ),
      )
      // The input container sits inside Remix's chrome gesture detector.
      // An outer wrapper would reserve space without accepting its taps.
      .container(BoxStyler().wrap(fortalTouchTarget()))
      .merge(style);
}

TextFieldStyler _fortalTextInputBaseStyle({
  required BoxStyler container,
  required double spacing,
  required CrossAxisAlignment crossAxisAlignment,
  required TextStyleToken text,
}) =>
    TextFieldStyler(
          container: container,
          spacing: spacing,
          crossAxisAlignment: crossAxisAlignment,
          text: .style(text.mix()),
          hintText: .style(text.mix()).textHeightBehavior(
            TextHeightBehaviorMix()
                .applyHeightToFirstAscent(false)
                .applyHeightToLastDescent(true),
          ),
          helperText: .style(FortalTokens.text1.mix()),
          label: .style(FortalTokens.text2.mix()),
          cursorWidth: 1.5,
          containerEffects: RemixBoxEffectsMix(
            behindContent: RemixBoxEffectLayerMix(),
            overContent: RemixBoxEffectLayerMix(),
          ),
        )
        .wrap(.iconTheme(color: FortalTokens.gray11(), size: 16.0))
        .onFocused(.containerEffects(fortalFocusOutline()));

TextFieldStyler _fortalApplySurfaceTextInput(TextFieldStyler base) =>
    _fortalApplyNeutralTextInput(base)
        .color(FortalTokens.gray2())
        .containerEffects(
          RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix()),
        )
        // An unlabeled field relies on its border to be found at all.
        .containerEffects(
          RemixBoxEffectsMix.overContent(
            fortalInsetSurface(strokes: [FortalTokens.controlBorder()]),
          ),
        )
        .onDisabled(
          _fortalNeutralTextInputDisabledStyle()
              .color(FortalTokens.gray2())
              .containerEffects(
                RemixBoxEffectsMix.behindContent(
                  RemixBoxEffectLayerMix(
                    gradients: [
                      RemixLinearGradientMix(
                        colors: [FortalTokens.grayA2(), FortalTokens.grayA2()],
                      ),
                    ],
                  ),
                ),
              )
              .containerEffects(
                RemixBoxEffectsMix.overContent(
                  fortalInsetSurface(strokes: [FortalTokens.grayA6()]),
                ),
              ),
        );

TextFieldStyler _fortalApplySoftTextInput(TextFieldStyler base) => base
    .merge(
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
      ),
    )
    .textColor(FortalTokens.accent12())
    .text(.selectionColor(FortalTokens.accentA5()))
    .onEnabled(.hintText(.color(FortalTokens.accentA11())))
    // Base-level icon overrides remain available while enabled.
    .wrap(.iconTheme(color: FortalTokens.accent11()))
    .color(FortalTokens.accentA3())
    .containerEffects(
      RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix()),
    )
    // A blank soft field shows no text, hint or border of its own, and its
    // tint alone is far below 3:1; the accent-8 ring keeps it findable. It is
    // the base so caller base overrides still win; disabled clears it.
    .containerEffects(
      RemixBoxEffectsMix.overContent(
        fortalInsetSurface(strokes: [FortalTokens.accentA8()]),
      ),
    )
    .onDisabled(
      _fortalSoftTextInputDisabledStyle()
          .color(FortalTokens.grayA3())
          .containerEffects(
            RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix()),
          )
          .containerEffects(
            RemixBoxEffectsMix.overContent(
              RemixBoxEffectLayerMix(shadows: const []),
            ),
          ),
    );

TextFieldStyler _fortalApplyNeutralTextInput(TextFieldStyler base) =>
    base.merge(
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
      ),
    );

// Keep the disabled-color branch on raw focus for the same :focus-within
// contract as the enabled text input.
TextFieldStyler _fortalTextInputDisabledBaseStyle() => TextFieldStyler(
  text: .color(FortalTokens.grayA11()).selectionColor(FortalTokens.grayA5()),
  cursorColor: FortalTokens.grayA11(),
).containerEffects(RemixBoxEffectsMix(outline: BorderSideMix(style: .none)));

TextFieldStyler _fortalNeutralTextInputDisabledStyle() =>
    _fortalTextInputDisabledBaseStyle().hintText(
      .color(_disabledNeutralTextInputPlaceholder()),
    );

TextFieldStyler _fortalSoftTextInputDisabledStyle() =>
    _fortalTextInputDisabledBaseStyle()
        .hintText(.color(_softTextInputDisabledPlaceholder()))
        .wrap(.iconTheme(color: FortalTokens.accent10()));

TextFieldStyler _fortalTextInputErrorStyle() => TextFieldStyler(
  helperText: .color(FortalTokens.error11()),
  label: .color(FortalTokens.error11()),
  cursorColor: FortalTokens.error9(),
  containerEffects: RemixBoxEffectsMix(
    overContent: RemixBoxEffectLayerMix(
      shadows: [
        RemixBoxShadowMix(
          kind: .inset,
          color: FortalTokens.error8(),
          spreadRadius: 1,
        ),
      ],
    ),
  ),
);

({
  double height,
  double paddingX,
  double spacing,
  Radius radius,
  TextStyleToken text,
})
_fortalTextFieldMetrics(FortalTextFieldSize size, {required bool bordered}) =>
    switch (size) {
      .size1 => (
        height: FortalTokens.space5(),
        paddingX: bordered ? FortalTokens.space2() : FortalTokens.space2(),
        spacing: FortalTokens.space2(),
        radius: FortalTokens.radius2OrFull(),
        text: FortalTokens.text1,
      ),
      .size2 => (
        height: FortalTokens.space6(),
        paddingX: bordered ? FortalTokens.space2() : FortalTokens.space2(),
        spacing: FortalTokens.space2(),
        radius: FortalTokens.radius2OrFull(),
        text: FortalTokens.text2,
      ),
      .size3 => (
        height: FortalTokens.space7(),
        paddingX: bordered ? FortalTokens.space3() : FortalTokens.space3(),
        spacing: FortalTokens.space3(),
        radius: FortalTokens.radius3OrFull(),
        text: FortalTokens.text3,
      ),
    };

/// Fortal TextArea size presets.
enum FortalTextAreaSize { size1, size2, size3 }

/// Fortal TextArea variants.
enum FortalTextAreaVariant { surface, soft }

/// Fortal recipe for [RemixTextArea].
@MixWidget(target: RemixTextArea.new)
TextFieldStyler fortalTextAreaStyle({
  FortalTextAreaVariant variant = .surface,
  FortalTextAreaSize size = .size2,
  TextFieldStyler style = const TextFieldStyler.create(),
}) {
  final metrics = _fortalTextAreaMetrics(size);
  final base = _fortalTextInputBaseStyle(
    container: BoxStyler()
        .minHeight(metrics.minHeight)
        .padding(
          .symmetric(horizontal: metrics.paddingX, vertical: metrics.paddingY),
        )
        .borderRadius(.all(metrics.radius))
        .clipBehavior(.antiAlias),
    spacing: metrics.spacing,
    crossAxisAlignment: .start,
    text: metrics.text,
  );

  final recipe = switch (variant) {
    .surface => _fortalApplySurfaceTextInput(base),
    .soft => _fortalApplySoftTextInput(base),
  };

  return recipe
      .variant(ContextVariant.widgetState(.error), _fortalTextInputErrorStyle())
      .onDisabled(
        .containerEffects(
          RemixBoxEffectsMix(outline: BorderSideMix(style: .none)),
        ),
      )
      .container(BoxStyler().wrap(fortalTouchTarget()))
      .merge(style);
}

({
  double minHeight,
  double paddingX,
  double paddingY,
  double spacing,
  Radius radius,
  TextStyleToken text,
})
_fortalTextAreaMetrics(FortalTextAreaSize size) => switch (size) {
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
