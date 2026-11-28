import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/fortal.dart';

import '../../helpers/test_helpers.dart';

Future<Rect> _pumpDialogSurface(
  WidgetTester tester,
  FortalDialog dialog, {
  MediaQueryData? mediaQueryData,
  TextDirection textDirection = TextDirection.ltr,
}) async {
  Widget child = SizedBox.expand(child: dialog);
  if (mediaQueryData != null) {
    child = MediaQuery(data: mediaQueryData, child: child);
  }
  await tester.pumpRemixApp(child, textDirection: textDirection);
  await tester.pumpAndSettle();

  final align = find.descendant(
    of: find.byType(RemixDialog),
    matching: find.byType(Align),
  );
  final surface = tester.widget<Align>(align.first).child!;

  return tester.getRect(find.byWidget(surface));
}

void main() {
  for (final direction in TextDirection.values) {
    for (final alignment in <AlignmentGeometry>[
      Alignment.bottomLeft,
      AlignmentDirectional.bottomEnd,
    ]) {
      testWidgets('dialog supports $alignment in $direction', (tester) async {
        final rect = await _pumpDialogSurface(
          tester,
          FortalDialog(align: alignment, title: 'Positioned'),
          textDirection: direction,
          mediaQueryData: const MediaQueryData(
            size: Size(800, 600),
            padding: EdgeInsets.fromLTRB(24, 48, 28, 40),
          ),
        );
        expect(rect.bottom, 560);
        expect(rect.left, alignment.resolve(direction).x == -1 ? 24 : 332);
      });
    }
  }

  testWidgets('default surface fills available width up to 440 pixels', (
    tester,
  ) async {
    final rect = await _pumpDialogSurface(
      tester,
      const FortalDialog(title: 'Short'),
    );

    expect(rect.width, 440);
  });

  testWidgets('keeps 12px from the edges of a narrow viewport', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final rect = await _pumpDialogSurface(
      tester,
      const FortalDialog(title: 'Narrow'),
    );

    expect(rect.left, 12);
    expect(rect.width, 336);
  });

  testWidgets('the panel is a 24px floating card with a header row', (
    tester,
  ) async {
    late DialogSpec spec, plain;
    late Color panel, border, secondary;
    await tester.pumpRemixApp(
      SizedBox.expand(
        child: RemixDialog(
          title: 'Styled',
          onClose: () {},
          closeLabel: 'Close',
          child: Builder(
            builder: (context) {
              spec = fortalDialogStyle().build(context).spec;
              panel = FortalTokens.colorPanelSolid.resolve(context);
              border = FortalTokens.gray7.resolve(context);
              secondary = FortalTokens.gray11.resolve(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
    await tester.pumpRemixApp(
      Builder(
        builder: (context) {
          plain = fortalDialogStyle().build(context).spec;
          return const SizedBox.shrink();
        },
      ),
    );
    expect(plain.header, isNull, reason: 'no close button, one column');
    expect(plain.container.spec.padding, const EdgeInsets.all(20));

    final box = spec.container.spec;
    final decoration = box.decoration! as BoxDecoration;
    expect(decoration.color, panel);
    expect(decoration.borderRadius, BorderRadius.circular(24));
    expect((decoration.border! as Border).top.color, border);
    expect(decoration.boxShadow, isNotEmpty);

    final header = spec.header!.spec;
    final headerBox = header.box!.spec;
    expect(headerBox.padding, const EdgeInsets.all(20));
    expect(
      ((headerBox.decoration! as BoxDecoration).border! as Border).bottom.color,
      border,
    );
    expect(header.flex!.spec.spacing, 18);
    expect(spec.title.spec.style!.fontSize, 17);
    expect(spec.title.spec.style!.fontWeight, FontWeight.w500);
    expect(spec.description.spec.style!.fontSize, 13);
    expect(spec.description.spec.style!.color, secondary);
    expect(spec.body.spec.padding, const EdgeInsets.fromLTRB(20, 20, 20, 0));
  });

  testWidgets('a dialog with onClose draws a 32px close button in its header', (
    tester,
  ) async {
    var closed = 0;
    final surface = await _pumpDialogSurface(
      tester,
      FortalDialog(
        title: 'Rename workspace',
        description: 'Pick a name.',
        onClose: () => closed++,
        closeLabel: 'Close',
        child: const Text('Body'),
      ),
    );

    expect(find.bySemanticsLabel('Close'), findsOneWidget);
    final button = find.byType(RemixIconButton);
    expect(tester.getSize(button), const Size(32, 32));
    expect(
      tester.getTopRight(button).dx,
      surface.right - 21,
      reason: 'inside the 1px frame and the 20px header padding',
    );
    await tester.tap(button);
    expect(closed, 1);
  });

  group('showFortalDialog', () {
    Future<void> open(WidgetTester tester, {bool reduceMotion = false}) async {
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(disableAnimations: reduceMotion),
          child: FortalTheme(
            child: WidgetsApp(
              color: const Color(0xFFFFFFFF),
              builder: (context, _) => Navigator(
                onGenerateRoute: (_) => PageRouteBuilder<void>(
                  pageBuilder: (context, _, _) => Center(
                    child: GestureDetector(
                      onTap: () => showFortalDialog<void>(
                        context: context,
                        barrierLabel: 'Dismiss',
                        builder: (_) => const FortalDialog(
                          title: 'Rename workspace',
                          child: Text('Body'),
                        ),
                      ),
                      child: const Text('Open'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pump();
    }

    List<double> opacities(WidgetTester tester) => [
      for (final o in tester.widgetList<Opacity>(
        find.descendant(
          of: find.byType(Stack).last,
          matching: find.byType(Opacity),
        ),
      ))
        o.opacity,
    ];

    double width(WidgetTester tester) =>
        tester.getRect(find.byType(RemixDialog)).width;

    testWidgets('the panel is announced from its first, transparent frame', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await open(tester);

      expect(opacities(tester), everyElement(0));
      expect(find.bySemanticsLabel('Rename workspace'), findsWidgets);
      semantics.dispose();
    });

    testWidgets('fades the scrim over 200ms and grows the panel on the smooth '
        'spring', (tester) async {
      await open(tester);
      final spring = FortalSpringCurve(FortalMotion.springSmooth);
      await tester.pumpAndSettle();
      final settled = width(tester);
      Navigator.of(tester.element(find.byType(RemixDialog))).pop();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      final t = 100 / spring.duration.inMilliseconds;
      final [scrim, panel] = opacities(tester);
      expect(scrim, closeTo(FortalMotion.easeEnter.transform(.5), .02));
      expect(panel, closeTo(FortalMotion.easeEnter.transform(100 / 150), .02));
      expect(
        width(tester) / settled,
        closeTo(.96 + .04 * spring.transform(t), .002),
      );
    });

    testWidgets('closes in 150ms and a tap on the scrim dismisses', (
      tester,
    ) async {
      await open(tester);
      await tester.pumpAndSettle();

      await tester.tapAt(const Offset(4, 4));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 75));
      final p = FortalMotion.easeStandard.transform(.5);
      expect(opacities(tester).first, closeTo(1 - p, .03));
      await tester.pump(const Duration(milliseconds: 80));
      expect(find.byType(RemixDialog), findsNothing);
    });

    testWidgets('only fades, over 100ms, under reduced motion', (tester) async {
      await open(tester, reduceMotion: true);
      await tester.pump(const Duration(milliseconds: 50));
      expect(opacities(tester).first, closeTo(.5, .02));
      final halfway = width(tester);
      await tester.pumpAndSettle();
      expect(width(tester), halfway);
    });
  });

  test('public contract defaults to center', () {
    const dialog = FortalDialog(title: 'Defaults');

    expect(dialog.align, Alignment.center);
  });

  testWidgets('start alignment respects the safe top inset', (tester) async {
    final rect = await _pumpDialogSurface(
      tester,
      const FortalDialog(align: Alignment.topCenter, title: 'Start aligned'),
      mediaQueryData: const MediaQueryData(
        size: Size(800, 600),
        padding: EdgeInsets.fromLTRB(24, 48, 28, 40),
      ),
    );

    expect(rect.top, 48);
  });

  testWidgets('default alignment centers within the safe padded viewport', (
    tester,
  ) async {
    final rect = await _pumpDialogSurface(
      tester,
      const FortalDialog(title: 'Centered safely'),
      mediaQueryData: const MediaQueryData(
        size: Size(800, 600),
        padding: EdgeInsets.fromLTRB(24, 48, 28, 40),
      ),
    );

    expect(rect.center.dy, 304);
  });

  testWidgets('bounded large-text structured content does not overflow', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    final bodyFocus = FocusNode(debugLabel: 'final environment variable');
    final actionFocus = FocusNode(debugLabel: 'save environment');
    addTearDown(bodyFocus.dispose);
    addTearDown(actionFocus.dispose);

    try {
      await tester.pumpRemixApp(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: SizedBox(
            width: 400,
            height: 320,
            child: FortalDialog(
              title: 'Environment',
              description: 'Variables available to this workspace.',
              scrollable: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  8,
                  (index) => index == 7
                      ? TextButton(
                          focusNode: bodyFocus,
                          onPressed: () {},
                          child: const Text('Environment variable 8'),
                        )
                      : Text('Environment variable ${index + 1}'),
                ),
              ),
              actions: [
                IconButton(
                  key: const ValueKey('save-environment-action'),
                  focusNode: actionFocus,
                  tooltip: 'Save environment',
                  onPressed: () {},
                  icon: const Icon(Icons.save),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(
        tester.widget<FortalDialog>(find.byType(FortalDialog)).scrollable,
        isTrue,
      );
      expect(
        tester.widget<RemixDialog>(find.byType(RemixDialog)).scrollable,
        isTrue,
      );

      final scrollView = find.byType(SingleChildScrollView);
      final action = find.byKey(const ValueKey('save-environment-action'));
      expect(scrollView, findsOneWidget);
      expect(
        find.descendant(of: scrollView, matching: find.text('Environment')),
        findsNothing,
      );
      expect(find.descendant(of: scrollView, matching: action), findsNothing);

      final scrollable = find.descendant(
        of: scrollView,
        matching: find.byType(Scrollable),
      );
      final position = tester.state<ScrollableState>(scrollable).position;
      final actionY = tester.getTopLeft(action).dy;
      expect(position.maxScrollExtent, greaterThan(0));

      await tester.drag(scrollView, const Offset(0, -1000));
      await tester.pumpAndSettle();

      expect(position.pixels, greaterThan(0));
      expect(tester.getTopLeft(action).dy, closeTo(actionY, 0.01));
      expect(find.bySemanticsLabel('Environment variable 8'), findsOneWidget);
      expect(
        tester.getSemantics(action),
        isSemantics(
          tooltip: 'Save environment',
          isButton: true,
          hasTapAction: true,
        ),
      );

      bodyFocus.requestFocus();
      await tester.pumpAndSettle();
      expect(bodyFocus.hasFocus, isTrue);

      for (var attempt = 0; attempt < 2 && !actionFocus.hasFocus; attempt++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();
      }
      expect(actionFocus.hasFocus, isTrue);
    } finally {
      semantics.dispose();
    }
  });
}
