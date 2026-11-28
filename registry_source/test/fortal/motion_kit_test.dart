import 'dart:ui' show ImageFilter;

import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';

double _spring(
  SpringDescription spring,
  double from,
  double to,
  double ms, {
  double velocity = 0,
}) => SpringSimulation(spring, from, to, velocity).x(ms / 1000);

double _springVelocity(
  SpringDescription spring,
  double from,
  double to,
  double ms,
) => SpringSimulation(spring, from, to, 0).dx(ms / 1000);

Widget _host(Widget child, {bool reduceMotion = false}) => MediaQuery(
  data: MediaQueryData(disableAnimations: reduceMotion),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: DefaultTextStyle(
      style: const TextStyle(fontSize: 10),
      child: Align(alignment: Alignment.topLeft, child: child),
    ),
  ),
);

/// The opacity, translation, scale and blur sigma a [FortalAnimatedVisual]
/// paints its child with. [of] narrows to the visual above that finder.
({double opacity, Offset offset, double scale, double blur}) _visual(
  WidgetTester tester, {
  Finder? of,
}) {
  final visual = of == null
      ? find.byType(FortalAnimatedVisual)
      : find
            .ancestor(of: of, matching: find.byType(FortalAnimatedVisual))
            .first;
  T only<T extends Widget>() => tester.widget<T>(
    find.descendant(of: visual, matching: find.byType(T)).first,
  );
  final transforms = find.descendant(
    of: visual,
    matching: find.byType(Transform),
  );
  final translate = tester.widget<Transform>(transforms.at(0)).transform;
  final scale = tester.widget<Transform>(transforms.at(1)).transform;
  final filtered = only<ImageFiltered>();

  return (
    opacity: only<Opacity>().opacity,
    offset: Offset(translate.getTranslation().x, translate.getTranslation().y),
    scale: scale.entry(0, 0),
    blur: filtered.enabled ? _sigma(filtered.imageFilter) : 0,
  );
}

double _sigma(ImageFilter filter) => double.parse(
  RegExp(r'ImageFilter\.blur\(([\d.]+)').firstMatch('$filter')!.group(1)!,
);

void main() {
  group('FortalSpringCurve', () {
    test('the transform ease runs 440 ms and is 90.8% through at 220 ms', () {
      final curve = FortalSpringCurve.css;

      expect(curve.duration.inMilliseconds, inInclusiveRange(439, 441));
      expect(
        curve.transform(220 / curve.duration.inMilliseconds),
        closeTo(0.908, 0.003),
      );
      expect(curve.transform(1), 1);
    });

    test('follows its spring over its own settle time', () {
      final curve = FortalSpringCurve.snappy;
      final ms = curve.duration.inMilliseconds;

      // Critically damped: 0.3% of travel is left at omega * t = 8.
      expect(ms, closeTo(8 / 26.18 * 1000, 2));
      for (final t in [0.1, 0.25, 0.5, 0.9]) {
        expect(
          curve.transform(t),
          closeTo(_spring(FortalMotion.springSnappy, 0, 1, t * ms), 1e-9),
        );
      }
    });
  });

  group('FortalAnimatedVisual', () {
    Widget visual(FortalVisual target, {bool reduceMotion = false}) => _host(
      FortalAnimatedVisual(
        visual: target,
        timing: const FortalVisualTiming(
          opacity: FortalTiming.fade,
          transform: FortalTiming.snappy,
        ),
        child: const SizedBox(width: 10, height: 10),
      ),
      reduceMotion: reduceMotion,
    );

    testWidgets('runs opacity on its curve and the transform on its spring', (
      tester,
    ) async {
      await tester.pumpWidget(visual(FortalVisual.rest));
      await tester.pumpWidget(
        visual(const FortalVisual(opacity: 0, offset: Offset(0, 100))),
      );
      for (final ms in [0, 75, 150]) {
        if (ms > 0) await tester.pump(const Duration(milliseconds: 75));
        final now = _visual(tester);
        expect(
          now.opacity,
          closeTo(1 - FortalMotion.easeStandard.transform(ms / 150), 1e-6),
          reason: 'opacity at $ms ms',
        );
        expect(
          now.offset.dy,
          closeTo(
            _spring(FortalMotion.springSnappy, 0, 100, ms.toDouble()),
            1e-6,
          ),
          reason: 'offset at $ms ms',
        );
      }
    });

    testWidgets('a spring retargeted mid-flight keeps its velocity', (
      tester,
    ) async {
      await tester.pumpWidget(visual(FortalVisual.rest));
      await tester.pumpWidget(
        visual(const FortalVisual(offset: Offset(0, 100))),
      );
      await tester.pump(const Duration(milliseconds: 60));
      final position = _visual(tester).offset.dy;
      final velocity = _springVelocity(FortalMotion.springSnappy, 0, 100, 60);
      expect(
        position,
        closeTo(_spring(FortalMotion.springSnappy, 0, 100, 60), 1e-6),
      );
      expect(velocity, greaterThan(500));

      await tester.pumpWidget(visual(FortalVisual.rest));
      await tester.pump(const Duration(milliseconds: 50));

      expect(
        _visual(tester).offset.dy,
        closeTo(
          _spring(
            FortalMotion.springSnappy,
            position,
            0,
            50,
            velocity: velocity,
          ),
          1e-3,
        ),
      );
    });

    testWidgets('reduced motion jumps the transform and fades in 100 ms', (
      tester,
    ) async {
      await tester.pumpWidget(visual(FortalVisual.rest, reduceMotion: true));
      await tester.pumpWidget(
        visual(
          const FortalVisual(opacity: 0, offset: Offset(0, 100), blur: 4),
          reduceMotion: true,
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));
      final now = _visual(tester);

      expect(now.offset.dy, 100);
      expect(now.blur, 4);
      expect(
        now.opacity,
        closeTo(1 - FortalMotion.easeStandard.transform(0.5), 1e-6),
      );
      await tester.pump(const Duration(milliseconds: 50));
      expect(_visual(tester).opacity, 0);
    });
  });

  group('FortalTextSwap', () {
    Widget swap(String text, {bool stagger = false, bool reduce = false}) =>
        _host(
          FortalTextSwap(text, staggerWords: stagger),
          reduceMotion: reduce,
        );

    testWidgets('the new text rises out of a blur over 200 ms', (tester) async {
      await tester.pumpWidget(swap('Draft'));
      expect(_visual(tester).opacity, 1, reason: 'no motion on first build');

      await tester.pumpWidget(swap('Sent'));
      for (final ms in [0, 100, 200]) {
        if (ms > 0) await tester.pump(const Duration(milliseconds: 100));
        final p = FortalMotion.easeEnter.transform(ms / 200);
        final incoming = _visual(tester, of: find.text('Sent'));
        expect(incoming.opacity, closeTo(p, 1e-6), reason: 'opacity at $ms');
        expect(
          incoming.offset.dy,
          closeTo(3 * (1 - p), 1e-6),
          reason: '0.3 em rise at $ms',
        );
        expect(
          incoming.blur,
          closeTo(FortalMotion.blurSoft * (1 - p), 1e-6),
          reason: 'blur at $ms',
        );
      }
    });

    testWidgets('the old text lifts away in 150 ms and leaves layout at once', (
      tester,
    ) async {
      await tester.pumpWidget(swap('Longer'));
      expect(tester.getSize(find.byType(FortalTextSwap)).width, 60);

      await tester.pumpWidget(swap('A'));
      expect(tester.getSize(find.byType(FortalTextSwap)).width, 10);
      await tester.pump(const Duration(milliseconds: 75));
      final outgoing = _visual(tester, of: find.text('Longer'));
      final p = FortalMotion.easeStandard.transform(0.5);
      expect(outgoing.opacity, closeTo(1 - p, 1e-6));
      expect(outgoing.offset.dy, closeTo(-3 * p, 1e-6));
      expect(outgoing.blur, closeTo(FortalMotion.blurSubtle * p, 1e-6));
      expect(
        tester.getSize(find.text('Longer')).width,
        60,
        reason: 'keeps painting at its own size',
      );

      await tester.pump(const Duration(milliseconds: 75));
      await tester.pump();
      expect(find.text('Longer'), findsNothing);
    });

    testWidgets('staggered words enter 40 ms apart', (tester) async {
      await tester.pumpWidget(swap('Up to date', stagger: true));
      await tester.pumpWidget(swap('Saved just now', stagger: true));
      await tester.pump(const Duration(milliseconds: 40));
      expect(_visual(tester, of: find.text('just')).opacity, 0);

      await tester.pump(const Duration(milliseconds: 100));
      expect(
        _visual(tester, of: find.text('Saved')).opacity,
        closeTo(FortalMotion.easeEnter.transform(140 / 200), 1e-6),
      );
      expect(
        _visual(tester, of: find.text('just')).opacity,
        closeTo(FortalMotion.easeEnter.transform(100 / 200), 1e-6),
      );
      expect(
        _visual(tester, of: find.text('now')).opacity,
        closeTo(FortalMotion.easeEnter.transform(60 / 200), 1e-6),
      );
    });

    testWidgets('reduced motion only crossfades', (tester) async {
      await tester.pumpWidget(swap('Draft', reduce: true));
      await tester.pumpWidget(swap('Sent', reduce: true));
      await tester.pump(const Duration(milliseconds: 50));
      final incoming = _visual(tester, of: find.text('Sent'));
      final outgoing = _visual(tester, of: find.text('Draft'));
      final p = FortalMotion.easeStandard.transform(0.5);

      expect(incoming.opacity, closeTo(p, 1e-6));
      expect(outgoing.opacity, closeTo(1 - p, 1e-6));
      for (final side in [incoming, outgoing]) {
        expect(side.offset, Offset.zero);
        expect(side.scale, 1);
        expect(side.blur, 0);
      }
    });
  });

  testWidgets('FortalSwap.icon grows the new icon from 0.6 on the snappy '
      'spring', (tester) async {
    Widget icon(String name) => _host(
      FortalSwap(
        motion: FortalSwapMotion.icon,
        child: SizedBox(key: ValueKey(name), width: 16, height: 16),
      ),
    );
    await tester.pumpWidget(icon('copy'));
    await tester.pumpWidget(icon('check'));
    await tester.pump(const Duration(milliseconds: 80));
    final p = _spring(FortalMotion.springSnappy, 0, 1, 80);
    final incoming = _visual(tester, of: find.byKey(const ValueKey('check')));

    expect(incoming.scale, closeTo(0.6 + 0.4 * p, 1e-3));
    expect(incoming.opacity, closeTo(p, 1e-3));
    expect(incoming.blur, closeTo(FortalMotion.blurSubtle * (1 - p), 1e-3));
  });

  group('FortalSizeMorph', () {
    Widget morph(Size size, {bool reduce = false}) => _host(
      FortalSizeMorph(
        heightTiming: FortalTiming.snappy,
        child: SizedBox.fromSize(size: size),
      ),
      reduceMotion: reduce,
    );
    Size morphSize(WidgetTester tester) =>
        tester.getSize(find.byType(FortalSizeMorph));

    testWidgets('takes the first size as is, then springs each axis on its '
        'own timing', (tester) async {
      await tester.pumpWidget(morph(const Size(100, 20)));
      expect(morphSize(tester), const Size(100, 20));

      await tester.pumpWidget(morph(const Size(200, 60)));
      await tester.pump(const Duration(milliseconds: 100));
      final size = morphSize(tester);
      expect(
        size.width,
        closeTo(_spring(FortalMotion.springMorph, 100, 200, 100), 1e-3),
      );
      expect(
        size.height,
        closeTo(_spring(FortalMotion.springSnappy, 20, 60, 100), 1e-3),
      );

      await tester.pumpAndSettle();
      expect(morphSize(tester), const Size(200, 60));
    });

    testWidgets('clips the child while smaller than it', (tester) async {
      await tester.pumpWidget(morph(const Size(100, 20)));
      await tester.pumpWidget(morph(const Size(200, 20)));
      await tester.pump(const Duration(milliseconds: 50));
      final box = tester.renderObject(find.byType(FortalSizeMorph));

      expect(box, paints..clipRect());
    });

    testWidgets('reduced motion follows the child at once', (tester) async {
      await tester.pumpWidget(morph(const Size(100, 20), reduce: true));
      await tester.pumpWidget(morph(const Size(200, 60), reduce: true));

      expect(morphSize(tester), const Size(200, 60));
    });
  });

  group('FortalIndicatorTrack', () {
    const pill = ValueKey('pill');
    Widget track(int selected, {bool reduce = false}) => _host(
      FortalIndicatorTrack(
        selected: selected,
        indicator: const ColoredBox(key: pill, color: Color(0xFF000000)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < 3; i++)
              FortalIndicatorAnchor(
                value: i,
                child: SizedBox(width: 50.0 + 10 * i, height: 20),
              ),
          ],
        ),
      ),
      reduceMotion: reduce,
    );
    Rect pillRect(WidgetTester tester) => tester.getRect(find.byKey(pill));

    testWidgets('sits on the selected anchor from the first frame', (
      tester,
    ) async {
      await tester.pumpWidget(track(1));

      expect(pillRect(tester), const Rect.fromLTWH(50, 0, 60, 20));
    });

    testWidgets('glides to the next anchor on the morph spring and keeps its '
        'velocity when retargeted', (tester) async {
      await tester.pumpWidget(track(0));
      await tester.pumpWidget(track(1));
      await tester.pump(const Duration(milliseconds: 80));
      final left = pillRect(tester).left;
      final velocity = _springVelocity(FortalMotion.springMorph, 0, 50, 80);
      expect(left, closeTo(_spring(FortalMotion.springMorph, 0, 50, 80), 1e-3));
      expect(
        pillRect(tester).width,
        closeTo(_spring(FortalMotion.springMorph, 50, 60, 80), 1e-3),
      );

      await tester.pumpWidget(track(2));
      await tester.pump(const Duration(milliseconds: 60));
      expect(
        pillRect(tester).left,
        closeTo(
          _spring(FortalMotion.springMorph, left, 110, 60, velocity: velocity),
          1e-2,
        ),
      );

      await tester.pumpAndSettle();
      expect(pillRect(tester), const Rect.fromLTWH(110, 0, 70, 20));
    });

    testWidgets('reduced motion jumps', (tester) async {
      await tester.pumpWidget(track(0, reduce: true));
      await tester.pumpWidget(track(2, reduce: true));

      expect(pillRect(tester), const Rect.fromLTWH(110, 0, 70, 20));
    });

    testWidgets('the indicator takes no pointer input', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _host(
          FortalIndicatorTrack(
            selected: 0,
            indicator: GestureDetector(
              onTap: () => taps++,
              child: const ColoredBox(color: Color(0xFF000000)),
            ),
            child: const FortalIndicatorAnchor(
              value: 0,
              child: SizedBox(width: 50, height: 20),
            ),
          ),
        ),
      );
      await tester.tapAt(const Offset(25, 10));

      expect(taps, 0);
    });
  });

  group('FortalRollingText', () {
    Widget rolling(String text, {bool reduce = false}) =>
        _host(FortalRollingText(text), reduceMotion: reduce);

    /// The vertical offset of the wheel slot showing [digit], in em.
    double slot(WidgetTester tester, String digit) {
      final transform = tester.widget<Transform>(
        find
            .ancestor(of: find.text(digit), matching: find.byType(Transform))
            .first,
      );

      return transform.transform.getTranslation().y / 10;
    }

    testWidgets('rolls a digit up through the digits between', (tester) async {
      await tester.pumpWidget(rolling('1'));
      await tester.pumpWidget(rolling('3'));
      await tester.pump(const Duration(milliseconds: 80));
      final position = 1 + 2 * _spring(FortalMotion.springSnappy, 0, 1, 80);

      expect(slot(tester, '3'), closeTo((3 - position) * 1.05, 1e-6));
      expect(slot(tester, '2'), closeTo((2 - position) * 1.05, 1e-6));

      await tester.pumpAndSettle();
      expect(slot(tester, '3'), 0);
      expect(find.text('2'), findsNothing);
    });

    testWidgets('wraps 9 to 0 going up and 0 to 9 going down', (tester) async {
      await tester.pumpWidget(rolling('19'));
      await tester.pumpWidget(rolling('20'));
      await tester.pump(const Duration(milliseconds: 40));
      expect(slot(tester, '0'), greaterThan(0), reason: 'arrives from below');

      await tester.pumpAndSettle();
      await tester.pumpWidget(rolling('19'));
      await tester.pump(const Duration(milliseconds: 40));
      expect(slot(tester, '9'), lessThan(0), reason: 'arrives from above');
    });

    testWidgets('a new place value grows in on the morph spring', (
      tester,
    ) async {
      await tester.pumpWidget(rolling('950'));
      await tester.pumpWidget(rolling('1,000'));
      await tester.pump(const Duration(milliseconds: 100));
      final separator = tester.widget<Align>(
        find.ancestor(of: find.text(','), matching: find.byType(Align)).first,
      );

      expect(
        separator.widthFactor,
        closeTo(_spring(FortalMotion.springMorph, 0, 1, 100), 1e-6),
      );
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(FortalRollingText)).width, 50);
    });

    testWidgets('reduced motion shows the new value at once', (tester) async {
      await tester.pumpWidget(rolling('1', reduce: true));
      await tester.pumpWidget(rolling('7', reduce: true));

      expect(slot(tester, '7'), 0);
      expect(find.text('6'), findsNothing);
      expect(tester.hasRunningAnimations, isFalse);
    });
  });

  testWidgets('FortalUnderline draws below the baseline by its offset', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const FortalUnderline(
          color: Color(0xFF112233),
          offset: 4,
          thickness: 1,
          child: Text('Link'),
        ),
      ),
    );
    final painter = TextPainter(
      text: const TextSpan(text: 'Link', style: TextStyle(fontSize: 10)),
      textDirection: TextDirection.ltr,
    )..layout();
    final baseline = painter.computeDistanceToActualBaseline(
      TextBaseline.alphabetic,
    );
    painter.dispose();

    expect(
      tester.renderObject(find.byType(FortalUnderline)),
      paints
        ..paragraph()
        ..rect(
          rect: Rect.fromLTWH(0, baseline + 4, 40, 1),
          color: const Color(0xFF112233),
        ),
    );
  });
}
