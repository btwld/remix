import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'button.dart';
import 'icon_button.dart';

part 'toast.g.dart';

/// The sizes a toast comes in. Pixel values are at 100% theme scaling.
enum FortalToastSize {
  /// 12px text with 12px padding.
  size1,

  /// 14px text with 16px padding. The default.
  size2,

  /// 16px text with 24px padding.
  size3,
}

/// How far a toast floats above the page.
enum FortalToastVariant {
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
enum FortalToastIntent {
  /// The accent's text color.
  accent,

  /// Gray.
  neutral,

  /// The error color.
  error,
}

/// The Fortal Toast recipe, for [RemixToast] and [RemixToastScope].
///
/// A toast is a raised, blurred panel in a 1px frame, with a ghost action and
/// close button. It caps at 360px and shrinks with the available width.
///
/// ```dart
/// RemixToastScope(style: fortalToastStyle(), child: const Shell())
/// ```
@MixWidget(target: RemixToast.new)
ToastStyler fortalToastStyle({
  FortalToastVariant variant = .classic,
  FortalToastSize size = .size2,
  FortalToastIntent intent = .accent,
  ToastStyler style = const ToastStyler.create(),
}) {
  final metrics = _fortalToastMetrics(size);

  return ToastStyler(
        container: FlexBoxStyler().spacing(metrics.gap),
        content: FlexBoxStyler().spacing(FortalTokens.space1()),
        icon: IconStyler()
            .size(metrics.iconSize)
            .color(_fortalToastIntentColor(intent)),
        title: TextStyler(style: metrics.text.mix())
            .fontWeight(FortalTokens.fontWeightMedium())
            .color(FortalTokens.gray12()),
        description: TextStyler(
          style: metrics.text.mix(),
        ).color(FortalTokens.gray11()),
        action: fortalButtonStyle(variant: .ghost, size: .size1),
        closeButton: fortalIconButtonStyle(variant: .ghost, size: .size1).merge(
          IconButtonStyler().icon(IconStyler().color(FortalTokens.gray11())),
        ),
      )
      .padding(.all(metrics.padding))
      .borderRadius(.all(metrics.radius))
      .maxWidth(FortalTokens.toastMaxWidth())
      .containerEffects(
        RemixBoxEffectsMix.backdropBlur(FortalTokens.panelBlur()),
      )
      .color(FortalTokens.colorPanel())
      .border(
        .all(.color(FortalTokens.gray6()).width(FortalTokens.borderWidth1())),
      )
      .decoration(
        BoxDecorationMix.create(
          boxShadow:
              (variant == .surface
                      ? FortalTokens.shadow3
                      : FortalTokens.shadow4)
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
_fortalToastMetrics(FortalToastSize size) => switch (size) {
  .size1 => (
    padding: FortalTokens.space3(),
    gap: FortalTokens.space2(),
    iconSize: FortalTokens.space4(),
    radius: FortalTokens.radius3(),
    text: FortalTokens.text1,
  ),
  .size2 => (
    padding: FortalTokens.space4(),
    gap: FortalTokens.space3(),
    iconSize: FortalTokens.space4(),
    radius: FortalTokens.radius4(),
    text: FortalTokens.text2,
  ),
  .size3 => (
    padding: FortalTokens.space5(),
    gap: FortalTokens.space3(),
    iconSize: FortalTokens.space5(),
    radius: FortalTokens.radius5(),
    text: FortalTokens.text3,
  ),
};

Color _fortalToastIntentColor(FortalToastIntent intent) => switch (intent) {
  .accent => FortalTokens.accentContent(),
  .neutral => FortalTokens.gray11(),
  .error => FortalTokens.error11(),
};
