import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/agent.dart';

import '../helpers/pump.dart';

const _starters = [
  AgentSuggestion(
    label: 'Review checkout',
    icon: SizedBox(key: ValueKey('search'), width: 16),
  ),
  AgentSuggestion(
    label: 'Run terminal checks',
    prompt: 'Run the checkout tests and tell me if the cart flow is ready.',
  ),
];

void main() {
  testWidgets('a tapped suggestion fills and focuses the composer', (
    tester,
  ) async {
    final controller = AgentComposerController();
    final focusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);
    final sent = <String>[];
    final selected = <AgentSuggestion>[];
    await pumpAgent(
      tester,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 600,
            child: AgentComposer(
              controller: controller,
              focusNode: focusNode,
              onSubmit: sent.add,
            ),
          ),
          AgentSuggestions(
            suggestions: _starters,
            controller: controller,
            focusNode: focusNode,
            onSelected: selected.add,
          ),
        ],
      ),
      overlay: true,
    );

    await tester.tap(find.text('Run terminal checks'));
    await tester.pump();

    expect(controller.text, _starters.last.prompt);
    expect(
      controller.selection,
      TextSelection.collapsed(offset: _starters.last.prompt.length),
    );
    expect(focusNode.hasFocus, isTrue);
    expect(selected, [_starters.last]);
    // It never sends: the reader reviews the prompt first.
    expect(sent, isEmpty);
  });

  testWidgets('a suggestion without a prompt fills its label', (tester) async {
    final controller = AgentComposerController(text: 'draft');
    addTearDown(controller.dispose);
    await pumpAgent(
      tester,
      AgentSuggestions(suggestions: _starters, controller: controller),
    );

    expect(find.byKey(const ValueKey('search')), findsOneWidget);
    await tester.tap(find.text('Review checkout'));
    expect(controller.text, 'Review checkout');
  });

  testWidgets('the suggestions are one labelled group of buttons', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    final controller = AgentComposerController();
    addTearDown(controller.dispose);
    await pumpAgent(
      tester,
      AgentSuggestions(suggestions: _starters, controller: controller),
    );

    expect(find.bySemanticsLabel('Suggestions'), findsOneWidget);
    expect(
      tester.getSemantics(find.text('Review checkout')),
      isSemantics(isButton: true),
    );
    semantics.dispose();
  });
}
