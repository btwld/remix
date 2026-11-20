import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

import '../test_helpers.dart';

final class _Exit {
  VoidCallback? dismiss;
  int built = 0;
  Widget? view;
}

Future<void> _pump(
  WidgetTester tester,
  _Exit exit, {
  bool withExit = true,
  bool enabled = true,
  Key? panelKey,
  NakedComboboxExitBuilder? exitBuilder,
  Widget Function(Widget child)? transform,
  VoidCallback? onOpen,
  VoidCallback? onClose,
  ValueChanged<String>? onSelected,
}) {
  final combobox = NakedCombobox<String>(
    enabled: enabled,
    onOpen: onOpen,
    onClose: onClose,
    onSelected: onSelected,
    optionsBuilder: (value) => switch (value.text) {
      '' => const <String>[],
      'apr' => ['apricot'],
      _ => ['apple', 'apricot'],
    },
    exitBuilder: !withExit
        ? null
        : (context, view, dismiss) {
            exit.built++;
            exit.dismiss = dismiss;
            exit.view = view;
            return exitBuilder?.call(context, view, dismiss) ??
                Opacity(opacity: .5, child: view);
          },
    fieldBuilder: (context, state, controller, focusNode, submit) => SizedBox(
      width: 200,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onSubmitted: (_) => submit(),
      ),
    ),
    overlayBuilder: (context, options) => Material(
      key: panelKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final option in options)
            NakedComboboxOption<String>(
              value: option,
              builder: (context, state, _) => Text(
                state.isHighlighted ? 'hi:$option' : option,
                key: ValueKey('option-$option'),
              ),
            ),
        ],
      ),
    ),
  );
  return tester.pumpMaterialWidget(
    Align(
      alignment: Alignment.topLeft,
      child: transform?.call(combobox) ?? combobox,
    ),
  );
}

Future<void> _open(WidgetTester tester) async {
  await tester.tap(find.byType(TextField));
  await tester.enterText(find.byType(TextField), 'ap');
  await tester.pump();
  await tester.pump();
}

Future<void> _close(WidgetTester tester) async {
  await tester.sendKeyEvent(LogicalKeyboardKey.escape);
  await tester.pump();
  await tester.pump();
}

void main() {
  group('NakedCombobox exitBuilder', () {
    testWidgets('rebuilds the last options view after the hiding frame, '
        'in the same place, until dismissed', (tester) async {
      final exit = _Exit();
      var closes = 0;
      await _pump(tester, exit, onClose: () => closes++);
      await _open(tester);
      final before = tester.getRect(find.byKey(const ValueKey('option-apple')));

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();

      expect(find.byKey(const ValueKey('option-apple')), findsNothing);
      expect(exit.built, 0);
      expect(closes, 1);
      await tester.pump();

      expect(find.byKey(const ValueKey('option-apple')), findsOneWidget);
      expect(exit.built, greaterThan(0));
      expect(
        tester.getRect(find.byKey(const ValueKey('option-apple'))),
        before,
      );
      await tester.pump(const Duration(seconds: 1));
      expect(find.byKey(const ValueKey('option-apple')), findsOneWidget);
      expect(closes, 1, reason: 'onClose reports the unmount, not the exit');

      exit.dismiss!();
      await tester.pump();
      expect(find.byKey(const ValueKey('option-apple')), findsNothing);
      exit.dismiss!();
      await tester.pump();
    });

    testWidgets('builds the exit on the next frame for each close path', (
      tester,
    ) async {
      for (final hide in <Future<void> Function(WidgetTester)>[
        (t) => t.sendKeyEvent(LogicalKeyboardKey.escape),
        (t) => t.enterText(find.byType(TextField), ''),
        (t) async => FocusManager.instance.primaryFocus?.unfocus(),
        (t) => t.tap(find.byKey(const ValueKey('option-apple'))),
      ]) {
        final exit = _Exit();
        await _pump(tester, exit);
        await _open(tester);
        expect(exit.built, 0);

        await hide(tester);
        await tester.pump(Duration.zero);

        expect(find.byKey(const ValueKey('option-apple')), findsNothing);
        expect(exit.built, 0);
        await tester.pump(Duration.zero);

        expect(find.byKey(const ValueKey('option-apple')), findsOneWidget);
        expect(exit.built, greaterThan(0));
        await tester.pumpWidget(const SizedBox());
      }
    });

    testWidgets('disabling uses the same next-frame exit timing', (
      tester,
    ) async {
      final exit = _Exit();
      await _pump(tester, exit);
      await _open(tester);

      await _pump(tester, exit, enabled: false);
      expect(find.byKey(const ValueKey('option-apple')), findsNothing);
      expect(exit.built, 0);

      await tester.pump();
      expect(find.byKey(const ValueKey('option-apple')), findsOneWidget);
      expect(exit.built, greaterThan(0));
      expect(tester.takeException(), isNull);
    });

    testWidgets('the entire exit result takes no pointer, focus or semantics', (
      tester,
    ) async {
      final exit = _Exit();
      final selected = <String>[];
      final focus = FocusNode();
      addTearDown(focus.dispose);
      final semantics = tester.ensureSemantics();
      var taps = 0;
      await _pump(
        tester,
        exit,
        onSelected: selected.add,
        exitBuilder: (context, view, dismiss) => Focus(
          focusNode: focus,
          child: Semantics(
            label: 'exit wrapper',
            onTap: () => taps++,
            child: GestureDetector(onTap: () => taps++, child: view),
          ),
        ),
      );
      await _open(tester);
      await _close(tester);

      focus.requestFocus();
      await tester.tap(
        find.byKey(const ValueKey('option-apple')),
        warnIfMissed: false,
      );
      await tester.pump();

      expect(selected, isEmpty);
      expect(taps, 0);
      expect(focus.hasFocus, isFalse);
      expect(find.bySemanticsLabel('apple'), findsNothing);
      expect(find.bySemanticsLabel('exit wrapper'), findsNothing);
      semantics.dispose();
    });

    testWidgets('reopen replaces the keyed exit without overlapping panels', (
      tester,
    ) async {
      final exit = _Exit();
      final panelKey = GlobalKey();
      var opened = 0;
      await _pump(tester, exit, panelKey: panelKey, onOpen: () => opened++);
      await _open(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(find.text('hi:apricot'), findsOneWidget);
      await _close(tester);
      expect(find.text('hi:apricot'), findsOneWidget);
      expect(opened, 1);

      await tester.enterText(find.byType(TextField), 'apr');
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(opened, 1);
      expect(find.byKey(panelKey), findsOneWidget);
      expect(find.byKey(const ValueKey('option-apple')), findsOneWidget);
      expect(find.text('hi:apricot'), findsOneWidget);
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(opened, 2);
      expect(find.byKey(panelKey), findsOneWidget);
      expect(find.byKey(const ValueKey('option-apple')), findsNothing);
      expect(find.text('hi:apricot'), findsOneWidget);
    });

    testWidgets('dismiss cannot affect a later exit', (tester) async {
      final exit = _Exit();
      await _pump(tester, exit);
      await _open(tester);
      await _close(tester);
      final oldDismiss = exit.dismiss!;

      await tester.enterText(find.byType(TextField), 'apr');
      await tester.pump();
      await tester.pump();
      await _close(tester);
      final currentDismiss = exit.dismiss!;

      oldDismiss();
      oldDismiss();
      await tester.pump();
      expect(find.byKey(const ValueKey('option-apricot')), findsOneWidget);
      currentDismiss();
      currentDismiss();
      await tester.pump();
      expect(find.byKey(const ValueKey('option-apricot')), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('dismiss can be called synchronously by the exit builder', (
      tester,
    ) async {
      for (final disable in [false, true]) {
        final exit = _Exit();
        Widget skip(BuildContext context, Widget view, VoidCallback dismiss) {
          dismiss();
          dismiss();
          return view;
        }

        await _pump(tester, exit, exitBuilder: skip);
        await _open(tester);
        if (disable) {
          await _pump(tester, exit, enabled: false, exitBuilder: skip);
          await tester.pump();
        } else {
          await _close(tester);
        }
        expect(exit.built, 1);
        expect(find.byKey(const ValueKey('option-apple')), findsNothing);
        expect(tester.takeException(), isNull);
        await tester.pump();
        if (!disable) {
          await tester.enterText(find.byType(TextField), 'apr');
          await tester.pump();
          expect(find.byKey(const ValueKey('option-apricot')), findsOneWidget);
        }
        await tester.pumpWidget(const SizedBox());
      }
    });

    testWidgets('exit keeps signed and transformed panel geometry', (
      tester,
    ) async {
      for (final scale in [1.0, .75]) {
        final exit = _Exit();
        await _pump(
          tester,
          exit,
          transform: (child) => Transform.translate(
            offset: const Offset(-25, -60),
            child: Transform.scale(
              scale: scale,
              alignment: Alignment.topLeft,
              child: child,
            ),
          ),
        );
        final field = find.byType(TextField);
        await tester.enterText(field, 'ap');
        await tester.pump();
        await tester.pump();
        final option = find.byKey(const ValueKey('option-apple'));
        final bounds = tester.getRect(option);
        expect(bounds.left, lessThan(0));
        expect(bounds.top, lessThan(0));
        await _close(tester);
        expect(tester.getRect(option), bounds);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      }
    });

    testWidgets('without an exitBuilder the view leaves at once', (
      tester,
    ) async {
      final exit = _Exit();
      await _pump(tester, exit, withExit: false);
      await _open(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();

      expect(find.byKey(const ValueKey('option-apple')), findsNothing);
      expect(exit.built, 0);
    });

    testWidgets('dismiss after disposal is harmless and leaves no layer', (
      tester,
    ) async {
      final exit = _Exit();
      await _pump(tester, exit);
      await _open(tester);
      await _close(tester);
      final dismiss = exit.dismiss!;

      await tester.pumpWidget(const SizedBox());
      dismiss();
      dismiss();
      await tester.pump();
      expect(find.byKey(const ValueKey('option-apple')), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });
}
