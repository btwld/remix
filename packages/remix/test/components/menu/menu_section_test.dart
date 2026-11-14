import 'dart:ui'
    show PointerDeviceKind, SemanticsAction, SemanticsRole, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show SemanticsNode;
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
  group('RemixMenuSection', () {
    test('rejects an empty label', () {
      expect(
        () => RemixMenuSection<String>(label: '', items: const []),
        throwsA(isA<AssertionError>()),
      );
    });

    testWidgets('a tap on the heading neither selects nor closes the menu', (
      tester,
    ) async {
      final selected = <String>[];
      await tester.pumpRemixApp(
        RemixMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          onSelected: selected.add,
          items: const [
            RemixMenuSection(
              label: 'Workspaces',
              items: [RemixMenuItem(value: 'alpha', label: 'Alpha')],
            ),
          ],
        ),
      );
      await _open(tester);

      await tester.tap(find.text('Workspaces'));
      await tester.pumpAndSettle();
      expect(selected, isEmpty);
      expect(find.text('Alpha'), findsOneWidget);

      await tester.tap(find.text('Alpha'));
      await tester.pumpAndSettle();
      expect(selected, ['alpha']);
    });

    testWidgets('keyboard navigation moves between sections past headings', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        RemixMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          onSelected: (_) {},
          items: const [
            RemixMenuSection(
              label: 'Recent',
              items: [RemixMenuItem(value: 'alpha', label: 'Alpha')],
            ),
            RemixMenuDivider(),
            RemixMenuSection(
              label: 'Shared',
              items: [RemixMenuItem(value: 'beta', label: 'Beta')],
            ),
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

    testWidgets('is one group named by its heading that holds its items', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpRemixApp(
        RemixMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          onSelected: (_) {},
          items: [
            const RemixMenuItem(value: 'reset', label: 'Reset'),
            RemixMenuSection(
              label: 'Density',
              items: [
                RemixMenuRadioGroup(
                  value: 'compact',
                  onChanged: (_) {},
                  items: const [
                    RemixMenuRadioItem(value: 'compact', label: 'Compact'),
                    RemixMenuRadioItem(
                      value: 'comfortable',
                      label: 'Comfortable',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
      await _open(tester);

      final group = tester.getSemantics(find.text('Compact')).parent!;
      final data = group.getSemanticsData();
      expect(data.label, 'Density');
      expect(data.role, SemanticsRole.none);
      expect(data.flagsCollection.isHeader, isFalse);
      expect(data.flagsCollection.isFocused, Tristate.none);
      expect(data.flagsCollection.isEnabled, Tristate.none);
      expect(data.hasAction(SemanticsAction.tap), isFalse);
      expect(data.hasAction(SemanticsAction.focus), isFalse);

      List<String> labels(SemanticsNode node, SemanticsRole role) => [
        for (final data in semanticsSubtree(
          node,
        ).map((n) => n.getSemanticsData()))
          if (data.role == role) data.label,
      ];
      expect(labels(group, SemanticsRole.menuItemRadio), [
        'Compact',
        'Comfortable',
      ]);

      // The group sits in the menu beside its sibling rows, and the visible
      // heading is not a second node that repeats the name.
      final menu = group.parent!;
      expect(labels(menu, SemanticsRole.menuItem), ['Reset']);
      expect(
        semanticsSubtree(
          menu,
        ).where((node) => node.getSemanticsData().label == 'Density'),
        [group],
      );
      semantics.dispose();
    });

    testWidgets('lines its heading up with the rows of a choice panel', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        RemixMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          onSelected: (_) {},
          style: MenuStyler().item(MenuItemStyler().spacing(8)),
          items: [
            const RemixMenuItem(value: 'reset', label: 'Reset'),
            RemixMenuSection(
              label: 'Density',
              items: [
                RemixMenuRadioGroup(
                  value: 'compact',
                  onChanged: (_) {},
                  items: const [
                    RemixMenuRadioItem(value: 'compact', label: 'Compact'),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
      await _open(tester);

      // A choice row inside a section reserves the slot for the whole panel.
      expect(
        find.byKey(const ValueKey('remix-menu-indicator-Reset')),
        findsOneWidget,
      );
      final compact = tester.getTopLeft(find.text('Compact')).dx;
      expect(tester.getTopLeft(find.text('Density')).dx, compact);
      expect(tester.getTopLeft(find.text('Reset')).dx, compact);
    });

    testWidgets('sectionLabel merges after item and labelStyle last', (
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
              .sectionLabel(MenuItemStyler().label(TextStyler().fontSize(12))),
          items: [
            const RemixMenuSection(
              label: 'Fallback',
              items: [RemixMenuItem(value: 'alpha', label: 'Alpha')],
            ),
            RemixMenuSection(
              label: 'Own',
              labelStyle: MenuItemStyler().label(
                TextStyler().color(Colors.red),
              ),
              items: const [RemixMenuItem(value: 'beta', label: 'Beta')],
            ),
          ],
        ),
      );
      await _open(tester);

      expect(_fontSize(tester, 'Fallback'), 12);
      expect(_color(tester, 'Fallback'), Colors.black);
      expect(_fontSize(tester, 'Own'), 12);
      expect(_color(tester, 'Own'), Colors.red);
      // Neither reaches the section's items.
      expect(_fontSize(tester, 'Alpha'), 14);
      expect(_color(tester, 'Beta'), Colors.black);
    });

    testWidgets('a raw spec without sectionLabel styles headings as items', (
      tester,
    ) async {
      const itemLabel = StyleSpec(
        spec: MenuItemSpec(
          label: StyleSpec(spec: TextSpec(style: TextStyle(fontSize: 15))),
        ),
      );
      const headingRow = StyleSpec(
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
            RemixMenuSection(
              label: 'Heading',
              items: [RemixMenuItem(value: 'alpha', label: 'Alpha')],
            ),
          ],
        ),
      );

      await pump(const MenuSpec(item: itemLabel));
      await _open(tester);
      expect(_fontSize(tester, 'Heading'), 15);

      await pump(const MenuSpec(item: itemLabel, sectionLabel: headingRow));
      await tester.pumpAndSettle();
      expect(_fontSize(tester, 'Heading'), 11);
      expect(_fontSize(tester, 'Alpha'), 15);
    });

    testWidgets('the heading ignores hover item variants', (tester) async {
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
            RemixMenuSection(
              label: 'Heading',
              items: [RemixMenuItem(value: 'alpha', label: 'Alpha')],
            ),
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
      String? selected;
      await tester.pumpRemixApp(
        RemixMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          onSelected: (value) => selected = value,
          items: const [
            RemixMenuSubmenu(
              label: 'Model',
              items: [
                RemixMenuSection(
                  label: 'Reasoning',
                  items: [RemixMenuItem(value: 'high', label: 'High')],
                ),
              ],
            ),
          ],
        ),
      );
      await _open(tester);
      await tester.tap(find.text('Model'));
      await tester.pumpAndSettle();
      expect(find.text('Reasoning'), findsOneWidget);

      await tester.tap(find.text('High'));
      await tester.pumpAndSettle();
      expect(selected, 'high');
    });
  });
}
