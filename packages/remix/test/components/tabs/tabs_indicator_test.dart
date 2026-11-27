import 'package:flutter/material.dart';
import 'package:flutter/physics.dart' show SpringSimulation;
import 'package:flutter/rendering.dart' show RenderRepaintBoundary;
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:remix/src/rendering/remix_box_effects.dart'
    show RemixBoxAdapter;

import '../../helpers/motion_harness.dart';
import '../../helpers/test_helpers.dart';

final _indicator = find.byKey(const ValueKey('remix-selection-indicator'));
final _boundary = GlobalKey();

/// An opaque green no tab or label paints, so its bounding box in the
/// rendered image is the indicator wherever its layer was placed.
const _green = Color(0xFF00C800);

const _labels = {'a': 'Alpha', 'b': 'Beta', 'c': 'Gamma', 'd': 'Delta'};

/// Three tabs `a`, `b` and `c`, or the [ids] given, in a bar whose indicator
/// is [_green].
Widget _tabs({
  required String selected,
  required ValueChanged<String> onChanged,
  AnimationConfig? motion,
  bool withIndicator = true,
  double firstWidth = 80,
  Axis axis = Axis.horizontal,
  List<String> ids = const ['a', 'b', 'c'],
  Set<String> disabled = const {},
  Widget Function(Widget strip)? wrapStrip,
}) {
  var bar = TabBarStyler().container(
    FlexBoxStyler()
        .direction(axis == Axis.horizontal ? .horizontal : .vertical)
        .mainAxisSize(.min),
  );
  if (withIndicator) {
    bar = bar.indicator(BoxStyler().color(_green));
    if (motion != null) bar = bar.indicatorMotion(motion);
  }

  const widths = {'a': 80.0, 'b': 140.0, 'c': 100.0, 'd': 80.0};
  final strip = Flex(
    direction: axis,
    mainAxisSize: MainAxisSize.min,
    children: [
      for (final id in ids)
        SizedBox(
          width: id == 'a' ? firstWidth : widths[id],
          child: RemixTab(
            key: ValueKey(id),
            tabId: id,
            label: _labels[id],
            enabled: !disabled.contains(id),
          ),
        ),
    ],
  );

  // The image of the boundary is cropped to its size, so it is larger than
  // the bar: an indicator that is off its tab is then still seen.
  return RepaintBoundary(
    key: _boundary,
    child: SizedBox(
      width: 700,
      height: 400,
      child: Align(
        alignment: Alignment.topLeft,
        child: RemixTabs(
          selectedTabId: selected,
          onChanged: onChanged,
          child: RemixTabBar(
            style: bar,
            child: wrapStrip?.call(strip) ?? strip,
          ),
        ),
      ),
    ),
  );
}

Rect _tabRect(WidgetTester tester, String label) => tester.getRect(
  find.ancestor(of: find.text(label), matching: find.byType(SizedBox)).first,
);

/// The bounding box, in global coordinates, of the pixels [color] paints in
/// the bar's image, or `null` when there are none. Reads what is drawn, not
/// where a render box sits, because the indicator is placed by its layer.
Future<Rect?> _indicatorRect(
  WidgetTester tester, {
  Color color = _green,
}) async {
  final origin = tester.getTopLeft(find.byKey(_boundary));
  final result = await tester.runAsync(() async {
    final render =
        _boundary.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await render.toImage();
    final data = (await image.toByteData())!;
    var minX = image.width, minY = image.height, maxX = -1, maxY = -1;
    final r = (color.r * 255).round(), g = (color.g * 255).round();
    final b = (color.b * 255).round();
    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final i = (y * image.width + x) * 4;
        if (data.getUint8(i) == r &&
            data.getUint8(i + 1) == g &&
            data.getUint8(i + 2) == b &&
            data.getUint8(i + 3) == 255) {
          if (x < minX) minX = x;
          if (y < minY) minY = y;
          if (x > maxX) maxX = x;
          if (y > maxY) maxY = y;
        }
      }
    }
    return maxX < 0
        ? null
        : Rect.fromLTRB(
            minX.toDouble(),
            minY.toDouble(),
            maxX + 1.0,
            maxY + 1.0,
          );
  });
  return result?.shift(origin);
}

/// The indicator sits on [expected] to within a pixel of antialiasing.
Future<void> _expectOn(WidgetTester tester, Rect expected) async {
  final actual = await _indicatorRect(tester);
  expect(actual, isNotNull, reason: 'the indicator paints');
  expect(actual!.left, closeTo(expected.left, 1.5));
  expect(actual.top, closeTo(expected.top, 1.5));
  expect(actual.right, closeTo(expected.right, 1.5));
  expect(actual.bottom, closeTo(expected.bottom, 1.5));
}

void main() {
  group('indicator motion', () {
    test('TabBarSpec carries the indicator and its motion', () {
      expect(const TabBarSpec().indicator, isNull);
      expect(const TabBarSpec().indicatorMotion, isNull);
      final motion = AnimationConfig.curve(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      final spec = TabBarSpec(
        indicator: StyleSpec(spec: const BoxSpec()),
        indicatorMotion: motion,
      );
      expect(spec.indicator, isNotNull);
      expect(spec.indicatorMotion, motion);
    });

    test(
      'the styler takes an AnimationConfig and keeps it apart from animate',
      () {
        final curve = AnimationConfig.easeOutCubic(
          const Duration(milliseconds: 300),
        );
        final spring = AnimationConfig.springDescription(
          mass: 1,
          stiffness: 400,
          damping: 30,
        );
        final styler = TabBarStyler()
            .indicator(BoxStyler().color(_green))
            .indicatorMotion(curve)
            .animate(spring);

        expect(styler.$indicatorMotion, Prop.value(curve));
        expect(styler.$animation, spring);
        expect(
          TabBarStyler().indicatorMotion(curve),
          TabBarStyler().indicatorMotion(
            AnimationConfig.easeOutCubic(const Duration(milliseconds: 300)),
          ),
        );
        expect(
          TabBarStyler().indicatorMotion(curve),
          isNot(TabBarStyler().indicatorMotion(spring)),
        );
      },
    );

    for (final (name, config) in <(String, AnimationConfig)>[
      (
        'phase',
        PhaseAnimationConfig<BoxSpec, BoxStyler>(
          styles: [BoxStyler(), BoxStyler().color(_green)],
          curveConfigs: [
            CurveAnimationConfig(
              duration: Duration(milliseconds: 200),
              curve: Curves.linear,
            ),
          ],
          trigger: null,
        ),
      ),
      (
        'keyframe',
        KeyframeAnimationConfig<BoxSpec>(
          trigger: null,
          timeline: [],
          styleBuilder: (_, style) => style,
          initialStyle: BoxStyler(),
        ),
      ),
    ]) {
      testWidgets('rejects $name motion before selection changes', (
        tester,
      ) async {
        await tester.pumpWidget(
          MixScope.empty(
            child: MaterialApp(
              home: _tabs(selected: 'a', motion: config, onChanged: (_) {}),
            ),
          ),
          phase: EnginePhase.build,
        );

        expect(
          tester.takeException(),
          isA<ArgumentError>().having(
            (error) => error.name,
            'argument',
            'indicatorMotion',
          ),
        );
      });
    }
  });

  group('RemixTabBar indicator', () {
    testWidgets('sits on the selected tab, behind its label', (tester) async {
      await tester.pumpRemixApp(_tabs(selected: 'b', onChanged: (_) {}));
      await tester.pump();

      expect(_indicator, findsOneWidget);
      await _expectOn(tester, _tabRect(tester, 'Beta'));
    });

    testWidgets('glides between tabs and ends on the new tab', (tester) async {
      var selected = 'a';
      late StateSetter set;
      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            set = setState;
            return _tabs(
              selected: selected,
              motion: AnimationConfig.curve(
                duration: const Duration(milliseconds: 400),
                curve: Curves.linear,
              ),
              onChanged: (id) => setState(() => selected = id),
            );
          },
        ),
      );
      final start = (await _indicatorRect(tester))!;
      await _expectOn(tester, _tabRect(tester, 'Alpha'));

      set(() => selected = 'c');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1));
      final first = (await _indicatorRect(tester))!;
      expect(first.left, closeTo(start.left, 2));

      await tester.pump(const Duration(milliseconds: 200));
      final mid = (await _indicatorRect(tester))!;
      final end = _tabRect(tester, 'Gamma');
      expect(mid.left, greaterThan(start.left + 1));
      expect(mid.left, lessThan(end.left - 1));
      expect(mid.width, greaterThan(start.width));
      expect(mid.width, lessThan(end.width));

      await tester.pump(const Duration(milliseconds: 300));
      await _expectOn(tester, end);
    });

    testWidgets('waits out the delay of a curve config', (tester) async {
      var selected = 'a';
      var completions = 0;
      late StateSetter set;
      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            set = setState;
            return _tabs(
              selected: selected,
              motion: AnimationConfig.curve(
                duration: const Duration(milliseconds: 200),
                curve: Curves.linear,
                delay: const Duration(milliseconds: 200),
                onEnd: () => completions++,
              ),
              onChanged: (_) {},
            );
          },
        ),
      );
      final start = (await _indicatorRect(tester))!;

      set(() => selected = 'c');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));
      expect((await _indicatorRect(tester))!.left, closeTo(start.left, 2));
      expect(completions, 0);

      final target = _tabRect(tester, 'Gamma');
      await tester.pump(const Duration(milliseconds: 150));
      await _expectOn(tester, Rect.lerp(start, target, .5)!);
      expect(completions, 0);
      await tester.pump(const Duration(milliseconds: 101));
      await _expectOn(tester, target);
      expect(completions, 1);
    });

    testWidgets('a spring follows the Mix simulation from rest', (
      tester,
    ) async {
      var selected = 'a';
      final motion = SpringAnimationConfig.standard(
        mass: 1,
        stiffness: 400,
        damping: 40,
      );
      late StateSetter set;
      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            set = setState;
            return _tabs(selected: selected, motion: motion, onChanged: (_) {});
          },
        ),
      );

      final start = _tabRect(tester, 'Alpha');
      final end = _tabRect(tester, 'Beta');
      set(() => selected = 'b');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 60));
      final progress = SpringSimulation(motion.spring, 0, 1, 0).x(.06);
      await _expectOn(tester, Rect.lerp(start, end, progress)!);

      await tester.pumpAndSettle();
      await _expectOn(tester, end);
    });

    testWidgets('a bouncy spring overshoots and settles on the tab', (
      tester,
    ) async {
      var selected = 'a';
      var completions = 0;
      late StateSetter set;
      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            set = setState;
            return _tabs(
              selected: selected,
              motion: AnimationConfig.springUnderdamped(
                stiffness: 600,
                ratio: .3,
                onEnd: () => completions++,
              ),
              onChanged: (_) {},
            );
          },
        ),
      );

      set(() => selected = 'b');
      await tester.pump();
      var farthest = 0.0;
      final target = _tabRect(tester, 'Beta');
      for (var i = 0; i < 40; i++) {
        await tester.pump(const Duration(milliseconds: 16));
        final rect = (await _indicatorRect(tester))!;
        if (rect.right > farthest) farthest = rect.right;
      }
      expect(farthest, greaterThan(target.right + 1));
      expect(completions, 0);

      await tester.pumpAndSettle();
      await _expectOn(tester, target);
      expect(tester.getSize(_indicator), target.size);
      expect(completions, 1);
    });

    for (final request in MotionRequest.values) {
      testWidgets('settles an active glide on ${request.name} reduced motion', (
        tester,
      ) async {
        var selected = 'a';
        var completions = 0;
        late StateSetter set;
        final harness = await MotionHarness.pump(
          tester,
          StatefulBuilder(
            builder: (context, setState) {
              set = setState;
              return _tabs(
                selected: selected,
                motion: AnimationConfig.curve(
                  duration: const Duration(seconds: 1),
                  curve: Curves.linear,
                  onEnd: () => completions++,
                ),
                onChanged: (_) {},
              );
            },
          ),
        );
        set(() => selected = 'c');
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        final target = _tabRect(tester, 'Gamma');
        expect((await _indicatorRect(tester))!.left, lessThan(target.left));

        await harness.set(request, enabled: true);
        await _expectOn(tester, target);
        expect(tester.hasRunningAnimations, isFalse);
        await harness.set(request, enabled: false);
        await tester.pump(const Duration(seconds: 2));
        await _expectOn(tester, target);
        expect(completions, 0);
      });
    }

    testWidgets('jumps when the user asks to reduce motion', (tester) async {
      var selected = 'a';
      late StateSetter set;
      final harness = await MotionHarness.pump(
        tester,
        StatefulBuilder(
          builder: (context, setState) {
            set = setState;
            return _tabs(selected: selected, onChanged: (_) {});
          },
        ),
      );
      await harness.set(MotionRequest.mediaQuery, enabled: true);

      set(() => selected = 'c');
      await tester.pump();
      await tester.pump();

      await _expectOn(tester, _tabRect(tester, 'Gamma'));
    });

    testWidgets('follows its tab when the bar resizes', (tester) async {
      var width = 80.0;
      late StateSetter set;
      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            set = setState;
            return _tabs(selected: 'b', firstWidth: width, onChanged: (_) {});
          },
        ),
      );
      final before = (await _indicatorRect(tester))!;

      set(() => width = 160);
      await tester.pump();
      await tester.pump();

      await _expectOn(tester, _tabRect(tester, 'Beta'));
      expect((await _indicatorRect(tester))!.left, isNot(before.left));
    });

    testWidgets('hides when the selected tab does not exist', (tester) async {
      await tester.pumpRemixApp(_tabs(selected: 'zzz', onChanged: (_) {}));
      await tester.pump();

      expect(await _indicatorRect(tester), isNull);
    });

    testWidgets('hands indicatorEffects to the indicator surface', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        RemixTabs(
          selectedTabId: 'a',
          onChanged: (_) {},
          child: RemixTabBar(
            style: TabBarStyler()
                .indicator(BoxStyler().color(Colors.blue))
                .indicatorEffects(
                  RemixBoxEffectsMix.outline(
                    BorderSideMix(color: Colors.red, width: 2),
                  ),
                ),
            child: const RemixTab(tabId: 'a', label: 'Alpha'),
          ),
        ),
      );
      await tester.pump();

      expect(
        tester.widget<RemixBoxAdapter>(_indicator).containerEffects?.outline,
        const BorderSide(color: Colors.red, width: 2),
      );
    });

    testWidgets('paints the pill over the bar fill and under the label', (
      tester,
    ) async {
      const blue = Color(0xFF0000FF);
      await tester.pumpRemixApp(
        RepaintBoundary(
          key: _boundary,
          child: RemixTabs(
            selectedTabId: 'a',
            onChanged: (_) {},
            child: RemixTabBar(
              style: TabBarStyler()
                  .color(const Color(0xFFFF0000))
                  .padding(.all(8))
                  .indicator(BoxStyler().color(blue)),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 240,
                    child: RemixTab(tabId: 'a', label: 'Alpha'),
                  ),
                  SizedBox(
                    width: 80,
                    child: RemixTab(tabId: 'b', label: 'Beta'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      final pill = (await _indicatorRect(tester, color: blue))!;
      final bar = tester.getRect(find.byKey(_boundary));
      final pixels = (await tester.runAsync(() async {
        final render =
            _boundary.currentContext!.findRenderObject()!
                as RenderRepaintBoundary;
        final image = await render.toImage();
        return image.toByteData();
      }))!;
      Color at(Offset p) {
        final x = (p.dx - bar.left).round();
        final y = (p.dy - bar.top).round();
        final i = (y * bar.width.round() + x) * 4;
        return Color.fromARGB(
          pixels.getUint8(i + 3),
          pixels.getUint8(i),
          pixels.getUint8(i + 1),
          pixels.getUint8(i + 2),
        );
      }

      // Near the pill's far corner: the label is at the start of a wide tab,
      // whichever font the platform falls back to.
      final inside = at(pill.topRight + const Offset(-4, 3));
      expect(inside.b, greaterThan(.4));
      expect(inside.r, lessThan(.2));
      // The bar's padding, outside the pill, keeps the fill.
      final outside = at(pill.topLeft - const Offset(4, 4));
      expect(outside.r, greaterThan(.9));
      expect(outside.b, lessThan(.1));
      expect(pill.left, greaterThan(bar.left));
    });

    testWidgets('keeps the tab semantics and adds none', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpRemixApp(_tabs(selected: 'b', onChanged: (_) {}));
      await tester.pump();

      expect(find.bySemanticsLabel('Beta'), findsOneWidget);
      expect(
        tester.getSemantics(find.bySemanticsLabel('Beta')),
        isSemantics(isSelected: true, hasTapAction: true, isFocusable: true),
      );
      expect(
        find.descendant(of: _indicator, matching: find.byType(Semantics)),
        findsNothing,
      );
      handle.dispose();
    });

    testWidgets('announces the new selection while the indicator glides', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      final motion = AnimationConfig.curve(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
      Widget bar(String selected) =>
          _tabs(selected: selected, onChanged: (_) {}, motion: motion);
      await tester.pumpRemixApp(bar('a'));
      await tester.pump();
      expect(
        tester.getSemantics(find.bySemanticsLabel('Alpha')),
        isSemantics(isSelected: true, hasTapAction: true, isFocusable: true),
      );
      expect(
        tester.getSemantics(find.bySemanticsLabel('Beta')),
        isSemantics(isSelected: false, hasTapAction: true, isFocusable: true),
      );

      await tester.pumpRemixApp(bar('b'));
      await tester.pump(const Duration(milliseconds: 100));
      // Mid-glide: the selection is already the new tab, and the indicator
      // adds no node of its own.
      expect(
        tester.getSemantics(find.bySemanticsLabel('Alpha')),
        isSemantics(isSelected: false, hasTapAction: true, isFocusable: true),
      );
      expect(
        tester.getSemantics(find.bySemanticsLabel('Beta')),
        isSemantics(isSelected: true, hasTapAction: true, isFocusable: true),
      );
      expect(
        find.bySemanticsLabel(RegExp('Alpha|Beta|Gamma')),
        findsNWidgets(3),
      );
      handle.dispose();
    });

    testWidgets('does not take taps from the tabs', (tester) async {
      String? tapped;
      await tester.pumpRemixApp(
        _tabs(selected: 'a', onChanged: (id) => tapped = id),
      );
      await tester.pump();

      await tester.tap(find.text('Beta'));
      await tester.pump();

      expect(tapped, 'b');
    });
  });

  group('a tab that moves without the bar being laid out again', () {
    testWidgets('keeps the indicator on it when a sibling resizes inside a '
        'relayout boundary', (tester) async {
      // A strip of fixed size gives its Row tight constraints, so the Row is a
      // relayout boundary: resizing Alpha lays out the Row, not the bar.
      var alpha = 80.0;
      late StateSetter set;
      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            set = setState;
            return _tabs(
              selected: 'b',
              onChanged: (_) {},
              wrapStrip: (_) => SizedBox(
                width: 360,
                height: 40,
                child: Row(
                  children: [
                    SizedBox(
                      width: alpha,
                      child: const RemixTab(tabId: 'a', label: 'Alpha'),
                    ),
                    const SizedBox(
                      width: 140,
                      child: RemixTab(tabId: 'b', label: 'Beta'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
      await tester.pump();
      final before = _tabRect(tester, 'Beta');
      await _expectOn(tester, before);

      set(() => alpha = 160);
      // One frame: the indicator must be right in the frame the tab moves.
      await tester.pump();

      final after = _tabRect(tester, 'Beta');
      expect(after.left, closeTo(before.left + 80, 1));
      await _expectOn(tester, after);
    });

    testWidgets('keeps the indicator on a tab that a Transform moves', (
      tester,
    ) async {
      final dx = ValueNotifier<double>(0);
      addTearDown(dx.dispose);
      await tester.pumpRemixApp(
        _tabs(
          selected: 'b',
          onChanged: (_) {},
          wrapStrip: (_) => ValueListenableBuilder<double>(
            valueListenable: dx,
            builder: (context, dx, _) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 80,
                  child: RemixTab(tabId: 'a', label: 'Alpha'),
                ),
                Transform.translate(
                  offset: Offset(dx, 0),
                  child: const SizedBox(
                    width: 140,
                    child: RemixTab(tabId: 'b', label: 'Beta'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();
      await _expectOn(tester, _tabRect(tester, 'Beta'));

      dx.value = 40;
      await tester.pump();
      await _expectOn(tester, _tabRect(tester, 'Beta'));

      dx.value = -20;
      await tester.pump();
      await _expectOn(tester, _tabRect(tester, 'Beta'));
    });

    testWidgets('updates the selected width inside a fixed strip', (
      tester,
    ) async {
      final width = ValueNotifier<double>(80);
      addTearDown(width.dispose);
      await tester.pumpRemixApp(
        _tabs(
          selected: 'a',
          onChanged: (_) {},
          wrapStrip: (_) => SizedBox(
            width: 360,
            height: 40,
            child: ValueListenableBuilder<double>(
              valueListenable: width,
              builder: (context, width, _) => Row(
                children: [
                  SizedBox(
                    width: width,
                    child: const RemixTab(tabId: 'a', label: 'Alpha'),
                  ),
                  const RemixTab(tabId: 'b', label: 'Beta'),
                ],
              ),
            ),
          ),
        ),
      );
      await _expectOn(tester, _tabRect(tester, 'Alpha'));

      width.value = 140;
      await tester.pump();
      final target = _tabRect(tester, 'Alpha');
      expect(target.width, 140);
      await _expectOn(tester, target);
      await tester.pumpAndSettle();
      expect(tester.getSize(_indicator), target.size);
    });

    testWidgets('follows a paint-time scale of the selected tab', (
      tester,
    ) async {
      final scale = ValueNotifier<double>(1);
      addTearDown(scale.dispose);
      await tester.pumpRemixApp(
        _tabs(
          selected: 'a',
          onChanged: (_) {},
          wrapStrip: (_) => ValueListenableBuilder<double>(
            valueListenable: scale,
            builder: (context, scale, _) => Transform.scale(
              scale: scale,
              alignment: Alignment.topLeft,
              child: const SizedBox(
                width: 80,
                child: RemixTab(tabId: 'a', label: 'Alpha'),
              ),
            ),
          ),
        ),
      );
      await _expectOn(tester, _tabRect(tester, 'Alpha'));

      scale.value = 1.5;
      await tester.pump();
      final target = _tabRect(tester, 'Alpha');
      expect(target.width, 120);
      await _expectOn(tester, target);
    });

    testWidgets('keeps the indicator on a tab when the whole bar is moved', (
      tester,
    ) async {
      final dx = ValueNotifier<double>(0);
      addTearDown(dx.dispose);
      await tester.pumpRemixApp(
        ValueListenableBuilder<double>(
          valueListenable: dx,
          builder: (context, dx, child) =>
              Transform.translate(offset: Offset(dx, 0), child: child),
          child: _tabs(selected: 'b', onChanged: (_) {}),
        ),
      );
      await tester.pump();

      dx.value = 25;
      await tester.pump();

      await _expectOn(tester, _tabRect(tester, 'Beta'));
    });

    testWidgets('keeps the indicator on a tab when a scroll view around the '
        'bar scrolls', (tester) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);
      await tester.pumpRemixApp(
        SizedBox(
          width: 250,
          height: 80,
          child: SingleChildScrollView(
            controller: controller,
            scrollDirection: Axis.horizontal,
            child: _tabs(selected: 'c', onChanged: (_) {}),
          ),
        ),
      );
      await tester.pump();

      controller.jumpTo(60);
      await tester.pump();

      // A scroll view above the bar moves the bar as a whole.
      await _expectOn(tester, _tabRect(tester, 'Gamma'));
    });
  });

  testWidgets('builds no indicator or compositing target by default', (
    tester,
  ) async {
    await tester.pumpRemixApp(
      _tabs(selected: 'a', onChanged: (_) {}, withIndicator: false),
    );

    expect(_indicator, findsNothing);
    expect(find.byType(CompositedTransformTarget), findsNothing);
  });

  for (final initiallyEnabled in [false, true]) {
    testWidgets('retains focus and child state when toggling from '
        '${initiallyEnabled ? 'enabled' : 'disabled'}', (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      const content = ValueKey('stateful tab content');
      var withIndicator = initiallyEnabled;
      late StateSetter set;
      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            set = setState;
            return _tabs(
              selected: 'a',
              withIndicator: withIndicator,
              onChanged: (_) {},
              wrapStrip: (_) => RemixTab(
                tabId: 'a',
                focusNode: focusNode,
                child: StatefulBuilder(
                  key: content,
                  builder: (context, _) => const Text('Alpha'),
                ),
              ),
            );
          },
        ),
      );
      focusNode.requestFocus();
      await tester.pump();
      expect(focusNode.hasPrimaryFocus, isTrue);
      final state = tester.state(find.byKey(content));

      for (final enabled in [!initiallyEnabled, initiallyEnabled]) {
        set(() => withIndicator = enabled);
        await tester.pump();
        expect(_indicator, enabled ? findsOneWidget : findsNothing);
        expect(tester.state(find.byKey(content)), same(state));
        expect(focusNode.hasPrimaryFocus, isTrue);
      }
    });
  }

  group('right to left', () {
    testWidgets('retargets from the last painted rectangle during reflow', (
      tester,
    ) async {
      var selected = 'a';
      var gap = 0.0;
      final completed = <String>[];
      late StateSetter set;
      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            set = setState;
            final target = selected;
            return _tabs(
              selected: selected,
              motion: AnimationConfig.curve(
                duration: const Duration(milliseconds: 400),
                curve: Curves.linear,
                onEnd: () => completed.add(target),
              ),
              onChanged: (_) {},
              wrapStrip: (strip) {
                final children = (strip as Flex).children;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...children.take(2),
                    SizedBox(width: gap),
                    children.last,
                  ],
                );
              },
            );
          },
        ),
        textDirection: TextDirection.rtl,
      );
      set(() => selected = 'b');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      final before = (await _indicatorRect(tester))!;

      set(() {
        selected = 'c';
        gap = 50;
      });
      await tester.pump();
      await _expectOn(tester, before);
      await tester.pump(const Duration(milliseconds: 200));
      final target = _tabRect(tester, 'Gamma');
      await _expectOn(tester, Rect.lerp(before, target, .5)!);
      expect(completed, isEmpty);

      await tester.pump(const Duration(milliseconds: 201));
      await _expectOn(tester, target);
      expect(completed, ['c']);
    });

    testWidgets('sits on the selected tab', (tester) async {
      await tester.pumpRemixApp(
        _tabs(selected: 'b', onChanged: (_) {}),
        textDirection: TextDirection.rtl,
      );
      await tester.pump();

      // Alpha is the rightmost tab.
      expect(
        _tabRect(tester, 'Alpha').left,
        greaterThan(_tabRect(tester, 'Gamma').left),
      );
      await _expectOn(tester, _tabRect(tester, 'Beta'));
    });

    testWidgets('glides toward the left when the next tab is to the left', (
      tester,
    ) async {
      var selected = 'a';
      late StateSetter set;
      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            set = setState;
            return _tabs(
              selected: selected,
              motion: AnimationConfig.curve(
                duration: const Duration(milliseconds: 400),
                curve: Curves.linear,
              ),
              onChanged: (_) {},
            );
          },
        ),
        textDirection: TextDirection.rtl,
      );
      final start = (await _indicatorRect(tester))!;
      await _expectOn(tester, _tabRect(tester, 'Alpha'));

      set(() => selected = 'c');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      final mid = (await _indicatorRect(tester))!;
      final end = _tabRect(tester, 'Gamma');

      expect(mid.left, lessThan(start.left - 1));
      expect(mid.left, greaterThan(end.left + 1));

      await tester.pump(const Duration(milliseconds: 300));
      await _expectOn(tester, end);
    });
  });

  group('vertical tabs', () {
    testWidgets('sits on the selected tab and glides down', (tester) async {
      var selected = 'a';
      late StateSetter set;
      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            set = setState;
            return _tabs(
              selected: selected,
              axis: Axis.vertical,
              motion: AnimationConfig.curve(
                duration: const Duration(milliseconds: 400),
                curve: Curves.linear,
              ),
              onChanged: (_) {},
            );
          },
        ),
      );
      final start = (await _indicatorRect(tester))!;
      await _expectOn(tester, _tabRect(tester, 'Alpha'));

      set(() => selected = 'c');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      final mid = (await _indicatorRect(tester))!;
      final end = _tabRect(tester, 'Gamma');

      expect(mid.top, greaterThan(start.top + 1));
      expect(mid.top, lessThan(end.top - 1));
      expect(mid.right, greaterThan(mid.left));

      await tester.pump(const Duration(milliseconds: 300));
      await _expectOn(tester, end);
    });
  });

  group('tabs that come and go', () {
    testWidgets('follows the selected tab when a tab is inserted before it', (
      tester,
    ) async {
      var ids = ['a', 'b', 'c'];
      late StateSetter set;
      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            set = setState;
            return _tabs(selected: 'b', ids: ids, onChanged: (_) {});
          },
        ),
      );
      final before = (await _indicatorRect(tester))!;

      set(() => ids = ['d', 'a', 'b', 'c']);
      await tester.pump();
      await tester.pump();

      await _expectOn(tester, _tabRect(tester, 'Beta'));
      expect((await _indicatorRect(tester))!.left, isNot(before.left));
    });

    testWidgets('follows the selected tab when a tab before it is removed', (
      tester,
    ) async {
      var ids = ['a', 'b', 'c'];
      late StateSetter set;
      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            set = setState;
            return _tabs(selected: 'c', ids: ids, onChanged: (_) {});
          },
        ),
      );

      set(() => ids = ['b', 'c']);
      await tester.pump();
      await tester.pump();

      await _expectOn(tester, _tabRect(tester, 'Gamma'));
    });

    testWidgets('hides while the selected tab is gone and returns with it', (
      tester,
    ) async {
      var ids = ['a', 'b', 'c'];
      late StateSetter set;
      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            set = setState;
            return _tabs(selected: 'b', ids: ids, onChanged: (_) {});
          },
        ),
      );
      await _expectOn(tester, _tabRect(tester, 'Beta'));

      set(() => ids = ['a', 'c']);
      await tester.pump();
      await tester.pump();
      expect(await _indicatorRect(tester), isNull);

      set(() => ids = ['a', 'b', 'c']);
      await tester.pump();
      await tester.pump();
      await _expectOn(tester, _tabRect(tester, 'Beta'));
    });

    testWidgets('jumps to the new selection when the selected tab is removed', (
      tester,
    ) async {
      var selected = 'b';
      var completions = 0;
      var ids = ['a', 'b', 'c'];
      late StateSetter set;
      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            set = setState;
            return _tabs(
              selected: selected,
              ids: ids,
              motion: AnimationConfig.curve(
                duration: const Duration(seconds: 1),
                curve: Curves.linear,
                onEnd: () => completions++,
              ),
              onChanged: (_) {},
            );
          },
        ),
      );

      set(() {
        ids = ['a', 'c'];
        selected = 'a';
      });
      await tester.pump();
      await tester.pump();

      await _expectOn(tester, _tabRect(tester, 'Alpha'));
      expect(tester.hasRunningAnimations, isFalse);
      await tester.pump(const Duration(seconds: 2));
      await _expectOn(tester, _tabRect(tester, 'Alpha'));
      expect(completions, 0);
    });
  });

  group('a disabled selected tab', () {
    testWidgets('still carries the indicator', (tester) async {
      await tester.pumpRemixApp(
        _tabs(selected: 'b', disabled: const {'b'}, onChanged: (_) {}),
      );
      await tester.pump();

      await _expectOn(tester, _tabRect(tester, 'Beta'));
    });

    testWidgets('glides away from it, and cannot be glided to by tapping', (
      tester,
    ) async {
      var selected = 'b';
      late StateSetter set;
      String? tapped;
      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            set = setState;
            return _tabs(
              selected: selected,
              disabled: const {'b'},
              onChanged: (id) => tapped = id,
            );
          },
        ),
      );

      await tester.tap(find.text('Beta'));
      await tester.pump();
      expect(tapped, isNull);
      await _expectOn(tester, _tabRect(tester, 'Beta'));

      set(() => selected = 'c');
      await tester.pumpAndSettle();
      await _expectOn(tester, _tabRect(tester, 'Gamma'));
    });
  });
}
