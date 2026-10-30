import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/button.dart';
import 'package:registry_source/src/heroui/components/modal.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

/// The upstream fixture's one-line body.
const _description = 'Delete this project.';

/// Wraps to several lines in the narrowest dialog, so the dialog reaches its
/// size cap.
const _longDescription =
    'This will permanently delete the project and every file in it. '
    'This action cannot be undone, so make sure you have a copy first.';

Widget _opener({
  HeroUiModalSize size = .md,
  HeroUiModalPlacement placement = .auto,
  DialogStyler style = const DialogStyler.create(),
  bool alert = false,
  String description = _description,
}) => Builder(
  builder: (context) {
    Widget dialog(BuildContext _) => HeroUiModal(
      size: size,
      placement: placement,
      style: style,
      title: 'Delete project',
      description: description,
      actions: [
        HeroUiButton(label: 'Cancel', variant: .secondary, onPressed: () {}),
        HeroUiButton(label: 'Delete', onPressed: () {}),
      ],
    );
    return GestureDetector(
      onTap: () => alert
          ? showRemixAlertDialog<void>(
              context: context,
              semanticLabel: 'Delete project',
              builder: dialog,
            )
          : showRemixDialog<void>(
              context: context,
              barrierLabel: 'Dismiss',
              barrierColor: HeroUiTokens.backdrop.resolve(context),
              builder: dialog,
            ),
      child: const Text('Open'),
    );
  },
);

Future<void> _open(WidgetTester tester) async {
  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
}

Future<void> _close(WidgetTester tester) async {
  await tester.tapAt(const Offset(2, 2));
  await tester.pumpAndSettle();
}

Finder get _surface => find
    .ancestor(
      of: find.text('Delete project'),
      matching: find.byType(DecoratedBox),
    )
    .first;

DialogSpec _spec(WidgetTester tester) =>
    tester.resolvedSpecOf<DialogSpec>(find.text('Delete project'));

BoxDecoration _box(DialogSpec spec) =>
    spec.container.spec.decoration! as BoxDecoration;

void main() {
  test('sizes and placements follow HeroUI', () {
    expect(HeroUiModalSize.values.map((size) => size.name), [
      'xs',
      'sm',
      'md',
      'lg',
      'cover',
      'full',
    ]);
    expect(HeroUiModalPlacement.values.map((placement) => placement.name), [
      'auto',
      'center',
      'top',
      'bottom',
    ]);
  });

  for (final mode in ['light', 'dark']) {
    testWidgets('the surface follows modal.css in $mode', (tester) async {
      await tester.pumpHeroUi(_opener(), mode: mode);
      await _open(tester);
      final spec = _spec(tester);
      final box = _box(spec);
      final dialog = heroUiCase('modal-md-auto-dialog', mode: mode);

      // bg-overlay, p-6, shadow-overlay, min(32px, var(--radius-3xl)).
      expectCssColor(box.color!, dialog.styles['backgroundColor']!);
      expect(
        spec.container.spec.padding,
        EdgeInsets.all(dialog.px('paddingTop')),
      );
      expect(
        box.borderRadius,
        BorderRadius.circular(dialog.px('borderRadius')),
      );
      expect(
        behindShadows(spec.containerEffects),
        cssRemixShadows(dialog.styles['boxShadow']!),
      );
    });

    testWidgets('the heading and body take their text styles in $mode', (
      tester,
    ) async {
      await tester.pumpHeroUi(_opener(), mode: mode);
      await _open(tester);
      final spec = _spec(tester);
      final heading = heroUiCase('modal-md-auto-heading', mode: mode);
      final bodyCase = heroUiCase('modal-md-auto-body', mode: mode);

      // modal__heading: text-base font-medium text-foreground.
      final title = spec.title.spec.style!;
      expect(title.fontSize, heading.px('fontSize'));
      expect(
        title.fontSize! * title.height!,
        closeTo(heading.px('lineHeight'), .01),
      );
      expect(title.fontWeight, FontWeight.w500);
      expectCssColor(title.color!, heading.styles['color']!);

      // modal__body: text-sm text-muted; the 14px size has a 1.43 leading.
      final body = spec.description.spec.style!;
      expect(body.fontSize, bodyCase.px('fontSize'));
      expect(
        body.fontSize! * body.height!,
        closeTo(bodyCase.px('lineHeight'), .05),
      );
      expectCssColor(body.color!, bodyCase.styles['color']!);
    });

    testWidgets('the HeroUI backdrop is the dialog route barrier in $mode', (
      tester,
    ) async {
      await tester.pumpHeroUi(_opener(), mode: mode);
      await _open(tester);
      final backdrop = heroUiToken(HeroUiTokens.backdrop, mode);
      final barrier = tester.widget<ModalBarrier>(
        find.byWidgetPredicate(
          (widget) => widget is ModalBarrier && widget.color == backdrop,
        ),
      );
      // --backdrop: rgba(0, 0, 0, 0.5) in light, 0.6 in dark.
      expectCssColor(
        barrier.color!,
        heroUiCase(
          'modal-md-auto-backdrop',
          mode: mode,
        ).styles['backgroundColor']!,
      );
    });

    testWidgets('an alert dialog takes the same surface in $mode', (
      tester,
    ) async {
      await tester.pumpHeroUi(_opener(alert: true), mode: mode);
      await _open(tester);
      expectCssColor(
        _box(_spec(tester)).color!,
        heroUiCase(
          'modal-md-auto-dialog',
          mode: mode,
        ).styles['backgroundColor']!,
      );
    });

    testWidgets('every size and placement builds in $mode', (tester) async {
      for (final size in HeroUiModalSize.values) {
        for (final placement in HeroUiModalPlacement.values) {
          await tester.pumpHeroUi(
            _opener(size: size, placement: placement),
            mode: mode,
          );
          await _open(tester);
          expect(
            find.text('Delete project'),
            findsOneWidget,
            reason: '${size.name} ${placement.name}',
          );
          await _close(tester);
        }
      }
    });
  }

  for (final width in [1024, 375]) {
    group('at $width px', () {
      testWidgets('the dialog is inset like modal-md-auto-dialog', (
        tester,
      ) async {
        await tester.pumpHeroUi(
          _opener(description: _longDescription),
          width: width.toDouble(),
        );
        await _open(tester);
        final dialog = heroUiCase('modal-md-auto-dialog', width: width).rect;
        final heading = heroUiCase('modal-md-auto-heading', width: width).rect;
        final title = tester.getRect(find.text('Delete project'));
        final surface = tester.getRect(_surface);

        // p-6 around the heading.
        expect(title.left - surface.left, heading.left - dialog.left);
        expect(title.top - surface.top, heading.top - dialog.top);
        expect(surface.width, dialog.width);
        expect(surface.left, dialog.left);
      });

      testWidgets('the body and footer are spaced as in modal.css', (
        tester,
      ) async {
        await tester.pumpHeroUi(_opener(), width: width.toDouble());
        await _open(tester);
        final heading = heroUiCase('modal-md-auto-heading', width: width).rect;
        final body = heroUiCase('modal-md-auto-body', width: width).rect;
        final footer = heroUiCase('modal-md-auto-footer', width: width).rect;
        final bodyCase = heroUiCase('modal-md-auto-body', width: width);
        final text = tester.getRect(find.text(_description));
        final title = tester.getRect(find.text('Delete project'));
        final actions = tester.getRect(find.byType(HeroUiButton).first);

        // The body has `mt-2` and 3px of padding around its text, so the text
        // sits 8 + 3 below the heading and 20 + 3 above the footer.
        expect(
          text.top - title.bottom,
          body.top + bodyCase.px('paddingTop') - heading.bottom,
        );
        expect(
          actions.top - text.bottom,
          footer.top - (body.bottom - bodyCase.px('paddingBottom')),
        );
      });

      testWidgets(
        'the footer ends the row with gap-2 and button-high actions',
        (tester) async {
          await tester.pumpHeroUi(_opener(), width: width.toDouble());
          await _open(tester);
          final footer = heroUiCase('modal-md-auto-footer', width: width);
          final surface = tester.getRect(_surface);
          final cancel = tester.getRect(find.byType(HeroUiButton).first);
          final delete = tester.getRect(find.byType(HeroUiButton).last);

          expect(delete.left - cancel.right, footer.px('gap'));
          // p-6, with the footer at the end.
          expect(surface.right - delete.right, 24);
          // Button md is h-10, md:h-9.
          expect(delete.height, footer.size.height);
        },
      );

      testWidgets('a one-line dialog is as tall as upstream', (tester) async {
        await tester.pumpHeroUi(_opener(), width: width.toDouble());
        await _open(tester);
        expect(
          tester.getSize(_surface).height,
          closeTo(
            heroUiCase('modal-md-auto-dialog', width: width).size.height,
            .05,
          ),
        );
      });

      testWidgets('the dialog is as wide as its size even with a short body', (
        tester,
      ) async {
        await tester.pumpHeroUi(_opener(), width: width.toDouble());
        await _open(tester);
        expect(
          tester.getSize(_surface).width,
          heroUiCase('modal-md-auto-dialog', width: width).size.width,
        );
      });

      for (final size in [
        HeroUiModalSize.xs,
        HeroUiModalSize.sm,
        HeroUiModalSize.md,
        HeroUiModalSize.lg,
      ]) {
        testWidgets('${size.name} caps the width like modal-${size.name}', (
          tester,
        ) async {
          await tester.pumpHeroUi(
            _opener(size: size, description: _longDescription),
            width: width.toDouble(),
          );
          await _open(tester);
          final dialog = heroUiCase(
            'modal-${size.name}-auto-dialog',
            width: width,
          ).rect;
          final surface = tester.getRect(_surface);
          expect(surface.width, dialog.width);
          expect(surface.left, dialog.left);
        });
      }

      testWidgets('cover fills the container, full the viewport', (
        tester,
      ) async {
        await tester.pumpHeroUi(_opener(size: .cover), width: width.toDouble());
        await _open(tester);
        final cover = heroUiCase('modal-cover-auto-dialog', width: width);
        expect(tester.getRect(_surface), cover.rect);
        expect(
          _box(_spec(tester)).borderRadius,
          BorderRadius.circular(cover.px('borderRadius')),
        );

        await _close(tester);
        await tester.pumpHeroUi(_opener(size: .full), width: width.toDouble());
        await _open(tester);
        expect(
          tester.getRect(_surface),
          heroUiCase('modal-full-auto-dialog', width: width).rect,
        );
        final spec = _spec(tester);
        final full = heroUiCase('modal-full-auto-dialog', width: width);
        expect(full.styles, isNot(contains('borderRadius')));
        expect(_box(spec).borderRadius, isNull);
        expect(
          behindShadows(spec.containerEffects),
          cssRemixShadows(full.styles['boxShadow'] ?? ''),
        );
      });

      for (final placement in HeroUiModalPlacement.values) {
        testWidgets('${placement.name} places the dialog like upstream', (
          tester,
        ) async {
          await tester.pumpHeroUi(
            _opener(placement: placement),
            width: width.toDouble(),
          );
          await _open(tester);
          final dialog = heroUiCase(
            'modal-md-${placement.name}-dialog',
            width: width,
          ).rect;
          final surface = tester.getRect(_surface);

          expect(surface.left, dialog.left);
          // The dialog's height differs from upstream's, so compare the edge
          // the placement anchors to.
          switch (placement) {
            case .top:
              expect(surface.top, dialog.top);
            case .bottom:
              expect(surface.bottom, closeTo(dialog.bottom, .05));
            case .center:
              expect(surface.center.dy, closeTo(dialog.center.dy, .05));
            case .auto:
              // Bottom below sm, centered from it.
              if (width < HeroUiTokens.breakpointSm) {
                expect(surface.bottom, closeTo(dialog.bottom, .05));
              } else {
                expect(surface.center.dy, closeTo(dialog.center.dy, .05));
              }
          }
        });
      }
    });
  }

  testWidgets('an outside tap closes the modal', (tester) async {
    await tester.pumpHeroUi(_opener());
    await _open(tester);
    await _close(tester);
    expect(find.text('Delete project'), findsNothing);
  });

  testWidgets('a caller style wins over the recipe', (tester) async {
    const override = Color(0xFF00FF00);
    await tester.pumpHeroUi(_opener(style: DialogStyler().color(override)));
    await _open(tester);
    expect(_box(_spec(tester)).color, override);
  });
}
