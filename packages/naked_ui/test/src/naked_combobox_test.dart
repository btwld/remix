import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

import '../test_helpers.dart';

void main() {
  Future<void> pumpCombobox(
    WidgetTester tester, {
    required AutocompleteOptionsBuilder<String> optionsBuilder,
    ValueChanged<String>? onSelected,
    TextEditingController? controller,
    FocusNode? focusNode,
    TextEditingValue? initialValue,
    bool enabled = true,
    VoidCallback? onOpen,
    VoidCallback? onClose,
    void Function(NakedComboboxState<String> state)? onState,
  }) async {
    await tester.pumpMaterialWidget(
      NakedCombobox<String>(
        enabled: enabled,
        controller: controller,
        focusNode: focusNode,
        initialValue: initialValue,
        onSelected: onSelected,
        onOpen: onOpen,
        onClose: onClose,
        optionsBuilder: optionsBuilder,
        fieldBuilder: (context, state, fieldController, fieldFocus, submit) {
          onState?.call(state);
          return SizedBox(
            width: 200,
            child: TextField(
              controller: fieldController,
              focusNode: fieldFocus,
              onSubmitted: (_) => submit(),
            ),
          );
        },
        overlayBuilder: (context, current) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final option in current)
                NakedComboboxOption<String>(
                  value: option,
                  builder: (context, state, child) {
                    return Text(
                      state.isHighlighted ? 'hi:$option' : option,
                      key: ValueKey('option-$option'),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  testWidgets('opens on focus when options exist and stays closed otherwise', (
    tester,
  ) async {
    var opens = 0;
    await pumpCombobox(
      tester,
      onOpen: () => opens++,
      optionsBuilder: (value) {
        if (value.text.isEmpty) return const <String>[];
        return ['apple'];
      },
    );

    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(find.text('apple'), findsNothing);

    await tester.enterText(find.byType(TextField), 'a');
    await tester.pump();
    await tester.pump();
    expect(find.textContaining('apple'), findsOneWidget);
    expect(opens, 1);
  });

  testWidgets('arrow keys move the highlight and enter selects it', (
    tester,
  ) async {
    String? selected;
    await pumpCombobox(
      tester,
      onSelected: (value) => selected = value,
      optionsBuilder: (value) => ['apple', 'apricot'],
    );

    await tester.tap(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'ap');
    await tester.pump();
    await tester.pump();

    expect(find.text('hi:apple'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(find.text('hi:apricot'), findsOneWidget);

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    await tester.pump();

    expect(selected, 'apricot');
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'apricot',
    );
    expect(find.text('hi:apricot'), findsNothing);
  });

  testWidgets('escape closes the options view', (tester) async {
    var closes = 0;
    await pumpCombobox(
      tester,
      onClose: () => closes++,
      optionsBuilder: (value) => ['apple'],
    );

    await tester.tap(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'a');
    await tester.pump();
    await tester.pump();
    expect(find.textContaining('apple'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    await tester.pump();
    expect(find.textContaining('apple'), findsNothing);
    expect(closes, 1);
  });

  testWidgets('tapping an option selects it', (tester) async {
    String? selected;
    await pumpCombobox(
      tester,
      onSelected: (value) => selected = value,
      optionsBuilder: (value) => ['apple', 'banana'],
    );

    await tester.tap(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'a');
    await tester.pump();
    await tester.pump();

    await tester.tap(find.textContaining('apple'));
    await tester.pump();
    await tester.pump();

    expect(selected, 'apple');
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'apple',
    );
  });

  testWidgets('clears value when the field text no longer matches', (
    tester,
  ) async {
    NakedComboboxState<String>? latest;
    await pumpCombobox(
      tester,
      onState: (state) => latest = state,
      optionsBuilder: (value) => ['apple'],
    );

    await tester.tap(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'a');
    await tester.pump();
    await tester.pump();
    await tester.tap(find.textContaining('apple'));
    await tester.pump();
    await tester.pump();
    expect(latest?.value, 'apple');

    await tester.enterText(find.byType(TextField), 'apple pie');
    await tester.pump();
    expect(latest?.value, isNull);
    expect(latest?.text, 'apple pie');
  });

  testWidgets('disabled combobox never opens', (tester) async {
    await pumpCombobox(
      tester,
      enabled: false,
      optionsBuilder: (value) => ['apple'],
    );

    await tester.tap(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'apple');
    await tester.pump();
    await tester.pump();
    expect(find.byType(NakedComboboxOption<String>), findsNothing);
  });

  testWidgets('uses an external controller and focus node pair', (
    tester,
  ) async {
    final controller = TextEditingController();
    final focusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);

    await pumpCombobox(
      tester,
      controller: controller,
      focusNode: focusNode,
      optionsBuilder: (value) => ['banana'],
    );

    focusNode.requestFocus();
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'b');
    await tester.pump();
    await tester.pump();
    expect(controller.text, 'b');
    expect(find.textContaining('banana'), findsOneWidget);
  });

  testWidgets('ignores a stale async options result', (tester) async {
    await pumpCombobox(
      tester,
      optionsBuilder: (value) async {
        if (value.text == 'a') {
          await Future<void>.delayed(const Duration(milliseconds: 30));
          return ['apple'];
        }
        return ['banana'];
      },
    );

    await tester.tap(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'a');
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'b');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.textContaining('banana'), findsOneWidget);
    expect(find.text('hi:apple'), findsNothing);
    expect(find.text('apple'), findsNothing);
  });

  group('scrolling options list', () {
    const optionExtent = 40.0;
    const listExtent = 120.0;
    const listKey = Key('options-list');

    Future<void> pumpScrollingCombobox(
      WidgetTester tester, {
      required ScrollController list,
      Axis axis = Axis.vertical,
      TextDirection textDirection = TextDirection.ltr,
      bool lazy = false,
      bool keyed = false,
      Widget Function(Widget combobox)? host,
    }) async {
      Widget option(String value) => NakedComboboxOption<String>(
        key: keyed ? ValueKey('keyed $value') : null,
        value: value,
        builder: (context, state, child) => SizedBox(
          key: ValueKey(value),
          width: axis == Axis.horizontal ? optionExtent : null,
          height: axis == Axis.vertical ? optionExtent : null,
          child: Text(state.isHighlighted ? 'hi:$value' : value),
        ),
      );

      final combobox = NakedCombobox<String>(
        optionsBuilder: (value) => [
          for (var i = 0; i < 30; i++)
            if ('option $i'.contains(value.text)) 'option $i',
        ],
        fieldBuilder: (context, state, controller, focusNode, submit) =>
            SizedBox(
              width: 200,
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                onSubmitted: (_) => submit(),
              ),
            ),
        overlayBuilder: (context, options) {
          final values = options.toList();
          return Align(
            alignment: AlignmentDirectional.topStart,
            child: SizedBox(
              key: listKey,
              width: axis == Axis.horizontal ? listExtent : null,
              height: axis == Axis.horizontal ? optionExtent : listExtent,
              child: lazy
                  ? ListView.builder(
                      controller: list,
                      itemExtent: optionExtent,
                      itemCount: values.length,
                      itemBuilder: (context, index) => option(values[index]),
                    )
                  : SingleChildScrollView(
                      controller: list,
                      scrollDirection: axis,
                      child: Flex(
                        direction: axis,
                        children: [for (final value in values) option(value)],
                      ),
                    ),
            ),
          );
        },
      );

      await tester.pumpMaterialWidget(
        Directionality(
          textDirection: textDirection,
          child: host == null ? combobox : host(combobox),
        ),
      );
    }

    Future<void> openOptions(WidgetTester tester) async {
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'o');
      await tester.pump();
      await tester.pump();
    }

    Future<void> press(WidgetTester tester, LogicalKeyboardKey key) async {
      await tester.sendKeyEvent(key);
      await tester.pump();
      await tester.pump();
    }

    Rect optionRect(WidgetTester tester, int index) =>
        tester.getRect(find.byKey(ValueKey('option $index')));

    Rect listRect(WidgetTester tester) => tester.getRect(find.byKey(listKey));

    void expectHighlightedInView(WidgetTester tester, int index) {
      expect(find.text('hi:option $index'), findsOneWidget);
      final list = listRect(tester);
      final option = optionRect(tester, index);
      expect(
        list.expandToInclude(option),
        list,
        reason: 'option $index at $option is outside the list at $list',
      );
    }

    testWidgets('ArrowDown reveals each option past the fold', (tester) async {
      final list = ScrollController();
      addTearDown(list.dispose);
      await pumpScrollingCombobox(tester, list: list);
      await openOptions(tester);

      for (var index = 1; index <= 8; index++) {
        await press(tester, LogicalKeyboardKey.arrowDown);
        expectHighlightedInView(tester, index);
      }
      expect(optionRect(tester, 8).bottom, listRect(tester).bottom);
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.focusNode!.hasPrimaryFocus, isTrue);
    });

    testWidgets('ArrowUp reveals each option above the fold', (tester) async {
      final list = ScrollController();
      addTearDown(list.dispose);
      await pumpScrollingCombobox(tester, list: list);
      await openOptions(tester);
      for (var index = 1; index <= 8; index++) {
        await press(tester, LogicalKeyboardKey.arrowDown);
      }

      for (var index = 7; index >= 0; index--) {
        await press(tester, LogicalKeyboardKey.arrowUp);
        expectHighlightedInView(tester, index);
      }
      expect(optionRect(tester, 0).top, listRect(tester).top);
      expect(list.offset, 0);
    });

    testWidgets('a highlighted option that is already visible stays put', (
      tester,
    ) async {
      final list = ScrollController();
      addTearDown(list.dispose);
      await pumpScrollingCombobox(tester, list: list);
      await openOptions(tester);
      list.jumpTo(optionExtent);
      await tester.pump();

      for (var index = 1; index <= 3; index++) {
        await press(tester, LogicalKeyboardKey.arrowDown);
        expectHighlightedInView(tester, index);
        expect(list.offset, optionExtent);
      }
      await press(tester, LogicalKeyboardKey.arrowUp);
      expectHighlightedInView(tester, 2);
      expect(list.offset, optionExtent);
    });

    for (final keyed in [false, true]) {
      testWidgets(
        'filtering leaves a list scrolled away from the highlight alone '
        '(keyed: $keyed)',
        (tester) async {
          final list = ScrollController();
          addTearDown(list.dispose);
          await pumpScrollingCombobox(tester, list: list, keyed: keyed);
          await openOptions(tester);
          for (var index = 1; index <= 5; index++) {
            await press(tester, LogicalKeyboardKey.arrowDown);
          }
          list.jumpTo(0);
          await tester.pump();

          await tester.enterText(find.byType(TextField), 'option 1');
          await tester.pump();
          await tester.pump();

          expect(find.text('hi:option 14'), findsOneWidget);
          expect(list.offset, 0);
        },
      );
    }

    testWidgets('reopening with ArrowDown reveals the highlighted option', (
      tester,
    ) async {
      final list = ScrollController();
      addTearDown(list.dispose);
      await pumpScrollingCombobox(tester, list: list);
      await openOptions(tester);
      for (var index = 1; index <= 5; index++) {
        await press(tester, LogicalKeyboardKey.arrowDown);
      }
      await press(tester, LogicalKeyboardKey.escape);
      expect(find.byKey(listKey), findsNothing);

      await press(tester, LogicalKeyboardKey.arrowDown);

      expectHighlightedInView(tester, 6);
    });

    testWidgets('reopening by typing reveals a highlight that did not move', (
      tester,
    ) async {
      final list = ScrollController();
      addTearDown(list.dispose);
      await pumpScrollingCombobox(tester, list: list);
      await openOptions(tester);
      for (var index = 1; index <= 5; index++) {
        await press(tester, LogicalKeyboardKey.arrowDown);
      }
      await press(tester, LogicalKeyboardKey.escape);
      expect(find.byKey(listKey), findsNothing);

      await tester.enterText(find.byType(TextField), 'op');
      await tester.pump();
      await tester.pump();

      expect(find.byKey(listKey), findsOneWidget);
      expectHighlightedInView(tester, 5);
    });

    group('in a lazily built list', () {
      // Cached options sit outside the viewport, which `find` skips by default.
      final firstOption = find.byKey(
        const ValueKey('option 0'),
        skipOffstage: false,
      );

      // The highlighted option 0 is disposed once the list is far from it.
      Future<ScrollController> pumpScrolledAway(WidgetTester tester) async {
        final list = ScrollController();
        addTearDown(list.dispose);
        await pumpScrollingCombobox(tester, list: list, lazy: true);
        await openOptions(tester);
        list.jumpTo(300);
        await tester.pump();
        expect(firstOption, findsNothing);
        return list;
      }

      testWidgets('a wheel scroll back toward the highlight is not undone', (
        tester,
      ) async {
        final list = await pumpScrolledAway(tester);
        final wheel = TestPointer(1, PointerDeviceKind.mouse);
        await tester.sendEventToBinding(
          wheel.hover(tester.getCenter(find.byKey(listKey))),
        );

        await tester.sendEventToBinding(wheel.scroll(const Offset(0, -40)));
        await tester.pump();
        await tester.pump();

        expect(firstOption, findsOneWidget);
        expect(list.offset, 260);
      });

      testWidgets('a drag back toward the highlight is not undone', (
        tester,
      ) async {
        final list = await pumpScrolledAway(tester);

        await tester.drag(find.byKey(listKey), const Offset(0, 60));
        await tester.pump();
        await tester.pump();

        expect(firstOption, findsOneWidget);
        expect(list.offset, inExclusiveRange(150, 300));
      });

      testWidgets('jumping back toward the highlight is not undone', (
        tester,
      ) async {
        final list = await pumpScrolledAway(tester);

        list.jumpTo(200);
        await tester.pump();
        await tester.pump();

        expect(firstOption, findsOneWidget);
        expect(list.offset, 200);
      });
    });

    testWidgets('keeps the scrolled route and page of a nested Navigator', (
      tester,
    ) async {
      final list = ScrollController();
      final route = ScrollController();
      final pages = PageController();
      addTearDown(list.dispose);
      addTearDown(route.dispose);
      addTearDown(pages.dispose);
      await pumpScrollingCombobox(
        tester,
        list: list,
        host: (combobox) => PageView(
          controller: pages,
          children: [
            Navigator(
              onGenerateRoute: (settings) => MaterialPageRoute<void>(
                settings: settings,
                builder: (context) => SingleChildScrollView(
                  controller: route,
                  child: Column(
                    children: [
                      const SizedBox(height: 1000),
                      combobox,
                      const SizedBox(height: 1000),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox.shrink(),
          ],
        ),
      );
      route.jumpTo(800);
      await tester.pump();
      await openOptions(tester);

      for (var index = 1; index <= 8; index++) {
        await press(tester, LogicalKeyboardKey.arrowDown);
        expectHighlightedInView(tester, index);
      }

      expect(route.offset, 800);
      expect(pages.offset, 0);
    });

    for (final textDirection in TextDirection.values) {
      testWidgets('reveals options in a horizontal list in $textDirection', (
        tester,
      ) async {
        final list = ScrollController();
        addTearDown(list.dispose);
        await pumpScrollingCombobox(
          tester,
          list: list,
          axis: Axis.horizontal,
          textDirection: textDirection,
        );
        await openOptions(tester);

        for (var index = 1; index <= 8; index++) {
          await press(tester, LogicalKeyboardKey.arrowDown);
          expectHighlightedInView(tester, index);
        }
        for (var index = 7; index >= 0; index--) {
          await press(tester, LogicalKeyboardKey.arrowUp);
          expectHighlightedInView(tester, index);
        }
      });
    }
  });
}
