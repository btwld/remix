import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/close_button.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../helpers/heroui.dart';

const _glyph = IconData(0xe000, fontFamily: 'Test');

/// `close-button.css`: `svg { size-4 }`.
const _iconSize = 16.0;

Future<IconButtonSpec> _pump(
  WidgetTester tester, {
  String mode = 'light',
  bool enabled = true,
  bool loading = false,
  IconData? icon,
  VoidCallback? onPressed,
  IconButtonStyler style = const IconButtonStyler.create(),
}) async {
  await tester.pumpHeroUi(
    icon == null
        ? HeroUiCloseButton(
            enabled: enabled,
            loading: loading,
            style: style,
            onPressed: onPressed ?? () {},
          )
        : HeroUiCloseButton(
            icon: icon,
            enabled: enabled,
            loading: loading,
            style: style,
            onPressed: onPressed ?? () {},
          ),
    mode: mode,
  );
  // A loading button's spinner never settles.
  loading
      ? await tester.pump(const Duration(milliseconds: 100))
      : await tester.pumpAndSettle();
  return _spec(tester);
}

/// The glyph sits below the surface, so it resolves the button spec.
IconButtonSpec _spec(WidgetTester tester) =>
    tester.resolvedSpecOf<IconButtonSpec>(find.byType(Icon));

Color? _fill(IconButtonSpec spec) => boxFill(spec.container);

/// The smallest scale among the glyph's ancestors; 1 when there is none.
double _scale(WidgetTester tester) => tester
    .widgetList<Transform>(
      find.ancestor(of: find.byType(Icon), matching: find.byType(Transform)),
    )
    .map((transform) => transform.transform.entry(0, 0))
    .fold(1.0, (a, b) => a < b ? a : b);

void main() {
  for (final mode in ['light', 'dark']) {
    testWidgets('matches upstream in $mode', (tester) async {
      final spec = await _pump(tester, mode: mode);
      final upstream = heroUiCase('close-button', mode: mode);

      expect(tester.getSize(find.byType(HeroUiCloseButton)), upstream.size);
      expect(
        (spec.container.spec.decoration! as BoxDecoration).borderRadius,
        BorderRadius.circular(upstream.px('borderRadius')),
      );
      expectCssColor(_fill(spec)!, upstream.styles['backgroundColor']!);
      expect(
        spec.container.spec.padding,
        EdgeInsets.all(upstream.px('paddingLeft')),
      );
      expectCssColor(spec.icon.spec.color!, upstream.styles['color']!);
      expect(spec.icon.spec.size, _iconSize);
      expect(tester.getSize(find.byType(Icon)), const Size.square(_iconSize));
    });
  }

  testWidgets('the default glyph is the icon library cross', (tester) async {
    await _pump(tester);
    expect(tester.widget<Icon>(find.byType(Icon)).icon, RemixIcons.cross2);
  });

  testWidgets('a caller icon replaces the cross', (tester) async {
    await _pump(tester, icon: _glyph);
    expect(find.byType(Icon), findsOneWidget);
    expect(tester.widget<Icon>(find.byType(Icon)).icon, _glyph);
  });

  for (final mode in ['light', 'dark']) {
    testWidgets('hover fills with default-hover, a pointer press scales it in '
        '$mode', (tester) async {
      await _pump(tester, mode: mode);
      final rest = heroUiCase('close-button', mode: mode);
      expect(_scale(tester), 1);

      final mouse = await tester.hoverCenter(find.byType(HeroUiCloseButton));
      final hover = heroUiCase('close-button-hover', mode: mode, state: true);
      expectCssColor(
        _fill(_spec(tester))!,
        hover.styles['backgroundColor']!,
        reason: 'hover',
      );

      await mouse.down(tester.getCenter(find.byType(HeroUiCloseButton)));
      await tester.pumpAndSettle();
      final pressed = heroUiCase(
        'close-button-pressed',
        mode: mode,
        state: true,
      );
      expect(
        _scale(tester),
        closeTo(pressed.size.width / rest.size.width, 1e-3),
      );
      expectCssColor(
        _fill(_spec(tester))!,
        pressed.styles['backgroundColor']!,
        reason: 'pressed',
      );
      await mouse.up();
    });

    testWidgets('a touch press scales without recoloring in $mode', (
      tester,
    ) async {
      await _pump(tester, mode: mode);
      final rest = heroUiCase('close-button', mode: mode);
      final touch = await tester.pressCenter(find.byType(HeroUiCloseButton));
      expect(
        _scale(tester),
        closeTo(
          heroUiCase(
                'close-button-pressed',
                mode: mode,
                state: true,
              ).size.width /
              rest.size.width,
          1e-3,
        ),
      );
      // close-button.css sets no fill on :active.
      expectCssColor(_fill(_spec(tester))!, rest.styles['backgroundColor']!);
      await touch.up();
    });

    testWidgets('keyboard focus draws the measured ring in $mode', (
      tester,
    ) async {
      final rest = await _pump(tester, mode: mode);
      expect(rest.containerEffects?.isEmpty ?? true, isTrue);
      final before = tester.getSize(find.byType(HeroUiCloseButton));

      await tester.focusWithTab();
      expectFocusRing(
        _spec(tester).containerEffects,
        heroUiCase('close-button-focus', mode: mode, state: true),
      );
      expect(tester.getSize(find.byType(HeroUiCloseButton)), before);
    });

    testWidgets('disabled and loading dim like upstream in $mode', (
      tester,
    ) async {
      var pressed = 0;
      await _pump(
        tester,
        enabled: false,
        mode: mode,
        onPressed: () => pressed++,
      );
      expect(
        tester.opacityAbove(find.byType(Icon)),
        double.parse(
          heroUiCase('close-button-disabled', mode: mode).styles['opacity']!,
        ),
      );
      await tester.tap(find.byType(HeroUiCloseButton));
      expect(pressed, 0);

      await _pump(
        tester,
        loading: true,
        mode: mode,
        onPressed: () => pressed++,
      );
      final pending = heroUiCase('close-button-pending', mode: mode);
      expect(
        tester.opacityAbove(find.byType(Icon)),
        double.parse(pending.styles['opacity']!),
      );
      expect(
        tester.getSize(find.byType(HeroUiCloseButton)),
        heroUiCase('close-button', mode: mode).size,
      );
      final spinner = tester.resolvedSpecOf<SpinnerSpec>(
        find.descendant(
          of: find.byType(RemixSpinner),
          matching: find.byType(CustomPaint),
        ),
      );
      expect(spinner.size, heroUiCase('spinner-accent-sm').size.width);
      // `<Spinner color="current">` takes the button's muted text colour.
      expectCssColor(spinner.indicatorColor!, pending.styles['color']!);
      await tester.tap(find.byType(HeroUiCloseButton));
      expect(pressed, 0);
    });
  }

  testWidgets('is labelled "Close" unless the caller says otherwise', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await _pump(tester);
    expect(find.bySemanticsLabel('Close'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('a caller style wins over the recipe', (tester) async {
    const override = Color(0xFF00FF00);
    final spec = await _pump(tester, style: IconButtonStyler().color(override));
    expect(_fill(spec), override);
  });

  testWidgets('pressing runs the Remix callback', (tester) async {
    var pressed = 0;
    await _pump(tester, onPressed: () => pressed++);
    await tester.tap(find.byType(HeroUiCloseButton));
    expect(pressed, 1);
  });
}
