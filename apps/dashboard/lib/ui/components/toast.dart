import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'button.dart';
import 'icon_button.dart';

part 'toast.g.dart';

/// Ui toast size presets.
enum UiToastSize { size1, size2, size3 }

/// Ui toast surfaces, with quiet and elevated floating treatments.
enum UiToastVariant { surface, classic }

/// The color role of the leading icon.
///
/// Visual only: it never changes [RemixToastData.priority]. Choose
/// [RemixToastPriority.assertive] explicitly when a message needs an
/// immediate announcement.
enum UiToastIntent { accent, neutral, error }

/// Ui-themed toast surface for [RemixToast] and [RemixToastScope].
///
/// Toasts use the shared floating-layer elevation scale. The surface caps at
/// 360 logical pixels and
/// shrinks with the available width.
///
/// ```dart
/// RemixToastScope(style: uiToastStyle(), child: const Shell())
/// ```
@MixWidget(target: RemixToast.new)
ToastStyler uiToastStyle({
  UiToastVariant variant = .classic,
  UiToastSize size = .size2,
  UiToastIntent intent = .accent,
  ToastStyler style = const ToastStyler.create(),
}) {
  final metrics = _uiToastMetrics(size);
  final base =
      ToastStyler(
            container: FlexBoxStyler().spacing(metrics.gap),
            content: FlexBoxStyler().spacing(UiTokens.space1()),
            icon: IconStyler()
                .size(metrics.iconSize)
                .color(_uiToastIntentColor(intent)),
            title: TextStyler(
              style: metrics.text.mix(),
            ).fontWeight(UiTokens.fontWeightMedium()).color(UiTokens.gray12()),
            description: TextStyler(
              style: metrics.text.mix(),
            ).color(UiTokens.gray11()),
            action: uiButtonStyle(variant: .ghost, size: .size1),
            closeButton: uiIconButtonStyle(variant: .ghost, size: .size1).merge(
              IconButtonStyler().icon(IconStyler().color(UiTokens.gray11())),
            ),
          )
          .padding(.all(metrics.padding))
          .borderRadius(.all(metrics.radius))
          .maxWidth(UiTokens.toastMaxWidth())
          .containerEffects(
            RemixBoxEffectsMix.backdropBlur(UiTokens.panelBlur()),
          );

  return base
      .color(UiTokens.colorPanel())
      .border(.all(.color(UiTokens.gray6()).width(UiTokens.borderWidth1())))
      .decoration(
        BoxDecorationMix.create(
          boxShadow: (variant == .surface ? UiTokens.shadow3 : UiTokens.shadow4)
              .mix(),
        ),
      )
      .merge(style);
}

({
  double padding,
  double gap,
  double iconSize,
  Radius radius,
  TextStyleToken text,
})
_uiToastMetrics(UiToastSize size) => switch (size) {
  .size1 => (
    padding: UiTokens.space3(),
    gap: UiTokens.space2(),
    iconSize: UiTokens.space4(),
    radius: UiTokens.radius3(),
    text: UiTokens.text1,
  ),
  .size2 => (
    padding: UiTokens.space4(),
    gap: UiTokens.space3(),
    iconSize: UiTokens.space4(),
    radius: UiTokens.radius4(),
    text: UiTokens.text2,
  ),
  .size3 => (
    padding: UiTokens.space5(),
    gap: UiTokens.space3(),
    iconSize: UiTokens.space5(),
    radius: UiTokens.radius5(),
    text: UiTokens.text3,
  ),
};

Color _uiToastIntentColor(UiToastIntent intent) => switch (intent) {
  .accent => UiTokens.accent11(),
  .neutral => UiTokens.gray11(),
  .error => UiTokens.error11(),
};
