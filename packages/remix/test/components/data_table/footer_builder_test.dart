import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

const _footerKey = ValueKey('footer');
const _footerColor = Color(0xFF123456);

Widget _table({
  WidgetBuilder? footerBuilder,
  List<String> rows = const ['Ada', 'Blaise'],
  bool paginated = false,
  double minimumWidth = 0,
}) {
  return SizedBox(
    width: 300,
    child: RemixDataTable<String>(
      rows: rows,
      columns: [
        RemixDataTableColumn<String>(
          id: 'name',
          label: 'Name',
          cellBuilder: (context, row) => Text(row),
        ),
      ],
      minimumWidth: minimumWidth,
      footerBuilder: footerBuilder,
      totalRows: paginated ? rows.length : null,
      onPageChanged: paginated ? (_) {} : null,
      onPageSizeChanged: paginated ? (_) {} : null,
      style: DataTableStyler().footerLabelColor(_footerColor),
    ),
  );
}

Widget _footer(BuildContext context) =>
    const Text('2 selected', key: _footerKey);

void main() {
  group('RemixDataTable.footerBuilder', () {
    testWidgets('renders nothing extra by default', (tester) async {
      await tester.pumpRemixApp(_table());

      expect(find.byKey(_footerKey), findsNothing);
      expect(find.text('2 selected'), findsNothing);
    });

    testWidgets('pins the footer below the last row with footer typography', (
      tester,
    ) async {
      await tester.pumpRemixApp(_table(footerBuilder: _footer));

      final footer = tester.getRect(find.byKey(_footerKey));
      expect(
        footer.top,
        greaterThanOrEqualTo(tester.getRect(find.text('Blaise')).bottom),
      );
      final rendered = tester
          .widget<RichText>(
            find.descendant(
              of: find.byKey(_footerKey),
              matching: find.byType(RichText),
            ),
          )
          .text
          .style;
      expect(rendered?.color, _footerColor);
    });

    testWidgets('renders with an empty page', (tester) async {
      await tester.pumpRemixApp(_table(footerBuilder: _footer, rows: const []));

      expect(find.byKey(_footerKey), findsOneWidget);
    });

    testWidgets('sits above the pagination footer', (tester) async {
      await tester.pumpRemixApp(
        _table(footerBuilder: _footer, paginated: true),
      );

      expect(
        tester.getRect(find.byKey(_footerKey)).bottom,
        lessThanOrEqualTo(tester.getRect(find.text('Rows per page')).top),
      );
    });

    testWidgets('stays outside the horizontal scroller', (tester) async {
      await tester.pumpRemixApp(
        _table(footerBuilder: _footer, minimumWidth: 900),
      );

      expect(
        find.ancestor(
          of: find.byKey(_footerKey),
          matching: find.byType(SingleChildScrollView),
        ),
        findsNothing,
      );
      expect(
        find.ancestor(
          of: find.text('Blaise'),
          matching: find.byType(SingleChildScrollView),
        ),
        findsOneWidget,
      );
    });

    testWidgets('stays outside the table semantics node', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpRemixApp(_table(footerBuilder: _footer));

      expect(
        find.ancestor(
          of: find.byKey(_footerKey),
          matching: find.byWidgetPredicate((widget) => widget is Table),
        ),
        findsNothing,
      );
      expect(find.bySemanticsLabel('2 selected'), findsOneWidget);
      handle.dispose();
    });
  });
}
