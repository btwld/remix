import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/button.dart';
import 'package:registry_source/src/heroui/components/toast.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

const _glyph = IconData(0xe5cf);

String _id(HeroUiToastVariant variant) =>
    variant == .defaultToast ? 'default' : variant.name;

/// A toast in the upstream fixture's width. [titleOnly] drops the description
/// and the action, as the `toast-single-*` fixture does.
Widget _toast({
  HeroUiToastVariant variant = .defaultToast,
  VoidCallback? onDismiss,
  VoidCallback? onAction,
  bool titleOnly = false,
  ToastStyler style = const ToastStyler.create(),
  int viewport = 1024,
}) => SizedBox(
  width: heroUiCase('toast-default-root', width: viewport).size.width,
  child: HeroUiToast(
    variant: variant,
    style: style,
    title: 'Saved',
    description: titleOnly ? null : 'Changes are live.',
    icon: _glyph,
    onDismiss: onDismiss,
    dismissLabel: 'Dismiss',
    action: onAction == null || titleOnly
        ? null
        : RemixToastAction(label: 'Undo', onPressed: onAction),
  ),
);

ToastSpec _spec(WidgetTester tester) =>
    tester.resolvedSpecOf<ToastSpec>(find.text('Saved'));

BoxDecoration _box(ToastSpec spec) =>
    spec.container.spec.boxSpec.decoration! as BoxDecoration;

final _closeButton = find.byType(RemixIconButton);

/// The action button without the margin around it.
final _actionSurface = find
    .descendant(
      of: find.byType(RemixButton),
      matching: find.byType(DecoratedBox),
    )
    .first;

/// The cross is the one `CustomPaint` inside the button, so it resolves the
/// button spec at rest and while a focus ring wraps the surface.
IconButtonSpec _close(WidgetTester tester) =>
    tester.resolvedSpecOf<IconButtonSpec>(
      find
          .descendant(of: _closeButton, matching: find.byType(CustomPaint))
          .first,
    );

BoxDecoration _closeBox(WidgetTester tester) =>
    _close(tester).container.spec.decoration! as BoxDecoration;

void main() {
  test('variants follow HeroUI', () {
    expect(HeroUiToastVariant.values.map((variant) => variant.name), [
      'defaultToast',
      'accent',
      'success',
      'warning',
      'danger',
    ]);
  });

  for (final mode in ['light', 'dark']) {
    testWidgets('the surface follows toast.css in $mode', (tester) async {
      await tester.pumpHeroUi(
        _toast(onDismiss: () {}, onAction: () {}),
        mode: mode,
      );
      await tester.pumpAndSettle();
      final spec = _spec(tester);
      final root = heroUiCase('toast-default-root', mode: mode);

      // bg-surface, px-4 py-3, gap-1.5, shadow-overlay, min(32px, radius-3xl);
      // a toast with a description and an action is 64 high at 1024.
      expect(tester.getSize(find.byType(RemixToast)), root.size);
      expectCssColor(_box(spec).color!, root.styles['backgroundColor']!);
      expect(
        _box(spec).borderRadius,
        BorderRadius.circular(root.px('borderRadius')),
      );
      expect(
        spec.container.spec.boxSpec.padding,
        EdgeInsets.fromLTRB(
          root.px('paddingLeft'),
          root.px('paddingTop'),
          root.px('paddingRight'),
          root.px('paddingBottom'),
        ),
      );
      expect(spec.container.spec.flex!.spec.spacing, root.px('gap'));
      expect(
        behindShadows(spec.containerEffects),
        cssRemixShadows(root.styles['boxShadow']!),
      );
    });

    testWidgets('a title-only toast is as tall as toast-single in $mode', (
      tester,
    ) async {
      await tester.pumpHeroUi(
        _toast(titleOnly: true, onDismiss: () {}),
        mode: mode,
      );
      await tester.pumpAndSettle();
      expect(
        tester.getSize(find.byType(RemixToast)),
        heroUiCase('toast-single-root', mode: mode).size,
      );
    });

    testWidgets('the text takes text-sm with a medium title in $mode', (
      tester,
    ) async {
      await tester.pumpHeroUi(_toast(), mode: mode);
      await tester.pumpAndSettle();
      final spec = _spec(tester);
      final titleCase = heroUiCase('toast-default-title', mode: mode);
      final descriptionCase = heroUiCase(
        'toast-default-description',
        mode: mode,
      );

      // .toast__title: text-sm leading-5 font-medium; .toast__description:
      // text-sm text-muted.
      final title = spec.title.spec.style!;
      expect(title.fontSize, titleCase.px('fontSize'));
      expect(
        title.fontSize! * title.height!,
        closeTo(titleCase.px('lineHeight'), .01),
      );
      expect(title.fontWeight, FontWeight.w500);
      final description = spec.description.spec.style!;
      expect(description.fontSize, descriptionCase.px('fontSize'));
      expect(
        description.fontSize! * description.height!,
        closeTo(descriptionCase.px('lineHeight'), .01),
      );
      expectCssColor(description.color!, descriptionCase.styles['color']!);
      expect(tester.getSize(find.text('Saved')).height, titleCase.size.height);
    });

    testWidgets('the indicator is a size-4 icon with p-1 around it in $mode', (
      tester,
    ) async {
      await tester.pumpHeroUi(_toast(), mode: mode);
      await tester.pumpAndSettle();
      expect(
        _spec(tester).icon.spec.size,
        heroUiCase('toast-default-icon', mode: mode).size.width,
      );
      expect(
        tester.getSize(find.byType(StyledIcon)),
        heroUiCase('toast-default-indicator', mode: mode).size,
      );
    });

    testWidgets('variants color the title and the indicator in $mode', (
      tester,
    ) async {
      for (final variant in HeroUiToastVariant.values) {
        await tester.pumpHeroUi(_toast(variant: variant), mode: mode);
        await tester.pumpAndSettle();
        final spec = _spec(tester);
        final title = heroUiCase('toast-${_id(variant)}-title', mode: mode);
        final icon = heroUiCase('toast-${_id(variant)}-icon', mode: mode);
        // The accent toast keeps its indicator on overlay-foreground.
        expectCssColor(
          spec.title.spec.style!.color!,
          title.styles['color']!,
          reason: '${variant.name} title',
        );
        expectCssColor(
          spec.icon.spec.color!,
          icon.styles['color']!,
          reason: '${variant.name} icon',
        );
      }
    });

    for (final viewport in [375, 1024]) {
      testWidgets(
        'the close button follows toast.css at $viewport px in $mode',
        (tester) async {
          await tester.pumpHeroUi(
            _toast(onDismiss: () {}, viewport: viewport),
            width: viewport.toDouble(),
            mode: mode,
          );
          await tester.pumpAndSettle();
          final upstream = heroUiCase(
            'toast-default-close',
            mode: mode,
            width: viewport,
          );
          final icon = heroUiCase(
            'toast-default-close-icon',
            mode: mode,
            width: viewport,
          );

          // size-5; from sm up `border bg-overlay`, below it `bg-default`;
          // the icon is size-3.5, then sm:size-3.
          expect(tester.getSize(_closeButton), upstream.size);
          final decoration = _closeBox(tester);
          expectCssColor(
            decoration.color!,
            upstream.styles['backgroundColor']!,
          );
          expect(
            decoration.borderRadius,
            BorderRadius.circular(upstream.px('borderRadius')),
          );
          if (upstream.styles.containsKey('borderTopWidth')) {
            final border = decoration.border! as Border;
            expect(border.top.width, upstream.px('borderTopWidth'));
            expectCssColor(border.top.color, upstream.styles['borderColor']!);
          } else {
            expect(decoration.border, isNull);
          }
          final close = _close(tester);
          expect(close.icon.spec.size, icon.size.width);
          // The icon stays the close button's `text-muted`.
          expectCssColor(close.icon.spec.color!, icon.styles['color']!);
        },
      );
    }

    testWidgets(
      'hovering the close button fills it with default at 1024 px in $mode',
      (tester) async {
        await tester.pumpHeroUi(_toast(onDismiss: () {}), mode: mode);
        await tester.pumpAndSettle();
        await tester.hoverCenter(_closeButton);
        // toast.css hover: `bg-default`, not the close button's
        // `bg-default-hover`.
        expectCssColor(
          _closeBox(tester).color!,
          heroUiCase(
            'toast-default-close-hover-close',
            mode: mode,
            state: true,
          ).styles['backgroundColor']!,
        );
        expect(
          _closeBox(tester).color,
          isNot(heroUiToken(HeroUiTokens.defaultHover, mode)),
        );
      },
      variant: desktopOnly,
    );

    testWidgets(
      'hovering the close button fills it with default at 375 px in $mode',
      (tester) async {
        await tester.pumpHeroUi(
          _toast(onDismiss: () {}, viewport: 375),
          width: 375,
          mode: mode,
        );
        await tester.pumpAndSettle();
        await tester.hoverCenter(_closeButton);
        expect(
          _closeBox(tester).color,
          heroUiToken(HeroUiTokens.defaultColor, mode),
        );
      },
      variant: desktopOnly,
    );

    testWidgets('the close button keeps the close button focus ring in $mode', (
      tester,
    ) async {
      await tester.pumpHeroUi(_toast(onDismiss: () {}), mode: mode);
      await tester.pumpAndSettle();
      final before = tester.getSize(_closeButton);

      await tester.focusWithTab();
      // close-button-focus: a background gap, then a 2px focus ring.
      expectFocusRing(
        _close(tester).containerEffects,
        heroUiCase('close-button-focus', mode: mode, state: true),
      );
      expect(tester.getSize(_closeButton), before);
    });

    testWidgets('the close button scales while pressed in $mode', (
      tester,
    ) async {
      await tester.pumpHeroUi(_toast(onDismiss: () {}), mode: mode);
      await tester.pumpAndSettle();
      final press = await tester.pressCenter(_closeButton);
      final pressed = heroUiCase(
        'close-button-pressed',
        mode: mode,
        state: true,
      );
      final scale = tester
          .widgetList<Transform>(
            find.descendant(of: _closeButton, matching: find.byType(Transform)),
          )
          .map((transform) => transform.transform.entry(0, 0))
          .reduce((a, b) => a < b ? a : b);
      expect(
        scale,
        closeTo(
          pressed.size.width /
              heroUiCase('close-button', mode: mode).size.width,
          1e-3,
        ),
      );
      await press.up();
    });

    for (final viewport in [375, 1024]) {
      testWidgets('the action is the primary button at $viewport px in $mode', (
        tester,
      ) async {
        await tester.pumpHeroUi(
          _toast(onAction: () {}, viewport: viewport),
          width: viewport.toDouble(),
          mode: mode,
        );
        await tester.pumpAndSettle();
        final action = heroUiCase(
          'toast-default-action',
          mode: mode,
          width: viewport,
        );
        final button = tester.resolvedSpecOf<ButtonSpec>(find.text('Undo'));

        // Button md is h-10, md:h-9; the toast adds no styling of its own.
        expect(tester.getSize(_actionSurface).height, action.size.height);
        expectCssColor(
          boxFill(button.container.spec.box!)!,
          action.styles['backgroundColor']!,
        );
      });
    }
  }

  for (final mode in ['light', 'dark']) {
    testWidgets('the action sits under the message at 375 px as upstream in '
        '$mode', (tester) async {
      await tester.pumpHeroUi(
        _toast(onAction: () {}, viewport: 375),
        width: 375,
        mode: mode,
      );
      await tester.pumpAndSettle();
      final root = heroUiCase('toast-default-root', mode: mode, width: 375);
      final description = heroUiCase(
        'toast-default-description',
        mode: mode,
        width: 375,
      );
      final action = heroUiCase('toast-default-action', mode: mode, width: 375);

      expect(tester.getSize(find.byType(RemixToast)), root.size);
      final text = tester.getRect(find.text('Changes are live.'));
      final button = tester.getRect(_actionSurface);
      expect(button.left, text.left);
      expect(
        button.top - text.bottom,
        action.rect.top - description.rect.bottom,
      );
    });
  }

  group(
    'the action placement follows max-width: 768px and mt-2 below 640px',
    () {
      /// The action's surface and the description above it, at [viewport].
      Future<({Rect text, Rect action})> place(
        WidgetTester tester,
        double viewport, {
        ToastStyler style = const ToastStyler.create(),
      }) async {
        await tester.pumpHeroUi(
          _toast(onAction: () {}, style: style),
          width: viewport,
        );
        await tester.pumpAndSettle();
        return (
          text: tester.getRect(find.text('Changes are live.')),
          action: tester.getRect(_actionSurface),
        );
      }

      for (final viewport in [375.0, 639.5, 640.0, 768.0]) {
        testWidgets('is below the message at $viewport px', (tester) async {
          final placed = await place(tester, viewport);
          expect(placed.action.left, placed.text.left);
          expect(placed.action.top, greaterThanOrEqualTo(placed.text.bottom));
        });
      }

      testWidgets('is beside the message at 769 px', (tester) async {
        final placed = await place(tester, 769);
        expect(placed.action.left, greaterThanOrEqualTo(placed.text.right));
      });

      testWidgets('adds mt-2 below 640 px, to the last fraction, and nothing '
          'from 640 px', (tester) async {
        double gap(({Rect text, Rect action}) placed) =>
            placed.action.top - placed.text.bottom;
        final root = heroUiCase('toast-default-root');

        // Stacked, the gap is the toast's own `gap-1.5`; `mt-2` brings it to 8.
        expect(gap(await place(tester, 375)), 8);
        expect(gap(await place(tester, 639.5)), 8);
        expect(gap(await place(tester, 640)), root.px('gap'));
      });

      // An `action` replaces rather than merges, in the base style and in the
      // below-640 fragment the recipe declares.
      testWidgets('a caller action restates the button style in its base and '
          'in the below-640 fragment', (tester) async {
        const override = Color(0xFF00FF00);
        final below640 = ContextVariant.breakpoint(
          const Breakpoint.minWidth(HeroUiTokens.breakpointSm),
        );
        final wide = heroUiCase('toast-default-action');
        final narrow = heroUiCase('toast-default-action', width: 375);
        final narrowText = heroUiCase('toast-default-description', width: 375);

        Future<({Color? fill, double height, double gap})> measure(
          double viewport,
          ToastStyler style,
        ) async {
          final placed = await place(tester, viewport, style: style);
          return (
            fill: boxFill(
              tester
                  .resolvedSpecOf<ButtonSpec>(find.text('Undo'))
                  .container
                  .spec
                  .box!,
            ),
            height: placed.action.height,
            gap: placed.action.top - placed.text.bottom,
          );
        }

        final colorOnly = ToastStyler().action(ButtonStyler().color(override));
        final restated = ToastStyler().action(
          heroUiButtonStyle().color(override),
        );
        final complete = restated.onNot(
          below640,
          ToastStyler().action(
            heroUiButtonStyle().color(override).margin(.top(2)),
          ),
        );

        // From 640 px only the base action applies: the color alone drops the
        // button's size, the restated style keeps it.
        final partial = await measure(1024, colorOnly);
        expect(partial.fill, override);
        expect(partial.height, lessThan(wide.size.height));
        final whole = await measure(1024, restated);
        expect((whole.fill, whole.height), (override, wide.size.height));

        // Below 640 px the recipe's own action wins unless the caller restates
        // it, with the margin, in the same fragment.
        final recipeWins = await measure(375, restated);
        expect(recipeWins.fill, isNot(override));
        final full = await measure(375, complete);
        expect(full.fill, override);
        expect(full.height, narrow.size.height);
        expect(full.gap, narrow.rect.top - narrowText.rect.bottom);
        expect((await measure(639.5, complete)).fill, override);
      });
    },
  );

  testWidgets('the close button and the action work through Remix', (
    tester,
  ) async {
    var dismissed = 0;
    var undone = 0;
    await tester.pumpHeroUi(
      _toast(onDismiss: () => dismissed++, onAction: () => undone++),
    );
    await tester.tap(_closeButton);
    await tester.tap(find.text('Undo'));
    expect(dismissed, 1);
    expect(undone, 1);
  });

  testWidgets('a toast scope shows toasts in the recipe style', (tester) async {
    final controller = RemixToastController();
    addTearDown(controller.dispose);
    await tester.pumpHeroUi(
      RemixToastScope(
        controller: controller,
        style: heroUiToastStyle(variant: .success),
        child: const SizedBox(),
      ),
    );
    controller.showToast(const RemixToastData(title: 'Saved', icon: _glyph));
    await tester.pumpAndSettle();

    final spec = _spec(tester);
    expectCssColor(
      _box(spec).color!,
      heroUiCase('toast-success-root').styles['backgroundColor']!,
    );
    expectCssColor(
      spec.title.spec.style!.color!,
      heroUiCase('toast-success-title').styles['color']!,
    );
  });

  testWidgets('a caller style wins over the recipe', (tester) async {
    const override = Color(0xFF00FF00);
    await tester.pumpHeroUi(_toast(style: ToastStyler().color(override)));
    await tester.pumpAndSettle();
    expect(_box(_spec(tester)).color, override);
  });
}
