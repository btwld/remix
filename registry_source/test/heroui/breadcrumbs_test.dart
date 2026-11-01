import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/breadcrumbs.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../helpers/heroui.dart';

/// `.breadcrumbs__separator`: `size-3`.
const _separatorSize = 12.0;

Future<void> _pump(
  WidgetTester tester, {
  String mode = 'light',
  double width = 1024,
  TextDirection direction = TextDirection.ltr,
  List<String>? pressed,
  Widget? separator,
  LinkStyler linkStyle = const LinkStyler.create(),
}) async {
  void press(String label) => pressed?.add(label);
  await tester.pumpHeroUi(
    Directionality(
      textDirection: direction,
      child: SizedBox(
        width: width - 48,
        child: HeroUiBreadcrumbs(
          separator: separator,
          linkStyle: linkStyle,
          items: [
            HeroUiBreadcrumb('Home', onPressed: () => press('Home')),
            HeroUiBreadcrumb('Library', onPressed: () => press('Library')),
            const HeroUiBreadcrumb('Book'),
          ],
        ),
      ),
    ),
    mode: mode,
    width: width,
  );
  await tester.pumpAndSettle();
}

LinkSpec _spec(WidgetTester tester, String label) =>
    tester.resolvedSpecOf<LinkSpec>(find.text(label));

/// The 12px box that holds a step's separator.
Finder _separatorBox(Finder separator) => find.ancestor(
  of: separator,
  matching: find.byWidgetPredicate(
    (widget) =>
        widget is SizedBox &&
        widget.width == _separatorSize &&
        widget.height == _separatorSize,
  ),
);

Finder get _chevrons => find.byType(Icon);

/// The product of the horizontal scale of every transform above [of].
double _horizontalScale(WidgetTester tester, Finder of) => tester
    .widgetList<Transform>(
      find.ancestor(of: of, matching: find.byType(Transform)),
    )
    .fold(1.0, (scale, transform) => scale * transform.transform.entry(0, 0));

void main() {
  for (final mode in ['light', 'dark']) {
    testWidgets('links take the breadcrumbs text styles in $mode', (
      tester,
    ) async {
      await _pump(tester, mode: mode);
      final upstream = heroUiCase('breadcrumbs-rest-item:Home', mode: mode);
      expect(
        tester.getSize(find.text('Home')).height,
        upstream.size.height,
        reason: 'leading-5',
      );

      // `text-muted` for steps and `text-link` for the current page, read off
      // the typography-muted and link cases.
      final muted = heroUiCase('typography-muted', mode: mode);
      final link = heroUiCase('link', mode: mode);
      for (final (label, color) in [
        ('Home', muted),
        ('Library', muted),
        ('Book', link),
      ]) {
        final text = _spec(tester, label).label.spec.style!;
        expect(text.fontSize, 14, reason: label);
        expect(
          text.fontSize! * text.height!,
          upstream.size.height,
          reason: label,
        );
        expect(text.fontWeight, FontWeight.w500, reason: label);
        expectCssColor(text.color!, color.styles['color']!, reason: label);
        expect(text.decoration, TextDecoration.none, reason: label);
      }
    });

    testWidgets('the chevron is a muted 12px icon from the library in $mode', (
      tester,
    ) async {
      await _pump(tester, mode: mode);
      expect(_chevrons, findsNWidgets(2));
      for (final chevron in tester.widgetList<Icon>(_chevrons)) {
        expect(chevron.icon, RemixIcons.chevronRight);
        expect(chevron.size, _separatorSize);
        expectCssColor(
          chevron.color!,
          heroUiCase('typography-muted', mode: mode).styles['color']!,
        );
      }
      // Two steps carry a separator; the current one does not.
      expect(_separatorBox(_chevrons), findsNWidgets(2));
    });

    testWidgets('hovering a link underlines it in $mode', (tester) async {
      await _pump(tester, mode: mode);
      await tester.hoverCenter(find.text('Home'));
      expect(
        _spec(tester, 'Home').label.spec.style!.decoration,
        TextDecoration.underline,
      );
      expect(
        _spec(tester, 'Library').label.spec.style!.decoration,
        TextDecoration.none,
      );
    });

    testWidgets('keyboard focus lands on the links and draws the measured '
        'link ring in $mode', (tester) async {
      await _pump(tester, mode: mode);
      final ring = heroUiCase('link-focus', mode: mode, state: true);
      bool ringed(String label) =>
          !(_spec(tester, label).containerEffects?.isEmpty ?? true);

      expect(
        [
          for (final l in ['Home', 'Library', 'Book']) ringed(l),
        ],
        [false, false, false],
      );
      await tester.focusWithTab();
      expectFocusRing(_spec(tester, 'Home').containerEffects, ring);
      expect(ringed('Library'), isFalse);

      await tester.focusWithTab();
      expectFocusRing(_spec(tester, 'Library').containerEffects, ring);
      expect(ringed('Home'), isFalse);

      // The current step is not a tab stop.
      await tester.focusWithTab();
      expect(ringed('Book'), isFalse);
      expect(ringed('Library'), isFalse);
    });
  }

  for (final width in [375, 1024]) {
    testWidgets('steps are 6px apart with a 12px separator at $width px', (
      tester,
    ) async {
      await _pump(tester, width: width.toDouble());
      final rest = heroUiCase('breadcrumbs-rest', width: width);
      expect(tester.getSize(find.byType(HeroUiBreadcrumbs)), rest.size);
      expect(
        tester.getSize(find.text('Home')).height,
        heroUiCase('breadcrumbs-rest-item:Home').size.height,
      );

      final separators = _separatorBox(_chevrons);
      expect(separators, findsNWidgets(2));
      final first = tester.getRect(find.text('Home'));
      final separator = tester.getRect(separators.first);
      expect(separator.size, const Size.square(_separatorSize));
      expect(separator.left - first.right, 4, reason: 'gap-1');

      final second = tester.getRect(find.text('Library'));
      expect(second.left - separator.right, rest.px('gap'), reason: 'gap-1.5');
      expect(
        tester.getRect(find.text('Book')).left -
            tester.getRect(separators.last).right,
        rest.px('gap'),
      );
    });
  }

  testWidgets('the chevron points the other way in right-to-left text', (
    tester,
  ) async {
    await _pump(tester);
    expect(_horizontalScale(tester, _chevrons.first), 1);

    await _pump(tester, direction: TextDirection.rtl);
    for (final chevron in tester.widgetList<Icon>(_chevrons)) {
      expect(chevron.icon, RemixIcons.chevronRight);
    }
    // `rtl:rotate-180` mirrors the glyph; the box keeps its place.
    expect(_horizontalScale(tester, _chevrons.first), -1);
    expect(_horizontalScale(tester, _chevrons.last), -1);
  });

  testWidgets('earlier steps are links, the last is the current page', (
    tester,
  ) async {
    final pressed = <String>[];
    await _pump(tester, pressed: pressed);
    await tester.tap(find.text('Home'));
    await tester.tap(find.text('Library'));
    await tester.tap(find.text('Book'));
    expect(pressed, ['Home', 'Library']);
  });

  testWidgets('the current step keeps full opacity', (tester) async {
    await _pump(tester);
    // `.breadcrumbs__link { opacity-100 }` overrides the disabled dimming a
    // plain disabled link has.
    expect(tester.opacityAbove(find.text('Book')), 1);
  });

  testWidgets('a custom separator replaces the chevron', (tester) async {
    await _pump(tester, separator: const Text('/'));
    expect(find.text('/'), findsNWidgets(2));
    expect(_chevrons, findsNothing);
    final boxes = _separatorBox(find.text('/'));
    expect(boxes, findsNWidgets(2));
    expect(tester.getSize(boxes.first), const Size.square(_separatorSize));
  });

  testWidgets('a caller link style wins over the recipe', (tester) async {
    const override = Color(0xFF00FF00);
    await _pump(tester, linkStyle: LinkStyler().label(.color(override)));
    expect(_spec(tester, 'Home').label.spec.style!.color, override);
  });
}
