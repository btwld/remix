import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/table.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

class _Person {
  const _Person(this.id, this.name, this.role);

  final String id;
  final String name;
  final String role;
}

/// Four body rows, as in the upstream fixture.
const _people = [
  _Person('1', 'Ada', 'Engineer'),
  _Person('2', 'Grace', 'Admiral'),
  _Person('3', 'Linus', 'Maintainer'),
  _Person('4', 'Margaret', 'Director'),
];

String _id(HeroUiTableVariant variant) => variant.name;

Widget _table({
  HeroUiTableVariant variant = .primary,
  Set<Object> selected = const {},
  bool selectable = false,
  ValueChanged<RemixDataTableSort>? onSort,
  ValueChanged<Set<Object>>? onSelection,
  DataTableStyler style = const DataTableStyler.create(),
}) => SizedBox(
  // The upstream fixture's width.
  width: heroUiCase('table-${_id(variant)}-root').size.width,
  child: HeroUiTable<_Person>(
    variant: variant,
    style: style,
    rows: _people,
    rowId: selectable ? (person) => person.id : null,
    selectedRowIds: selected,
    onSelectionChanged: selectable ? (onSelection ?? (_) {}) : null,
    onSortChanged: onSort ?? (_) {},
    columns: [
      RemixDataTableColumn<_Person>(
        id: 'name',
        label: 'Name',
        sortable: true,
        cellBuilder: (context, person) => Text(person.name),
      ),
      RemixDataTableColumn<_Person>(
        id: 'role',
        label: 'Role',
        cellBuilder: (context, person) => Text(person.role),
      ),
    ],
  ),
);

DataTableSpec _spec(WidgetTester tester) => tester
    .widget<StyleSpecProvider<DataTableSpec>>(
      find.byType(StyleSpecProvider<DataTableSpec>),
    )
    .spec
    .spec;

/// The row region behind the cell with [text]: its background box.
Finder _rowBox(String text) => find
    .ancestor(
      of: find.text(text),
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is DecoratedBox &&
            widget.position == DecorationPosition.background,
      ),
    )
    .first;

/// The row fill and the rule under it, as painted behind the cell with
/// [text].
({Color? fill, Color? divider, double ruleWidth}) _row(
  WidgetTester tester,
  String text,
) {
  final decoration =
      tester.widget<DecoratedBox>(_rowBox(text)).decoration as BoxDecoration;
  final border = decoration.border as Border?;
  return (
    fill: decoration.color,
    divider: border?.bottom.color,
    ruleWidth: border?.bottom.width ?? 0,
  );
}

Color? _frame(WidgetTester tester) =>
    (_spec(tester).container.spec.decoration as BoxDecoration?)?.color;

void main() {
  test('variants follow HeroUI', () {
    expect(HeroUiTableVariant.values, [
      HeroUiTableVariant.primary,
      HeroUiTableVariant.secondary,
    ]);
  });

  for (final mode in ['light', 'dark']) {
    testWidgets('primary is a surface card on a secondary frame in $mode', (
      tester,
    ) async {
      await tester.pumpHeroUi(_table(), mode: mode);
      await tester.pumpAndSettle();
      final root = heroUiCase('table-primary-root', mode: mode);
      final header = heroUiCase('table-primary-header', mode: mode);
      final cell = heroUiCase('table-primary-cell-mid', mode: mode);
      final footer = heroUiCase('table-primary-footer', mode: mode);

      // The fixture has no footer: 36 header + 4 x 45 rows + the frame's 4.
      expect(
        tester.getSize(find.byType(HeroUiTable<_Person>)),
        Size(root.size.width, root.size.height - footer.size.height),
      );

      // .table-root--primary: bg-surface-secondary px-1 pb-1 rounded;
      // .table__header: bg-surface-secondary; .table__cell: bg-surface.
      expectCssColor(_frame(tester)!, root.styles['backgroundColor']!);
      expect(
        _spec(tester).container.spec.padding,
        EdgeInsets.fromLTRB(
          root.px('paddingLeft'),
          root.px('paddingTop'),
          root.px('paddingRight'),
          root.px('paddingBottom'),
        ),
      );
      expectCssColor(
        _row(tester, 'Name').fill!,
        header.styles['backgroundColor']!,
      );
      expectCssColor(
        _row(tester, 'Ada').fill!,
        cell.styles['backgroundColor']!,
      );

      // Only the cells' own rule paints (`border-separate` ignores the
      // header's and the row's), `separator-tertiary` at 50%.
      expect(_row(tester, 'Name').divider, isNull);
      expectCssColor(_row(tester, 'Ada').divider!, cell.styles['borderColor']!);
      expect(_row(tester, 'Ada').ruleWidth, cell.px('borderBottomWidth'));
    });

    testWidgets('secondary has a gray header over bare rows in $mode', (
      tester,
    ) async {
      await tester.pumpHeroUi(_table(variant: .secondary), mode: mode);
      await tester.pumpAndSettle();
      final root = heroUiCase('table-secondary-root', mode: mode);
      final column = heroUiCase('table-secondary-column-start', mode: mode);
      final cell = heroUiCase('table-secondary-cell-mid', mode: mode);
      final footer = heroUiCase('table-secondary-footer', mode: mode);

      expect(
        tester.getSize(find.byType(HeroUiTable<_Person>)),
        Size(root.size.width, root.size.height - footer.size.height),
      );
      expect(root.styles, isNot(contains('backgroundColor')));
      expect(_frame(tester), isNull);
      expectCssColor(
        _row(tester, 'Name').fill!,
        column.styles['backgroundColor']!,
      );
      expect(cell.styles, isNot(contains('backgroundColor')));
      expect(_row(tester, 'Ada').fill, const Color(0x00000000));
      expectCssColor(_row(tester, 'Ada').divider!, cell.styles['borderColor']!);
    });

    testWidgets('cells and headers are padded and typeset as in table.css in '
        '$mode', (tester) async {
      await tester.pumpHeroUi(_table(), mode: mode);
      await tester.pumpAndSettle();
      final spec = _spec(tester);
      final column = heroUiCase('table-primary-column-start', mode: mode);
      final cell = heroUiCase('table-primary-cell-mid', mode: mode);

      // .table__column: px-4 py-2.5 text-xs font-medium text-muted.
      final header = spec.headerLabel.spec.style!;
      expect(header.fontSize, column.px('fontSize'));
      expect(
        header.fontSize! * header.height!,
        closeTo(column.px('lineHeight'), .01),
      );
      expect(header.fontWeight, FontWeight.w500);
      expectCssColor(header.color!, column.styles['color']!);
      expect(tester.getSize(find.text('Name')).height, column.px('lineHeight'));

      // .table__cell: px-4 py-3 text-sm text-foreground.
      final text = spec.cellText.spec.style!;
      expect(text.fontSize, cell.px('fontSize'));
      expect(
        text.fontSize! * text.height!,
        closeTo(cell.px('lineHeight'), .01),
      );
      expectCssColor(text.color!, cell.styles['color']!);

      // A header cell is 36 high and every body row, the last included, 45:
      // the 20px line, py-3 and the 1px rule.
      expect(tester.getSize(_rowBox('Name')).height, column.size.height);
      for (final person in _people) {
        expect(
          tester.getSize(_rowBox(person.name)).height,
          heroUiCase('table-primary-row-first', mode: mode).size.height,
          reason: person.name,
        );
      }
      expect(
        tester.getSize(_rowBox('Margaret')).height,
        heroUiCase('table-primary-row-last', mode: mode).size.height,
      );
      expect(
        tester.getTopLeft(find.text('Ada')).dx -
            tester.getTopLeft(_rowBox('Ada')).dx,
        cell.px('paddingLeft'),
      );
      expect(
        spec.sortIcon.spec.size,
        heroUiCase('table-primary-sort-indicator', mode: mode).size.width,
      );
    });

    testWidgets(
      'hovering a row fills it; hover wins over selected in $mode',
      (tester) async {
        await tester.pumpHeroUi(
          _table(selected: {'2'}, selectable: true),
          mode: mode,
        );
        await tester.pumpAndSettle();
        final rest = heroUiCase('table-primary-cell-mid', mode: mode);
        final hover = heroUiCase(
          'table-primary-hover-cell',
          mode: mode,
          state: true,
        );
        final selected = heroUiCase(
          'table-primary-select-cell-selected',
          mode: mode,
        );
        final hoverSelected = heroUiCase(
          'table-primary-select-hover-cell',
          mode: mode,
          state: true,
        );

        expectCssColor(
          _row(tester, 'Ada').fill!,
          rest.styles['backgroundColor']!,
        );
        // .table__row[data-selected]: bg-surface/10.
        expectCssColor(
          _row(tester, 'Grace').fill!,
          selected.styles['backgroundColor']!,
        );

        final mouse = await tester.hoverCenter(find.text('Ada'));
        // .table__row:hover: bg-surface/40.
        expectCssColor(
          _row(tester, 'Ada').fill!,
          hover.styles['backgroundColor']!,
        );

        // A hovered selected row takes the hover fill.
        await mouse.moveTo(tester.getCenter(find.text('Grace')));
        await tester.pumpAndSettle();
        expectCssColor(
          _row(tester, 'Grace').fill!,
          hoverSelected.styles['backgroundColor']!,
        );
      },
      variant: desktopOnly,
    );

    testWidgets(
      'a secondary row hovers to default at half strength, selected or not in '
      '$mode',
      (tester) async {
        await tester.pumpHeroUi(
          _table(variant: .secondary, selected: {'2'}, selectable: true),
          mode: mode,
        );
        await tester.pumpAndSettle();
        final hover = heroUiCase(
          'table-secondary-hover-cell',
          mode: mode,
          state: true,
        );
        final selected = heroUiCase(
          'table-secondary-select-cell-selected',
          mode: mode,
        );

        // .table__row[data-selected]: bg-surface/10.
        expectCssColor(
          _row(tester, 'Grace').fill!,
          selected.styles['backgroundColor']!,
        );

        final mouse = await tester.hoverCenter(find.text('Ada'));
        // .table-root--secondary .table__row:hover: bg-default/50.
        expectCssColor(
          _row(tester, 'Ada').fill!,
          hover.styles['backgroundColor']!,
        );

        // The secondary hover rule (0,4,0) outranks the selected rule
        // (0,3,0), so a hovered selected row keeps the hover fill.
        await mouse.moveTo(tester.getCenter(find.text('Grace')));
        await tester.pumpAndSettle();
        expectCssColor(
          _row(tester, 'Grace').fill!,
          hover.styles['backgroundColor']!,
        );
      },
      variant: desktopOnly,
    );

    testWidgets('a sortable header turns foreground on hover in $mode', (
      tester,
    ) async {
      Color? labelColor(String text) => tester
          .renderObject<RenderParagraph>(find.text(text))
          .text
          .style
          ?.color;

      await tester.pumpHeroUi(_table(), mode: mode);
      await tester.pumpAndSettle();
      expectCssColor(
        labelColor('Name')!,
        heroUiCase('table-primary-column-sort', mode: mode).styles['color']!,
      );

      await tester.hoverCenter(find.text('Name'));
      expectCssColor(
        labelColor('Name')!,
        heroUiCase(
          'table-primary-hover-column-sort',
          mode: mode,
          state: true,
        ).styles['color']!,
      );
    }, variant: desktopOnly);

    testWidgets('a selectable table keeps its row heights in $mode', (
      tester,
    ) async {
      await tester.pumpHeroUi(_table(selectable: true), mode: mode);
      await tester.pumpAndSettle();
      // The selection checkbox does not grow a row or the header.
      expect(
        tester.getSize(_rowBox('Ada')).height,
        heroUiCase('table-primary-select-row-first', mode: mode).size.height,
      );
      expect(
        tester.getSize(_rowBox('Name')).height,
        heroUiCase('table-primary-select-column-start', mode: mode).size.height,
      );
    });
  }

  testWidgets('the footer is padded like table__footer', (tester) async {
    await tester.pumpHeroUi(_table());
    await tester.pumpAndSettle();
    final footer = heroUiCase('table-primary-footer');
    expect(
      _spec(tester).footer.spec.boxSpec.padding,
      EdgeInsets.fromLTRB(
        footer.px('paddingLeft'),
        footer.px('paddingTop'),
        footer.px('paddingRight'),
        footer.px('paddingBottom'),
      ),
    );
  });

  testWidgets('the frame radius is min(32, 2.5 * radius), the card 2xl', (
    tester,
  ) async {
    BorderRadius? radius() =>
        (_spec(tester).container.spec.decoration as BoxDecoration?)
                ?.borderRadius
            as BorderRadius?;

    await tester.pumpHeroUi(_table());
    await tester.pumpAndSettle();
    expect(
      radius(),
      BorderRadius.circular(
        heroUiCase('table-primary-root').px('borderRadius'),
      ),
    );

    await tester.pumpHeroUi(_table(variant: .secondary));
    await tester.pumpAndSettle();
    // --radius-2xl; the measured header cards round to the same 16.
    expect(radius(), BorderRadius.circular(16));
    expect(
      heroUiCase('table-secondary-column-start').styles['borderRadius'],
      '16px 0px 0px 16px',
    );

    const large = HeroUiThemeData.light(radius: 24);
    await tester.pumpHeroUi(_table(), theme: large);
    await tester.pumpAndSettle();
    expect(radius(), BorderRadius.circular(32));

    await tester.pumpHeroUi(_table(variant: .secondary), theme: large);
    await tester.pumpAndSettle();
    expect(radius(), BorderRadius.circular(32));
  });

  testWidgets('activating a sortable header reports the sort through Remix', (
    tester,
  ) async {
    RemixDataTableSort? sort;
    await tester.pumpHeroUi(_table(onSort: (next) => sort = next));
    await tester.tap(find.text('Name'));
    expect(
      sort,
      const RemixDataTableSort(
        columnId: 'name',
        direction: RemixDataTableSortDirection.ascending,
      ),
    );
  });

  testWidgets('the selection checkbox takes the HeroUI checkbox', (
    tester,
  ) async {
    Set<Object>? selection;
    await tester.pumpHeroUi(
      _table(selectable: true, onSelection: (next) => selection = next),
    );
    await tester.pumpAndSettle();
    final control = tester
        .widget<StyleSpecProvider<CheckboxSpec>>(
          find.byType(StyleSpecProvider<CheckboxSpec>).first,
        )
        .spec
        .spec;
    expect(
      control.container.spec.constraints,
      BoxConstraints.tight(heroUiCase('checkbox-primary-rest-control').size),
    );

    await tester.tap(find.byType(RemixCheckbox).at(1));
    await tester.pumpAndSettle();
    expect(selection, {'1'});
  });

  testWidgets('a caller style wins over the recipe', (tester) async {
    const override = Color(0xFF00FF00);
    await tester.pumpHeroUi(_table(style: DataTableStyler().color(override)));
    await tester.pumpAndSettle();
    expect(_frame(tester), override);
  });
}
