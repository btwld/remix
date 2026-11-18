import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../helpers/fortal_text_input_geometry.dart';
import '../../helpers/test_helpers.dart';

void main() {
  test('defaults to size2, surface and the search action', () {
    const field = FortalSearchField(semanticLabel: 'Search');

    expect(field.size, FortalSearchFieldSize.size2);
    expect(field.variant, FortalSearchFieldVariant.surface);
    expect(field.textInputAction, TextInputAction.search);
    expect(field.clearSemanticLabel, 'Clear search');
    expect(
      const FortalSearchField.soft(semanticLabel: 'Search').variant,
      FortalSearchFieldVariant.soft,
    );
  });

  group('geometry', () {
    for (final (size, fieldSize, height, paddingY, glyph) in const [
      (FortalSearchFieldSize.size1, FortalTextFieldSize.size1, 24.0, 4.0, 12.0),
      (FortalSearchFieldSize.size2, FortalTextFieldSize.size2, 32.0, 6.0, 12.0),
      (FortalSearchFieldSize.size3, FortalTextFieldSize.size3, 40.0, 8.0, 16.0),
    ]) {
      for (final variant in FortalSearchFieldVariant.values) {
        for (final scale in [1.0, 2.0]) {
          testWidgets(
            '${size.name} ${variant.name} at $scale keeps the text field '
            'height, with and without the clear button',
            (tester) async {
              final controller = TextEditingController();
              addTearDown(controller.dispose);
              for (final direction in TextDirection.values) {
                for (final text in ['', 'Agj Ép']) {
                  controller.text = text;
                  await tester.pumpRemixApp(
                    MediaQuery(
                      data: MediaQueryData(
                        textScaler: TextScaler.linear(scale),
                      ),
                      child: SizedBox(
                        width: 320,
                        child: FortalSearchField(
                          size: size,
                          variant: variant,
                          controller: controller,
                          semanticLabel: 'Search',
                          hintText: 'Search editions…',
                        ),
                      ),
                    ),
                    textDirection: direction,
                  );
                  await tester.pump();
                  expectFortalTextInputGeometry(
                    tester,
                    scale: scale,
                    height: height,
                    paddingY: paddingY,
                  );
                  expect(
                    find.byType(FortalIconButton),
                    text.isEmpty ? findsNothing : findsOneWidget,
                  );
                }
              }

              // The text field it wraps is the same height, side by side.
              if (scale == 1) {
                await tester.pumpRemixApp(
                  SizedBox(
                    width: 320,
                    child: FortalTextField(size: fieldSize, semanticLabel: 'X'),
                  ),
                );
                expect(_chrome(tester).height, height);
              }
            },
          );
        }
      }

      testWidgets('${size.name} centers a 40px clear target in the field '
          'end, clear of the text', (tester) async {
        for (final direction in TextDirection.values) {
          final controller = TextEditingController(text: 'Mar');
          addTearDown(controller.dispose);
          await tester.pumpRemixApp(
            SizedBox(
              width: 320,
              child: FortalSearchField(
                size: size,
                controller: controller,
                semanticLabel: 'Search',
              ),
            ),
            textDirection: direction,
          );
          final rtl = direction == TextDirection.rtl;
          final field = _chrome(tester);
          final target = tester.getRect(find.byType(FortalIconButton));
          final icon = tester.getRect(find.byIcon(RemixIcons.close));
          final editor = tester.getRect(find.byType(EditableText));

          expect(target.size, const Size.square(40));
          expect(target.center.dy, closeTo(field.center.dy, 0.01));
          expect(
            rtl ? target.left : target.right,
            rtl ? field.left : field.right,
          );
          expect(icon.size, Size.square(glyph));
          expect(icon.center, target.center);
          // The editor stops a spacing step short of the glyph.
          final spacing = size == .size3 ? 12.0 : 8.0;
          expect(
            rtl ? editor.left - icon.right : icon.left - editor.right,
            closeTo(spacing, 0.01),
          );
          // The leading glyph keeps the field's own inset.
          final search = tester.getRect(find.byIcon(RemixIcons.search));
          final inset = size == .size3 ? 12.0 : 8.0;
          expect(
            rtl ? field.right - search.right : search.left - field.left,
            inset,
          );
        }
      });
    }
  });

  group('typing', () {
    // The clear button appears after the first character. If that changed
    // the structure around the editor, the editor would be rebuilt with a
    // new input connection, and on the web every later key would be lost.
    testWidgets('the editor survives the clear button appearing and going', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpRemixApp(
        SizedBox(
          width: 320,
          child: FortalSearchField(
            semanticLabel: 'Search',
            controller: controller,
          ),
        ),
      );
      await tester.showKeyboard(find.byType(EditableText));
      final editor = tester.state<EditableTextState>(find.byType(EditableText));

      tester.testTextInput.enterText('o');
      await tester.pump();
      expect(find.byType(FortalIconButton), findsOneWidget);
      expect(
        tester.state<EditableTextState>(find.byType(EditableText)),
        same(editor),
      );
      expect(tester.testTextInput.hasAnyClients, isTrue);

      tester.testTextInput.enterText('ol');
      await tester.pump();
      expect(controller.text, 'ol');

      tester.testTextInput.enterText('');
      await tester.pump();
      expect(find.byType(FortalIconButton), findsNothing);
      expect(
        tester.state<EditableTextState>(find.byType(EditableText)),
        same(editor),
      );

      tester.testTextInput.enterText('m');
      await tester.pump();
      expect(controller.text, 'm');
      expect(
        tester.state<EditableTextState>(find.byType(EditableText)),
        same(editor),
      );
    });

    // On the web the editor's input element hangs off the semantics tree.
    // A clear button merged into the node around the field turned that node
    // into a "Clear search" button after the first key, and the browser
    // dropped every key after it.
    testWidgets('the clear button is its own semantics node, so the field '
        'and its surroundings keep theirs', (tester) async {
      final semantics = tester.ensureSemantics();
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpRemixApp(
        SizedBox(
          width: 320,
          child: FortalSearchField(
            semanticLabel: 'Search',
            controller: controller,
          ),
        ),
      );
      await tester.showKeyboard(find.byType(EditableText));
      final field = tester.getSemantics(find.byType(EditableText));
      final surroundings = field.parent!;
      final before = surroundings.getSemanticsData();

      tester.testTextInput.enterText('o');
      await tester.pump();

      final typed = tester.getSemantics(find.byType(EditableText));
      expect(typed.id, field.id);
      expect(typed.parent!.id, surroundings.id);
      expect(typed.parent!.getSemanticsData(), before);
      final clear = tester.getSemantics(find.bySemanticsLabel('Clear search'));
      expect(clear.id, isNot(surroundings.id));
      expect(clear, isSemantics(isButton: true, hasTapAction: true));
      expect(clear.childrenCount, 0);

      tester.testTextInput.enterText('');
      await tester.pump();
      expect(tester.getSemantics(find.byType(EditableText)).id, field.id);
      expect(surroundings.getSemanticsData(), before);
      semantics.dispose();
    });

    testWidgets('the text area keeps its width whether or not there is text '
        'to clear', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpRemixApp(
        SizedBox(
          width: 320,
          child: FortalSearchField(
            semanticLabel: 'Search',
            controller: controller,
          ),
        ),
      );
      final empty = tester.getRect(find.byType(EditableText));

      controller.text = 'olivia';
      await tester.pump();
      expect(tester.getRect(find.byType(EditableText)), empty);
    });
  });

  group('clearing', () {
    testWidgets('the clear button clears, reports and refocuses', (
      tester,
    ) async {
      final changes = <String>[];
      var cleared = 0;
      await tester.pumpRemixApp(
        SizedBox(
          width: 320,
          child: FortalSearchField(
            semanticLabel: 'Search',
            onChanged: changes.add,
            onCleared: () => cleared++,
          ),
        ),
      );

      expect(find.byType(FortalIconButton), findsNothing);
      await tester.enterText(find.byType(EditableText), 'mar');
      await tester.pump();
      expect(changes, ['mar']);
      expect(find.byType(FortalIconButton), findsOneWidget);

      // A pointer press elsewhere would move focus; the field keeps it.
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pump();
      await tester.tap(find.byType(FortalIconButton));
      await tester.pump();

      expect(_editable(tester).controller.text, isEmpty);
      expect(changes, ['mar', '']);
      expect(cleared, 1);
      expect(_editable(tester).focusNode.hasFocus, isTrue);
      expect(find.byType(FortalIconButton), findsNothing);
    });

    testWidgets('a caller controller and focus node are used, and a change '
        'from outside shows the button', (tester) async {
      final controller = TextEditingController();
      final focusNode = FocusNode();
      addTearDown(controller.dispose);
      addTearDown(focusNode.dispose);
      await tester.pumpRemixApp(
        SizedBox(
          width: 320,
          child: FortalSearchField(
            semanticLabel: 'Search',
            controller: controller,
            focusNode: focusNode,
          ),
        ),
      );

      controller.text = 'Ava';
      await tester.pump();
      expect(find.byType(FortalIconButton), findsOneWidget);
      expect(_editable(tester).controller, controller);
      await tester.tap(find.byType(FortalIconButton));
      await tester.pump();
      expect(controller.text, isEmpty);
      expect(focusNode.hasFocus, isTrue);
    });

    testWidgets('dropping the caller controller keeps the text in the owned '
        'one', (tester) async {
      final caller = TextEditingController(text: 'Ava');
      addTearDown(caller.dispose);
      Future<void> pump(TextEditingController? controller) =>
          tester.pumpRemixApp(
            SizedBox(
              width: 320,
              child: FortalSearchField(
                semanticLabel: 'Search',
                controller: controller,
              ),
            ),
          );

      await pump(caller);
      await pump(null);

      final owned = _editable(tester).controller;
      expect(owned, isNot(same(caller)));
      expect(owned.text, 'Ava');
      expect(find.byType(FortalIconButton), findsOneWidget);
      // The owned controller is independent of the one it was copied from.
      caller.text = 'Bruno';
      await tester.pump();
      expect(owned.text, 'Ava');
    });

    testWidgets('swapping controllers follows the new one', (tester) async {
      final first = TextEditingController(text: 'one');
      final second = TextEditingController();
      addTearDown(first.dispose);
      addTearDown(second.dispose);
      Future<void> pump(TextEditingController? controller) =>
          tester.pumpRemixApp(
            SizedBox(
              width: 320,
              child: FortalSearchField(
                semanticLabel: 'Search',
                controller: controller,
              ),
            ),
          );

      await pump(first);
      expect(find.byType(FortalIconButton), findsOneWidget);
      await pump(second);
      expect(find.byType(FortalIconButton), findsNothing);
      second.text = 'two';
      await tester.pump();
      expect(find.byType(FortalIconButton), findsOneWidget);
      first.text = '';
      await tester.pump();
      expect(find.byType(FortalIconButton), findsOneWidget);
      // The owned controller starts from the caller's last text.
      await pump(null);
      expect(_editable(tester).controller.text, 'two');
      second.text = '';
      await tester.pump();
      expect(find.byType(FortalIconButton), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    for (final (name, enabled, readOnly) in const [
      ('disabled', false, false),
      ('read-only', true, true),
    ]) {
      testWidgets('a $name field has no clear button and lets Escape pass', (
        tester,
      ) async {
        final controller = TextEditingController(text: 'mar');
        addTearDown(controller.dispose);
        final escapes = <KeyEvent>[];
        await tester.pumpRemixApp(
          Focus(
            onKeyEvent: (_, event) {
              escapes.add(event);
              return KeyEventResult.handled;
            },
            child: SizedBox(
              width: 320,
              child: FortalSearchField(
                semanticLabel: 'Search',
                controller: controller,
                enabled: enabled,
                readOnly: readOnly,
              ),
            ),
          ),
        );

        expect(find.byType(FortalIconButton), findsNothing);
        if (enabled) {
          await tester.tap(find.byType(EditableText));
          await tester.pump();
          await tester.sendKeyEvent(LogicalKeyboardKey.escape);
          expect(controller.text, 'mar');
          expect(
            escapes.whereType<KeyDownEvent>().map((event) => event.logicalKey),
            [LogicalKeyboardKey.escape],
          );
        }
      });
    }
  });

  group('keyboard', () {
    testWidgets('Escape clears when there is text, then passes on', (
      tester,
    ) async {
      final changes = <String>[];
      var cleared = 0;
      var dismissed = 0;
      await tester.pumpRemixApp(
        Actions(
          actions: {
            DismissIntent: CallbackAction<DismissIntent>(
              onInvoke: (_) => dismissed++,
            ),
          },
          child: SizedBox(
            width: 320,
            child: FortalSearchField(
              semanticLabel: 'Search',
              onChanged: changes.add,
              onCleared: () => cleared++,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(EditableText), 'mar');
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      expect(_editable(tester).controller.text, isEmpty);
      expect(changes, ['mar', '']);
      expect(cleared, 1);
      expect(dismissed, 0);

      // Nothing left to clear: Escape reaches the dismiss action, as it would
      // to close a dialog.
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      expect(dismissed, 1);
      expect(cleared, 1);
    });

    testWidgets('Escape leaves an input method composition alone', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      var dismissed = 0;
      await tester.pumpRemixApp(
        Actions(
          actions: {
            DismissIntent: CallbackAction<DismissIntent>(
              onInvoke: (_) => dismissed++,
            ),
          },
          child: SizedBox(
            width: 320,
            child: FortalSearchField(
              semanticLabel: 'Search',
              controller: controller,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(EditableText));
      controller.value = const TextEditingValue(
        text: 'かな',
        selection: TextSelection.collapsed(offset: 2),
        composing: TextRange(start: 0, end: 2),
      );
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      expect(controller.text, 'かな');
      expect(dismissed, 1);
    });

    testWidgets('the clear button is no Tab stop, and the field rings on '
        'focus', (tester) async {
      await tester.pumpRemixApp(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 320,
              child: FortalSearchField(
                semanticLabel: 'Search',
                controller: TextEditingController(text: 'mar'),
              ),
            ),
            FortalButton(label: 'After', onPressed: () {}),
          ],
        ),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(_editable(tester).focusNode.hasFocus, isTrue);
      final effects = tester
          .resolvedSpecOf<TextFieldSpec>(find.byType(EditableText))
          .containerEffects;
      expect(effects?.outline.width, 2);
      expect(
        effects?.outline.color,
        FortalTokens.focus8.resolve(tester.element(find.byType(EditableText))),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(
        FocusManager.instance.primaryFocus?.context
            ?.findAncestorWidgetOfExactType<FortalButton>(),
        isNotNull,
      );
    });

    testWidgets('submitting runs the search action', (tester) async {
      String? submitted;
      await tester.pumpRemixApp(
        SizedBox(
          width: 320,
          child: FortalSearchField(
            semanticLabel: 'Search',
            onSubmitted: (value) => submitted = value,
          ),
        ),
      );

      await tester.enterText(find.byType(EditableText), 'ceu');
      expect(_editable(tester).textInputAction, TextInputAction.search);
      await tester.testTextInput.receiveAction(TextInputAction.search);
      expect(submitted, 'ceu');
    });
  });

  group('colour and style', () {
    for (final mode in const [FortalThemeMode.light, FortalThemeMode.dark]) {
      for (final variant in FortalSearchFieldVariant.values) {
        testWidgets('${variant.name} ${mode.name} takes the text field look '
            'and a matching clear glyph', (tester) async {
          final controller = TextEditingController(text: 'mar');
          addTearDown(controller.dispose);
          await tester.pumpRemixApp(
            SizedBox(
              width: 320,
              child: FortalSearchField(
                variant: variant,
                controller: controller,
                semanticLabel: 'Search',
              ),
            ),
            mode: mode,
          );
          final context = tester.element(find.byType(EditableText));
          final field = tester.resolvedSpecOf<TextFieldSpec>(
            find.byType(EditableText),
          );
          final expected = fortalTextFieldStyle(
            variant: variant == .surface ? .surface : .soft,
          ).build(context).spec;
          expect(
            field.container.spec.decoration,
            expected.container.spec.decoration,
          );
          final glyph = tester.widget<Icon>(find.byIcon(RemixIcons.close));
          expect(
            glyph.color,
            (variant == .surface
                    ? FortalTokens.gray11
                    : FortalTokens.accentContent)
                .resolve(context),
          );
          expect(
            tester.getSize(find.byIcon(RemixIcons.search)),
            const Size.square(16),
          );
          expect(
            IconTheme.of(tester.element(find.byIcon(RemixIcons.search))).color,
            glyph.color,
          );
        });
      }
    }

    testWidgets('a caller style merges last into the field', (tester) async {
      const fill = Color(0xFF123456);
      await tester.pumpRemixApp(
        SizedBox(
          width: 320,
          child: FortalSearchField(
            semanticLabel: 'Search',
            style: TextFieldStyler().color(fill),
          ),
        ),
      );

      expect(
        (tester
                    .resolvedSpecOf<TextFieldSpec>(find.byType(EditableText))
                    .container
                    .spec
                    .decoration
                as BoxDecoration)
            .color,
        fill,
      );
    });
  });

  group('semantics', () {
    testWidgets('the field and its clear button are named', (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpRemixApp(
        SizedBox(
          width: 320,
          child: FortalSearchField(
            semanticLabel: 'Search editions',
            clearSemanticLabel: 'Clear the search',
            controller: TextEditingController(text: 'mar'),
          ),
        ),
      );

      expect(
        tester.getSemantics(find.byType(EditableText)),
        isSemantics(label: 'Search editions', isTextField: true, value: 'mar'),
      );
      expect(
        tester.getSemantics(find.bySemanticsLabel('Clear the search')),
        isSemantics(isButton: true, hasTapAction: true),
      );
      semantics.dispose();
    });
  });
}

EditableText _editable(WidgetTester tester) =>
    tester.widget<EditableText>(find.byType(EditableText));

/// The painted field, inside its touch target.
Rect _chrome(WidgetTester tester) => tester.getRect(
  find
      .ancestor(
        of: find.byType(EditableText),
        matching: find.byType(DecoratedBox),
      )
      .first,
);
