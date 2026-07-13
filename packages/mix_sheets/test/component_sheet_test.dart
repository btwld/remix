import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_sheets/golden.dart';
import 'package:mix_sheets/mix_sheets.dart';

Widget _cell(BuildContext context, SheetCellContext cell) => const SizedBox();

void main() {
  testWidgets('legacy rows use their IDs without group headers', (
    tester,
  ) async {
    final sheet = ComponentSheet(
      id: 'legacy',
      scenarios: const [SheetScenario('default')],
      rows: [SheetRow('solid', _cell)],
    );
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SheetView(sheet: sheet),
      ),
    );
    expect(find.text('solid'), findsOneWidget);
  });

  testWidgets('one axis labels rows without sections', (tester) async {
    final sheet = ComponentSheet(
      id: 'one-axis',
      rowAxes: const [SheetAxis('size', 'Size')],
      scenarios: const [SheetScenario('default')],
      rows: [
        SheetRow(
          'size1',
          _cell,
          values: const {'size': SheetAxisValue('size1', 'Size 1')},
        ),
      ],
    );
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SheetView(sheet: sheet),
      ),
    );
    expect(find.text('Size 1'), findsOneWidget);
    expect(find.text('Size'), findsNothing);
  });

  testWidgets('arbitrary nested axes render headers without building cells', (
    tester,
  ) async {
    var builds = 0;
    Widget builder(BuildContext context, SheetCellContext cell) {
      builds++;
      return const SizedBox();
    }

    final sheet = ComponentSheet(
      id: 'nested',
      rowAxes: const [
        SheetAxis('tone', 'Tone'),
        SheetAxis('density', 'Density'),
        SheetAxis('scale', 'Scale'),
      ],
      scenarios: const [SheetScenario('default')],
      rows: [
        SheetRow(
          'a',
          builder,
          values: const {
            'tone': SheetAxisValue('warm', 'Warm'),
            'density': SheetAxisValue('compact', 'Compact'),
            'scale': SheetAxisValue('small', 'Small'),
          },
        ),
        SheetRow(
          'b',
          builder,
          values: const {
            'tone': SheetAxisValue('cool', 'Cool'),
            'density': SheetAxisValue('compact', 'Compact'),
            'scale': SheetAxisValue('large', 'Large'),
          },
        ),
      ],
    );
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SheetView(sheet: sheet),
      ),
    );
    expect(find.text('Warm'), findsOneWidget);
    expect(find.text('Cool'), findsOneWidget);
    expect(find.text('Compact'), findsNWidgets(2));
    expect(builds, 2);
  });

  test('invalid matrices fail deterministically', () {
    ComponentSheet sheet({
      List<SheetAxis> axes = const [SheetAxis('size', 'Size')],
      Map<String, SheetAxisValue> values = const {},
      List<SheetScenario> scenarios = const [SheetScenario('default')],
    }) => ComponentSheet(
      id: 'invalid',
      rowAxes: axes,
      scenarios: scenarios,
      rows: [SheetRow('row', _cell, values: values)],
    );

    expect(sheet().validate, throwsArgumentError);
    expect(
      () => sheet(
        values: const {
          'size': SheetAxisValue('size1', 'Size 1'),
          'unknown': SheetAxisValue('x', 'X'),
        },
      ).validate(),
      throwsArgumentError,
    );
    expect(
      () => sheet(
        scenarios: const [SheetScenario('same'), SheetScenario('same')],
        values: const {'size': SheetAxisValue('size1', 'Size 1')},
      ).validate(),
      throwsArgumentError,
    );
    final duplicateCombination = ComponentSheet(
      id: 'duplicate',
      rowAxes: const [SheetAxis('size', 'Size')],
      scenarios: const [SheetScenario('default')],
      rows: [
        SheetRow(
          'a',
          _cell,
          values: const {'size': SheetAxisValue('size1', 'Size 1')},
        ),
        SheetRow(
          'b',
          _cell,
          values: const {'size': SheetAxisValue('size1', 'Size One')},
        ),
      ],
    );
    expect(duplicateCombination.validate, throwsArgumentError);
  });

  test('structured metadata uses the sheet v1 schema', () {
    final sheet = ComponentSheet(
      id: 'button',
      rowAxes: const [SheetAxis('size', 'Size')],
      scenarios: const [SheetScenario('default')],
      rows: [
        SheetRow(
          'size1',
          _cell,
          values: const {'size': SheetAxisValue('size1', 'Size 1')},
        ),
      ],
    );
    final metadata = componentSheetMetadata(
      sheet,
      SheetTheme(
        'light',
        background: const Color(0xFFFFFFFF),
        builder: (context, child) => child,
      ),
    );
    expect(metadata['schema'], 'mix_sheets/sheet/v1');
    expect(metadata['rowAxes'], [
      {'id': 'size', 'label': 'Size'},
    ]);
    expect(metadata['rows'], [
      {
        'id': 'size1',
        'values': {
          'size': {'id': 'size1', 'label': 'Size 1'},
        },
      },
    ]);
  });
}
