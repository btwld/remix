// `DragStartBehavior` and `MaxLengthEnforcement` appear in the generated
// UiTextField/UiTextArea constructors, so they must be visible from
// this library even though nothing here references them directly.
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'textfield.g.dart';

/// Ui text field size presets.
enum UiTextFieldSize {
  /// Compact text field.
  size1,

  /// Default text field.
  size2,

  /// Large text field.
  size3,
}

/// Ui text field color variants.
enum UiTextFieldVariant {
  /// Surface treatment with neutral border and text colors.
  surface,

  /// Soft accent treatment.
  soft,
}

Color _resolveDisabledNeutralTextInputPlaceholder(BuildContext context) {
  final color = UiTokens.grayA10.resolve(context);
  return color.withValues(alpha: color.a * 0.5);
}

const _disabledNeutralTextInputPlaceholder = ContextToken<Color>(
  _resolveDisabledNeutralTextInputPlaceholder,
);

Color _resolveAccent12Alpha(BuildContext context, double alpha) =>
    UiTokens.accent12.resolve(context).withValues(alpha: alpha);

final _softTextInputDisabledPlaceholder = ContextToken<Color>(
  (context) => _resolveAccent12Alpha(context, 0.5),
);

/// Ui-themed preset for [RemixTextField].
@MixWidget(target: RemixTextField.new)
TextFieldStyler uiTextFieldStyle({
  UiTextFieldVariant variant = .surface,
  UiTextFieldSize size = .size2,
  TextFieldStyler style = const TextFieldStyler.create(),
}) {
  final metrics = _uiTextFieldMetrics(size, bordered: variant != .soft);
  final base = _uiTextInputBaseStyle(
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
    .surface => _uiApplySurfaceTextInput(base),
    .soft => _uiApplySoftTextInput(base),
  };

  return recipe
      .variant(ContextVariant.widgetState(.error), _uiTextInputErrorStyle())
      .onDisabled(
        .containerEffects(
          RemixBoxEffectsMix(outline: BorderSideMix(style: .none)),
        ),
      )
      // The input container sits inside Remix's chrome gesture detector.
      // An outer wrapper would reserve space without accepting its taps.
      .container(BoxStyler().wrap(uiTouchTarget()))
      .merge(style);
}

TextFieldStyler _uiTextInputBaseStyle({
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
          helperText: .style(UiTokens.text1.mix()),
          label: .style(UiTokens.text2.mix()),
          cursorWidth: 1.5,
          containerEffects: RemixBoxEffectsMix(
            behindContent: RemixBoxEffectLayerMix(),
            overContent: RemixBoxEffectLayerMix(),
          ),
        )
        .wrap(.iconTheme(color: UiTokens.gray11(), size: 16.0))
        .onFocused(.containerEffects(uiFocusOutline()));

TextFieldStyler _uiApplySurfaceTextInput(TextFieldStyler base) =>
    _uiApplyNeutralTextInput(base)
        .color(UiTokens.gray2())
        .containerEffects(
          RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix()),
        )
        .containerEffects(
          RemixBoxEffectsMix.overContent(
            uiInsetSurface(strokes: [UiTokens.gray7()]),
          ),
        )
        .onDisabled(
          _uiNeutralTextInputDisabledStyle()
              .color(UiTokens.gray2())
              .containerEffects(
                RemixBoxEffectsMix.behindContent(
                  RemixBoxEffectLayerMix(
                    gradients: [
                      RemixLinearGradientMix(
                        colors: [UiTokens.grayA2(), UiTokens.grayA2()],
                      ),
                    ],
                  ),
                ),
              )
              .containerEffects(
                RemixBoxEffectsMix.overContent(
                  uiInsetSurface(strokes: [UiTokens.grayA6()]),
                ),
              ),
        );

TextFieldStyler _uiApplySoftTextInput(TextFieldStyler base) => base
    .merge(
      TextFieldStyler(
        text: .fontWeight(UiTokens.fontWeightRegular()),
        hintText: .fontWeight(UiTokens.fontWeightRegular()),
        cursorColor: UiTokens.accent12(),
        helperText: .color(
          UiTokens.gray11(),
        ).fontWeight(UiTokens.fontWeightRegular()),
        label: .color(
          UiTokens.gray12(),
        ).fontWeight(UiTokens.fontWeightMedium()),
      ),
    )
    .textColor(UiTokens.accent12())
    .text(.selectionColor(UiTokens.accentA5()))
    .onEnabled(.hintText(.color(UiTokens.accentA11())))
    // Base-level icon overrides remain available while enabled.
    .wrap(.iconTheme(color: UiTokens.accent11()))
    .color(UiTokens.accentA3())
    .containerEffects(
      RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix()),
    )
    .onDisabled(
      _uiSoftTextInputDisabledStyle()
          .color(UiTokens.grayA3())
          .containerEffects(
            RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix()),
          ),
    );

TextFieldStyler _uiApplyNeutralTextInput(TextFieldStyler base) => base.merge(
  TextFieldStyler(
    text: .color(UiTokens.gray12()).selectionColor(UiTokens.focusA5()),
    hintText: .color(UiTokens.grayA11()),
    cursorColor: UiTokens.gray12(),
    helperText: .color(UiTokens.gray11()),
    label: .color(UiTokens.gray12()).fontWeight(UiTokens.fontWeightMedium()),
  ),
);

// Keep the disabled-color branch on raw focus for the same :focus-within
// contract as the enabled text input.
TextFieldStyler _uiTextInputDisabledBaseStyle() => TextFieldStyler(
  text: .color(UiTokens.grayA11()).selectionColor(UiTokens.grayA5()),
  cursorColor: UiTokens.grayA11(),
).containerEffects(RemixBoxEffectsMix(outline: BorderSideMix(style: .none)));

TextFieldStyler _uiNeutralTextInputDisabledStyle() =>
    _uiTextInputDisabledBaseStyle().hintText(
      .color(_disabledNeutralTextInputPlaceholder()),
    );

TextFieldStyler _uiSoftTextInputDisabledStyle() =>
    _uiTextInputDisabledBaseStyle()
        .hintText(.color(_softTextInputDisabledPlaceholder()))
        .wrap(.iconTheme(color: UiTokens.accent10()));

TextFieldStyler _uiTextInputErrorStyle() => TextFieldStyler(
  helperText: .color(UiTokens.error11()),
  label: .color(UiTokens.error11()),
  cursorColor: UiTokens.error9(),
  containerEffects: RemixBoxEffectsMix(
    overContent: RemixBoxEffectLayerMix(
      shadows: [
        RemixBoxShadowMix(
          kind: .inset,
          color: UiTokens.errorA7(),
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
_uiTextFieldMetrics(UiTextFieldSize size, {required bool bordered}) =>
    switch (size) {
      .size1 => (
        height: UiTokens.space5(),
        paddingX: bordered ? UiTokens.space2() : UiTokens.space2(),
        spacing: UiTokens.space2(),
        radius: UiTokens.radius2OrFull(),
        text: UiTokens.text1,
      ),
      .size2 => (
        height: UiTokens.space6(),
        paddingX: bordered ? UiTokens.space2() : UiTokens.space2(),
        spacing: UiTokens.space2(),
        radius: UiTokens.radius2OrFull(),
        text: UiTokens.text2,
      ),
      .size3 => (
        height: UiTokens.space7(),
        paddingX: bordered ? UiTokens.space3() : UiTokens.space3(),
        spacing: UiTokens.space3(),
        radius: UiTokens.radius3OrFull(),
        text: UiTokens.text3,
      ),
    };

/// Ui TextArea size presets.
enum UiTextAreaSize { size1, size2, size3 }

/// Ui TextArea variants.
enum UiTextAreaVariant { surface, soft }

/// Ui recipe for [RemixTextArea].
@MixWidget(target: RemixTextArea.new)
TextFieldStyler uiTextAreaStyle({
  UiTextAreaVariant variant = .surface,
  UiTextAreaSize size = .size2,
  TextFieldStyler style = const TextFieldStyler.create(),
}) {
  final metrics = _uiTextAreaMetrics(size);
  final base = _uiTextInputBaseStyle(
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
    .surface => _uiApplySurfaceTextInput(base),
    .soft => _uiApplySoftTextInput(base),
  };

  return recipe
      .variant(ContextVariant.widgetState(.error), _uiTextInputErrorStyle())
      .onDisabled(
        .containerEffects(
          RemixBoxEffectsMix(outline: BorderSideMix(style: .none)),
        ),
      )
      .container(BoxStyler().wrap(uiTouchTarget()))
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
_uiTextAreaMetrics(UiTextAreaSize size) => switch (size) {
  .size1 => (
    minHeight: UiTokens.space8(),
    paddingX: UiTokens.space2(),
    paddingY: UiTokens.space1(),
    spacing: UiTokens.space2(),
    radius: UiTokens.radius2(),
    text: UiTokens.text1,
  ),
  .size2 => (
    minHeight: UiTokens.space9(),
    paddingX: UiTokens.space2(),
    paddingY: UiTokens.space2(),
    spacing: UiTokens.space2(),
    radius: UiTokens.radius2(),
    text: UiTokens.text2,
  ),
  .size3 => (
    minHeight: UiTokens.textAreaMinHeight3(),
    paddingX: UiTokens.space3(),
    paddingY: UiTokens.space2(),
    spacing: UiTokens.space3(),
    radius: UiTokens.radius3(),
    text: UiTokens.text3,
  ),
};
