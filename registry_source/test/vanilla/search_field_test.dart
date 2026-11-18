import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/vanilla.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import 'support.dart';

/// shadcn/ui `input-group.tsx`: an `h-9` group with the input's border,
/// a search addon (`pl-3`, `size-4` icon, `text-muted-foreground`, input
/// `pl-2`), and an `InputGroupButton` `size="icon-xs"` (`size-6`, ghost)
/// in an inline-end addon (`pr-3 -mr-[0.45rem]`, input `pr-2`).
void main() {
  Future<void> pump(
    WidgetTester tester,
    Widget field, {
    VanillaThemeData theme = const VanillaThemeData.light(),
    TextDirection direction = TextDirection.ltr,
    double textScale = 1,
    VoidCallback? onDismiss,
  }) async {
    final previous = FocusManager.instance.highlightStrategy;
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
    addTearDown(() => FocusManager.instance.highlightStrategy = previous);

    // A fresh app per pump, with a navigator for the field's overlay and for
    // Tab traversal. Escape that the field passes up reaches [onDismiss].
    await tester.pumpWidget(
      WidgetsApp(
        key: UniqueKey(),
        color: const Color(0xFFFFFFFF),
        pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, _, _) => builder(context),
        ),
        builder: (context, navigator) => VanillaTheme(
          theme: theme,
          child: MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(textScale)),
            child: Directionality(textDirection: direction, child: navigator!),
          ),
        ),
        home: Actions(
          actions: {
            DismissIntent: CallbackAction<DismissIntent>(
              onInvoke: (_) => onDismiss?.call(),
            ),
          },
          child: Center(child: SizedBox(width: 320, child: field)),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  TextFieldSpec fieldSpec(WidgetTester tester) => tester
      .widget<StyleSpecProvider<TextFieldSpec>>(
        find.byType(StyleSpecProvider<TextFieldSpec>),
      )
      .spec
      .spec;

  IconButtonSpec clearSpec(WidgetTester tester) => tester
      .widget<StyleSpecProvider<IconButtonSpec>>(
        find.byType(StyleSpecProvider<IconButtonSpec>),
      )
      .spec
      .spec;

  Finder clearButton() => find.byType(RemixIconButton);
  Finder editable() => find.byType(EditableText);

  /// Lets the 150ms state transition run; the caret blink never settles.
  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  for (final theme in vanillaThemes) {
    group(theme.name, () {
      testWidgets('the field is the text field recipe with the group insets', (
        tester,
      ) async {
        await pump(
          tester,
          const VanillaTextField(hintText: 'Search…'),
          theme: theme.data,
        );
        final text = fieldSpec(tester).container.spec;
        final textSize = tester.getSize(find.byType(VanillaTextField));

        await pump(
          tester,
          const VanillaSearchField(
            semanticLabel: 'Search',
            hintText: 'Search…',
          ),
          theme: theme.data,
        );
        final search = fieldSpec(tester).container.spec;

        expect(tester.getSize(find.byType(VanillaSearchField)), textSize);
        expect(textSize.height, 36);
        expect(search.decoration, text.decoration);
        expect(search.constraints, text.constraints);
        expect(
          search.padding,
          const EdgeInsets.fromLTRB(12, 4, 4, 4),
          reason: 'addon pl-3; inline-end addon pr-3 less the button margin',
        );
        expect(
          fieldSpec(tester).hintText.spec.style?.color,
          theme.data.mutedForeground,
        );
      });

      testWidgets('the search icon is a muted 16px glyph', (tester) async {
        await pump(
          tester,
          const VanillaSearchField(semanticLabel: 'Search'),
          theme: theme.data,
        );
        final glyph = tester.widget<RichText>(
          find.descendant(
            of: find.byIcon(RemixIcons.search),
            matching: find.byType(RichText),
          ),
        );
        expect(glyph.text.style?.color, theme.data.mutedForeground);
        expect(
          tester.getSize(find.byIcon(RemixIcons.search)),
          const Size.square(16),
        );
      });

      testWidgets('the clear button is a 24px ghost square with a muted '
          'glyph', (tester) async {
        final controller = TextEditingController(text: 'ada');
        addTearDown(controller.dispose);
        await pump(
          tester,
          VanillaSearchField(semanticLabel: 'Search', controller: controller),
          theme: theme.data,
        );
        final spec = clearSpec(tester);
        final decoration = spec.container.spec.decoration as BoxDecoration?;

        expect(tester.getSize(clearButton()), const Size.square(24));
        expect(decoration?.color?.a ?? 0, 0, reason: 'ghost: no fill');
        expect(
          decoration?.borderRadius,
          BorderRadius.all(tokenOf(theme.data, VanillaTokens.radiusSm)),
        );
        expect(spec.icon.spec.size, 16);
        expect(spec.icon.spec.color, theme.data.mutedForeground);
      });

      testWidgets('hovering the clear button brings the ghost hover', (
        tester,
      ) async {
        final controller = TextEditingController(text: 'ada');
        addTearDown(controller.dispose);
        await pump(
          tester,
          VanillaSearchField(semanticLabel: 'Search', controller: controller),
          theme: theme.data,
        );
        final pointer = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        addTearDown(pointer.removePointer);
        await pointer.addPointer(location: Offset.zero);
        await pointer.moveTo(tester.getCenter(clearButton()));
        await tester.pumpAndSettle();

        final spec = clearSpec(tester);
        expect(
          (spec.container.spec.decoration as BoxDecoration?)?.color,
          tint(
            theme.data.accent,
            theme.data.brightness == Brightness.dark ? 0.5 : 1,
          ),
        );
        expect(spec.icon.spec.color, theme.data.accentForeground);
      });

      testWidgets('focus rings the field, then the clear button on Tab', (
        tester,
      ) async {
        final controller = TextEditingController(text: 'ada');
        addTearDown(controller.dispose);
        await pump(
          tester,
          VanillaSearchField(semanticLabel: 'Search', controller: controller),
          theme: theme.data,
        );
        final ring = BorderSide(color: tint(theme.data.ring, 0.5), width: 3);

        await tester.tap(editable());
        await settle(tester);
        expect(fieldSpec(tester).containerEffects?.outline, ring);
        expect(clearSpec(tester).containerEffects?.isEmpty ?? true, isTrue);

        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await settle(tester);
        expect(clearSpec(tester).containerEffects?.outline, ring);
        expect(
          fieldSpec(tester).containerEffects?.outline.style,
          BorderStyle.none,
          reason: 'the group rings for its input only',
        );
      });
    });
  }

  testWidgets('the icon, text and clear button keep the group spacing', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'ada');
    addTearDown(controller.dispose);
    await pump(
      tester,
      VanillaSearchField(semanticLabel: 'Search', controller: controller),
    );
    final field = tester.getRect(find.byType(VanillaSearchField));
    final icon = tester.getRect(find.byIcon(RemixIcons.search));
    final text = tester.getRect(editable());
    final clear = tester.getRect(clearButton());

    expect(icon.left - field.left, 13, reason: '1px border, pl-3');
    expect(text.left - icon.right, 8, reason: 'input pl-2');
    expect(clear.left - text.right, 8, reason: 'input pr-2');
    expect(field.right - clear.right, 5, reason: '1px border, 4px inset');
    expect(clear.center.dy, field.center.dy);
    expect(icon.center.dy, field.center.dy);

    controller.clear();
    await tester.pump();
    expect(clearButton(), findsNothing);
    expect(
      field.right - tester.getRect(editable()).right,
      13,
      reason: 'input px-3 without the button',
    );
  });

  testWidgets('right-to-left text mirrors the icon and the clear button', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'ada');
    addTearDown(controller.dispose);
    await pump(
      tester,
      VanillaSearchField(semanticLabel: 'Search', controller: controller),
      direction: TextDirection.rtl,
    );
    final field = tester.getRect(find.byType(VanillaSearchField));
    final icon = tester.getRect(find.byIcon(RemixIcons.search));
    final clear = tester.getRect(clearButton());

    expect(field.right - icon.right, 13);
    expect(clear.left - field.left, 5);
  });

  testWidgets('the clear button shows only for text in an editable field', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    Widget field({bool enabled = true, bool readOnly = false}) =>
        VanillaSearchField(
          semanticLabel: 'Search',
          controller: controller,
          enabled: enabled,
          readOnly: readOnly,
        );

    await pump(tester, field());
    expect(clearButton(), findsNothing);
    await tester.enterText(editable(), 'a');
    await tester.pump();
    expect(clearButton(), findsOneWidget);

    await pump(tester, field(enabled: false));
    expect(clearButton(), findsNothing);
    expect(tester.widget<EditableText>(editable()).controller.text, 'a');

    await pump(tester, field(readOnly: true));
    expect(clearButton(), findsNothing);
  });

  testWidgets('the clear button empties the field, reports it, and keeps '
      'focus', (tester) async {
    final changes = <String>[];
    var cleared = 0;
    await pump(
      tester,
      VanillaSearchField(
        semanticLabel: 'Search',
        onChanged: changes.add,
        onCleared: () => cleared++,
      ),
    );
    await tester.enterText(editable(), 'ada');
    await tester.pump();
    await tester.tap(clearButton());
    await tester.pump();

    expect(tester.widget<EditableText>(editable()).controller.text, isEmpty);
    expect(changes, ['ada', '']);
    expect(cleared, 1);
    expect(clearButton(), findsNothing);
    expect(tester.widget<EditableText>(editable()).focusNode.hasFocus, isTrue);
  });

  testWidgets('the clear button clears from the keyboard and returns focus '
      'to the field', (tester) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    var cleared = 0;
    await pump(
      tester,
      VanillaSearchField(
        semanticLabel: 'Search',
        focusNode: focusNode,
        onCleared: () => cleared++,
      ),
    );
    await tester.enterText(editable(), 'ada');
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(focusNode.hasFocus, isFalse);

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(cleared, 1);
    expect(focusNode.hasFocus, isTrue);
  });

  testWidgets('Escape clears text, and passes up when there is nothing to '
      'clear', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    final changes = <String>[];
    var cleared = 0;
    var dismissed = 0;
    await pump(
      tester,
      VanillaSearchField(
        semanticLabel: 'Search',
        controller: controller,
        onChanged: changes.add,
        onCleared: () => cleared++,
      ),
      onDismiss: () => dismissed++,
    );
    await tester.enterText(editable(), 'ada');
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    expect(controller.text, isEmpty);
    expect(changes, ['ada', '']);
    expect((cleared, dismissed), (1, 0));
    expect(tester.widget<EditableText>(editable()).focusNode.hasFocus, isTrue);

    // Nothing to clear: an enclosing dialog closes instead.
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    expect((cleared, dismissed), (1, 1));
  });

  group('in a dialog', () {
    /// Opens a dismissible dialog holding [field] over the test app.
    Future<void> openDialog(WidgetTester tester, Widget field) async {
      await pump(tester, const SizedBox(key: ValueKey('page')));
      unawaited(
        Navigator.of(tester.element(find.byKey(const ValueKey('page')))).push(
          RawDialogRoute<void>(
            barrierDismissible: true,
            barrierLabel: 'Dismiss',
            pageBuilder: (_, _, _) =>
                Center(child: SizedBox(width: 320, child: field)),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    Finder dialogField() => find.byType(VanillaSearchField);

    testWidgets('holding Escape clears once and leaves the dialog open, and '
        'a fresh Escape then closes it', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      var cleared = 0;
      await openDialog(
        tester,
        VanillaSearchField(
          semanticLabel: 'Search',
          controller: controller,
          onCleared: () => cleared++,
        ),
      );
      await tester.enterText(editable(), 'ada');
      await tester.pump();

      expect(await tester.sendKeyDownEvent(LogicalKeyboardKey.escape), isTrue);
      await tester.pump();
      for (var repeat = 0; repeat < 3; repeat++) {
        expect(
          await tester.sendKeyRepeatEvent(LogicalKeyboardKey.escape),
          isTrue,
          reason: 'repeat $repeat belongs to the press that cleared',
        );
        await tester.pump();
      }
      await tester.sendKeyUpEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(controller.text, isEmpty);
      expect(cleared, 1);
      expect(dialogField(), findsOneWidget, reason: 'the dialog stays open');

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(cleared, 1);
      expect(dialogField(), findsNothing, reason: 'an empty field passes up');
    });

    testWidgets('Escape during composition stays with the input method', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      var cleared = 0;
      await openDialog(
        tester,
        VanillaSearchField(
          semanticLabel: 'Search',
          controller: controller,
          onCleared: () => cleared++,
        ),
      );
      await tester.showKeyboard(editable());
      controller.value = const TextEditingValue(
        text: 'に',
        selection: TextSelection.collapsed(offset: 1),
        composing: TextRange(start: 0, end: 1),
      );
      await tester.pump();

      // Unhandled by the framework, so the platform's input method gets it,
      // and no handler above the field sees it.
      expect(await tester.sendKeyDownEvent(LogicalKeyboardKey.escape), isFalse);
      await tester.sendKeyRepeatEvent(LogicalKeyboardKey.escape);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(controller.text, 'に');
      expect(cleared, 0);
      expect(dialogField(), findsOneWidget, reason: 'the dialog stays open');
    });
  });

  testWidgets('a read-only field passes Escape up', (tester) async {
    final controller = TextEditingController(text: 'ada');
    addTearDown(controller.dispose);
    var dismissed = 0;
    await pump(
      tester,
      VanillaSearchField(
        semanticLabel: 'Search',
        controller: controller,
        readOnly: true,
      ),
      onDismiss: () => dismissed++,
    );
    await tester.tap(editable());
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    expect(controller.text, 'ada');
    expect(dismissed, 1);
  });

  testWidgets('submitting runs the search action', (tester) async {
    final submitted = <String>[];
    await pump(
      tester,
      VanillaSearchField(semanticLabel: 'Search', onSubmitted: submitted.add),
    );
    expect(
      tester.widget<EditableText>(editable()).textInputAction,
      TextInputAction.search,
    );
    await tester.enterText(editable(), 'ada');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();
    expect(submitted, ['ada']);
  });

  testWidgets('the field owns a controller and focus node only when none is '
      'given, and keeps the text when the caller hands it back', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'given');
    addTearDown(controller.dispose);
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    final given = ValueNotifier(true);
    addTearDown(given.dispose);

    await pump(
      tester,
      ValueListenableBuilder<bool>(
        valueListenable: given,
        builder: (_, given, _) => VanillaSearchField(
          semanticLabel: 'Search',
          controller: given ? controller : null,
          focusNode: given ? focusNode : null,
        ),
      ),
    );
    final editableText = tester.widget<EditableText>(editable());
    expect(editableText.controller, same(controller));
    expect(editableText.focusNode, same(focusNode));
    expect(clearButton(), findsOneWidget);

    given.value = false;
    await tester.pump();
    final owned = tester.widget<EditableText>(editable());
    expect(owned.controller, isNot(same(controller)));
    expect(owned.focusNode, isNot(same(focusNode)));
    expect(owned.controller.text, 'given');
    expect(clearButton(), findsOneWidget);

    owned.controller.clear();
    await tester.pump();
    expect(clearButton(), findsNothing);
    expect(controller.text, 'given', reason: "the caller's text is untouched");

    given.value = true;
    await tester.pump();
    expect(clearButton(), findsOneWidget, reason: 'the caller has text again');
  });

  testWidgets('typing the first character and clearing keep the same editor', (
    tester,
  ) async {
    await pump(tester, const VanillaSearchField(semanticLabel: 'Search'));
    await tester.showKeyboard(editable());
    final editor = tester.state<EditableTextState>(editable());

    // Through the text input channel, as a keyboard delivers it.
    tester.testTextInput.updateEditingValue(
      const TextEditingValue(
        text: 'a',
        selection: TextSelection.collapsed(offset: 1),
      ),
    );
    await tester.pump();
    expect(clearButton(), findsOneWidget);
    expect(tester.state<EditableTextState>(editable()), same(editor));
    expect(tester.testTextInput.hasAnyClients, isTrue);

    tester.testTextInput.updateEditingValue(TextEditingValue.empty);
    await tester.pump();
    expect(clearButton(), findsNothing);
    expect(tester.state<EditableTextState>(editable()), same(editor));

    tester.testTextInput.enterText('ab');
    await tester.pump();
    await tester.tap(clearButton());
    await tester.pump();
    expect(clearButton(), findsNothing);
    expect(tester.state<EditableTextState>(editable()), same(editor));
    expect(editor.widget.focusNode.hasFocus, isTrue);
    expect(tester.testTextInput.hasAnyClients, isTrue);
  });

  testWidgets('the field hands its own controller over to a caller', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'given');
    addTearDown(controller.dispose);
    final given = ValueNotifier(false);
    addTearDown(given.dispose);
    final changes = <String>[];

    await pump(
      tester,
      ValueListenableBuilder<bool>(
        valueListenable: given,
        builder: (_, given, _) => VanillaSearchField(
          semanticLabel: 'Search',
          controller: given ? controller : null,
          onChanged: changes.add,
        ),
      ),
    );
    await tester.enterText(editable(), 'own');
    await tester.pump();
    final owned = tester.widget<EditableText>(editable()).controller;
    expect(owned.text, 'own');

    given.value = true;
    await tester.pump();
    expect(
      tester.widget<EditableText>(editable()).controller,
      same(controller),
    );
    expect(controller.text, 'given', reason: 'the caller keeps its own text');
    expect(clearButton(), findsOneWidget);

    // The field now follows the caller's controller, not its own.
    owned.text = '';
    await tester.pump();
    expect(clearButton(), findsOneWidget);
    controller.clear();
    await tester.pump();
    expect(clearButton(), findsNothing);
    await tester.enterText(editable(), 'next');
    await tester.pump();
    expect(controller.text, 'next');
    expect(clearButton(), findsOneWidget);
    expect(changes, ['own', 'next']);
  });

  testWidgets('a disabled field fades as the text field does', (tester) async {
    await pump(
      tester,
      const VanillaSearchField(semanticLabel: 'Search', enabled: false),
    );
    final opacity = tester
        .widgetList<Opacity>(
          find.ancestor(
            of: find.byIcon(RemixIcons.search),
            matching: find.byType(Opacity),
          ),
        )
        .fold(1.0, (product, widget) => product * widget.opacity);
    expect(opacity, 0.5);
  });

  testWidgets('the field and its clear button are named; the icon is not', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      final controller = TextEditingController(text: 'ada');
      addTearDown(controller.dispose);
      await pump(
        tester,
        VanillaSearchField(
          semanticLabel: 'Search customers',
          hintText: 'Search customers…',
          clearSemanticLabel: 'Clear customer search',
          controller: controller,
        ),
      );
      final field = find.semantics.byLabel('Search customers');
      expect(field, findsOne);
      expect(
        field.evaluate().single.getSemanticsData().flagsCollection.isTextField,
        isTrue,
      );
      final clear = find.semantics.byLabel('Clear customer search');
      expect(clear, findsOne);
      final node = clear.evaluate().single;
      expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
      expect(node.getSemanticsData().flagsCollection.isButton, isTrue);
      // Its own node, the size of the button, rather than merged into the
      // node that encloses the field.
      expect(node.rect.size, const Size.square(24));
      expect(node.getSemanticsData().label, 'Clear customer search');
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('a caller style merges last', (tester) async {
    const override = Color(0xFF00FF00);
    await pump(
      tester,
      VanillaSearchField(
        semanticLabel: 'Search',
        style: TextFieldStyler().color(override),
      ),
    );
    expect(
      (fieldSpec(tester).container.spec.decoration as BoxDecoration?)?.color,
      override,
    );
  });
}
