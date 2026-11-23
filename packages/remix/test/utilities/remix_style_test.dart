import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:remix/src/utilities/remix_style.dart'
    show RemixDefaultContentStyle, RemixStyleSpecBuilder, remixChildAnimation;

void main() {
  group('remixChildAnimation', () {
    final curve = CurveAnimationConfig(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeIn,
      delay: const Duration(milliseconds: 30),
      onEnd: () {},
    );
    final spring = SpringAnimationConfig.underdamped(
      mass: 2,
      stiffness: 220,
      ratio: .6,
      onEnd: () {},
    );

    Matcher timingOf(AnimationConfig config) => switch (config) {
      CurveAnimationConfig() =>
        isA<CurveAnimationConfig>()
            .having((config) => config.duration, 'duration', config.duration)
            .having((config) => config.curve, 'curve', config.curve)
            .having((config) => config.delay, 'delay', config.delay)
            .having((config) => config.onEnd, 'onEnd', isNull),
      SpringAnimationConfig() =>
        isA<SpringAnimationConfig>()
            .having((config) => config.spring, 'spring', same(config.spring))
            .having((config) => config.onEnd, 'onEnd', isNull),
      _ => throw ArgumentError.value(config),
    };

    test('keeps reverse timing and strips callbacks in both directions', () {
      for (final (forward, reverse) in <(AnimationConfig, AnimationConfig)>[
        (curve, spring),
        (spring, curve),
      ]) {
        final child = remixChildAnimation<BoxSpec>(
          AnimationConfig.reversible(forward, reverse: reverse),
        );

        expect(child, timingOf(forward));
        expect(AnimationConfig.reverseOf(child), timingOf(reverse));
      }
    });

    test('plain configs retain their timing without gaining a reverse', () {
      for (final config in <AnimationConfig>[curve, spring]) {
        final child = remixChildAnimation<BoxSpec>(config);

        expect(child, timingOf(config));
        expect(AnimationConfig.reverseOf(child), isNull);
      }
      expect(remixChildAnimation<BoxSpec>(null), isNull);
    });
  });

  group('focus-visible styling', () {
    late FocusHighlightStrategy previousStrategy;

    setUp(() {
      previousStrategy = FocusManager.instance.highlightStrategy;
    });

    tearDown(() {
      FocusManager.instance.highlightStrategy = previousStrategy;
    });

    testWidgets('reacts to focus highlight mode while focus is retained', (
      tester,
    ) async {
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTouch;
      final controller = WidgetStatesController({WidgetState.focused});
      addTearDown(controller.dispose);
      late BoxSpec resolved;

      await tester.pumpWidget(
        MaterialApp(
          home: RemixStyleSpecBuilder<BoxSpec>(
            style: BoxStyler()
                .color(Colors.blue)
                .onFocusVisible(.color(Colors.red)),
            styleSpec: null,
            controller: controller,
            builder: (context, spec) {
              resolved = spec;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(_boxColor(resolved), Colors.blue);
      expect(controller.value, contains(WidgetState.focused));

      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      await tester.pump();
      expect(_boxColor(resolved), Colors.red);
      expect(controller.value, contains(WidgetState.focused));

      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTouch;
      await tester.pump();
      expect(_boxColor(resolved), Colors.blue);
      expect(controller.value, contains(WidgetState.focused));
    });

    testWidgets('requires focus unless tooling forces the visual state', (
      tester,
    ) async {
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      final controller = WidgetStatesController();
      addTearDown(controller.dispose);
      late BoxSpec resolved;

      Widget build({required bool forceFocus}) {
        final child = RemixStyleSpecBuilder<BoxSpec>(
          style: BoxStyler()
              .color(Colors.blue)
              .onFocusVisible(.color(Colors.red)),
          styleSpec: null,
          controller: controller,
          builder: (context, spec) {
            resolved = spec;
            return const SizedBox.shrink();
          },
        );

        return MaterialApp(
          home: forceFocus
              ? WidgetStateStyleOverride(
                  states: const {WidgetState.focused},
                  child: child,
                )
              : child,
        );
      }

      await tester.pumpWidget(build(forceFocus: false));
      expect(_boxColor(resolved), Colors.blue);

      controller.focused = true;
      await tester.pump();
      expect(_boxColor(resolved), Colors.red);

      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTouch;
      await tester.pump();
      expect(_boxColor(resolved), Colors.blue);

      await tester.pumpWidget(build(forceFocus: true));
      expect(_boxColor(resolved), Colors.red);
    });
  });

  testWidgets(
    'RemixDefaultContentStyle provides defaults while descendants can override',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: RemixDefaultContentStyle(
            text: StyleSpec(
              spec: TextSpec(
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            icon: StyleSpec(spec: IconSpec(color: Colors.green, size: 19)),
            child: Row(
              children: [
                Icon(Icons.star),
                Text('Inherited'),
                Icon(Icons.close, color: Colors.red, size: 13),
                Text(
                  'Explicit',
                  style: TextStyle(color: Colors.orange, fontSize: 17),
                ),
              ],
            ),
          ),
        ),
      );

      final inheritedTextContext = tester.element(find.text('Inherited'));
      final inheritedIconContext = tester.element(find.byIcon(Icons.star));
      expect(
        DefaultTextStyle.of(inheritedTextContext).style.color,
        Colors.blue,
      );
      expect(DefaultTextStyle.of(inheritedTextContext).style.fontSize, 15);
      expect(IconTheme.of(inheritedIconContext).color, Colors.green);
      expect(IconTheme.of(inheritedIconContext).size, 19);

      final explicitText = tester.widget<Text>(find.text('Explicit'));
      final explicitIcon = tester.widget<Icon>(find.byIcon(Icons.close));
      expect(explicitText.style?.color, Colors.orange);
      expect(explicitText.style?.fontSize, 17);
      expect(explicitIcon.color, Colors.red);
      expect(explicitIcon.size, 13);
    },
  );

  testWidgets(
    'RemixDefaultContentStyle keeps ancestor wrapping when the spec leaves it unset',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DefaultTextStyle(
            style: TextStyle(),
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            textWidthBasis: TextWidthBasis.longestLine,
            child: RemixDefaultContentStyle(
              text: StyleSpec(spec: TextSpec()),
              child: Text('Inherited'),
            ),
          ),
        ),
      );

      final inherited = DefaultTextStyle.of(
        tester.element(find.text('Inherited')),
      );
      expect(inherited.softWrap, isFalse);
      expect(inherited.overflow, TextOverflow.ellipsis);
      expect(inherited.textWidthBasis, TextWidthBasis.longestLine);
    },
  );
}

Color? _boxColor(BoxSpec spec) {
  return (spec.decoration as BoxDecoration?)?.color;
}
