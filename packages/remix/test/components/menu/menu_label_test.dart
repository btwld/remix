import 'dart:ui'
    show PointerDeviceKind, SemanticsAction, SemanticsRole, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

double? _fontSize(WidgetTester tester, String text) => tester
    .widget<RichText>(
      find.descendant(of: find.text(text), matching: find.byType(RichText)),
    )
    .text
    .style
    ?.fontSize;

Color? _color(WidgetTester tester, String text) => tester
    .widget<RichText>(
      find.descendant(of: find.text(text), matching: find.byType(RichText)),
    )
    .text
    .style
    ?.color;

bool _hasFocus(WidgetTester tester, String text) =>
    Focus.of(tester.element(find.text(text))).hasPrimaryFocus;

Future<void> _open(WidgetTester tester) async {
  await tester.tap(find.text('Options'));
  await tester.pumpAndSettle();
}

void main() {
  group('RemixMenuLabel', () {
    test('rejects an empty label', () {
      expect(
        () => RemixMenuLabel<String>(label: ''),
        throwsA(isA<AssertionError>()),
      );
    });

    testWidgets('renders its text and does not select or close the menu', (
      tester,
    ) async {
      final selected = <String>[];
      await tester.pumpRemixApp(
        RemixMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          onSelected: selected.add,
          items: const [
            RemixMenuLabel(label: 'Workspaces'),
            RemixMenuItem(value: 'alpha', label: 'Alpha'),
          ],
        ),
      );
      await _open(tester);

      expect(find.text('Workspaces'), findsOneWidget);
      await tester.tap(find.text('Workspaces'));
      await tester.pumpAndSettle();

      expect(selected, isEmpty);
      expect(find.text('Workspaces'), findsOneWidget);
      expect(find.text('Alpha'), findsOneWidget);
    });

    testWidgets('keyboard navigation moves past a label', (tester) async {
      await tester.pumpRemixApp(
        RemixMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          onSelected: (_) {},
          items: const [
            RemixMenuLabel(label: 'Recent'),
            RemixMenuItem(value: 'alpha', label: 'Alpha'),
            RemixMenuLabel(label: 'Shared'),
            RemixMenuItem(value: 'beta', label: 'Beta'),
          ],
        ),
      );
      await _open(tester);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(_hasFocus(tester, 'Alpha'), isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(_hasFocus(tester, 'Beta'), isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pump();
      expect(_hasFocus(tester, 'Alpha'), isTrue);
    });

    testWidgets('is plain text to assistive technology, not a menu item', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpRemixApp(
        RemixMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          onSelected: (_) {},
          items: [
            const RemixMenuLabel(label: 'Density'),
            RemixMenuRadioGroup(
              value: 'compact',
              onChanged: (_) {},
              items: const [
                RemixMenuRadioItem(value: 'compact', label: 'Compact'),
                RemixMenuRadioItem(value: 'comfortable', label: 'Comfortable'),
              ],
            ),
          ],
        ),
      );
      await _open(tester);

      final node = tester.getSemantics(find.text('Density'));
      final data = node.getSemanticsData();
      expect(data.label, 'Density');
      expect(data.role, SemanticsRole.none);
      expect(data.flagsCollection.isHeader, isFalse);
      // Neither focusable nor an enabled or disabled control.
      expect(data.flagsCollection.isFocused, Tristate.none);
      expect(data.flagsCollection.isEnabled, Tristate.none);
      expect(data.flagsCollection.isButton, isFalse);
      expect(data.hasAction(SemanticsAction.tap), isFalse);
      expect(data.hasAction(SemanticsAction.focus), isFalse);

      // The label is its own node: no menu row merges or carries it.
      final menu = tester.getSemantics(find.text('Compact')).parent!;
      final rows = semanticsSubtree(menu)
          .map((node) => node.getSemanticsData())
          .where((data) => data.role == SemanticsRole.menuItemRadio)
          .map((data) => data.label)
          .toList();
      expect(rows, ['Compact', 'Comfortable']);
      semantics.dispose();
    });

    testWidgets('lines its text up with the rows of a choice panel', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        RemixMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          onSelected: (_) {},
          style: MenuStyler().item(MenuItemStyler().spacing(8)),
          items: [
            const RemixMenuLabel(label: 'Density'),
            RemixMenuRadioGroup(
              value: 'compact',
              onChanged: (_) {},
              items: const [
                RemixMenuRadioItem(value: 'compact', label: 'Compact'),
              ],
            ),
          ],
        ),
      );
      await _open(tester);

      expect(
        tester.getTopLeft(find.text('Density')).dx,
        tester.getTopLeft(find.text('Compact')).dx,
      );
    });

    testWidgets('labelItem merges after item and the label style last', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        RemixMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          onSelected: (_) {},
          style: MenuStyler()
              .item(
                MenuItemStyler().label(
                  TextStyler().fontSize(14).color(Colors.black),
                ),
              )
              .labelItem(MenuItemStyler().label(TextStyler().fontSize(12))),
          items: [
            const RemixMenuLabel(label: 'Fallback'),
            RemixMenuLabel(
              label: 'Own',
              style: MenuItemStyler().label(TextStyler().color(Colors.red)),
            ),
            const RemixMenuItem(value: 'alpha', label: 'Alpha'),
          ],
        ),
      );
      await _open(tester);

      expect(_fontSize(tester, 'Fallback'), 12);
      expect(_color(tester, 'Fallback'), Colors.black);
      expect(_fontSize(tester, 'Own'), 12);
      expect(_color(tester, 'Own'), Colors.red);
      // labelItem does not reach ordinary rows.
      expect(_fontSize(tester, 'Alpha'), 14);
    });

    testWidgets('a raw spec without labelItem styles labels as items', (
      tester,
    ) async {
      const itemLabel = StyleSpec(
        spec: MenuItemSpec(
          label: StyleSpec(spec: TextSpec(style: TextStyle(fontSize: 15))),
        ),
      );
      const labelRow = StyleSpec(
        spec: MenuItemSpec(
          label: StyleSpec(spec: TextSpec(style: TextStyle(fontSize: 11))),
        ),
      );

      Future<void> pump(MenuSpec spec) => tester.pumpRemixApp(
        RemixMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          onSelected: (_) {},
          styleSpec: spec,
          items: const [
            RemixMenuLabel(label: 'Heading'),
            RemixMenuItem(value: 'alpha', label: 'Alpha'),
          ],
        ),
      );

      await pump(const MenuSpec(item: itemLabel));
      await _open(tester);
      expect(_fontSize(tester, 'Heading'), 15);

      await pump(const MenuSpec(item: itemLabel, labelItem: labelRow));
      await tester.pumpAndSettle();
      expect(_fontSize(tester, 'Heading'), 11);
      expect(_fontSize(tester, 'Alpha'), 15);
    });

    testWidgets('ignores hover and focus item variants', (tester) async {
      await tester.pumpRemixApp(
        RemixMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          onSelected: (_) {},
          style: MenuStyler().item(
            MenuItemStyler()
                .label(TextStyler().fontSize(12))
                .onHovered(MenuItemStyler().label(TextStyler().fontSize(30))),
          ),
          items: const [
            RemixMenuLabel(label: 'Heading'),
            RemixMenuItem(value: 'alpha', label: 'Alpha'),
          ],
        ),
      );
      await _open(tester);

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(
        location: tester.getCenter(find.text('Heading')),
      );
      await tester.pumpAndSettle();
      expect(_fontSize(tester, 'Heading'), 12);
      await gesture.removePointer();
    });

    testWidgets('renders in a submenu panel', (tester) async {
      await tester.pumpRemixApp(
        RemixMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          onSelected: (_) {},
          items: const [
            RemixMenuSubmenu(
              label: 'Model',
              items: [
                RemixMenuLabel(label: 'Reasoning'),
                RemixMenuItem(value: 'high', label: 'High'),
              ],
            ),
          ],
        ),
      );
      await _open(tester);
      await tester.tap(find.text('Model'));
      await tester.pumpAndSettle();

      expect(find.text('Reasoning'), findsOneWidget);
    });
  });
}
