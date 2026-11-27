import 'dart:math' as math;

import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:remix/src/utilities/remix_path_icon.dart';

import '../../helpers/test_helpers.dart';

class _Record {
  const _Record(this.id, this.name);

  final String id;
  final String name;
}

const _records = [_Record('a', 'Ada'), _Record('b', 'Blaise')];

const _tint = Color(0xFF111111);
const _headerTint = Color(0xFF222222);
const _hover = Color(0xFF333333);
const _ascending = Color(0xFF444444);
const _descending = Color(0xFF555555);
const _base = Color(0xFF666666);

final _columns = [
  RemixDataTableColumn<_Record>(
    id: 'name',
    label: 'Name',
    sortable: true,
    cellBuilder: (context, row) => Text(row.name),
  ),
  RemixDataTableColumn<_Record>(
    id: 'id',
    label: 'Id',
    sortable: true,
    cellBuilder: (context, row) => Text(row.id),
  ),
];

Widget _table({
  required DataTableStyler style,
  RemixDataTableSort? sort,
  bool selectable = false,
}) {
  return SizedBox(
    width: 400,
    child: RemixDataTable<_Record>(
      rows: _records,
      columns: _columns,
      sort: sort,
      onSortChanged: (_) {},
      rowId: selectable ? (row) => row.id : null,
      onSelectionChanged: selectable ? (_) {} : null,
      style: style,
    ),
  );
}

RemixDataTableSort _sortBy(String id, RemixDataTableSortDirection direction) =>
    RemixDataTableSort(columnId: id, direction: direction);

/// Fill of the outer row box painted by the cell that holds [text].
Color? _rowFill(WidgetTester tester, String text) {
  final box = tester.widget<Box>(
    find.ancestor(of: find.text(text), matching: find.byType(Box)).at(1),
  );

  return (box.styleSpec?.spec.decoration as BoxDecoration?)?.color;
}

/// Fill of the inner cell box that holds [text].
Color? _cellFill(WidgetTester tester, String text) {
  final box = tester.widget<Box>(
    find.ancestor(of: find.text(text), matching: find.byType(Box)).first,
  );

  return (box.styleSpec?.spec.decoration as BoxDecoration?)?.color;
}

Finder _sortIconIn(String label) => find.descendant(
  of: find.ancestor(of: find.text(label), matching: find.byType(Row)).first,
  matching: find.byType(RemixPathIcon),
);

void main() {
  group('RemixDataTable sorted column', () {
    final style = DataTableStyler().onSorted(
      DataTableStyler()
          .headerCell(BoxStyler().color(_headerTint))
          .bodyCell(BoxStyler().color(_tint)),
    );

    testWidgets('tints the header and body cells of the sorted column only', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        _table(
          style: style,
          sort: _sortBy('name', RemixDataTableSortDirection.ascending),
        ),
      );

      expect(_cellFill(tester, 'Name'), _headerTint);
      expect(_cellFill(tester, 'Ada'), _tint);
      expect(_cellFill(tester, 'Blaise'), _tint);
      expect(_cellFill(tester, 'Id'), isNull);
      expect(_cellFill(tester, 'a'), isNull);
      expect(_cellFill(tester, 'b'), isNull);
    });

    testWidgets('moves the tint when the sort moves to another column', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        _table(
          style: style,
          sort: _sortBy('name', RemixDataTableSortDirection.ascending),
        ),
      );
      await tester.pumpRemixApp(
        _table(
          style: style,
          sort: _sortBy('id', RemixDataTableSortDirection.descending),
        ),
      );

      expect(_cellFill(tester, 'Ada'), isNull);
      expect(_cellFill(tester, 'Id'), _headerTint);
      expect(_cellFill(tester, 'a'), _tint);
    });

    testWidgets('applies to no cell while the table is unsorted', (
      tester,
    ) async {
      await tester.pumpRemixApp(_table(style: style, selectable: true));

      for (final text in ['Name', 'Id', 'Ada', 'Blaise', 'a', 'b']) {
        expect(_cellFill(tester, text), isNull, reason: text);
      }
    });

    testWidgets('never applies to the selection column or the container', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        _table(
          style: DataTableStyler().onSorted(
            DataTableStyler()
                .container(BoxStyler().color(_tint))
                .selectionCell(BoxStyler().color(_tint)),
          ),
          sort: _sortBy('name', RemixDataTableSortDirection.ascending),
          selectable: true,
        ),
      );

      final fills = tester
          .widgetList<Box>(find.byType(Box))
          .map(
            (box) => (box.styleSpec?.spec.decoration as BoxDecoration?)?.color,
          );
      expect(fills, isNot(contains(_tint)));
      expect(find.byType(RemixCheckbox), findsNWidgets(3));
    });

    testWidgets('resolves the direction variants against the sort direction', (
      tester,
    ) async {
      final directional = DataTableStyler()
          .onSortedAscending(
            DataTableStyler().sortIcon(IconStyler().color(_ascending)),
          )
          .onSortedDescending(
            DataTableStyler().sortIcon(
              IconStyler()
                  .color(_descending)
                  .wrap(WidgetModifierConfig.rotate(radians: math.pi)),
            ),
          );
      Color? iconColor(String label) =>
          tester.widget<RemixPathIcon>(_sortIconIn(label)).styleSpec.spec.color;
      Finder rotation(String label) => find.descendant(
        of: _sortIconIn(label),
        matching: find.byType(Transform),
      );

      await tester.pumpRemixApp(
        _table(
          style: directional,
          sort: _sortBy('name', RemixDataTableSortDirection.ascending),
        ),
      );
      expect(iconColor('Name'), _ascending);
      expect(iconColor('Id'), isNull);
      expect(rotation('Name'), findsNothing);

      await tester.pumpRemixApp(
        _table(
          style: directional,
          sort: _sortBy('name', RemixDataTableSortDirection.descending),
        ),
      );
      expect(iconColor('Name'), _descending);
      expect(rotation('Name'), findsOneWidget);
      expect(rotation('Id'), findsNothing);
    });

    testWidgets('a hovered row keeps its hover fill inside the sorted column', (
      tester,
    ) async {
      // Declared before onSorted on purpose: precedence comes from Mix's
      // widget-state ranking, not declaration order.
      await tester.pumpRemixApp(
        _table(
          style: DataTableStyler()
              .bodyRow(BoxStyler().color(_base))
              .onHovered(DataTableStyler().bodyRow(BoxStyler().color(_hover)))
              .onSorted(DataTableStyler().bodyRow(BoxStyler().color(_tint))),
          sort: _sortBy('name', RemixDataTableSortDirection.ascending),
        ),
      );

      final pointer = TestPointer(1, PointerDeviceKind.mouse);
      await tester.sendEventToBinding(
        pointer.hover(tester.getCenter(find.text('Ada'))),
      );
      await tester.pump();

      expect(_rowFill(tester, 'Ada'), _hover);
      expect(_rowFill(tester, 'Blaise'), _tint);
      expect(_rowFill(tester, 'a'), _hover);
      expect(_rowFill(tester, 'b'), _base);
    });
  });
}
