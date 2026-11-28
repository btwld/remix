import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'tooltip.g.dart';

/// The Fortal Tooltip recipe: 13px text in the page color on an ink bubble
/// with 14px corners, inverted from the page, that appears 8px above its
/// trigger after a 250ms wait.
///
/// It fades in over 150ms while it rises 3px from its trigger and grows from
/// 97%, and fades out in 100ms to 98%. Under reduced motion it only fades.
@MixWidget(target: RemixTooltip.new)
TooltipStyler fortalTooltipStyle({
  TooltipStyler style = const TooltipStyler.create(),
}) {
  return TooltipStyler(
        label: .style(FortalTokens.text2.mix()),
        waitDuration: const Duration(milliseconds: 250),
        skipDelayDuration: const Duration(milliseconds: 300),
        transitionBuilder: _tooltipMotion,
        animationStyle: const AnimationStyle(
          duration: FortalMotion.fast,
          curve: Curves.linear,
          reverseDuration: FortalMotion.instant,
          reverseCurve: Curves.linear,
        ),
        positioning: const OverlayPositionConfig(
          side: .top,
          alignment: .center,
          sideOffset: 8,
          collisionPadding: EdgeInsets.all(12),
        ),
      )
      .maxWidth(240)
      .borderRadius(.all(FortalTokens.radius4()))
      .padding(
        .symmetric(
          vertical: FortalTokens.space3(),
          horizontal: FortalTokens.space4(),
        ),
      )
      .label(.color(FortalTokens.gray1()))
      .color(FortalTokens.gray12())
      .border(.all(.color(_frame()).width(FortalTokens.borderWidth1())))
      .decoration(
        BoxDecorationMix.create(boxShadow: FortalTokens.shadow3.mix()),
      )
      .merge(style);
}

/// The ink fill mixed 14% toward the page.
final _frame = ContextToken<Color>(
  (context) => mixOklabPremultiplied(
    FortalTokens.gray12.resolve(context),
    FortalTokens.colorBackground.resolve(context),
    .14,
  ),
);

Widget _tooltipMotion(
  BuildContext context,
  Animation<double> animation,
  Widget child,
) {
  // The bubble rises toward its place: up from below, or down when it sits
  // under its trigger.
  final below = OverlayPlacement.maybeOf(context)?.side == OverlaySide.bottom;
  final travel = below ? -3.0 : 3.0;

  return RemixReducedMotionBuilder(
    builder: (context, reduceMotion) => AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final t = animation.value;
        if (reduceMotion) {
          return Opacity(
            opacity: t,
            alwaysIncludeSemantics: true,
            child: child,
          );
        }

        final double opacity;
        var offset = 0.0;
        final double scale;
        if (animation.status == .reverse) {
          final p = FortalMotion.easeStandard.transform(1 - t);
          opacity = 1 - p;
          scale = 1 - .02 * p;
        } else {
          final p = FortalMotion.easeEnter.transform(t);
          opacity = p;
          offset = travel * (1 - p);
          scale = .97 + .03 * p;
        }

        return Opacity(
          opacity: opacity,
          alwaysIncludeSemantics: true,
          child: Transform.translate(
            offset: Offset(0, offset),
            child: Transform.scale(scale: scale, child: child),
          ),
        );
      },
    ),
  );
}
