import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../motion/motion.dart';
import '../theme/theme.dart';

part 'dialog.g.dart';

/// The sizes a dialog comes in, from the padding of its header and body.
/// Pixel values are at 100% theme scaling.
enum FortalDialogSize {
  /// 12px padding.
  size1,

  /// 16px padding.
  size2,

  /// 20px padding. The default.
  size3,

  /// 24px padding.
  size4,
}

/// Padding that keeps the dialog 12px off the screen edges, or the safe area
/// when that is larger.
final _dialogViewportInsets = ContextToken<EdgeInsetsGeometry>((context) {
  final safeArea = MediaQuery.paddingOf(context);
  final gap = FortalTokens.space3.resolve(context);

  return EdgeInsets.fromLTRB(
    math.max(safeArea.left, gap),
    math.max(safeArea.top, gap),
    math.max(safeArea.right, gap),
    math.max(safeArea.bottom, gap),
  );
});

/// The Fortal Dialog recipe: a floating 440px panel. With a close button,
/// the title, description and close button form a header row over a
/// divider, then come the body and actions; without one, they stack in one
/// padded column.
///
/// The generated [FortalDialog] defaults to [FortalDialogSize.size3] and
/// [Alignment.center], keeps 12px from the viewport edges, and is modal. Open
/// it with [showFortalDialog] for the blurred scrim and the panel's spring.
@MixWidget(target: RemixDialog.new)
DialogStyler fortalDialogStyle({
  FortalDialogSize size = .size3,
  AlignmentGeometry align = Alignment.center,
  DialogStyler style = const DialogStyler.create(),
}) {
  final padding = switch (size) {
    .size1 => FortalTokens.space3(),
    .size2 => FortalTokens.space4(),
    .size3 => FortalTokens.space20(),
    .size4 => FortalTokens.space5(),
  };

  return DialogStyler()
      .wrap(
        .modifier(
          PaddingModifierMix.create(padding: Prop.token(_dialogViewportInsets)),
        ).align(alignment: align).orderOfModifiers([
          PaddingModifier,
          AlignModifier,
        ]),
      )
      .title(
        .style(FortalTokens.text4.mix())
            .fontWeight(FortalTokens.fontWeightMedium())
            .color(FortalTokens.gray12()),
      )
      .description(
        TextStyler(style: FortalTokens.text2.mix())
            .color(FortalTokens.gray11())
            .wrap(
              .padding(EdgeInsetsMix.fromLTRB(0, FortalTokens.space2(), 0, 0)),
            ),
      )
      .actions(
        FlexBoxStyler()
            .mainAxisAlignment(.end)
            .spacing(FortalTokens.space3())
            .margin(.top(padding)),
      )
      .padding(.all(padding))
      .onBuilder(
        (context) => _hasClose(context)
            ? _withHeader(padding)
            : const DialogStyler.create(),
      )
      .closeButton(_closeButton())
      .width(FortalTokens.dialogMaxWidth())
      .borderRadius(.all(FortalTokens.radius7()))
      .border(
        .all(.color(FortalTokens.gray7()).width(FortalTokens.borderWidth1())),
      )
      .color(FortalTokens.colorPanelSolid())
      .decoration(
        BoxDecorationMix.create(boxShadow: FortalTokens.shadow5.mix()),
      )
      .merge(style);
}

/// Whether the dialog being styled draws a close button.
///
/// Remix gives the header row a flexible heading only when there is a close
/// button, so the divided header applies to those dialogs alone; the others
/// keep one padded column, which lets long titles wrap.
bool _hasClose(BuildContext context) =>
    context.findAncestorWidgetOfExactType<RemixDialog>()?.onClose != null;

/// The header row over a divider, then the body and actions. The container's
/// bottom padding closes whichever part comes last, so the body and actions
/// only pad their top and sides.
DialogStyler _withHeader(double padding) => DialogStyler()
    .header(
      FlexBoxStyler()
          .crossAxisAlignment(.start)
          .spacing(FortalTokens.space18())
          .padding(.all(padding))
          .border(
            .bottom(
              .color(FortalTokens.gray7()).width(FortalTokens.borderWidth1()),
            ),
          ),
    )
    .body(BoxStyler().padding(.fromLTRB(padding, padding, padding, 0)))
    .actions(
      FlexBoxStyler()
          .margin(.top(0))
          .padding(.fromLTRB(padding, padding, padding, 0)),
    )
    .padding(.fromLTRB(0, 0, 0, padding));

final _closeFill = ContextToken<Color>(
  (context) => FortalTokens.gray3.resolve(context).withValues(alpha: .5),
);

/// A 32px framed square, lifted 4px so it centers on the title's line.
IconButtonStyler _closeButton() => IconButtonStyler()
    .size(32, 32)
    .alignment(.center)
    .borderRadius(.all(FortalTokens.radius4()))
    .border(
      .all(.color(FortalTokens.gray7()).width(FortalTokens.borderWidth1())),
    )
    .color(_closeFill())
    .icon(IconStyler().size(FortalTokens.space4()).color(FortalTokens.gray11()))
    .wrap(.transform(transform: Matrix4.translationValues(0, -4, 0)))
    .onHovered(
      IconButtonStyler()
          .color(FortalTokens.gray3())
          .icon(.color(FortalTokens.gray12())),
    )
    .onPressed(IconButtonStyler().scale(.96))
    .animate(.easeOut(FortalMotion.fast));

final _panelSpring = FortalSpringCurve(FortalMotion.springSmooth);

/// Shows [builder] as a modal dialog with Fortal's motion: a blurred scrim
/// that fades in over 200ms, and a panel that fades in over 150ms while it
/// rises 8px and grows from 96% on the smooth spring. Closing takes 150ms:
/// the panel sinks 4px to 98% as both fade. Under reduced motion both only
/// fade, over 100ms.
///
/// A visual wrapper over [showRemixDialog]: dismissal, focus and semantics
/// stay Remix's.
Future<T?> showFortalDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
}) => showRemixDialog<T>(
  context: context,
  builder: builder,
  barrierColor: const Color(0x00000000),
  barrierDismissible: barrierDismissible,
  barrierLabel: barrierLabel,
  useRootNavigator: useRootNavigator,
  routeSettings: routeSettings,
  transitionDuration: _panelSpring.duration,
  reverseTransitionDuration: FortalMotion.fast,
  reducedMotionDuration: FortalMotion.instant,
  transitionBuilder: _dialogTransition,
);

Widget _dialogTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  final enterMs = _panelSpring.duration.inMicroseconds / 1000;
  double fadeIn(double t, Duration over) => FortalMotion.easeEnter.transform(
    (t * enterMs / over.inMilliseconds).clamp(0.0, 1.0),
  );

  return RemixReducedMotionBuilder(
    builder: (context, reduceMotion) => AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final t = animation.value;
        final leaving = animation.status == .reverse;
        final exit = FortalMotion.easeStandard.transform(1 - t);
        final double scrim;
        final double panel;
        var offset = 0.0;
        var scale = 1.0;
        if (reduceMotion) {
          scrim = t;
          panel = t;
        } else if (leaving) {
          scrim = 1 - exit;
          panel = 1 - exit;
          offset = 4 * exit;
          scale = 1 - .02 * exit;
        } else {
          final spring = _panelSpring.transform(t);
          scrim = fadeIn(t, FortalMotion.standard);
          panel = fadeIn(t, FortalMotion.fast);
          offset = 8 * (1 - spring);
          scale = .96 + .04 * spring;
        }

        return Stack(
          fit: .expand,
          children: [
            // Taps fall through to the route's barrier, which dismisses.
            IgnorePointer(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 7 * scrim, sigmaY: 7 * scrim),
                child: Opacity(
                  opacity: scrim,
                  child: ColoredBox(
                    color: FortalTokens.colorOverlay.resolve(context),
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: panel,
              alwaysIncludeSemantics: true,
              child: Transform.translate(
                offset: Offset(0, offset),
                child: Transform.scale(scale: scale, child: child),
              ),
            ),
          ],
        );
      },
    ),
  );
}
