import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

const _itemCount = 30;
const _panelKey = Key('panel');

enum _Anchor { select, menu }

enum _Host { pageScrollView, listInPageScrollView, nestedNavigatorInPageView }

void main() {
  group('Home and End in an overlay hosted inside another scroll view', () {
    late ScrollController panelController;
    late ScrollController pageController;
    late ScrollController listController;
    late PageController pageViewController;
    late MenuController menuController;
    late List<bool> focusStates;

    setUp(() {
      panelController = ScrollController();
      pageController = ScrollController();
      listController = ScrollController();
      pageViewController = PageController();
      menuController = MenuController();
      focusStates = List<bool>.filled(_itemCount, false);
    });

    tearDown(() {
      panelController.dispose();
      pageController.dispose();
      listController.dispose();
      pageViewController.dispose();
    });

    Widget panel(Widget Function(int index) item) => SizedBox(
      key: _panelKey,
      height: 120,
      child: SingleChildScrollView(
        controller: panelController,
        child: Column(
          children: [
            for (var index = 0; index < _itemCount; index++) item(index),
          ],
        ),
      ),
    );

    Widget item(int index) => SizedBox(
      key: Key('item$index'),
      height: 40,
      child: Text('Item $index'),
    );

    Widget anchor(_Anchor anchor) {
      return switch (anchor) {
        _Anchor.select => NakedSelect<String>(
          onChanged: (_) {},
          builder: (context, state, child) => const Text('Open'),
          overlayBuilder: (context, info) => panel(
            (index) => NakedSelectOption<String>(
              value: 'item$index',
              builder: (context, state, child) {
                focusStates[index] = state.isFocused;
                return child!;
              },
              child: item(index),
            ),
          ),
        ),
        _Anchor.menu => NakedMenu<String>(
          controller: menuController,
          builder: (context, state, child) => const Text('Open'),
          overlayBuilder: (context, info) => panel(
            (index) => NakedMenuItem<String>(
              value: 'item$index',
              builder: (context, state, child) {
                focusStates[index] = state.isFocused;
                return child!;
              },
              child: item(index),
            ),
          ),
        ),
      };
    }

    Widget page(_Anchor anchorKind) => Column(
      children: [
        const SizedBox(height: 1000),
        Align(alignment: Alignment.topLeft, child: anchor(anchorKind)),
      ],
    );

    Future<List<ScrollController>> pumpHost(
      WidgetTester tester,
      _Host host,
      _Anchor anchorKind,
    ) async {
      final theme = ThemeData(splashFactory: NoSplash.splashFactory);
      switch (host) {
        case _Host.pageScrollView:
          await tester.pumpWidget(
            MaterialApp(
              theme: theme,
              builder: (context, child) => SingleChildScrollView(
                controller: pageController,
                child: SizedBox(height: 2000, child: child),
              ),
              home: Scaffold(body: page(anchorKind)),
            ),
          );
          await tester.pump();
          pageController.jumpTo(800);
          await tester.pump();
          return [pageController];
        case _Host.listInPageScrollView:
          await tester.pumpWidget(
            MaterialApp(
              theme: theme,
              builder: (context, child) => SingleChildScrollView(
                controller: pageController,
                child: SizedBox(height: 2000, child: child),
              ),
              home: Scaffold(
                body: SingleChildScrollView(
                  controller: listController,
                  child: SizedBox(height: 3000, child: page(anchorKind)),
                ),
              ),
            ),
          );
          await tester.pump();
          pageController.jumpTo(100);
          listController.jumpTo(800);
          await tester.pump();
          return [pageController, listController];
        case _Host.nestedNavigatorInPageView:
          await tester.pumpWidget(
            MaterialApp(
              theme: theme,
              home: Scaffold(
                body: PageView(
                  controller: pageViewController,
                  children: [
                    Navigator(
                      onGenerateRoute: (settings) => MaterialPageRoute<void>(
                        settings: settings,
                        builder: (context) => SingleChildScrollView(
                          controller: listController,
                          child: SizedBox(
                            height: 2000,
                            child: page(anchorKind),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          );
          await tester.pump();
          listController.jumpTo(800);
          await tester.pump();
          return [pageViewController, listController];
      }
    }

    Future<void> open(WidgetTester tester, _Anchor anchorKind) async {
      switch (anchorKind) {
        case _Anchor.select:
          await tester.tap(find.text('Open'));
        case _Anchor.menu:
          menuController.open();
      }
      await tester.pumpAndSettle();
    }

    bool isInPanel(WidgetTester tester, int index) {
      final panelRect = tester.getRect(find.byKey(_panelKey));
      final itemRect = tester.getRect(find.byKey(Key('item$index')));
      return itemRect.top >= panelRect.top &&
          itemRect.bottom <= panelRect.bottom;
    }

    for (final host in _Host.values) {
      for (final anchorKind in _Anchor.values) {
        testWidgets('End reveals the last item and leaves the page alone '
            '($anchorKind in $host)', (tester) async {
          final hosts = await pumpHost(tester, host, anchorKind);
          await open(tester, anchorKind);
          final offsets = [for (final controller in hosts) controller.offset];
          expect(isInPanel(tester, _itemCount - 1), isFalse);

          await tester.sendKeyEvent(LogicalKeyboardKey.end);
          await tester.pumpAndSettle();

          expect(focusStates.indexWhere((focused) => focused), _itemCount - 1);
          expect(isInPanel(tester, _itemCount - 1), isTrue);
          expect([for (final controller in hosts) controller.offset], offsets);
        });

        testWidgets('Home reveals the first item and leaves the page alone '
            '($anchorKind in $host)', (tester) async {
          final hosts = await pumpHost(tester, host, anchorKind);
          await open(tester, anchorKind);
          panelController.jumpTo(panelController.position.maxScrollExtent);
          await tester.pumpAndSettle();
          final offsets = [for (final controller in hosts) controller.offset];
          expect(isInPanel(tester, 0), isFalse);

          await tester.sendKeyEvent(LogicalKeyboardKey.home);
          await tester.pumpAndSettle();

          expect(focusStates.indexWhere((focused) => focused), 0);
          expect(isInPanel(tester, 0), isTrue);
          expect([for (final controller in hosts) controller.offset], offsets);
        });
      }
    }
  });
}
