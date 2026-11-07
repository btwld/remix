import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';
import 'package:remix/remix.dart';
import 'package:remix/src/rendering/remix_box_effects.dart'
    show RemixBoxAdapter;
import '../../../example/api/range_slider.0.dart' as example;

const red = Color(0xffff0000),
    blue = Color(0xff0000ff),
    green = Color(0xff00ff00);
Widget host(Widget child, {TextDirection direction = TextDirection.ltr}) =>
    WidgetsApp(
      color: const Color(0xffffffff),
      builder: (context, _) => Directionality(
        textDirection: direction,
        child: Center(child: SizedBox(width: 240, child: child)),
      ),
    );
Finder thumb(int i) => find.descendant(
  of: find.byKey(ValueKey<int>(i)),
  matching: find.byType(RemixBoxAdapter),
);
Finder thumbs() => find.byWidgetPredicate(
  (w) =>
      w is RemixBoxAdapter &&
      w.styleSpec.spec.constraints?.hasBoundedWidth == true,
);
Color? color(WidgetTester tester, int index) =>
    (tester
                .widget<RemixBoxAdapter>(thumbs().at(index))
                .styleSpec
                .spec
                .decoration
            as BoxDecoration?)
        ?.color;
void action(WidgetTester t, String label, ui.SemanticsAction a) =>
    t.binding.performSemanticsAction(
      ui.SemanticsActionEvent(
        type: a,
        viewId: t.view.viewId,
        nodeId: t.getSemantics(find.bySemanticsLabel(label)).id,
      ),
    );
void main() {
  testWidgets('public example runs in a widgets-only host', (t) async {
    await t.pumpWidget(host(const example.RangeSliderExample()));
    expect(find.byType(RemixRangeSlider), findsOneWidget);
    expect(t.takeException(), isNull);
  });
  testWidgets(
    'minimal range has bounded default thumbs and one interaction owner',
    (t) async {
      final requests = <List<double>>[];
      await t.pumpWidget(
        host(
          RemixRangeSlider(values: const [.25, .75], onChanged: requests.add),
        ),
      );
      expect(thumbs(), findsNWidgets(2));
      for (final e in thumbs().evaluate())
        expect(t.getSize(find.byWidget(e.widget)), const Size(16, 16));
      expect(t.getSize(find.byType(RemixRangeSlider)).height, 48);
      expect(find.byType(NakedSlider), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
      final hit = t.getRect(find.byType(RemixRangeSlider));
      await t.tapAt(Offset(hit.center.dx, hit.top + 1));
      await t.pump();
      expect(requests, [
        [.5, .75],
      ]);
    },
  );
  testWidgets(
    'both thumbs share rail geometry across padded sizes raw specs and RTL',
    (t) async {
      for (final direction in TextDirection.values)
        for (final raw in [false, true])
          for (final shape in [
            const Size(8, 8),
            const Size(64, 64),
            const Size(32, 12),
          ]) {
            for (final thickness in [4.0, 72.0]) {
              final changes = <List<double>>[];
              final style = SliderStyler()
                  .thumb(
                    BoxStyler()
                        .width(shape.width)
                        .height(shape.height)
                        .padding(.symmetric(horizontal: 6, vertical: 4)),
                  )
                  .thickness(thickness);
              final spec = raw
                  ? SliderSpec(
                      thumb: StyleSpec(
                        spec: BoxSpec(
                          constraints: BoxConstraints.tight(shape),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 4,
                          ),
                        ),
                      ),
                      trackWidth: thickness,
                      rangeWidth: thickness,
                    )
                  : null;
              await t.pumpWidget(
                host(
                  RemixRangeSlider(
                    values: const [0, 1],
                    onChanged: changes.add,
                    style: style,
                    styleSpec: spec,
                  ),
                  direction: direction,
                ),
              );
              final rail = t.getRect(find.byType(NakedSliderTrack));
              final rects =
                  thumbs()
                      .evaluate()
                      .map((e) => t.getRect(find.byWidget(e.widget)))
                      .toList()
                    ..sort((a, b) => a.left.compareTo(b.left));
              expect(rects.first.center.dx, closeTo(rail.left, .001));
              expect(rects.last.center.dx, closeTo(rail.right, .001));
              for (final rect in rects) {
                await t.tapAt(rect.center);
                await t.pump();
              }
              expect(changes, isEmpty);
              expect(
                t.getSize(find.byType(RemixRangeSlider)).height,
                greaterThanOrEqualTo(48),
              );
            }
          }
    },
  );
  testWidgets(
    'rejected pointer requests retain visuals semantics and captured end callback',
    (t) async {
      final handle = t.ensureSemantics();
      final changes = <List<double>>[],
          ends = <List<double>>[],
          starts = <List<double>>[];
      await t.pumpWidget(
        host(
          RemixRangeSlider(
            values: const [.25, .75],
            onChanged: changes.add,
            onChangeStart: starts.add,
            onChangeEnd: ends.add,
            semanticLabels: const ['Lower', 'Upper'],
            style: SliderStyler().thumbSize(const Size(20, 20)),
          ),
        ),
      );
      final before = t.getCenter(thumb(0));
      final gesture = await t.startGesture(before);
      await gesture.moveBy(const Offset(44, 0));
      await t.pump();
      expect(changes.last, [.45, .75]);
      expect(t.getCenter(thumb(0)), before);
      expect(t.getSemantics(find.bySemanticsLabel('Lower')).value, '25%');
      await gesture.cancel();
      await t.pump();
      expect(starts, [
        [.25, .75],
      ]);
      expect(ends, [changes.last]);
      expect(() => changes.last[0] = 0, throwsUnsupportedError);
      handle.dispose();
    },
  );
  testWidgets(
    'semantic actions keyboard spacing and exclusion preserve thumb ownership',
    (t) async {
      final handle = t.ensureSemantics();
      final focus = [FocusNode(), FocusNode()];
      var values = <double>[.4, .6];
      final starts = <List<double>>[], ends = <List<double>>[];
      var exclude = false;
      late StateSetter rebuild;
      await t.pumpWidget(
        host(
          StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return RemixRangeSlider(
                values: values,
                focusNodes: focus,
                minSpacing: .1,
                snapDivisions: 10,
                excludeSemantics: exclude,
                semanticLabels: const ['Minimum price', 'Maximum price'],
                semanticFormatterCallbacks: [(v) => 'From $v', (v) => 'To $v'],
                onChanged: (next) => setState(() => values = next),
                onChangeStart: starts.add,
                onChangeEnd: ends.add,
                style: SliderStyler().thumbSize(const Size(20, 20)),
              );
            },
          ),
        ),
      );
      action(t, 'Minimum price', ui.SemanticsAction.focus);
      await t.pump();
      expect(focus[0].hasPrimaryFocus, isTrue);
      action(t, 'Minimum price', ui.SemanticsAction.decrease);
      await t.pump();
      expect(values[0], closeTo(.3, .00001));
      expect(values[1], .6);
      action(t, 'Maximum price', ui.SemanticsAction.increase);
      await t.pump();
      expect(values[0], closeTo(.3, .00001));
      expect(values[1], closeTo(.7, .00001));
      await t.sendKeyEvent(LogicalKeyboardKey.end);
      await t.pump();
      expect(values[0], closeTo(.6, .0001));
      expect(values[1], closeTo(.7, .00001));
      expect(starts, isEmpty);
      expect(ends, isEmpty);
      rebuild(() => exclude = true);
      await t.pump();
      expect(find.bySemanticsLabel('Minimum price'), findsNothing);
      await t.sendKeyEvent(LogicalKeyboardKey.home);
      await t.pump();
      expect(values[0], 0);
      expect(values[1], closeTo(.7, .00001));
      handle.dispose();
      await t.pumpWidget(const SizedBox());
      for (final n in focus) n.dispose();
    },
  );
  testWidgets(
    'state-dependent thumb sizes use one common rail and per-thumb variants',
    (t) async {
      final focus = [FocusNode(), FocusNode()];
      late StateSetter rebuild;
      var raw = false, enabled = true, dark = false;
      final style = SliderStyler()
          .thumbSize(const Size(20, 20))
          .thumbColor(red)
          .onFocused(
            SliderStyler().thumbSize(const Size(36, 28)).thumbColor(green),
          )
          .onPressed(SliderStyler().thumbColor(blue));
      await t.pumpWidget(
        host(
          StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return MediaQuery(
                data: MediaQueryData(
                  platformBrightness: dark ? Brightness.dark : Brightness.light,
                ),
                child: StyleProvider<SliderSpec>(
                  style: SliderStyler().onDark(SliderStyler().thickness(12)),
                  child: RemixRangeSlider(
                    values: const [0, 1],
                    focusNodes: focus,
                    enabled: enabled,
                    onChanged: (_) {},
                    style: style,
                    styleSpec: raw
                        ? SliderSpec(
                            thumb: StyleSpec(
                              spec: BoxSpec(
                                constraints: BoxConstraints.tight(
                                  const Size(10, 10),
                                ),
                                decoration: const BoxDecoration(color: blue),
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
              );
            },
          ),
        ),
      );
      focus[0].requestFocus();
      await t.pumpAndSettle();
      final adapters = t.widgetList<RemixBoxAdapter>(thumbs()).toList();
      expect(
        adapters.where(
          (w) => (w.styleSpec.spec.decoration as BoxDecoration).color == green,
        ),
        hasLength(1),
      );
      final rail = t.getRect(find.byType(NakedSliderTrack));
      final centers =
          thumbs()
              .evaluate()
              .map((e) => t.getCenter(find.byWidget(e.widget)).dx)
              .toList()
            ..sort();
      expect(centers, [rail.left, rail.right]);
      rebuild(() => dark = true);
      await t.pumpAndSettle();
      expect(t.getSize(find.byType(RemixRangeSlider)).height, 48);
      expect(
        t
            .widgetList<RemixBoxAdapter>(find.byType(RemixBoxAdapter))
            .where(
              (w) =>
                  w.styleSpec.spec.constraints?.maxHeight == 12 &&
                  w.styleSpec.spec.constraints?.hasBoundedWidth == false,
            ),
        hasLength(2),
      );
      rebuild(() => raw = true);
      await t.pumpAndSettle();
      expect(color(t, 0), blue);
      expect(color(t, 1), blue);
      rebuild(() => enabled = false);
      await t.pumpAndSettle();
      final mouse = await t.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer();
      await mouse.moveTo(t.getCenter(thumbs().first));
      await t.pump();
      expect(t.takeException(), isNull);
      await mouse.removePointer();
      await t.pumpWidget(const SizedBox());
      for (final n in focus) n.dispose();
    },
  );
  testWidgets(
    'snapping yields to neighbor spacing for off-grid controlled bounds',
    (t) async {
      final changes = <List<double>>[];
      await t.pumpWidget(
        host(
          RemixRangeSlider(
            values: const [.2, .55],
            minSpacing: .1,
            snapDivisions: 10,
            autofocusThumbIndex: 0,
            onChanged: changes.add,
            style: SliderStyler().thumbSize(const Size(20, 20)),
          ),
        ),
      );
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.end);
      await t.pump();
      expect(changes.last[0], closeTo(.45, .00001));
      expect(changes.last[1], .55);
    },
  );

  testWidgets(
    'nested hover tooling overrides and null-callback disabling remain independent',
    (t) async {
      late StateSetter rebuild;
      Set<WidgetState>? forced;
      var attached = true;
      final requests = <List<double>>[];
      final style = SliderStyler()
          .thumbSize(const Size(20, 20))
          .thumbColor(red)
          .thumb(BoxStyler().onHovered(BoxStyler().color(blue)))
          .onFocused(SliderStyler().thumbColor(green));
      Widget slider() => RemixRangeSlider(
        values: const [.25, .75],
        onChanged: attached ? requests.add : null,
        style: style,
      );
      await t.pumpWidget(
        host(
          StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return forced == null
                  ? slider()
                  : WidgetStateStyleOverride(states: forced!, child: slider());
            },
          ),
        ),
      );
      final mouse = await t.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(t.getCenter(thumb(0)));
      await t.pumpAndSettle();
      expect(color(t, 0), blue);
      expect(color(t, 1), red);
      expect(requests, isEmpty);
      rebuild(() => forced = {WidgetState.focused});
      await t.pumpAndSettle();
      expect(color(t, 0), green);
      expect(color(t, 1), green);
      rebuild(() {
        forced = null;
        attached = false;
      });
      await t.pumpAndSettle();
      expect(color(t, 0), red);
      expect(color(t, 1), red);
      await t.tapAt(t.getCenter(thumb(0)));
      await t.pump();
      expect(requests, isEmpty);
      await mouse.removePointer();
    },
  );

  testWidgets(
    'nonzero decimal minimum accepts requests and omits packed bound actions',
    (t) async {
      final handle = t.ensureSemantics();
      var values = <double>[.2, .3];
      final requests = <List<double>>[];
      await t.pumpWidget(
        host(
          StatefulBuilder(
            builder: (context, setState) => RemixRangeSlider(
              values: values,
              min: .2,
              max: 1,
              minSpacing: .1,
              snapDivisions: 8,
              semanticLabels: const ['Lower', 'Upper'],
              enableFeedback: false,
              onChanged: (next) {
                requests.add(next);
                setState(() => values = next);
              },
            ),
          ),
        ),
      );
      expect(t.takeException(), isNull);
      bool has(String name, ui.SemanticsAction action) => t
          .getSemantics(find.bySemanticsLabel(name))
          .getSemanticsData()
          .hasAction(action);
      expect(has('Lower', ui.SemanticsAction.increase), isFalse);
      expect(has('Lower', ui.SemanticsAction.decrease), isFalse);
      expect(has('Upper', ui.SemanticsAction.decrease), isFalse);
      expect(has('Upper', ui.SemanticsAction.increase), isTrue);
      action(t, 'Upper', ui.SemanticsAction.increase);
      await t.pump();
      expect(t.takeException(), isNull);
      expect(values[0], .2);
      expect(values[1], closeTo(.4, .000000001));
      action(t, 'Upper', ui.SemanticsAction.decrease);
      await t.pump();
      expect(t.takeException(), isNull);
      expect(values[0], .2);
      expect(values[1], closeTo(.3, .000000001));
      expect(has('Lower', ui.SemanticsAction.increase), isFalse);
      expect(has('Upper', ui.SemanticsAction.decrease), isFalse);
      expect(requests, hasLength(2));
      for (final request in requests) {
        expect(request[0], greaterThanOrEqualTo(.2));
        expect(request[1], lessThanOrEqualTo(1));
        expect(request[1] - request[0], greaterThanOrEqualTo(.1 - 1e-10));
      }
      handle.dispose();
    },
  );
  testWidgets(
    'minimum-only thumb widths keep both endpoints inside the control',
    (t) async {
      for (final direction in TextDirection.values) {
        for (final minimum in [8.0, 12.0, 16.0, 32.0]) {
          await t.pumpWidget(
            host(
              RemixRangeSlider(
                values: const [0, 1],
                onChanged: (_) {},
                style: SliderStyler().minWidth(minimum).thumbColor(red),
              ),
              direction: direction,
            ),
          );
          final root = t.getRect(find.byType(RemixRangeSlider));
          for (var index = 0; index < 2; index++) {
            final rect = t.getRect(thumb(index));
            expect(
              rect.left,
              greaterThanOrEqualTo(root.left),
              reason: '$direction minimum=$minimum',
            );
            expect(
              rect.right,
              lessThanOrEqualTo(root.right),
              reason: '$direction minimum=$minimum',
            );
          }
        }
      }
    },
  );

  final focusColor = ContextToken<Color>(
    (context) => WidgetStateProvider.hasStateOf(context, WidgetState.focused)
        ? green
        : red,
  );
  Finder painted(Color value) => find.byWidgetPredicate(
    (widget) =>
        widget is DecoratedBox &&
        widget.decoration is BoxDecoration &&
        (widget.decoration as BoxDecoration).color == value,
  );
  for (final keyframe in [false, true]) {
    for (final focused in [0, 1]) {
      testWidgets(
        'deferred ${keyframe ? 'keyframe' : 'phase'} tokens use local thumb and aggregate rail states focus=$focused',
        (t) async {
          final trigger = ValueNotifier(false);
          final focus = [FocusNode(), FocusNode()];
          BoxStyler animate(BoxStyler base) => keyframe
              ? base.keyframeAnimation(
                  trigger: trigger,
                  timeline: [
                    KeyframeTrack<double>('progress', [
                      const Keyframe.linear(1, Duration(milliseconds: 100)),
                    ], initial: 0),
                  ],
                  styleBuilder: (_, style) => style.color(focusColor()),
                )
              : base.phaseAnimation<int>(
                  trigger: trigger,
                  phases: const [0, 1],
                  styleBuilder: (_, style) => style.color(focusColor()),
                  configBuilder: (_) => const CurveAnimationConfig.linear(
                    Duration(milliseconds: 100),
                  ),
                );
          await t.pumpWidget(
            host(
              RemixRangeSlider(
                values: const [.25, .75],
                focusNodes: focus,
                onChanged: (_) {},
                style: SliderStyler()
                    .thumb(
                      animate(
                        BoxStyler().size(20, 20).color(red).wrap(.opacity(.4)),
                      ),
                    )
                    .track(animate(BoxStyler().color(red)))
                    .range(animate(BoxStyler().color(red))),
              ),
            ),
          );
          focus[focused].requestFocus();
          await t.pump();
          await t.pump();
          expect(focus[focused].hasPrimaryFocus, isTrue);
          trigger.value = true;
          await t.pump();
          await t.pump(const Duration(milliseconds: 50));
          for (var index = 0; index < 2; index++) {
            expect(
              find.descendant(
                of: thumb(index),
                matching: painted(index == focused ? green : red),
              ),
              findsOneWidget,
            );
          }
          expect(
            find.descendant(
              of: find.byType(NakedSliderTrack),
              matching: painted(green),
            ),
            findsNWidgets(2),
          );
          expect(
            t.widgetList<Opacity>(find.byType(Opacity)).map((w) => w.opacity),
            [.4, .4],
          );
          await t.pumpWidget(const SizedBox());
          for (final node in focus) node.dispose();
          trigger.dispose();
        },
      );
    }

    for (final range in [false, true]) {
      testWidgets(
        'root ${keyframe ? 'keyframe' : 'phase'} frames own modifiers once and retain local interpolation range=$range',
        (t) async {
          final trigger = ValueNotifier(false);
          final focus = [FocusNode(), FocusNode()];
          final base = SliderStyler()
              .thumbSize(const Size(20, 20))
              .thumbColor(red)
              .thumb(BoxStyler().wrap(.opacity(.4)))
              .wrap(.opacity(.5));
          SliderStyler frame(SliderStyler style, double progress) => style
              .thumbSize(Size.square(20 + 20 * progress))
              .thumbColor(focusColor())
              .wrap(.opacity(.5 - .25 * progress));
          final style = keyframe
              ? base.keyframeAnimation(
                  trigger: trigger,
                  timeline: [
                    KeyframeTrack<double>('progress', [
                      const Keyframe.linear(1, Duration(milliseconds: 100)),
                    ], initial: 0),
                  ],
                  styleBuilder: (values, style) =>
                      frame(style, values.get<double>('progress')),
                )
              : base.phaseAnimation<int>(
                  trigger: trigger,
                  phases: const [0, 1],
                  styleBuilder: (phase, style) =>
                      frame(style, phase.toDouble()),
                  configBuilder: (_) => const CurveAnimationConfig.linear(
                    Duration(milliseconds: 100),
                  ),
                );
          await t.pumpWidget(
            host(
              range
                  ? RemixRangeSlider(
                      values: const [.25, .75],
                      focusNodes: focus,
                      onChanged: (_) {},
                      style: style,
                    )
                  : RemixSlider(
                      value: .25,
                      focusNode: focus[0],
                      onChanged: (_) {},
                      style: style,
                    ),
            ),
          );
          focus[0].requestFocus();
          await t.pump();
          await t.pump();
          expect(focus[0].hasPrimaryFocus, isTrue);
          trigger.value = true;
          await t.pump();
          await t.pump(const Duration(milliseconds: 50));
          expect(
            t
                .widgetList<Opacity>(
                  find.ancestor(
                    of: find.byType(NakedSliderTrack),
                    matching: find.byType(Opacity),
                  ),
                )
                .map((w) => w.opacity),
            [.375],
          );
          final opacities =
              t
                  .widgetList<Opacity>(find.byType(Opacity))
                  .map((w) => w.opacity)
                  .toList()
                ..sort();
          expect(opacities, range ? [.375, .4, .4] : [.375, .4]);
          for (var index = 0; index < (range ? 2 : 1); index++) {
            expect(t.getSize(thumb(index)), const Size(30, 30));
            expect(
              find.descendant(
                of: thumb(index),
                matching: painted(index == 0 ? green : red),
              ),
              findsOneWidget,
            );
          }
          await t.pumpWidget(const SizedBox());
          for (final node in focus) node.dispose();
          trigger.dispose();
        },
      );
    }
  }
}
