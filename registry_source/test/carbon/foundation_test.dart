import 'package:registry_source/carbon.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CarbideSize', () {
    test('heights come from the Carbon control-size scale', () {
      expect(CarbideSize.sm.height, 32);
      expect(CarbideSize.md.height, 40);
      expect(CarbideSize.lg.height, 48);
      expect(CarbideSize.x2l.height, 80);
    });

    test('clampTo constrains into a supported range', () {
      expect(
        CarbideSize.xs.clampTo(CarbideSize.sm, CarbideSize.x2l),
        CarbideSize.sm,
      );
      expect(
        CarbideSize.xl.clampTo(CarbideSize.sm, CarbideSize.x2l),
        CarbideSize.xl,
      );
      expect(
        CarbideSize.x2l.clampTo(CarbideSize.sm, CarbideSize.lg),
        CarbideSize.lg,
      );
    });
  });

  group('CarbideLayoutScope', () {
    testWidgets('distinguishes an absent scope from the default size', (
      tester,
    ) async {
      late CarbideSize defaultSize;
      late CarbideSize? maybeSize;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (context) {
              defaultSize = CarbideLayoutScope.sizeOf(context);
              maybeSize = CarbideLayoutScope.maybeSizeOf(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(defaultSize, CarbideSize.md);
      expect(maybeSize, isNull);
    });

    testWidgets('inherits and overrides the contextual size', (tester) async {
      late CarbideSize outerSize;
      late CarbideSize inheritedSize;
      late CarbideSize overriddenSize;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: CarbideLayoutScope(
            size: CarbideSize.sm,
            child: Builder(
              builder: (context) {
                outerSize = CarbideLayoutScope.sizeOf(context);
                return CarbideLayoutScope(
                  child: Builder(
                    builder: (context) {
                      inheritedSize = CarbideLayoutScope.sizeOf(context);
                      return CarbideLayoutScope(
                        size: CarbideSize.xl,
                        child: Builder(
                          builder: (context) {
                            overriddenSize = CarbideLayoutScope.sizeOf(context);
                            return const SizedBox();
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(outerSize, CarbideSize.sm);
      expect(inheritedSize, CarbideSize.sm);
      expect(overriddenSize, CarbideSize.xl);
    });
  });

  group('CarbideLayer', () {
    test('resolves contextual aliases to indexed role tokens', () {
      expect(
        const CarbideLayerData(1).color(CarbideContextualColor.layer),
        CarbideTokens.layer01,
      );
      expect(
        const CarbideLayerData(2).color(CarbideContextualColor.layer),
        CarbideTokens.layer02,
      );
      expect(
        const CarbideLayerData(3).color(CarbideContextualColor.field),
        CarbideTokens.field03,
      );
      expect(
        const CarbideLayerData(1).color(CarbideContextualColor.borderSubtle),
        CarbideTokens.borderSubtle01,
      );
      expect(
        const CarbideLayerData(
          2,
        ).color(CarbideContextualColor.layerAccentHover),
        CarbideTokens.layerAccentHover02,
      );
    });

    testWidgets('a single CarbideLayer steps up from the page (level 1 -> 2)', (
      tester,
    ) async {
      late int single;
      late int nested;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: CarbideLayer(
            child: Builder(
              builder: (context) {
                single = CarbideLayer.levelOf(context);
                return CarbideLayer(
                  child: Builder(
                    builder: (context) {
                      nested = CarbideLayer.levelOf(context);
                      return const SizedBox();
                    },
                  ),
                );
              },
            ),
          ),
        ),
      );
      expect(single, 2, reason: 'first layer must not be a no-op');
      expect(nested, 3);
    });

    testWidgets('levels clamp at 3', (tester) async {
      late int level;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: CarbideLayer(
            child: CarbideLayer(
              child: CarbideLayer(
                child: Builder(
                  builder: (context) {
                    level = CarbideLayer.levelOf(context);
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ),
        ),
      );
      expect(level, 3);
    });
  });

  group('Breakpoints', () {
    test('carbideBreakpointFor returns the active breakpoint', () {
      expect(carbideBreakpointFor(100).name, 'sm');
      expect(carbideBreakpointFor(320).name, 'sm');
      expect(carbideBreakpointFor(700).name, 'md');
      expect(carbideBreakpointFor(1600).name, 'max');
    });
  });

  group('Fluid typography', () {
    test('resolves overrides cumulatively across breakpoints', () {
      expect(CarbideType.resolveFluid('fluidHeading05', 400).fontSize, 32);
      expect(CarbideType.resolveFluid('fluidHeading05', 700).fontSize, 36);
      expect(CarbideType.resolveFluid('fluidHeading05', 1600).fontSize, 60);
    });

    test('throws on an unknown style name in every build mode', () {
      expect(
        () => CarbideType.resolveFluid('fluidHeading99', 400),
        throwsArgumentError,
      );
    });

    testWidgets("fluidTextStyle uses the scope's fontFamily override", (
      tester,
    ) async {
      late TextStyle style;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(700, 800)),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: CarbideScope(
              overrides: const CarbideThemeOverrides(
                fontFamily: 'IBM Plex Sans',
              ),
              child: Builder(
                builder: (context) {
                  style = CarbideType.fluidTextStyle(context, 'fluidHeading05');
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );
      expect(style.fontFamily, 'IBM Plex Sans');
      expect(style.fontSize, 36);
    });
  });

  group('CarbideMotion', () {
    test('exposes Carbon easing curves', () {
      expect(
        CarbideMotion.curve(
          CarbideMotionIntent.standard,
          CarbideMotionMode.productive,
        ),
        const Cubic(0.2, 0.0, 0.38, 0.9),
      );
    });

    testWidgets('honors the reduce-motion accessibility setting', (
      tester,
    ) async {
      late bool reduced;
      late Duration resolved;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Builder(
            builder: (context) {
              reduced = CarbideMotion.reducedMotionOf(context);
              resolved = CarbideMotion.duration(
                context,
                const Duration(milliseconds: 240),
              );
              return const SizedBox();
            },
          ),
        ),
      );
      expect(reduced, isTrue);
      expect(resolved, Duration.zero);
    });
  });
}
