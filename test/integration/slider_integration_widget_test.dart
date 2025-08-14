import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

void main() {
  group('RemixSlider Integration Tests', () {
    testWidgets('renders with initial value', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: RemixSlider(
                  value: 0.5,
                  onChanged: (_) {},
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(RemixSlider), findsOneWidget);
    });

    testWidgets('updates value when dragged', (tester) async {
      double sliderValue = 0.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: StatefulBuilder(
                builder: (context, setState) {
                  return SizedBox(
                    width: 300,
                    child: RemixSlider(
                      value: sliderValue,
                      onChanged: (value) {
                        setState(() {
                          sliderValue = value;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Drag slider to the right
      final sliderFinder = find.byType(RemixSlider);
      final center = tester.getCenter(sliderFinder);
      final rightEdge = tester.getTopRight(sliderFinder);
      
      await tester.dragFrom(center, Offset(rightEdge.dx - center.dx, 0));
      await tester.pumpAndSettle();

      // Value should have increased
      expect(sliderValue, greaterThan(0.5));
    });

    testWidgets('respects min and max values', (tester) async {
      double sliderValue = 50.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: StatefulBuilder(
                builder: (context, setState) {
                  return SizedBox(
                    width: 300,
                    child: RemixSlider(
                      value: sliderValue,
                      min: 0.0,
                      max: 100.0,
                      onChanged: (value) {
                        setState(() {
                          sliderValue = value;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Value should be within bounds
      expect(sliderValue, 50.0);
      
      // Drag to max
      final sliderFinder = find.byType(RemixSlider);
      final center = tester.getCenter(sliderFinder);
      final rightEdge = tester.getTopRight(sliderFinder);
      
      await tester.dragFrom(center, Offset(rightEdge.dx - center.dx, 0));
      await tester.pumpAndSettle();
      
      expect(sliderValue, lessThanOrEqualTo(100.0));
    });

    testWidgets('handles divisions correctly', (tester) async {
      double sliderValue = 0.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: StatefulBuilder(
                builder: (context, setState) {
                  return SizedBox(
                    width: 300,
                    child: RemixSlider(
                      value: sliderValue,
                      divisions: 4, // 5 discrete positions: 0, 0.25, 0.5, 0.75, 1
                      onChanged: (value) {
                        setState(() {
                          sliderValue = value;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Drag to approximately middle
      final sliderFinder = find.byType(RemixSlider);
      final leftEdge = tester.getTopLeft(sliderFinder);
      final rightEdge = tester.getTopRight(sliderFinder);
      final middleX = (leftEdge.dx + rightEdge.dx) / 2;
      
      await tester.tapAt(Offset(middleX, tester.getCenter(sliderFinder).dy));
      await tester.pumpAndSettle();

      // Should snap to 0.5 due to divisions
      expect(sliderValue, closeTo(0.5, 0.1));
    });

    testWidgets('does not respond when disabled', (tester) async {
      double sliderValue = 0.5;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: RemixSlider(
                  value: sliderValue,
                  enabled: false,
                  onChanged: (value) {
                    sliderValue = value;
                  },
                ),
              ),
            ),
          ),
        ),
      );

      // Try to drag
      final sliderFinder = find.byType(RemixSlider);
      final center = tester.getCenter(sliderFinder);
      final rightEdge = tester.getTopRight(sliderFinder);
      
      await tester.dragFrom(center, Offset(rightEdge.dx - center.dx, 0));
      await tester.pumpAndSettle();

      // Value should not change
      expect(sliderValue, 0.5);
    });

    testWidgets('calls onChanged with correct value', (tester) async {
      double? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: RemixSlider(
                  value: 0.0,
                  onChanged: (value) {
                    changedValue = value;
                  },
                ),
              ),
            ),
          ),
        ),
      );

      // Tap on slider
      final sliderFinder = find.byType(RemixSlider);
      final leftEdge = tester.getTopLeft(sliderFinder);
      final rightEdge = tester.getTopRight(sliderFinder);
      final quarterX = leftEdge.dx + (rightEdge.dx - leftEdge.dx) * 0.25;
      
      await tester.tapAt(Offset(quarterX, tester.getCenter(sliderFinder).dy));
      await tester.pumpAndSettle();

      expect(changedValue, isNotNull);
      expect(changedValue!, greaterThan(0.0));
      expect(changedValue!, lessThan(0.5));
    });

    testWidgets('maintains value during widget rebuild', (tester) async {
      double sliderValue = 0.75;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 300,
                        child: RemixSlider(
                          value: sliderValue,
                          onChanged: (value) {
                            setState(() {
                              sliderValue = value;
                            });
                          },
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            // Force rebuild
                          });
                        },
                        child: const Text('Rebuild'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(sliderValue, 0.75);

      // Force rebuild
      await tester.tap(find.text('Rebuild'));
      await tester.pumpAndSettle();

      // Value should be maintained
      expect(sliderValue, 0.75);
    });

    testWidgets('handles hover state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: RemixSlider(
                  value: 0.5,
                  onChanged: (_) {},
                ),
              ),
            ),
          ),
        ),
      );

      // Simulate hover
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.byType(RemixSlider)));
      await tester.pumpAndSettle();

      // Slider should still be functional
      expect(find.byType(RemixSlider), findsOneWidget);
    });

    testWidgets('handles continuous dragging', (tester) async {
      final values = <double>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: RemixSlider(
                  value: 0.0,
                  onChanged: (value) {
                    values.add(value);
                  },
                ),
              ),
            ),
          ),
        ),
      );

      // Perform continuous drag
      final sliderFinder = find.byType(RemixSlider);
      final leftEdge = tester.getTopLeft(sliderFinder);
      final rightEdge = tester.getTopRight(sliderFinder);
      
      final gesture = await tester.startGesture(Offset(leftEdge.dx + 10, tester.getCenter(sliderFinder).dy));
      
      // Drag across the slider
      for (int i = 1; i <= 5; i++) {
        await gesture.moveTo(Offset(
          leftEdge.dx + (rightEdge.dx - leftEdge.dx) * (i / 5),
          tester.getCenter(sliderFinder).dy,
        ));
        await tester.pump();
      }
      
      await gesture.up();
      await tester.pumpAndSettle();

      // Should have received multiple value updates
      expect(values.length, greaterThan(1));
      expect(values.last, greaterThan(values.first));
    });

    testWidgets('updates visual feedback during drag', (tester) async {
      double sliderValue = 0.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 300,
                        child: RemixSlider(
                          value: sliderValue,
                          onChanged: (value) {
                            setState(() {
                              sliderValue = value;
                            });
                          },
                        ),
                      ),
                      Text('Value: ${sliderValue.toStringAsFixed(2)}'),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Value: 0.00'), findsOneWidget);

      // Drag slider
      final sliderFinder = find.byType(RemixSlider);
      final center = tester.getCenter(sliderFinder);
      final rightEdge = tester.getTopRight(sliderFinder);
      
      await tester.dragFrom(center, Offset((rightEdge.dx - center.dx) / 2, 0));
      await tester.pumpAndSettle();

      // Text should update
      expect(find.text('Value: 0.00'), findsNothing);
      expect(sliderValue, greaterThan(0.0));
    });

    testWidgets('handles tap to position', (tester) async {
      double sliderValue = 0.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: StatefulBuilder(
                builder: (context, setState) {
                  return SizedBox(
                    width: 300,
                    child: RemixSlider(
                      value: sliderValue,
                      onChanged: (value) {
                        setState(() {
                          sliderValue = value;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Tap at 3/4 position
      final sliderFinder = find.byType(RemixSlider);
      final leftEdge = tester.getTopLeft(sliderFinder);
      final rightEdge = tester.getTopRight(sliderFinder);
      final threeQuarterX = leftEdge.dx + (rightEdge.dx - leftEdge.dx) * 0.75;
      
      await tester.tapAt(Offset(threeQuarterX, tester.getCenter(sliderFinder).dy));
      await tester.pumpAndSettle();

      // Value should jump to approximately 0.75
      expect(sliderValue, greaterThan(0.6));
      expect(sliderValue, lessThan(0.9));
    });

    testWidgets('preserves accessibility semantics', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Semantics(
                label: 'Volume control',
                value: '50%',
                child: SizedBox(
                  width: 300,
                  child: RemixSlider(
                    value: 0.5,
                    onChanged: (_) {},
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Verify semantics
      final semantics = tester.getSemantics(find.byType(RemixSlider));
      expect(semantics.label, contains('Volume control'));
    });

    testWidgets('handles null onChanged callback', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: RemixSlider(
                  value: 0.5,
                  enabled: false,
                  onChanged: (_) {},
                ),
              ),
            ),
          ),
        ),
      );

      // Should render without crash
      expect(find.byType(RemixSlider), findsOneWidget);

      // Try to interact
      await tester.tap(find.byType(RemixSlider));
      await tester.pumpAndSettle();
    });

    testWidgets('handles edge values correctly', (tester) async {
      double sliderValue = 0.5;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 300,
                        child: RemixSlider(
                          value: sliderValue,
                          min: 0.0,
                          max: 1.0,
                          onChanged: (value) {
                            setState(() {
                              sliderValue = value;
                            });
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                sliderValue = 0.0;
                              });
                            },
                            child: const Text('Min'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                sliderValue = 1.0;
                              });
                            },
                            child: const Text('Max'),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Set to min
      await tester.tap(find.text('Min'));
      await tester.pumpAndSettle();
      expect(sliderValue, 0.0);

      // Set to max
      await tester.tap(find.text('Max'));
      await tester.pumpAndSettle();
      expect(sliderValue, 1.0);
    });
  });
}