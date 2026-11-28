import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/fortal.dart';

import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../helpers/contrast.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('FortalToast', () {
    test('named constructors pin variants', () {
      const surface = FortalToast.surface(title: 'Saved');
      const classic = FortalToast.classic(title: 'Saved');

      expect(surface.variant, FortalToastVariant.surface);
      expect(classic.variant, FortalToastVariant.classic);
      expect(const FortalToast(title: 'Saved').size, FortalToastSize.size2);
      expect(
        const FortalToast(title: 'Saved').intent,
        FortalToastIntent.accent,
      );
    });

    for (final brightness in Brightness.values) {
      for (final variant in FortalToastVariant.values) {
        for (final size in FortalToastSize.values) {
          for (final intent in FortalToastIntent.values) {
            testWidgets(
              'resolves $variant $size $intent in ${brightness.name}',
              (tester) async {
                await tester.pumpRemixApp(
                  FortalTheme(
                    mode: brightness == Brightness.dark ? .dark : .light,
                    child: FortalToast(
                      variant: variant,
                      size: size,
                      intent: intent,
                      title: 'Draft saved',
                      description: 'Stored on this device.',
                      icon: Icons.check,
                      action: RemixToastAction(label: 'Undo', onPressed: () {}),
                      onDismiss: () {},
                      dismissLabel: 'Dismiss notification',
                    ),
                  ),
                );

                expect(tester.takeException(), isNull);
                expect(find.text('Draft saved'), findsOneWidget);
                expect(
                  tester.getSize(find.byType(RemixToast)).width,
                  lessThanOrEqualTo(416),
                );
              },
            );
          }
        }
      }
    }

    testWidgets('shrinks below its cap on narrow screens', (tester) async {
      await tester.pumpRemixApp(
        const SizedBox(
          width: 240,
          child: FortalToast(
            title: 'A long message that has to wrap on a narrow screen.',
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(RemixToast)).width, 240);
    });

    testWidgets('stays within its cap at a large text scale', (tester) async {
      await tester.pumpRemixApp(
        const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(2)),
          child: FortalToast(
            title: 'A long message that has to wrap at a large text scale.',
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byType(RemixToast)).width,
        lessThanOrEqualTo(416),
      );
    });

    testWidgets('the default is a 416px floating card with a check chip', (
      tester,
    ) async {
      late ToastSpec spec;
      late Color surface, gray7, success;
      await tester.pumpRemixApp(
        Builder(
          builder: (context) {
            spec = fortalToastStyle().build(context).spec;
            surface = FortalTokens.colorSurface.resolve(context);
            gray7 = FortalTokens.gray7.resolve(context);
            success = FortalTokens.success.resolve(context);
            return const FortalToast(
              title: 'Saved',
              onDismiss: _noop,
              dismissLabel: 'Dismiss notification',
            );
          },
        ),
      );

      final box = spec.container.spec.box!.spec;
      final decoration = box.decoration! as BoxDecoration;
      expect(box.padding, const EdgeInsetsDirectional.fromSTEB(16, 14, 14, 14));
      expect(decoration.borderRadius, BorderRadius.circular(20));
      expect((decoration.border! as Border).top.color, gray7);
      expect(decoration.boxShadow, hasLength(2));
      expect(
        spec.container.spec.flex!.spec.crossAxisAlignment,
        CrossAxisAlignment.start,
      );
      expect(spec.content.spec.flex!.spec.spacing, 2);
      expect(spec.title.spec.style!.fontSize, 13);
      expect(spec.title.spec.style!.fontWeight, FontWeight.w500);
      expect(spec.title.spec.maxLines, 1);
      expect(spec.description.spec.style!.fontSize, 13);
      expect(spec.icon.spec.icon, RemixIcons.check);
      expect(spec.icon.spec.color, success);

      final chip = spec.iconContainer!.spec;
      final chipDecoration = chip.decoration! as BoxDecoration;
      expect(chip.constraints, BoxConstraints.tight(const Size.square(30)));
      expect(chipDecoration.color, isNot(surface));
      expect(
        chipDecoration.color!.g,
        greaterThan(chipDecoration.color!.r),
        reason: 'the chip is tinted toward the success color',
      );

      expect(tester.getSize(find.byType(RemixToast)).width, 416);
      expect(find.byIcon(RemixIcons.check), findsOneWidget);
    });

    for (final mode in [FortalThemeMode.light, FortalThemeMode.dark]) {
      testWidgets('theme high contrast lifts the frame to 3:1 and keeps text '
          'at 4.5:1 (${mode.name})', (tester) async {
        late ToastSpec rest, lifted;
        for (final highContrast in [false, true]) {
          await tester.pumpRemixApp(
            Builder(
              builder: (context) {
                final spec = fortalToastStyle().build(context).spec;
                highContrast ? lifted = spec : rest = spec;
                return const SizedBox.shrink();
              },
            ),
            mode: mode,
            highContrast: highContrast,
          );
        }
        BoxDecoration card(ToastSpec spec) =>
            spec.container.spec.box!.spec.decoration! as BoxDecoration;
        Color frame(ToastSpec spec) => (card(spec).border! as Border).top.color;

        expect(contrastRatio(frame(rest), card(rest).color!), lessThan(3));
        expect(
          contrastRatio(frame(lifted), card(lifted).color!),
          greaterThanOrEqualTo(3),
        );
        expect(
          contrastRatio(
            lifted.description.spec.style!.color!,
            card(lifted).color!,
          ),
          greaterThanOrEqualTo(4.5),
        );
      });
    }

    group('in a scope', () {
      Future<RemixToastHandle> show(
        WidgetTester tester, {
        bool reduceMotion = false,
      }) async {
        final controller = RemixToastController();
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          MediaQuery(
            data: MediaQueryData(disableAnimations: reduceMotion),
            child: FortalTheme(
              child: WidgetsApp(
                color: const Color(0xFFFFFFFF),
                builder: (context, _) => Overlay.wrap(
                  child: RemixToastScope(
                    controller: controller,
                    placement: .bottomCenter,
                    style: fortalToastStyle(),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ),
          ),
        );
        final handle = controller.showToast(
          const RemixToastData(title: 'Draft saved'),
        );
        await tester.pump();
        return handle;
      }

      double opacity(WidgetTester tester) => tester
          .widget<Opacity>(
            find
                .ancestor(
                  of: find.byType(RemixToast),
                  matching: find.byType(Opacity),
                )
                .first,
          )
          .opacity;

      double top(WidgetTester tester) =>
          tester.getTopLeft(find.byType(RemixToast)).dy;

      testWidgets('is announced from its first, transparent frame', (
        tester,
      ) async {
        final semantics = tester.ensureSemantics();
        await show(tester);

        expect(opacity(tester), 0);
        expect(find.bySemanticsLabel(RegExp('Draft saved')), findsWidgets);
        // The close button lives inside the fade; an opacity-0 subtree
        // without kept semantics would drop it.
        expect(find.bySemanticsLabel('Dismiss notification'), findsOneWidget);
        semantics.dispose();
      });

      testWidgets('rises 16px on the morph spring and fades in over 200ms', (
        tester,
      ) async {
        await show(tester);
        final spring = FortalSpringCurve(FortalMotion.springMorph);
        final start = top(tester);

        await tester.pump(const Duration(milliseconds: 100));
        final t = 100 / spring.duration.inMilliseconds;
        expect(
          opacity(tester),
          closeTo(FortalMotion.easeEnter.transform(.5), .02),
        );
        final mid = top(tester);

        await tester.pumpAndSettle();
        final rest = top(tester);
        expect(opacity(tester), 1);
        // The scale grows around the center, so the top edge moves by the
        // rise plus half the height the scale adds.
        expect(start - rest, greaterThan(16));
        expect(
          mid - rest,
          lessThan((start - rest) * (1 - spring.transform(t)) + 1),
        );
      });

      testWidgets('leaves in 140ms, sinking 8px', (tester) async {
        final toast = await show(tester);
        await tester.pumpAndSettle();
        final rest = top(tester);

        toast.dismiss();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 70));
        final p = FortalMotion.easeStandard.transform(.5);
        expect(opacity(tester), closeTo(1 - p, .03));
        expect(top(tester), greaterThan(rest + 8 * p - 1));

        await tester.pump(const Duration(milliseconds: 80));
        expect(find.byType(RemixToast), findsNothing);
      });

      testWidgets('only fades, over 100ms, under reduced motion', (
        tester,
      ) async {
        final toast = await show(tester, reduceMotion: true);
        final start = top(tester);
        await tester.pump(const Duration(milliseconds: 50));
        expect(opacity(tester), closeTo(.5, .02));
        expect(top(tester), start);

        await tester.pumpAndSettle();
        expect(top(tester), start);

        toast.dismiss();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));
        expect(opacity(tester), closeTo(.5, .02));
        expect(top(tester), start);
      });
    });

    test('the intent never changes semantics priority', () {
      const toast = RemixToastData(title: 'Failed');

      expect(toast.priority, RemixToastPriority.polite);
      expect(fortalToastStyle(intent: .error), isA<ToastStyler>());
    });
  });
}

void _noop() {}
