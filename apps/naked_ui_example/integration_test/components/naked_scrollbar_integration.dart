import 'package:naked_ui_example/api/naked_scrollbar.0.dart'
    as scrollbar_example;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('NakedScrollbar Integration Tests', () {
    testWidgets('dragging the thumb changes the scroll offset', (tester) async {
      await tester.pumpWidget(const scrollbar_example.MyApp());
      await tester.pumpAndSettle();

      final list = tester.widget<ListView>(find.byType(ListView));
      final controller =
          list.controller ??
          PrimaryScrollController.of(tester.element(find.byType(ListView)));
      expect(controller.offset, 0);

      final box = tester.getRect(find.byType(ListView));
      await tester.dragFrom(
        box.topRight - const Offset(4, -40),
        const Offset(0, 100),
      );
      await tester.pumpAndSettle();
      expect(controller.offset, greaterThan(0));
    });
  });
}
