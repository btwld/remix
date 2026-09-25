import 'package:naked_ui_example/api/naked_menubar.0.dart' as menubar_example;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('NakedMenubar Integration Tests', () {
    testWidgets('opening Edit closes File', (tester) async {
      await tester.pumpWidget(const menubar_example.MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('File'));
      await tester.pumpAndSettle();
      expect(find.text('New'), findsOneWidget);

      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();
      expect(find.text('New'), findsNothing);
      expect(find.text('Copy'), findsOneWidget);
    });
  });
}
