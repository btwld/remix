import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/agent.dart';

import '../helpers/pump.dart';

void main() {
  testWidgets('submits trimmed text without clearing when opted out', (
    tester,
  ) async {
    final controller = TextEditingController(text: '  keep me  ');
    addTearDown(controller.dispose);
    final submitted = <String>[];
    await pumpAgent(
      tester,
      AgentComposer(
        controller: controller,
        clearOnSubmit: false,
        onSubmit: submitted.add,
      ),
      overlay: true,
    );

    await tester.tap(find.byKey(const ValueKey('agent-composer-send')));
    await tester.pump();

    expect(submitted, ['keep me']);
    expect(controller.text, '  keep me  ');
  });

  testWidgets('programmatic edits report changes and enable submit', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    final changes = <String>[];
    await pumpAgent(
      tester,
      AgentComposer(
        controller: controller,
        onChanged: changes.add,
        onSubmit: (_) {},
      ),
      overlay: true,
    );

    controller.text = 'programmatic';
    await tester.pump();

    expect(changes, ['programmatic']);
    expect(
      tester
          .widget<RemixIconButton>(
            find.byKey(const ValueKey('agent-composer-send')),
          )
          .enabled,
      isTrue,
    );
  });

  testWidgets('canSubmit false disables a non-empty composer', (tester) async {
    final submitted = <String>[];
    await pumpAgent(
      tester,
      AgentComposer(
        initialValue: 'blocked',
        canSubmit: false,
        onSubmit: submitted.add,
      ),
      overlay: true,
    );

    final button = tester.widget<RemixIconButton>(
      find.byKey(const ValueKey('agent-composer-send')),
    );
    expect(button.enabled, isFalse);
    await tester.tap(find.byKey(const ValueKey('agent-composer-send')));
    expect(submitted, isEmpty);
  });

  testWidgets('owned controller clears after submit', (tester) async {
    final submitted = <String>[];
    await pumpAgent(
      tester,
      AgentComposer(initialValue: 'owned', onSubmit: submitted.add),
      overlay: true,
    );

    await tester.tap(find.byKey(const ValueKey('agent-composer-send')));
    await tester.pump();

    expect(submitted, ['owned']);
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).controller.text,
      isEmpty,
    );
  });

  testWidgets('running mode invokes stop and never submit', (tester) async {
    var stops = 0;
    final submitted = <String>[];
    await pumpAgent(
      tester,
      AgentComposer(
        running: true,
        initialValue: 'do not send',
        onSubmit: submitted.add,
        onStop: () => stops++,
      ),
      overlay: true,
    );

    await tester.tap(find.byKey(const ValueKey('agent-composer-stop')));
    expect(stops, 1);
    expect(submitted, isEmpty);
  });

  // Both swaps used to dispose the superseded owned object inside
  // didUpdateWidget, while the child RemixTextArea still held it. Detaching
  // then touched a disposed object, which asserts in debug.
  testWidgets('adopting a host controller keeps the composer usable', (
    tester,
  ) async {
    final adopted = TextEditingController(text: 'from host');
    addTearDown(adopted.dispose);

    await pumpAgent(
      tester,
      const AgentComposer(initialValue: 'owned'),
      overlay: true,
    );
    await pumpAgent(tester, AgentComposer(controller: adopted), overlay: true);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('from host'), findsOneWidget);
  });

  testWidgets('adopting a host focus node keeps the composer usable', (
    tester,
  ) async {
    final adopted = FocusNode();
    addTearDown(adopted.dispose);

    await pumpAgent(
      tester,
      const AgentComposer(initialValue: 'text'),
      overlay: true,
    );
    // The owned node is created lazily by the getter, so it only exists to be
    // disposed once the field has been built.
    await tester.pump();

    await pumpAgent(
      tester,
      AgentComposer(initialValue: 'text', focusNode: adopted),
      overlay: true,
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    adopted.requestFocus();
    await tester.pump();
    expect(adopted.hasFocus, isTrue);
  });

  testWidgets(
    'typing rebuilds the composer only when sending becomes possible',
    (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      final changes = <String>[];
      await pumpAgent(
        tester,
        SizedBox(
          width: 400,
          child: AgentComposer(
            controller: controller,
            onChanged: changes.add,
            onSubmit: (_) {},
          ),
        ),
        overlay: true,
      );

      var composerBuilds = 0;
      final previous = debugOnRebuildDirtyWidget;
      debugOnRebuildDirtyWidget = (element, builtOnce) {
        if (element.widget is AgentComposer) composerBuilds++;
      };
      addTearDown(() => debugOnRebuildDirtyWidget = previous);

      const draft = 'Ship the notes';
      for (var length = 1; length <= draft.length; length++) {
        controller.text = draft.substring(0, length);
        await tester.pump();
      }
      expect(changes, hasLength(draft.length));
      expect(
        composerBuilds,
        1,
        reason: 'Only the first character changes whether Send is enabled.',
      );

      controller.clear();
      await tester.pump();
      expect(composerBuilds, 2);
    },
  );

  testWidgets('field focus reaches the surface style, and only the surface', (
    tester,
  ) async {
    const ring = Color(0xFF0055FF);
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    final leadingSaw = <bool>[];
    await pumpAgent(
      tester,
      SizedBox(
        width: 400,
        child: AgentComposer(
          initialValue: 'go',
          focusNode: focusNode,
          onSubmit: (_) {},
          surfaceStyle: CardStyler().onFocused(CardStyler().color(ring)),
          leading: Builder(
            builder: (context) {
              leadingSaw.add(
                WidgetStateProvider.hasStateOf(context, WidgetState.focused),
              );
              return const SizedBox(width: 8, height: 8);
            },
          ),
        ),
      ),
      overlay: true,
    );
    Iterable<Color?> cardFills() => [
      for (final widget in tester.widgetList(
        find.descendant(
          of: find.byType(RemixCard),
          matching: find.byWidgetPredicate(
            (widget) => widget is DecoratedBox || widget is ColoredBox,
          ),
        ),
      ))
        switch (widget) {
          ColoredBox(:final color) => color,
          DecoratedBox(:final BoxDecoration decoration) => decoration.color,
          _ => null,
        },
    ];
    expect(cardFills(), isNot(contains(ring)));

    focusNode.requestFocus();
    await tester.pump();
    await tester.pump();
    expect(cardFills(), contains(ring));
    expect(leadingSaw, everyElement(isFalse));

    focusNode.unfocus();
    await tester.pump();
    await tester.pump();
    expect(cardFills(), isNot(contains(ring)));
  });
}
