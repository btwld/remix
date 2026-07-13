import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_specimen/golden.dart';
import 'package:mix_specimen/mix_specimen.dart';

Widget _cell(BuildContext context, SpecimenSim sim) => const SizedBox();

void main() {
  testWidgets('legacy rows use their IDs without group headers', (
    tester,
  ) async {
    final specimen = Specimen(
      id: 'legacy',
      scenarios: const [SpecimenScenario('default')],
      rows: [SpecimenRow('solid', _cell)],
    );
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SpecimenSheet(specimen: specimen),
      ),
    );
    expect(find.text('solid'), findsOneWidget);
  });

  testWidgets('one axis labels rows without sections', (tester) async {
    final specimen = Specimen(
      id: 'one-axis',
      rowAxes: const [SpecimenAxis('size', 'Size')],
      scenarios: const [SpecimenScenario('default')],
      rows: [
        SpecimenRow(
          'size1',
          _cell,
          values: const {'size': SpecimenAxisValue('size1', 'Size 1')},
        ),
      ],
    );
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SpecimenSheet(specimen: specimen),
      ),
    );
    expect(find.text('Size 1'), findsOneWidget);
    expect(find.text('Size'), findsNothing);
  });

  testWidgets('arbitrary nested axes render headers without building cells', (
    tester,
  ) async {
    var builds = 0;
    Widget builder(BuildContext context, SpecimenSim sim) {
      builds++;
      return const SizedBox();
    }

    final specimen = Specimen(
      id: 'nested',
      rowAxes: const [
        SpecimenAxis('tone', 'Tone'),
        SpecimenAxis('density', 'Density'),
        SpecimenAxis('scale', 'Scale'),
      ],
      scenarios: const [SpecimenScenario('default')],
      rows: [
        SpecimenRow(
          'a',
          builder,
          values: const {
            'tone': SpecimenAxisValue('warm', 'Warm'),
            'density': SpecimenAxisValue('compact', 'Compact'),
            'scale': SpecimenAxisValue('small', 'Small'),
          },
        ),
        SpecimenRow(
          'b',
          builder,
          values: const {
            'tone': SpecimenAxisValue('cool', 'Cool'),
            'density': SpecimenAxisValue('compact', 'Compact'),
            'scale': SpecimenAxisValue('large', 'Large'),
          },
        ),
      ],
    );
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SpecimenSheet(specimen: specimen),
      ),
    );
    expect(find.text('Warm'), findsOneWidget);
    expect(find.text('Cool'), findsOneWidget);
    expect(find.text('Compact'), findsNWidgets(2));
    expect(builds, 2);
  });

  test('invalid matrices fail deterministically', () {
    Specimen specimen({
      List<SpecimenAxis> axes = const [SpecimenAxis('size', 'Size')],
      Map<String, SpecimenAxisValue> values = const {},
      List<SpecimenScenario> scenarios = const [SpecimenScenario('default')],
    }) => Specimen(
      id: 'invalid',
      rowAxes: axes,
      scenarios: scenarios,
      rows: [SpecimenRow('row', _cell, values: values)],
    );

    expect(specimen().validate, throwsArgumentError);
    expect(
      () => specimen(
        values: const {
          'size': SpecimenAxisValue('size1', 'Size 1'),
          'unknown': SpecimenAxisValue('x', 'X'),
        },
      ).validate(),
      throwsArgumentError,
    );
    expect(
      () => specimen(
        scenarios: const [SpecimenScenario('same'), SpecimenScenario('same')],
        values: const {'size': SpecimenAxisValue('size1', 'Size 1')},
      ).validate(),
      throwsArgumentError,
    );
    final duplicateCombination = Specimen(
      id: 'duplicate',
      rowAxes: const [SpecimenAxis('size', 'Size')],
      scenarios: const [SpecimenScenario('default')],
      rows: [
        SpecimenRow(
          'a',
          _cell,
          values: const {'size': SpecimenAxisValue('size1', 'Size 1')},
        ),
        SpecimenRow(
          'b',
          _cell,
          values: const {'size': SpecimenAxisValue('size1', 'Size One')},
        ),
      ],
    );
    expect(duplicateCombination.validate, throwsArgumentError);
  });

  test('structured metadata uses the sheet v1 schema', () {
    final specimen = Specimen(
      id: 'button',
      rowAxes: const [SpecimenAxis('size', 'Size')],
      scenarios: const [SpecimenScenario('default')],
      rows: [
        SpecimenRow(
          'size1',
          _cell,
          values: const {'size': SpecimenAxisValue('size1', 'Size 1')},
        ),
      ],
    );
    final metadata = specimenSheetMetadata(
      specimen,
      SpecimenTheme(
        'light',
        background: const Color(0xFFFFFFFF),
        builder: (context, child) => child,
      ),
    );
    expect(metadata['schema'], 'mix_specimen/sheet/v1');
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
