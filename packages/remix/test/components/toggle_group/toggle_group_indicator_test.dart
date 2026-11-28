import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';
import 'package:remix/remix.dart';

import '../../helpers/indicator_probe.dart';
import '../../helpers/motion_harness.dart';
import '../../helpers/test_helpers.dart';

final _boundary = GlobalKey();
final _indicator = find.byKey(const ValueKey('remix-selection-indicator'));

const _linear = CurveAnimationConfig(
  duration: Duration(milliseconds: 200),
  curve: Curves.linear,
);

Widget _control(
  ValueNotifier<String?> selected, {
  bool withIndicator = true,
  AnimationConfig? motion = _linear,
}) {
  var style = ToggleGroupStyler().container(FlexBoxStyler().spacing(4));
  if (withIndicator) {
    style = style.indicator(BoxStyler().color(indicatorGreen));
    if (motion != null) style = style.indicatorMotion(motion);
  }
  return RepaintBoundary(
    key: _boundary,
    child: SizedBox(
      width: 400,
      height: 100,
      child: Align(
        alignment: Alignment.topLeft,
        child: ValueListenableBuilder<String?>(
          valueListenable: selected,
          builder: (context, value, _) => RemixToggleGroup<String>(
            selectedValue: value,
            onChanged: (next) => selected.value = next,
            style: style,
            items: const [
              RemixToggleGroupItem(value: 'a', label: 'Alpha'),
              RemixToggleGroupItem(value: 'b', label: 'Beta'),
              RemixToggleGroupItem(value: 'c', label: 'Gamma'),
            ],
          ),
        ),
      ),
    ),
  );
}

Rect _item(WidgetTester tester, String label) => tester.getRect(
  find
      .ancestor(
        of: find.text(label),
        matching: find.byType(NakedToggleOption<String>),
      )
      .first,
);

void main() {
  late ValueNotifier<String?> selected;

  setUp(() => selected = ValueNotifier('a'));
  tearDown(() => selected.dispose());

  testWidgets('builds no indicator by default', (tester) async {
    await tester.pumpRemixApp(_control(selected, withIndicator: false));
    expect(_indicator, findsNothing);
    expect(await paintedRect(tester, _boundary), isNull);
  });

  testWidgets('sits on the selected item', (tester) async {
    await tester.pumpRemixApp(_control(selected));
    expectRectNear(
      await paintedRect(tester, _boundary),
      _item(tester, 'Alpha'),
    );
  });

  testWidgets('glides to the next item along indicatorMotion', (tester) async {
    await tester.pumpRemixApp(_control(selected));
    final from = _item(tester, 'Alpha');
    final to = _item(tester, 'Gamma');

    await tester.tap(find.text('Gamma'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expectRectNear(
      await paintedRect(tester, _boundary),
      Rect.lerp(from, to, .5)!,
    );

    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump();
    expect(selected.value, 'c');
    expectRectNear(await paintedRect(tester, _boundary), to);
  });

  testWidgets('draws nothing without a selection', (tester) async {
    selected.value = null;
    await tester.pumpRemixApp(_control(selected));
    expect(await paintedRect(tester, _boundary), isNull);
  });

  testWidgets('jumps when the user asks to reduce motion', (tester) async {
    final harness = await MotionHarness.pump(tester, _control(selected));
    await harness.set(MotionRequest.mediaQuery, enabled: true);

    await tester.tap(find.text('Beta'));
    await tester.pump();
    expectRectNear(await paintedRect(tester, _boundary), _item(tester, 'Beta'));
  });

  testWidgets('rejects a phase motion when it builds', (tester) async {
    await tester.pumpWidget(
      MixScope.empty(
        child: MaterialApp(
          home: _control(
            selected,
            motion: PhaseAnimationConfig<BoxSpec, BoxStyler>(
              styles: [BoxStyler(), BoxStyler().color(indicatorGreen)],
              curveConfigs: const [_linear],
              trigger: null,
            ),
          ),
        ),
      ),
      phase: EnginePhase.build,
    );
    expect(
      tester.takeException(),
      isA<ArgumentError>().having((e) => e.name, 'name', 'indicatorMotion'),
    );
  });
}
