import 'dart:async';
import 'dart:ui' show SemanticsAction, SemanticsRole, Tristate;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

void main() {
  testWidgets('preserves keyed counter state when the open sheet widens', (
    tester,
  ) async {
    final sidebarKey = GlobalKey<_CounterState>();
    final width = ValueNotifier(300.0);
    addTearDown(width.dispose);
    final changes = <bool>[];

    await tester.pumpWidget(
      _app(
        ValueListenableBuilder(
          valueListenable: width,
          builder: (context, value, _) => Center(
            child: SizedBox(
              width: value,
              height: 400,
              child: _layout(
                sidebar: _Counter(key: sidebarKey),
                onChanged: changes.add,
              ),
            ),
          ),
        ),
        width: 600,
      ),
    );
    final body = find.text('Body');
    final bodyElement = tester.element(body);
    _scope(tester).openCompact();
    await tester.pumpAndSettle();
    expect(_scope(tester).isCompactOpen, isTrue);
    final counterState = sidebarKey.currentState!;
    await tester.tap(find.text('Count: 0'));
    await tester.pump();
    expect(find.text('Count: 1'), findsOneWidget);

    width.value = 500;
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(sidebarKey.currentState, same(counterState));
    expect(find.text('Count: 1'), findsOneWidget);
    expect(_scope(tester).isCompact, isFalse);
    expect(_scope(tester).isCompactOpen, isFalse);
    expect(tester.element(body), same(bodyElement));
    expect(tester.getSize(find.byKey(sidebarKey)).width, 120);
    _scope(tester).openCompact();

    width.value = 300;
    await tester.pumpAndSettle();
    expect(find.byKey(sidebarKey), findsNothing);
    expect(changes, [true, false]);
  });

  testWidgets('selecting an inline destination does not request a close', (
    tester,
  ) async {
    final changes = <bool>[];
    await tester.pumpWidget(
      _app(
        _layout(
          compactOpen: true,
          onChanged: changes.add,
          sidebar: Builder(
            builder: (context) => GestureDetector(
              onTap: RemixSidebarLayoutScope.of(context).closeCompact,
              child: const Text('Orders'),
            ),
          ),
        ),
        width: 600,
      ),
    );
    expect(_scope(tester).isCompactOpen, isFalse);
    await tester.tap(find.text('Orders'));
    expect(changes, isEmpty);
  });

  testWidgets('open panel follows host brightness without losing focus', (
    tester,
  ) async {
    const background = ColorToken('navigation.background');
    const light = Color(0xFFFFFFFF);
    const dark = Color(0xFF171717);
    final focus = FocusNode();
    addTearDown(focus.dispose);
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

    final layout = RemixSidebarLayout(
      compactBreakpoint: 400,
      inlineWidth: 120,
      compactOpen: true,
      sidebar: Focus(
        focusNode: focus,
        autofocus: true,
        child: const Text('Nav'),
      ),
      body: _body,
      compactPanelBuilder: (context, child) => ColoredBox(
        color: MixScope.tokenOf(background, context),
        child: child,
      ),
    );
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) => MixScope(
            colors: {
              background:
                  MediaQuery.platformBrightnessOf(context) == Brightness.dark
                  ? dark
                  : light,
            },
            child: layout,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final panel = find
        .ancestor(of: find.text('Nav'), matching: find.byType(ColoredBox))
        .first;
    final route = ModalRoute.of(tester.element(panel));
    expect(tester.widget<ColoredBox>(panel).color, light);
    expect(FocusManager.instance.primaryFocus, same(focus));

    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    await tester.pumpAndSettle();
    expect(tester.widget<ColoredBox>(panel).color, dark);
    expect(ModalRoute.of(tester.element(panel)), same(route));
    expect(FocusManager.instance.primaryFocus, same(focus));
  });

  testWidgets('a controlled owner can decline Escape or accept dismissal', (
    tester,
  ) async {
    final open = ValueNotifier(false);
    addTearDown(open.dispose);
    final changes = <bool>[];

    await tester.pumpWidget(
      _app(
        ValueListenableBuilder(
          valueListenable: open,
          builder: (context, value, _) =>
              _layout(compactOpen: value, onChanged: changes.add),
        ),
      ),
    );
    _scope(tester).openCompact();
    await tester.pumpAndSettle();
    expect(changes, [true]);
    expect(_scope(tester).isCompactOpen, isFalse);

    open.value = true;
    await tester.pumpAndSettle();
    final links = find.text('Links');
    final route = ModalRoute.of(tester.element(links));
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(changes, [true, false]);
    expect(ModalRoute.of(tester.element(links)), same(route));

    open.value = false;
    await tester.pumpAndSettle();
    expect(links, findsNothing);
    expect(changes, [true, false]);
  });

  testWidgets('keeps focus in the sheet and restores it on Escape', (
    tester,
  ) async {
    final trigger = FocusNode();
    final first = FocusNode();
    final last = FocusNode();
    for (final node in [trigger, first, last]) {
      addTearDown(node.dispose);
    }

    await tester.pumpWidget(
      _app(
        _layout(
          sidebar: Column(
            children: [
              Focus(
                focusNode: first,
                autofocus: true,
                child: const Text('One'),
              ),
              Focus(focusNode: last, child: const Text('Two')),
            ],
          ),
          body: Focus(focusNode: trigger, autofocus: true, child: _body),
        ),
      ),
    );
    expect(FocusManager.instance.primaryFocus, same(trigger));
    _scope(tester).openCompact();
    await tester.pumpAndSettle();
    expect(FocusManager.instance.primaryFocus, same(first));

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(FocusManager.instance.primaryFocus, same(last));
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(FocusManager.instance.primaryFocus, same(first));
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    await tester.pump();
    expect(FocusManager.instance.primaryFocus, same(last));

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(FocusManager.instance.primaryFocus, same(trigger));
    expect(_scope(tester).isCompactOpen, isFalse);
  });

  testWidgets('updates live semantics and exposes a semantic dismiss action', (
    tester,
  ) async {
    final selected = ValueNotifier(false);
    addTearDown(selected.dispose);
    final destination = FocusNode();
    addTearDown(destination.dispose);

    await tester.pumpWidget(
      _app(
        ValueListenableBuilder(
          valueListenable: selected,
          builder: (context, value, _) => _layout(
            sidebar: Focus(
              focusNode: destination,
              autofocus: true,
              child: Semantics(
                selected: value,
                onTap: () => selected.value = true,
                child: Text(value ? 'All orders' : 'Orders'),
              ),
            ),
          ),
        ),
        reduceMotion: true,
      ),
    );
    _scope(tester).openCompact();
    await tester.pumpAndSettle();
    final dialogFinder = find.semantics.byLabel('Navigation');
    final bodyFinder = find.semantics.byLabel('Body');
    final dialog = dialogFinder.evaluate().single.getSemanticsData();
    expect(dialog.role, SemanticsRole.dialog);
    expect(dialog.flagsCollection.scopesRoute, isTrue);
    expect(dialog.flagsCollection.namesRoute, isTrue);
    expect(bodyFinder, findsNothing);

    final route = ModalRoute.of(tester.element(find.text('Orders')));
    final orders = find.semantics.byLabel('Orders');
    expect(
      orders.evaluate().single.getSemanticsData().flagsCollection.isSelected,
      Tristate.isFalse,
    );
    tester.semantics.performAction(orders, SemanticsAction.tap);
    await tester.pumpAndSettle();

    final updated = find.semantics.byLabel('All orders').evaluate().single;
    expect(
      updated.getSemanticsData().flagsCollection.isSelected,
      Tristate.isTrue,
    );
    expect(ModalRoute.of(tester.element(find.text('All orders'))), same(route));
    expect(FocusManager.instance.primaryFocus, same(destination));

    final barrier = find.semantics.byLabel('Close navigation');
    tester.semantics.performAction(barrier, SemanticsAction.dismiss);
    await tester.pumpAndSettle();
    expect(dialogFinder, findsNothing);
    expect(bodyFinder, findsOne);
  });

  testWidgets(
    'rapid reopen waits for the outgoing sheet with a shared nested key',
    (tester) async {
      final sidebar = ValueNotifier('Links');
      final sidebarKey = GlobalKey();
      addTearDown(sidebar.dispose);

      await tester.pumpWidget(
        _app(
          ValueListenableBuilder(
            valueListenable: sidebar,
            builder: (context, value, _) => _layout(
              sidebar: Center(child: Text(value, key: sidebarKey)),
            ),
          ),
        ),
      );
      _scope(tester).openCompact();
      await tester.pumpAndSettle();
      final exitingContext = tester.element(find.text('Links'));
      final exitingScope = RemixSidebarLayoutScope.of(exitingContext);
      final exitingRoute = ModalRoute.of(exitingContext)!;
      exitingRoute.navigator!.pop();
      await tester.pump();

      _scope(tester).openCompact();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 20));
      sidebar.value = 'Updated links';
      exitingScope.closeCompact();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 20));
      expect(tester.takeException(), isNull);
      final links = find.text('Links', skipOffstage: false);
      expect(links, findsOneWidget);
      expect(ModalRoute.of(tester.element(links)), same(exitingRoute));
      expect(find.text('Updated links', skipOffstage: false), findsNothing);

      await tester.pumpAndSettle();
      expect(links, findsNothing);
      final updated = find.byKey(sidebarKey);
      expect(tester.widget<Text>(updated).data, 'Updated links');
      expect(ModalRoute.of(tester.element(updated)), isNot(same(exitingRoute)));
      expect(_scope(tester).isCompactOpen, isTrue);
    },
  );

  testWidgets('disposing the layout removes only its own route', (
    tester,
  ) async {
    final showLayout = ValueNotifier(true);
    addTearDown(showLayout.dispose);
    final changes = <bool>[];
    await tester.pumpWidget(
      _app(
        ValueListenableBuilder(
          valueListenable: showLayout,
          builder: (context, value, _) =>
              value ? _layout(onChanged: changes.add) : const Text('Home'),
        ),
      ),
    );
    _scope(tester).openCompact();
    await tester.pumpAndSettle();

    final sheet = ModalRoute.of(tester.element(find.text('Links')))!;
    final navigator = sheet.navigator!;
    unawaited(
      navigator.push<void>(
        PageRouteBuilder<void>(pageBuilder: (_, _, _) => const Text('Other')),
      ),
    );
    await tester.pumpAndSettle();

    showLayout.value = false;
    await tester.pumpAndSettle();
    expect(sheet.isActive, isFalse);
    expect(find.text('Other'), findsOneWidget);
    expect(changes, [true]);

    navigator.pop();
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

const _body = Text('Body');

class _Counter extends StatefulWidget {
  const _Counter({super.key});

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  int _count = 0;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => setState(() => _count++),
    child: Text('Count: $_count'),
  );
}

RemixSidebarLayoutScope _scope(WidgetTester tester) =>
    RemixSidebarLayoutScope.of(
      tester.element(find.byWidget(_body, skipOffstage: false)),
    );

Widget _layout({
  Widget sidebar = const Text('Links'),
  Widget body = _body,
  bool? compactOpen,
  ValueChanged<bool>? onChanged,
}) => RemixSidebarLayout(
  sidebar: sidebar,
  body: body,
  compactBreakpoint: 400,
  inlineWidth: 120,
  compactOpen: compactOpen,
  onCompactOpenChanged: onChanged,
  compactPanelBuilder: (context, child) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: SizedBox(width: 120, height: 400, child: child),
  ),
);

Widget _app(Widget home, {double width = 300, bool reduceMotion = false}) =>
    WidgetsApp(
      color: const Color(0xFFFFFFFF),
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, _, _) => builder(context),
      ),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: reduceMotion),
        child: child!,
      ),
      home: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(width: width, height: 500, child: home),
      ),
    );
