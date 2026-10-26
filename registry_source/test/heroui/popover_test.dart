import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/popover.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

const _content = Key('content');

/// The measured `popover-open` content: 252.28 wide and 108 tall with a 16px
/// inset around a 220.28 x 76 body.
Widget _popover({
  PopoverStyler style = const PopoverStyler.create(),
  MenuController? controller,
  bool openOnTap = true,
  Widget? trigger,
}) => HeroUiPopover(
  style: style,
  controller: controller,
  openOnTap: openOnTap,
  popoverChild: const SizedBox(
    key: _content,
    width: 220.28125,
    height: 76,
    child: Text('Details'),
  ),
  child: trigger ?? const Text('Open'),
);

Future<void> _open(WidgetTester tester) async {
  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
}

Finder get _surface => find
    .ancestor(of: find.byKey(_content), matching: find.byType(DecoratedBox))
    .first;

void main() {
  for (final mode in ['light', 'dark']) {
    testWidgets('the open popover matches upstream in $mode', (tester) async {
      await tester.pumpHeroUi(_popover(), mode: mode);
      await _open(tester);
      final upstream = heroUiCase('popover-open', mode: mode, state: true);

      expect(tester.getSize(_surface), upstream.size);

      final spec = tester.resolvedSpecOf<PopoverSpec>(find.byKey(_content));
      final box = spec.container.spec.decoration! as BoxDecoration;
      expect(
        box.borderRadius,
        BorderRadius.circular(upstream.px('borderRadius')),
      );
      expectCssColor(box.color!, upstream.styles['backgroundColor']!);
      expect(
        behindShadows(spec.containerEffects),
        cssRemixShadows(upstream.styles['boxShadow']!),
      );

      final text = DefaultTextStyle.of(
        tester.element(find.text('Details')),
      ).style;
      expectCssColor(text.color!, upstream.styles['color']!, reason: 'text');
      expect(text.fontSize, upstream.px('fontSize'));
      expect(
        text.fontSize! * text.height!,
        closeTo(upstream.px('lineHeight'), .01),
      );
    });
  }

  testWidgets('a button trigger opens the popover through its controller', (
    tester,
  ) async {
    final controller = MenuController();
    await tester.pumpHeroUi(
      _popover(
        controller: controller,
        openOnTap: false,
        trigger: RemixButton(label: 'Open', onPressed: controller.open),
      ),
    );
    expect(find.byKey(_content), findsNothing);

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.byKey(_content), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byKey(_content), findsNothing);
  });

  testWidgets('tapping the trigger opens and an outside tap closes', (
    tester,
  ) async {
    await tester.pumpHeroUi(_popover());
    await _open(tester);
    expect(find.byKey(_content), findsOneWidget);

    await tester.tapAt(const Offset(2, 2));
    await tester.pumpAndSettle();
    expect(find.byKey(_content), findsNothing);
  });

  testWidgets('a caller style wins over the recipe', (tester) async {
    const override = Color(0xFF00FF00);
    await tester.pumpHeroUi(_popover(style: PopoverStyler().color(override)));
    await _open(tester);
    final spec = tester.resolvedSpecOf<PopoverSpec>(find.byKey(_content));
    expect((spec.container.spec.decoration! as BoxDecoration).color, override);
  });
}
