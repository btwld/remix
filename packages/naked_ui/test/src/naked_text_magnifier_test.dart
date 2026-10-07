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

  testWidgets('repositions when the magnifier info notifier is replaced', (
    tester,
  ) async {
    final oldInfo = ValueNotifier<MagnifierInfo>(
      const MagnifierInfo(
        globalGesturePosition: Offset(100, 80),
        caretRect: Rect.fromLTWH(100, 80, 2, 20),
        fieldBounds: Rect.fromLTWH(0, 40, 200, 120),
        currentLineBoundaries: Rect.fromLTWH(0, 80, 200, 20),
      ),
    );
    final newInfo = ValueNotifier<MagnifierInfo>(
      const MagnifierInfo(
        globalGesturePosition: Offset(180, 120),
        caretRect: Rect.fromLTWH(180, 120, 2, 20),
        fieldBounds: Rect.fromLTWH(0, 40, 200, 120),
        currentLineBoundaries: Rect.fromLTWH(0, 120, 200, 20),
      ),
    );
    addTearDown(oldInfo.dispose);
    addTearDown(newInfo.dispose);

    await tester.pumpWidget(
      _magnifierHost(NakedTextMagnifier(magnifierInfo: oldInfo)),
    );
    expect(tester.getTopLeft(find.byType(RawMagnifier)), const Offset(60, 28));

    await tester.pumpWidget(
      _magnifierHost(NakedTextMagnifier(magnifierInfo: newInfo)),
    );
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.byType(RawMagnifier)), const Offset(120, 68));

    newInfo.value = const MagnifierInfo(
      globalGesturePosition: Offset(100, 120),
      caretRect: Rect.fromLTWH(100, 120, 2, 20),
      fieldBounds: Rect.fromLTWH(0, 40, 200, 120),
      currentLineBoundaries: Rect.fromLTWH(0, 120, 200, 20),
    );
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.byType(RawMagnifier)), const Offset(60, 68));
  });

  for (final configuration in [
    (
      name: 'size',
      size: const Size(120, 60),
      scale: 1.25,
      shift: 22.0,
      position: const Offset(80, 0),
      focalPoint: const Offset(35, 0),
    ),
    (
      name: 'scale',
      size: const Size(80, 40),
      scale: 2.5,
      shift: 22.0,
      position: const Offset(120, 0),
      focalPoint: const Offset(6, 10),
    ),
    (
      name: 'vertical shift',
      size: const Size(80, 40),
      scale: 1.25,
      shift: 46.0,
      position: const Offset(120, 0),
      focalPoint: const Offset(15, 10),
    ),
  ]) {
    testWidgets('updates clamped geometry when ${configuration.name} changes', (
      tester,
    ) async {
      final info = ValueNotifier<MagnifierInfo>(
        const MagnifierInfo(
          globalGesturePosition: Offset(180, 20),
          caretRect: Rect.fromLTWH(180, 20, 2, 20),
          fieldBounds: Rect.fromLTWH(150, 0, 50, 120),
          currentLineBoundaries: Rect.fromLTWH(150, 20, 50, 20),
        ),
      );
      addTearDown(info.dispose);

      await tester.pumpWidget(
        _magnifierHost(NakedTextMagnifier(magnifierInfo: info)),
      );
      expect(
        tester.getTopLeft(find.byType(RawMagnifier)),
        const Offset(120, 0),
      );
      expect(
        tester.widget<RawMagnifier>(find.byType(RawMagnifier)).focalPointOffset,
        const Offset(15, 10),
      );

      await tester.pumpWidget(
        _magnifierHost(
          NakedTextMagnifier(
            magnifierInfo: info,
            size: configuration.size,
            magnificationScale: configuration.scale,
            verticalFocalPointShift: configuration.shift,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        tester.getTopLeft(find.byType(RawMagnifier)),
        configuration.position,
      );
      expect(
        tester.widget<RawMagnifier>(find.byType(RawMagnifier)).focalPointOffset,
        configuration.focalPoint,
      );
    });
  }

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

  for (final platform in [TargetPlatform.android, TargetPlatform.iOS]) {
    testWidgets(
      'NakedTextField shows the lens on a $platform long-press drag',
      (tester) async {
        debugDefaultTargetPlatformOverride = platform;
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
      },
    );
  }
}

Widget _magnifierHost(NakedTextMagnifier magnifier) {
  return MaterialApp(
    home: MediaQuery(
      data: const MediaQueryData(size: Size(200, 200)),
      child: Scaffold(body: Stack(children: [magnifier])),
    ),
  );
}
