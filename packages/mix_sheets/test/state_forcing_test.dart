import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_sheets/mix_sheets.dart';

void main() {
  testWidgets('sheet cells force scenario states into style resolution', (
    tester,
  ) async {
    const baseColor = Color(0xFFFFFFFF);
    const hoverColor = Color(0xFF2196F3);
    final resolvedColors = <String, Color?>{};

    final sheet = ComponentSheet(
      id: 'box',
      scenarios: const [SheetScenarios.base, SheetScenarios.hovered],
      rows: [
        SheetRow('base', (context, cell) {
          final spec = cell.resolve(
            context,
            BoxStyler()
                .color(baseColor)
                .onHovered(BoxStyler().color(hoverColor)),
          );
          final decoration = spec.spec.decoration as BoxDecoration?;
          resolvedColors[cell.scenario.id] = decoration?.color;

          return const SizedBox(width: 10, height: 10);
        }),
      ],
    );

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SheetView(sheet: sheet),
      ),
    );

    expect(resolvedColors['default'], baseColor);
    expect(resolvedColors['hovered'], hoverColor);
  });
}
