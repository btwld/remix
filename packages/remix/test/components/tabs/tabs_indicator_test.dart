import 'package:flutter/material.dart';
import 'package:flutter/physics.dart' show SpringDescription;
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:remix/src/rendering/remix_box_effects.dart'
    show RemixBoxAdapter;

import '../../helpers/motion_harness.dart';
import '../../helpers/test_helpers.dart';

final _indicator = find.byKey(const ValueKey('remix-tab-indicator'));

Widget _tabs({
  required String selected,
  required ValueChanged<String> onChanged,
  RemixTabIndicatorMotion? motion,
  bool withIndicator = true,
  double firstWidth = 80,
}) {
  var bar = TabBarStyler().container(
    FlexBoxStyler().direction(.horizontal).mainAxisSize(.min),
  );
  if (withIndicator) {
    bar = bar.indicator(
      BoxStyler().color(Colors.blue).borderRadius(.circular(6)),
    );
    if (motion != null) bar = bar.indicatorMotion(motion);
  }

  return RemixTabs(
    selectedTabId: selected,
    onChanged: onChanged,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RemixTabBar(
          style: bar,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: firstWidth,
                child: const RemixTab(tabId: 'a', label: 'Alpha'),
              ),
              const SizedBox(
                width: 140,
                child: RemixTab(tabId: 'b', label: 'Beta'),
              ),
              const SizedBox(
                width: 100,
                child: RemixTab(tabId: 'c', label: 'Gamma'),
              ),
            ],
          ),
        ),
        const RemixTabView(tabId: 'a', child: Text('Content a')),
        const RemixTabView(tabId: 'b', child: Text('Content b')),
        const RemixTabView(tabId: 'c', child: Text('Content c')),
      ],
    ),
  );
}

Rect _tabRect(WidgetTester tester, String label) => tester.getRect(
  find.ancestor(of: find.text(label), matching: find.byType(SizedBox)).first,
);

void _expectRectNear(Rect actual, Rect expected) {
  expect(actual.left, closeTo(expected.left, .01));
  expect(actual.top, closeTo(expected.top, .01));
  expect(actual.width, closeTo(expected.width, .01));
  expect(actual.height, closeTo(expected.height, .01));
}

void main() {
  group('RemixTabIndicatorMotion', () {
    test('has value equality and curve defaults', () {
      expect(const RemixTabIndicatorMotion(), const RemixTabIndicatorMotion());
      expect(
        const RemixTabIndicatorMotion().duration,
        const Duration(milliseconds: 250),
      );
      expect(const RemixTabIndicatorMotion().spring, isNull);
      const spring = SpringDescription(mass: 1, stiffness: 300, damping: 30);
      expect(
        const RemixTabIndicatorMotion.spring(spring),
        const RemixTabIndicatorMotion.spring(spring),
      );
      expect(
        const RemixTabIndicatorMotion.spring(spring),
        isNot(const RemixTabIndicatorMotion()),
      );
    });

    test('TabBarSpec carries the indicator and its motion', () {
      expect(const TabBarSpec().indicator, isNull);
      expect(const TabBarSpec().indicatorMotion, isNull);
      const motion = RemixTabIndicatorMotion();
      final spec = TabBarSpec(
        indicator: StyleSpec(spec: const BoxSpec()),
        indicatorMotion: motion,
      );
      expect(spec.indicator, isNotNull);
      expect(spec.indicatorMotion, motion);
    });
  });

  group('RemixTabBar indicator', () {
    testWidgets('sits on the selected tab, behind its label', (tester) async {
      await tester.pumpRemixApp(_tabs(selected: 'b', onChanged: (_) {}));
      await tester.pump();

      expect(_indicator, findsOneWidget);
      expect(tester.getRect(_indicator), _tabRect(tester, 'Beta'));
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
              motion: const RemixTabIndicatorMotion(
                duration: Duration(milliseconds: 400),
                curve: Curves.linear,
              ),
              onChanged: (id) => setState(() => selected = id),
            );
          },
        ),
      );
      final start = tester.getRect(_indicator);
      expect(start, _tabRect(tester, 'Alpha'));

      set(() => selected = 'c');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1));
      final first = tester.getRect(_indicator);
      expect(first.left, closeTo(start.left, 1));

      await tester.pump(const Duration(milliseconds: 200));
      final mid = tester.getRect(_indicator);
      final end = _tabRect(tester, 'Gamma');
      expect(mid.left, greaterThan(start.left + 1));
      expect(mid.left, lessThan(end.left - 1));
      expect(mid.width, greaterThan(start.width));
      expect(mid.width, lessThan(end.width));

      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.getRect(_indicator), end);
    });

    testWidgets('a spring moves it too', (tester) async {
      var selected = 'a';
      late StateSetter set;
      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            set = setState;
            return _tabs(
              selected: selected,
              motion: const RemixTabIndicatorMotion.spring(
                SpringDescription(mass: 1, stiffness: 400, damping: 40),
              ),
              onChanged: (_) {},
            );
          },
        ),
      );

      set(() => selected = 'b');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 60));
      final mid = tester.getRect(_indicator);
      expect(mid.left, greaterThan(_tabRect(tester, 'Alpha').left));

      await tester.pumpAndSettle();
      _expectRectNear(tester.getRect(_indicator), _tabRect(tester, 'Beta'));
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

      expect(tester.getRect(_indicator), _tabRect(tester, 'Gamma'));
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
      final before = tester.getRect(_indicator);

      set(() => width = 160);
      await tester.pump();
      await tester.pump();

      final after = tester.getRect(_indicator);
      expect(after, _tabRect(tester, 'Beta'));
      expect(after.left, isNot(before.left));
    });

    testWidgets('hides when the selected tab does not exist', (tester) async {
      await tester.pumpRemixApp(_tabs(selected: 'zzz', onChanged: (_) {}));
      await tester.pump();

      expect(tester.getSize(_indicator), Size.zero);
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

    testWidgets('no indicator by default: nothing extra is built', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        _tabs(selected: 'a', onChanged: (_) {}, withIndicator: false),
      );

      expect(_indicator, findsNothing);
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
}
