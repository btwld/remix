import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderRepaintBoundary;
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart' show NakedTab;
import 'package:remix/remix.dart';
import 'package:remix/src/rendering/remix_box_effects.dart'
    show RemixBoxAdapter;

import '../../helpers/motion_harness.dart';
import '../../helpers/test_helpers.dart';

final _indicator = find.byKey(const ValueKey('remix-tab-indicator'));
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

      await tester.pumpAndSettle();
      await _expectOn(tester, _tabRect(tester, 'Gamma'));
    });

    testWidgets('a spring config moves it too', (tester) async {
      var selected = 'a';
      late StateSetter set;
      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            set = setState;
            return _tabs(
              selected: selected,
              motion: AnimationConfig.springDescription(
                mass: 1,
                stiffness: 400,
                damping: 40,
              ),
              onChanged: (_) {},
            );
          },
        ),
      );

      set(() => selected = 'b');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 60));
      final mid = (await _indicatorRect(tester))!;
      expect(mid.left, greaterThan(_tabRect(tester, 'Alpha').left + 1));

      await tester.pumpAndSettle();
      await _expectOn(tester, _tabRect(tester, 'Beta'));
    });

    testWidgets('a bouncy spring overshoots and settles on the tab', (
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
              motion: AnimationConfig.springUnderdamped(
                stiffness: 600,
                ratio: .3,
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

      await tester.pumpAndSettle();
      await _expectOn(tester, target);
    });

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
                    width: 80,
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

      // Near the pill's corner, clear of the label.
      final inside = at(pill.topLeft + const Offset(3, 3));
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

  group('without an indicator', () {
    bool isAnchor(Widget w) =>
        w.runtimeType.toString() == '_TabIndicatorAnchor';

    testWidgets('builds no indicator', (tester) async {
      await tester.pumpRemixApp(
        _tabs(selected: 'a', onChanged: (_) {}, withIndicator: false),
      );

      expect(_indicator, findsNothing);
    });

    testWidgets('builds each tab as the NakedTab and nothing around it', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        _tabs(selected: 'a', onChanged: (_) {}, withIndicator: false),
      );

      expect(find.byWidgetPredicate(isAnchor), findsNothing);
      expect(find.byType(CompositedTransformTarget), findsNothing);
      for (final id in ['a', 'b', 'c']) {
        final element = tester.element(find.byKey(ValueKey(id)));
        final children = <Widget>[];
        element.visitChildren((child) => children.add(child.widget));
        expect(children, hasLength(1));
        expect(children.single, isA<NakedTab>(), reason: 'tab $id');
      }
      // No leader layer, which is what an anchor adds, anywhere in the tree.
      var leaders = 0;
      void visit(RenderObject object) {
        if (object.runtimeType.toString().contains('Leader') ||
            object.runtimeType.toString().contains('Anchor')) {
          leaders++;
        }
        object.visitChildren(visit);
      }

      visit(tester.binding.renderViews.first);
      expect(leaders, 0);
    });

    testWidgets('wraps the tabs only once an indicator is set', (tester) async {
      var withIndicator = false;
      late StateSetter set;
      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            set = setState;
            return _tabs(
              selected: 'a',
              onChanged: (_) {},
              withIndicator: withIndicator,
            );
          },
        ),
      );
      expect(find.byWidgetPredicate(isAnchor), findsNothing);

      set(() => withIndicator = true);
      await tester.pump();
      expect(find.byWidgetPredicate(isAnchor), findsNWidgets(3));
      await _expectOn(tester, _tabRect(tester, 'Alpha'));

      set(() => withIndicator = false);
      await tester.pump();
      expect(find.byWidgetPredicate(isAnchor), findsNothing);
    });
  });

  group('right to left', () {
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
      var ids = ['a', 'b', 'c'];
      late StateSetter set;
      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            set = setState;
            return _tabs(selected: selected, ids: ids, onChanged: (_) {});
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
      await tester.pumpAndSettle();
      await _expectOn(tester, _tabRect(tester, 'Alpha'));
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
