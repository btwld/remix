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
            title: 'Item',
            child: Text('Content'),
          ),
        ),
      );

      expect(find.byType(FortalAccordion<String>), findsOneWidget);
      expect(find.byType(RemixAccordion<String>), findsOneWidget);
    });

    testWidgets('renders FortalAvatar', (tester) async {
      await tester.pumpRemixApp(const FortalAvatar(label: 'LF'));

      expect(find.byType(FortalAvatar), findsOneWidget);
      expect(find.byType(RemixAvatar), findsOneWidget);
    });

    testWidgets('renders FortalBadge', (tester) async {
      await tester.pumpRemixApp(const FortalBadge(label: 'New'));

      expect(find.byType(FortalBadge), findsOneWidget);
      expect(find.byType(RemixBadge), findsOneWidget);
    });

    testWidgets('renders FortalButton', (tester) async {
      await tester.pumpRemixApp(const FortalButton(label: 'Save'));

      expect(find.byType(FortalButton), findsOneWidget);
      expect(find.byType(RemixButton), findsOneWidget);
    });

    testWidgets('renders FortalCard', (tester) async {
      await tester.pumpRemixApp(
        const FortalCard(child: SizedBox(width: 24, height: 24)),
      );

      expect(find.byType(FortalCard), findsOneWidget);
      expect(find.byType(RemixCard), findsOneWidget);
    });

    testWidgets('renders FortalCallout', (tester) async {
      await tester.pumpRemixApp(const FortalCallout(text: 'Heads up'));

      expect(find.byType(FortalCallout), findsOneWidget);
      expect(find.byType(RemixCallout), findsOneWidget);
    });

    testWidgets('renders FortalCheckbox', (tester) async {
      await tester.pumpRemixApp(const FortalCheckbox(selected: true));

      expect(find.byType(FortalCheckbox), findsOneWidget);
      expect(find.byType(RemixCheckbox), findsOneWidget);
    });

    testWidgets('renders FortalDivider', (tester) async {
      await tester.pumpRemixApp(const FortalDivider());

      expect(find.byType(FortalDivider), findsOneWidget);
      expect(find.byType(RemixDivider), findsOneWidget);
    });

    testWidgets('renders FortalIconButton', (tester) async {
      await tester.pumpRemixApp(const FortalIconButton(icon: Icons.add));

      expect(find.byType(FortalIconButton), findsOneWidget);
      expect(find.byType(RemixIconButton), findsOneWidget);
    });

    testWidgets('renders FortalProgress', (tester) async {
      await tester.pumpRemixApp(const FortalProgress(value: 0.5));

      expect(find.byType(FortalProgress), findsOneWidget);
      expect(find.byType(RemixProgress), findsOneWidget);
    });

    testWidgets('renders FortalRadio', (tester) async {
      await tester.pumpRemixApp(
        const RemixRadioGroup<String>(
          groupValue: 'option',
          child: FortalRadio<String>(value: 'option'),
        ),
      );

      expect(find.byType(FortalRadio<String>), findsOneWidget);
      expect(find.byType(RemixRadio<String>), findsOneWidget);
    });

    testWidgets('renders FortalSlider', (tester) async {
      await tester.pumpRemixApp(const FortalSlider(value: 0.5));

      expect(find.byType(FortalSlider), findsOneWidget);
      expect(find.byType(RemixSlider), findsOneWidget);
    });

    testWidgets('renders FortalSpinner', (tester) async {
      await tester.pumpRemixApp(const FortalSpinner());

      expect(find.byType(FortalSpinner), findsOneWidget);
      expect(find.byType(RemixSpinner), findsOneWidget);
    });

    testWidgets('renders FortalSwitch', (tester) async {
      await tester.pumpRemixApp(const FortalSwitch(selected: true));

      expect(find.byType(FortalSwitch), findsOneWidget);
      expect(find.byType(RemixSwitch), findsOneWidget);
    });

    testWidgets('renders FortalTextField', (tester) async {
      await tester.pumpRemixApp(const FortalTextField(hintText: 'Email'));

      expect(find.byType(FortalTextField), findsOneWidget);
      expect(find.byType(RemixTextField), findsOneWidget);
    });

    testWidgets('renders FortalToggle', (tester) async {
      await tester.pumpRemixApp(
        const FortalToggle(selected: true, label: 'Bold'),
      );

      expect(find.byType(FortalToggle), findsOneWidget);
      expect(find.byType(RemixToggle), findsOneWidget);
    });

    testWidgets('renders FortalDialog', (tester) async {
      await tester.pumpRemixApp(const FortalDialog(title: 'Hello'));
      expect(find.byType(FortalDialog), findsOneWidget);
      expect(find.byType(RemixDialog), findsOneWidget);
    });

    testWidgets('renders FortalTooltip', (tester) async {
      await tester.pumpRemixApp(
        const FortalTooltip(tooltipChild: Text('tip'), child: Text('target')),
      );
      expect(find.byType(FortalTooltip), findsOneWidget);
      expect(find.byType(RemixTooltip), findsOneWidget);
    });

    testWidgets('renders FortalMenu', (tester) async {
      await tester.pumpRemixApp(
        FortalMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Menu'),
          items: const [RemixMenuItem(value: 'a', label: 'A')],
        ),
      );
      expect(find.byType(FortalMenu<String>), findsOneWidget);
      expect(find.byType(RemixMenu<String>), findsOneWidget);
    });

    testWidgets('renders FortalSelect', (tester) async {
      await tester.pumpRemixApp(
        FortalSelect<String>(
          trigger: const RemixSelectTrigger(placeholder: 'Pick'),
          items: const [RemixSelectItem(value: 'a', label: 'A')],
        ),
      );
      expect(find.byType(FortalSelect<String>), findsOneWidget);
      expect(find.byType(RemixSelect<String>), findsOneWidget);
    });

    testWidgets('renders FortalTabBar/Tab/TabView', (tester) async {
      await tester.pumpRemixApp(
        RemixTabs(
          selectedTabId: 'a',
          onChanged: (_) {},
          child: Column(
            children: [
              FortalTabBar(
                child: Row(
                  children: const [
                    FortalTab(tabId: 'a', label: 'A'),
                    FortalTab(tabId: 'b', label: 'B'),
                  ],
                ),
              ),
              const FortalTabView(tabId: 'a', child: Text('A view')),
              const FortalTabView(tabId: 'b', child: Text('B view')),
            ],
          ),
        ),
      );
      expect(find.byType(FortalTabBar), findsOneWidget);
      expect(find.byType(FortalTab), findsNWidgets(2));
      expect(find.byType(FortalTabView), findsNWidgets(2));
    });
  });
}
