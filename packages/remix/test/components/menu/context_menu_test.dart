import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

const _targetKey = Key('target');
const _panelColor = Color(0xFF123456);

RemixPanelTransitionInfo? _lastInfo;

final _recordingTransition = RemixPanelTransition(
  duration: const Duration(milliseconds: 200),
  builder: (context, info, panel) {
    _lastInfo = info;
    return panel;
  },
);

RemixContextMenu<String> _menu({
  List<String>? log,
  MenuStyler? style,
  OverlayPositionConfig? positioning,
}) {
  return RemixContextMenu<String>(
    items: const [
      RemixMenuItem(value: 'copy', label: 'Copy'),
      RemixMenuItem(value: 'delete', label: 'Delete'),
    ],
    onSelected: (value) => log?.add('selected:$value'),
    onCanceled: () => log?.add('canceled'),
    positioning: positioning,
    style: style ?? MenuStyler().overlay(FlexBoxStyler().color(_panelColor)),
    child: const SizedBox(key: _targetKey, width: 400, height: 300),
  );
}

Future<void> _rightClickAt(WidgetTester tester, Offset position) async {
  final gesture = await tester.startGesture(
    position,
    kind: PointerDeviceKind.mouse,
    buttons: kSecondaryButton,
  );
  await gesture.up();
  await tester.pump();
}

Offset _targetPoint(WidgetTester tester, Offset local) =>
    tester.getTopLeft(find.byKey(_targetKey)) + local;

Finder get _panel => find.byWidgetPredicate(
  (widget) =>
      widget is Container &&
      widget.decoration is BoxDecoration &&
      (widget.decoration! as BoxDecoration).color == _panelColor,
);

void main() {
  setUp(() => _lastInfo = null);

  testWidgets('opens the styled panel at the pointer and selects', (
    tester,
  ) async {
    final log = <String>[];
    await tester.pumpRemixApp(_menu(log: log));
    final point = _targetPoint(tester, const Offset(60, 40));

    await _rightClickAt(tester, point);
    await tester.pumpAndSettle();

    expect(find.text('Copy'), findsOneWidget);
    expect(tester.getTopLeft(_panel), point);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(find.text('Copy'), findsNothing);
    expect(log, ['selected:delete']);
  });

  testWidgets('the style positioning places the panel against the point', (
    tester,
  ) async {
    await tester.pumpRemixApp(
      _menu(
        style: MenuStyler()
            .overlay(FlexBoxStyler().color(_panelColor))
            .positioning(const OverlayPositionConfig(sideOffset: 6)),
      ),
    );
    final point = _targetPoint(tester, const Offset(60, 40));

    await _rightClickAt(tester, point);
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(_panel), point + const Offset(0, 6));
  });

  testWidgets('the panel transition receives the open point', (tester) async {
    await tester.pumpRemixApp(
      _menu(
        style: MenuStyler()
            .overlay(FlexBoxStyler().color(_panelColor))
            .panelTransition(_recordingTransition),
      ),
    );
    final point = _targetPoint(tester, const Offset(60, 40));

    await _rightClickAt(tester, point);
    await tester.pump();

    expect(_lastInfo!.openPosition, point);
    expect(_lastInfo!.anchorRect, tester.getRect(find.byKey(_targetKey)));
  });

  testWidgets('moving to a new point replays the open transition', (
    tester,
  ) async {
    await tester.pumpRemixApp(
      _menu(
        style: MenuStyler()
            .overlay(FlexBoxStyler().color(_panelColor))
            .panelTransition(_recordingTransition),
      ),
    );
    await _rightClickAt(tester, _targetPoint(tester, const Offset(60, 40)));
    await tester.pumpAndSettle();
    expect(_lastInfo!.animation.value, 1);

    final next = _targetPoint(tester, const Offset(200, 150));
    await _rightClickAt(tester, next);
    await tester.pump(const Duration(milliseconds: 50));

    expect(_lastInfo!.openPosition, next);
    expect(_lastInfo!.animation.value, closeTo(.25, .01));
    expect(tester.getTopLeft(_panel), next);
  });

  testWidgets('a move during the exit reopens at the new point', (
    tester,
  ) async {
    await tester.pumpRemixApp(
      _menu(
        style: MenuStyler()
            .overlay(FlexBoxStyler().color(_panelColor))
            .panelTransition(_recordingTransition),
      ),
    );
    await _rightClickAt(tester, _targetPoint(tester, const Offset(60, 40)));
    await tester.pumpAndSettle();

    await tester.tapAt(const Offset(780, 580));
    await tester.pump(const Duration(milliseconds: 50));
    expect(_lastInfo!.animation.status, AnimationStatus.reverse);

    final next = _targetPoint(tester, const Offset(200, 150));
    await _rightClickAt(tester, next);
    await tester.pumpAndSettle();

    expect(_lastInfo!.animation.value, 1);
    expect(tester.getTopLeft(_panel), next);
    expect(find.text('Copy'), findsOneWidget);
  });

  testWidgets('semantics: the target opens the menu with long press', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpRemixApp(_menu());

    final target = tester.getSemantics(find.byKey(_targetKey));
    expect(
      target.getSemanticsData().hasAction(SemanticsAction.longPress),
      isTrue,
    );
    target.owner!.performAction(target.id, SemanticsAction.longPress);
    await tester.pumpAndSettle();

    expect(tester.getSemantics(find.text('Copy')).role, SemanticsRole.menuItem);
    expect(
      tester.getTopLeft(_panel),
      tester.getBottomLeft(find.byKey(_targetKey)),
    );
    handle.dispose();
  });
}
