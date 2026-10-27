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
      Widget Function(Widget combobox)? host,
    }) async {
      Widget option(String value) => NakedComboboxOption<String>(
        value: value,
        builder: (context, state, child) => SizedBox(
          key: ValueKey(value),
          width: axis == Axis.horizontal ? optionExtent : null,
          height: axis == Axis.vertical ? optionExtent : null,
          child: Text(state.isHighlighted ? 'hi:$value' : value),
        ),
      );

      final combobox = NakedCombobox<String>(
        optionsBuilder: (value) => [for (var i = 0; i < 30; i++) 'option $i'],
        fieldBuilder: (context, state, controller, focusNode, submit) =>
            SizedBox(
              width: 200,
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                onSubmitted: (_) => submit(),
              ),
            ),
        overlayBuilder: (context, options) => Align(
          alignment: AlignmentDirectional.topStart,
          child: SizedBox(
            key: listKey,
            width: axis == Axis.horizontal ? listExtent : null,
            height: axis == Axis.horizontal ? optionExtent : listExtent,
            child: SingleChildScrollView(
              controller: list,
              scrollDirection: axis,
              child: Flex(
                direction: axis,
                children: [for (final value in options) option(value)],
              ),
            ),
          ),
        ),
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

    testWidgets('a rebuild does not pull the list back to the highlight', (
      tester,
    ) async {
      final list = ScrollController();
      addTearDown(list.dispose);
      await pumpScrollingCombobox(tester, list: list);
      await openOptions(tester);
      for (var index = 1; index <= 5; index++) {
        await press(tester, LogicalKeyboardKey.arrowDown);
      }
      list.jumpTo(0);
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'op');
      await tester.pump();
      await tester.pump();

      expect(find.text('hi:option 5'), findsOneWidget);
      expect(list.offset, 0);
    });

    testWidgets('reopening reveals the option that is still highlighted', (
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

    testWidgets('keeps a scrolled page where it is', (tester) async {
      // The options view renders in the nearest Overlay. One inside the page
      // puts the page's viewport on the options' render ancestry, so a reveal
      // that over-scrolls reaches the page.
      final list = ScrollController();
      final page = ScrollController();
      addTearDown(list.dispose);
      addTearDown(page.dispose);
      await pumpScrollingCombobox(
        tester,
        list: list,
        host: (combobox) => SingleChildScrollView(
          controller: page,
          child: Column(
            children: [
              const SizedBox(height: 1000),
              SizedBox(
                height: 300,
                child: Overlay.wrap(
                  child: Align(
                    alignment: AlignmentDirectional.topStart,
                    child: combobox,
                  ),
                ),
              ),
              const SizedBox(height: 1000),
            ],
          ),
        ),
      );
      page.jumpTo(900);
      await tester.pump();
      await openOptions(tester);

      for (var index = 1; index <= 8; index++) {
        await press(tester, LogicalKeyboardKey.arrowDown);
        expectHighlightedInView(tester, index);
      }
      expect(page.offset, 900);
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
