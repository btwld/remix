import 'dart:typed_data';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/default/recipes/dashboard/dashboard_demo.dart';
import 'package:registry_source/vanilla.dart';
import 'package:remix/remix.dart';

import 'support.dart';

/// A part that rings on keyboard focus draws the ring around itself and moves
/// nothing: neither the part nor what sits beside it changes size or position,
/// and the ring appears only once the part is focus-visible.
///
/// The ring is read from the rendered pixels, so the test holds however a
/// recipe or a Remix part chooses to paint it.
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

      testWidgets('a sidebar destination rings outside itself', (tester) async {
        final probe = await _pump(
          tester,
          theme.data,
          (node) => SizedBox(
            width: 280,
            height: 120,
            child: VanillaSidebar<String>(
              selectedValue: 'billing',
              onSelected: (_) {},
              sections: [
                RemixSidebarSection(
                  label: 'Workspace',
                  destinations: [
                    RemixSidebarDestination(
                      value: 'overview',
                      label: 'Overview',
                      focusNode: node,
                    ),
                    const RemixSidebarDestination(
                      value: 'billing',
                      label: 'Billing',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

        await probe.expectRing(
          part: find.byType(VanillaSidebar<String>),
          includes: (_) => [probe.focusNode.rect.centerLeft.translate(-1.5, 0)],
        );
      });

      testWidgets('the dashboard account trigger rings outside itself', (
        tester,
      ) async {
        await _pumpDashboard(tester, theme.data);
        const workspace = 'Northstar workspace';
        final probe = _Probe(
          tester,
          theme.data,
          Focus.of(tester.element(find.text(workspace))),
        );

        await probe.expectRing(
          part: find.ancestor(
            of: find.text(workspace),
            matching: find.byType(VanillaMenu<String>),
          ),
          neighbor: find.text(workspace),
          includes: (part) => [part.centerLeft.translate(-1.5, 0)],
        );
      });

      for (final label in const ['Open notifications', 'Open theme settings'])
        testWidgets('the dashboard $label button rings outside itself', (
          tester,
        ) async {
          await _pumpDashboard(tester, theme.data);
          final button = find.byWidgetPredicate(
            (widget) =>
                widget is VanillaIconButton && widget.semanticLabel == label,
          );
          final popover = find.ancestor(
            of: button,
            matching: find.byType(VanillaPopover),
          );
          final stop = FocusManager.instance.rootScope.traversalDescendants
              .singleWhere(
                (node) => _isInside(node.context, tester.element(popover)),
              );
          final probe = _Probe(tester, theme.data, stop);

          await probe.expectRing(
            part: button,
            neighbor: find.byType(VanillaIconButton).first,
            includes: (part) => [part.centerLeft.translate(-1.5, 0)],
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
const _frame = ValueKey('frame');

/// Pumps the widget [build] returns above a [_neighbor], on a keyboard-driven
/// focus highlight, so a focused part is focus-visible.
Future<_Probe> _pump(
  WidgetTester tester,
  VanillaThemeData theme,
  Widget Function(FocusNode focusNode) build,
) async {
  final focusNode = FocusNode(debugLabel: 'ring-probe');
  addTearDown(focusNode.dispose);
  await _pumpFrame(
    tester,
    theme,
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
  );

  return _Probe(tester, theme, focusNode);
}

/// Pumps the built-in dashboard chrome on a desktop-sized view.
Future<void> _pumpDashboard(WidgetTester tester, VanillaThemeData theme) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1200, 800);
  addTearDown(tester.view.reset);

  await _pumpFrame(
    tester,
    theme,
    Overlay.wrap(child: const VanillaDashboardDemo(initialPage: .orders)),
  );
}

bool _isInside(BuildContext? context, Element root) {
  if (context == null) return false;
  var inside = identical(context, root);
  context.visitAncestorElements((ancestor) {
    inside = identical(ancestor, root);
    return !inside;
  });

  return inside;
}

/// Pumps [child] under [theme] inside the frame the probe captures.
Future<void> _pumpFrame(
  WidgetTester tester,
  VanillaThemeData theme,
  Widget child,
) async {
  final previous = FocusManager.instance.highlightStrategy;
  FocusManager.instance.highlightStrategy =
      FocusHighlightStrategy.alwaysTraditional;
  addTearDown(() => FocusManager.instance.highlightStrategy = previous);

  await tester.pumpWidget(
    RepaintBoundary(
      key: _frame,
      child: VanillaTheme(theme: theme, child: hostOf(child)),
    ),
  );
  await tester.pumpAndSettle();
}

final class _Probe {
  const _Probe(this.tester, this.theme, this.focusNode);

  final WidgetTester tester;
  final VanillaThemeData theme;
  final FocusNode focusNode;

  /// Focuses the part and checks that it rings without moving anything.
  ///
  /// [neighbor] is what must stay put beside or inside it; it defaults to a
  /// marker [_pump] places after the part.
  ///
  /// [includes] are points, in global coordinates, where the ring must be
  /// painted: each pixel there turns into the ring's color laid over what it
  /// showed before. At each of [excludes] the pixel must not change at all.
  Future<void> expectRing({
    required Finder part,
    Finder? neighbor,
    Iterable<Offset> Function(Rect part) includes = _none,
    Iterable<Offset> Function(Rect part) excludes = _none,
  }) async {
    final rect = tester.getRect(part);
    final neighborFinder = neighbor ?? find.byKey(_neighbor);
    final neighborRect = tester.getRect(neighborFinder);
    final before = await _capture();

    focusNode.requestFocus();
    await tester.pumpAndSettle();
    final after = await _capture();

    expect(tester.getRect(part), rect, reason: 'the part keeps its box');
    expect(
      tester.getRect(neighborFinder),
      neighborRect,
      reason: 'the part does not push what sits beside or inside it',
    );
    final ring = tint(theme.ring, 0.5);
    for (final point in includes(rect)) {
      final resting = before.colorAt(point);
      expect(
        after.colorAt(point),
        isNot(_isColor(resting)),
        reason: 'focusing the part paints something at $point',
      );
      expect(
        after.colorAt(point),
        _isColor(Color.alphaBlend(ring, resting)),
        reason: 'what it paints at $point is the ring over what was there',
      );
    }
    for (final point in excludes(rect)) {
      expect(
        after.colorAt(point),
        _isColor(before.colorAt(point)),
        reason: 'the ring stays off $point',
      );
    }
  }

  Future<_Pixels> _capture() async {
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(_frame),
    );
    final pixels = await tester.runAsync(() async {
      final image = await boundary.toImage();
      final data = await image.toByteData();
      final pixels = _Pixels(image.width, data!);
      image.dispose();
      return pixels;
    });

    return pixels!;
  }
}

Iterable<Offset> _none(Rect part) => const [];

/// A frame of logical pixels, one per physical pixel.
final class _Pixels {
  const _Pixels(this.width, this._rgba);

  final int width;
  final ByteData _rgba;

  Color colorAt(Offset point) {
    final offset = (point.dy.floor() * width + point.dx.floor()) * 4;

    return Color.fromARGB(
      _rgba.getUint8(offset + 3),
      _rgba.getUint8(offset),
      _rgba.getUint8(offset + 1),
      _rgba.getUint8(offset + 2),
    );
  }
}

/// Matches [expected] to within a level or two per channel, which is what
/// blending and rounding leave.
Matcher _isColor(Color expected) => predicate<Color>((actual) {
  int channel(Color color, int shift) => (color.toARGB32() >> shift) & 0xFF;

  return [0, 8, 16, 24].every(
    (shift) => (channel(actual, shift) - channel(expected, shift)).abs() <= 2,
  );
}, 'is $expected');
