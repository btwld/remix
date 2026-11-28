import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../motion/motion.dart';
import '../theme/theme.dart';

part 'popover.g.dart';

/// The sizes a popover comes in, from its padding and corners. Pixel values
/// are at 100% theme scaling.
enum UiPopoverSize {
  /// 12px padding.
  size1,

  /// 16px padding. The default.
  size2,

  /// 24px padding.
  size3,

  /// 32px padding.
  size4,
}

/// The Fortal Popover recipe: a floating panel in a 1px border, 192 to 352px
/// wide.
///
/// It opens over 440ms: it fades in over the first 150ms while it slides 5px
/// from its trigger and grows from 97% around the trigger-side corner on the
/// transform spring. It closes in 150ms, halfway back and to 98%. Under
/// reduced motion it only fades, over 100ms.
///
/// The generated [UiPopover] defaults to [UiPopoverSize.size2] and no
/// arrow.
@MixWidget(target: RemixPopover.new)
PopoverStyler uiPopoverStyle({
  UiPopoverSize size = .size2,
  PopoverStyler style = const PopoverStyler.create(),
}) {
  final radius = switch (size) {
    .size1 || .size2 => UiTokens.radius6(),
    .size3 || .size4 => UiTokens.radius7(),
  };
  final padding = switch (size) {
    .size1 => UiTokens.space3(),
    .size2 => UiTokens.space4(),
    .size3 => UiTokens.space5(),
    .size4 => UiTokens.space6(),
  };

  return PopoverStyler()
      .border(.color(UiTokens.gray7()).width(UiTokens.borderWidth1()))
      .minWidth(_minWidth)
      .maxWidth(UiTokens.popoverMaxWidth())
      .padding(.all(padding))
      .borderRadius(.all(radius))
      .color(UiTokens.colorPanelSolid())
      .decoration(BoxDecorationMix.create(boxShadow: UiTokens.shadow5.mix()))
      .panelTransition(_panelTransition)
      .merge(style);
}

const double _minWidth = 192;

const _panelTransition = RemixPanelTransition(
  duration: UiMotion.spring,
  reverseDuration: UiMotion.fast,
  reducedMotionDuration: UiMotion.instant,
  builder: _panelMotion,
);

Widget _panelMotion(
  BuildContext context,
  RemixPanelTransitionInfo info,
  Widget panel,
) {
  final placement = OverlayPlacement.maybeOf(context);
  final side = placement?.side ?? OverlaySide.bottom;
  // The panel starts a few pixels toward its trigger.
  final travel = switch (side) {
    .bottom => const Offset(0, -5),
    .top => const Offset(0, 5),
    .left => const Offset(5, 0),
    .right => const Offset(-5, 0),
  };
  final origin = _origin(side, placement?.alignment ?? OverlayAlignment.start);
  final animation = info.animation;

  return RemixReducedMotionBuilder(
    builder: (context, reduceMotion) => AnimatedBuilder(
      animation: animation,
      child: panel,
      builder: (context, panel) {
        final t = animation.value;
        if (reduceMotion) {
          return Opacity(
            opacity: t,
            alwaysIncludeSemantics: true,
            child: panel,
          );
        }

        final double opacity;
        final Offset offset;
        final double scale;
        if (animation.status == .reverse) {
          final p = UiMotion.easeStandard.transform(1 - t);
          opacity = 1 - p;
          offset = travel * (.5 * p);
          scale = 1 - .02 * p;
        } else {
          final enterMs = UiMotion.spring.inMilliseconds;
          final spring = UiSpringCurve.css.transform(t);
          opacity = UiMotion.easeEnter.transform(
            (t * enterMs / UiMotion.fast.inMilliseconds).clamp(0.0, 1.0),
          );
          offset = travel * (1 - spring);
          scale = .97 + .03 * spring;
        }

        return Opacity(
          opacity: opacity,
          alwaysIncludeSemantics: true,
          child: Transform.translate(
            offset: offset,
            child: Transform.scale(
              scale: scale,
              alignment: origin,
              child: panel,
            ),
          ),
        );
      },
    ),
  );
}

/// The panel's corner or edge nearest its trigger, where it grows from.
AlignmentGeometry _origin(OverlaySide side, OverlayAlignment alignment) {
  final cross = switch (alignment) {
    .start => -1.0,
    .center => 0.0,
    .end => 1.0,
  };

  return switch (side) {
    .bottom => AlignmentDirectional(cross, -1),
    .top => AlignmentDirectional(cross, 1),
    .left => Alignment(1, cross),
    .right => Alignment(-1, cross),
  };
}
