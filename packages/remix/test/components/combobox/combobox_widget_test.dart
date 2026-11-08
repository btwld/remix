import 'dart:async';
import 'dart:ui' show PointerDeviceKind, SemanticsAction, Tristate;
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart' show PointerScrollEvent;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:naked_ui/naked_ui.dart' show NakedComboboxOption;
import 'combobox_test_host.dart';

void main() {
  for (final height in [32.0, 64.0]) {
    testWidgets('option style owns the $height px minimum including padding', (
      tester,
    ) async {
      await tester.pumpWidget(
        comboboxHost(
          RemixCombobox<String>(
            optionsBuilder: (_) => suggestions,
            style: testComboboxStyle().option(
              ComboboxOptionStyler()
                  .minHeight(height)
                  .padding(.symmetric(horizontal: 8, vertical: 6))
                  .label(.fontSize(14)),
            ),
          ),
        ),
      );
      await openCombobox(tester);
      final row = find.byType(NakedComboboxOption<String>).first;
      expect(tester.getSize(row).height, height);
    });
  }

  testWidgets('semanticLabel replaces the visible editor name once', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      comboboxHost(
        RemixCombobox<String>(
          label: 'Fruit',
          semanticLabel: 'Search destinations',
          optionsBuilder: (_) => suggestions,
          style: testComboboxStyle(),
        ),
      ),
    );
    final nodes = tester.semantics.simulatedAccessibilityTraversal().toList();
    final editor = nodes.singleWhere(
      (node) => node.getSemanticsData().flagsCollection.isTextField,
    );
    expect(editor.getSemanticsData().label, 'Search destinations');
    expect(
      nodes.where(
        (node) => node.getSemanticsData().label.contains('Search destinations'),
      ),
      hasLength(1),
    );
    expect(
      nodes.where((node) => node.getSemanticsData().label.contains('Fruit')),
      isEmpty,
    );
    editor.owner!.performAction(editor.id, SemanticsAction.tap);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText), 'ap');
    await tester.pumpAndSettle();
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).controller.text,
      'ap',
    );
    expect(find.text('Fruit'), findsOneWidget);
    handle.dispose();
  });

  for (final enabled in [true, false]) {
    testWidgets('autofocus respects enabled=$enabled', (tester) async {
      await tester.pumpWidget(
        comboboxHost(
          RemixCombobox<String>(
            autofocus: true,
            enabled: enabled,
            optionsBuilder: (_) => suggestions,
            style: testComboboxStyle(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final editor = tester.widget<EditableText>(find.byType(EditableText));
      expect(editor.focusNode.hasFocus, enabled);
    });
  }

  testWidgets(
    'no-Material keyboard accept, dismiss and traversal retain editing',
    (tester) async {
      final picked = <String>[];
      await tester.pumpWidget(
        comboboxHost(
          RemixCombobox<String>(
            label: 'Fruit',
            optionsBuilder: (_) => suggestions,
            onSelected: picked.add,
            style: testComboboxStyle(),
          ),
        ),
      );
      await openCombobox(tester);
      final editor = tester.widget<EditableText>(find.byType(EditableText));
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(picked, ['Apricot']);
      expect(editor.controller.text, 'Apricot');
      expect(editor.focusNode.hasFocus, isTrue);
      await tester.enterText(find.byType(EditableText), 'ap');
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Apple'), findsNothing);
      expect(editor.controller.text, 'ap');
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      expect(editor.focusNode.hasFocus, isFalse);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      await tester.pumpAndSettle();
      expect(editor.focusNode.hasFocus, isTrue);
      expect(picked, ['Apricot']);
    },
  );

  testWidgets('IME submit finalizes composition before a later acceptance', (
    tester,
  ) async {
    final picked = <String>[];
    await tester.pumpWidget(
      comboboxHost(
        RemixCombobox<String>(
          label: 'Fruit',
          optionsBuilder: (_) => suggestions,
          onSelected: picked.add,
          style: testComboboxStyle(),
        ),
      ),
    );
    await openCombobox(tester, 'ap');
    final editor = tester.widget<EditableText>(find.byType(EditableText));
    tester.testTextInput.updateEditingValue(
      const TextEditingValue(
        text: 'ap',
        selection: TextSelection.collapsed(offset: 2),
        composing: TextRange(start: 0, end: 2),
      ),
    );
    await tester.pump();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(editor.controller.value.composing.isCollapsed, isTrue);
    expect(editor.controller.text, 'ap');
    expect(editor.focusNode.hasFocus, isTrue);
    expect(picked, isEmpty);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(picked, ['Apple']);
    expect(editor.controller.text, 'Apple');
    expect(editor.focusNode.hasFocus, isTrue);
  });

  for (final kind in [
    PointerDeviceKind.mouse,
    PointerDeviceKind.touch,
    PointerDeviceKind.stylus,
  ]) {
    testWidgets('$kind release selects once; cancel does not select', (
      tester,
    ) async {
      final picked = <String>[];
      await tester.pumpWidget(
        comboboxHost(
          RemixCombobox<String>(
            optionsBuilder: (_) => suggestions,
            onSelected: picked.add,
            style: testComboboxStyle(),
          ),
        ),
      );
      await openCombobox(tester);
      var pointer = await tester.startGesture(
        tester.getCenter(find.text('Apricot')),
        kind: kind,
      );
      await pointer.cancel();
      await tester.pumpAndSettle();
      expect(picked, isEmpty);
      pointer = await tester.startGesture(
        tester.getCenter(find.text('Apricot')),
        kind: kind,
      );
      await pointer.up();
      await tester.pumpAndSettle();
      expect(picked, ['Apricot']);
      expect(
        tester
            .widget<EditableText>(find.byType(EditableText))
            .focusNode
            .hasFocus,
        isTrue,
      );
    });
  }

  for (final kind in [
    PointerDeviceKind.mouse,
    PointerDeviceKind.touch,
    PointerDeviceKind.stylus,
  ]) {
    testWidgets('$kind release cannot select a replacement async result', (
      tester,
    ) async {
      final controller = TextEditingController();
      final focus = FocusNode();
      addTearDown(controller.dispose);
      addTearDown(focus.dispose);
      final nextResults = Completer<Iterable<String>>();
      final picked = <String>[];
      await tester.pumpWidget(
        comboboxHost(
          RemixCombobox<String>(
            controller: controller,
            focusNode: focus,
            optionsBuilder: (query) =>
                query.text == 'b' ? nextResults.future : const ['Apple'],
            onSelected: picked.add,
            style: testComboboxStyle(),
          ),
        ),
      );
      await openCombobox(tester, 'a');
      controller.text = 'b';
      await tester.pump();
      final pointer = await tester.startGesture(
        tester.getCenter(find.text('Apple')),
        kind: kind,
      );
      nextResults.complete(const ['Banana']);
      await tester.pumpAndSettle();
      expect(find.text('Banana'), findsOneWidget);
      await pointer.up();
      await tester.pumpAndSettle();
      expect(picked, isEmpty);
      expect(controller.text, 'b');
      await tester.tap(find.text('Banana'));
      await tester.pumpAndSettle();
      expect(picked, ['Banana']);
    });
  }

  testWidgets('exact external pair and callback clear stay coherent', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'initial');
    final focus = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focus.dispose);
    NakedComboboxState<String>? snapshot;
    var calls = 0;
    await tester.pumpWidget(
      comboboxHost(
        RemixCombobox<String>(
          controller: controller,
          focusNode: focus,
          optionsBuilder: (_) => suggestions,
          onSelected: (_) {
            calls++;
            controller.clear();
          },
          fieldBuilder:
              (context, state, passedController, passedFocus, submit) {
                snapshot = state;
                expect(passedController, same(controller));
                expect(passedFocus, same(focus));
                return RemixTextField(
                  label: 'Search',
                  controller: passedController,
                  focusNode: passedFocus,
                  enabled: !state.isDisabled,
                  onSubmitted: (_) => submit(),
                );
              },
        ),
      ),
    );
    expect(snapshot!.text, 'initial');
    expect(snapshot!.value, isNull);
    await openCombobox(tester);
    await tester.tap(find.text('Apple'));
    await tester.pumpAndSettle();
    expect(controller.text, isEmpty);
    expect(snapshot!.value, isNull);
    expect(snapshot!.text, isEmpty);
    expect(calls, 1);
    controller.text = 'again';
    await tester.pumpAndSettle();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(calls, 2);
    expect(controller.text, isEmpty);
  });

  testWidgets('replacement editor cannot accept the previous query cache', (
    tester,
  ) async {
    final oldController = TextEditingController();
    final oldFocus = FocusNode();
    final nextController = TextEditingController.fromValue(
      const TextEditingValue(
        text: 'new query',
        selection: TextSelection.collapsed(offset: 9),
      ),
    );
    final nextFocus = FocusNode();
    for (final controller in [oldController, nextController]) {
      addTearDown(controller.dispose);
    }
    for (final focus in [oldFocus, nextFocus]) {
      addTearDown(focus.dispose);
    }
    var replaced = false;
    late StateSetter update;
    final picked = <String>[];
    await tester.pumpWidget(
      comboboxHost(
        StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return RemixCombobox<String>(
              label: 'Fruit',
              controller: replaced ? nextController : oldController,
              focusNode: replaced ? nextFocus : oldFocus,
              optionsBuilder: (query) =>
                  query.text == 'cached' ? const ['Apple'] : const ['Banana'],
              onSelected: picked.add,
              style: testComboboxStyle(),
            );
          },
        ),
      ),
    );
    await openCombobox(tester, 'cached');
    expect(find.text('Apple'), findsOneWidget);
    update(() => replaced = true);
    await tester.pumpAndSettle();
    nextFocus.requestFocus();
    await tester.pumpAndSettle();
    expect(nextController.text, 'new query');
    expect(find.text('Apple'), findsNothing);
    expect(picked, isEmpty);
    nextController.text = 'fresh';
    await tester.pumpAndSettle();
    await tester.tap(find.text('Banana'));
    await tester.pumpAndSettle();
    expect(picked, ['Banana']);
    expect(nextController.text, 'Banana');
    expect(tester.takeException(), isNull);
  });

  testWidgets('callback clear permits accepting a whole pasted value again', (
    tester,
  ) async {
    final controller = TextEditingController();
    final focus = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focus.dispose);
    final picked = <String>[];
    await tester.pumpWidget(
      comboboxHost(
        RemixCombobox<String>(
          label: 'Fruit',
          controller: controller,
          focusNode: focus,
          optionsBuilder: (_) => const ['Apple'],
          onSelected: (value) {
            picked.add(value);
            controller.clear();
          },
          style: testComboboxStyle(),
        ),
      ),
    );
    await openCombobox(tester, 'ap');
    await tester.tap(find.text('Apple'));
    await tester.pumpAndSettle();
    expect(picked, ['Apple']);
    expect(controller.text, isEmpty);
    tester.testTextInput.updateEditingValue(
      const TextEditingValue(
        text: 'Apple',
        selection: TextSelection.collapsed(offset: 5),
      ),
    );
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(picked, ['Apple', 'Apple']);
    expect(controller.text, isEmpty);
    expect(focus.hasFocus, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('named editor and visual-only option semantics actions work', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();

    final picked = <String>[];
    await tester.pumpWidget(
      comboboxHost(
        RemixCombobox<String>(
          label: 'Fruit',
          optionsBuilder: (_) => suggestions,
          onSelected: picked.add,
          optionBuilder: (_, value) => Text('Visual $value'),
          style: testComboboxStyle(),
        ),
      ),
    );
    var nodes = tester.semantics.simulatedAccessibilityTraversal().toList();
    final editor = nodes.singleWhere(
      (node) => node.getSemanticsData().flagsCollection.isTextField,
    );
    expect(editor.getSemanticsData().label, 'Fruit');
    expect(
      nodes.where((node) => node.getSemanticsData().label.contains('Fruit')),
      hasLength(1),
    );
    editor.owner!.performAction(editor.id, SemanticsAction.tap);
    await tester.pumpAndSettle();
    editor.owner!.performAction(editor.id, SemanticsAction.setText, 'a');
    await tester.pumpAndSettle();
    nodes = tester.semantics.simulatedAccessibilityTraversal().toList();
    final options = nodes
        .where((node) => suggestions.contains(node.getSemanticsData().label))
        .toList();
    expect(options, hasLength(3));
    expect(
      options.every(
        (node) => node.getSemanticsData().hasAction(SemanticsAction.tap),
      ),
      isTrue,
    );
    expect(
      nodes.where((node) => node.getSemanticsData().label.startsWith('Visual')),
      isEmpty,
    );
    options[1].owner!.performAction(options[1].id, SemanticsAction.tap);
    await tester.pumpAndSettle();
    expect(picked, ['Apricot']);
    handle.dispose();
  });

  testWidgets(
    'disabled editor suppresses open options; exclusion covers overlay',
    (tester) async {
      final handle = tester.ensureSemantics();

      final controller = TextEditingController();
      final focus = FocusNode();
      addTearDown(controller.dispose);
      addTearDown(focus.dispose);
      var enabled = true;
      var excluded = false;
      var calls = 0;
      late StateSetter update;
      await tester.pumpWidget(
        comboboxHost(
          StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return RemixCombobox<String>(
                controller: controller,
                focusNode: focus,
                label: 'Fruit',
                optionsBuilder: (_) => suggestions,
                enabled: enabled,
                excludeSemantics: excluded,
                onSelected: (_) => calls++,
                style: testComboboxStyle(),
              );
            },
          ),
        ),
      );
      await openCombobox(tester);
      update(() => excluded = true);
      await tester.pumpAndSettle();
      expect(
        tester.semantics.simulatedAccessibilityTraversal().where(
          (node) =>
              node.getSemanticsData().label.contains('Fruit') ||
              suggestions.contains(node.getSemanticsData().label),
        ),
        isEmpty,
      );
      update(() {
        excluded = false;
        enabled = false;
      });
      await tester.pumpAndSettle();
      expect(find.text('Apple'), findsNothing);
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).readOnly,
        isTrue,
      );
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(controller.text, 'a');
      expect(calls, 0);
      final editor = tester.semantics
          .simulatedAccessibilityTraversal()
          .singleWhere(
            (node) => node.getSemanticsData().flagsCollection.isTextField,
          );
      expect(
        editor.getSemanticsData().flagsCollection.isEnabled,
        Tristate.isFalse,
      );
      handle.dispose();
    },
  );

  testWidgets(
    'popup scrolling leaves the host primary scroll controller alone',
    (tester) async {
      final hostController = ScrollController(initialScrollOffset: 48);
      addTearDown(hostController.dispose);
      await tester.pumpWidget(
        comboboxHost(
          PrimaryScrollController(
            controller: hostController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RemixCombobox<String>(
                  optionsBuilder: (_) =>
                      List.generate(24, (index) => 'Suggestion $index'),
                  style: testComboboxStyle(),
                ),
                SizedBox(
                  height: 200,
                  child: ListView(
                    primary: true,
                    children: const [SizedBox(height: 1000)],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      expect(hostController.positions, hasLength(1));
      final hostOffset = hostController.offset;
      expect(hostOffset, 48);

      await openCombobox(tester);

      expect(find.text('Suggestion 0'), findsOneWidget);
      expect(hostController.positions, hasLength(1));
      expect(hostController.offset, hostOffset);
      final popup = find.byType(SingleChildScrollView).last;
      final popupState = tester.state<ScrollableState>(
        find.descendant(of: popup, matching: find.byType(Scrollable)),
      );
      final popupOffset = popupState.position.pixels;
      await tester.drag(popup, const Offset(0, -120));
      await tester.pumpAndSettle();

      expect(popupState.position.pixels, greaterThan(popupOffset));
      expect(hostController.positions, hasLength(1));
      expect(hostController.offset, hostOffset);
    },
    variant: TargetPlatformVariant({
      TargetPlatform.android,
      TargetPlatform.iOS,
    }),
  );

  testWidgets(
    'touch scrolling does not select and eager last-row reveal works',
    (tester) async {
      final values = List.generate(24, (index) => 'Suggestion $index');
      var calls = 0;
      await tester.pumpWidget(
        comboboxHost(
          RemixCombobox<String>(
            optionsBuilder: (_) => values,
            onSelected: (_) => calls++,
            style: testComboboxStyle(),
          ),
        ),
      );
      await openCombobox(tester);
      final scroll = find.byType(SingleChildScrollView).last;
      await tester.drag(scroll, const Offset(0, -120));
      await tester.pumpAndSettle();
      expect(calls, 0);
      final scrollState = tester.state<ScrollableState>(
        find.descendant(of: scroll, matching: find.byType(Scrollable)),
      );
      expect(scrollState.position.pixels, greaterThan(0));
      final offsetBeforeWheel = scrollState.position.pixels;
      await tester.sendEventToBinding(
        PointerScrollEvent(
          position: tester.getCenter(scroll),
          scrollDelta: const Offset(0, 100),
        ),
      );
      await tester.pumpAndSettle();
      expect(scrollState.position.pixels, greaterThan(offsetBeforeWheel));
      expect(calls, 0);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.metaLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.metaLeft);
      await tester.pumpAndSettle();
      final viewport = tester.getRect(scroll);
      final last = tester.getRect(find.text(values.last));
      expect(last.top, greaterThanOrEqualTo(viewport.top));
      expect(last.bottom, lessThanOrEqualTo(viewport.bottom));
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(calls, 1);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.macOS),
  );
}
