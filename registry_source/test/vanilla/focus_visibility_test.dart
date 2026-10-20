import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:registry_source/vanilla.dart';
import 'package:remix/remix.dart';
// RemixBoxAdapter is @internal. The ring is painted there, and the resolved
// spec is not otherwise reachable from these widgets.
import 'package:remix/src/rendering/remix_box_effects.dart';

/// Click-focus and Tab coverage for the focus-ring contract.
///
/// Text fields ring on any focus. Buttons and sliders ring only while
/// [FocusVisibility] is showing, so a mouse click hides the ring until Tab.
void main() {
  const desktop = TargetPlatformVariant({TargetPlatform.macOS});
  final errorRingColor = const VanillaThemeData.light().destructive.withValues(
    alpha: 0.2,
  );

  final cases =
      <
        ({
          String name,
          Widget Function(Widget child) theme,
          Widget Function(FocusNode focusNode) build,
          Type target,
          double tabRing,
          double clickRing,
          Color? ringColor,
        })
      >[
        (
          name: 'VanillaTextField',
          theme: (child) => VanillaTheme(child: child),
          build: (focusNode) => SizedBox(
            width: 240,
            child: VanillaTextField(focusNode: focusNode),
          ),
          target: VanillaTextField,
          tabRing: 3,
          clickRing: 3,
          ringColor: null,
        ),
        (
          name: 'VanillaTextField with error',
          theme: (child) => VanillaTheme(child: child),
          build: (focusNode) => SizedBox(
            width: 240,
            child: VanillaTextField(focusNode: focusNode, error: true),
          ),
          target: VanillaTextField,
          tabRing: 3,
          clickRing: 3,
          ringColor: errorRingColor,
        ),
        (
          name: 'VanillaTextArea',
          theme: (child) => VanillaTheme(child: child),
          build: (focusNode) => SizedBox(
            width: 240,
            child: VanillaTextArea(focusNode: focusNode),
          ),
          target: VanillaTextArea,
          tabRing: 3,
          clickRing: 3,
          ringColor: null,
        ),
        (
          name: 'VanillaButton',
          theme: (child) => VanillaTheme(child: child),
          build: (focusNode) => VanillaButton(
            label: 'Save',
            onPressed: () {},
            focusNode: focusNode,
          ),
          target: VanillaButton,
          tabRing: 3,
          clickRing: 0,
          ringColor: null,
        ),
        (
          name: 'VanillaSlider',
          theme: (child) => VanillaTheme(child: child),
          build: (focusNode) => SizedBox(
            width: 240,
            child: VanillaSlider(
              value: 0.4,
              onChanged: (_) {},
              focusNode: focusNode,
            ),
          ),
          target: VanillaSlider,
          tabRing: 4,
          clickRing: 0,
          ringColor: null,
        ),
        (
          name: 'FortalTextField',
          theme: (child) => FortalTheme(child: child),
          build: (focusNode) => SizedBox(
            width: 240,
            child: FortalTextField(focusNode: focusNode),
          ),
          target: FortalTextField,
          tabRing: 2,
          clickRing: 2,
          ringColor: null,
        ),
        (
          name: 'FortalButton',
          theme: (child) => FortalTheme(child: child),
          build: (focusNode) => FortalButton(
            label: 'Save',
            onPressed: () {},
            focusNode: focusNode,
          ),
          target: FortalButton,
          tabRing: 2,
          clickRing: 0,
          ringColor: null,
        ),
      ];

  for (final c in cases) {
    testWidgets(
      '${c.name}: click ${c.clickRing > 0 ? 'rings (${c.clickRing}px)' : 'hides ring'}, Tab rings (${c.tabRing}px)',
      (tester) async {
        final focusNode = FocusNode();
        addTearDown(focusNode.dispose);
        await _pump(tester, c.theme, c.build(focusNode));

        expect(_ringWidth(tester), 0);

        await _click(tester, find.byType(c.target));
        expect(focusNode.hasFocus, isTrue);
        expect(_ringWidth(tester), c.clickRing);
        if (c.ringColor != null && c.clickRing > 0) {
          expect(_ringOutline(tester)?.color, c.ringColor);
        }

        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();
        expect(focusNode.hasFocus, isTrue);
        expect(_ringWidth(tester), c.tabRing);
        if (c.ringColor != null) {
          expect(_ringOutline(tester)?.color, c.ringColor);
        }

        await _click(tester, find.byType(c.target));
        expect(focusNode.hasFocus, isTrue);
        expect(_ringWidth(tester), c.clickRing);
      },
      variant: desktop,
    );
  }
}

Future<void> _pump(
  WidgetTester tester,
  Widget Function(Widget child) theme,
  Widget child,
) {
  return tester.pumpWidget(
    WidgetsApp(
      color: const Color(0xFFFFFFFF),
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, _, _) => builder(context),
      ),
      builder: (context, navigator) => theme(navigator!),
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
  await gesture.moveTo(const Offset(2, 2));
  await tester.pumpAndSettle();
}

BorderSide? _ringOutline(WidgetTester tester) {
  // ignore: invalid_use_of_internal_member
  final finder = find.byType(RemixBoxAdapter);
  // ignore: invalid_use_of_internal_member
  final adapters = tester.widgetList<RemixBoxAdapter>(finder);
  BorderSide? widest;
  for (final adapter in adapters) {
    final outline = adapter.containerEffects?.outline;
    if (outline != null && outline.width > (widest?.width ?? 0)) {
      widest = outline;
    }
  }
  return widest;
}

double _ringWidth(WidgetTester tester) => _ringOutline(tester)?.width ?? 0;
