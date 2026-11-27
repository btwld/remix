import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

import '../test_helpers.dart';

Widget _fade(BuildContext context, Animation<double> animation, Widget child) {
  return FadeTransition(opacity: animation, child: child);
}

class _Counter extends StatefulWidget {
  const _Counter(this.label);

  final String label;

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 40, child: Text(widget.label));
  }
}

class _Harness extends StatefulWidget {
  const _Harness({this.transitionBuilder, this.disableAnimations = false});

  final NakedTabViewTransitionBuilder? transitionBuilder;
  final bool disableAnimations;

  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness> {
  String selected = 'a';

  void select(String id) => setState(() => selected = id);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(disableAnimations: widget.disableAnimations),
      child: NakedTabs(
        selectedTabId: selected,
        onChanged: select,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const NakedTabBar(
              child: Row(
                children: [
                  NakedTab(tabId: 'a', child: Text('Tab A')),
                  NakedTab(tabId: 'b', child: Text('Tab B')),
                ],
              ),
            ),
            NakedTabView(
              tabId: 'a',
              transitionBuilder: widget.transitionBuilder,
              child: const _Counter('View A'),
            ),
            const SizedBox(height: 12),
            NakedTabView(
              tabId: 'b',
              transitionBuilder: widget.transitionBuilder,
              child: const _Counter('View B'),
            ),
          ],
        ),
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

  testWidgets('without a transition builder the old view hides at once', (
    tester,
  ) async {
    await tester.pumpMaterialWidget(const _Harness());

    harness(tester).select('b');
    await tester.pump();

    expect(find.text('View A'), findsNothing);
    expect(find.text('View B'), findsOneWidget);
  });

  testWidgets('the first build shows the selected view without animating', (
    tester,
  ) async {
    await tester.pumpMaterialWidget(const _Harness(transitionBuilder: _fade));

    expect(opacityOf(tester, 'View A'), 1);
    expect(find.text('View B'), findsNothing);
  });

  testWidgets('the leaving view stays painted where it sat, out of layout', (
    tester,
  ) async {
    await tester.pumpMaterialWidget(const _Harness(transitionBuilder: _fade));
    final restingTopLeft = tester.getTopLeft(find.text('View A'));

    harness(tester).select('b');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('View A'), findsOneWidget);
    expect(opacityOf(tester, 'View A'), inExclusiveRange(0, 1));
    expect(opacityOf(tester, 'View B'), inExclusiveRange(0, 1));
    expect(tester.getTopLeft(find.text('View A')), restingTopLeft);
    // View A takes no space, so View B sits right below the 12px gap.
    expect(
      tester.getTopLeft(find.text('View B')),
      restingTopLeft + const Offset(0, 12),
    );
    expect(find.text('View A').hitTestable(), findsNothing);

    await tester.pumpAndSettle();
    expect(find.text('View A'), findsNothing);
    expect(opacityOf(tester, 'View B'), 1);
  });

  testWidgets('a view after the selected one leaves from its own place', (
    tester,
  ) async {
    await tester.pumpMaterialWidget(const _Harness(transitionBuilder: _fade));
    harness(tester).select('b');
    await tester.pumpAndSettle();
    final restingTopLeft = tester.getTopLeft(find.text('View B'));

    harness(tester).select('a');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(tester.getTopLeft(find.text('View B')), restingTopLeft);
    expect(
      tester.getTopLeft(find.text('View A')),
      restingTopLeft - const Offset(0, 12),
    );
  });

  testWidgets('the leaving view is hidden from semantics and focus', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpMaterialWidget(const _Harness(transitionBuilder: _fade));

    harness(tester).select('b');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.semantics.byLabel('View A'), findsNothing);
    expect(find.semantics.byLabel('View B'), findsOne);
    final focusScope = tester.widget<Focus>(
      find
          .ancestor(of: find.text('View A'), matching: find.byType(Focus))
          .first,
    );
    expect(focusScope.canRequestFocus, isFalse);
    semantics.dispose();
  });

  testWidgets('reselecting mid-exit reverses the same view', (tester) async {
    await tester.pumpMaterialWidget(const _Harness(transitionBuilder: _fade));
    final state = tester.state(find.byType(_Counter).first);

    harness(tester).select('b');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    final midway = opacityOf(tester, 'View A');

    harness(tester).select('a');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 16));

    expect(opacityOf(tester, 'View A'), greaterThan(midway));
    expect(tester.state(find.byType(_Counter).first), same(state));
  });

  testWidgets('reduced motion swaps views at once', (tester) async {
    await tester.pumpMaterialWidget(
      const _Harness(transitionBuilder: _fade, disableAnimations: true),
    );

    harness(tester).select('b');
    await tester.pump();

    expect(find.text('View A'), findsNothing);
    expect(opacityOf(tester, 'View B'), 1);
  });
}
