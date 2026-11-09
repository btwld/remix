import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/heroui.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';
import '../helpers/contrast.dart';

Future<ComboboxSpec> resolve(
  WidgetTester tester, {
  required String mode,
  HeroUiComboboxVariant variant = .primary,
  Set<WidgetState> states = const {},
  ComboboxStyler style = const ComboboxStyler.create(),
  double width = 1024,
}) async {
  late ComboboxSpec spec;
  await tester.pumpHeroUi(
    WidgetStateProvider(
      states: states,
      child: Builder(
        builder: (context) {
          spec = heroUiComboboxStyle(
            variant: variant,
            style: style,
          ).build(context).spec;
          final field = heroUiTextFieldStyle(
            variant: HeroUiTextFieldVariant.values[variant.index],
            style: TextFieldStyler().constraints(.minHeight(0)),
          ).build(context);
          expect(spec.field, field);
          return const SizedBox.shrink();
        },
      ),
    ),
    mode: mode,
    width: width,
  );
  return spec;
}

BoxDecoration decoration(BoxSpec spec) => spec.decoration! as BoxDecoration;

void main() {
  for (final count in [7, 20]) {
    testWidgets(
      '$count suggestions have balanced insets and scroll only on overflow',
      (tester) async {
        await tester.pumpHeroUi(
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 320,
              child: HeroUiCombobox<String>(
                optionsBuilder: (_) => List.generate(count, (i) => 'City $i'),
              ),
            ),
          ),
        );
        await tester.tap(find.byType(EditableText));
        await tester.enterText(find.byType(EditableText), 'City');
        await tester.pumpAndSettle();
        final scroll = tester.state<ScrollableState>(
          find.byWidgetPredicate(
            (widget) =>
                widget is Scrollable &&
                widget.axisDirection == AxisDirection.down,
          ),
        );
        if (count == 7) {
          expect(scroll.position.maxScrollExtent, 0);
          final panel = find
              .ancestor(
                of: find.byType(SingleChildScrollView),
                matching: find.byType(DecoratedBox),
              )
              .first;
          Rect row(String text) => tester.getRect(
            find
                .ancestor(
                  of: find.text(text),
                  matching: find.byType(DecoratedBox),
                )
                .first,
          );
          final panelRect = tester.getRect(panel);
          expect(row('City 0').top - panelRect.top, 6);
          expect(panelRect.bottom - row('City 6').bottom, 6);
          expect(row('City 1').top - row('City 0').bottom, 4);
        } else {
          expect(scroll.position.maxScrollExtent, greaterThan(0));
          await tester.drag(
            find.byType(SingleChildScrollView),
            const Offset(0, -120),
          );
          await tester.pumpAndSettle();
          expect(scroll.position.pixels, greaterThan(0));
        }
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final mode in ['light', 'dark']) {
    for (final width in [375, 1024]) {
      for (final variant in HeroUiComboboxVariant.values) {
        testWidgets(
          '$mode/$width/$variant field matrix and measured suggestion geometry',
          (tester) async {
            for (final states in <Set<WidgetState>>[
              {},
              {.hovered},
              {.focused},
              {.disabled},
              {.focused, .disabled},
            ]) {
              final spec = await resolve(
                tester,
                mode: mode,
                variant: variant,
                states: states,
                width: width.toDouble(),
              );
              expect(
                spec.option.spec.container.spec.constraints!.minHeight,
                36,
              );
              expect(
                spec.option.spec.container.spec.padding,
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              );
              expect(
                spec.option.spec.container.spec.margin,
                const EdgeInsets.only(bottom: 4),
              );
              final item = heroUiCase(
                'combobox-${variant.name}-keyboard-open-list-box-item:Apple',
                mode: mode,
                width: width,
              );
              expect(
                spec.option.spec.container.spec.constraints!.minHeight,
                item.px('minHeight'),
              );
              expect(
                spec.option.spec.container.spec.padding,
                EdgeInsets.symmetric(
                  horizontal: item.px('paddingLeft'),
                  vertical: item.px('paddingTop'),
                ),
              );
              expect(
                decoration(spec.option.spec.container.spec).borderRadius,
                BorderRadius.circular(item.px('borderRadius')),
              );
              expect(spec.option.spec.label.spec.style!.fontSize, 14);
              expect(
                spec.panel.spec.container.spec.padding,
                const EdgeInsets.fromLTRB(6, 6, 6, 2),
              );
              expect(
                decoration(spec.panel.spec.container.spec).borderRadius,
                BorderRadius.circular(24),
              );
            }
            await tester.pumpHeroUi(
              SizedBox(
                width: 320,
                child: HeroUiCombobox<String>(
                  variant: variant,
                  hintText: 'Search cities',
                  optionsBuilder: (_) => const [],
                ),
              ),
              mode: mode,
              width: width.toDouble(),
            );
            await tester.pumpAndSettle();
            final input = heroUiCase(
              'combobox-${variant.name}-rest-input',
              mode: mode,
              width: width,
            );
            expect(
              tester.getSize(find.byType(HeroUiCombobox<String>)),
              input.size,
            );
            expect(tester.takeException(), isNull);
          },
        );
      }
    }
    testWidgets(
      '$mode keyboard ring, hover and pressed scale stay distinct and legible',
      (tester) async {
        final hover = await resolve(tester, mode: mode, states: {.hovered});
        final focus = await resolve(tester, mode: mode, states: {.focused});
        final press = await resolve(
          tester,
          mode: mode,
          states: {.hovered, .pressed},
        );
        expect(
          decoration(hover.option.spec.container.spec).color,
          heroUiToken(HeroUiTokens.defaultColor, mode),
        );
        final ring =
            focus.option.spec.container.spec.foregroundDecoration!
                as BoxDecoration;
        expect(
          (ring.border! as Border).top.color,
          heroUiToken(HeroUiTokens.focus, mode),
        );
        expect((ring.border! as Border).top.width, 2);
        expect(
          focus.option.spec.container.spec.padding,
          hover.option.spec.container.spec.padding,
        );
        expect(
          focus.option.spec.container.spec.constraints,
          hover.option.spec.container.spec.constraints,
        );
        expect(
          press.option.spec.container.spec.transform,
          isNot(hover.option.spec.container.spec.transform),
        );
        final pressed = heroUiCase(
          'combobox-primary-item-pressed-list-box-item:Apricot',
          mode: mode,
        );
        final scale = double.parse(
          RegExp(
            r'matrix\(([^,]+)',
          ).firstMatch(pressed.styles['transform']!)![1]!,
        );
        expect(press.option.spec.container.spec.transform!.storage[0], scale);

        for (final spec in [hover, focus, press]) {
          expect(
            compositedContrast(
              foreground: spec.option.spec.label.spec.style!.color!,
              fill:
                  decoration(spec.option.spec.container.spec).color ??
                  const Color(0),
              panel: heroUiToken(HeroUiTokens.overlay, mode),
            ),
            greaterThanOrEqualTo(4.5),
          );
        }
        final custom = await resolve(
          tester,
          mode: mode,
          style: ComboboxStyler().option(
            ComboboxOptionStyler().onHovered(.color(HeroUiTokens.accent())),
          ),
          states: {.hovered},
        );
        expect(
          decoration(custom.option.spec.container.spec).color,
          heroUiToken(HeroUiTokens.accent, mode),
        );
      },
    );
    testWidgets(
      '$mode RTL 200 percent wraps suggestions and submits without layout errors',
      (tester) async {
        String? accepted;
        await tester.pumpHeroUi(
          Directionality(
            textDirection: .rtl,
            child: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(2)),
              child: SizedBox(
                width: 320,
                child: HeroUiCombobox<String>(
                  label: 'Destination',
                  onSelected: (value) => accepted = value,
                  optionsBuilder: (_) => const [
                    'San Sebastián, Basque Country · Spain',
                    'Santiago de Compostela, Galicia · Spain',
                  ],
                ),
              ),
            ),
          ),
          mode: mode,
        );
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
