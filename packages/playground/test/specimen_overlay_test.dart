import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_specimen/mix_specimen.dart';
import 'package:playground/specimens/fortal_catalog.dart';
import 'package:remix/remix.dart';

void main() {
  testWidgets('open select stays inside its local overlay host', (
    tester,
  ) async {
    final select = fortalCatalog.specimens.firstWhere(
      (item) => item.id == 'select',
    );
    final specimen = Specimen(
      id: 'select-open-spike',
      scenarios: [select.scenarios.firstWhere((item) => item.id == 'open')],
      rows: [select.rows.first],
      rowAxes: select.rowAxes,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: FortalScope(
          child: Align(
            alignment: Alignment.topLeft,
            child: SpecimenSheet(specimen: specimen),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    final anchors = tester.widgetList<RawMenuAnchor>(
      find.byType(RawMenuAnchor),
    );
    expect(anchors.any((anchor) => anchor.controller.isOpen), isTrue);
    expect(find.text('Option one'), findsOneWidget);
    final host = tester.getRect(find.byType(SpecimenOverlayHost));
    final option = tester.getRect(find.text('Option one'));
    expect(host.contains(option.topLeft), isTrue);
    expect(host.contains(option.bottomRight), isTrue);
  });
}
