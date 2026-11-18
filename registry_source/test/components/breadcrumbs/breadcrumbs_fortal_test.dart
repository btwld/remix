import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../helpers/test_helpers.dart';

void main() {
  test('defaults to size2', () {
    const trail = FortalBreadcrumbs(items: [FortalBreadcrumbItem('Home')]);

    expect(trail.size, FortalBreadcrumbsSize.size2);
    expect(trail.semanticLabel, isNull);
  });

  group('steps', () {
    testWidgets('actionable steps are links; the last step never is', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        SizedBox(
          width: 600,
          child: FortalBreadcrumbs(
            items: [
              FortalBreadcrumbItem('Studio', onPressed: () {}),
              const FortalBreadcrumbItem('Catalog'),
              FortalBreadcrumbItem('Editions', onPressed: () {}),
            ],
          ),
        ),
      );

      expect(find.byType(FortalLink), findsOneWidget);
      expect(tester.widget<FortalLink>(find.byType(FortalLink)).text, 'Studio');
      expect(find.text('Catalog'), findsOneWidget);
      expect(find.text('Editions'), findsOneWidget);
    });

    for (final mode in const [FortalThemeMode.light, FortalThemeMode.dark]) {
      testWidgets('plain steps are muted, the current page strong in '
          '${mode.name}', (tester) async {
        await tester.pumpRemixApp(
          const SizedBox(
            width: 600,
            child: FortalBreadcrumbs(
              items: [
                FortalBreadcrumbItem('Catalog'),
                FortalBreadcrumbItem('Editions'),
              ],
            ),
          ),
          mode: mode,
        );
        final context = tester.element(find.byType(FortalBreadcrumbs));
        final muted = _textStyle(tester, 'Catalog');
        final current = _textStyle(tester, 'Editions');

        expect(muted.color, FortalTokens.gray11.resolve(context));
        expect(muted.fontWeight, FontWeight.w400);
        expect(current.color, FortalTokens.gray12.resolve(context));
        expect(current.fontWeight, FontWeight.w500);
        final chevron = tester.widget<StyledIcon>(find.byType(StyledIcon));
        expect(chevron.icon, RemixIcons.chevronRight);
      });
    }

    testWidgets('a step link activates on pointer and Enter, with a ring', (
      tester,
    ) async {
      var presses = 0;
      await tester.pumpRemixApp(
        SizedBox(
          width: 600,
          child: FortalBreadcrumbs(
            items: [
              FortalBreadcrumbItem('Studio', onPressed: () => presses++),
              const FortalBreadcrumbItem('Editions'),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Studio'));
      await tester.pump();
      expect(presses, 1);

      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      addTearDown(
        () => FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.automatic,
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      final spec = tester.resolvedSpecOf<LinkSpec>(find.text('Studio'));
      expect(spec.containerEffects?.outline.width, 2);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(presses, 2);

      // The link is the trail's only Tab stop: the current page is not one.
      expect(
        FocusManager.instance.rootScope.traversalDescendants.where(
          (node) => node is! FocusScopeNode && node.canRequestFocus,
        ),
        hasLength(1),
      );
    });
  });

  group('geometry', () {
    for (final (size, fontSize, chevron, gap) in const [
      (FortalBreadcrumbsSize.size1, 12.0, 12.0, 4.0),
      (FortalBreadcrumbsSize.size2, 14.0, 12.0, 8.0),
      (FortalBreadcrumbsSize.size3, 16.0, 16.0, 8.0),
    ]) {
      testWidgets('${size.name} sets ${fontSize}px text, ${chevron}px '
          'chevrons ${gap}px from the steps', (tester) async {
        await tester.pumpRemixApp(
          SizedBox(
            width: 600,
            child: FortalBreadcrumbs(
              size: size,
              items: const [
                FortalBreadcrumbItem('Catalog'),
                FortalBreadcrumbItem('Editions'),
              ],
            ),
          ),
        );

        expect(_textStyle(tester, 'Catalog').fontSize, fontSize);
        expect(_textStyle(tester, 'Editions').fontSize, fontSize);
        final icon = tester.getRect(find.byType(Icon));
        expect(icon.size, Size.square(chevron));
        expect(icon.left - tester.getRect(find.text('Catalog')).right, gap);
        expect(tester.getRect(find.text('Editions')).left - icon.right, gap);
      });
    }

    testWidgets('a long trail keeps to one line and ellipsizes', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        SizedBox(
          width: 200,
          child: FortalBreadcrumbs(
            items: [
              FortalBreadcrumbItem(
                'A workspace with a long name',
                onPressed: () {},
              ),
              const FortalBreadcrumbItem('An even longer current page title'),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(FortalBreadcrumbs)).width, 200);
      for (final label in [
        'A workspace with a long name',
        'An even longer current page title',
      ]) {
        final paragraph = tester.renderObject<RenderParagraph>(
          find.text(label),
        );
        expect(paragraph.maxLines, 1, reason: label);
        expect(paragraph.overflow, TextOverflow.ellipsis, reason: label);
        expect(paragraph.didExceedMaxLines, isTrue, reason: label);
      }
    });
  });

  group('fitting', () {
    testWidgets('a trail that fits keeps every step whole', (tester) async {
      // The test font draws 16px squares: 96 + 160 + 160 for the steps and
      // 64 for the chevrons and gaps. Even thirds would cut the last two.
      await tester.pumpRemixApp(
        SizedBox(
          width: 490,
          child: FortalBreadcrumbs(
            size: .size3,
            items: [
              FortalBreadcrumbItem('Studio', onPressed: () {}),
              const FortalBreadcrumbItem('Collection'),
              const FortalBreadcrumbItem('Mar Aberto'),
            ],
          ),
        ),
      );

      for (final label in ['Studio', 'Collection', 'Mar Aberto']) {
        expect(
          tester
              .renderObject<RenderParagraph>(find.text(label))
              .didExceedMaxLines,
          isFalse,
          reason: label,
        );
      }
    });

    testWidgets('a short step stays whole while long ones share the rest', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        const SizedBox(
          width: 240,
          child: FortalBreadcrumbs(
            items: [
              FortalBreadcrumbItem('Home'),
              FortalBreadcrumbItem('A collection with a long name'),
              FortalBreadcrumbItem('A current page with a longer title'),
            ],
          ),
        ),
      );

      bool cut(String label) => tester
          .renderObject<RenderParagraph>(find.text(label))
          .didExceedMaxLines;
      expect(cut('Home'), isFalse);
      expect(cut('A collection with a long name'), isTrue);
      expect(cut('A current page with a longer title'), isTrue);
      expect(
        tester.getSize(find.text('A collection with a long name')).width,
        closeTo(
          tester.getSize(find.text('A current page with a longer title')).width,
          1,
        ),
      );
    });

    testWidgets('an unbounded trail lays every step out whole', (tester) async {
      await tester.pumpRemixApp(
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FortalBreadcrumbs(
              items: [
                FortalBreadcrumbItem('Catalog'),
                FortalBreadcrumbItem('Editions'),
              ],
            ),
          ],
        ),
      );

      expect(tester.takeException(), isNull);
      expect(
        tester
            .renderObject<RenderParagraph>(find.text('Editions'))
            .didExceedMaxLines,
        isFalse,
      );
    });
  });

  group('direction, scale and semantics', () {
    testWidgets('right to left mirrors the chevron and the order', (
      tester,
    ) async {
      for (final direction in TextDirection.values) {
        await tester.pumpRemixApp(
          const SizedBox(
            width: 600,
            child: FortalBreadcrumbs(
              items: [
                FortalBreadcrumbItem('Catalog'),
                FortalBreadcrumbItem('Editions'),
              ],
            ),
          ),
          textDirection: direction,
        );

        final flip = tester.widget<Transform>(
          find
              .ancestor(
                of: find.byType(StyledIcon),
                matching: find.byType(Transform),
              )
              .first,
        );
        final rtl = direction == TextDirection.rtl;
        expect(flip.transform.entry(0, 0), rtl ? -1 : 1);
        final catalog = tester.getRect(find.text('Catalog'));
        final editions = tester.getRect(find.text('Editions'));
        expect(
          rtl ? editions.right < catalog.left : catalog.right < editions.left,
          isTrue,
        );
      }
    });

    testWidgets('200% text in right to left stays on one line', (tester) async {
      await tester.pumpRemixApp(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: SizedBox(
            width: 320,
            child: FortalBreadcrumbs(
              size: .size3,
              items: [
                FortalBreadcrumbItem('Studio', onPressed: () {}),
                const FortalBreadcrumbItem('Catalog'),
                const FortalBreadcrumbItem('Editions'),
              ],
            ),
          ),
        ),
        textDirection: .rtl,
      );

      expect(tester.takeException(), isNull);
      final tops = [
        for (final label in ['Studio', 'Catalog', 'Editions'])
          tester.getCenter(find.text(label)).dy,
      ];
      expect(tops.toSet(), hasLength(1));
    });

    testWidgets('chevrons are hidden; labels and the trail name read', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpRemixApp(
        SizedBox(
          width: 600,
          child: FortalBreadcrumbs(
            semanticLabel: 'Breadcrumbs',
            items: [
              FortalBreadcrumbItem(
                'Home',
                onPressed: () {},
                semanticLabel: 'Studio home',
              ),
              const FortalBreadcrumbItem('Editions'),
            ],
          ),
        ),
      );

      expect(find.bySemanticsLabel('Breadcrumbs'), findsOneWidget);
      expect(
        tester.getSemantics(find.bySemanticsLabel('Studio home')),
        isSemantics(isLink: true, hasTapAction: true),
      );
      expect(find.bySemanticsLabel('Editions'), findsOneWidget);
      final icon = find.byType(StyledIcon);
      expect(
        find.ancestor(of: icon, matching: find.byType(ExcludeSemantics)),
        findsWidgets,
      );
      semantics.dispose();
    });

    testWidgets('the trail is a navigation landmark named Breadcrumb unless '
        'given a name', (tester) async {
      final semantics = tester.ensureSemantics();
      for (final (label, expected) in const [
        (null, 'Breadcrumb'),
        ('Collection path', 'Collection path'),
      ]) {
        await tester.pumpRemixApp(
          SizedBox(
            width: 600,
            child: FortalBreadcrumbs(
              semanticLabel: label,
              items: const [
                FortalBreadcrumbItem('Catalog'),
                FortalBreadcrumbItem('Editions'),
              ],
            ),
          ),
        );

        final node = tester.getSemantics(find.bySemanticsLabel(expected));
        expect(node.getSemanticsData().role, SemanticsRole.navigation);
        // The steps stay their own nodes inside the landmark.
        expect(node.childrenCount, greaterThan(0));
        expect(find.bySemanticsLabel('Editions'), findsOneWidget);
      }
      semantics.dispose();
    });
  });

  group('render box', () {
    testWidgets('a measured baseline row lays the trail out without errors', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        const SizedBox(
          width: 400,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                FortalText('Path', size: .size2),
                Expanded(
                  child: FortalBreadcrumbs(
                    items: [
                      FortalBreadcrumbItem('Catalog'),
                      FortalBreadcrumbItem('Editions'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      // The trail sits on the row's baseline by its first step; the two
      // texts share their size, so their tops line up too.
      expect(
        tester.getTopLeft(find.text('Catalog')).dy,
        tester.getTopLeft(find.text('Path')).dy,
      );
    });

    testWidgets('the dry baseline matches the laid-out one', (tester) async {
      await tester.pumpRemixApp(
        const SizedBox(
          width: 300,
          child: FortalBreadcrumbs(
            size: .size3,
            items: [
              FortalBreadcrumbItem('Catalog'),
              FortalBreadcrumbItem('Editions of the year'),
            ],
          ),
        ),
      );

      final trail = tester.renderObject<RenderBox>(
        find.descendant(
          of: find.byType(FortalBreadcrumbs),
          matching: find.byWidgetPredicate(
            (widget) => widget.runtimeType.toString() == '_Trail',
          ),
        ),
      );
      // The first step's baseline, where layout put it.
      final first = tester.renderObject<RenderParagraph>(find.text('Catalog'));
      final expected =
          first.localToGlobal(Offset.zero).dy -
          trail.localToGlobal(Offset.zero).dy +
          first.getDryBaseline(first.constraints, TextBaseline.alphabetic)!;
      expect(
        trail.getDryBaseline(trail.constraints, TextBaseline.alphabetic),
        closeTo(expected, 1e-9),
      );
    });

    for (final direction in TextDirection.values) {
      testWidgets('a trail too narrow even for its chevrons is clipped in '
          '${direction.name}', (tester) async {
        await tester.pumpRemixApp(
          const SizedBox(
            width: 20,
            child: FortalBreadcrumbs(
              items: [
                FortalBreadcrumbItem('Studio'),
                FortalBreadcrumbItem('Catalog'),
                FortalBreadcrumbItem('Editions'),
              ],
            ),
          ),
          textDirection: direction,
        );

        expect(tester.takeException(), isNull);
        final trail = find.descendant(
          of: find.byType(FortalBreadcrumbs),
          matching: find.byWidgetPredicate(
            (widget) => widget.runtimeType.toString() == '_Trail',
          ),
        );
        final box = tester.getRect(trail);
        expect(box.width, 20);
        // The chevrons and gaps alone are wider than the box...
        final chevrons = find.byType(StyledIcon);
        expect(
          chevrons.evaluate().any((element) {
            final rect = tester.getRect(
              find.byElementPredicate((e) => e == element),
            );
            return rect.left < box.left || rect.right > box.right;
          }),
          isTrue,
        );
        // ...so the trail clips its painting to its own box.
        expect(
          tester.renderObject(trail),
          paints..clipRect(rect: Offset.zero & box.size),
        );
      });
    }

    testWidgets('a trail that fits paints without a clip', (tester) async {
      await tester.pumpRemixApp(
        const SizedBox(
          width: 400,
          child: FortalBreadcrumbs(
            items: [
              FortalBreadcrumbItem('Catalog'),
              FortalBreadcrumbItem('Editions'),
            ],
          ),
        ),
      );

      expect(
        tester.renderObject(
          find.descendant(
            of: find.byType(FortalBreadcrumbs),
            matching: find.byWidgetPredicate(
              (widget) => widget.runtimeType.toString() == '_Trail',
            ),
          ),
        ),
        isNot(paints..clipRect()),
      );
    });
  });
}

/// The resolved style of the text that reads [label].
TextStyle _textStyle(WidgetTester tester, String label) =>
    tester.renderObject<RenderParagraph>(find.text(label)).text.style!;
