import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/tooltip.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

/// The upstream fixture's text.
const _text = 'Tooltip text';

Widget _tooltip({
  String message = _text,
  TooltipStyler style = const TooltipStyler.create(),
}) => HeroUiTooltip(
  style: style,
  tooltipChild: Text(message),
  child: const Text('Trigger'),
);

/// Hovers the trigger until the tooltip is showing.
Future<TestGesture> _show(WidgetTester tester) async {
  final mouse = await tester.hoverCenter(find.text('Trigger'));
  await tester.pump(const Duration(seconds: 1));
  await tester.pumpAndSettle();
  return mouse;
}

TooltipSpec _spec(WidgetTester tester, String message) =>
    tester.resolvedSpecOf<TooltipSpec>(find.text(message));

BoxDecoration _box(TooltipSpec spec) =>
    spec.container.spec.decoration! as BoxDecoration;

Finder _surface(String message) =>
    find.ancestor(of: find.text(message), matching: find.byType(Box)).first;

void main() {
  for (final mode in ['light', 'dark']) {
    testWidgets('the tooltip surface follows tooltip.css in $mode', (
      tester,
    ) async {
      await tester.pumpHeroUi(_tooltip(), mode: mode);
      await _show(tester);
      final content = heroUiCase('tooltip-default-open-content', mode: mode);
      final text = heroUiCase('tooltip-default-open-text', mode: mode);
      final spec = _spec(tester, _text);
      final box = _box(spec);

      // bg-overlay, p-2, text-xs, min(32px, var(--radius-xl)).
      expectCssColor(box.color!, content.styles['backgroundColor']!);
      expect(
        spec.container.spec.padding,
        EdgeInsets.all(content.px('paddingTop')),
      );
      expect(
        box.borderRadius,
        BorderRadius.circular(content.px('borderRadius')),
      );
      expect(spec.label.spec.style!.fontSize, text.px('fontSize'));
      expect(
        spec.label.spec.style!.fontSize! * spec.label.spec.style!.height!,
        closeTo(text.px('lineHeight'), .01),
      );
      expect(tester.getSize(_surface(_text)).height, content.size.height);
      expectCssColor(
        tester
            .renderObject<RenderParagraph>(find.text(_text))
            .text
            .style!
            .color!,
        text.styles['color']!,
        reason: 'text',
      );
    }, variant: desktopOnly);
  }

  testWidgets('the light surface carries the overlay shadow', (tester) async {
    await tester.pumpHeroUi(_tooltip());
    await _show(tester);
    expect(
      _box(_spec(tester, _text)).boxShadow,
      cssShadows(
        heroUiCase('tooltip-default-open-content').styles['boxShadow']!,
      ),
    );
  }, variant: desktopOnly);

  testWidgets('the radius stops at 32px', (tester) async {
    await tester.pumpHeroUi(
      _tooltip(),
      theme: const HeroUiThemeData.light(radius: 40),
    );
    await _show(tester);
    // --radius-xl would be 60px.
    expect(_box(_spec(tester, _text)).borderRadius, BorderRadius.circular(32));
  }, variant: desktopOnly);

  testWidgets('the surface is at most 320px wide', (tester) async {
    await tester.pumpHeroUi(_tooltip(message: 'word ' * 200));
    await _show(tester);
    final upstream = heroUiCase('tooltip-long-open-content');
    final surface = find
        .ancestor(of: find.textContaining('word'), matching: find.byType(Box))
        .first;
    expect(tester.getSize(surface).width, upstream.size.width);
    expect(upstream.styles['maxWidth'], '${upstream.size.width.toInt()}px');
  }, variant: desktopOnly);

  testWidgets('a caller style wins over the recipe', (tester) async {
    const override = Color(0xFF00FF00);
    await tester.pumpHeroUi(_tooltip(style: TooltipStyler().color(override)));
    await _show(tester);
    expect(_box(_spec(tester, _text)).color, override);
  }, variant: desktopOnly);

  testWidgets(
    'hovering the trigger shows the tooltip and leaving hides it',
    (tester) async {
      await tester.pumpHeroUi(_tooltip());
      expect(find.text(_text), findsNothing);
      final mouse = await _show(tester);
      expect(find.text(_text), findsOneWidget);

      await mouse.moveTo(const Offset(2, 2));
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(find.text(_text), findsNothing);
    },
    variant: desktopOnly,
  );
}
