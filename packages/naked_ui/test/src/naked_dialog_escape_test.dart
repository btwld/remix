import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

// Escape contracts from the 1.2.0 dialog audit
// (2026-10-07-naked-ui-audit-dialog-combobox-radio.md).
void main() {
  Future<BuildContext> pumpHost(
    WidgetTester tester, {
    Map<ShortcutActivator, Intent>? shortcuts,
  }) async {
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        shortcuts: shortcuts,
        home: Builder(
          builder: (hostContext) {
            context = hostContext;
            return const Scaffold(body: SizedBox());
          },
        ),
      ),
    );

    return context;
  }

  Widget content() => Material(
    type: MaterialType.transparency,
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            autofocus: true,
            onPressed: () {},
            child: const Text('Inside'),
          ),
          const SizedBox(width: 200, child: TextField()),
        ],
      ),
    ),
  );

  final dialogs = <String, Future<String?> Function(BuildContext)>{
    'showNakedDialog': (context) => showNakedDialog<String>(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => content(),
    ),
    'showNakedAlertDialog(barrierDismissible: true)': (context) =>
        showNakedAlertDialog<String>(
          context: context,
          barrierColor: Colors.black54,
          semanticLabel: 'Alert',
          barrierLabel: 'Dismiss',
          barrierDismissible: true,
          builder: (_) => content(),
        ),
  };

  for (final MapEntry(key: name, value: show) in dialogs.entries) {
    group(name, () {
      testWidgets('Escape from focused content closes with null', (
        tester,
      ) async {
        final context = await pumpHost(tester);
        final result = show(context);
        await tester.pumpAndSettle();
        expect(find.text('Inside'), findsOneWidget);

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();

        expect(find.text('Inside'), findsNothing);
        expect(await result, isNull);
      });

      // naked_ui binds Escape itself, so the dialog does not depend on the
      // app's shortcut map.
      testWidgets('Escape closes when app shortcuts omit Escape', (
        tester,
      ) async {
        final context = await pumpHost(
          tester,
          shortcuts: const <ShortcutActivator, Intent>{},
        );
        final result = show(context);
        await tester.pumpAndSettle();

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();

        expect(find.text('Inside'), findsNothing);
        expect(await result, isNull);
      });
    });
  }

  testWidgets('PopScope keeps a dismissible dialog open on Escape', (
    tester,
  ) async {
    final context = await pumpHost(tester);
    final pops = <bool>[];
    final result = showNakedDialog<String>(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => PopScope<String>(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) => pops.add(didPop),
        child: content(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(pops, [false]);
    expect(find.text('Inside'), findsOneWidget);

    Navigator.of(tester.element(find.text('Inside'))).pop('done');
    await tester.pumpAndSettle();
    expect(await result, 'done');
  });

  testWidgets(
    'Escape closes an open nested NakedPopover before dismissing the dialog',
    (tester) async {
      final context = await pumpHost(tester);
      final popoverController = MenuController();
      final result = showNakedDialog<String>(
        context: context,
        barrierColor: Colors.black54,
        builder: (_) => Material(
          type: MaterialType.transparency,
          child: Center(
            child: NakedPopover(
              controller: popoverController,
              popoverBuilder: (context, info) => const Text('Popover Panel'),
              child: NakedButton(
                autofocus: true,
                onPressed: popoverController.open,
                child: const Text('Open Popover'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Popover'));
      await tester.pumpAndSettle();
      expect(find.text('Popover Panel'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Popover Panel'), findsNothing);
      expect(find.text('Open Popover'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Open Popover'), findsNothing);
      expect(await result, isNull);
    },
  );
}
