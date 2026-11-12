import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../helpers/mock.dart';
import '../helpers/pump.dart';

const _toggle = ValueKey('agent-message-toggle');

final _bubble = AgentMessageStyler().onUser(
  AgentMessageStyler(maxWidthFactor: 0.75, collapsedHeight: 60),
);

Future<void> _pump(WidgetTester tester, Widget message) =>
    pumpAgent(tester, SizedBox(width: 600, child: message));

void main() {
  testWidgets('a user message sits at the end, at most the line share', (
    tester,
  ) async {
    await _pump(
      tester,
      AgentMessage(
        role: AgentRole.user,
        style: _bubble,
        child: const Text(prompt),
      ),
    );

    final text = tester.getRect(find.text(prompt));
    expect(text.right, 600);
    expect(text.width, lessThanOrEqualTo(450));
  });

  testWidgets('a short user message does not collapse', (tester) async {
    await _pump(
      tester,
      AgentMessage(
        role: AgentRole.user,
        style: _bubble,
        child: const Text('Hi'),
      ),
    );
    await tester.pump();

    expect(find.byKey(_toggle), findsNothing);
  });

  testWidgets('a long user message collapses at its height', (tester) async {
    final expansions = <bool>[];
    await _pump(
      tester,
      AgentMessage(
        role: AgentRole.user,
        style: _bubble,
        onExpandedChanged: expansions.add,
        child: const SizedBox(key: ValueKey('long'), height: 200),
      ),
    );
    await tester.pump();

    double height() => tester.getSize(find.byType(AgentMessage)).height;
    final toggle = tester.getSize(find.byKey(_toggle)).height;
    expect(height(), 60 + toggle);
    expect(find.text('Show more'), findsOneWidget);

    await tester.tap(find.byKey(_toggle));
    await tester.pump();
    expect(height(), 200 + toggle);
    expect(find.text('Show less'), findsOneWidget);
    expect(expansions, [true]);
  });

  testWidgets('collapsed text stays readable to assistive technology', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    final long = List.filled(40, 'word').join(' ');
    await _pump(
      tester,
      AgentMessage(
        role: AgentRole.user,
        style: AgentMessageStyler(collapsedHeight: 20),
        child: Text(long),
      ),
    );
    await tester.pump();

    expect(find.text('Show more'), findsOneWidget);
    expect(find.bySemanticsLabel(long), findsOneWidget);
    expect(find.bySemanticsLabel('User message'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('an assistant message spans the line and never collapses', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await _pump(
      tester,
      AgentMessage(
        role: AgentRole.assistant,
        style: AgentMessageStyler(collapsedHeight: 20),
        header: const Text('Agent'),
        footer: const Text('Footer'),
        child: const SizedBox(key: ValueKey('reply'), height: 200),
      ),
    );
    await tester.pump();

    final reply = tester.getRect(find.byKey(const ValueKey('reply')));
    expect(reply.width, 600);
    expect(reply.height, 200);
    expect(find.byKey(_toggle), findsNothing);
    expect(
      tester.getRect(find.text('Agent')).bottom,
      lessThanOrEqualTo(reply.top),
    );
    expect(
      tester.getRect(find.text('Footer')).top,
      greaterThanOrEqualTo(reply.bottom),
    );
    expect(find.bySemanticsLabel('Assistant message'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('each role resolves its own variant', (tester) async {
    const userColor = Color(0xFF111111);
    const assistantColor = Color(0xFF222222);
    final style = AgentMessageStyler()
        .onUser(AgentMessageStyler(text: TextStyler().color(userColor)))
        .onAssistant(
          AgentMessageStyler(text: TextStyler().color(assistantColor)),
        );
    await _pump(
      tester,
      Column(
        children: [
          AgentMessage(
            role: AgentRole.user,
            style: style,
            child: const Text('U'),
          ),
          AgentMessage(
            role: AgentRole.assistant,
            style: style,
            child: const Text('A'),
          ),
        ],
      ),
    );

    TextStyle styleOf(String text) =>
        DefaultTextStyle.of(tester.element(find.text(text))).style;
    expect(styleOf('U').color, userColor);
    expect(styleOf('A').color, assistantColor);
  });
}
