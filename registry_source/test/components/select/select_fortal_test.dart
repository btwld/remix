import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
// `RemixBoxAdapter` is `@internal` to `remix`, but the panel is only reachable
// through the box Remix draws around the options. Suppressed per use below.
import 'package:remix/src/rendering/remix_box_effects.dart';
// Deliberate: RemixPathIcon/RemixPathGlyph stay unexported, but this suite
// pins the *glyph* the trigger draws, not just that some widget sits under the
// indicator key. Exporting them to satisfy a test would widen the public API
// for no consumer, so the private import is the cheaper coupling. If that file
// moves, retarget this import rather than weakening the assertion.
import 'package:remix/src/utilities/remix_path_icon.dart';
import 'package:registry_source/fortal.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('focus-visible behavior', () {
    late FocusHighlightStrategy previousStrategy;

    setUp(() {
      previousStrategy = FocusManager.instance.highlightStrategy;
    });

    tearDown(() {
      FocusManager.instance.highlightStrategy = previousStrategy;
    });

    testWidgets('focused select hides its ring in touch mode', (tester) async {
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTouch;
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await tester.pumpRemixApp(
        FortalSelect<String>(
          trigger: const RemixSelectTrigger(placeholder: 'Choose'),
          items: const [RemixSelectItem(value: 'a', label: 'Apple')],
          onChanged: (_) {},
          focusNode: focusNode,
        ),
      );
      await tester.pumpAndSettle();

      focusNode.requestFocus();
      await tester.pumpAndSettle();

      expect(focusNode.hasFocus, isTrue);
      final spec = tester.resolvedSpecOf<SelectTriggerSpec>(
        find.text('Choose'),
      );
      expect(
        spec.containerEffects?.outline.style ?? BorderStyle.none,
        BorderStyle.none,
      );
      expect(spec.containerEffects?.overContent, isNull);
    });
  });

  group('Fortal Select geometry', () {
    for (final (size, expected)
        in <
          (
            FortalSelectSize,
            ({
              double triggerHeight,
              double triggerPadding,
              double gap,
              double triggerRadius,
              double triggerIndicatorSize,
              double contentPadding,
              double contentRadius,
              double itemHeight,
              double indicatorWidth,
              double indicatorSize,
              double itemRadius,
              double itemFontSize,
            }),
          )
        >[
          (
            FortalSelectSize.size1,
            (
              triggerHeight: 32,
              triggerPadding: 13,
              gap: 12,
              triggerRadius: 14,
              triggerIndicatorSize: 16,
              contentPadding: 6,
              contentRadius: 16,
              itemHeight: 36,
              indicatorWidth: 24,
              indicatorSize: 16,
              itemRadius: 10,
              itemFontSize: 13,
            ),
          ),
          (
            FortalSelectSize.size2,
            (
              triggerHeight: 40,
              triggerPadding: 13,
              gap: 12,
              triggerRadius: 14,
              triggerIndicatorSize: 16,
              contentPadding: 6,
              contentRadius: 16,
              itemHeight: 36,
              indicatorWidth: 24,
              indicatorSize: 16,
              itemRadius: 10,
              itemFontSize: 13,
            ),
          ),
          (
            FortalSelectSize.size3,
            (
              triggerHeight: 44,
              triggerPadding: 13,
              gap: 12,
              triggerRadius: 14,
              triggerIndicatorSize: 16,
              contentPadding: 6,
              contentRadius: 16,
              itemHeight: 36,
              indicatorWidth: 24,
              indicatorSize: 16,
              itemRadius: 10,
              itemFontSize: 13,
            ),
          ),
        ]) {
      testWidgets('${size.name} matches the Fortal metrics', (tester) async {
        final spec = await _resolve(tester, fortalSelectStyle(size: size));
        final trigger = spec.trigger.spec;
        final triggerBox = trigger.container.spec.box!.spec;
        final content = spec.content.spec;
        final item = spec.item.spec;
        final itemBox = item.container.spec.box!.spec;

        expect(triggerBox.constraints!.minHeight, expected.triggerHeight);
        expect(triggerBox.constraints!.maxHeight, expected.triggerHeight);
        expect(
          triggerBox.padding,
          EdgeInsets.symmetric(horizontal: expected.triggerPadding),
        );
        expect(trigger.container.spec.flex!.spec.spacing, expected.gap);
        expect(_radius(triggerBox), expected.triggerRadius);
        expect(trigger.indicator.spec.size, expected.triggerIndicatorSize);

        // The list adds 2px above and below the panel's own inset.
        expect(
          content.container.spec.padding,
          EdgeInsets.symmetric(
            horizontal: expected.contentPadding,
            vertical: expected.contentPadding + 2,
          ),
        );
        expect(_radius(content.container.spec), expected.contentRadius);
        expect(content.container.spec.clipBehavior, Clip.antiAlias);

        expect(itemBox.constraints!.minHeight, expected.itemHeight);
        expect(itemBox.constraints!.maxHeight, expected.itemHeight);
        expect(itemBox.padding, const EdgeInsets.only(left: 11, right: 10));
        expect(_radius(itemBox), expected.itemRadius);
        expect(
          item.indicator.spec.constraints!.minWidth,
          expected.indicatorWidth,
        );
        expect(
          item.indicator.spec.constraints!.maxWidth,
          expected.indicatorWidth,
        );
        expect(item.icon.spec.size, expected.indicatorSize);
        expect(item.text.spec.style!.fontSize, expected.itemFontSize);
      });
    }

    testWidgets('all scalable metrics follow Fortal scaling', (tester) async {
      final spec = await _resolve(
        tester,
        fortalSelectStyle(size: .size1),
        scaling: .percent110,
      );
      final triggerBox = spec.trigger.spec.container.spec.box!.spec;
      final item = spec.item.spec;

      expect(triggerBox.constraints!.minHeight, closeTo(35.2, 1e-9));
      // 12px scaled plus the 1px frame, which does not scale.
      expect(
        triggerBox.padding!.resolve(TextDirection.ltr).left,
        closeTo(14.2, 1e-9),
      );
      expect(item.indicator.spec.constraints!.minWidth, closeTo(26.4, 1e-9));
      expect(
        item.container.spec.box!.spec.constraints!.minHeight,
        closeTo(39.6, 1e-9),
      );
      expect(item.icon.spec.size, closeTo(17.6, 1e-9));
      expect(item.text.spec.style!.fontSize, closeTo(14.3, 1e-9));
      expect(spec.trigger.spec.indicator.spec.size, closeTo(17.6, 1e-9));
    });

    testWidgets('full radius promotes only the trigger to a pill', (
      tester,
    ) async {
      final spec = await _resolve(
        tester,
        fortalSelectStyle(size: .size2),
        radius: .full,
      );

      expect(_radius(spec.trigger.spec.container.spec.box!.spec), 9999);
      expect(_radius(spec.content.spec.container.spec), 24);
      expect(_radius(spec.item.spec.container.spec.box!.spec), 15);
    });
  });

  group('Fortal Select panel width', () {
    // select.css:45 gives the content `min-width: var(--radix-select-trigger-width)`.
    Future<({double trigger, double panel})> openedWidths(
      WidgetTester tester, {
      required double triggerWidth,
      required String label,
      required FortalSelectSize size,
    }) async {
      await tester.pumpRemixApp(
        SizedBox(
          width: triggerWidth,
          child: FortalSelect<String>(
            size: size,
            trigger: const RemixSelectTrigger(placeholder: 'Choose'),
            items: [RemixSelectItem(value: 'a', label: label)],
            onChanged: (_) {},
            positioning: const OverlayPositionConfig(
              side: .bottom,
              alignment: .start,
            ),
          ),
        ),
      );
      await tester.tap(find.byType(RemixSelect<String>));
      await tester.pumpAndSettle();

      // The panel is the outermost box above an option's label.
      final panel = find
          .ancestor(
            of: find.text(label),
            // ignore: invalid_use_of_internal_member
            matching: find.byType(RemixBoxAdapter),
          )
          .last;
      return (
        trigger: tester.getSize(find.byType(RemixSelect<String>)).width,
        panel: tester.getSize(panel).width,
      );
    }

    for (final size in FortalSelectSize.values) {
      testWidgets('${size.name} panel is as wide as a wider trigger', (
        tester,
      ) async {
        final widths = await openedWidths(
          tester,
          triggerWidth: 280,
          label: 'A',
          size: size,
        );

        expect(widths.trigger, 280);
        expect(widths.panel, 280);
      });

      testWidgets('${size.name} panel grows past a narrower trigger', (
        tester,
      ) async {
        final widths = await openedWidths(
          tester,
          triggerWidth: 100,
          label: 'An option label wider than the trigger',
          size: size,
        );

        expect(widths.panel, greaterThan(widths.trigger));
      });
    }
  });

  group('Fortal Select panel width override', () {
    testWidgets('a maxWidth below the trigger works once minWidth is reset', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        SizedBox(
          width: 280,
          child: FortalSelect<String>(
            style: SelectStyler().content(
              SelectContentStyler().maxWidth(120).minWidth(0),
            ),
            trigger: const RemixSelectTrigger(placeholder: 'Choose'),
            items: const [
              RemixSelectItem(
                value: 'a',
                label: 'An option label wider than the cap',
              ),
            ],
            onChanged: (_) {},
            positioning: const OverlayPositionConfig(
              side: .bottom,
              alignment: .start,
            ),
          ),
        ),
      );
      await tester.tap(find.byType(RemixSelect<String>));
      await tester.pumpAndSettle();

      final panel = find
          .ancestor(
            of: find.text('An option label wider than the cap'),
            // ignore: invalid_use_of_internal_member
            matching: find.byType(RemixBoxAdapter),
          )
          .last;
      expect(tester.getSize(panel).width, 120);
      expect(tester.takeException(), isNull);
    });
  });

  group('Fortal Select state recipes', () {
    testWidgets('surface trigger uses exact idle, open, and disabled roles', (
      tester,
    ) async {
      final idle = await _resolve(tester, fortalSelectStyle());
      final open = await _resolve(
        tester,
        fortalSelectStyle(),
        states: {WidgetState.selected},
      );
      final disabledHover = await _resolve(
        tester,
        fortalSelectStyle(),
        states: {WidgetState.disabled, WidgetState.hovered},
      );
      final tokens = await _tokens(tester);
      Color frame(SelectSpec spec) => spec
          .trigger
          .spec
          .containerEffects!
          .behindContent!
          .shadows
          .single
          .color;

      expect(_flexColor(idle.trigger.spec.container), tokens.colorSurface);
      expect(
        idle.trigger.spec.containerEffects!.behindContent!.shadows.single.kind,
        RemixBoxShadowKind.inset,
      );
      expect(frame(idle), tokens.gray7);
      expect(idle.trigger.spec.indicatorOpacity, 1);
      expect(idle.trigger.spec.indicatorAngle ?? 0, 0);
      expect(idle.trigger.spec.indicator.spec.color, tokens.gray10);
      expect(idle.trigger.spec.selectedWhileOpen, isTrue);

      expect(frame(open), tokens.gray8);
      expect(_flexColor(open.trigger.spec.container), tokens.gray3);
      expect(open.trigger.spec.indicatorAngle, closeTo(math.pi, 1e-9));

      expect(frame(disabledHover), tokens.gray7);
      expect(
        _flexColor(disabledHover.trigger.spec.container),
        tokens.colorSurface,
      );
      expect(
        disabledHover.trigger.widgetModifiers!
            .whereType<OpacityModifier>()
            .single
            .opacity,
        0.5,
      );
    });

    testWidgets('focus uses a solid step-8 outside outline', (tester) async {
      final focused = await _resolve(
        tester,
        fortalSelectStyle(),
        states: {WidgetState.focused},
      );
      final tokens = await _tokens(tester);
      final effects = focused.trigger.spec.containerEffects!;
      expect(effects.outline.color, tokens.focus8);
      expect(effects.outline.width, 2);
      expect(effects.outlineOffset, 2);
      expect(effects.overContent, isNull);
    });

    testWidgets('soft and ghost own the specified muted fills', (tester) async {
      final soft = await _resolve(tester, fortalSelectStyle(variant: .soft));
      final softOpen = await _resolve(
        tester,
        fortalSelectStyle(variant: .soft),
        states: {WidgetState.selected},
      );
      final ghost = await _resolve(tester, fortalSelectStyle(variant: .ghost));
      final tokens = await _tokens(tester);

      expect(_flexColor(soft.trigger.spec.container), tokens.gray3);
      expect(_flexColor(softOpen.trigger.spec.container), tokens.gray4);
      expect(soft.trigger.spec.label.spec.style!.color, tokens.gray12);
      expect(_flexColor(ghost.trigger.spec.container), Colors.transparent);
      final ghostBox = ghost.trigger.spec.container.spec.box!.spec;
      expect(
        ghostBox.padding,
        const EdgeInsets.all(0).copyWith(left: 8, right: 8, top: 4, bottom: 4),
      );
      expect(
        ghostBox.margin,
        const EdgeInsets.symmetric(horizontal: -8, vertical: -4),
      );
      expect(ghostBox.constraints, isNull);
    });
  });

  testWidgets('uses the retained indicator and thick-check vector paths', (
    tester,
  ) async {
    await tester.pumpWidget(
      FortalTheme(
        accent: .mar,
        child: WidgetsApp(
          color: const Color(0xFFFFFFFF),
          pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
            settings: settings,
            pageBuilder: (context, _, _) => builder(context),
          ),
          home: FortalSelect<String>(
            trigger: const RemixSelectTrigger(placeholder: 'Choose'),
            items: const [RemixSelectItem(value: 'a', label: 'Apple')],
            selectedValue: 'a',
            onChanged: (_) {},
          ),
        ),
      ),
    );

    final triggerIndicator = find.byKey(
      const ValueKey('remix-select-indicator'),
    );
    expect(triggerIndicator, findsOneWidget);
    expect(
      tester.widget<RemixPathIcon>(triggerIndicator).glyph,
      RemixPathGlyph.chevronDown,
    );
    expect(find.byIcon(Icons.keyboard_arrow_down), findsNothing);

    await tester.tap(find.byType(RemixSelect<String>));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('fortal-select-indicator')),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.check), findsNothing);
  });
}

Future<SelectSpec> _resolve(
  WidgetTester tester,
  SelectStyler style, {
  Set<WidgetState> states = const {},
  FortalScaling scaling = .percent100,
  FortalRadius radius = .medium,
  Brightness brightness = .light,
}) async {
  late SelectSpec resolved;
  await tester.pumpWidget(
    FortalTheme(
      accent: .mar,
      mode: brightness == Brightness.dark ? .dark : .light,
      scaling: scaling,
      radius: radius,
      child: WidgetsApp(
        color: Colors.black,
        builder: (context, child) => WidgetStateStyleOverride(
          states: states,
          child: Builder(
            builder: (context) {
              resolved = style.build(context).spec;
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    ),
  );
  return resolved;
}

Future<
  ({
    Color colorSurface,
    Color grayA2,
    Color grayA5,
    Color grayA6,
    Color grayA7,
    Color gray3,
    Color gray4,
    Color gray7,
    Color gray8,
    Color gray10,
    Color grayA8,
    Color grayA9,
    Color grayA11,
    Color grayA12,
    Color gray12,
    Color accent1,
    Color accent9,
    Color accent12,
    Color accentA3,
    Color accentA4,
    Color accentContrast,
    Color focus8,
    Color whiteA4,
    Color whiteA11,
    Color blackA9,
  })
>
_tokens(WidgetTester tester, {Brightness brightness = .light}) async {
  late ({
    Color colorSurface,
    Color grayA2,
    Color grayA5,
    Color grayA6,
    Color grayA7,
    Color gray3,
    Color gray4,
    Color gray7,
    Color gray8,
    Color gray10,
    Color grayA8,
    Color grayA9,
    Color grayA11,
    Color grayA12,
    Color gray12,
    Color accent1,
    Color accent9,
    Color accent12,
    Color accentA3,
    Color accentA4,
    Color accentContrast,
    Color focus8,
    Color whiteA4,
    Color whiteA11,
    Color blackA9,
  })
  result;
  await tester.pumpWidget(
    FortalTheme(
      accent: .mar,
      mode: brightness == Brightness.dark ? .dark : .light,
      child: WidgetsApp(
        color: Colors.black,
        builder: (context, child) {
          Color token(ColorToken value) => MixScope.tokenOf(value, context);
          result = (
            colorSurface: token(FortalTokens.colorSurface),
            grayA2: token(FortalTokens.grayA2),
            grayA5: token(FortalTokens.grayA5),
            grayA6: token(FortalTokens.grayA6),
            grayA7: token(FortalTokens.grayA7),
            gray3: token(FortalTokens.gray3),
            gray4: token(FortalTokens.gray4),
            gray7: token(FortalTokens.gray7),
            gray8: token(FortalTokens.gray8),
            gray10: token(FortalTokens.gray10),
            grayA8: token(FortalTokens.grayA8),
            grayA9: token(FortalTokens.grayA9),
            grayA11: token(FortalTokens.grayA11),
            grayA12: token(FortalTokens.grayA12),
            gray12: token(FortalTokens.gray12),
            accent1: token(FortalTokens.accent1),
            accent9: token(FortalTokens.accent9),
            accent12: token(FortalTokens.accent12),
            accentA3: token(FortalTokens.accentA3),
            accentA4: token(FortalTokens.accentA4),
            accentContrast: token(FortalTokens.accentContrast),
            focus8: token(FortalTokens.focus8),
            whiteA4: token(FortalTokens.whiteA4),
            whiteA11: token(FortalTokens.whiteA11),
            blackA9: token(FortalTokens.blackA9),
          );
          return const SizedBox.shrink();
        },
      ),
    ),
  );
  return result;
}

double? _radius(BoxSpec spec) {
  return (spec.decoration as BoxDecoration?)?.borderRadius
      ?.resolve(TextDirection.ltr)
      .topLeft
      .x;
}

Color? _flexColor(StyleSpec<FlexBoxSpec> style) =>
    (style.spec.box?.spec.decoration as BoxDecoration?)?.color;
