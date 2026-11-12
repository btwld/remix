import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:registry_source/heroui.dart';
import 'package:registry_source/vanilla.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

void main() {
  final fortalCall = fortalAgentToolCallRecipe();
  final vanillaCall = vanillaAgentToolCallRecipe();
  final heroUiCall = heroUiAgentToolCallRecipe();
  final fortalAnswer = fortalAgentAnswerRecipe();
  final vanillaAnswer = vanillaAgentAnswerRecipe();
  final heroUiAnswer = heroUiAgentAnswerRecipe();
  final presets = [
    (
      name: 'fortal',
      theme: (Widget child, bool dark) =>
          FortalTheme(mode: dark ? .dark : .light, child: child),
      call: fortalCall.style,
      action: fortalAnswer.actionStyle,
      selected: fortalAnswer.selectedActionStyle,
      toolIcon: fortalAgentToolIcon,
      hover: FortalTokens.grayA3,
      pressed: FortalTokens.grayA4,
      foreground: FortalTokens.gray12,
      muted: FortalTokens.gray11,
    ),
    (
      name: 'vanilla',
      theme: (Widget child, bool dark) =>
          VanillaTheme(mode: dark ? .dark : .light, child: child),
      call: vanillaCall.style,
      action: vanillaAnswer.actionStyle,
      selected: vanillaAnswer.selectedActionStyle,
      toolIcon: vanillaAgentToolIcon,
      hover: VanillaTokens.accent,
      pressed: VanillaTokens.accent,
      foreground: VanillaTokens.foreground,
      muted: VanillaTokens.mutedForeground,
    ),
    (
      name: 'heroui',
      theme: (Widget child, bool dark) =>
          HeroUiTheme(mode: dark ? .dark : .light, child: child),
      call: heroUiCall.style,
      action: heroUiAnswer.actionStyle,
      selected: heroUiAnswer.selectedActionStyle,
      toolIcon: heroUiAgentToolIcon,
      hover: HeroUiTokens.defaultColor,
      pressed: HeroUiTokens.defaultHover,
      foreground: HeroUiTokens.foreground,
      muted: HeroUiTokens.muted,
    ),
  ];

  for (final preset in presets) {
    for (final dark in [false, true]) {
      group('${preset.name} ${dark ? 'dark' : 'light'}', () {
        Future<void> pump(WidgetTester tester, Widget child) =>
            tester.pumpWidget(
              WidgetsApp(
                color: const Color(0xFFFFFFFF),
                builder: (_, _) => preset.theme(Center(child: child), dark),
              ),
            );

        Future<S> resolve<S extends Spec<S>>(
          WidgetTester tester,
          Style<S> style, {
          Set<WidgetState> states = const {},
        }) async {
          late S result;
          await pump(
            tester,
            WidgetStateProvider(
              states: states,
              child: Builder(
                builder: (context) {
                  _context = context;
                  result = style.build(context).spec;
                  return const SizedBox.shrink();
                },
              ),
            ),
          );
          return result;
        }

        testWidgets('row and output toggle expose the preset states', (
          tester,
        ) async {
          final idle = await resolve(tester, preset.call);
          expect(idle.row.spec.box?.spec.constraints?.minHeight, 32);
          expect(idle.outputToggle.spec.box?.spec.constraints?.minHeight, 32);
          expect(
            idle.outputToggleLabel.spec.style?.color,
            _color(preset.muted),
          );
          for (final entry in [
            ({WidgetState.hovered}, preset.hover),
            ({WidgetState.hovered, WidgetState.pressed}, preset.pressed),
            ({WidgetState.focused}, preset.hover),
            // A pointer press focuses the disclosure too; press must still win.
            (
              {WidgetState.focused, WidgetState.hovered, WidgetState.pressed},
              preset.pressed,
            ),
          ]) {
            final spec = await resolve(tester, preset.call, states: entry.$1);
            expect(_fill(spec.row), _color(entry.$2));
            if (entry.$1.contains(WidgetState.hovered)) {
              expect(_fill(spec.outputToggle), _color(entry.$2));
              expect(
                spec.outputToggleLabel.spec.style?.color,
                _color(preset.foreground),
              );
            }
            if (entry.$1.contains(WidgetState.focused)) {
              expect(
                spec.outputToggleLabel.spec.style?.decoration,
                TextDecoration.underline,
              );
            }
          }
        });

        testWidgets('overflow toggles between the compact and full output', (
          tester,
        ) async {
          await pump(
            tester,
            SizedBox(
              width: 500,
              child: AgentToolCall(
                call: _call('terminal.run'),
                defaultExpanded: true,
                style: preset.call.merge(
                  AgentToolCallStyler(outputMaxHeight: 40),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(find.text('Show all'), findsOneWidget);
          final toggle = find.byKey(
            const ValueKey('agent-tool-call-output-toggle'),
          );
          expect(tester.getSize(toggle).height, 32);
          final compact = tester
              .getSize(find.byType(SingleChildScrollView))
              .height;
          await tester.tap(toggle);
          await tester.pumpAndSettle();
          expect(find.text('Show less'), findsOneWidget);
          expect(
            tester.getSize(find.byType(SingleChildScrollView)).height,
            greaterThan(compact),
          );
          await tester.tap(toggle);
          await tester.pumpAndSettle();
          expect(
            tester.getSize(find.byType(SingleChildScrollView)).height,
            compact,
          );
        });

        testWidgets('named tool icons fall back for unknown tools', (
          tester,
        ) async {
          for (final name in ['terminal.run', 'unknown.tool']) {
            await pump(
              tester,
              AgentGlyphs(
                toolIconBuilder: preset.toolIcon,
                builder: (_, glyph, _) => glyph == AgentGlyph.tool
                    ? const SizedBox(key: ValueKey('fallback-tool'))
                    : null,
                child: SizedBox(
                  width: 500,
                  child: AgentToolCall(call: _call(name), style: preset.call),
                ),
              ),
            );
            expect(
              find.byIcon(RemixIcons.terminal),
              name == 'terminal.run' ? findsOneWidget : findsNothing,
            );
            expect(
              find.byKey(const ValueKey('fallback-tool')),
              name == 'terminal.run' ? findsNothing : findsOneWidget,
            );
          }
        });

        testWidgets('only the chosen feedback uses the selected style', (
          tester,
        ) async {
          final selected = await resolve(
            tester,
            preset.action.merge(preset.selected),
          );
          expect(_fill(selected.container), _color(preset.hover));
          expect(selected.icon.spec.color, _color(preset.foreground));
          final expectedSelected = _color(preset.foreground);
          final expectedIdle = _color(preset.muted);
          var feedback = AgentAnswerFeedback.positive;
          await pump(
            tester,
            StatefulBuilder(
              builder: (context, setState) => AgentAnswer(
                feedback: feedback,
                onFeedback: (value) => setState(() => feedback = value!),
                onCopy: () {},
                actionStyle: preset.action,
                selectedActionStyle: preset.selected,
                glyphBuilder: (_, glyph, spec) => Icon(
                  RemixIcons.circle,
                  key: ValueKey(glyph),
                  color: spec.color,
                ),
                child: const Text('Answer'),
              ),
            ),
          );
          Color? color(AgentGlyph glyph) =>
              tester.widget<Icon>(find.byKey(ValueKey(glyph))).color;
          expect(color(.positive), expectedSelected);
          expect(color(.negative), expectedIdle);
          expect(color(.copy), expectedIdle);
          await tester.tap(find.byKey(const ValueKey(AgentGlyph.negative)));
          await tester.pumpAndSettle();
          expect(color(.positive), expectedIdle);
          expect(color(.negative), expectedSelected);
        });
      });
    }
  }

  testWidgets('tool ids, output and input values use the Code font stack', (
    tester,
  ) async {
    late AgentToolCallSpec spec;
    late DataListSpec inputs;
    await tester.pumpWidget(
      WidgetsApp(
        color: const Color(0xFFFFFFFF),
        builder: (_, _) => FortalTheme(
          child: Builder(
            builder: (context) {
              final recipe = fortalAgentToolCallRecipe();
              spec = recipe.style.build(context).spec;
              inputs = recipe.inputStyle.build(context).spec;
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
    for (final text in [
      spec.toolId.spec,
      spec.outputText.spec,
      spec.errorText.spec,
      inputs.value.spec,
    ]) {
      expect(text.style?.fontFamily, 'Menlo');
      expect(text.style?.fontFamilyFallback, const [
        'Consolas',
        'Bitstream Vera Sans Mono',
        'monospace',
        'Apple Color Emoji',
        'Segoe UI Emoji',
      ]);
    }
  });
}

AgentToolCallPart _call(String name) => AgentToolCallPart(
  id: 'call',
  name: name,
  summary: 'Read the output',
  status: .succeeded,
  output: List.generate(12, (i) => 'line $i').join('\n'),
);

late BuildContext _context;
Color _color(ColorToken token) => token.resolve(_context);
Color? _fill(Object part) {
  final box = switch (part) {
    StyleSpec<BoxSpec>() => part.spec,
    StyleSpec<FlexBoxSpec>() => part.spec.box?.spec,
    _ => null,
  };
  return (box?.decoration as BoxDecoration?)?.color;
}
