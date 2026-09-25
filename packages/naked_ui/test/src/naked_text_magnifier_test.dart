import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

void main() {
  testWidgets('positions the lens above the caret and clamps to the screen', (
    tester,
  ) async {
    final info = ValueNotifier<MagnifierInfo>(
      const MagnifierInfo(
        globalGesturePosition: Offset(10, 80),
        caretRect: Rect.fromLTWH(10, 80, 2, 20),
        fieldBounds: Rect.fromLTWH(0, 40, 300, 80),
        currentLineBoundaries: Rect.fromLTWH(0, 80, 300, 20),
      ),
    );
    addTearDown(info.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(200, 200)),
          child: Scaffold(
            body: Stack(children: [NakedTextMagnifier(magnifierInfo: info)]),
          ),
        ),
      ),
    );

    expect(find.byType(RawMagnifier), findsOneWidget);
    final topLeft = tester.getTopLeft(find.byType(RawMagnifier));
    expect(topLeft.dx, greaterThanOrEqualTo(0));
    expect(topLeft.dy, lessThan(80));

    info.value = const MagnifierInfo(
      globalGesturePosition: Offset(-40, 80),
      caretRect: Rect.fromLTWH(0, 80, 2, 20),
      fieldBounds: Rect.fromLTWH(0, 40, 300, 80),
      currentLineBoundaries: Rect.fromLTWH(0, 80, 300, 20),
    );
    await tester.pump();
    expect(
      tester.getTopLeft(find.byType(RawMagnifier)).dx,
      greaterThanOrEqualTo(0),
    );
  });

  testWidgets('adaptive configuration is disabled on desktop', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    try {
      expect(
        identical(
          NakedTextMagnifier.adaptiveConfiguration(),
          TextMagnifierConfiguration.disabled,
        ),
        isTrue,
      );
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('adaptive configuration builds a lens on Android', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    try {
      expect(
        NakedTextMagnifier.adaptiveConfiguration().magnifierBuilder,
        isNotNull,
      );
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('NakedTextField shows the lens on a long-press drag on Android', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    try {
      final controller = TextEditingController(text: 'hello world hello');
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: NakedTextField(
                  controller: controller,
                  builder: (context, state, child) => child,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(EditableText)),
      );
      await tester.pump(const Duration(milliseconds: 600));
      await gesture.moveBy(const Offset(20, 0));
      await tester.pump();
      expect(find.byType(RawMagnifier), findsOneWidget);

      await gesture.up();
      await tester.pumpAndSettle();
      expect(find.byType(RawMagnifier), findsNothing);
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });
}
