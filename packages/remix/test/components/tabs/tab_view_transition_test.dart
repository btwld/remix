import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

typedef _Call = ({String view, AnimationStatus status, int direction});

class _Harness extends StatefulWidget {
  const _Harness({
    required this.calls,
    this.withBuilder = true,
    this.orientation = Axis.horizontal,
    this.animationStyle,
  });

  final List<_Call> calls;
  final bool withBuilder;
  final Axis orientation;
  final AnimationStyle? animationStyle;

  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness> {
  String selected = 'a';

  void select(String id) => setState(() => selected = id);

  RemixTabView _view(String id) {
    final style = widget.animationStyle;
    Widget builder(
      BuildContext context,
      Animation<double> animation,
      int direction,
      Widget child,
    ) {
      widget.calls.add((
        view: id,
        status: animation.status,
        direction: direction,
      ));

      return FadeTransition(opacity: animation, child: child);
    }

    return style == null
        ? RemixTabView(
            tabId: id,
            transitionBuilder: widget.withBuilder ? builder : null,
            child: Text('View $id'),
          )
        : RemixTabView(
            tabId: id,
            transitionBuilder: builder,
            animationStyle: style,
            child: Text('View $id'),
          );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      const RemixTab(tabId: 'a', label: 'Tab a'),
      const RemixTab(tabId: 'b', label: 'Tab b'),
      const RemixTab(tabId: 'c', label: 'Tab c'),
    ];

    return RemixTabs(
      selectedTabId: selected,
      onChanged: select,
      orientation: widget.orientation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RemixTabBar(
            child: widget.orientation == Axis.horizontal
                ? Row(mainAxisSize: MainAxisSize.min, children: tabs)
                : Column(mainAxisSize: MainAxisSize.min, children: tabs),
          ),
          _view('a'),
          _view('b'),
          _view('c'),
        ],
      ),
    );
  }
}

void main() {
  _HarnessState harness(WidgetTester tester) =>
      tester.state<_HarnessState>(find.byType(_Harness));

  double opacityOf(WidgetTester tester, String label) {
    final fade = tester.widget<FadeTransition>(
      find
          .ancestor(of: find.text(label), matching: find.byType(FadeTransition))
          .first,
    );

    return fade.opacity.value;
  }

  Set<int> directionsSince(List<_Call> calls, int start) =>
      calls.skip(start).map((call) => call.direction).toSet();

  testWidgets('without a transition builder views swap at once', (
    tester,
  ) async {
    await tester.pumpRemixApp(_Harness(calls: [], withBuilder: false));

    harness(tester).select('b');
    await tester.pump();

    expect(find.text('View a'), findsNothing);
    expect(find.text('View b'), findsOneWidget);
  });

  testWidgets('the old view fades out while the new one fades in', (
    tester,
  ) async {
    final calls = <_Call>[];
    await tester.pumpRemixApp(_Harness(calls: calls));
    expect(opacityOf(tester, 'View a'), 1);

    harness(tester).select('b');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(opacityOf(tester, 'View a'), inExclusiveRange(0, 1));
    expect(opacityOf(tester, 'View b'), inExclusiveRange(0, 1));
    expect(
      calls.map((call) => (call.view, call.status)),
      containsAll([
        ('a', AnimationStatus.reverse),
        ('b', AnimationStatus.forward),
      ]),
    );

    await tester.pumpAndSettle();
    expect(find.text('View a'), findsNothing);
    expect(opacityOf(tester, 'View b'), 1);
  });

  testWidgets('direction follows where the selected tab sits', (tester) async {
    final calls = <_Call>[];
    await tester.pumpRemixApp(_Harness(calls: calls));
    expect(directionsSince(calls, 0), {0});

    var start = calls.length;
    harness(tester).select('c');
    await tester.pumpAndSettle();
    expect(directionsSince(calls, start), {1});

    start = calls.length;
    harness(tester).select('b');
    await tester.pumpAndSettle();
    expect(directionsSince(calls, start), {-1});
  });

  testWidgets('direction is physical in right-to-left layouts', (tester) async {
    final calls = <_Call>[];
    await tester.pumpRemixApp(
      _Harness(calls: calls),
      textDirection: TextDirection.rtl,
    );

    final start = calls.length;
    harness(tester).select('b');
    await tester.pumpAndSettle();

    // Tab b sits left of tab a in a right-to-left row.
    expect(directionsSince(calls, start), {-1});
  });

  testWidgets('direction follows the vertical axis', (tester) async {
    final calls = <_Call>[];
    await tester.pumpRemixApp(
      _Harness(calls: calls, orientation: Axis.vertical),
    );

    var start = calls.length;
    harness(tester).select('b');
    await tester.pumpAndSettle();
    expect(directionsSince(calls, start), {1});

    start = calls.length;
    harness(tester).select('a');
    await tester.pumpAndSettle();
    expect(directionsSince(calls, start), {-1});
  });

  testWidgets('animationStyle sets the transition timing', (tester) async {
    await tester.pumpRemixApp(
      _Harness(
        calls: [],
        animationStyle: const AnimationStyle(
          curve: Curves.linear,
          duration: Duration(milliseconds: 1000),
          reverseDuration: Duration(milliseconds: 400),
        ),
      ),
    );

    harness(tester).select('b');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(opacityOf(tester, 'View b'), moreOrLessEquals(0.2, epsilon: 0.02));
    expect(opacityOf(tester, 'View a'), moreOrLessEquals(0.5, epsilon: 0.02));

    await tester.pump(const Duration(milliseconds: 201));
    expect(find.text('View a'), findsNothing);
  });
}
