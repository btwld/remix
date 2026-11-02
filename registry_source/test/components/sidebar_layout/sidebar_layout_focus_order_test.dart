import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart' show FortalSidebarLayout;
import 'package:registry_source/vanilla.dart' show VanillaSidebarLayout;

Widget _stop(FocusNode node) =>
    Focus(focusNode: node, child: const SizedBox(width: 100, height: 40));

Widget _gap(double height) => SizedBox(height: height);

void main() {
  final layouts = <String, Widget Function(Widget sidebar, Widget body)>{
    'Fortal': (sidebar, body) =>
        FortalSidebarLayout(sidebar: sidebar, body: body),
    'Vanilla': (sidebar, body) =>
        VanillaSidebarLayout(sidebar: sidebar, body: body),
  };

  for (final MapEntry(key: preset, value: layout) in layouts.entries) {
    testWidgets('$preset: Tab finishes one pane before the other', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final names = ['sidebar 1', 'sidebar 2', 'body 1', 'body 2', 'body 3'];
      final nodes = {
        for (final name in names) name: FocusNode(debugLabel: name),
      };
      for (final node in nodes.values) {
        addTearDown(node.dispose);
      }

      // The heights interleave: sorted by position alone, Tab would go
      // sidebar 1, body 1, body 2, sidebar 2, body 3.
      await tester.pumpWidget(
        WidgetsApp(
          color: const Color(0xFFFFFFFF),
          builder: (context, _) => layout(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _stop(nodes['sidebar 1']!),
                _gap(100),
                _stop(nodes['sidebar 2']!),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _stop(nodes['body 1']!),
                _gap(40),
                _stop(nodes['body 2']!),
                _gap(120),
                _stop(nodes['body 3']!),
              ],
            ),
          ),
        ),
      );

      nodes['sidebar 1']!.requestFocus();
      await tester.pump();

      final visited = [FocusManager.instance.primaryFocus?.debugLabel];
      for (var i = 0; i < names.length - 1; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        visited.add(FocusManager.instance.primaryFocus?.debugLabel);
      }

      expect(visited, names);
    });

    testWidgets('$preset: the panes keep an app traversal policy', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final first = FocusNode(debugLabel: 'first');
      final second = FocusNode(debugLabel: 'second');
      addTearDown(first.dispose);
      addTearDown(second.dispose);

      await tester.pumpWidget(
        WidgetsApp(
          color: const Color(0xFFFFFFFF),
          builder: (context, _) => FocusTraversalGroup(
            policy: OrderedTraversalPolicy(),
            child: layout(
              const SizedBox.shrink(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FocusTraversalOrder(
                    order: const NumericFocusOrder(2),
                    child: _stop(second),
                  ),
                  FocusTraversalOrder(
                    order: const NumericFocusOrder(1),
                    child: _stop(first),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      first.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();

      expect(FocusManager.instance.primaryFocus, second);
    });
  }
}
