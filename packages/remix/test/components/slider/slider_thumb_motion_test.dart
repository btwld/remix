import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:remix/src/rendering/remix_box_effects.dart'
    show RemixBoxAdapter;

const _linear = CurveAnimationConfig(
  duration: Duration(milliseconds: 100),
  curve: Curves.linear,
);

final _thumb = find.byWidgetPredicate(
  (widget) =>
      widget is RemixBoxAdapter &&
      widget.styleSpec.spec.constraints?.maxWidth == 20,
);

SliderStyler _style([AnimationConfig? motion]) {
  final style = SliderStyler().thumb(BoxStyler().width(20).height(20));
  return motion == null ? style : style.thumbMotion(motion);
}

/// The rail spans 180px: the 200px slider less a half thumb at each end.
Widget _host(
  double value, {
  SliderStyler? style,
  ValueChanged<double>? onChanged,
  FocusNode? focusNode,
  bool disableAnimations = false,
}) => WidgetsApp(
  color: const Color(0xffffffff),
  builder: (context, _) => MediaQuery(
    data: MediaQuery.of(context).copyWith(disableAnimations: disableAnimations),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: 200,
          child: RemixSlider(
            value: value,
            enableFeedback: false,
            focusNode: focusNode,
            onChanged: onChanged ?? (_) {},
            style: style ?? _style(_linear),
          ),
        ),
      ),
    ),
  ),
);

double _x(WidgetTester tester) => tester.getCenter(_thumb).dx;

void main() {
  group('SliderSpec.thumbMotion', () {
    testWidgets('moves the thumb to a value the app sets', (tester) async {
      await tester.pumpWidget(_host(.2));
      final from = _x(tester);
      await tester.pumpWidget(_host(.8));
      final to = from + .6 * 180;

      expect(_x(tester), closeTo(from, .01));
      await tester.pump(const Duration(milliseconds: 50));
      expect(_x(tester), closeTo((from + to) / 2, .5));
      await tester.pumpAndSettle();
      expect(_x(tester), closeTo(to, .01));
    });

    testWidgets('moves the thumb on a key press', (tester) async {
      var value = .5;
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, set) => _host(
            value,
            focusNode: focusNode,
            onChanged: (next) => set(() => value = next),
          ),
        ),
      );
      final from = _x(tester);
      focusNode.requestFocus();
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();

      expect(value, greaterThan(.5));
      expect(_x(tester), closeTo(from, .01));
      await tester.pumpAndSettle();
      expect(_x(tester), closeTo(from + (value - .5) * 180, .01));
    });

    testWidgets('a dragged thumb follows the pointer', (tester) async {
      var value = .25;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, set) =>
              _host(value, onChanged: (next) => set(() => value = next)),
        ),
      );
      final before = tester.getCenter(_thumb);
      final gesture = await tester.startGesture(before);
      await tester.pump();
      await gesture.moveBy(const Offset(36, 0));
      await tester.pump();

      expect(_x(tester), closeTo(before.dx + 36, .01));
      await gesture.up();
      await tester.pump();
    });

    testWidgets('a press on the track moves the thumb there', (tester) async {
      var value = .2;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, set) =>
              _host(value, onChanged: (next) => set(() => value = next)),
        ),
      );
      final from = tester.getCenter(_thumb);
      final gesture = await tester.startGesture(from + const Offset(108, 0));
      await tester.pump();

      expect(value, closeTo(.8, .01));
      expect(_x(tester), closeTo(from.dx, .01));
      await tester.pumpAndSettle();
      expect(_x(tester), closeTo(from.dx + 108, .5));
      await gesture.up();
      await tester.pump();
    });

    testWidgets('jumps under reduced motion', (tester) async {
      await tester.pumpWidget(_host(.2, disableAnimations: true));
      final from = _x(tester);
      await tester.pumpWidget(_host(.8, disableAnimations: true));

      expect(_x(tester), closeTo(from + .6 * 180, .01));
    });

    testWidgets('without a motion the thumb jumps', (tester) async {
      await tester.pumpWidget(_host(.2, style: _style()));
      final from = _x(tester);
      await tester.pumpWidget(_host(.8, style: _style()));

      expect(_x(tester), closeTo(from + .6 * 180, .01));
    });

    testWidgets('a spring settles on the new value', (tester) async {
      final spring = _style(
        AnimationConfig.springDescription(mass: 1, stiffness: 400, damping: 30),
      );
      await tester.pumpWidget(_host(.2, style: spring));
      final from = _x(tester);
      await tester.pumpWidget(_host(.8, style: spring));
      await tester.pump(const Duration(milliseconds: 16));

      expect(_x(tester), allOf(greaterThan(from), lessThan(from + 108)));
      await tester.pumpAndSettle();
      expect(_x(tester), closeTo(from + 108, .01));
    });
  });

  testWidgets('the range bar follows the moving thumbs', (tester) async {
    Widget range(List<double> values) => WidgetsApp(
      color: const Color(0xffffffff),
      builder: (context, _) => Directionality(
        textDirection: TextDirection.ltr,
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 200,
            child: RemixRangeSlider(
              values: values,
              onChanged: (_) {},
              semanticLabels: const ['Low', 'High'],
              style: _style(_linear).rangeColor(const Color(0xff00ff00)),
            ),
          ),
        ),
      ),
    );
    final bar = find.byWidgetPredicate(
      (widget) =>
          widget is RemixBoxAdapter &&
          (widget.styleSpec.spec.decoration as BoxDecoration?)?.color ==
              const Color(0xff00ff00),
    );

    await tester.pumpWidget(range(const [.2, .4]));
    final width = tester.getSize(bar).width;
    await tester.pumpWidget(range(const [.2, .8]));
    expect(tester.getSize(bar).width, closeTo(width, .01));
    await tester.pumpAndSettle();
    expect(tester.getSize(bar).width, closeTo(width * 3, .01));
  });
}
