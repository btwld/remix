import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Integration Test Verification', () {
    testWidgets('Test 1: Shows "TEST 1 RUNNING"', (WidgetTester tester) async {
      print('🟢 TEST 1 STARTED');
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.green,
            body: Center(
              child: Text(
                'TEST 1 RUNNING',
                style: TextStyle(fontSize: 48, color: Colors.white),
              ),
            ),
          ),
        ),
      );
      
      expect(find.text('TEST 1 RUNNING'), findsOneWidget);
      
      // Wait a bit so we can see it
      await tester.pump(const Duration(seconds: 1));
      
      print('✅ TEST 1 COMPLETED');
    });

    testWidgets('Test 2: Shows "TEST 2 RUNNING"', (WidgetTester tester) async {
      print('🟢 TEST 2 STARTED');
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.blue,
            body: Center(
              child: Text(
                'TEST 2 RUNNING',
                style: TextStyle(fontSize: 48, color: Colors.white),
              ),
            ),
          ),
        ),
      );
      
      expect(find.text('TEST 2 RUNNING'), findsOneWidget);
      
      // Wait a bit so we can see it
      await tester.pump(const Duration(seconds: 1));
      
      print('✅ TEST 2 COMPLETED');
    });

    testWidgets('Test 3: Shows "TEST 3 - FINAL"', (WidgetTester tester) async {
      print('🟢 TEST 3 STARTED');
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.purple,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'TEST 3 - FINAL',
                    style: TextStyle(fontSize: 48, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'ALL TESTS COMPLETE!',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: const Text(
                      '✅ Integration tests are working!\n'
                      'You should have seen:\n'
                      '1. Green screen with TEST 1\n'
                      '2. Blue screen with TEST 2\n'
                      '3. This purple screen',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      
      expect(find.text('TEST 3 - FINAL'), findsOneWidget);
      expect(find.text('ALL TESTS COMPLETE!'), findsOneWidget);
      
      // Wait longer on the final test
      await tester.pump(const Duration(seconds: 2));
      
      print('✅ TEST 3 COMPLETED');
      print('🎉 ALL INTEGRATION TESTS PASSED!');
    });
  });
}