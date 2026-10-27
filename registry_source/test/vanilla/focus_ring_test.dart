import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/vanilla.dart';
import 'package:remix/remix.dart';

import 'support.dart';

/// A part that rings on keyboard focus draws the ring around itself and moves
/// nothing: neither the part nor what sits beside it changes size or position,
/// and the ring is absent until the part is focus-visible.
void main() {
  for (final theme in vanillaThemes) {
    group(theme.name, () {
      testWidgets('a toggle rings outside itself', (tester) async {
        final probe = await _pump(
          tester,
          theme.data,
          (node) => VanillaToggle(
            selected: false,
            label: 'Bold',
            focusNode: node,
            onChanged: (_) {},
          ),
        );

        await probe.expectRing(
          part: find.byType(VanillaToggle),
          includes: (part) => [part.centerLeft.translate(-1.5, 0)],
        );
      });

      testWidgets('an outline toggle rings outside itself', (tester) async {
        final probe = await _pump(
          tester,
          theme.data,
          (node) => VanillaToggle.outline(
            selected: false,
            label: 'Bold',
            focusNode: node,
            onChanged: (_) {},
          ),
        );

        await probe.expectRing(
          part: find.byType(VanillaToggle),
          includes: (part) => [part.centerLeft.translate(-1.5, 0)],
        );
      });

      testWidgets('a toggle group option rings inside itself', (tester) async {
        final probe = await _pump(
          tester,
          theme.data,
          (node) => VanillaToggleGroup<String>(
            selectedValue: 'right',
            onChanged: (_) {},
            items: [
              RemixToggleGroupItem(
                value: 'left',
                label: 'Left',
                focusNode: node,
              ),
              const RemixToggleGroupItem(value: 'right', label: 'Right'),
            ],
          ),
        );

        await probe.expectRing(
          part: find.byType(VanillaToggleGroup<String>),
          includes: (part) => [part.centerLeft.translate(1.5, 0)],
          excludes: (part) => [part.centerLeft.translate(-1.5, 0)],
        );
      });

      testWidgets('a tab rings outside itself', (tester) async {
        final probe = await _pump(
          tester,
          theme.data,
          (node) => RemixTabs(
            selectedTabId: 'account',
            onChanged: (_) {},
            child: VanillaTabBar(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  VanillaTab(
                    tabId: 'account',
                    label: 'Account',
                    focusNode: node,
                  ),
                  const VanillaTab(tabId: 'billing', label: 'Billing'),
                ],
              ),
            ),
          ),
        );

        await probe.expectRing(
          part: find.byType(VanillaTab).first,
          includes: (part) => [part.centerLeft.translate(-1.5, 0)],
        );
      });

      testWidgets('a line tab rings outside itself', (tester) async {
        final probe = await _pump(
          tester,
          theme.data,
          (node) => RemixTabs(
            selectedTabId: 'account',
            onChanged: (_) {},
            child: VanillaTabBar(
              variant: .line,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  VanillaTab(
                    variant: .line,
                    tabId: 'account',
                    label: 'Account',
                    focusNode: node,
                  ),
                  const VanillaTab(
                    variant: .line,
                    tabId: 'billing',
                    label: 'Billing',
                  ),
                ],
              ),
            ),
          ),
        );

        await probe.expectRing(
          part: find.byType(VanillaTab).first,
          includes: (part) => [part.centerLeft.translate(-1.5, 0)],
        );
      });

      testWidgets('a menu trigger rings outside itself', (tester) async {
        final probe = await _pump(
          tester,
          theme.data,
          (node) => VanillaMenu<String>(
            trigger: const RemixMenuTrigger(label: 'Actions'),
            triggerFocusNode: node,
            items: const [RemixMenuItem(value: 'copy', label: 'Copy')],
          ),
        );

        await probe.expectRing(
          part: find.byType(VanillaMenu<String>),
          includes: (part) => [part.centerLeft.translate(-1.5, 0)],
        );
      });

      testWidgets('an accordion rings its trigger, not the opened section', (
        tester,
      ) async {
        const body = ValueKey('accordion-body');
        final controller = RemixAccordionController<String>();
        addTearDown(controller.dispose);
        final probe = await _pump(
          tester,
          theme.data,
          (node) => RemixAccordionGroup<String>(
            controller: controller,
            initialExpandedValues: const ['shipping'],
            child: VanillaAccordion<String>(
              value: 'shipping',
              title: 'Shipping',
              focusNode: node,
              child: const SizedBox(key: body, height: 80, width: 200),
            ),
          ),
        );

        await probe.expectRing(
          part: find.byType(VanillaAccordion<String>),
          includes: (part) => [
            Offset(part.left - 1.5, tester.getCenter(find.text('Shipping')).dy),
          ],
          excludes: (part) => [
            Offset(part.left - 1.5, tester.getCenter(find.byKey(body)).dy),
          ],
        );
      });

      testWidgets('a disclosure rings its trigger, not the opened section', (
        tester,
      ) async {
        const body = ValueKey('disclosure-body');
        final probe = await _pump(
          tester,
          theme.data,
          (node) => VanillaDisclosure(
            defaultExpanded: true,
            focusNode: node,
            trigger: const Text('Details'),
            content: const SizedBox(key: body, height: 80, width: 200),
          ),
        );

        await probe.expectRing(
          part: find.byType(VanillaDisclosure),
          includes: (part) => [
            Offset(part.left - 1.5, tester.getCenter(find.text('Details')).dy),
          ],
          excludes: (part) => [
            Offset(part.left - 1.5, tester.getCenter(find.byKey(body)).dy),
          ],
        );
      });
    });
  }
}

const _neighbor = ValueKey('neighbor');

/// Pumps the widget [build] returns above a [_neighbor], on a keyboard-driven
/// focus highlight, so a focused part is focus-visible.
Future<_Probe> _pump(
  WidgetTester tester,
  VanillaThemeData theme,
  Widget Function(FocusNode focusNode) build,
) async {
  final previous = FocusManager.instance.highlightStrategy;
  FocusManager.instance.highlightStrategy =
      FocusHighlightStrategy.alwaysTraditional;
  addTearDown(() => FocusManager.instance.highlightStrategy = previous);
  final focusNode = FocusNode(debugLabel: 'ring-probe');
  addTearDown(focusNode.dispose);

  await tester.pumpWidget(
    VanillaTheme(
      theme: theme,
      child: hostOf(
        Center(
          child: SizedBox(
            width: 320,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                build(focusNode),
                const SizedBox(key: _neighbor, width: 40, height: 10),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  return _Probe(tester, theme, focusNode);
}

final class _Probe {
  const _Probe(this.tester, this.theme, this.focusNode);

  final WidgetTester tester;
  final VanillaThemeData theme;
  final FocusNode focusNode;

  /// Focuses the part and checks that it rings without moving anything.
  ///
  /// [includes] and [excludes] are points, in global coordinates, that the
  /// ring's band must and must not cover.
  Future<void> expectRing({
    required Finder part,
    Iterable<Offset> Function(Rect part) includes = _none,
    Iterable<Offset> Function(Rect part) excludes = _none,
  }) async {
    final ring = tint(theme.ring, 0.5);
    final rect = tester.getRect(part);
    final neighbor = tester.getRect(find.byKey(_neighbor));
    expect(
      tester.renderObject(part),
      isNot(_paintsPath(ring)),
      reason: 'a part that is not focused draws no ring',
    );

    focusNode.requestFocus();
    await tester.pumpAndSettle();

    expect(tester.getRect(part), rect, reason: 'the part keeps its box');
    expect(
      tester.getRect(find.byKey(_neighbor)),
      neighbor,
      reason: 'the part does not push what sits beside it',
    );
    expect(
      tester.renderObject(part),
      _paintsPath(
        ring,
        includes: [for (final point in includes(rect)) point - rect.topLeft],
        excludes: [for (final point in excludes(rect)) point - rect.topLeft],
      ),
      reason: 'a focus-visible part draws the ring',
    );
  }
}

/// Matches a render object that draws a path of [color] covering every
/// [includes] point and none of the [excludes] points.
///
/// Other paths may be drawn before it, such as a tab's underline.
PaintPattern _paintsPath(
  Color color, {
  Iterable<Offset> includes = const [],
  Iterable<Offset> excludes = const [],
}) => paints
  ..something((method, arguments) {
    if (method != #drawPath) return false;
    final path = arguments[0] as Path;
    final paint = arguments[1] as Paint;

    return paint.color.toARGB32() == color.toARGB32() &&
        includes.every(path.contains) &&
        !excludes.any(path.contains);
  });

Iterable<Offset> _none(Rect part) => const [];
