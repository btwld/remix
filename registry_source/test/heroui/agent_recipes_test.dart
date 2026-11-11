import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/agent.dart';
import 'package:registry_source/src/heroui/components/card.dart';
import 'package:registry_source/src/heroui/recipes/activity_recipe.dart';
import 'package:registry_source/src/heroui/recipes/answer_recipe.dart';
import 'package:registry_source/src/heroui/recipes/composer_recipe.dart';
import 'package:registry_source/src/heroui/recipes/execution_recipe.dart';
import 'package:registry_source/src/heroui/recipes/message_recipe.dart';
import 'package:registry_source/src/heroui/recipes/permission_recipe.dart';
import 'package:registry_source/src/heroui/recipes/plan_recipe.dart';
import 'package:registry_source/src/heroui/recipes/transcript_recipe.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

void main() {
  for (final mode in ['light', 'dark']) {
    group(mode, () {
      testWidgets('surfaces are HeroUI cards', (tester) async {
        final card = await _resolve(tester, heroUiCardStyle(), mode: mode);
        for (final style in [
          heroUiAgentAnswerRecipe().surfaceStyle,
          heroUiAgentExecutionRecipe().surfaceStyle,
          heroUiAgentPermissionRecipe().surfaceStyle,
        ]) {
          final spec = await _resolve(tester, style, mode: mode);
          expect(_fill(spec), _fill(card));
          expect(_fill(spec), heroUiToken(HeroUiTokens.surface, mode));
          expect(spec.container.spec.padding, const EdgeInsets.all(16));
        }
        final message = await _resolve(
          tester,
          heroUiAgentMessageRecipe().surfaceStyle,
          mode: mode,
        );
        expect(_fill(message), heroUiToken(HeroUiTokens.surface, mode));
        expect(
          message.container.spec.padding,
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        );
        final composer = await _resolve(
          tester,
          heroUiAgentComposerRecipe().surfaceStyle,
          mode: mode,
        );
        expect(composer.container.spec.padding, const EdgeInsets.all(12));
      });

      testWidgets('actions are HeroUI buttons in HeroUI variants', (
        tester,
      ) async {
        Future<ButtonSpec> button(ButtonStyler style) =>
            _resolve(tester, style, mode: mode);
        final permission = heroUiAgentPermissionRecipe();
        expect(
          _buttonFill(await button(permission.allowOnceStyle)),
          heroUiToken(HeroUiTokens.accent, mode),
        );
        final outline = await button(permission.alwaysAllowStyle);
        expect(_buttonFill(outline), HeroUiTokens.transparent);
        expect(
          (outline.container.spec.box!.spec.decoration! as BoxDecoration)
              .border,
          isNotNull,
        );
        expect(
          _buttonFill(await button(permission.denyStyle)),
          HeroUiTokens.transparent,
        );
        expect(
          _buttonFill(await button(heroUiAgentMessageRecipe().toggleStyle)),
          HeroUiTokens.transparent,
        );

        final composer = heroUiAgentComposerRecipe();
        final submit = await _resolve(tester, composer.submitStyle, mode: mode);
        final stop = await _resolve(tester, composer.stopStyle, mode: mode);
        expect(_iconFill(submit), heroUiToken(HeroUiTokens.accent, mode));
        expect(_iconFill(stop), heroUiToken(HeroUiTokens.danger, mode));
        final copy = await _resolve(
          tester,
          heroUiAgentAnswerRecipe().copyStyle,
          mode: mode,
        );
        expect(_iconFill(copy), HeroUiTokens.transparent);
        expect(
          copy.icon.spec.color,
          heroUiToken(HeroUiTokens.defaultForeground, mode),
        );
      });

      testWidgets('text and marks use HeroUI tokens', (tester) async {
        final plan = await _resolve(
          tester,
          heroUiAgentPlanRecipe().style,
          mode: mode,
        );
        expect(
          plan.summaryTitle.spec.style!.color,
          heroUiToken(HeroUiTokens.foreground, mode),
        );
        expect(plan.summaryTitle.spec.style!.fontSize, 14);
        expect(
          plan.itemDetail.spec.style!.color,
          heroUiToken(HeroUiTokens.muted, mode),
        );
        expect(
          plan.activeStatus.spec.color,
          heroUiToken(HeroUiTokens.accent, mode),
        );
        final activity = await _resolve(
          tester,
          heroUiAgentActivityRecipe().style,
          mode: mode,
        );
        expect(
          activity.completedStatus.spec.color,
          heroUiToken(HeroUiTokens.accent, mode),
        );
        final execution = await _resolve(
          tester,
          heroUiAgentExecutionRecipe().style,
          mode: mode,
        );
        expect(
          (execution.output.spec.decoration! as BoxDecoration).color,
          heroUiToken(HeroUiTokens.surfaceSecondary, mode),
        );
        final parameters = await _resolve(
          tester,
          heroUiAgentPermissionRecipe().parametersStyle,
          mode: mode,
        );
        expect(
          parameters.label.spec.style!.color,
          heroUiToken(HeroUiTokens.muted, mode),
        );
        expect(
          parameters.value.spec.style!.color,
          heroUiToken(HeroUiTokens.foreground, mode),
        );
      });

      testWidgets('the composer field has no fill of its own', (tester) async {
        final field = await _resolve(
          tester,
          heroUiAgentComposerRecipe().fieldStyle,
          mode: mode,
        );
        expect(
          (field.container.spec.decoration as BoxDecoration?)?.color,
          HeroUiTokens.transparent,
        );
        expect(field.container.spec.constraints?.minHeight, 56);
      });

      testWidgets('the surfaces render with HeroUI recipes', (tester) async {
        final message = heroUiAgentMessageRecipe();
        final answer = heroUiAgentAnswerRecipe();
        final permission = heroUiAgentPermissionRecipe();
        final execution = heroUiAgentExecutionRecipe();
        final composer = heroUiAgentComposerRecipe();
        await tester.pumpHeroUi(
          SizedBox(
            width: 640,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 12,
                children: [
                  AgentMessage(
                    role: AgentRole.user,
                    surfaceStyle: message.surfaceStyle,
                    style: message.style,
                    child: const Text('Review the checkout flow.'),
                  ),
                  AgentAnswer(
                    status: AgentAnswerStatus.complete,
                    onCopy: () {},
                    onRetry: () {},
                    surfaceStyle: answer.surfaceStyle,
                    sourcesStyle: answer.sourcesStyle,
                    copyStyle: answer.copyStyle,
                    retryStyle: answer.retryStyle,
                    style: answer.style,
                    child: const Text('The flow is ready for review.'),
                  ),
                  AgentPermission(
                    tool: 'terminal',
                    title: 'Run checks',
                    defaultDetailsExpanded: true,
                    parameters: const [
                      RemixDataListItem(label: 'Command', value: 'test'),
                    ],
                    onAllowOnce: () {},
                    onAlwaysAllow: () {},
                    onDeny: () {},
                    surfaceStyle: permission.surfaceStyle,
                    detailsStyle: permission.detailsStyle,
                    parametersStyle: permission.parametersStyle,
                    allowOnceStyle: permission.allowOnceStyle,
                    alwaysAllowStyle: permission.alwaysAllowStyle,
                    denyStyle: permission.denyStyle,
                    style: permission.style,
                  ),
                  AgentExecution(
                    tool: 'terminal',
                    title: 'flutter test',
                    status: AgentExecutionStatus.success,
                    collapseOnComplete: false,
                    onCopy: () {},
                    surfaceStyle: execution.surfaceStyle,
                    disclosureStyle: execution.disclosureStyle,
                    copyStyle: execution.copyStyle,
                    retryStyle: execution.retryStyle,
                    style: execution.style,
                    child: const Text('All tests passed!'),
                  ),
                  AgentComposer(
                    onSubmit: (_) {},
                    surfaceStyle: composer.surfaceStyle,
                    fieldStyle: composer.fieldStyle,
                    submitStyle: composer.submitStyle,
                    stopStyle: composer.stopStyle,
                    style: composer.style,
                  ),
                ],
              ),
            ),
          ),
          mode: mode,
        );
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text('Allow once'), findsOneWidget);
        expect(find.text('test'), findsOneWidget);
        expect(find.byType(RemixDataList), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });
  }

  testWidgets('a copy override resolves its own hover', (tester) async {
    const idle = Color(0xFF123456);
    const hovered = Color(0xFFABCDEF);
    final recipe = heroUiAgentAnswerRecipe(
      copyStyle: IconButtonStyler()
          .color(idle)
          .onHovered(IconButtonStyler().color(hovered)),
    );
    await tester.pumpHeroUi(
      AgentAnswer(
        status: AgentAnswerStatus.complete,
        style: recipe.style,
        surfaceStyle: recipe.surfaceStyle,
        copyStyle: recipe.copyStyle,
        onCopy: () {},
        child: const Text('Local answer'),
      ),
    );
    final copy = find.byWidgetPredicate(
      (widget) =>
          widget is RemixIconButton && widget.semanticLabel == 'Copy answer',
    );
    Color? fill() => _iconFill(
      tester
          .widget<StyleSpecProvider<IconButtonSpec>>(
            find
                .descendant(
                  of: copy,
                  matching: find.byType(StyleSpecProvider<IconButtonSpec>),
                )
                .first,
          )
          .spec
          .spec,
    );

    expect(fill(), idle);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(copy));
    await tester.pumpAndSettle();
    expect(fill(), hovered);
  });

  testWidgets('every recipe merges the caller style last', (tester) async {
    expect(
      (await _resolve(
        tester,
        heroUiAgentComposerRecipe(
          style: AgentComposerStyler(toolbar: FlexBoxStyler().spacing(37)),
        ).style,
      )).toolbar.spec.flex?.spec.spacing,
      37,
    );
    expect(
      (await _resolve(
        tester,
        heroUiAgentMessageRecipe(style: AgentMessageStyler(maxWidth: 37)).style,
      )).maxWidth,
      37,
    );
    expect(
      (await _resolve(
        tester,
        heroUiAgentAnswerRecipe(
          style: AgentAnswerStyler(actions: FlexBoxStyler().spacing(37)),
        ).style,
      )).actions.spec.flex?.spec.spacing,
      37,
    );
    expect(
      (await _resolve(
        tester,
        heroUiAgentExecutionRecipe(
          style: AgentExecutionStyler(header: FlexBoxStyler().spacing(37)),
        ).style,
      )).header.spec.flex?.spec.spacing,
      37,
    );
    expect(
      (await _resolve(
        tester,
        heroUiAgentPermissionRecipe(
          style: AgentPermissionStyler(actions: FlexBoxStyler().spacing(37)),
        ).style,
      )).actions.spec.flex?.spec.spacing,
      37,
    );
    expect(
      (await _resolve(
        tester,
        heroUiAgentPlanRecipe(
          style: AgentPlanStyler(viewport: BoxStyler().maxHeight(37)),
        ).style,
      )).viewport.spec.constraints?.maxHeight,
      37,
    );
    expect(
      (await _resolve(
        tester,
        heroUiAgentActivityRecipe(
          style: AgentActivityStyler(viewport: BoxStyler().maxHeight(37)),
        ).style,
      )).viewport.spec.constraints?.maxHeight,
      37,
    );
    expect(
      (await _resolve(
        tester,
        heroUiAgentTranscriptRecipe(
          style: AgentTranscriptStyler(spacing: 37),
        ).style,
      )).spacing,
      37,
    );
    expect(
      (await _resolve(
        tester,
        heroUiAgentPermissionRecipe(
          parametersStyle: DataListStyler().rowSpacing(37),
        ).parametersStyle,
      )).rowSpacing,
      37,
    );
  });
}

Future<S> _resolve<S extends Spec<S>>(
  WidgetTester tester,
  Style<S> style, {
  String mode = 'light',
}) async {
  late S result;
  await tester.pumpHeroUi(
    Builder(
      builder: (context) {
        result = style.build(context).spec;
        return const SizedBox.shrink();
      },
    ),
    mode: mode,
  );
  return result;
}

Color? _fill(CardSpec spec) =>
    (spec.container.spec.decoration as BoxDecoration?)?.color;

Color? _buttonFill(ButtonSpec spec) =>
    (spec.container.spec.box?.spec.decoration as BoxDecoration?)?.color;

Color? _iconFill(IconButtonSpec spec) =>
    (spec.container.spec.decoration as BoxDecoration?)?.color;
