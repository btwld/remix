import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('Fortal widgets', () {
    test('named constructors pin variants and infer generic types', () {
      const button = FortalButton.soft(label: 'Save');
      const accordion = FortalAccordion.soft(value: 'item', child: SizedBox());
      const radio = FortalRadio.soft(value: 'option');
      const menu = FortalMenu.soft(
        trigger: RemixMenuTrigger(label: 'Menu'),
        items: [RemixMenuItem(value: 'a', label: 'A')],
      );
      const select = FortalSelect.ghost(
        trigger: RemixSelectTrigger(placeholder: 'Pick'),
        items: [RemixSelectItem(value: 'a', label: 'A')],
      );

      expect(button.variant, FortalButtonVariant.soft);
      expect(accordion, isA<FortalAccordion<String>>());
      expect(accordion.variant, FortalAccordionVariant.soft);
      expect(radio, isA<FortalRadio<String>>());
      expect(radio.variant, FortalRadioVariant.soft);
      expect(menu, isA<FortalMenu<String>>());
      expect(menu.variant, FortalMenuVariant.soft);
      expect(select, isA<FortalSelect<String>>());
      expect(select.variant, FortalSelectVariant.ghost);
    });

    testWidgets('renders FortalAccordion', (tester) async {
      await tester.pumpRemixApp(
        RemixAccordionGroup<String>(
          controller: RemixAccordionController<String>(),
          child: const FortalAccordion<String>(
            value: 'item',
            color: .red,
            radius: .small,
            title: 'Item',
            child: Text('Content'),
          ),
        ),
      );

      expect(find.byType(FortalAccordion<String>), findsOneWidget);
      expect(find.byType(RemixAccordion<String>), findsOneWidget);
      _expectFortalOverride(tester, find.byType(RemixAccordion<String>));
    });

    testWidgets('renders FortalAvatar', (tester) async {
      await tester.pumpRemixApp(
        const FortalAvatar(color: .red, radius: .small, label: 'LF'),
      );

      expect(find.byType(FortalAvatar), findsOneWidget);
      expect(find.byType(RemixAvatar), findsOneWidget);
      _expectFortalOverride(tester, find.byType(RemixAvatar));
    });

    testWidgets('renders FortalBadge', (tester) async {
      await tester.pumpRemixApp(
        const FortalBadge(
          color: .red,
          radius: .small,
          highContrast: true,
          label: 'New',
        ),
      );

      expect(find.byType(FortalBadge), findsOneWidget);
      expect(find.byType(RemixBadge), findsOneWidget);
      _expectFortalOverride(tester, find.byType(RemixBadge));
    });

    testWidgets('renders FortalButton', (tester) async {
      await tester.pumpRemixApp(
        const FortalButton(
          color: .red,
          radius: .small,
          highContrast: true,
          label: 'Save',
        ),
      );

      expect(find.byType(FortalButton), findsOneWidget);
      expect(find.byType(RemixButton), findsOneWidget);
      _expectFortalOverride(tester, find.byType(RemixButton));
    });

    testWidgets('renders FortalCard', (tester) async {
      await tester.pumpRemixApp(
        const FortalCard(
          color: .red,
          radius: .small,
          child: SizedBox(width: 24, height: 24),
        ),
      );

      expect(find.byType(FortalCard), findsOneWidget);
      expect(find.byType(RemixCard), findsOneWidget);
      _expectFortalOverride(tester, find.byType(RemixCard));
    });

    testWidgets('renders FortalCallout', (tester) async {
      await tester.pumpRemixApp(
        const FortalCallout(
          color: .red,
          radius: .small,
          highContrast: true,
          text: 'Heads up',
        ),
      );

      expect(find.byType(FortalCallout), findsOneWidget);
      expect(find.byType(RemixCallout), findsOneWidget);
      _expectFortalOverride(tester, find.byType(RemixCallout));
    });

    testWidgets('renders FortalCheckbox', (tester) async {
      await tester.pumpRemixApp(
        const FortalCheckbox(
          color: .red,
          radius: .small,
          highContrast: true,
          selected: true,
        ),
      );

      expect(find.byType(FortalCheckbox), findsOneWidget);
      expect(find.byType(RemixCheckbox), findsOneWidget);
      _expectFortalOverride(tester, find.byType(RemixCheckbox));
    });

    testWidgets('renders FortalDivider', (tester) async {
      await tester.pumpRemixApp(const FortalDivider(color: .red));

      expect(find.byType(FortalDivider), findsOneWidget);
      expect(find.byType(RemixDivider), findsOneWidget);
      _expectFortalOverride(
        tester,
        find.byType(RemixDivider),
        expectsRadius: false,
      );

      final divider = tester.widget<Box>(
        find.descendant(
          of: find.byType(RemixDivider),
          matching: find.byType(Box),
        ),
      );
      final decoration = divider.styleSpec!.spec.decoration as BoxDecoration;
      expect(decoration.color, red.light.scale.alphaStep(6));
    });

    testWidgets('renders FortalIconButton', (tester) async {
      await tester.pumpRemixApp(
        const FortalIconButton(
          color: .red,
          radius: .small,
          highContrast: true,
          icon: Icons.add,
        ),
      );

      expect(find.byType(FortalIconButton), findsOneWidget);
      expect(find.byType(RemixIconButton), findsOneWidget);
      _expectFortalOverride(tester, find.byType(RemixIconButton));
    });

    testWidgets('renders FortalProgress', (tester) async {
      await tester.pumpRemixApp(
        const FortalProgress(
          color: .red,
          radius: .small,
          highContrast: true,
          value: 0.5,
        ),
      );

      expect(find.byType(FortalProgress), findsOneWidget);
      expect(find.byType(RemixProgress), findsOneWidget);
      _expectFortalOverride(tester, find.byType(RemixProgress));
    });

    testWidgets('renders FortalRadio', (tester) async {
      await tester.pumpRemixApp(
        const RemixRadioGroup<String>(
          groupValue: 'option',
          child: FortalRadio<String>(
            color: .red,
            highContrast: true,
            value: 'option',
          ),
        ),
      );

      expect(find.byType(FortalRadio<String>), findsOneWidget);
      expect(find.byType(RemixRadio<String>), findsOneWidget);
      _expectFortalOverride(
        tester,
        find.byType(RemixRadio<String>),
        expectsRadius: false,
      );
    });

    testWidgets('renders FortalSlider', (tester) async {
      await tester.pumpRemixApp(
        const FortalSlider(
          color: .red,
          radius: .small,
          highContrast: true,
          value: 0.5,
        ),
      );

      expect(find.byType(FortalSlider), findsOneWidget);
      expect(find.byType(RemixSlider), findsOneWidget);
      _expectFortalOverride(tester, find.byType(RemixSlider));
    });

    testWidgets('renders FortalSpinner', (tester) async {
      await tester.pumpRemixApp(const FortalSpinner(color: .red));

      expect(find.byType(FortalSpinner), findsOneWidget);
      expect(find.byType(RemixSpinner), findsOneWidget);
      _expectFortalOverride(
        tester,
        find.byType(RemixSpinner),
        expectsRadius: false,
      );
    });

    testWidgets('renders FortalSwitch', (tester) async {
      await tester.pumpRemixApp(
        const FortalSwitch(
          color: .red,
          radius: .small,
          highContrast: true,
          selected: true,
        ),
      );

      expect(find.byType(FortalSwitch), findsOneWidget);
      expect(find.byType(RemixSwitch), findsOneWidget);
      _expectFortalOverride(tester, find.byType(RemixSwitch));
    });

    testWidgets('renders FortalTextField', (tester) async {
      await tester.pumpRemixApp(
        const FortalTextField(color: .red, radius: .small, hintText: 'Email'),
      );

      expect(find.byType(FortalTextField), findsOneWidget);
      expect(find.byType(RemixTextField), findsOneWidget);
      _expectFortalOverride(tester, find.byType(RemixTextField));
    });

    testWidgets('renders FortalToggle', (tester) async {
      await tester.pumpRemixApp(
        const FortalToggle(
          color: .red,
          radius: .small,
          highContrast: true,
          selected: true,
          label: 'Bold',
        ),
      );

      expect(find.byType(FortalToggle), findsOneWidget);
      expect(find.byType(RemixToggle), findsOneWidget);
      _expectFortalOverride(tester, find.byType(RemixToggle));
    });

    testWidgets('renders FortalToggleGroup', (tester) async {
      await tester.pumpRemixApp(
        FortalToggleGroup<String>(
          color: .red,
          radius: .small,
          highContrast: true,
          selectedValue: 'a',
          onChanged: (_) {},
          items: const [
            RemixToggleGroupItem(value: 'a', label: 'A'),
            RemixToggleGroupItem(value: 'b', label: 'B'),
          ],
        ),
      );

      expect(find.byType(FortalToggleGroup<String>), findsOneWidget);
      expect(find.byType(RemixToggleGroup<String>), findsOneWidget);
      _expectFortalOverride(tester, find.byType(RemixToggleGroup<String>));
    });

    testWidgets('renders FortalDialog', (tester) async {
      await tester.pumpRemixApp(
        const FortalDialog(color: .red, radius: .small, title: 'Hello'),
      );
      expect(find.byType(FortalDialog), findsOneWidget);
      expect(find.byType(RemixDialog), findsOneWidget);
      _expectFortalOverride(tester, find.byType(RemixDialog));
    });

    testWidgets('renders FortalTooltip', (tester) async {
      await tester.pumpRemixApp(
        const FortalTooltip(
          color: .red,
          radius: .small,
          tooltipChild: Text('tip'),
          child: Text('target'),
        ),
      );
      expect(find.byType(FortalTooltip), findsOneWidget);
      expect(find.byType(RemixTooltip), findsOneWidget);
      _expectFortalOverride(tester, find.byType(RemixTooltip));
    });

    testWidgets('renders FortalMenu', (tester) async {
      await tester.pumpRemixApp(
        FortalMenu<String>(
          color: .red,
          radius: .small,
          trigger: const RemixMenuTrigger(label: 'Menu'),
          items: const [RemixMenuItem(value: 'a', label: 'A')],
        ),
      );
      expect(find.byType(FortalMenu<String>), findsOneWidget);
      expect(find.byType(RemixMenu<String>), findsOneWidget);
      _expectFortalOverride(tester, find.byType(RemixMenu<String>));
    });

    testWidgets('renders FortalSelect', (tester) async {
      await tester.pumpRemixApp(
        FortalSelect<String>(
          color: .red,
          radius: .small,
          highContrast: true,
          trigger: const RemixSelectTrigger(placeholder: 'Pick'),
          items: const [RemixSelectItem(value: 'a', label: 'A')],
        ),
      );
      expect(find.byType(FortalSelect<String>), findsOneWidget);
      expect(find.byType(RemixSelect<String>), findsOneWidget);
      _expectFortalOverride(tester, find.byType(RemixSelect<String>));
    });

    testWidgets('renders FortalTabBar/Tab/TabView', (tester) async {
      await tester.pumpRemixApp(
        RemixTabs(
          selectedTabId: 'a',
          onChanged: (_) {},
          child: Column(
            children: [
              FortalTabBar(
                color: .red,
                radius: .small,
                child: Row(
                  children: const [
                    FortalTab(
                      color: .red,
                      radius: .small,
                      highContrast: true,
                      tabId: 'a',
                      label: 'A',
                    ),
                    FortalTab(
                      color: .red,
                      radius: .small,
                      highContrast: true,
                      tabId: 'b',
                      label: 'B',
                    ),
                  ],
                ),
              ),
              const FortalTabView(
                color: .red,
                radius: .small,
                tabId: 'a',
                child: Text('A view'),
              ),
              const FortalTabView(
                color: .red,
                radius: .small,
                tabId: 'b',
                child: Text('B view'),
              ),
            ],
          ),
        ),
      );
      expect(find.byType(FortalTabBar), findsOneWidget);
      expect(find.byType(FortalTab), findsNWidgets(2));
      expect(find.byType(FortalTabView), findsNWidgets(2));
      _expectFortalOverride(tester, find.byType(RemixTabBar));
      _expectFortalOverride(tester, find.byType(RemixTab).first);
      _expectFortalOverride(tester, find.byType(RemixTabView).first);
    });
  });
}

void _expectFortalOverride(
  WidgetTester tester,
  Finder finder, {
  bool expectsRadius = true,
}) {
  final context = tester.element(finder);

  expect(
    MixScope.tokenOf(FortalTokens.accent9, context),
    red.light.scale.step(9),
  );
  if (expectsRadius) {
    expect(
      MixScope.tokenOf(FortalTokens.radius3, context),
      const Radius.circular(4.5),
    );
  }
}
