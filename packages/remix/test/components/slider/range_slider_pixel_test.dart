import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

const red = Color(0xffff0000),
    blue = Color(0xff0000ff),
    green = Color(0xff00ff00),
    yellow = Color(0xffffff00),
    pink = Color(0xffff00ff),
    white = Color(0xffffffff);
const boundaryKey = ValueKey('range-pixels');
SliderStyler get style => SliderStyler()
    .thumbSize(const Size(20, 20))
    .thumbColor(red)
    .thickness(4)
    .trackColor(blue)
    .rangeColor(green);
Widget host(Widget child, {TextDirection direction = TextDirection.ltr}) =>
    Directionality(
      textDirection: direction,
      child: Center(
        child: RepaintBoundary(
          key: boundaryKey,
          child: ColoredBox(
            color: white,
            child: SizedBox(width: 240, height: 48, child: child),
          ),
        ),
      ),
    );
Future<ByteData> pixels(WidgetTester tester) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(boundaryKey),
  );
  return (await tester.runAsync(() async {
    final image = boundary.toImageSync(pixelRatio: 1);
    final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    image.dispose();
    return data;
  }))!;
}

int pixel(ByteData image, int x, int y) => image.getUint32((y * 240 + x) * 4);
int rgba(Color c) =>
    (c.r * 255).round() << 24 |
    (c.g * 255).round() << 16 |
    (c.b * 255).round() << 8 |
    (c.a * 255).round();
void main() {
  testWidgets(
    'selected interval is painted between thumbs in LTR RTL touching and endpoints',
    (t) async {
      for (final direction in TextDirection.values)
        for (final bounds in [
          const [.25, .75],
          const [.5, .5],
          const [0.0, 0.0],
          const [1.0, 1.0],
          const [0.0, 1.0],
        ]) {
          await t.pumpWidget(
            host(
              RemixRangeSlider(values: bounds, onChanged: (_) {}, style: style),
              direction: direction,
            ),
          );
          final image = await pixels(t);
          final full = bounds[0] == 0 && bounds[1] == 1;
          expect(pixel(image, 32, 24), rgba(full ? green : blue));
          expect(pixel(image, 208, 24), rgba(full ? green : blue));
          if (bounds[0] != bounds[1])
            expect(pixel(image, 120, 24), rgba(green));
          else if (bounds[0] != .5)
            expect(pixel(image, 120, 24), rgba(blue));
          else {
            expect(pixel(image, 120, 24), rgba(red));
            expect(pixel(image, 100, 24), rgba(blue));
          }
        }
    },
  );
  testWidgets(
    'focus effects hover press and disabled pixels belong to the relevant thumb',
    (t) async {
      final previous = FocusManager.instance.highlightStrategy;
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      addTearDown(() => FocusManager.instance.highlightStrategy = previous);
      final focus = [FocusNode(), FocusNode()];
      late StateSetter rebuild;
      var enabled = true;
      final states = style
          .onFocused(SliderStyler().thumbColor(green))
          .onHovered(SliderStyler().thumbColor(yellow))
          .onPressed(SliderStyler().thumbColor(blue))
          .onDisabled(SliderStyler().thumbColor(const Color(0xff888888)))
          .thumbFocusEffects(
            RemixBoxEffectsMix.outline(
              BorderSideMix(color: pink, width: 2),
            ).outlineOffset(2),
          );
      await t.pumpWidget(
        host(
          StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return RemixRangeSlider(
                values: const [.25, .75],
                focusNodes: focus,
                enabled: enabled,
                onChanged: (_) {},
                style: states,
              );
            },
          ),
        ),
      );
      focus[0].requestFocus();
      await t.pumpAndSettle();
      var image = await pixels(t);
      expect(pixel(image, 65, 24), rgba(green));
      expect(pixel(image, 175, 24), rgba(red));
      expect(pixel(image, 52, 24), rgba(pink));
      expect(pixel(image, 162, 24), rgba(green));
      focus[1].requestFocus();
      await t.pumpAndSettle();
      image = await pixels(t);
      expect(pixel(image, 65, 24), rgba(red));
      expect(pixel(image, 175, 24), rgba(green));
      expect(pixel(image, 162, 24), rgba(pink));
      final rect = t.getRect(find.byKey(boundaryKey));
      final mouse = await t.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(rect.topLeft + const Offset(65, 24));
      await t.pumpAndSettle();
      image = await pixels(t);
      expect(pixel(image, 65, 24), rgba(yellow));
      expect(pixel(image, 175, 24), rgba(green));
      await mouse.moveTo(Offset.zero);
      await t.pumpAndSettle();
      await mouse.removePointer();
      final touch = await t.startGesture(rect.topLeft + const Offset(65, 24));
      await t.pumpAndSettle();
      image = await pixels(t);
      expect(pixel(image, 65, 24), rgba(blue));
      expect(pixel(image, 175, 24), rgba(red));
      await touch.cancel();
      await t.pumpAndSettle();
      rebuild(() => enabled = false);
      await t.pumpAndSettle();
      image = await pixels(t);
      expect(pixel(image, 65, 24), rgba(const Color(0xff888888)));
      expect(pixel(image, 175, 24), rgba(const Color(0xff888888)));
      await t.pumpWidget(const SizedBox());
      for (final n in focus) n.dispose();
    },
  );
  testWidgets(
    'root and nested opacity apply once and local transitions animate independently',
    (t) async {
      final focus = [FocusNode(), FocusNode()];
      final animated = style
          .thumb(BoxStyler().wrap(.opacity(.4)))
          .onFocused(SliderStyler().thumbColor(blue))
          .animate(AnimationConfig.linear(const Duration(milliseconds: 200)))
          .wrap(.opacity(.5));
      await t.pumpWidget(
        host(
          RemixRangeSlider(
            values: const [.25, .75],
            focusNodes: focus,
            onChanged: (_) {},
            style: animated,
          ),
        ),
      );
      await t.pumpAndSettle();
      var image = await pixels(t);
      expect(pixel(image, 65, 18), rgba(const Color(0xffffcccc)));
      expect(pixel(image, 175, 18), rgba(const Color(0xffffcccc)));
      focus[0].requestFocus();
      await t.pump();
      await t.pump(); // Focus notifications reach the slider after the frame.
      await t.pump(const Duration(milliseconds: 100));
      image = await pixels(t);
      final mid = pixel(image, 65, 18);
      expect((mid >> 24) & 255, inInclusiveRange(228, 230));
      expect((mid >> 8) & 255, inInclusiveRange(228, 230));
      expect(pixel(image, 175, 18), rgba(const Color(0xffffcccc)));
      await t.pumpAndSettle();
      image = await pixels(t);
      expect(pixel(image, 65, 18), rgba(const Color(0xffccccff)));
      expect(
        t
            .widgetList<Opacity>(find.byType(Opacity))
            .map((w) => w.opacity)
            .toList()
          ..sort(),
        [.4, .4, .5],
      );
      await t.pumpWidget(const SizedBox());
      for (final n in focus) n.dispose();
    },
  );
  for (final keyframe in [false, true]) {
    testWidgets(
      '${keyframe ? 'keyframe' : 'phase'} frames paint root and nested opacity once',
      (t) async {
        final trigger = ValueNotifier(false);
        final base = style
            .thumb(BoxStyler().wrap(.opacity(.4)))
            .wrap(.opacity(.5));
        final animated = keyframe
            ? base.keyframeAnimation(
                trigger: trigger,
                timeline: [
                  KeyframeTrack<double>('progress', [
                    const Keyframe.linear(1, Duration(milliseconds: 100)),
                  ], initial: 0),
                ],
                styleBuilder: (_, style) => style,
              )
            : base.phaseAnimation<int>(
                trigger: trigger,
                phases: const [0, 1],
                styleBuilder: (_, style) => style,
                configBuilder: (_) => const CurveAnimationConfig.linear(
                  Duration(milliseconds: 100),
                ),
              );
        await t.pumpWidget(
          host(
            RemixRangeSlider(
              values: const [.25, .75],
              onChanged: (_) {},
              style: animated,
            ),
          ),
        );
        trigger.value = true;
        await t.pump();
        await t.pump(const Duration(milliseconds: 50));
        final image = await pixels(t);
        final rail = pixel(image, 32, 24);
        // Allow two channel levels for raster opacity rounding. Doubled root
        // opacity would instead leave these white-background channels near 191.
        expect((rail >> 24) & 255, closeTo(128, 2));
        expect((rail >> 16) & 255, closeTo(128, 2));
        expect(rail & 0xffff, 0xffff);
        expect(pixel(image, 65, 18), rgba(const Color(0xffffcccc)));
        expect(pixel(image, 175, 18), rgba(const Color(0xffffcccc)));
        await t.pumpWidget(const SizedBox());
        trigger.dispose();
      },
    );
  }
}
