import 'package:flutter/gestures.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/vanilla.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import 'support.dart';

/// shadcn/ui `breadcrumb.tsx`: the list is `text-sm text-muted-foreground`
/// with `gap-1.5 sm:gap-2.5`, a link `hover:text-foreground`, the page
/// `font-normal text-foreground`, and the separator `[&>svg]:size-3.5`.
void main() {
  Future<void> pump(
    WidgetTester tester, {
    VanillaThemeData theme = const VanillaThemeData.light(),
    TextDirection direction = TextDirection.ltr,
    double width = 480,
    double textScale = 1,
    List<String>? pressed,
    List<VanillaBreadcrumbItem>? items,
  }) async {
    final previous = FocusManager.instance.highlightStrategy;
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
    addTearDown(() => FocusManager.instance.highlightStrategy = previous);

    // A fresh app per pump, with a navigator so Tab traverses the route.
    await tester.pumpWidget(
      WidgetsApp(
        key: UniqueKey(),
        color: const Color(0xFFFFFFFF),
        pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, _, _) => builder(context),
        ),
        builder: (context, navigator) => VanillaTheme(
          theme: theme,
          child: MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(textScale)),
            child: Directionality(textDirection: direction, child: navigator!),
          ),
        ),
        home: Center(
          child: SizedBox(
            width: width,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: VanillaBreadcrumbs(
                items:
                    items ??
                    [
                      VanillaBreadcrumbItem(
                        'Home',
                        onPressed: () => pressed?.add('Home'),
                      ),
                      const VanillaBreadcrumbItem('Workspace'),
                      VanillaBreadcrumbItem(
                        'Components',
                        onPressed: () => pressed?.add('Components'),
                      ),
                      VanillaBreadcrumbItem(
                        'Breadcrumb',
                        onPressed: () => pressed?.add('Breadcrumb'),
                      ),
                    ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  LinkSpec linkSpec(WidgetTester tester, String label) => tester
      .widget<StyleSpecProvider<LinkSpec>>(
        find
            .ancestor(
              of: find.text(label),
              matching: find.byType(StyleSpecProvider<LinkSpec>),
            )
            .first,
      )
      .spec
      .spec;

  TextStyle textStyle(WidgetTester tester, String label) =>
      tester.widget<Text>(find.text(label)).style!;

  Finder chevrons() => find.byIcon(RemixIcons.chevronRight);

  for (final theme in vanillaThemes) {
    group(theme.name, () {
      testWidgets('steps are text-sm in the muted color, the page in '
          'foreground, all at regular weight', (tester) async {
        await pump(tester, theme: theme.data);

        for (final label in ['Home', 'Components']) {
          final style = linkSpec(tester, label).label.spec.style!;
          expect(style.fontSize, 14, reason: label);
          expect(style.fontSize! * style.height!, closeTo(20, 1e-9));
          expect(style.fontWeight, FontWeight.w400, reason: label);
          expect(style.color, theme.data.mutedForeground, reason: label);
          expect(
            style.decoration,
            anyOf(isNull, TextDecoration.none),
            reason: label,
          );
        }
        final level = textStyle(tester, 'Workspace');
        expect(level.fontSize, 14);
        expect(level.fontWeight, FontWeight.w400);
        expect(level.color, theme.data.mutedForeground);

        final page = textStyle(tester, 'Breadcrumb');
        expect(page.fontSize, 14);
        expect(page.fontWeight, FontWeight.w400);
        expect(page.color, theme.data.foreground);
      });

      testWidgets('a link turns foreground under the pointer, without an '
          'underline', (tester) async {
        await pump(tester, theme: theme.data);
        final pointer = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        addTearDown(pointer.removePointer);
        await pointer.addPointer(location: Offset.zero);
        await pointer.moveTo(tester.getCenter(find.text('Home')));
        await tester.pumpAndSettle();

        final hovered = linkSpec(tester, 'Home').label.spec.style!;
        expect(hovered.color, theme.data.foreground);
        expect(hovered.decoration, anyOf(isNull, TextDecoration.none));
        expect(
          linkSpec(tester, 'Components').label.spec.style!.color,
          theme.data.mutedForeground,
        );
      });

      testWidgets('the separator is a muted 14px chevron', (tester) async {
        await pump(tester, theme: theme.data);
        expect(chevrons(), findsNWidgets(3));
        for (final chevron in tester.widgetList<Icon>(chevrons())) {
          expect(chevron.size, 14);
          expect(chevron.color, theme.data.mutedForeground);
        }
        expect(tester.getSize(chevrons().first), const Size.square(14));
      });

      testWidgets('keyboard focus rings only the links', (tester) async {
        await pump(tester, theme: theme.data);
        bool ringed(String label) =>
            !(linkSpec(tester, label).containerEffects?.isEmpty ?? true);

        expect(ringed('Home'), isFalse);
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();
        expect(
          linkSpec(tester, 'Home').containerEffects?.outline,
          BorderSide(color: tint(theme.data.ring, 0.5), width: 3),
        );

        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();
        expect(ringed('Home'), isFalse);
        expect(ringed('Components'), isTrue);

        // Neither the plain level nor the current page is a tab stop.
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();
        expect(ringed('Components'), isFalse);
        expect(find.byType(StyleSpecProvider<LinkSpec>), findsNWidgets(2));
      });
    });
  }

  testWidgets('right-to-left text reverses the trail and mirrors the '
      'chevron', (tester) async {
    double flip(Finder chevron) => tester
        .widget<Transform>(
          find.ancestor(of: chevron, matching: find.byType(Transform)).first,
        )
        .transform
        .entry(0, 0);

    await pump(tester);
    expect(flip(chevrons().first), 1);

    await pump(tester, direction: TextDirection.rtl);
    expect(
      tester.getRect(find.text('Home')).left,
      greaterThan(tester.getRect(find.text('Breadcrumb')).right),
    );
    for (final chevron in chevrons().evaluate()) {
      expect(flip(find.byWidget(chevron.widget)), -1);
    }
  });

  testWidgets('only earlier steps with a callback navigate, by tap or '
      'Enter', (tester) async {
    final pressed = <String>[];
    await pump(tester, pressed: pressed);

    for (final label in ['Home', 'Workspace', 'Components', 'Breadcrumb']) {
      await tester.tap(find.text(label));
      await tester.pump();
    }
    expect(pressed, ['Home', 'Components']);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(pressed, ['Home', 'Components', 'Home']);
  });

  testWidgets('the trail is a named navigation landmark of links and text', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await pump(
        tester,
        items: [
          VanillaBreadcrumbItem('Home', onPressed: () {}),
          const VanillaBreadcrumbItem('Ws', semanticLabel: 'Workspace'),
          VanillaBreadcrumbItem('Docs', onPressed: () {}),
          const VanillaBreadcrumbItem('Breadcrumb'),
        ],
      );

      final trail = tester.getSemantics(find.byType(VanillaBreadcrumbs));
      expect(trail.label, 'Breadcrumb');
      expect(trail.getSemanticsData().role, SemanticsRole.navigation);

      for (final label in ['Home', 'Docs']) {
        final link = find.semantics.byLabel(label);
        expect(link, findsOne, reason: label);
        expect(
          link.evaluate().single.getSemanticsData().flagsCollection.isLink,
          isTrue,
          reason: label,
        );
      }
      for (final label in ['Workspace', 'Breadcrumb']) {
        // `Breadcrumb` names both the trail and its current page.
        final matches = find.semantics
            .byLabel(label)
            .evaluate()
            .where(
              (node) =>
                  node.getSemanticsData().role != SemanticsRole.navigation,
            );
        expect(matches, hasLength(1), reason: label);
        final data = matches.single.getSemanticsData();
        expect(data.flagsCollection.isLink, isFalse, reason: label);
        expect(data.hasAction(SemanticsAction.tap), isFalse, reason: label);
      }
      expect(find.semantics.byLabel('Ws'), findsNothing);
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('the current page is never a link', (tester) async {
    await pump(
      tester,
      items: [
        VanillaBreadcrumbItem('Home', onPressed: () {}),
        VanillaBreadcrumbItem('Settings', onPressed: () {}),
      ],
    );
    expect(find.byType(StyleSpecProvider<LinkSpec>), findsOneWidget);
    expect(
      find.ancestor(
        of: find.text('Settings'),
        matching: find.byType(RemixLink),
      ),
      findsNothing,
    );
  });

  testWidgets('a trail can be const', (tester) async {
    // The whole trail, not only its items, constructs as a constant.
    const trail = VanillaBreadcrumbs(
      items: [VanillaBreadcrumbItem('Settings')],
    );
    await tester.pumpWidget(
      VanillaTheme(child: hostOf(const Center(child: trail))),
    );
    expect(find.text('Settings'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a single step is just the current page', (tester) async {
    await pump(tester, items: const [VanillaBreadcrumbItem('Overview')]);
    expect(chevrons(), findsNothing);
    expect(
      textStyle(tester, 'Overview').color,
      VanillaThemeData.light().foreground,
    );
  });
}
