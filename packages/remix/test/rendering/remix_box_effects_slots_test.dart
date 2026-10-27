import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:remix/src/rendering/remix_box_effects.dart'
    show RemixBoxAdapter, RemixFlexBoxAdapter;

const _ringColor = Color(0xFF0000FF);
const _boundaryKey = ValueKey('effects-slots-boundary');

RemixBoxEffectsMix _ring({double offset = 2}) => RemixBoxEffectsMix(
  outline: BorderSideMix(color: _ringColor, width: 2),
  outlineOffset: offset,
);

typedef _Capture = ({ByteData bytes, int width});

/// A focusable part whose own box should carry the ring.
///
/// [label] is the text inside that box, and [adapter] is the widget type that
/// renders it, so `ancestor(label, adapter).first` is the ringed box.
typedef _Part = ({
  String name,
  String label,
  Type adapter,
  Widget Function(RemixBoxEffectsMix ring, FocusNode node) build,
  Future<void> Function(WidgetTester tester, FocusNode node) focus,
  Future<void> Function(WidgetTester tester)? open,
});

Future<void> _focusNode(WidgetTester tester, FocusNode node) async {
  node.requestFocus();
  await tester.pumpAndSettle();
}

Future<void> _focusWithArrowDown(WidgetTester tester, FocusNode node) async {
  await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
  await tester.pumpAndSettle();
}

Future<void> _tapAndSettle(WidgetTester tester, String label) async {
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
}

final List<_Part> _parts = [
  (
    name: 'Tab',
    label: 'Alpha',
    adapter: RemixFlexBoxAdapter,
    build: (ring, node) => RemixTabs(
      selectedTabId: 'a',
      onChanged: (_) {},
      child: RemixTabBar(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RemixTab(
              tabId: 'a',
              label: 'Alpha',
              focusNode: node,
              style: TabStyler()
                  .padding(.all(8))
                  .onFocusVisible(TabStyler().containerEffects(ring)),
            ),
            const RemixTab(tabId: 'b', label: 'Beta'),
          ],
        ),
      ),
    ),
    focus: _focusNode,
    open: null,
  ),
  (
    name: 'Toggle',
    label: 'Bold',
    adapter: RemixFlexBoxAdapter,
    build: (ring, node) => RemixToggle(
      selected: false,
      onChanged: (_) {},
      label: 'Bold',
      focusNode: node,
      style: ToggleStyler()
          .padding(.all(8))
          .onFocusVisible(ToggleStyler().containerEffects(ring)),
    ),
    focus: _focusNode,
    open: null,
  ),
  (
    name: 'ToggleGroup item',
    label: 'Alpha',
    adapter: RemixFlexBoxAdapter,
    build: (ring, node) => RemixToggleGroup<String>(
      selectedValue: 'a',
      onChanged: (_) {},
      items: [
        RemixToggleGroupItem(value: 'a', label: 'Alpha', focusNode: node),
        const RemixToggleGroupItem(value: 'b', label: 'Beta'),
      ],
      style: ToggleGroupStyler(
        item: ToggleGroupItemStyler()
            .padding(.all(8))
            .onFocusVisible(ToggleGroupItemStyler().containerEffects(ring)),
      ),
    ),
    focus: _focusNode,
    open: null,
  ),
  (
    name: 'SelectMenuItem',
    label: 'Alpha',
    adapter: RemixFlexBoxAdapter,
    build: (ring, node) => RemixSelect<String>(
      trigger: const RemixSelectTrigger(placeholder: 'Pick'),
      onChanged: (_) {},
      items: const [
        RemixSelectItem(value: 'a', label: 'Alpha'),
        RemixSelectItem(value: 'b', label: 'Beta'),
      ],
      style: SelectStyler().item(
        SelectMenuItemStyler()
            .padding(.all(8))
            .onFocusVisible(SelectMenuItemStyler().containerEffects(ring)),
      ),
    ),
    focus: _focusWithArrowDown,
    open: (tester) => _tapAndSettle(tester, 'Pick'),
  ),
  (
    name: 'MenuItem',
    label: 'Copy',
    adapter: RemixFlexBoxAdapter,
    build: (ring, node) => RemixMenu<String>(
      trigger: const RemixMenuTrigger(label: 'Options'),
      onSelected: (_) {},
      items: const [
        RemixMenuItem(value: 'copy', label: 'Copy'),
        RemixMenuItem(value: 'paste', label: 'Paste'),
      ],
      style: MenuStyler().item(
        MenuItemStyler()
            .padding(.all(8))
            .onFocusVisible(MenuItemStyler().containerEffects(ring)),
      ),
    ),
    focus: _focusWithArrowDown,
    open: (tester) => _tapAndSettle(tester, 'Options'),
  ),
  (
    name: 'MenuTrigger',
    label: 'Options',
    adapter: RemixFlexBoxAdapter,
    build: (ring, node) => RemixMenu<String>(
      triggerFocusNode: node,
      trigger: const RemixMenuTrigger(label: 'Options'),
      onSelected: (_) {},
      items: const [RemixMenuItem(value: 'copy', label: 'Copy')],
      style: MenuStyler().trigger(
        MenuTriggerStyler()
            .padding(.all(8))
            .onFocusVisible(MenuTriggerStyler().containerEffects(ring)),
      ),
    ),
    focus: _focusNode,
    open: null,
  ),
  (
    name: 'Accordion trigger',
    label: 'Title',
    adapter: RemixFlexBoxAdapter,
    build: (ring, node) => RemixAccordionGroup<String>(
      controller: RemixAccordionController<String>(),
      child: RemixAccordion<String>(
        value: 'a',
        title: 'Title',
        focusNode: node,
        style: AccordionStyler()
            .padding(.all(8))
            .onFocusVisible(AccordionStyler().triggerEffects(ring)),
        child: const Text('Content'),
      ),
    ),
    focus: _focusNode,
    open: null,
  ),
  (
    name: 'Disclosure trigger',
    label: 'Trigger',
    adapter: RemixBoxAdapter,
    build: (ring, node) => RemixDisclosure(
      trigger: const Text('Trigger'),
      content: const Text('Content'),
      focusNode: node,
      style: DisclosureStyler()
          .padding(.all(8))
          .onFocusVisible(DisclosureStyler().triggerEffects(ring)),
    ),
    focus: _focusNode,
    open: null,
  ),
];

Widget _harness(Widget child) => RepaintBoundary(
  key: _boundaryKey,
  child: MixScope.empty(
    child: MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(40),
          child: Center(child: child),
        ),
      ),
    ),
  ),
);

Future<_Capture> _capture(WidgetTester tester) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(_boundaryKey),
  );
  final result = await tester.runAsync(() async {
    final image = boundary.toImageSync(pixelRatio: 1);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    final width = image.width;
    image.dispose();
    return (bytes: bytes!, width: width);
  });
  return result!;
}

int _pixel(_Capture image, int x, int y) =>
    image.bytes.getUint32((y * image.width + x) * 4);

int _rgba(Color color) =>
    (color.r * 255).round() << 24 |
    (color.g * 255).round() << 16 |
    (color.b * 255).round() << 8 |
    (color.a * 255).round();

/// The pixel in the middle of a 2px ring drawn 2px outside [box]'s left edge.
int _outsideRingPixel(_Capture image, Rect box, {double? y}) =>
    _pixel(image, (box.left - 3).floor(), (y ?? box.center.dy).floor());

/// The pixel in the middle of a 2px ring drawn flush inside [box]'s left edge.
int _insideRingPixel(_Capture image, Rect box) =>
    _pixel(image, (box.left + 1).floor(), box.center.dy.floor());

List<Rect> _adapterRects(WidgetTester tester) => [
  for (final type in [RemixBoxAdapter, RemixFlexBoxAdapter])
    for (final element in find.byType(type).evaluate())
      (element.renderObject! as RenderBox).localToGlobal(Offset.zero) &
          (element.renderObject! as RenderBox).size,
];

void _useTraditionalFocus() {
  final previous = FocusManager.instance.highlightStrategy;
  addTearDown(() => FocusManager.instance.highlightStrategy = previous);
  FocusManager.instance.highlightStrategy =
      FocusHighlightStrategy.alwaysTraditional;
}

void main() {
  group('containerEffects and triggerEffects on focusable parts', () {
    for (final part in _parts) {
      testWidgets(
        '${part.name} paints its ring on focus without changing layout',
        (tester) async {
          _useTraditionalFocus();
          final node = FocusNode();
          addTearDown(node.dispose);

          await tester.pumpWidget(_harness(part.build(_ring(), node)));
          await tester.pumpAndSettle();
          await part.open?.call(tester);

          final box = find
              .ancestor(
                of: find.text(part.label),
                matching: find.byType(part.adapter),
              )
              .first;
          final rect = tester.getRect(box);
          final rectsBefore = _adapterRects(tester);

          expect(
            _outsideRingPixel(await _capture(tester), rect),
            isNot(_rgba(_ringColor)),
            reason: 'idle',
          );

          await part.focus(tester, node);

          expect(_adapterRects(tester), rectsBefore, reason: 'layout');
          expect(
            _outsideRingPixel(await _capture(tester), rect),
            _rgba(_ringColor),
            reason: 'focused',
          );
        },
      );
    }

    for (final part in _parts.where(
      (part) =>
          const {'Accordion trigger', 'Disclosure trigger'}.contains(part.name),
    )) {
      testWidgets('${part.name} ring hugs the trigger, not the panel', (
        tester,
      ) async {
        _useTraditionalFocus();
        final node = FocusNode();
        addTearDown(node.dispose);

        await tester.pumpWidget(_harness(part.build(_ring(), node)));
        await _tapAndSettle(tester, part.label);
        await _focusNode(tester, node);

        final trigger = tester.getRect(
          find
              .ancestor(
                of: find.text(part.label),
                matching: find.byType(part.adapter),
              )
              .first,
        );
        final content = tester.getRect(find.text('Content'));
        expect(content.top, greaterThanOrEqualTo(trigger.bottom));
        final image = await _capture(tester);

        expect(_outsideRingPixel(image, trigger), _rgba(_ringColor));
        expect(
          _outsideRingPixel(image, trigger, y: content.center.dy),
          isNot(_rgba(_ringColor)),
        );
      });
    }

    group('on the end item of a toggle group', () {
      // Pixel at the group's left edge on the first item, for a ring drawn
      // `offset` from the item (outside it when positive, inside when negative)
      // in a group that clips with [clip].
      Future<int> edgePixel(
        WidgetTester tester, {
        required double offset,
        required Clip clip,
      }) async {
        _useTraditionalFocus();
        final node = FocusNode();
        addTearDown(node.dispose);
        await tester.pumpWidget(
          _harness(
            RemixToggleGroup<String>(
              selectedValue: 'a',
              onChanged: (_) {},
              items: [
                RemixToggleGroupItem(
                  value: 'a',
                  label: 'Alpha',
                  focusNode: node,
                ),
                const RemixToggleGroupItem(value: 'b', label: 'Beta'),
              ],
              style: ToggleGroupStyler(
                container: FlexBoxStyler()
                    .color(Colors.white)
                    .borderRadius(.circular(4))
                    .clipBehavior(clip),
                item: ToggleGroupItemStyler()
                    .padding(.all(8))
                    .onFocusVisible(
                      ToggleGroupItemStyler().containerEffects(
                        _ring(offset: offset),
                      ),
                    ),
              ),
            ),
          ),
        );
        await _focusNode(tester, node);
        final item = tester.getRect(
          find
              .ancestor(
                of: find.text('Alpha'),
                matching: find.byType(RemixFlexBoxAdapter),
              )
              .first,
        );
        final image = await _capture(tester);
        return offset < 0
            ? _insideRingPixel(image, item)
            : _outsideRingPixel(image, item);
      }

      testWidgets('the group clip crops a ring drawn outside the item', (
        tester,
      ) async {
        expect(
          await edgePixel(tester, offset: 2, clip: Clip.none),
          _rgba(_ringColor),
          reason: 'without a clip',
        );
        expect(
          await edgePixel(tester, offset: 2, clip: Clip.antiAlias),
          isNot(_rgba(_ringColor)),
          reason: 'with a clip',
        );
      });

      testWidgets('the group clip keeps a ring drawn with a negative offset', (
        tester,
      ) async {
        expect(
          await edgePixel(tester, offset: -2, clip: Clip.antiAlias),
          _rgba(_ringColor),
        );
      });
    });
  });

  group('effects slots animate through RemixBoxEffectsSpec.lerpNullable', () {
    const ring = RemixBoxEffectsSpec(
      outline: BorderSide(color: _ringColor, width: 4),
      outlineOffset: 2,
    );

    // Each entry lerps one spec's effects slot between two optional values.
    final lerps =
        <
          String,
          RemixBoxEffectsSpec? Function(
            RemixBoxEffectsSpec? from,
            RemixBoxEffectsSpec? to,
            double t,
          )
        >{
          'TabSpec': (from, to, t) => TabSpec(
            containerEffects: from,
          ).lerp(TabSpec(containerEffects: to), t).containerEffects,
          'ToggleSpec': (from, to, t) => ToggleSpec(
            containerEffects: from,
          ).lerp(ToggleSpec(containerEffects: to), t).containerEffects,
          'ToggleGroupItemSpec': (from, to, t) => ToggleGroupItemSpec(
            containerEffects: from,
          ).lerp(ToggleGroupItemSpec(containerEffects: to), t).containerEffects,
          'SelectMenuItemSpec': (from, to, t) => SelectMenuItemSpec(
            containerEffects: from,
          ).lerp(SelectMenuItemSpec(containerEffects: to), t).containerEffects,
          'MenuItemSpec': (from, to, t) => MenuItemSpec(
            containerEffects: from,
          ).lerp(MenuItemSpec(containerEffects: to), t).containerEffects,
          'MenuTriggerSpec': (from, to, t) => MenuTriggerSpec(
            containerEffects: from,
          ).lerp(MenuTriggerSpec(containerEffects: to), t).containerEffects,
          'AccordionSpec.triggerEffects': (from, to, t) => AccordionSpec(
            triggerEffects: from,
          ).lerp(AccordionSpec(triggerEffects: to), t).triggerEffects,
          'DisclosureSpec.triggerEffects': (from, to, t) => DisclosureSpec(
            triggerEffects: from,
          ).lerp(DisclosureSpec(triggerEffects: to), t).triggerEffects,
        };

    for (final MapEntry(key: name, value: lerp) in lerps.entries) {
      test('$name fades an outline in and out', () {
        expect(lerp(null, ring, 0.5)?.outline.width, 2);
        expect(lerp(ring, null, 0.5)?.outline.width, 2);
        expect(lerp(null, ring, 1), ring);
        expect(lerp(ring, null, 0), ring);
        expect(lerp(null, null, 0.5), isNull);
      });
    }
  });
}
