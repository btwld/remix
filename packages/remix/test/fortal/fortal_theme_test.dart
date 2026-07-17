import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

void main() {
  group('Fortal theme configuration', () {
    test('rejects non-positive and non-finite scaling', () {
      for (final scaling in [0.0, -1.0, double.nan, double.infinity]) {
        expect(
          () => FortalScope(scaling: scaling, child: const SizedBox()),
          throwsAssertionError,
          reason: 'FortalScope must reject $scaling.',
        );
        expect(
          () => FortalThemeConfig(scaling: scaling),
          throwsAssertionError,
          reason: 'FortalThemeConfig must reject $scaling.',
        );
      }
    });

    testWidgets('exposes knob values and preserves the default token values', (
      tester,
    ) async {
      late FortalThemeConfig config;
      late double defaultSpace4;
      late Radius defaultRadius3;
      late Color defaultPanel;
      late Color defaultSolidPanel;
      late Radius defaultThumbRadius;

      await tester.pumpWidget(
        MaterialApp(
          home: FortalScope(
            child: Builder(
              builder: (context) {
                config = FortalTheme.of(context);
                defaultSpace4 = MixScope.tokenOf(FortalTokens.space4, context);
                defaultRadius3 = MixScope.tokenOf(
                  FortalTokens.radius3,
                  context,
                );
                defaultPanel = MixScope.tokenOf(
                  FortalTokens.colorPanel,
                  context,
                );
                defaultSolidPanel = MixScope.tokenOf(
                  FortalTokens.colorPanelSolid,
                  context,
                );
                defaultThumbRadius = MixScope.tokenOf(
                  FortalTokens.radiusThumb,
                  context,
                );
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(config, const FortalThemeConfig());
      expect(defaultSpace4, 16.0);
      expect(defaultRadius3, const Radius.circular(6.0));
      expect(defaultPanel, defaultSolidPanel);
      expect(defaultThumbRadius, const Radius.circular(9999.0));
    });

    testWidgets('applies radius, scaling, and panel background knobs', (
      tester,
    ) async {
      late FortalThemeConfig config;
      late Radius radius3;
      late Radius thumbRadius;
      late double space4;
      late Color panel;
      late Color translucentPanel;

      await tester.pumpWidget(
        MaterialApp(
          home: FortalScope(
            radius: .none,
            scaling: 0.9,
            panelBackground: .translucent,
            child: Builder(
              builder: (context) {
                config = FortalTheme.of(context);
                radius3 = MixScope.tokenOf(FortalTokens.radius3, context);
                thumbRadius = MixScope.tokenOf(
                  FortalTokens.radiusThumb,
                  context,
                );
                space4 = MixScope.tokenOf(FortalTokens.space4, context);
                panel = MixScope.tokenOf(FortalTokens.colorPanel, context);
                translucentPanel = MixScope.tokenOf(
                  FortalTokens.colorPanelTranslucent,
                  context,
                );
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(config.radius, FortalRadius.none);
      expect(config.scaling, 0.9);
      expect(config.panelBackground, FortalPanelBackground.translucent);
      expect(radius3, Radius.zero);
      expect(thumbRadius, const Radius.circular(0.5));
      expect(space4, closeTo(14.4, 0.00001));
      expect(panel, translucentPanel);
    });

    testWidgets('scales large radii while keeping the circle primitive full', (
      tester,
    ) async {
      late Radius radius3;
      late Radius radiusFull;
      late Radius thumbRadius;
      late double space4;

      await tester.pumpWidget(
        MaterialApp(
          home: FortalScope(
            radius: .large,
            scaling: 1.1,
            child: Builder(
              builder: (context) {
                radius3 = MixScope.tokenOf(FortalTokens.radius3, context);
                radiusFull = MixScope.tokenOf(FortalTokens.radiusFull, context);
                thumbRadius = MixScope.tokenOf(
                  FortalTokens.radiusThumb,
                  context,
                );
                space4 = MixScope.tokenOf(FortalTokens.space4, context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(radius3, const Radius.circular(9.9));
      expect(radiusFull, const Radius.circular(9999));
      expect(thumbRadius, const Radius.circular(9999));
      expect(space4, closeTo(17.6, 0.00001));
    });
  });

  group('FortalOverride', () {
    testWidgets('preserves child state when an override is toggled', (
      tester,
    ) async {
      FortalAccentColor? color;
      late StateSetter rebuild;

      await tester.pumpWidget(
        MaterialApp(
          home: FortalScope(
            child: StatefulBuilder(
              builder: (context, setState) {
                rebuild = setState;
                return FortalTextField(color: color, hintText: 'Draft');
              },
            ),
          ),
        ),
      );

      final editableFinder = find.byType(EditableText);
      await tester.enterText(editableFinder, 'Keep this text');
      await tester.pump();

      final before = tester.widget<EditableText>(editableFinder);
      expect(before.controller.text, 'Keep this text');
      expect(before.focusNode.hasFocus, isTrue);

      rebuild(() => color = .red);
      await tester.pump();

      final after = tester.widget<EditableText>(editableFinder);
      expect(after.controller, same(before.controller));
      expect(after.controller.text, 'Keep this text');
      expect(after.focusNode.hasFocus, isTrue);

      rebuild(() => color = null);
      await tester.pump();

      final restored = tester.widget<EditableText>(editableFinder);
      expect(restored.controller, same(before.controller));
      expect(restored.controller.text, 'Keep this text');
      expect(restored.focusNode.hasFocus, isTrue);
    });

    testWidgets('changes only accent and radius families and composes inward', (
      tester,
    ) async {
      late Color outerAccent;
      late Color outerGray;
      late double outerSpace;
      late Color overrideAccent;
      late Color overrideGray;
      late double overrideSpace;
      late Radius overrideRadius;
      late Color nestedAccent;

      await tester.pumpWidget(
        MaterialApp(
          home: FortalScope(
            accent: .indigo,
            scaling: 1.1,
            child: Builder(
              builder: (context) {
                outerAccent = MixScope.tokenOf(FortalTokens.accent9, context);
                outerGray = MixScope.tokenOf(FortalTokens.gray12, context);
                outerSpace = MixScope.tokenOf(FortalTokens.space4, context);

                return FortalOverride(
                  color: .red,
                  radius: .small,
                  child: Builder(
                    builder: (context) {
                      overrideAccent = MixScope.tokenOf(
                        FortalTokens.accent9,
                        context,
                      );
                      overrideGray = MixScope.tokenOf(
                        FortalTokens.gray12,
                        context,
                      );
                      overrideSpace = MixScope.tokenOf(
                        FortalTokens.space4,
                        context,
                      );
                      overrideRadius = MixScope.tokenOf(
                        FortalTokens.radius3,
                        context,
                      );

                      return FortalOverride(
                        color: .blue,
                        child: Builder(
                          builder: (context) {
                            nestedAccent = MixScope.tokenOf(
                              FortalTokens.accent9,
                              context,
                            );
                            return const SizedBox.shrink();
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

      expect(outerAccent, indigo.light.scale.step(9));
      expect(overrideAccent, red.light.scale.step(9));
      expect(nestedAccent, blue.light.scale.step(9));
      expect(overrideAccent, isNot(outerAccent));
      expect(overrideGray, outerGray);
      expect(overrideSpace, outerSpace);
      expect(overrideRadius.x, closeTo(4.95, 0.00001));
      expect(overrideRadius.y, closeTo(4.95, 0.00001));
    });
  });
}
