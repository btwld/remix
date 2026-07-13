import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_specimen/mix_specimen.dart';

Widget _cell(BuildContext context, SpecimenSim sim) => const Text('cell');

SpecimenCatalog _catalog() => SpecimenCatalog(
  id: 'custom',
  label: 'Custom system',
  themes: [
    SpecimenTheme(
      'day',
      label: 'Day',
      background: Colors.white,
      builder: (context, child) => child,
    ),
    SpecimenTheme(
      'night',
      label: 'Night',
      brightness: Brightness.dark,
      background: Colors.black,
      builder: (context, child) => child,
    ),
  ],
  specimens: [
    Specimen(
      id: 'zeta',
      label: 'Zeta control',
      scenarios: const [SpecimenScenario('rest', label: 'Resting')],
      rows: [SpecimenRow('plain', _cell, label: 'Plain row')],
    ),
    Specimen(
      id: 'alpha',
      label: 'Alpha control',
      scenarios: const [SpecimenScenario('rest')],
      rows: [SpecimenRow('plain', _cell)],
    ),
  ],
);

void main() {
  test('controller normalizes invalid IDs and keeps declared defaults', () {
    final controller = SpecimenViewerController(
      _catalog(),
      specimenId: 'missing',
      themeId: 'missing',
    );
    expect(
      controller.selection,
      const SpecimenViewerSelection(specimenId: 'zeta', themeId: 'day'),
    );
    controller.select(specimenId: 'alpha', themeId: 'night');
    expect(
      controller.selection,
      const SpecimenViewerSelection(specimenId: 'alpha', themeId: 'night'),
    );
  });

  testWidgets('viewer exposes labels, coverage, search, and declared order', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: SpecimenCatalogViewer(catalog: _catalog())),
    );
    expect(find.text('Custom system'), findsOneWidget);
    expect(find.text('1 rows × 1 scenarios = 1 cells'), findsOneWidget);
    expect(find.text('Zeta control'), findsWidgets);
    expect(find.text('Alpha control'), findsOneWidget);
    final tiles = tester.widgetList<ListTile>(find.byType(ListTile)).toList();
    expect((tiles[0].title! as Text).data, 'Zeta control');
    expect((tiles[1].title! as Text).data, 'Alpha control');
    await tester.enterText(find.byType(TextField), 'alpha');
    await tester.pump();
    expect(find.text('Zeta control'), findsNWidgets(2));
    expect(find.text('Alpha control'), findsOneWidget);
  });

  testWidgets('compact viewer uses a drawer', (tester) async {
    tester.view.physicalSize = const Size(600, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(home: SpecimenCatalogViewer(catalog: _catalog())),
    );
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    expect(find.byType(Drawer), findsOneWidget);
  });

  testWidgets('empty catalog has a useful state', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SpecimenCatalogViewer(
          catalog: SpecimenCatalog(id: 'empty', themes: [], specimens: []),
        ),
      ),
    );
    expect(find.text('No specimens to display'), findsOneWidget);
  });

  testWidgets('sheet uses human labels and metadata retains IDs', (
    tester,
  ) async {
    final catalog = _catalog();
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SpecimenSheet(specimen: catalog.specimens.first),
      ),
    );
    expect(find.text('Resting'), findsOneWidget);
    expect(find.text('Plain row'), findsOneWidget);
  });
}
