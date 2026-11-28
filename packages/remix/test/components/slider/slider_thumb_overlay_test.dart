import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:remix/src/rendering/remix_box_effects.dart'
    show RemixBoxAdapter;

final _seen = <RemixSliderThumbOverlayInfo>[];

Widget _bubble(BuildContext context, RemixSliderThumbOverlayInfo thumb) {
  _seen.add(thumb);
  return SizedBox(
    width: 30,
    height: 12,
    child: Text(
      'v${thumb.index}=${thumb.value.toStringAsFixed(2)}',
      textDirection: TextDirection.ltr,
      style: const TextStyle(fontSize: 6),
    ),
  );
}

final _style = SliderStyler()
    .thumb(BoxStyler().width(20).height(20))
    .thumbOverlay(_bubble);

final _thumb = find.byWidgetPredicate(
  (widget) =>
      widget is RemixBoxAdapter &&
      widget.styleSpec.spec.constraints?.maxWidth == 20,
);

Widget _host(Widget slider) => WidgetsApp(
  color: const Color(0xffffffff),
  builder: (context, _) => Directionality(
    textDirection: TextDirection.ltr,
    child: Center(child: SizedBox(width: 200, child: slider)),
  ),
);

void main() {
  setUp(_seen.clear);

  testWidgets('centers the overlay on the thumb and follows its value', (
    tester,
  ) async {
    var value = .25;
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, set) => _host(
          RemixSlider(
            value: value,
            enableFeedback: false,
            onChanged: (next) => set(() => value = next),
            style: _style,
          ),
        ),
      ),
    );

    final bubble = find.text('v0=0.25');
    expect(tester.getSize(bubble), const Size(30, 12));
    expect(tester.getCenter(bubble), tester.getCenter(_thumb));

    final gesture = await tester.startGesture(tester.getCenter(_thumb));
    await tester.pump();
    expect(_seen.last.states, contains(WidgetState.pressed));
    await gesture.moveBy(const Offset(36, 0));
    await tester.pump();

    final moved = find.text('v0=${value.toStringAsFixed(2)}');
    expect(value, closeTo(.45, .001));
    expect(tester.getCenter(moved), tester.getCenter(_thumb));
    await gesture.up();
    await tester.pump();
    expect(_seen.last.states, isNot(contains(WidgetState.pressed)));
  });

  testWidgets('builds one overlay per range thumb', (tester) async {
    await tester.pumpWidget(
      _host(
        RemixRangeSlider(
          values: const [.2, .7],
          onChanged: (_) {},
          semanticLabels: const ['Low', 'High'],
          style: _style,
        ),
      ),
    );

    expect(find.text('v0=0.20'), findsOneWidget);
    expect(find.text('v1=0.70'), findsOneWidget);
  });

  testWidgets('the overlay is hidden from semantics', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(RemixSlider(value: .5, onChanged: (_) {}, style: _style)),
    );

    expect(find.text('v0=0.50'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('v0=')), findsNothing);
    handle.dispose();
  });

  testWidgets('without an overlay the thumb draws alone', (tester) async {
    await tester.pumpWidget(
      _host(
        RemixSlider(
          value: .5,
          onChanged: (_) {},
          style: SliderStyler().thumb(BoxStyler().width(20).height(20)),
        ),
      ),
    );

    expect(find.byType(OverflowBox), findsNothing);
    expect(_seen, isEmpty);
  });
}
