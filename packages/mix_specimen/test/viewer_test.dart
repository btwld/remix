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

/// A cell that pushes an overlay route onto the local [SpecimenOverlayHost]
/// Navigator, mirroring how the Dialog specimen opens its modal.
class _PushingCell extends StatefulWidget {
  const _PushingCell(this.label);
  final String label;

  @override
  State<_PushingCell> createState() => _PushingCellState();
}

class _PushingCellState extends State<_PushingCell> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.of(context).push(
        PageRouteBuilder<void>(
          opaque: false,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
          pageBuilder: (context, animation, secondaryAnimation) =>
              Center(child: Text(widget.label)),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox(width: 40, height: 40);
}

/// Two specimens whose cells share the `SizedBox > SpecimenOverlayHost` shape,
/// so their local Navigators reuse the same element across a specimen switch.
SpecimenCatalog _overlayCatalog() => SpecimenCatalog(
  id: 'overlays',
  themes: [
    SpecimenTheme(
      'day',
      background: Colors.white,
      builder: (_, child) => child,
    ),
  ],
  specimens: [
    Specimen(
      id: 'first',
      scenarios: const [SpecimenScenario('rest')],
      rows: [
        SpecimenRow(
          'plain',
          (context, sim) => const SizedBox(
            width: 120,
            height: 80,
            child: SpecimenOverlayHost(child: _PushingCell('leak-first')),
          ),
        ),
      ],
    ),
    Specimen(
      id: 'second',
      scenarios: const [SpecimenScenario('rest')],
      rows: [
        SpecimenRow(
          'plain',
          (context, sim) => const SizedBox(
            width: 120,
            height: 80,
            child: SpecimenOverlayHost(
              child: Center(child: Text('second-cell')),
            ),
          ),
        ),
      ],
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

  testWidgets('switching specimens disposes stale overlay-host routes', (
    tester,
  ) async {
    final catalog = _overlayCatalog();
    final controller = SpecimenViewerController(catalog);
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: SpecimenCatalogViewer(catalog: catalog, controller: controller),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('leak-first'), findsOneWidget);

    controller.select(specimenId: 'second');
    await tester.pumpAndSettle();
    expect(find.text('second-cell'), findsOneWidget);
    expect(find.text('leak-first'), findsNothing);
  });
}
