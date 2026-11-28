import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../motion/motion.dart';
import '../theme/theme.dart';

part 'popover.g.dart';

/// The sizes a popover comes in, from its padding and corners. Pixel values
/// are at 100% theme scaling.
enum FortalPopoverSize {
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
/// The generated [FortalPopover] defaults to [FortalPopoverSize.size2] and no
/// arrow.
@MixWidget(target: RemixPopover.new)
PopoverStyler fortalPopoverStyle({
  FortalPopoverSize size = .size2,
  PopoverStyler style = const PopoverStyler.create(),
}) {
  final radius = switch (size) {
    .size1 || .size2 => FortalTokens.radius6(),
    .size3 || .size4 => FortalTokens.radius7(),
  };
  final padding = switch (size) {
    .size1 => FortalTokens.space3(),
    .size2 => FortalTokens.space4(),
    .size3 => FortalTokens.space5(),
    .size4 => FortalTokens.space6(),
  };

  return PopoverStyler()
      .border(.color(_frame()).width(FortalTokens.borderWidth1()))
      .minWidth(_minWidth)
      .maxWidth(FortalTokens.popoverMaxWidth())
      .padding(.all(padding))
      .borderRadius(.all(radius))
      .color(FortalTokens.colorPanelSolid())
      .decoration(
        BoxDecorationMix.create(boxShadow: FortalTokens.shadow5.mix()),
      )
      .panelTransition(_panelTransition)
      .merge(style);
}

const double _minWidth = 192;

/// The quiet border, or gray 10 (3:1 on the panel) under the theme's high
/// contrast.
final _frame = ContextToken<Color>(
  (context) => (FortalTheme.maybeOf(context)?.highContrast ?? false)
      ? FortalTokens.gray10.resolve(context)
      : FortalTokens.gray7.resolve(context),
);

const _panelTransition = RemixPanelTransition(
  duration: FortalMotion.spring,
  reverseDuration: FortalMotion.fast,
  reducedMotionDuration: FortalMotion.instant,
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
          final p = FortalMotion.easeStandard.transform(1 - t);
          opacity = 1 - p;
          offset = travel * (.5 * p);
          scale = 1 - .02 * p;
        } else {
          final enterMs = FortalMotion.spring.inMilliseconds;
          final spring = FortalSpringCurve.css.transform(t);
          opacity = FortalMotion.easeEnter.transform(
            (t * enterMs / FortalMotion.fast.inMilliseconds).clamp(0.0, 1.0),
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
