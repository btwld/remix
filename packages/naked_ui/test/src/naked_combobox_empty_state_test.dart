import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

import '../test_helpers.dart';

void main() {
  late List<Iterable<String>> shown;
  late List<String> selected;
  late List<String> announcements;
  late int opens;
  late int closes;

  setUp(() {
    shown = [];
    selected = [];
    announcements = [];
    opens = 0;
    closes = 0;
  });

  Future<void> pumpCombobox(
    WidgetTester tester, {
    bool showWhenEmpty = true,
  }) async {
    tester.binding.defaultBinaryMessenger.setMockDecodedMessageHandler(
      SystemChannels.accessibility,
      (message) async {
        if (message is Map && message['type'] == 'announce') {
          announcements.add((message['data'] as Map)['message'] as String);
        }
        return null;
      },
    );
    addTearDown(() {
      tester.binding.defaultBinaryMessenger.setMockDecodedMessageHandler(
        SystemChannels.accessibility,
        null,
      );
    });
    await tester.pumpMaterialWidget(
      NakedCombobox<String>(
        showWhenEmpty: showWhenEmpty,
        onSelected: selected.add,
        onOpen: () => opens++,
        onClose: () => closes++,
        // Like the documented pattern, an empty query has no results.
        optionsBuilder: (value) => value.text.isEmpty
            ? const <String>[]
            : [
                'apple',
                'apricot',
              ].where((fruit) => fruit.startsWith(value.text)),
        fieldBuilder: (context, state, controller, focusNode, submit) {
          return SizedBox(
            width: 200,
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              // Keep focus on submit, as Remix's editor does.
              onEditingComplete: controller.clearComposing,
              onSubmitted: (_) => submit(),
            ),
          );
        },
        overlayBuilder: (context, current) {
          shown.add(current);
          if (current.isEmpty) return const Text('No fruit');
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final option in current)
                NakedComboboxOption<String>(value: option, child: Text(option)),
            ],
          );
        },
      ),
    );
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
  }

  Future<void> type(WidgetTester tester, String text) async {
    await tester.enterText(find.byType(TextField), text);
    await tester.pumpAndSettle();
  }

  TextEditingController controller(WidgetTester tester) =>
      tester.widget<TextField>(find.byType(TextField)).controller!;

  testWidgets('an empty result keeps the view open with no options', (
    tester,
  ) async {
    await pumpCombobox(tester);
    await type(tester, 'ap');
    expect(find.text('apple'), findsOneWidget);

    await type(tester, 'zz');
    expect(find.text('No fruit'), findsOneWidget);
    expect(shown.last, isEmpty);
    expect(opens, 1);
    expect(closes, 0);

    await type(tester, 'apr');
    expect(find.text('No fruit'), findsNothing);
    expect(find.text('apricot'), findsOneWidget);
  });

  testWidgets('Enter accepts nothing from an empty result', (tester) async {
    await pumpCombobox(tester);
    await type(tester, 'zz');
    controller(tester).selection = const TextSelection.collapsed(offset: 0);
    await tester.pump();

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(selected, isEmpty);
    expect(controller(tester).text, 'zz');
    expect(
      controller(tester).selection,
      const TextSelection.collapsed(offset: 0),
    );
    expect(find.text('No fruit'), findsOneWidget);
  });

  testWidgets('Escape closes an empty result', (tester) async {
    await pumpCombobox(tester);
    await type(tester, 'zz');

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('No fruit'), findsNothing);
    expect(closes, 1);
  });

  testWidgets('without showWhenEmpty an empty result closes the view', (
    tester,
  ) async {
    await pumpCombobox(tester, showWhenEmpty: false);
    await type(tester, 'ap');
    expect(find.text('apple'), findsOneWidget);

    await type(tester, 'zz');
    expect(find.text('No fruit'), findsNothing);
    expect(find.text('apple'), findsNothing);
  });

  testWidgets('announces when results become empty and return', (tester) async {
    await pumpCombobox(tester);
    final localizations = WidgetsLocalizations.of(
      tester.element(find.byType(TextField)),
    );

    await type(tester, 'ap');
    expect(announcements, [localizations.searchResultsFound]);

    announcements.clear();
    await type(tester, 'apr');
    expect(announcements, isEmpty);

    await type(tester, 'zz');
    expect(announcements, [localizations.noResultsFound]);

    announcements.clear();
    await type(tester, 'zzz');
    expect(announcements, isEmpty);

    await type(tester, 'a');
    expect(announcements, [localizations.searchResultsFound]);
  });

  testWidgets('a first empty result is not announced as found', (tester) async {
    await pumpCombobox(tester);
    final localizations = WidgetsLocalizations.of(
      tester.element(find.byType(TextField)),
    );

    // Focusing shows the empty view for the empty query.
    expect(find.text('No fruit'), findsOneWidget);
    await type(tester, 'zz');
    expect(find.text('No fruit'), findsOneWidget);
    expect(announcements, isNot(contains(localizations.searchResultsFound)));
    expect(announcements, isEmpty);
  });

  testWidgets('toggling showWhenEmpty keeps the editor state', (tester) async {
    late StateSetter update;
    var showWhenEmpty = false;
    await tester.pumpMaterialWidget(
      StatefulBuilder(
        builder: (context, setState) {
          update = setState;
          return NakedCombobox<String>(
            showWhenEmpty: showWhenEmpty,
            optionsBuilder: (value) => const <String>[],
            fieldBuilder: (context, state, controller, focusNode, submit) =>
                TextField(controller: controller, focusNode: focusNode),
            overlayBuilder: (context, current) => const Text('No fruit'),
          );
        },
      ),
    );
    await tester.tap(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'zz');
    await tester.pumpAndSettle();
    expect(find.text('No fruit'), findsNothing);

    update(() => showWhenEmpty = true);
    await tester.pumpAndSettle();
    expect(controller(tester).text, 'zz');
    expect(
      tester.widget<TextField>(find.byType(TextField)).focusNode!.hasFocus,
      isTrue,
    );
  });

  testWidgets('the caller keeps its own announcement support', (tester) async {
    final supported = <String, bool>{};
    await tester.pumpMaterialWidget(
      NakedCombobox<String>(
        showWhenEmpty: true,
        optionsBuilder: (value) => const <String>[],
        fieldBuilder: (context, state, controller, focusNode, submit) {
          supported['field'] = MediaQuery.supportsAnnounceOf(context);
          return TextField(controller: controller, focusNode: focusNode);
        },
        overlayBuilder: (context, current) {
          supported['overlay'] = MediaQuery.supportsAnnounceOf(context);
          return const Text('No fruit');
        },
      ),
    );
    final expected = MediaQuery.supportsAnnounceOf(
      tester.element(find.byType(NakedCombobox<String>)),
    );
    await tester.tap(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'zz');
    await tester.pumpAndSettle();

    expect(supported, {'field': expected, 'overlay': expected});
  });
}
