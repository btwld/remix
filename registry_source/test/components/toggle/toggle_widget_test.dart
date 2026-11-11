import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
// `RemixFlexBoxAdapter` is `@internal` to `remix`, but this sibling package's
// tests need it to read the container spec Remix resolved for a Fortal recipe.
// Suppressed per-use below, so a future accidental internal-member use still
// gets flagged.
import 'package:remix/src/rendering/remix_box_effects.dart';
import 'package:registry_source/fortal.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('Fortal Styles', () {
    testWidgets(
      'each toggle variant and size applies its metrics and selected colors',
      (tester) async {
        for (final variant in FortalToggleVariant.values) {
          for (final size in FortalToggleSize.values) {
            for (final selected in [false, true]) {
              await tester.pumpRemixApp(
                RemixToggle(
                  selected: selected,
                  onChanged: (_) {},
                  label: 'Bold',
                  style: fortalToggleStyle(variant: variant, size: size),
                ),
              );
              await tester.pumpAndSettle();
              final box = _toggleRow(tester).styleSpec.spec.box!.spec;
              // Toggles share the button height scale (24/32/40) and centre
              // their content, rather than deriving height from padding.
              final (paddingX, height) = switch (size) {
                FortalToggleSize.size1 => (8.0, 24.0),
                FortalToggleSize.size2 => (12.0, 32.0),
                FortalToggleSize.size3 => (16.0, 40.0),
              };
              expect(
                box.padding!.resolve(TextDirection.ltr),
                EdgeInsets.symmetric(horizontal: paddingX),
              );
              expect(box.constraints!.minHeight, height);
              final context = tester.element(_toggleRowFinder);
              Color color(ColorToken token) => MixScope.tokenOf(token, context);
              final decoration = box.decoration! as BoxDecoration;
              expect(
                decoration.color,
                selected
                    ? color(
                        variant == FortalToggleVariant.ghost
                            ? FortalTokens.accent3
                            : FortalTokens.accentA3,
                      )
                    : Colors.transparent,
              );
              expect(
                tester.widget<Text>(find.text('Bold')).style!.color,
                color(
                  selected ? FortalTokens.accentContent : FortalTokens.gray12,
                ),
              );
              if (variant == FortalToggleVariant.outline) {
                final border = decoration.border! as Border;
                expect(border.top.width, 1);
                expect(
                  border.top.color,
                  color(selected ? FortalTokens.accentA5 : FortalTokens.gray7),
                );
              } else {
                expect(decoration.border, isNull);
              }
            }
          }
        }
      },
    );

    testWidgets('wraps a complete label at 200% in 200 logical pixels', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();

      await tester.pumpRemixApp(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: SizedBox(
            width: 200,
            child: FortalToggle(
              selected: false,
              label: 'Workspace Write',
              onChanged: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(tester.getSize(_toggleRowFinder).width, lessThanOrEqualTo(200));
      expect(
        tester.getSemantics(find.byType(RemixToggle)).label,
        'Workspace Write',
      );
      semantics.dispose();
    });

    testWidgets('preserves normal label geometry and icon-only sizing', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        FortalToggle(selected: false, label: 'Bold', onChanged: (_) {}),
      );
      await tester.pumpAndSettle();

      final rowSize = tester.getSize(_toggleRowFinder);
      final labelSize = tester.getSize(find.text('Bold'));
      expect(rowSize.width, closeTo(labelSize.width + 24, 0.01));
      expect(rowSize.height, 32);

      final iconOnlySizes = <Size>[];
      for (final scaler in const [TextScaler.noScaling, TextScaler.linear(2)]) {
        await tester.pumpRemixApp(
          MediaQuery(
            data: MediaQueryData(textScaler: scaler),
            child: FortalToggle(
              selected: false,
              icon: Icons.format_bold,
              onChanged: (_) {},
            ),
          ),
        );
        await tester.pumpAndSettle();
        iconOnlySizes.add(tester.getSize(_toggleRowFinder));
      }

      expect(iconOnlySizes[1], iconOnlySizes[0]);
    });

    testWidgets('paints the button height for each size, label or icon', (
      tester,
    ) async {
      for (final size in FortalToggleSize.values) {
        final buttonSize = switch (size) {
          FortalToggleSize.size1 => FortalButtonSize.size1,
          FortalToggleSize.size2 => FortalButtonSize.size2,
          FortalToggleSize.size3 => FortalButtonSize.size3,
        };
        await tester.pumpRemixApp(
          FortalButton.surface(
            size: buttonSize,
            label: 'Bold',
            onPressed: () {},
          ),
        );
        await tester.pumpAndSettle();
        final buttonHeight = tester
            .getSize(
              find.descendant(
                of: find.byType(RemixButton),
                matching: find.byType(DecoratedBox),
              ),
            )
            .height;

        for (final content in ['label', 'icon']) {
          await tester.pumpRemixApp(
            FortalToggle(
              selected: false,
              size: size,
              label: content == 'label' ? 'Bold' : null,
              icon: content == 'icon' ? Icons.format_bold : null,
              onChanged: (_) {},
            ),
          );
          await tester.pumpAndSettle();
          expect(
            tester.getSize(_toggleRowFinder).height,
            buttonHeight,
            reason: '$size $content toggle',
          );
          // Content stays centred in the painted box.
          final row = tester.getRect(_toggleRowFinder);
          final glyph = tester.getRect(
            content == 'label'
                ? find.text('Bold')
                : find.byIcon(Icons.format_bold),
          );
          expect(glyph.center.dy, closeTo(row.center.dy, 0.5));
        }
      }
    });

    testWidgets('keeps labels intrinsic under unbounded width', (tester) async {
      await tester.pumpRemixApp(
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: FortalToggle(
            selected: false,
            label: 'Workspace Write',
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(Flexible), findsNothing);
    });

    group('focus-visible ring', () {
      late FocusHighlightStrategy previousStrategy;

      setUp(() {
        previousStrategy = FocusManager.instance.highlightStrategy;
      });

      tearDown(() {
        FocusManager.instance.highlightStrategy = previousStrategy;
      });

      testWidgets('outline toggle keeps focus ring when selected', (
        tester,
      ) async {
        FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.alwaysTraditional;
        final focusRingColor = await resolveInFortalTheme(
          tester,
          (context) => MixScope.tokenOf(FortalTokens.focus8, context),
        );

        Future<Color?> ringColorFor({required bool selected}) async {
          final focusNode = FocusNode();
          addTearDown(focusNode.dispose);
          await tester.pumpRemixApp(
            RemixToggle(
              selected: selected,
              onChanged: (_) {},
              label: 'T',
              focusNode: focusNode,
              style: fortalToggleStyle(variant: .outline),
            ),
          );
          await tester.pumpAndSettle();

          focusNode.requestFocus();
          await tester.pumpAndSettle();

          expect(focusNode.hasFocus, isTrue);
          return _focusRing(tester)?.color;
        }

        final unselected = await ringColorFor(selected: false);
        final selected = await ringColorFor(selected: true);

        expect(unselected, focusRingColor);
        expect(
          selected,
          unselected,
          reason: 'focus ring must survive selection',
        );
      });

      testWidgets('outline toggle hides focus ring in touch mode', (
        tester,
      ) async {
        FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.alwaysTouch;
        final focusNode = FocusNode();
        addTearDown(focusNode.dispose);

        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (_) {},
            label: 'T',
            focusNode: focusNode,
            style: fortalToggleStyle(variant: .outline),
          ),
        );
        await tester.pumpAndSettle();
        focusNode.requestFocus();
        await tester.pumpAndSettle();

        expect(focusNode.hasFocus, isTrue);
        expect(_focusRing(tester), isNull);
      });
    });
  });
}

BorderSide? _focusRing(WidgetTester tester) =>
    tester.resolvedSpecOf<ToggleSpec>(find.text('T')).containerEffects?.outline;
// ignore: invalid_use_of_internal_member
final _toggleRowFinder = find.byType(RemixFlexBoxAdapter);

// ignore: invalid_use_of_internal_member
RemixFlexBoxAdapter _toggleRow(WidgetTester tester) =>
    tester.widget(_toggleRowFinder);
