import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../motion/motion.dart';
import '../theme/theme.dart';
import 'button.dart';

part 'toast.g.dart';

/// The sizes a toast comes in. Pixel values are at 100% theme scaling.
enum FortalToastSize {
  /// 12px text beside a 26px icon chip, 10px padding.
  size1,

  /// 13px text beside a 30px icon chip, 14px padding. The default.
  size2,

  /// 15px text beside a 34px icon chip, 16px padding.
  size3,
}

/// How far a toast floats above the page.
enum FortalToastVariant {
  /// The raised shadow.
  surface,

  /// The floating shadow. The default.
  classic,
}

/// The color role of the leading icon chip.
///
/// Visual only: it never changes [RemixToastData.priority]. Choose
/// [RemixToastPriority.assertive] explicitly when a message needs an
/// immediate announcement.
enum FortalToastIntent {
  /// A confirmation: the success color and a check. The default.
  accent,

  /// Gray and an info glyph.
  neutral,

  /// The error color and a warning glyph.
  error,
}

/// The Fortal Toast recipe, for [RemixToast] and [RemixToastScope].
///
/// A toast is a floating card in a 1px border with a round tinted icon chip,
/// a medium title over secondary text, and a round close button. It caps at
/// 416px and shrinks with the available width. Inside a [RemixToastScope] it
/// rises 16px and grows from 96% on the morph spring while it fades in over
/// 200ms, and leaves in 140ms, sinking 8px to 97%.
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
  final metrics = _metrics(size);
  final (tone, glyph) = switch (intent) {
    .accent => (FortalTokens.success, RemixIcons.check),
    .neutral => (FortalTokens.gray11, RemixIcons.info),
    .error => (FortalTokens.error11, RemixIcons.warning),
  };

  return ToastStyler(
        container: FlexBoxStyler()
            .spacing(metrics.gap)
            .crossAxisAlignment(.start),
        // The copy fills the row so the close button sits at the end and every
        // toast spans the full width the scope allows.
        content: FlexBoxStyler()
            .width(double.infinity)
            .spacing(2)
            .padding(.only(top: metrics.copyTop)),
        icon: IconStyler().icon(glyph).size(metrics.iconSize).color(tone()),
        iconContainer: BoxStyler()
            .size(metrics.chip, metrics.chip)
            .alignment(.center)
            .color(_chipFill(tone)())
            .border(.all(.color(_chipBorder(tone)()).width(1)))
            .borderRadius(.all(FortalTokens.radiusCircle())),
        title: TextStyler(style: metrics.text.mix())
            .fontWeight(FortalTokens.fontWeightMedium())
            .color(FortalTokens.gray12())
            .maxLines(1)
            .overflow(.ellipsis),
        description: TextStyler(
          style: metrics.text.mix(),
        ).color(FortalTokens.gray11()),
        action: fortalButtonStyle(variant: .ghost, size: .size1),
        closeButton: _closeButton(metrics.close),
        transitionBuilder: _transition,
        animationStyle: AnimationStyle(
          duration: _enterSpring.duration,
          curve: Curves.linear,
          reverseDuration: FortalMotion.exit,
          reverseCurve: Curves.linear,
        ),
        reducedMotionDuration: FortalMotion.instant,
      )
      .padding(metrics.padding)
      .borderRadius(.all(metrics.radius))
      .maxWidth(FortalTokens.toastMaxWidth())
      .color(_fill())
      .border(.all(.color(_frame()).width(FortalTokens.borderWidth1())))
      .decoration(
        BoxDecorationMix.create(
          boxShadow:
              (variant == .surface
                      ? FortalTokens.shadow3
                      : FortalTokens.shadow5)
                  .mix(),
        ),
      )
      .merge(style);
}

({
  EdgeInsetsGeometryMix padding,
  double gap,
  double chip,
  double iconSize,
  double copyTop,
  double close,
  Radius radius,
  TextStyleToken text,
})
_metrics(FortalToastSize size) => switch (size) {
  .size1 => (
    padding: EdgeInsetsGeometryMix.directional(
      top: 10,
      bottom: 10,
      start: FortalTokens.space3(),
      end: 10,
    ),
    gap: FortalTokens.space2(),
    chip: 26,
    iconSize: 14,
    copyTop: 4,
    close: 28,
    radius: FortalTokens.radius5(),
    text: FortalTokens.text1,
  ),
  .size2 => (
    padding: EdgeInsetsGeometryMix.directional(
      top: 14,
      bottom: 14,
      start: FortalTokens.space4(),
      end: 14,
    ),
    gap: FortalTokens.space3(),
    chip: 30,
    iconSize: FortalTokens.space4(),
    copyTop: 5,
    close: 32,
    radius: FortalTokens.radius6(),
    text: FortalTokens.text2,
  ),
  .size3 => (
    padding: EdgeInsetsGeometryMix.directional(
      top: 16,
      bottom: 16,
      start: FortalTokens.space18(),
      end: 16,
    ),
    gap: FortalTokens.space3(),
    chip: 34,
    iconSize: FortalTokens.space18(),
    copyTop: 6,
    close: 36,
    radius: FortalTokens.radius7(),
    text: FortalTokens.text3,
  ),
};

/// The quiet border, or gray 10 (3:1 on the card) under the theme's high
/// contrast.
final _frame = ContextToken<Color>(
  (context) => (FortalTheme.maybeOf(context)?.highContrast ?? false)
      ? FortalTokens.gray10.resolve(context)
      : FortalTokens.gray7.resolve(context),
);

/// The surface mixed 6% toward the page background.
final _fill = ContextToken<Color>(
  (context) => mixOklabPremultiplied(
    FortalTokens.colorSurface.resolve(context),
    FortalTokens.colorBackground.resolve(context),
    .06,
  ),
);

ContextToken<Color> _chipFill(ColorToken tone) => ContextToken<Color>(
  (context) => mixOklabPremultiplied(
    FortalTokens.colorSurface.resolve(context),
    tone.resolve(context),
    .10,
  ),
);

ContextToken<Color> _chipBorder(ColorToken tone) => ContextToken<Color>(
  (context) => mixOklabPremultiplied(
    FortalTokens.gray7.resolve(context),
    tone.resolve(context),
    .24,
  ),
);

/// A round ghost button nudged 2px out and 1px up, so it hugs the corner.
IconButtonStyler _closeButton(double edge) => IconButtonStyler()
    .size(edge, edge)
    .alignment(.center)
    .borderRadius(.all(FortalTokens.radiusCircle()))
    .icon(IconStyler().size(FortalTokens.space4()).color(FortalTokens.gray10()))
    .wrap(.transform(transform: Matrix4.translationValues(2, -1, 0)))
    .onHovered(
      IconButtonStyler()
          .color(FortalTokens.gray3())
          .icon(.color(FortalTokens.gray12())),
    )
    .onPressed(IconButtonStyler().scale(.96))
    .animate(.easeOut(FortalMotion.fast));

final _enterSpring = FortalSpringCurve(FortalMotion.springMorph);

/// Rises 16px from the toast's edge and grows from 96% on the morph spring
/// while fading in over 200ms; leaves in 140ms, sinking 8px to 97%. Under
/// reduced motion it only fades.
///
/// The fade keeps semantics so a toast is announced from its first frame.
Widget _transition(
  BuildContext context,
  Animation<double> animation,
  RemixToastPlacement placement,
  Widget child,
) {
  final fromTop = switch (placement) {
    .topStart || .topCenter || .topEnd => true,
    .bottomStart || .bottomCenter || .bottomEnd => false,
  };
  final edge = fromTop ? -1.0 : 1.0;
  final enterMs = _enterSpring.duration.inMicroseconds / 1000;

  return RemixReducedMotionBuilder(
    builder: (context, reduceMotion) => AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final t = animation.value;
        final leaving = animation.status == .reverse;
        if (reduceMotion) {
          return Opacity(
            opacity: t,
            alwaysIncludeSemantics: true,
            child: child,
          );
        }

        final double opacity;
        final double offset;
        final double scale;
        if (leaving) {
          final p = FortalMotion.easeStandard.transform(1 - t);
          opacity = 1 - p;
          offset = 8 * p;
          scale = 1 - .03 * p;
        } else {
          final spring = _enterSpring.transform(t);
          final fadeEnd = (FortalMotion.standard.inMilliseconds / enterMs)
              .clamp(0.0, 1.0);
          opacity = FortalMotion.easeEnter.transform(
            (t / fadeEnd).clamp(0.0, 1.0),
          );
          offset = 16 * (1 - spring);
          scale = .96 + .04 * spring;
        }

        return Opacity(
          opacity: opacity,
          alwaysIncludeSemantics: true,
          child: Transform.translate(
            offset: Offset(0, edge * offset),
            child: Transform.scale(scale: scale, child: child),
          ),
        );
      },
    ),
  );
}
