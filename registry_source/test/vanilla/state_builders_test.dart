import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/vanilla.dart';
import 'package:remix/remix.dart';

import 'support.dart';

// The generated adapters forward the Naked UI builders and formatters that
// `package:remix` re-exports.
void main() {
  Future<void> pump(WidgetTester tester, Widget child) async {
    await tester.pumpWidget(VanillaTheme(child: hostOf(Center(child: child))));
    await tester.pumpAndSettle();
  }

  testWidgets('VanillaAccordion builds its trigger from the item state', (
    tester,
  ) async {
    await pump(
      tester,
      RemixAccordionGroup<String>(
        controller: RemixAccordionController<String>(),
        child: VanillaAccordion<String>(
          value: 'shipping',
          title: 'Shipping',
          builder: (context, state) =>
              Text(state.isExpanded ? 'Hide shipping' : 'Show shipping'),
          child: const Text('Two to four business days.'),
        ),
      ),
    );

    await tester.tap(find.text('Show shipping'));
    await tester.pumpAndSettle();

    expect(find.text('Hide shipping'), findsOneWidget);
    expect(find.text('Two to four business days.'), findsOneWidget);
  });

  testWidgets('VanillaDisclosure builds its trigger from the expanded state', (
    tester,
  ) async {
    await pump(
      tester,
      VanillaDisclosure(
        trigger: const Text('Details'),
        content: const Text('Three packages'),
        triggerBuilder: (context, state, child) =>
            Text(state.isExpanded ? 'Hide details' : 'Show details'),
      ),
    );

    await tester.tap(find.text('Show details'));
    await tester.pumpAndSettle();

    expect(find.text('Hide details'), findsOneWidget);
    expect(find.text('Three packages'), findsOneWidget);
  });

  testWidgets('VanillaTab builds its content from the tab state', (
    tester,
  ) async {
    await pump(
      tester,
      RemixTabs(
        selectedTabId: 'account',
        onChanged: (_) {},
        child: VanillaTabBar(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final id in ['account', 'billing'])
                VanillaTab(
                  tabId: id,
                  builder: (context, state, child) =>
                      Text('$id ${state.isSelected ? 'current' : 'other'}'),
                ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('account current'), findsOneWidget);
    expect(find.text('billing other'), findsOneWidget);
  });

  testWidgets('VanillaSlider announces the formatted value', (tester) async {
    final semantics = tester.ensureSemantics();
    await pump(
      tester,
      SizedBox(
        width: 240,
        child: VanillaSlider(
          value: 0.5,
          onChanged: (_) {},
          semanticLabel: 'Volume',
          semanticFormatterCallback: (value) => '${(value * 100).round()}%',
        ),
      ),
    );

    expect(tester.getSemantics(find.bySemanticsLabel('Volume')).value, '50%');
    semantics.dispose();
  });

  testWidgets('VanillaRangeSlider announces each formatted bound', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pump(
      tester,
      SizedBox(
        width: 240,
        child: VanillaRangeSlider(
          values: const [0.25, 0.75],
          onChanged: (_) {},
          semanticLabels: const ['Minimum', 'Maximum'],
          semanticFormatterCallbacks: [
            (value) => 'From ${(value * 100).round()}%',
            (value) => 'To ${(value * 100).round()}%',
          ],
        ),
      ),
    );

    expect(
      tester.getSemantics(find.bySemanticsLabel('Minimum')).value,
      'From 25%',
    );
    expect(
      tester.getSemantics(find.bySemanticsLabel('Maximum')).value,
      'To 75%',
    );
    semantics.dispose();
  });
}
