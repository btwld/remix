import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:registry_source/heroui.dart';
import 'package:registry_source/vanilla.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import 'helpers/pixels.dart';

void main() {
  final vanilla = vanillaAgentComposerRecipe();
  final hero = heroUiAgentComposerRecipe();
  for (final preset in [
    (
      name: 'vanilla',
      theme: (Widget child, bool dark) =>
          VanillaTheme(mode: dark ? .dark : .light, child: child),
      style: vanilla.style,
      field: vanilla.fieldStyle,
    ),
    (
      name: 'heroui',
      theme: (Widget child, bool dark) =>
          HeroUiTheme(mode: dark ? .dark : .light, child: child),
      style: hero.style,
      field: hero.fieldStyle,
    ),
  ]) {
    for (final dark in [false, true]) {
      testWidgets(
        '${preset.name} composer field stays frameless on hover and focus, dark=$dark',
        (tester) async {
          final focus = FocusNode();
          addTearDown(focus.dispose);
          await tester.pumpWidget(
            _host(
              (child) => preset.theme(child, dark),
              SizedBox(
                width: 500,
                child: AgentComposer(
                  focusNode: focus,
                  onSubmit: (_) {},
                  style: preset.style,
                  fieldStyle: preset.field,
                ),
              ),
            ),
          );
          void expectBareField() {
            final spec = tester
                .widget<StyleSpecProvider<TextFieldSpec>>(
                  find.byType(StyleSpecProvider<TextFieldSpec>).first,
                )
                .spec
                .spec;
            final fill =
                (spec.container.spec.decoration as BoxDecoration?)?.color;
            expect(
              fill?.a ?? 0,
              0,
              reason: 'the shared surface supplies the fill',
            );
            final effects = spec.containerEffects;
            expect(effects?.behindContent?.isEmpty ?? true, isTrue);
            expect(effects?.overContent?.isEmpty ?? true, isTrue);
            expect(
              effects == null ||
                  effects.outline.style == BorderStyle.none ||
                  effects.outline.width == 0,
              isTrue,
              reason: 'the inner field must not draw a focus ring',
            );
          }

          expectBareField();
          final mouse = await tester.createGesture(
            kind: PointerDeviceKind.mouse,
          );
          addTearDown(mouse.removePointer);
          await mouse.addPointer(location: Offset.zero);
          await mouse.moveTo(tester.getCenter(find.byType(EditableText)));
          await tester.pumpAndSettle();
          expectBareField();
          await tester.tap(
            find.byType(EditableText),
            kind: PointerDeviceKind.mouse,
          );
          await tester.pumpAndSettle();
          expect(focus.hasFocus, isTrue);
          expectBareField();
          await mouse.moveTo(Offset.zero);
          await tester.pumpAndSettle();
          expectBareField();
        },
      );
    }
  }

  for (final dark in [false, true]) {
    testWidgets(
      'composer paints the 2px focus outline 2px outside its surface, dark=$dark',
      (tester) async {
        final boundary = GlobalKey();
        final focus = FocusNode();
        addTearDown(focus.dispose);
        final recipe = fortalAgentComposerRecipe();
        await tester.pumpWidget(
          _host(
            (child) => FortalTheme(mode: dark ? .dark : .light, child: child),
            RepaintBoundary(
              key: boundary,
              child: SizedBox(
                width: 500,
                height: 200,
                child: Center(
                  child: SizedBox(
                    width: 400,
                    child: AgentComposer(
                      focusNode: focus,
                      onSubmit: (_) {},
                      style: recipe.style,
                      fieldStyle: recipe.fieldStyle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        final surface = find.byType(AgentComposer);
        final before = tester.getRect(surface);
        final origin = tester.getTopLeft(find.byKey(boundary));
        final context = tester.element(surface);
        final ink = FortalTokens.focus8.resolve(context);
        // The theme paints outside this boundary; clear pixels stay transparent.
        const background = Color(0x00000000);
        Future<Color> sample(double x, double y) async {
          final pixels = await capturePixels(tester, boundary);
          return pixels.at(
            ((x - origin.dx) * pixelScale).round(),
            ((y - origin.dy) * pixelScale).round(),
          );
        }

        expectNearColor(
          await sample(before.center.dx, before.top - 3),
          background,
        );
        focus.requestFocus();
        await tester.pumpAndSettle();
        expect(tester.getRect(surface), before);
        // Two pixels of ink, then two clear pixels before the unchanged frame.
        for (final distance in [2.5, 3.5]) {
          expectNearColor(
            await sample(before.center.dx, before.top - distance),
            ink,
          );
        }
        for (final distance in [0.5, 1.5, 4.5]) {
          expectNearColor(
            await sample(before.center.dx, before.top - distance),
            background,
          );
        }
        // The outline follows the surface radius rather than making square corners.
        expectNearColor(
          await sample(before.left - 3, before.top - 3),
          background,
        );
        final radius = FortalTokens.radius6.resolve(context).x;
        expectNearColor(
          await sample(before.left + radius, before.top - 3),
          ink,
        );
      },
    );
  }

  testWidgets('running tool spinner uses its resolved glyph color', (
    tester,
  ) async {
    const ink = Color(0xFFBE123C);
    final recipe = vanillaAgentToolCallRecipe();
    for (final status in [
      AgentToolCallStatus.running,
      AgentToolCallStatus.inputStreaming,
    ]) {
      await tester.pumpWidget(
        _host(
          (child) => VanillaTheme(child: child),
          AgentGlyphs(
            builder: vanillaAgentGlyph,
            child: SizedBox(
              width: 500,
              child: AgentToolCall(
                call: AgentToolCallPart(
                  id: 'run',
                  name: 'terminal.run',
                  summary: 'Running',
                  status: status,
                ),
                style: recipe.style.merge(
                  AgentToolCallStyler(
                    statusIcon: IconStyler().size(13).color(ink),
                  ),
                ),
                disclosureStyle: recipe.disclosureStyle,
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(
        tester.widget<AgentToolCall>(find.byType(AgentToolCall)).call.status,
        status,
      );
      final spec = tester
          .widget<StyleSpecProvider<SpinnerSpec>>(
            find.byType(StyleSpecProvider<SpinnerSpec>),
          )
          .spec
          .spec;
      expect(spec.color, ink);
      expect(spec.size, 13);
    }
  });
}

Widget _host(Widget Function(Widget) theme, Widget child) => WidgetsApp(
  key: UniqueKey(),
  color: const Color(0xFFFFFFFF),
  pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
    settings: settings,
    pageBuilder: (context, _, _) => builder(context),
  ),
  builder: (_, navigator) => theme(navigator!),
  home: Center(child: child),
);
