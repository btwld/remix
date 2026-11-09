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
    (FortalComboboxSize.size1, 24.0, 4.0),
    (FortalComboboxSize.size2, 32.0, 6.0),
    (FortalComboboxSize.size3, 40.0, 8.0),
  ]) {
    for (final variant in FortalComboboxVariant.values) {
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
      '$mode field matrix matches TextField including disabled and focus',
      (tester) async {
        for (final size in FortalComboboxSize.values) {
          for (final variant in FortalComboboxVariant.values) {
            for (final states in <Set<WidgetState>>[
              {},
              {.hovered},
              {.focused},
              {.disabled},
              {.focused, .disabled},
            ]) {
              await resolveInFortalTheme(
                tester,
                (context) {
                  final combo = fortalComboboxStyle(
                    size: size,
                    variant: variant,
                  ).build(context).spec;
                  final field = fortalTextFieldStyle(
                    size: FortalTextFieldSize.values[size.index],
                    variant: FortalTextFieldVariant.values[variant.index],
                  ).build(context);
                  expect(combo.field, field);
                },
                mode: mode,
                states: states,
              );
            }
          }
        }
      },
    );
    testWidgets(
      '$mode suggestion states preserve geometry and readable contrast for every palette',
      (tester) async {
        for (final accent in FortalAccentColor.values) {
          final fills = <Color>{};
          final borders = <EdgeInsetsGeometry?>{};
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
                expect(
                  spec.option.spec.container.spec.padding,
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                );
                fills.add(row.color!);
                borders.add(row.border?.dimensions);
                expect(
                  compositedContrast(
                    foreground: spec.option.spec.label.spec.style!.color!,
                    fill: row.color!,
                    panel: panel.color!,
                  ),
                  greaterThanOrEqualTo(4.5),
                );
                expect(
                  spec.option.spec.container.spec.constraints!.minHeight,
                  32,
                );
                expect(
                  spec.panel.spec.scrollbarColor,
                  FortalTokens.gray9.resolve(context),
                );
              },
              accent: accent,
              mode: mode,
              states: {state},
            );
          }
          expect(fills, hasLength(3));
          expect(
            borders,
            hasLength(1),
            reason: 'highlight must not move wrapped labels',
          );
        }
      },
    );
    testWidgets('$mode keyboard suggestion ring is opaque accent8', (
      tester,
    ) async {
      for (final accent in FortalAccentColor.values) {
        final (border, accent8) = await resolveInFortalTheme(
          tester,
          (context) {
            final spec = fortalComboboxStyle().build(context).spec;
            return (
              decoration(spec.option.spec.container.spec).border! as Border,
              FortalTokens.accent8.resolve(context),
            );
          },
          accent: accent,
          mode: mode,
          states: {WidgetState.focused},
        );
        expect(border.top.width, 1);
        expect(border.top.color, accent8);
        expect(border.top.color.a, 1);
      }
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
}
