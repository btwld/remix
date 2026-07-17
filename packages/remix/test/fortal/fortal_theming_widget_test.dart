import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

void main() {
  testWidgets('FortalPopover keeps its color override in the overlay', (
    tester,
  ) async {
    late Color overlayAccent;
    late Radius overlayRadius;

    await tester.pumpWidget(
      _fortalApp(
        FortalPopover(
          color: .red,
          radius: .small,
          popoverChild: Builder(
            builder: (context) {
              overlayAccent = MixScope.tokenOf(FortalTokens.accent9, context);
              overlayRadius = MixScope.tokenOf(FortalTokens.radius3, context);
              return const Text('Red popover content');
            },
          ),
          child: const Text('Open red popover'),
        ),
      ),
    );

    await tester.tap(find.text('Open red popover'));
    await tester.pumpAndSettle();

    expect(find.text('Red popover content'), findsOneWidget);
    expect(overlayAccent, red.light.scale.step(9));
    expect(overlayRadius, const Radius.circular(4.5));
  });

  testWidgets('FortalMenu keeps its color override in the overlay', (
    tester,
  ) async {
    await tester.pumpWidget(
      _fortalApp(
        FortalMenu<String>(
          color: .red,
          trigger: const RemixMenuTrigger(label: 'Open red menu'),
          items: const [RemixMenuItem(value: 'red', label: 'Red menu item')],
        ),
      ),
    );

    await tester.tap(find.text('Open red menu'));
    await tester.pumpAndSettle();

    final itemContext = tester.element(find.text('Red menu item'));
    expect(
      MixScope.tokenOf(FortalTokens.accent9, itemContext),
      red.light.scale.step(9),
    );
  });

  testWidgets('FortalSelect keeps its color override in the overlay', (
    tester,
  ) async {
    await tester.pumpWidget(
      _fortalApp(
        FortalSelect<String>(
          color: .red,
          trigger: const RemixSelectTrigger(placeholder: 'Pick red'),
          items: const [
            RemixSelectItem(value: 'red', label: 'Red select item'),
          ],
        ),
      ),
    );

    await tester.tap(find.byType(RemixSelect<String>));
    await tester.pumpAndSettle();

    final itemContext = tester.element(find.text('Red select item'));
    expect(
      MixScope.tokenOf(FortalTokens.accent9, itemContext),
      red.light.scale.step(9),
    );
  });

  testWidgets('FortalSlider resolves radiusThumb from its local radius', (
    tester,
  ) async {
    await tester.pumpWidget(
      FortalScope(
        radius: .none,
        child: const MaterialApp(
          home: Scaffold(body: FortalSlider(value: 0.5)),
        ),
      ),
    );

    final thumb = tester.widget<Box>(find.byType(Box));
    final decoration = thumb.styleSpec!.spec.decoration;

    expect(decoration, isA<ShapeDecoration>());
    final shape = (decoration! as ShapeDecoration).shape;
    expect(shape, isA<RoundedRectangleBorder>());
    expect(
      (shape as RoundedRectangleBorder).borderRadius,
      const BorderRadius.all(Radius.circular(0.5)),
    );
  });

  testWidgets('dialog barrier uses the scoped overlay token by default', (
    tester,
  ) async {
    late Color expectedBarrier;

    await tester.pumpWidget(
      FortalScope(
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                expectedBarrier = MixScope.tokenOf(
                  FortalTokens.colorOverlay,
                  context,
                );
                return TextButton(
                  onPressed: () => showRemixDialog<void>(
                    context: context,
                    builder: (context) => const RemixDialog(title: 'Dialog'),
                  ),
                  child: const Text('Open token barrier'),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open token barrier'));
    await tester.pumpAndSettle();

    final barrier = tester.widget<AnimatedModalBarrier>(
      find.byType(AnimatedModalBarrier),
    );
    expect(barrier.color.value, expectedBarrier);
  });

  testWidgets('an explicit dialog barrier color takes precedence', (
    tester,
  ) async {
    const explicitBarrier = Color(0xFF123456);

    await tester.pumpWidget(
      _fortalApp(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showRemixDialog<void>(
              context: context,
              barrierColor: explicitBarrier,
              builder: (context) => const RemixDialog(title: 'Dialog'),
            ),
            child: const Text('Open explicit barrier'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open explicit barrier'));
    await tester.pumpAndSettle();

    final barrier = tester.widget<AnimatedModalBarrier>(
      find.byType(AnimatedModalBarrier),
    );
    expect(barrier.color.value, explicitBarrier);
  });

  testWidgets('dialog routes replay Fortal config and nested overrides', (
    tester,
  ) async {
    late Color dialogAccent;
    late FortalThemeConfig dialogTheme;

    await tester.pumpWidget(
      FortalScope(
        radius: .large,
        scaling: 1.1,
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: FortalOverride(
                color: .red,
                child: Builder(
                  builder: (context) => TextButton(
                    onPressed: () => showRemixDialog<void>(
                      context: context,
                      builder: (context) {
                        dialogAccent = MixScope.tokenOf(
                          FortalTokens.accent9,
                          context,
                        );
                        dialogTheme = FortalTheme.of(context);

                        return const FortalDialog(
                          title: 'Themed dialog',
                          child: FortalButton(
                            color: .green,
                            label: 'Nested green action',
                          ),
                        );
                      },
                    ),
                    child: const Text('Open themed dialog'),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open themed dialog'));
    await tester.pumpAndSettle();

    expect(dialogAccent, red.light.scale.step(9));
    expect(dialogTheme.radius, FortalRadius.large);
    expect(dialogTheme.scaling, 1.1);
    expect(
      MixScope.tokenOf(
        FortalTokens.accent9,
        tester.element(find.byType(RemixButton)),
      ),
      green.light.scale.step(9),
    );
  });
}

Widget _fortalApp(Widget child) {
  return FortalScope(
    child: MaterialApp(
      home: Scaffold(body: Center(child: child)),
    ),
  );
}
