import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:remix/remix.dart';

import '../../helpers/contrast.dart';
import '../../helpers/test_helpers.dart';

void main() {
  test('defaults to the surface variant at size2, padded', () {
    const surface = FortalSurface(child: SizedBox());

    expect(surface.variant, FortalSurfaceVariant.surface);
    expect(surface.size, FortalSurfaceSize.size2);
    expect(surface.padded, isTrue);
    for (final (built, variant) in const [
      (FortalSurface.surface(child: SizedBox()), FortalSurfaceVariant.surface),
      (FortalSurface.soft(child: SizedBox()), FortalSurfaceVariant.soft),
      (FortalSurface.quiet(child: SizedBox()), FortalSurfaceVariant.quiet),
      (FortalSurface.inverse(child: SizedBox()), FortalSurfaceVariant.inverse),
    ]) {
      expect(built.variant, variant);
    }
  });

  group('looks', () {
    for (final mode in const [FortalThemeMode.light, FortalThemeMode.dark]) {
      testWidgets('each variant fills and frames in ${mode.name}, with no '
          'shadow', (tester) async {
        final looks = await resolveInFortalTheme(tester, (context) {
          Color token(ColorToken token) => MixScope.tokenOf(token, context);
          return {
            for (final variant in FortalSurfaceVariant.values)
              variant: fortalSurfaceStyle(variant: variant).build(context).spec,
          }.map(
            (variant, spec) => MapEntry(variant, (
              decoration: spec.container.spec.decoration! as BoxDecoration,
              panel: token(FortalTokens.colorPanel),
              gray6: token(FortalTokens.gray6),
              accentA3: token(FortalTokens.accentA3),
              accentA4: token(FortalTokens.accentA4),
              grayA2: token(FortalTokens.grayA2),
              grayA3: token(FortalTokens.grayA3),
              effects: spec.containerEffects,
            )),
          );
        }, mode: mode);

        for (final MapEntry(key: variant, value: look) in looks.entries) {
          final (fill, frame) = switch (variant) {
            .surface || .inverse => (look.panel, look.gray6),
            .soft => (look.accentA3, look.accentA4),
            .quiet => (look.grayA2, look.grayA3),
          };
          expect(look.decoration.color, fill, reason: variant.name);
          expect(
            (look.decoration.border! as Border).top.color,
            frame,
            reason: variant.name,
          );
          expect(look.decoration.boxShadow, isNull, reason: variant.name);
          expect(
            [
              ...?look.effects?.behindContent?.shadows,
              ...?look.effects?.overContent?.shadows,
            ],
            isEmpty,
            reason: variant.name,
          );
        }
      });
    }

    testWidgets('sizes take the card padding and corners', (tester) async {
      for (final (size, padding, radius) in const [
        (FortalSurfaceSize.size1, 12.0, 8.0),
        (FortalSurfaceSize.size2, 16.0, 8.0),
        (FortalSurfaceSize.size3, 24.0, 12.0),
        (FortalSurfaceSize.size4, 32.0, 12.0),
        (FortalSurfaceSize.size5, 48.0, 16.0),
      ]) {
        final box = await resolveInFortalTheme(
          tester,
          (context) => fortalSurfaceStyle(size: size).build(context).spec,
        );
        expect(
          box.container.spec.padding,
          EdgeInsets.all(padding),
          reason: size.name,
        );
        expect(
          (box.container.spec.decoration! as BoxDecoration).borderRadius,
          BorderRadius.all(Radius.circular(radius)),
          reason: size.name,
        );
      }
    });

    testWidgets('soft and quiet deepen under the pointer and press', (
      tester,
    ) async {
      for (final (states, soft, quiet) in [
        (
          {WidgetState.hovered},
          (fill: FortalTokens.accentA3, frame: FortalTokens.accentA5),
          (fill: FortalTokens.grayA2, frame: FortalTokens.grayA4),
        ),
        (
          {WidgetState.pressed},
          (fill: FortalTokens.accentA4, frame: FortalTokens.accentA4),
          (fill: FortalTokens.grayA3, frame: FortalTokens.grayA3),
        ),
      ]) {
        final result = await resolveInFortalTheme(
          tester,
          (context) => (
            soft:
                fortalSurfaceStyle(
                      variant: .soft,
                    ).build(context).spec.container.spec.decoration!
                    as BoxDecoration,
            quiet:
                fortalSurfaceStyle(
                      variant: .quiet,
                    ).build(context).spec.container.spec.decoration!
                    as BoxDecoration,
            expected: (
              softFill: MixScope.tokenOf(soft.fill, context),
              softFrame: MixScope.tokenOf(soft.frame, context),
              quietFill: MixScope.tokenOf(quiet.fill, context),
              quietFrame: MixScope.tokenOf(quiet.frame, context),
            ),
          ),
          states: states,
        );
        expect(result.soft.color, result.expected.softFill, reason: '$states');
        expect(
          (result.soft.border! as Border).top.color,
          result.expected.softFrame,
          reason: '$states',
        );
        expect(
          result.quiet.color,
          result.expected.quietFill,
          reason: '$states',
        );
        expect(
          (result.quiet.border! as Border).top.color,
          result.expected.quietFrame,
          reason: '$states',
        );
      }
    });

    testWidgets('padded false runs its content to the edge', (tester) async {
      for (final direction in TextDirection.values) {
        await tester.pumpRemixApp(
          const FortalSurface(
            padded: false,
            child: SizedBox(key: ValueKey('content'), width: 120, height: 80),
          ),
          textDirection: direction,
        );

        final surface = tester.getRect(find.byType(FortalSurface));
        final content = tester.getRect(find.byKey(const ValueKey('content')));
        // Only the one-pixel frame separates them.
        expect(content.left - surface.left, lessThanOrEqualTo(1));
        expect(content.top - surface.top, lessThanOrEqualTo(1));
        expect(surface.right - content.right, lessThanOrEqualTo(1));
      }
    });

    testWidgets('a caller style merges last', (tester) async {
      const fill = Color(0xFF123456);
      await tester.pumpRemixApp(
        FortalSurface.soft(
          style: CardStyler().color(fill),
          child: const SizedBox(width: 40, height: 40),
        ),
      );

      expect(_fill(tester), fill);
    });

    testWidgets('200% text grows the surface around its content', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(2)),
          child: SizedBox(
            width: 240,
            child: FortalSurface.quiet(
              child: FortalText('Revenue this month, before refunds'),
            ),
          ),
        ),
        textDirection: .rtl,
      );

      expect(tester.takeException(), isNull);
      final surface = tester.getRect(find.byType(FortalSurface));
      final text = tester.getRect(find.byType(FortalText));
      expect(text.top - surface.top, greaterThanOrEqualTo(16));
      expect(surface.bottom - text.bottom, greaterThanOrEqualTo(16));
    });
  });

  group('inverse', () {
    for (final accent in FortalAccentColor.values) {
      for (final mode in const [FortalThemeMode.light, FortalThemeMode.dark]) {
        testWidgets('flips ${accent.name} ${mode.name} and keeps its text '
            'readable', (tester) async {
          late BuildContext inside;
          late BuildContext outside;
          await tester.pumpRemixApp(
            Builder(
              builder: (context) {
                outside = context;
                return FortalSurface.inverse(
                  child: Builder(
                    builder: (context) {
                      inside = context;
                      return const FortalText('Revenue');
                    },
                  ),
                );
              },
            ),
            accent: accent,
            mode: mode,
          );

          expect(
            FortalTheme.of(inside).isDark,
            isNot(FortalTheme.of(outside).isDark),
          );
          // Everything but the appearance is inherited.
          expect(FortalTheme.of(inside).accent, accent);

          final panel = MixScope.tokenOf(FortalTokens.colorPanelSolid, inside);
          for (final ink in [
            FortalTokens.gray12,
            FortalTokens.gray11,
            FortalTokens.accentContent,
          ]) {
            expect(
              contrastRatio(MixScope.tokenOf(ink, inside), panel),
              greaterThanOrEqualTo(4.5),
              reason: ink.name,
            );
          }
          // The surface paints the panel its content resolved against.
          expect(
            _fill(tester),
            MixScope.tokenOf(FortalTokens.colorPanel, inside),
          );
        });
      }
    }

    testWidgets('the other variants keep the ambient appearance', (
      tester,
    ) async {
      for (final variant in const [
        FortalSurfaceVariant.surface,
        FortalSurfaceVariant.soft,
        FortalSurfaceVariant.quiet,
      ]) {
        late BuildContext inside;
        await tester.pumpRemixApp(
          FortalSurface(
            variant: variant,
            child: Builder(
              builder: (context) {
                inside = context;
                return const FortalText('Goals');
              },
            ),
          ),
          mode: .light,
        );
        expect(FortalTheme.of(inside).isDark, isFalse, reason: variant.name);
        expect(find.byType(FortalTheme), findsOneWidget, reason: variant.name);
      }
    });
  });

  group('pressable', () {
    testWidgets('is one named button for pointer, keyboard and assistive '
        'technology', (tester) async {
      final semantics = tester.ensureSemantics();
      var presses = 0;
      await tester.pumpRemixApp(
        FortalSurface(
          onPressed: () => presses += 1,
          semanticLabel: 'Open Mar Aberto',
          child: const FortalText('Mar Aberto'),
        ),
      );

      final node = tester.getSemantics(
        find.bySemanticsLabel('Open Mar Aberto'),
      );
      expect(node, isSemantics(isButton: true, hasTapAction: true));
      // The label names the whole card; its text is not announced again.
      expect(find.bySemanticsLabel('Mar Aberto'), findsNothing);

      await tester.tap(find.byType(FortalSurface));
      await tester.pump();
      expect(presses, 1);

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(presses, 2);
      semantics.dispose();
    });

    for (final variant in FortalSurfaceVariant.values) {
      testWidgets('${variant.name} rings on keyboard focus, outside its '
          'frame', (tester) async {
        FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.alwaysTraditional;
        addTearDown(
          () => FocusManager.instance.highlightStrategy =
              FocusHighlightStrategy.automatic,
        );
        await tester.pumpRemixApp(
          FortalSurface(
            variant: variant,
            onPressed: () {},
            semanticLabel: 'Open',
            child: const SizedBox(width: 80, height: 40),
          ),
        );
        expect(_spec(tester).containerEffects?.outline.width ?? 0, 0);

        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        final effects = _spec(tester).containerEffects!;
        final context = tester.element(find.byType(RemixCard));
        expect(effects.outline.width, 2);
        expect(effects.outlineOffset, 2);
        expect(
          effects.outline.color,
          MixScope.tokenOf(FortalTokens.focus8, context),
        );
      });
    }

    testWidgets('a semantic label without onPressed names a group', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpRemixApp(
        const FortalSurface(
          semanticLabel: 'Revenue',
          child: FortalText('R\$ 12.400'),
        ),
      );

      expect(
        tester.getSemantics(find.byType(FortalSurface)),
        isSemantics(label: 'Revenue\nR\$ 12.400', isButton: false),
      );
      semantics.dispose();
    });
  });
}

CardSpec _spec(WidgetTester tester) => tester.resolvedSpecOf<CardSpec>(
  find
      .descendant(of: find.byType(RemixCard), matching: find.byType(SizedBox))
      .first,
);

/// The surface's painted fill.
Color? _fill(WidgetTester tester) => tester
    .widgetList<DecoratedBox>(
      find.descendant(
        of: find.byType(RemixCard),
        matching: find.byType(DecoratedBox),
      ),
    )
    .map((box) => box.decoration)
    .whereType<BoxDecoration>()
    .map((decoration) => decoration.color)
    .firstWhere((color) => color != null);
