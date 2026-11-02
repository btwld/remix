import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/search_field.dart';
import 'package:registry_source/src/heroui/components/textfield.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../helpers/heroui.dart';

const _modes = ['light', 'dark'];

/// Upstream renders the search field 320px wide, with a label and description.
Widget _search(
  TextEditingController controller, {
  HeroUiTextFieldVariant variant = .primary,
  bool labeled = true,
  bool enabled = true,
  bool error = false,
  VoidCallback? onClear,
  TextFieldStyler style = const TextFieldStyler.create(),
}) => SizedBox(
  width: 320,
  child: HeroUiSearchField(
    variant: variant,
    controller: controller,
    enabled: enabled,
    error: error,
    style: style,
    label: labeled ? 'Search' : null,
    helperText: labeled ? 'Find anything.' : null,
    hintText: 'Search',
    leading: const HeroUiSearchIcon(),
    trailing: HeroUiSearchClearButton(enabled: enabled, onPressed: onClear),
  ),
);

Future<TextFieldSpec> _pump(
  WidgetTester tester,
  TextEditingController controller, {
  HeroUiTextFieldVariant variant = .primary,
  bool labeled = false,
  bool enabled = true,
  bool error = false,
  TextFieldStyler style = const TextFieldStyler.create(),
  String mode = 'light',
  int width = 1024,
}) async {
  await tester.pumpHeroUi(
    _search(
      controller,
      variant: variant,
      labeled: labeled,
      enabled: enabled,
      error: error,
      style: style,
    ),
    mode: mode,
    width: width.toDouble(),
  );
  await tester.pumpAndSettle();
  return _spec(tester);
}

TextFieldSpec _spec(WidgetTester tester) =>
    tester.resolvedSpecOf<TextFieldSpec>(find.byType(EditableText));

Color? _fill(TextFieldSpec spec) =>
    (spec.container.spec.decoration as BoxDecoration?)?.color;

IconButtonSpec _clearSpec(WidgetTester tester) =>
    tester.resolvedSpecOf<IconButtonSpec>(find.byIcon(RemixIcons.close));

Color? _clearFill(WidgetTester tester) =>
    (_clearSpec(tester).container.spec.decoration as BoxDecoration?)?.color;

/// Runs the 150ms state transition; the caret blink never lets
/// `pumpAndSettle` finish.
Future<void> _focus(WidgetTester tester) async {
  await tester.tap(find.byType(EditableText));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  for (final mode in _modes) {
    for (final width in [375, 1024]) {
      for (final variant in HeroUiTextFieldVariant.values) {
        testWidgets('${variant.name} matches upstream at $width px in $mode', (
          tester,
        ) async {
          final controller = TextEditingController(text: 'query');
          addTearDown(controller.dispose);
          final spec = await _pump(
            tester,
            controller,
            variant: variant,
            labeled: true,
            mode: mode,
            width: width,
          );
          String id(String part) =>
              'search-${variant.name}-full-rest${part.isEmpty ? '' : '-$part'}';
          final root = heroUiCase(id(''), mode: mode, width: width);
          final group = heroUiCase(id('group'), mode: mode, width: width);
          final input = heroUiCase(id('input'), mode: mode, width: width);
          final icon = heroUiCase(id('icon'), mode: mode, width: width);
          final clear = heroUiCase(id('clear'), mode: mode, width: width);

          expect(tester.getSize(find.byType(HeroUiSearchField)), root.size);
          final box = spec.container.spec;
          expect(box.constraints!.maxHeight, group.size.height);
          expect(
            (box.decoration as BoxDecoration).borderRadius,
            BorderRadius.circular(group.px('borderRadius')),
          );
          expectCssColor(
            _fill(spec)!,
            group.styles['backgroundColor']!,
            reason: 'fill',
          );
          expectShadows(
            behindShadows(spec.containerEffects),
            cssShadows(group.styles['boxShadow'] ?? ''),
          );
          expect(tester.getSize(find.byType(HeroUiSearchIcon)), icon.size);
          expect(tester.getSize(find.byType(RemixIconButton)), clear.size);
          // The upstream input includes its `ps-2` and `pe-2`.
          expect(
            tester.getSize(find.byType(EditableText)).width,
            input.size.width -
                input.px('paddingLeft') -
                input.px('paddingRight'),
          );
          expect(spec.text.spec.style!.fontSize, input.px('fontSize'));
        });
      }
    }
  }

  for (final mode in _modes) {
    testWidgets('the icon is size-4 in the placeholder color in $mode', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await _pump(tester, controller, mode: mode);
      final icon = tester.widget<Icon>(find.byIcon(RemixIcons.search));
      final upstream = heroUiCase('search-primary-full-rest-icon', mode: mode);
      expect(icon.size, upstream.size.width);
      expect(icon.color, heroUiToken(HeroUiTokens.fieldPlaceholder, mode));
    });

    // The clear button is a pure recipe: the close button at `size-5` with a
    // `size-3` icon (`.search-field__clear-button`).
    testWidgets('the clear button is the close button sized for the field in '
        '$mode', (tester) async {
      await tester.pumpHeroUi(
        HeroUiSearchClearButton(onPressed: () {}),
        mode: mode,
      );
      await tester.pumpAndSettle();
      final clear = heroUiCase('search-primary-full-rest-clear', mode: mode);
      final spec = _clearSpec(tester);
      final box = spec.container.spec;

      expect(tester.getSize(find.byType(RemixIconButton)), clear.size);
      expect(box.padding, EdgeInsets.all(clear.px('paddingTop')));
      expect(
        (box.decoration as BoxDecoration).borderRadius,
        BorderRadius.circular(clear.px('borderRadius')),
      );
      expectCssColor(
        _clearFill(tester)!,
        clear.styles['backgroundColor']!,
        reason: 'fill',
      );
      expectCssColor(
        spec.icon.spec.color!,
        clear.styles['color']!,
        reason: 'icon',
      );
      // `[data-slot="close-button-icon"] { size-3 }`.
      expect(spec.icon.spec.size, 12);
    });

    testWidgets(
      'the clear button hovers with the close button fill in $mode',
      (tester) async {
        await tester.pumpHeroUi(
          HeroUiSearchClearButton(onPressed: () {}),
          mode: mode,
        );
        await tester.pumpAndSettle();
        await tester.hoverCenter(find.byType(RemixIconButton));
        final hover = heroUiCase('close-button-hover', mode: mode, state: true);
        expectCssColor(
          _clearFill(tester)!,
          hover.styles['backgroundColor']!,
          reason: 'hover',
        );
      },
      variant: desktopOnly,
    );

    testWidgets('a disabled clear button carries its own 0.5 in $mode', (
      tester,
    ) async {
      await tester.pumpHeroUi(
        const HeroUiSearchClearButton(enabled: false),
        mode: mode,
      );
      await tester.pumpAndSettle();
      final disabled = heroUiCase(
        'search-primary-intrinsic-disabled-clear',
        mode: mode,
      );
      expect(
        tester.opacityAbove(find.byIcon(RemixIcons.close)),
        double.parse(disabled.styles['opacity']!),
      );
    });
  }

  testWidgets('the clear button shows the cross and says what it clears', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpHeroUi(HeroUiSearchClearButton(onPressed: () {}));
    await tester.pumpAndSettle();
    expect(find.byIcon(RemixIcons.close), findsOneWidget);
    expect(find.bySemanticsLabel('Clear search'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('the clear button runs only the callback it is given', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'query');
    addTearDown(controller.dispose);
    var pressed = 0;
    await tester.pumpHeroUi(
      SizedBox(
        width: 320,
        child: HeroUiSearchField(
          controller: controller,
          trailing: HeroUiSearchClearButton(onPressed: () => pressed++),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(RemixIconButton));
    expect(pressed, 1);
    // Nothing in the preset reads or clears the app's controller.
    expect(controller.text, 'query');
  });

  testWidgets('an app shows the clear button for text and clears its own '
      'controller', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    final changes = <String>[];
    await tester.pumpHeroUi(
      SizedBox(
        width: 320,
        child: HeroUiSearchField(
          controller: controller,
          hintText: 'Search',
          onChanged: changes.add,
          leading: const HeroUiSearchIcon(),
          trailing: ListenableBuilder(
            listenable: controller,
            builder: (context, _) => controller.text.isEmpty
                ? const SizedBox.shrink()
                : HeroUiSearchClearButton(onPressed: controller.clear),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(HeroUiSearchClearButton), findsNothing);

    await tester.enterText(find.byType(EditableText), 'dart');
    await tester.pump();
    expect(find.byType(HeroUiSearchClearButton), findsOneWidget);
    expect(changes, ['dart']);

    await tester.tap(find.byType(HeroUiSearchClearButton));
    await tester.pump();
    expect(controller.text, isEmpty);
    expect(find.byType(HeroUiSearchClearButton), findsNothing);
  });

  for (final mode in _modes) {
    for (final variant in HeroUiTextFieldVariant.values) {
      testWidgets(
        'error rings the ${variant.name} group with danger in $mode',
        (tester) async {
          final controller = TextEditingController();
          addTearDown(controller.dispose);
          final spec = await _pump(
            tester,
            controller,
            variant: variant,
            error: true,
            labeled: true,
            mode: mode,
          );
          final group = heroUiCase(
            'search-${variant.name}-full-invalid-group',
            mode: mode,
          );
          final fieldError = heroUiCase(
            'search-primary-full-invalid-error',
            mode: mode,
          );
          final danger = heroUiToken(HeroUiTokens.danger, mode);
          // `invalid-field-ring`: `outline-1 outline-danger`.
          expect(spec.containerEffects!.outline.width, 1);
          expect(spec.containerEffects!.outline.color, danger);
          expect(spec.container.spec.constraints!.maxHeight, group.size.height);
          expectCssColor(
            _fill(spec)!,
            group.styles['backgroundColor']!,
            reason: 'fill',
          );
          expectCssColor(
            spec.label.spec.style!.color!,
            fieldError.styles['color']!,
            reason: 'label',
          );
          expectCssColor(
            spec.helperText.spec.style!.color!,
            fieldError.styles['color']!,
            reason: 'message',
          );
        },
      );

      testWidgets(
        'hovering the ${variant.name} group fills it with the hover color in '
        '$mode',
        (tester) async {
          final controller = TextEditingController();
          addTearDown(controller.dispose);
          await _pump(tester, controller, variant: variant, mode: mode);
          await tester.hoverCenter(find.byType(EditableText));
          expect(
            _fill(_spec(tester)),
            heroUiToken(
              variant == .primary
                  ? HeroUiTokens.fieldHover
                  : HeroUiTokens.defaultHover,
              mode,
            ),
          );
        },
        variant: desktopOnly,
      );
    }

    testWidgets('focus rings the group, and an error makes it a 2px danger '
        'ring in $mode', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await _pump(tester, controller, mode: mode);
      await _focus(tester);
      // `ring-2` as measured on `input-invalid-focus`; `status-focused-field`
      // is the same width.
      final focus = heroUiCase('input-invalid-focus', mode: mode, state: true);
      final ring = cssRemixShadows(focus.styles['boxShadow']!).singleWhere(
        (shadow) => shadow.blurRadius == 0 && shadow.spreadRadius > 0,
      );
      var effects = _spec(tester).containerEffects!;
      expect(effects.outline.width, ring.spreadRadius);
      expect(effects.outline.color, heroUiToken(HeroUiTokens.focus, mode));

      await _pump(tester, controller, error: true, mode: mode);
      await _focus(tester);
      effects = _spec(tester).containerEffects!;
      expect(effects.outline.width, ring.spreadRadius);
      expect(effects.outline.color, heroUiToken(HeroUiTokens.danger, mode));
    });
  }

  testWidgets('disabled dims the group and the clear button, not the '
      'description', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpHeroUi(_search(controller, enabled: false));
    await tester.pumpAndSettle();
    final group = heroUiCase('search-primary-intrinsic-disabled-group');
    final clear = heroUiCase('search-primary-intrinsic-disabled-clear');
    final description = heroUiCase(
      'search-primary-intrinsic-disabled-description',
    );
    expect(
      tester.opacityAbove(find.byType(EditableText)),
      double.parse(group.styles['opacity']!),
    );
    // The browser compounds the group's dimming and the button's own.
    expect(
      tester.opacityAbove(find.byIcon(RemixIcons.close)),
      double.parse(group.styles['opacity']!) *
          double.parse(clear.styles['opacity']!),
    );
    expect(description.styles.containsKey('opacity'), isFalse);
    expect(tester.opacityAbove(find.text('Find anything.')), 1);
  });

  testWidgets('a caller style wins over the recipe', (tester) async {
    const override = Color(0xFF00FF00);
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    final spec = await _pump(
      tester,
      controller,
      style: TextFieldStyler().color(override),
    );
    expect(_fill(spec), override);
  });
}
