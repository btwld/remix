import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'button.dart';
import 'icon_button.dart';

part 'toast.g.dart';

/// The sizes a toast comes in. Pixel values are at 100% theme scaling.
enum UiToastSize {
  /// 12px text with 12px padding.
  size1,

  /// 14px text with 16px padding. The default.
  size2,

  /// 16px text with 24px padding.
  size3,
}

/// How far a toast floats above the page.
enum UiToastVariant {
  /// A quiet shadow.
  surface,

  /// A deeper shadow. The default.
  classic,
}

/// The color role of the leading icon.
///
/// Visual only: it never changes [RemixToastData.priority]. Choose
/// [RemixToastPriority.assertive] explicitly when a message needs an
/// immediate announcement.
enum UiToastIntent {
  /// The accent's text color.
  accent,

  /// Gray.
  neutral,

  /// The error color.
  error,
}

/// The Ui Toast recipe, for [RemixToast] and [RemixToastScope].
///
/// A toast is a raised, blurred panel in a 1px frame, with a ghost action and
/// close button. It caps at 360px and shrinks with the available width.
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
  final metrics = _metrics(size);

  return ToastStyler(
        container: FlexBoxStyler().spacing(metrics.gap),
        content: FlexBoxStyler().spacing(UiTokens.space1()),
        icon: IconStyler().size(metrics.iconSize).color(_intentColor(intent)),
        title: TextStyler(
          style: metrics.text.mix(),
        ).fontWeight(UiTokens.fontWeightMedium()).color(UiTokens.gray12()),
        description: TextStyler(
          style: metrics.text.mix(),
        ).color(UiTokens.gray11()),
        action: uiButtonStyle(variant: .ghost, size: .size1),
        closeButton: uiIconButtonStyle(
          variant: .ghost,
          size: .size1,
        ).merge(IconButtonStyler().icon(IconStyler().color(UiTokens.gray11()))),
      )
      .padding(.all(metrics.padding))
      .borderRadius(.all(metrics.radius))
      .maxWidth(UiTokens.toastMaxWidth())
      .containerEffects(RemixBoxEffectsMix.backdropBlur(UiTokens.panelBlur()))
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
_metrics(UiToastSize size) => switch (size) {
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

Color _intentColor(UiToastIntent intent) => switch (intent) {
  .accent => UiTokens.accentContent(),
  .neutral => UiTokens.gray11(),
  .error => UiTokens.error11(),
};
