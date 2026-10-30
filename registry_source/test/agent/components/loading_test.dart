import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/agent.dart';
import 'package:remix/remix.dart';

import '../helpers/pump.dart';

Widget execution(AgentExecutionStatus status) => AgentExecution(
  title: 'Checks',
  tool: 'terminal.run',
  status: status,
  child: const Text('Output'),
);

double turns(WidgetTester tester) => tester
    .widget<RotationTransition>(find.byType(RotationTransition))
    .turns
    .value;

void main() {
  testWidgets('running animates, completion stops, retry restarts', (
    tester,
  ) async {
    await pumpAgent(tester, execution(AgentExecutionStatus.running));
    final initial = turns(tester);
    await tester.pump(const Duration(milliseconds: 250));
    expect(turns(tester), greaterThan(initial));
    expect(find.text('Running'), findsOneWidget);

    await pumpAgent(tester, execution(AgentExecutionStatus.success));
    await tester.pumpAndSettle();
    expect(find.byType(RotationTransition), findsNothing);
    expect(tester.binding.transientCallbackCount, 0);

    await pumpAgent(tester, execution(AgentExecutionStatus.running));
    await tester.pump(const Duration(milliseconds: 250));
    expect(turns(tester), greaterThan(0));
  });

  testWidgets('reduced motion stops loading and preserves running status', (
    tester,
  ) async {
    await pumpAgent(tester, execution(AgentExecutionStatus.running));
    await tester.pump(const Duration(milliseconds: 250));
    expect(turns(tester), greaterThan(0));

    await pumpAgent(
      tester,
      execution(AgentExecutionStatus.running),
      disableAnimations: true,
    );
    await tester.pumpAndSettle();
    expect(turns(tester), 0);
    expect(find.text('Running'), findsOneWidget);
    expect(tester.binding.transientCallbackCount, 0);

    await pumpAgent(tester, execution(AgentExecutionStatus.running));
    await tester.pump(const Duration(milliseconds: 250));
    expect(turns(tester), greaterThan(0));
  });

  testWidgets(
    'loading follows disableAnimations and ignores other MediaQuery',
    (tester) async {
      final media = ValueNotifier(const MediaQueryData());
      addTearDown(media.dispose);
      await tester.pumpWidget(
        MixScope.empty(
          child: ValueListenableBuilder(
            valueListenable: media,
            builder: (context, data, child) =>
                MediaQuery(data: data, child: child!),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: execution(AgentExecutionStatus.running),
            ),
          ),
        ),
      );
      late final Element glyph;
      tester.element(find.byType(RotationTransition)).visitAncestorElements((
        ancestor,
      ) {
        glyph = ancestor;
        return false;
      });

      var rebuilds = 0;
      debugOnRebuildDirtyWidget = (element, _) {
        if (identical(element, glyph)) rebuilds++;
      };
      addTearDown(() => debugOnRebuildDirtyWidget = null);

      media.value = const MediaQueryData(
        viewInsets: EdgeInsets.only(bottom: 300),
      );
      await tester.pump(const Duration(milliseconds: 250));
      expect(rebuilds, 0);
      expect(turns(tester), greaterThan(0));

      media.value = const MediaQueryData(
        viewInsets: EdgeInsets.only(bottom: 300),
        disableAnimations: true,
      );
      await tester.pump();
      expect(rebuilds, 1);
      expect(turns(tester), 0);
      expect(tester.binding.transientCallbackCount, 0);
    },
  );

  testWidgets('loading pauses in a disabled ticker subtree', (tester) async {
    await pumpAgent(
      tester,
      TickerMode(
        enabled: false,
        child: execution(AgentExecutionStatus.running),
      ),
    );
    await tester.pumpAndSettle();
    expect(turns(tester), 0);
    expect(tester.binding.transientCallbackCount, 0);
  });

  for (final status in [
    AgentPermissionStatus.deciding,
    AgentPermissionStatus.running,
  ]) {
    testWidgets('permission $status animates its loading indicator', (
      tester,
    ) async {
      await pumpAgent(
        tester,
        AgentPermission(tool: 'terminal.run', status: status),
      );
      await tester.pump(const Duration(milliseconds: 250));
      expect(turns(tester), greaterThan(0));
    });
  }
}
