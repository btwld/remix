import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/deui.dart';
import 'package:remix/remix.dart';

/// The tab's effective opacity: the product of the opacities above its
/// label, which is 1 when the tab has no opacity modifier.
double _opacity(WidgetTester tester) {
  var value = 1.0;
  final label = find.text('Beta').evaluate().single;
  label.visitAncestorElements((element) {
    final widget = element.widget;
    if (widget is Opacity) value *= widget.opacity;
    if (widget is FadeTransition) value *= widget.opacity.value;
    return true;
  });
  return value;
}

void main() {
  testWidgets('tab hover fades on its own 150 ms, not the 470 ms glide', (
    tester,
  ) async {
    await tester.pumpWidget(
      DeuiTheme(
        child: WidgetsApp(
          color: const Color(0xFFFFFFFF),
          pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
            settings: settings,
            pageBuilder: (context, _, _) => builder(context),
          ),
          builder: (context, _) => Directionality(
            textDirection: TextDirection.ltr,
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) => Align(
                    alignment: Alignment.topLeft,
                    child: RemixTabs(
                      selectedTabId: 'a',
                      onChanged: (_) {},
                      child: const DeuiTabBar(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DeuiTab(tabId: 'a', label: 'Alpha'),
                            DeuiTab(tabId: 'b', label: 'Beta'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(_opacity(tester), 1);

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.text('Beta')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 160));
    // Hover-in finished within 150 ms (the glide would still be running).
    expect(_opacity(tester), closeTo(.7, .01));

    await mouse.moveTo(const Offset(700, 500));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 75));
    final mid = _opacity(tester);
    expect(mid, greaterThan(.7));
    expect(mid, lessThan(1));
    await tester.pump(const Duration(milliseconds: 90));
    // Hover-out is done at 165 ms; a 470 ms glide would not be.
    expect(_opacity(tester), closeTo(1, .01));
  });
}
