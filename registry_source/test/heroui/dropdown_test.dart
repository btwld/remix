import 'dart:ui' show Tristate;

import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/button.dart';
import 'package:registry_source/src/heroui/components/dropdown.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

Widget _dropdown({
  MenuStyler style = const MenuStyler.create(),
  ValueChanged<String>? onSelected,
  List<RemixMenuItemData<String>>? items,
}) => HeroUiDropdown<String>(
  style: style,
  trigger: const RemixMenuTrigger(label: 'Actions'),
  onSelected: onSelected,
  items:
      items ??
      [
        const RemixMenuItem(value: 'apple', label: 'Apple'),
        const RemixMenuItem(value: 'banana', label: 'Banana', enabled: false),
        const RemixMenuItem(value: 'cherry', label: 'Cherry'),
        RemixMenuItem(
          value: 'date',
          label: 'Date',
          style: heroUiDropdownItemStyle(variant: .danger),
        ),
      ],
);

/// Rows that carry an indicator: a checked checkbox row, an unchecked one, and
/// a danger one, around a divider.
List<RemixMenuItemData<String>> _choiceItems() => [
  RemixMenuCheckboxItem(
    value: 'notify',
    label: 'Notify',
    checked: true,
    onChanged: (_) {},
  ),
  RemixMenuCheckboxItem(
    value: 'mute',
    label: 'Mute',
    checked: false,
    onChanged: (_) {},
  ),
  const RemixMenuDivider(),
  RemixMenuCheckboxItem(
    value: 'remove',
    label: 'Remove',
    checked: true,
    onChanged: (_) {},
    style: heroUiDropdownItemStyle(variant: .danger),
  ),
];

Future<void> _open(WidgetTester tester) async {
  await tester.tap(find.text('Actions'));
  await tester.pumpAndSettle();
}

MenuItemSpec _item(WidgetTester tester, String label) =>
    tester.resolvedSpecOf<MenuItemSpec>(find.text(label));

BoxDecoration _decoration(MenuItemSpec spec) =>
    spec.container.spec.boxSpec.decoration! as BoxDecoration;

Finder get _popover => find
    .ancestor(of: find.text('Apple'), matching: find.byType(DecoratedBox))
    .last;

/// A dropdown whose trigger is a [HeroUiButton], the way Remix hands a real
/// control to the menu.
Widget _buttonDropdown({
  required List<RemixMenuTriggerHandle> handles,
  bool enabled = true,
}) => HeroUiDropdown<String>(
  trigger: RemixMenuTrigger.control(
    builder: (context, menu) {
      handles.add(menu);
      return HeroUiButton.secondary(
        label: 'Actions',
        focusNode: menu.focusNode,
        onPressed: enabled ? menu.toggle : null,
      );
    },
  ),
  items: const [RemixMenuItem(value: 'apple', label: 'Apple')],
);

/// `transform: scale(0.98)` on a pressed row and `scale(0.97)` on the
/// pressed trigger (`menu-item.css`, `dropdown.css`).
const _itemPressedScale = .98;
const _triggerPressedScale = .97;

void main() {
  test('item variants follow HeroUI', () {
    expect(HeroUiDropdownItemVariant.values, [
      HeroUiDropdownItemVariant.defaultItem,
      HeroUiDropdownItemVariant.danger,
    ]);
  });

  for (final mode in ['light', 'dark']) {
    testWidgets('the open menu matches upstream in $mode', (tester) async {
      await tester.pumpHeroUi(_dropdown(), mode: mode);
      await _open(tester);
      final popover = heroUiCase(
        'dropdown-default-keyboard-open-dropdown-popover',
        mode: mode,
      );
      final menu = heroUiCase(
        'dropdown-default-keyboard-open-dropdown-menu',
        mode: mode,
      );

      expect(tester.getSize(_popover), popover.size);
      expect(menu.size, popover.size);

      final spec = tester.resolvedSpecOf<MenuSpec>(find.text('Apple'));
      final box = spec.overlay.spec.box!.spec.decoration! as BoxDecoration;
      expect(
        box.borderRadius,
        BorderRadius.circular(popover.px('borderRadius')),
      );
      expectCssColor(box.color!, popover.styles['backgroundColor']!);
      expect(spec.overlay.spec.flex!.spec.spacing, menu.px('gap'));
      expect(
        behindShadows(spec.containerEffects),
        cssRemixShadows(popover.styles['boxShadow']!),
      );
    });

    testWidgets('rows match upstream in $mode', (tester) async {
      await tester.pumpHeroUi(_dropdown(), mode: mode);
      await _open(tester);
      final row = heroUiCase(
        'dropdown-default-keyboard-open-menu-item:Banana',
        mode: mode,
      );
      final label = heroUiCase(
        'dropdown-default-keyboard-open-label:Banana',
        mode: mode,
      );

      expect(tester.getSize(find.text('Cherry')).height, label.size.height);
      final spec = _item(tester, 'Cherry');
      expect(
        spec.container.spec.boxSpec.constraints!.minHeight,
        row.size.height,
      );
      expect(
        _decoration(spec).borderRadius,
        BorderRadius.circular(row.px('borderRadius')),
      );
      expect(spec.container.spec.flex!.spec.spacing, row.px('gap'));
      expect(spec.label.spec.style!.fontSize, label.px('fontSize'));
      expect(
        spec.label.spec.style!.fontSize! * spec.label.spec.style!.height!,
        label.px('lineHeight'),
      );
      expect(
        spec.label.spec.style!.fontWeight,
        FontWeight.values[label.px('fontWeight') ~/ 100 - 1],
      );
      expectCssColor(spec.label.spec.style!.color!, label.styles['color']!);
    });

    testWidgets('hover fills a row with default in $mode', (tester) async {
      await tester.pumpHeroUi(_dropdown(), mode: mode);
      await _open(tester);
      expect(_decoration(_item(tester, 'Cherry')).color, isNull);

      await tester.hoverCenter(find.text('Cherry'));
      expect(
        _decoration(_item(tester, 'Cherry')).color,
        heroUiToken(HeroUiTokens.defaultColor, mode),
      );
    }, variant: desktopOnly);

    testWidgets('a disabled row dims twice and ignores hover in $mode', (
      tester,
    ) async {
      await tester.pumpHeroUi(_dropdown(), mode: mode);
      await _open(tester);
      final row = heroUiCase('menu-default-rest-menu-item:Banana', mode: mode);
      final label = heroUiCase('menu-default-rest-label:Banana', mode: mode);
      expect(
        tester.opacityAbove(find.text('Banana')),
        double.parse(row.styles['opacity']!),
      );
      expect(
        _item(tester, 'Banana').label.spec.style!.color!.a,
        closeTo(double.parse(label.styles['opacity']!), .001),
      );

      await tester.hoverCenter(find.text('Banana'));
      expect(_decoration(_item(tester, 'Banana')).color, isNull);
    }, variant: desktopOnly);

    testWidgets('a danger row takes the danger color on label and indicator '
        'in $mode', (tester) async {
      await tester.pumpHeroUi(_dropdown(), mode: mode);
      await _open(tester);
      final label = heroUiCase(
        'dropdown-danger-keyboard-open-label:Cherry',
        mode: mode,
      );
      final indicator = heroUiCase(
        'dropdown-danger-keyboard-open-menu-item-indicator',
        mode: mode,
      );
      final muted = heroUiCase(
        'dropdown-default-keyboard-open-menu-item-indicator--checkmark',
        mode: mode,
      );
      final spec = _item(tester, 'Date');
      expectCssColor(spec.label.spec.style!.color!, label.styles['color']!);
      expectCssColor(spec.indicator.spec.color!, indicator.styles['color']!);
      expectCssColor(
        _item(tester, 'Apple').indicator.spec.color!,
        muted.styles['color']!,
      );
    });

    testWidgets('keyboard focus draws the measured ring around a row without '
        'moving it in $mode', (tester) async {
      await tester.pumpHeroUi(_dropdown(), mode: mode);
      await tester.focusWithTab();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      final before = tester.getRect(find.text('Apple'));
      final size = tester.getSize(
        find
            .ancestor(of: find.text('Apple'), matching: find.byType(Padding))
            .first,
      );
      final measured = heroUiCase(
        'dropdown-default-keyboard-open-menu-item:Apple',
        mode: mode,
      );
      expect(_item(tester, 'Apple').containerEffects?.isEmpty ?? true, isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expectFocusRing(_item(tester, 'Apple').containerEffects, measured);
      expect(_decoration(_item(tester, 'Apple')).border, isNull);
      expect(tester.getRect(find.text('Apple')), before);
      expect(
        tester.getSize(
          find
              .ancestor(of: find.text('Apple'), matching: find.byType(Padding))
              .first,
        ),
        size,
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(_item(tester, 'Apple').containerEffects?.isEmpty ?? true, isTrue);
      expect(tester.getRect(find.text('Apple')), before);
    });

    testWidgets('keyboard focus draws the measured ring around the trigger '
        'without moving it in $mode', (tester) async {
      await tester.pumpHeroUi(_dropdown(), mode: mode);
      MenuTriggerSpec spec() =>
          tester.resolvedSpecOf<MenuTriggerSpec>(find.text('Actions'));

      final before = tester.getRect(find.text('Actions'));
      expect(spec().containerEffects?.isEmpty ?? true, isTrue);
      await tester.focusWithTab();
      expectFocusRing(
        spec().containerEffects,
        heroUiCase('close-button-focus', mode: mode, state: true),
      );
      expect(spec().container.spec.boxSpec.decoration, isNull);
      expect(tester.getRect(find.text('Actions')), before);
    });

    testWidgets('a divider is a 1px separator line in $mode', (tester) async {
      await tester.pumpHeroUi(_dropdown(items: _choiceItems()), mode: mode);
      await _open(tester);
      // separator.css: `h-px bg-separator`.
      final line = find
          .descendant(
            of: find.byType(RemixDivider),
            matching: find.byType(DecoratedBox),
          )
          .first;
      expect(tester.getSize(line).height, 1);
      expect(
        (tester.widget<DecoratedBox>(line).decoration as BoxDecoration).color,
        heroUiToken(HeroUiTokens.separator, mode),
      );
    });

    testWidgets('a checkbox row shows the indicator in muted, danger on a '
        'danger row in $mode', (tester) async {
      await tester.pumpHeroUi(_dropdown(items: _choiceItems()), mode: mode);
      await _open(tester);
      final muted = heroUiCase(
        'dropdown-default-keyboard-open-menu-item-indicator--checkmark',
        mode: mode,
      );
      final danger = heroUiCase(
        'dropdown-danger-keyboard-open-menu-item-indicator',
        mode: mode,
      );

      for (final label in ['Notify', 'Mute']) {
        final spec = _item(tester, label);
        expectCssColor(spec.indicator.spec.color!, muted.styles['color']!);
        expect(spec.indicator.spec.size, muted.size.width);
      }
      expectCssColor(
        _item(tester, 'Remove').indicator.spec.color!,
        danger.styles['color']!,
      );
    });
  }

  testWidgets('rows are as wide as the popover allows', (tester) async {
    await tester.pumpHeroUi(_dropdown());
    await _open(tester);
    final popoverCase = heroUiCase(
      'dropdown-default-keyboard-open-dropdown-popover',
    );
    final row = heroUiCase('dropdown-default-keyboard-open-menu-item:Apple');
    // The menu's `p-1.5` on both sides leaves the rows 12px less than the
    // popover.
    const padding = 2 * 6.0;
    expect(popoverCase.size.width - row.size.width, padding);
    expect(tester.getSize(_popover).width - row.size.width, padding);
    expect(
      tester
          .getSize(
            find
                .ancestor(
                  of: find.text('Apple'),
                  matching: find.byType(DecoratedBox),
                )
                .first,
          )
          .width,
      row.size.width,
    );
  });

  testWidgets('the minimum width applies from the md breakpoint only', (
    tester,
  ) async {
    await tester.pumpHeroUi(_dropdown(), width: 375);
    await _open(tester);
    expect(tester.getSize(_popover).width, lessThan(220));
    await tester.pumpHeroUi(_dropdown(), width: 1024);
    await _open(tester);
    expect(tester.getSize(_popover).width, 220);
  });

  testWidgets('a row with an indicator starts its label 4px after ps-7', (
    tester,
  ) async {
    await tester.pumpHeroUi(_dropdown(items: _choiceItems()));
    await _open(tester);
    final indicator = heroUiCase(
      'dropdown-default-keyboard-open-menu-item-indicator--checkmark',
    );
    final row = heroUiCase('dropdown-default-keyboard-open-menu-item:Apple');
    // Upstream rows with an indicator carry `ps-7` (28px) and draw the
    // indicator absolutely; Remix lays it out in the row: `px-2.5` (10), the
    // indicator (10), the row gap (12).
    const upstreamStart = 28.0;
    const paddingX = 10.0;
    for (final label in ['Notify', 'Mute']) {
      final rowBox = find
          .ancestor(of: find.text(label), matching: find.byType(DecoratedBox))
          .first;
      expect(
        tester.getTopLeft(find.text(label)).dx - tester.getTopLeft(rowBox).dx,
        paddingX + indicator.size.width + row.px('gap'),
        reason: label,
      );
      expect(
        tester.getTopLeft(find.text(label)).dx - tester.getTopLeft(rowBox).dx,
        upstreamStart + 4,
        reason: label,
      );
    }
  });

  for (final mode in ['light', 'dark']) {
    testWidgets('a pressed row scales to .98 in $mode', (tester) async {
      await tester.pumpHeroUi(_dropdown(), mode: mode);
      await _open(tester);
      final press = await tester.pressCenter(find.text('Cherry'));
      final transform = tester.widget<Transform>(
        find
            .ancestor(of: find.text('Cherry'), matching: find.byType(Transform))
            .first,
      );
      expect(transform.transform.entry(0, 0), closeTo(_itemPressedScale, .001));
      await press.up();
    });

    testWidgets('the trigger scales to .97 while pressed in $mode', (
      tester,
    ) async {
      await tester.pumpHeroUi(_dropdown(), mode: mode);
      final press = await tester.pressCenter(find.text('Actions'));
      final transform = tester.widget<Transform>(
        find
            .ancestor(
              of: find.text('Actions'),
              matching: find.byType(Transform),
            )
            .first,
      );
      expect(
        transform.transform.entry(0, 0),
        closeTo(_triggerPressedScale, .001),
      );
      await press.up();
    });
  }

  testWidgets('a HeroUiButton is the trigger: one tab stop that opens the menu '
      'and takes focus back', (tester) async {
    final handles = <RemixMenuTriggerHandle>[];
    await tester.pumpHeroUi(_buttonDropdown(handles: handles));

    await tester.focusWithTab();
    expect(handles.last.focusNode.hasPrimaryFocus, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.text('Apple'), findsOneWidget);
    expect(handles.last.isOpen, isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Apple'), findsNothing);
    expect(handles.last.focusNode.hasPrimaryFocus, isTrue);

    // The button is the only tab stop, so Tab comes back to it.
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(handles.last.focusNode.hasPrimaryFocus, isTrue);
  });

  testWidgets('a HeroUiButton trigger keeps the button recipe and is one '
      'expandable semantics node', (tester) async {
    final handles = <RemixMenuTriggerHandle>[];
    await tester.pumpHeroUi(_buttonDropdown(handles: handles));
    final semantics = tester.ensureSemantics();
    final button = find.byType(HeroUiButton);

    final spec = tester.resolvedSpecOf<ButtonSpec>(find.text('Actions'));
    expect(
      (spec.container.spec.boxSpec.decoration as BoxDecoration).color,
      heroUiToken(HeroUiTokens.defaultColor),
    );
    expect(
      tester.getSize(button).height,
      heroUiCase('button-secondary-md').size.height,
    );

    bool hasExpandedState(SemanticsNode node) =>
        node.getSemanticsData().flagsCollection.isExpanded != Tristate.none;
    expect(find.semantics.byPredicate(hasExpandedState), findsOne);
    expect(
      tester.getSemantics(find.text('Actions')),
      isSemantics(
        label: 'Actions',
        isButton: true,
        hasTapAction: true,
        hasExpandedState: true,
        isExpanded: false,
      ),
    );

    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(find.semantics.byPredicate(hasExpandedState), findsOne);
    expect(
      tester.getSemantics(find.text('Actions')),
      isSemantics(label: 'Actions', hasExpandedState: true, isExpanded: true),
    );
    semantics.dispose();
  });

  testWidgets('a disabled HeroUiButton trigger does not open the menu', (
    tester,
  ) async {
    await tester.pumpHeroUi(_buttonDropdown(handles: [], enabled: false));
    await tester.tap(find.byType(HeroUiButton));
    await tester.pumpAndSettle();
    expect(find.text('Apple'), findsNothing);
  });

  testWidgets('selecting a row reports its value through Remix', (
    tester,
  ) async {
    String? picked;
    await tester.pumpHeroUi(_dropdown(onSelected: (value) => picked = value));
    await _open(tester);
    await tester.tap(find.text('Cherry'));
    await tester.pumpAndSettle();
    expect(picked, 'cherry');
    expect(find.text('Cherry'), findsNothing);
  });

  testWidgets('a caller style wins over the recipe', (tester) async {
    const override = Color(0xFF00FF00);
    await tester.pumpHeroUi(
      _dropdown(style: MenuStyler().overlay(FlexBoxStyler().color(override))),
    );
    await _open(tester);
    final spec = tester.resolvedSpecOf<MenuSpec>(find.text('Apple'));
    expect(
      (spec.overlay.spec.box!.spec.decoration! as BoxDecoration).color,
      override,
    );
  });
}
