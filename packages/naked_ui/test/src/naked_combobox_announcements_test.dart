import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

enum _Invalidation { selection, disablement, replacement, removal }

void main() {
  for (final invalidation in _Invalidation.values) {
    testWidgets('discarded query is silent after ${invalidation.name}', (
      tester,
    ) async {
      final announcements = <String>[];
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
      final pending = Completer<Iterable<String>>();
      final selected = <String>[];
      final key = GlobalKey<_AnnouncementHostState>();
      await tester.pumpWidget(
        _AnnouncementHost(
          key: key,
          pending: pending.future,
          onSelected: selected.add,
        ),
      );
      await tester.enterText(find.byType(TextField), 'cached');
      await tester.pumpAndSettle();
      final localizations = WidgetsLocalizations.of(
        tester.element(find.byType(TextField)),
      );
      expect(announcements, [localizations.searchResultsFound]);
      final host = key.currentState!;
      host.fieldController!.text = 'pending';
      await tester.pump();
      switch (invalidation) {
        case _Invalidation.selection:
          await tester.tap(find.text('apple'));
        case _Invalidation.disablement:
          host.update(() => host.enabled = false);
        case _Invalidation.replacement:
          host.replaceEditor();
        case _Invalidation.removal:
          host.update(() => host.show = false);
      }
      await tester.pumpAndSettle();
      announcements.clear();
      pending.complete(['obsolete']);
      await tester.pumpAndSettle();
      expect(announcements, isEmpty);
      expect(find.text('obsolete'), findsNothing);
      if (invalidation == _Invalidation.selection) {
        expect(selected, ['apple']);
        expect(host.fieldController!.text, 'apple');
      }

      // A cancelled framework invocation must not block independent requests.
      host.update(() {
        host.enabled = true;
        host.show = true;
      });
      await tester.pumpAndSettle();
      host.fieldFocus!.requestFocus();
      host.fieldController!.text = 'fresh';
      await tester.pumpAndSettle();
      expect(find.text('banana'), findsOneWidget);
      announcements.clear();
      host.fieldController!.text = 'empty';
      await tester.pumpAndSettle();
      expect(announcements, [localizations.noResultsFound]);
      expect(find.byType(NakedComboboxOption<String>), findsNothing);
      announcements.clear();
      host.fieldController!.text = 'again';
      await tester.pumpAndSettle();
      expect(announcements, [localizations.searchResultsFound]);
      await tester.tap(find.text('banana'));
      await tester.pumpAndSettle();
      expect(selected.last, 'banana');
      expect(host.fieldController!.text, 'banana');
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('invalidated cache waits for fresh async results', (
    tester,
  ) async {
    final pending = Completer<Iterable<String>>();
    final nextPending = Completer<Iterable<String>>();
    final selected = <String>[];
    final key = GlobalKey<_AnnouncementHostState>();
    await tester.pumpWidget(
      _AnnouncementHost(
        key: key,
        pending: pending.future,
        nextPending: nextPending.future,
        onSelected: selected.add,
      ),
    );
    await tester.enterText(find.byType(TextField), 'cached');
    await tester.pumpAndSettle();
    final host = key.currentState!;
    host.fieldController!.text = 'pending';
    await tester.pump();
    host.update(() => host.enabled = false);
    await tester.pump();
    host.update(() => host.enabled = true);
    await tester.pumpAndSettle();
    pending.complete(['obsolete']);
    await tester.pumpAndSettle();
    expect(find.byType(NakedComboboxOption<String>), findsNothing);
    host.fieldController!.text = 'next pending';
    await tester.pumpAndSettle();
    expect(find.byType(NakedComboboxOption<String>), findsNothing);
    host.submit!();
    expect(selected, isEmpty);
    nextPending.complete(['banana']);
    await tester.pumpAndSettle();
    expect(find.text('banana'), findsOneWidget);
    await tester.tap(find.text('banana'));
    await tester.pumpAndSettle();
    expect(selected, ['banana']);
    expect(tester.takeException(), isNull);
  });

  testWidgets('same-query editor replacement cannot revive invalidated cache', (
    tester,
  ) async {
    final pending = Completer<Iterable<String>>();
    final selected = <String>[];
    final key = GlobalKey<_AnnouncementHostState>();
    await tester.pumpWidget(
      _AnnouncementHost(
        key: key,
        pending: pending.future,
        onSelected: selected.add,
      ),
    );
    await tester.enterText(find.byType(TextField), 'cached');
    await tester.pumpAndSettle();
    final host = key.currentState!;
    host.fieldController!.text = 'pending';
    await tester.pump();
    host.replaceEditor(text: 'pending');
    await tester.pumpAndSettle();
    host.fieldFocus!.requestFocus();
    pending.complete(['obsolete']);
    await tester.pumpAndSettle();
    host.fieldController!.selection = const TextSelection.collapsed(offset: 0);
    await tester.pumpAndSettle();
    host.submit!();
    expect(selected, isEmpty);
    expect(find.byType(NakedComboboxOption<String>), findsNothing);
    host.fieldController!.text = 'fresh';
    await tester.pumpAndSettle();
    await tester.tap(find.text('banana'));
    await tester.pumpAndSettle();
    expect(selected, ['banana']);
    expect(tester.takeException(), isNull);
  });

  testWidgets('caret-only results do not release a suppressed query', (
    tester,
  ) async {
    final pending = Completer<Iterable<String>>();
    final fresh = Completer<Iterable<String>>();
    var freshCalls = 0;
    final key = GlobalKey<_AnnouncementHostState>();
    await tester.pumpWidget(
      _AnnouncementHost(
        key: key,
        pending: pending.future,
        onSelected: (_) {},
        optionsBuilder: (query) {
          if (query.text == 'pending') return pending.future;
          if (query.text == 'fresh') {
            return freshCalls++ == 0 ? fresh.future : Future.value(['ignored']);
          }
          return ['apple'];
        },
      ),
    );
    await tester.enterText(find.byType(TextField), 'cached');
    await tester.pumpAndSettle();
    final host = key.currentState!;
    host.fieldController!.text = 'pending';
    await tester.pump();
    host.update(() => host.enabled = false);
    await tester.pump();
    host.update(() => host.enabled = true);
    await tester.pumpAndSettle();
    host.fieldController!.text = 'fresh';
    await tester.pump();
    host.fieldController!.selection = const TextSelection.collapsed(offset: 0);
    await tester.pumpAndSettle();
    expect(freshCalls, greaterThanOrEqualTo(2));
    expect(find.byType(NakedComboboxOption<String>), findsNothing);
    fresh.complete(['banana']);
    await tester.pumpAndSettle();
    expect(find.text('banana'), findsOneWidget);
    expect(find.text('ignored'), findsNothing);
    pending.complete(['obsolete']);
    await tester.pumpAndSettle();
    expect(find.text('banana'), findsOneWidget);
    expect(find.text('obsolete'), findsNothing);
  });

  testWidgets('a prior query typed after selection is tracked as pending', (
    tester,
  ) async {
    final pending = Completer<Iterable<String>>();
    final repeated = Completer<Iterable<String>>();
    var pendingCalls = 0;
    final key = GlobalKey<_AnnouncementHostState>();
    await tester.pumpWidget(
      _AnnouncementHost(
        key: key,
        pending: pending.future,
        onSelected: (_) {},
        optionsBuilder: (query) {
          if (query.text == 'pending') {
            return pendingCalls++ == 0 ? pending.future : repeated.future;
          }
          return ['apple', 'apricot'];
        },
      ),
    );
    await tester.enterText(find.byType(TextField), 'cached');
    await tester.pumpAndSettle();
    final host = key.currentState!;
    host.fieldController!.text = 'pending';
    await tester.pump();
    await tester.tap(find.text('apple'));
    await tester.pumpAndSettle();
    pending.complete(['obsolete']);
    await tester.pumpAndSettle();
    host.fieldController!.text = 'pending';
    await tester.pump();
    host.update(() => host.enabled = false);
    await tester.pump();
    host.update(() => host.enabled = true);
    await tester.pumpAndSettle();
    host.fieldFocus!.unfocus();
    await tester.pump();
    host.fieldFocus!.requestFocus();
    await tester.pumpAndSettle();
    expect(find.byType(NakedComboboxOption<String>), findsNothing);
    expect(host.fieldController!.text, 'pending');
    repeated.complete(['discarded']);
    await tester.pumpAndSettle();
    expect(find.byType(NakedComboboxOption<String>), findsNothing);
    host.fieldController!.text = 'fresh';
    await tester.pumpAndSettle();
    expect(find.text('apricot'), findsOneWidget);
    expect(find.text('discarded'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

class _AnnouncementHost extends StatefulWidget {
  const _AnnouncementHost({
    super.key,
    required this.pending,
    this.nextPending,
    this.optionsBuilder,
    required this.onSelected,
  });

  final Future<Iterable<String>> pending;
  final Future<Iterable<String>>? nextPending;
  final AutocompleteOptionsBuilder<String>? optionsBuilder;
  final ValueChanged<String> onSelected;

  @override
  State<_AnnouncementHost> createState() => _AnnouncementHostState();
}

class _AnnouncementHostState extends State<_AnnouncementHost> {
  bool enabled = true;
  bool show = true;
  TextEditingController? controller;
  FocusNode? focus;
  TextEditingController? fieldController;
  FocusNode? fieldFocus;
  VoidCallback? submit;

  void update(VoidCallback callback) => setState(callback);

  void replaceEditor({String text = 'replacement'}) => setState(() {
    controller = TextEditingController(text: text);
    focus = FocusNode();
  });

  @override
  void dispose() {
    controller?.dispose();
    focus?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(supportsAnnounce: true),
      child: child!,
    ),
    home: Scaffold(
      body: show
          ? NakedCombobox<String>(
              enabled: enabled,
              controller: controller,
              focusNode: focus,
              onSelected: widget.onSelected,
              optionsBuilder:
                  widget.optionsBuilder ??
                  (query) => switch (query.text) {
                    'pending' => widget.pending,
                    'next pending' => widget.nextPending!,
                    'empty' => const <String>[],
                    'cached' => const ['apple'],
                    _ => const ['banana'],
                  },
              fieldBuilder: (_, state, controller, focus, submit) {
                fieldController = controller;
                fieldFocus = focus;
                this.submit = submit;
                return SizedBox(
                  width: 240,
                  child: TextField(
                    controller: controller,
                    focusNode: focus,
                    onSubmitted: (_) => submit(),
                  ),
                );
              },
              overlayBuilder: (_, options) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final option in options)
                    NakedComboboxOption(value: option, child: Text(option)),
                ],
              ),
            )
          : const SizedBox(),
    ),
  );
}
