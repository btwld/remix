import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/vanilla.dart';
import 'package:remix/remix.dart';
// RemixBoxAdapter is @internal. The ring is painted there, and the resolved
// spec is not otherwise reachable from these widgets.
import 'package:remix/src/rendering/remix_box_effects.dart';

/// Click-focus and Tab coverage for the Vanilla focus-ring contract.
///
/// Text fields ring on any focus. Buttons and sliders ring only while
/// [FocusVisibility] is showing, so a mouse click hides the ring until Tab.
void main() {
  const desktop = TargetPlatformVariant({TargetPlatform.macOS});

  testWidgets('a click and Tab both ring a text field', (tester) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    await _pump(
      tester,
      SizedBox(width: 240, child: VanillaTextField(focusNode: focusNode)),
    );

    expect(_ringWidth(tester), 0);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(focusNode.hasFocus, isTrue);
    expect(_ringWidth(tester), 3);

    await _click(tester, find.byType(VanillaTextField));
    expect(focusNode.hasFocus, isTrue);
    expect(_ringWidth(tester), 3);
  }, variant: desktop);

  testWidgets('a click and Tab both ring a text area', (tester) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    await _pump(
      tester,
      SizedBox(width: 240, child: VanillaTextArea(focusNode: focusNode)),
    );

    expect(_ringWidth(tester), 0);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(focusNode.hasFocus, isTrue);
    expect(_ringWidth(tester), 3);

    await _click(tester, find.byType(VanillaTextArea));
    expect(focusNode.hasFocus, isTrue);
    expect(_ringWidth(tester), 3);
  }, variant: desktop);

  testWidgets('a click does not ring a button; Tab does', (tester) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    await _pump(
      tester,
      VanillaButton(label: 'Save', onPressed: () {}, focusNode: focusNode),
    );

    expect(_ringWidth(tester), 0);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(focusNode.hasFocus, isTrue);
    expect(_ringWidth(tester), 3);

    await _click(tester, find.byType(VanillaButton));
    expect(focusNode.hasFocus, isTrue);
    expect(_ringWidth(tester), 0);
  }, variant: desktop);

  testWidgets('a click does not ring a slider thumb; Tab does', (tester) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    await _pump(
      tester,
      SizedBox(
        width: 240,
        child: VanillaSlider(
          value: 0.4,
          onChanged: (_) {},
          focusNode: focusNode,
        ),
      ),
    );

    expect(_ringWidth(tester), 0);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(focusNode.hasFocus, isTrue);
    expect(_ringWidth(tester), 4);

    await _click(tester, find.byType(VanillaSlider));
    expect(focusNode.hasFocus, isTrue);
    expect(_ringWidth(tester), 0);
  }, variant: desktop);
}

Future<void> _pump(WidgetTester tester, Widget child) {
  return tester.pumpWidget(
    WidgetsApp(
      color: const Color(0xFFFFFFFF),
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, _, _) => builder(context),
      ),
      builder: (context, navigator) => VanillaTheme(child: navigator!),
      home: Center(child: child),
    ),
  );
}

Future<void> _click(WidgetTester tester, Finder finder) async {
  final gesture = await tester.startGesture(
    tester.getCenter(finder),
    kind: PointerDeviceKind.mouse,
  );
  await tester.pump();
  await gesture.up();
  await tester.pump();
  // Leave the control so a hover ring is not read as a focus ring.
  await gesture.moveTo(const Offset(2, 2));
  await tester.pumpAndSettle();
}

double _ringWidth(WidgetTester tester) {
  // ignore: invalid_use_of_internal_member
  final finder = find.byType(RemixBoxAdapter);
  // ignore: invalid_use_of_internal_member
  final adapters = tester.widgetList<RemixBoxAdapter>(finder);
  var width = 0.0;
  for (final adapter in adapters) {
    final outline = adapter.containerEffects?.outline.width ?? 0;
    if (outline > width) width = outline;
  }
  return width;
}
