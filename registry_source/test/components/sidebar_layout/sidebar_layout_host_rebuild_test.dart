import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:registry_source/heroui.dart';
import 'package:registry_source/vanilla.dart';

void main() {
  final presets = [
    (
      name: 'Vanilla',
      layout: VanillaSidebarLayout.new,
      theme: (Widget child) => VanillaTheme(child: child),
      open: (BuildContext context) =>
          VanillaSidebarLayoutScope.of(context).openCompact(),
    ),
    (
      name: 'Fortal',
      layout: FortalSidebarLayout.new,
      theme: (Widget child) => FortalTheme(child: child),
      open: (BuildContext context) =>
          FortalSidebarLayoutScope.of(context).openCompact(),
    ),
    (
      name: 'HeroUI',
      layout: HeroUiSidebarLayout.new,
      theme: (Widget child) => HeroUiTheme(child: child),
      open: (BuildContext context) =>
          HeroUiSidebarLayoutScope.of(context).openCompact(),
    ),
  ];

  for (final preset in presets) {
    testWidgets(
      '${preset.name}: compact sidebar stays live after host rebuild',
      (tester) async {
        final label = ValueNotifier('Orders');
        addTearDown(label.dispose);
        const body = Text('Body');
        await tester.pumpWidget(
          WidgetsApp(
            color: const Color(0xFFFFFFFF),
            pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
              settings: settings,
              pageBuilder: (context, _, _) => builder(context),
            ),
            builder: (context, child) => preset.theme(child!),
            home: ValueListenableBuilder(
              valueListenable: label,
              builder: (context, value, _) => preset.layout(
                compactBreakpoint: 1000,
                sidebar: _Counter(value),
                body: body,
              ),
            ),
          ),
        );

        preset.open(tester.element(find.byWidget(body)));
        await tester.pumpAndSettle();
        final counter = find.byType(_Counter);
        final state = tester.state(counter);
        final route = ModalRoute.of(tester.element(counter))!;
        await tester.tap(find.text('Orders: 0'));
        await tester.pump();
        expect(find.text('Orders: 1'), findsOneWidget);

        label.value = 'All orders';
        await tester.pumpAndSettle();
        expect(tester.state(counter), same(state));
        expect(ModalRoute.of(tester.element(counter)), same(route));
        expect(find.text('All orders: 1'), findsOneWidget);
        await tester.tap(find.text('All orders: 1'));
        await tester.pump();
        expect(find.text('All orders: 2'), findsOneWidget);
      },
    );
  }
}

class _Counter extends StatefulWidget {
  const _Counter(this.label);

  final String label;

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  int count = 0;

  @override
  Widget build(BuildContext context) => Center(
    child: GestureDetector(
      onTap: () => setState(() => count++),
      child: Text('${widget.label}: $count'),
    ),
  );
}
