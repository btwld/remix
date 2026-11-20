import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../helpers/motion_harness.dart';
import '../helpers/test_helpers.dart';

const _duration = Duration(milliseconds: 200);

enum _Overlay {
  menu,
  popover,
  select;

  Widget build({
    required RemixPanelTransition transition,
    VoidCallback? onOpen,
    VoidCallback? onClose,
    MenuController? controller,
    RawMenuAnchorOpenRequestedCallback? onOpenRequested,
    RawMenuAnchorCloseRequestedCallback? onCloseRequested,
    bool control = false,
  }) => switch (this) {
    menu => RemixMenu<String>(
      trigger: control
          ? RemixMenuTrigger.control(
              builder: (context, menu) => TextButton(
                focusNode: menu.focusNode,
                onPressed: menu.toggle,
                child: const Text('Open'),
              ),
            )
          : const RemixMenuTrigger(label: 'Open'),
      items: const [RemixMenuItem(value: 'item', label: 'Content')],
      style: MenuStyler().panelTransition(transition),
      controller: controller,
      onOpenRequested: onOpenRequested,
      onCloseRequested: onCloseRequested,
      onOpen: onOpen,
      onClose: onClose,
    ),
    popover => RemixPopover(
      child: const Text('Open'),
      popoverChild: const Text('Content'),
      style: PopoverStyler().panelTransition(transition),
      controller: controller,
      onOpenRequested: onOpenRequested,
      onCloseRequested: onCloseRequested,
      onOpen: onOpen,
      onClose: onClose,
    ),
    select => RemixSelect<String>(
      trigger: const RemixSelectTrigger(placeholder: 'Open'),
      items: const [RemixSelectItem(value: 'item', label: 'Content')],
      style: SelectStyler().panelTransition(transition),
      onChanged: (_) {},
      onOpen: onOpen,
      onClose: onClose,
    ),
  };
}

Widget _fade(
  BuildContext context,
  RemixPanelTransitionInfo info,
  Widget panel,
) {
  expect(OverlayPlacement.maybeOf(context), isNotNull);
  return FadeTransition(opacity: info.animation, child: panel);
}

const _transition = RemixPanelTransition(duration: _duration, builder: _fade);

Future<void> _open(WidgetTester tester) async {
  await tester.tap(find.text('Open'));
  await tester.pump();
  await tester.pump();
}

Future<void> _escape(WidgetTester tester) async {
  await tester.sendKeyEvent(LogicalKeyboardKey.escape);
  await tester.pump();
}

double _progress(WidgetTester tester) =>
    effectiveOpacity(tester, find.text('Content'));

Future<void> _checkReopen(
  WidgetTester tester,
  _Overlay overlay, {
  bool control = false,
}) async {
  final events = <String>[];
  await tester.pumpRemixApp(
    overlay.build(
      transition: _transition,
      onOpen: () => events.add('open'),
      onClose: () => events.add('close'),
      control: control,
    ),
  );
  await _open(tester);
  await tester.pumpAndSettle();
  await _escape(tester);
  await tester.pump(_duration ~/ 2);
  expect(_progress(tester), closeTo(.5, .01));

  await _open(tester);
  expect(_progress(tester), closeTo(.5, .01));
  await tester.pump(_duration * 2);
  expect(_progress(tester), 1);
  expect(events, ['open']);

  await _escape(tester);
  await tester.pumpAndSettle();
  expect(find.text('Content'), findsNothing);
  expect(events, ['open', 'close']);
}

void main() {
  for (final overlay in _Overlay.values) {
    group(overlay.name, () {
      testWidgets('trigger toggle resumes a closing panel', (tester) async {
        await _checkReopen(tester, overlay);
      });

      for (final request in MotionRequest.values) {
        testWidgets('${request.name} settles both directions in flight', (
          tester,
        ) async {
          var closes = 0;
          final motion = await MotionHarness.pump(
            tester,
            overlay.build(transition: _transition, onClose: () => closes++),
          );

          await _open(tester);
          await tester.pump(_duration ~/ 2);
          expect(_progress(tester), closeTo(.5, .01));
          await motion.set(request, enabled: true);
          expect(_progress(tester), 1);

          await motion.set(request, enabled: false);
          await _escape(tester);
          await tester.pump(_duration ~/ 2);
          expect(_progress(tester), closeTo(.5, .01));
          await motion.set(request, enabled: true);
          await tester.pump();
          expect(find.text('Content'), findsNothing);
          expect(closes, 1);
        });
      }
    });
  }

  testWidgets('control menu toggle also resumes a closing panel', (tester) {
    return _checkReopen(tester, _Overlay.menu, control: true);
  });

  testWidgets('menu starts with the panel variant duration', (tester) async {
    await tester.pumpRemixApp(
      RemixMenu<String>(
        trigger: const RemixMenuTrigger(label: 'Open'),
        items: const [RemixMenuItem(value: 'item', label: 'Content')],
        style: MenuStyler().onBuilder(
          (context) => MenuStyler().panelTransition(
            RemixPanelTransition(
              duration: Duration(
                milliseconds: OverlayPlacement.maybeOf(context) == null
                    ? 100
                    : 800,
              ),
              builder: _fade,
            ),
          ),
        ),
      ),
    );
    await _open(tester);
    await tester.pump(const Duration(milliseconds: 200));
    expect(_progress(tester), closeTo(.25, .01));
    await tester.pumpAndSettle();
  });

  testWidgets('menu exit does not steal focus requested by the action', (
    tester,
  ) async {
    final outside = FocusNode();
    addTearDown(outside.dispose);
    await tester.pumpRemixApp(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(focusNode: outside),
          RemixMenu<String>(
            trigger: const RemixMenuTrigger(label: 'Open'),
            items: const [RemixMenuItem(value: 'item', label: 'Content')],
            style: MenuStyler().panelTransition(_transition),
            onSelected: (_) => outside.requestFocus(),
          ),
        ],
      ),
    );
    await _open(tester);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(outside.hasPrimaryFocus, isTrue);
    expect(find.text('Content'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(outside.hasPrimaryFocus, isTrue);
    expect(find.text('Content'), findsNothing);
  });

  for (final overlay in [_Overlay.menu, _Overlay.popover]) {
    testWidgets('${overlay.name} ignores a deferred show after disposal', (
      tester,
    ) async {
      late VoidCallback show;
      await tester.pumpRemixApp(
        overlay.build(
          transition: _transition,
          onOpenRequested: (_, showOverlay) => show = showOverlay,
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpWidget(const SizedBox());
      show();
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('controller reopen drops stale and duplicate close requests', (
    tester,
  ) async {
    final controller = MenuController();
    final requests = <VoidCallback>[];
    final events = <String>[];
    await tester.pumpRemixApp(
      _Overlay.menu.build(
        transition: _transition,
        controller: controller,
        onCloseRequested: requests.add,
        onOpen: () => events.add('open'),
        onClose: () => events.add('close'),
      ),
    );
    controller.open();
    await tester.pumpAndSettle();
    controller.close();
    controller.close();
    expect(requests, hasLength(1));
    requests.single();
    await tester.pump();
    await tester.pump(_duration ~/ 2);
    controller.open();
    expect(_progress(tester), closeTo(.5, .01));
    requests.single();
    await tester.pumpAndSettle();
    expect(_progress(tester), 1);
    expect(events, ['open']);

    controller.close();
    expect(requests, hasLength(2));
    requests.last();
    requests.last();
    await tester.pumpAndSettle();
    expect(events, ['open', 'close']);
    expect(find.text('Content'), findsNothing);
  });
}
