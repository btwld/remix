import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:remix/remix.dart';

import '../helpers/contrast.dart';
import '../helpers/fortal_text_input_geometry.dart';
import '../helpers/test_helpers.dart';

BoxDecoration decoration(BoxSpec spec) => spec.decoration! as BoxDecoration;

void main() {
  for (final (size, height, paddingY) in const [
    // The field's control heights, centering the 14px line box that the
    // engine lays out on 20px.
    (FortalTextFieldSize.size1, 32.0, 6.0),
    (FortalTextFieldSize.size2, 40.0, 10.0),
    (FortalTextFieldSize.size3, 44.0, 12.0),
  ]) {
    for (final variant in FortalTextFieldVariant.values) {
      for (final scale in [1.0, 2.0]) {
        testWidgets(
          '$size/$variant at $scale keeps the accepted text line inside its field',
          (tester) async {
            final controller = TextEditingController(text: 'Agj Ép');
            addTearDown(controller.dispose);
            final focusNode = FocusNode();
            addTearDown(focusNode.dispose);
            for (final direction in TextDirection.values) {
              for (final enabled in [true, false]) {
                await tester.pumpRemixApp(
                  MediaQuery(
                    data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                    child: SizedBox(
                      width: 320,
                      child: FortalCombobox<String>(
                        size: size,
                        variant: variant,
                        controller: controller,
                        focusNode: focusNode,
                        enabled: enabled,
                        optionsBuilder: (_) => const <String>[],
                      ),
                    ),
                  ),
                  textDirection: direction,
                );
                await tester.pumpAndSettle();
                expectFortalTextInputGeometry(
                  tester,
                  scale: scale,
                  height: height,
                  paddingY: paddingY,
                );
              }
            }
          },
        );
      }
    }
  }

  for (final dark in [false, true]) {
    final FortalThemeMode mode = dark ? .dark : .light;
    testWidgets(
      '$mode field keeps the text field geometry with its own frame',
      (tester) async {
        Color frame(TextFieldSpec spec) =>
            spec.containerEffects!.overContent!.shadows.single.color;
        for (final size in FortalTextFieldSize.values) {
          for (final (states, expected, fill)
              in <(Set<WidgetState>, ColorToken, ColorToken)>[
                ({}, FortalTokens.gray7, FortalTokens.gray2),
                ({.focused}, FortalTokens.accent9, FortalTokens.gray2),
                ({.focused, .selected}, FortalTokens.gray8, FortalTokens.gray3),
                ({.focused, .hovered}, FortalTokens.gray8, FortalTokens.gray3),
                ({.disabled, .hovered}, FortalTokens.gray7, FortalTokens.gray3),
                (
                  {.error, .focused, .hovered},
                  FortalTokens.error8,
                  FortalTokens.gray3,
                ),
              ]) {
            await resolveInFortalTheme(
              tester,
              (context) {
                final combo = fortalComboboxStyle(size: size).build(context);
                final field = fortalTextFieldStyle(size: size).build(context);
                final spec = combo.spec.field.spec;
                expect(
                  spec.container.spec.constraints,
                  field.spec.container.spec.constraints,
                );
                expect(
                  spec.container.spec.padding,
                  field.spec.container.spec.padding,
                );
                expect(
                  frame(spec),
                  expected.resolve(context),
                  reason: '$states',
                );
                expect(
                  decoration(spec.container.spec).color,
                  fill.resolve(context),
                  reason: '$states',
                );
              },
              mode: mode,
              states: states,
            );
          }
        }
      },
    );
    testWidgets(
      '$mode suggestion states share one muted fill with readable labels for every palette',
      (tester) async {
        for (final accent in FortalAccentColor.values) {
          for (final state in [
            WidgetState.hovered,
            WidgetState.focused,
            WidgetState.pressed,
          ]) {
            await resolveInFortalTheme(
              tester,
              (context) {
                final spec = fortalComboboxStyle().build(context).spec;
                final row = decoration(spec.option.spec.container.spec);
                final panel = decoration(spec.panel.spec.container.spec);
                expect(row.color, FortalTokens.gray3.resolve(context));
                expect(row.border, isNull);
                expect(row.borderRadius, BorderRadius.circular(15));
                expect(
                  compositedContrast(
                    foreground: spec.option.spec.label.spec.style!.color!,
                    fill: row.color!,
                    panel: panel.color!,
                  ),
                  greaterThanOrEqualTo(4.5),
                  reason: '${accent.name} ${state.name}',
                );
                expect(
                  spec.option.spec.container.spec.constraints!.minHeight,
                  36,
                );
                expect(spec.panel.spec.scrollbarThickness, 0);
                expect(panel.borderRadius, BorderRadius.circular(20));
                expect(
                  panel.color,
                  FortalTokens.colorPanelSolid.resolve(context),
                );
              },
              accent: accent,
              mode: mode,
              states: {state},
            );
          }
        }
      },
    );
    testWidgets('$mode panel grows in and leaves in 100ms', (tester) async {
      await tester.pumpRemixApp(
        SizedBox(
          width: 320,
          child: FortalCombobox<String>(
            label: 'Team',
            optionsBuilder: (_) => const ['Design', 'Marketing'],
          ),
        ),
        mode: mode,
      );
      double opacity() => tester
          .widgetList<Opacity>(
            find.ancestor(
              of: find.text('Marketing'),
              matching: find.byType(Opacity),
            ),
          )
          .fold(1.0, (product, widget) => product * widget.opacity);

      await tester.tap(find.byType(EditableText));
      await tester.enterText(find.byType(EditableText), 'g');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 40));
      expect(opacity(), inExclusiveRange(0, 1));
      await tester.pumpAndSettle();
      expect(opacity(), 1);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 60));
      expect(find.text('Marketing'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 60));
      expect(find.text('Marketing'), findsNothing);
    });
    testWidgets('$mode caller suggestion border stays opaque', (tester) async {
      for (final focused in [false, true]) {
        final (border, callerColor) = await resolveInFortalTheme(
          tester,
          (context) {
            final override = ComboboxOptionStyler().border(
              .all(.color(FortalTokens.gray11()).width(1)),
            );
            final spec = fortalComboboxStyle(
              style: ComboboxStyler().option(
                focused ? ComboboxOptionStyler().onFocused(override) : override,
              ),
            ).build(context).spec;
            return (
              decoration(spec.option.spec.container.spec).border! as Border,
              FortalTokens.gray11.resolve(context),
            );
          },
          mode: mode,
          states: focused ? {WidgetState.focused} : {},
        );
        expect(border.top.color, callerColor);
        expect(border.top.color.a, 1);
      }
    });
    testWidgets('$mode caller state overrides merge last', (tester) async {
      await resolveInFortalTheme(
        tester,
        (context) {
          final spec = fortalComboboxStyle(
            style: ComboboxStyler().option(
              ComboboxOptionStyler().onHovered(.color(FortalTokens.gray4())),
            ),
          ).build(context).spec;
          expect(
            decoration(spec.option.spec.container.spec).color,
            FortalTokens.gray4.resolve(context),
          );
        },
        mode: mode,
        states: {WidgetState.hovered},
      );
    });
    testWidgets(
      '$mode RTL at 200 percent grows wrapped suggestions and accepts by keyboard',
      (tester) async {
        String? accepted;
        await tester.pumpRemixApp(
          MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: SizedBox(
              width: 320,
              child: FortalCombobox<String>(
                label: 'Destination',
                onSelected: (value) => accepted = value,
                optionsBuilder: (_) => const [
                  'San Sebastián, Basque Country · Spain',
                  'Santiago de Compostela, Galicia · Spain',
                ],
              ),
            ),
          ),
          mode: mode,
          textDirection: .rtl,
        );
        await tester.tap(find.byType(EditableText));
        await tester.enterText(find.byType(EditableText), 'San');
        await tester.pumpAndSettle();
        expect(
          find.text('San Sebastián, Basque Country · Spain'),
          findsOneWidget,
        );
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();
        expect(accepted, 'San Sebastián, Basque Country · Spain');
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final dark in [false, true]) {
    testWidgets(
      '${dark ? 'dark' : 'light'} placeholder lifts to gray 11 under high contrast',
      (tester) async {
        for (final variant in FortalTextFieldVariant.values) {
          for (final highContrast in [false, true]) {
            late TextFieldSpec field;
            late FortalThemeColors colors;
            await tester.pumpRemixApp(
              Builder(
                builder: (context) {
                  colors = resolveFortalTokens(FortalTheme.of(context));
                  field = fortalComboboxStyle(
                    variant: variant,
                  ).build(context).spec.field.spec;
                  return const SizedBox.shrink();
                },
              ),
              mode: dark ? .dark : .light,
              highContrast: highContrast,
            );
            final reason = '$dark/$variant/highContrast=$highContrast';
            final hint = field.hintText.spec.style!.color!;
            expect(
              hint,
              colors.gray.scale.step(highContrast ? 11 : 10),
              reason: reason,
            );
            if (!highContrast) continue;
            final fill =
                (field.container.spec.decoration as BoxDecoration).color!;
            for (final panel in [
              colors.colorBackground,
              colors.colorPanelSolid,
            ]) {
              expect(
                compositedContrast(foreground: hint, fill: fill, panel: panel),
                greaterThanOrEqualTo(4.5),
                reason: reason,
              );
            }
          }
        }
      },
    );
  }
}
