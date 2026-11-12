import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/agent.dart';

import '../helpers/pump.dart';

void main() {
  testWidgets('decision actions exist only while permission is pending', (
    tester,
  ) async {
    Widget permission(AgentPermissionStatus status) => AgentPermission(
      tool: 'tool',
      status: status,
      onAllowOnce: () {},
      onAlwaysAllow: () {},
      onDeny: () {},
    );

    await pumpAgent(tester, permission(AgentPermissionStatus.pending));
    expect(find.text('Allow once'), findsOneWidget);
    expect(find.text('Always allow'), findsOneWidget);
    expect(find.text('Deny'), findsOneWidget);

    await pumpAgent(tester, permission(AgentPermissionStatus.running));
    expect(find.text('Allow once'), findsNothing);
    expect(find.text('Always allow'), findsNothing);
    expect(find.text('Deny'), findsNothing);
  });

  testWidgets('a decided request is a one-line receipt, without a card', (
    tester,
  ) async {
    Widget permission(AgentPermissionStatus status) => AgentPermission(
      tool: 'terminal.run',
      title: 'Allow this tool to run?',
      description: 'Run the checks.',
      status: status,
      onAllowOnce: () {},
      onDeny: () {},
    );

    await pumpAgent(tester, permission(AgentPermissionStatus.pending));
    expect(find.byType(RemixCard), findsOneWidget);
    expect(find.text('Allow this tool to run?'), findsOneWidget);

    for (final status in [
      AgentPermissionStatus.allowed,
      AgentPermissionStatus.complete,
      AgentPermissionStatus.denied,
    ]) {
      await pumpAgent(tester, permission(status));
      expect(find.byType(RemixCard), findsNothing, reason: '$status');
      expect(find.text('Allow this tool to run?'), findsNothing);
      expect(find.text('Run the checks.'), findsNothing);
      expect(find.text('terminal.run'), findsOneWidget);
    }
    expect(find.text('Denied'), findsOneWidget);
  });

  testWidgets('initial deciding status starts with details open', (
    tester,
  ) async {
    await pumpAgent(
      tester,
      const AgentPermission(
        tool: 'tool',
        status: AgentPermissionStatus.deciding,
        parameters: [RemixDataListItem(label: 'Command', value: 'test')],
      ),
    );

    expect(find.text('test'), findsOneWidget);
  });

  testWidgets('details use the requested parameter orientation', (
    tester,
  ) async {
    await pumpAgent(
      tester,
      const AgentPermission(
        tool: 'tool',
        defaultDetailsExpanded: true,
        parameterOrientation: Axis.vertical,
        parameters: [RemixDataListItem(label: 'Command', value: 'test')],
      ),
    );

    expect(
      tester.widget<RemixDataList>(find.byType(RemixDataList)).orientation,
      Axis.vertical,
    );
  });

  testWidgets('status and indicator builders replace functional defaults', (
    tester,
  ) async {
    await pumpAgent(
      tester,
      AgentPermission(
        tool: 'tool',
        parameters: const [RemixDataListItem(label: 'Command', value: 'test')],
        statusBuilder: (context, status) =>
            const SizedBox(key: ValueKey('custom-permission-status')),
        indicatorBuilder: (context, expanded) =>
            const SizedBox(key: ValueKey('custom-permission-indicator')),
      ),
    );

    expect(
      find.byKey(const ValueKey('custom-permission-status')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('custom-permission-indicator')),
      findsOneWidget,
    );
  });

  testWidgets('the primary decision comes last, visually and when read', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pumpAgent(
      tester,
      SizedBox(
        width: 600,
        child: AgentPermission(
          tool: 'tool',
          onAllowOnce: () {},
          onAlwaysAllow: () {},
          onDeny: () {},
        ),
      ),
    );
    const order = ['Deny', 'Always allow', 'Allow once'];
    final lefts = [
      for (final label in order) tester.getTopLeft(find.text(label)).dx,
    ];
    expect(lefts, orderedEquals([...lefts]..sort()));

    // Focus traversal is reading order, which assistive technology follows.
    final read = tester.semantics
        .simulatedAccessibilityTraversal()
        .map((node) => node.getSemanticsData())
        .where((data) => data.flagsCollection.isButton)
        .map((data) => data.label)
        .where(order.contains)
        .toList();
    expect(read, order);
    semantics.dispose();
  });
}
