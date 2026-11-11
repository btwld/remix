import 'dart:ui' show Tristate;

import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:registry_source/src/dashboard/dashboard_demo_base.dart';
import 'package:registry_source/src/dashboard/dashboard_demo_charts.dart';
import 'package:registry_source/src/heroui/components/button.dart';
import 'package:registry_source/src/heroui/components/chart.dart';
import 'package:registry_source/src/heroui/components/chip.dart';
import 'package:registry_source/src/heroui/recipes/dashboard/dashboard_demo.dart';
import 'package:registry_source/src/heroui/recipes/dashboard/dashboard_overview.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/contrast.dart';
import '../helpers/heroui.dart';
import '../helpers/pixels.dart';

void main() {
  for (final mode in ['light', 'dark']) {
    testWidgets('the fulfillment legend names the colors the pie draws '
        'in $mode', (tester) async {
      await _pumpDemo(tester, host: _host(mode));

      final legend = tester.widget<RegistryChartLegend>(
        find.byType(RegistryChartLegend),
      );
      expect(legend.items.map((item) => item.color), heroUiChartSeries.take(3));
      final pie = find.byType(PieChart);
      final palette = resolveHeroUiChartPalette(tester.element(pie));
      expect(palette.take(3), [
        heroUiToken(HeroUiTokens.accent, mode),
        heroUiToken(HeroUiTokens.muted, mode),
        heroUiToken(HeroUiTokens.foreground, mode),
      ]);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('statuses are soft chips in their status color', (tester) async {
    await _pumpDemo(tester);

    HeroUiChip chip(String label) => tester.widget<HeroUiChip>(
      find.ancestor(
        of: find.text(label).first,
        matching: find.byType(HeroUiChip),
      ),
    );
    expect(chip('Paid').color, HeroUiColor.success);
    expect(chip('Pending').color, HeroUiColor.warning);
    expect(chip('Refunded').color, HeroUiColor.defaultColor);
    for (final label in ['Paid', 'Pending', 'Refunded']) {
      expect(chip(label).variant, HeroUiChipVariant.soft, reason: label);
    }
  });

  for (final mode in ['light', 'dark']) {
    testWidgets('the order filter is a segmented control in the primary '
        'tabs pill in $mode', (tester) async {
      final semantics = tester.ensureSemantics();
      await _pumpDemo(
        tester,
        initialPage: RegistryDashboardDemoPage.orders,
        host: _host(mode),
      );

      final control = find.byWidgetPredicate(
        (widget) => widget is RemixSegmentedControl,
      );
      expect(control, findsOneWidget);
      expect(find.byType(RemixTabs), findsNothing);
      Finder inControl(String label) =>
          find.descendant(of: control, matching: find.text(label));

      // One labelled group of options, not a tab list without panels.
      final group = find.semantics.byLabel('Filter orders by status');
      expect(group, findsOne);
      SemanticsData option(String label) => find.semantics
          .descendant(of: group, matching: find.semantics.byLabel(label))
          .evaluate()
          .single
          .getSemanticsData();
      for (final label in ['All', 'Paid', 'Pending', 'Refunded', 'Cancelled']) {
        final data = option(label);
        expect(data.role, isNot(SemanticsRole.tab), reason: label);
        expect(data.flagsCollection.isSelected, isNot(Tristate.none));
      }
      expect(option('All').flagsCollection.isSelected, Tristate.isTrue);
      expect(
        find.semantics.byPredicate(
          (node) => node.getSemanticsData().role == SemanticsRole.tabBar,
        ),
        findsNothing,
      );

      // The track and the chosen segment are the primary tabs' tokens.
      final spec = tester
          .widget<StyleSpecProvider<SegmentedControlSpec>>(
            find.byType(StyleSpecProvider<SegmentedControlSpec>).first,
          )
          .spec
          .spec;
      final track = spec.container.spec.decoration! as BoxDecoration;
      expect(track.color, heroUiToken(HeroUiTokens.defaultColor, mode));
      expect(track.borderRadius, BorderRadius.circular(20));
      expect(spec.container.spec.padding, const EdgeInsets.all(4));

      SegmentedControlItemSpec segment(String label) => tester
          .widget<StyleSpecProvider<SegmentedControlItemSpec>>(
            find
                .ancestor(
                  of: inControl(label),
                  matching: find.byType(
                    StyleSpecProvider<SegmentedControlItemSpec>,
                  ),
                )
                .first,
          )
          .spec
          .spec;
      final chosen = segment('All');
      expect(
        (chosen.container.spec.decoration! as BoxDecoration).color,
        heroUiToken(HeroUiTokens.segment, mode),
      );
      expect(
        chosen.label.spec.style!.color,
        heroUiToken(HeroUiTokens.segmentForeground, mode),
      );
      final rest = segment('Paid');
      expect(
        rest.label.spec.style!.color,
        heroUiToken(HeroUiTokens.muted, mode),
      );
      expect(rest.label.spec.style!.fontSize, 14);
      expect(rest.label.spec.style!.fontWeight, FontWeight.w500);
      expect(
        tester
            .getSize(
              find
                  .ancestor(
                    of: inControl('Paid'),
                    matching: find.byType(MergeSemantics),
                  )
                  .first,
            )
            .height,
        32,
      );

      await tester.tap(inControl('Refunded'));
      await tester.pumpAndSettle();
      final orders = tester.widget<RemixDataTable<Object>>(
        find.byWidgetPredicate((widget) => widget is RemixDataTable),
      );
      expect(orders.rows, isNotEmpty);
      expect(
        find.semantics
            .byLabel('Refunded')
            .evaluate()
            .single
            .getSemanticsData()
            .flagsCollection
            .isSelected,
        Tristate.isTrue,
      );
      expect(tester.takeException(), isNull);
      semantics.dispose();
    });
  }

  testWidgets('the appearance choices are segmented controls, not tabs', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await _pumpDemo(tester, initialPage: RegistryDashboardDemoPage.settings);
    // The visible heading and the group share the name; the options sit in
    // the group.
    for (final label in ['Light', 'Dark', 'System']) {
      expect(
        find.semantics.descendant(
          of: find.semantics.byLabel('Color mode'),
          matching: find.semantics.byLabel(label),
        ),
        findsOne,
        reason: label,
      );
    }
    expect(find.byType(RemixTabs), findsNothing);

    await tester.tap(find.bySemanticsLabel('Open theme settings'));
    await tester.pumpAndSettle();
    for (final label in ['Light', 'Dark']) {
      expect(
        find.semantics.descendant(
          of: find.semantics.byLabel('Theme appearance'),
          matching: find.semantics.byLabel(label),
        ),
        findsOne,
        reason: label,
      );
    }
    expect(find.byType(RemixTabs), findsNothing);
    expect(
      find.byWidgetPredicate((widget) => widget is RemixSegmentedControl),
      findsNWidgets(2),
    );
    semantics.dispose();
  });

  testWidgets('the radius slider reaches both brightnesses and keeps a '
      "host's custom dark theme", (tester) async {
    const custom = Color(0xFF123456);
    await _pumpDemo(
      tester,
      initialPage: RegistryDashboardDemoPage.settings,
      host: (child) => HeroUiTheme(
        mode: HeroUiThemeMode.light,
        darkTheme: HeroUiThemeData.dark(
          colors: {HeroUiTokens.background: custom},
        ),
        child: child,
      ),
    );

    Radius radius(RadiusToken token) => MixScope.tokenOf(
      token,
      tester.element(find.textContaining('Control radius')),
    );
    expect(radius(HeroUiTokens.radiusLg), const Radius.circular(8));
    expect(find.text('Control radius · 8px'), findsOneWidget);

    final slider = find.byType(RemixSlider);
    await tester.ensureVisible(slider);
    await tester.drag(slider, const Offset(160, 0));
    await tester.pumpAndSettle();
    final after = radius(HeroUiTokens.radiusLg);
    expect(after.x, greaterThan(8));
    expect(radius(HeroUiTokens.radiusXl).x, closeTo(after.x * 1.5, 0.001));
    expect(
      find.text('Settings'),
      findsWidgets,
      reason: 'the page survives the new radius',
    );

    await tester.tap(
      find.byKey(const ValueKey('dashboard-appearance-toggle')).first,
    );
    await tester.pumpAndSettle();
    final element = tester.element(find.textContaining('Control radius'));
    expect(HeroUiTheme.of(element).brightness, Brightness.dark);
    expect(MixScope.tokenOf(HeroUiTokens.background, element), custom);
    expect(radius(HeroUiTokens.radiusLg), after);
  });

  testWidgets('the radius slider works without a host theme', (tester) async {
    await _pumpDemo(
      tester,
      initialPage: RegistryDashboardDemoPage.settings,
      host: (child) => child,
    );

    final slider = find.byType(RemixSlider);
    await tester.ensureVisible(slider);
    await tester.drag(slider, const Offset(160, 0));
    await tester.pumpAndSettle();
    expect(
      MixScope.tokenOf(
        HeroUiTokens.radiusLg,
        tester.element(find.textContaining('Control radius')),
      ).x,
      greaterThan(8),
    );
    expect(tester.takeException(), isNull);
  });

  for (final label in ['Open notifications', 'Open theme settings']) {
    testWidgets('$label toggles its popover from one button', (tester) async {
      await _pumpDemo(tester);
      final button = find.byWidgetPredicate(
        (widget) => widget is HeroUiIconButton && widget.semanticLabel == label,
      );
      expect(button, findsOneWidget);
      final panel = label == 'Open notifications'
          ? 'Payout batch #29 was settled.'
          : 'Theme settings';

      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(find.text(panel), findsOneWidget);
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(find.text(panel), findsNothing);
    });
  }

  testWidgets('a radius change keeps the open page and its edits', (
    tester,
  ) async {
    await _pumpDemo(tester);
    await _open(tester, 'Settings');
    final digest = find.byType(RemixCheckbox);
    await tester.ensureVisible(digest);
    await tester.tap(digest);
    await tester.pumpAndSettle();
    expect(tester.widget<RemixCheckbox>(digest).selected, isTrue);

    final slider = find.byType(RemixSlider);
    await tester.ensureVisible(slider);
    await tester.drag(slider, const Offset(160, 0));
    await tester.pumpAndSettle();
    expect(
      MixScope.tokenOf(
        HeroUiTokens.radiusLg,
        tester.element(find.textContaining('Control radius')),
      ).x,
      greaterThan(8),
    );
    expect(find.text('Danger zone'), findsOneWidget);
    expect(tester.widget<RemixCheckbox>(digest).selected, isTrue);
    expect(tester.takeException(), isNull);
  });

  for (final mode in ['light', 'dark']) {
    for (final (page, label) in [
      (RegistryDashboardDemoPage.settings, 'the weekly digest'),
      (RegistryDashboardDemoPage.customers, 'a customer row'),
    ]) {
      testWidgets('an unchecked box on $label has a visible edge in $mode', (
        tester,
      ) async {
        final boundary = GlobalKey();
        await _pumpDemo(
          tester,
          initialPage: page,
          host: _host(mode),
          boundary: boundary,
        );
        await tester.pumpAndSettle();
        final boxes = find.byType(RemixCheckbox);
        final box = page == RegistryDashboardDemoPage.settings
            ? boxes
            : boxes.at(1);
        await tester.ensureVisible(box);
        await tester.pumpAndSettle();
        expect(tester.widget<RemixCheckbox>(box).selected, isFalse);

        final pixels = await capturePixels(tester, boundary);
        final origin = tester.getTopLeft(find.byKey(boundary));
        Color pixel(Offset logical) {
          final device = (logical - origin) * pixelScale.toDouble();
          return pixels.at(device.dx.round(), device.dy.round());
        }

        // The control is the 16px box centered in its 24px tap target.
        final center = tester.getCenter(box);
        final top = center.dy - 8;
        final edge = pixel(Offset(center.dx, top + .5));
        final card = pixel(Offset(center.dx, top - 3));
        final inside = pixel(center.translate(-4, -4));
        expectNearColor(card, heroUiToken(HeroUiTokens.surface, mode));
        expectNearColor(inside, heroUiToken(HeroUiTokens.defaultColor, mode));
        expectNearColor(edge, heroUiToken(HeroUiTokens.borderTertiary, mode));
        // Twice the contrast the bare `default` fill has against the card.
        expect(contrastRatio(edge, card), greaterThan(2.3));
        expect(contrastRatio(inside, card), lessThan(1.3));
      });
    }
  }

  testWidgets('a checked box on a card drops the edge for the accent fill', (
    tester,
  ) async {
    await _pumpDemo(tester, initialPage: RegistryDashboardDemoPage.settings);
    final box = find.byType(RemixCheckbox);
    await tester.ensureVisible(box);
    await tester.tap(box);
    await tester.pumpAndSettle();
    final spec = tester
        .widget<StyleSpecProvider<CheckboxSpec>>(
          find
              .descendant(
                of: box,
                matching: find.byType(StyleSpecProvider<CheckboxSpec>),
              )
              .first,
        )
        .spec
        .spec;
    expect(
      (spec.container.spec.decoration! as BoxDecoration).color,
      heroUiToken(HeroUiTokens.accent),
    );
    expect(spec.containerEffects?.outline.style, BorderStyle.none);
  });

  for (final mode in ['light', 'dark']) {
    testWidgets('every status keeps its label in its soft chip color in '
        '$mode', (tester) async {
      const cases = <(String, HeroUiColor)>[
        ('Paid', .success),
        ('Pending', .warning),
        ('Refunded', .defaultColor),
        ('Cancelled', .danger),
        ('Active', .success),
        ('Invited', .warning),
        ('Suspended', .danger),
        ('Fulfilled', .success),
        // The record pages pass the enum names.
        ('paid', .success),
        ('suspended', .danger),
      ];
      final soft = <HeroUiColor, (ColorToken, ColorToken)>{
        .success: (
          HeroUiTokens.successSoft,
          HeroUiTokens.successSoftForeground,
        ),
        .warning: (
          HeroUiTokens.warningSoft,
          HeroUiTokens.warningSoftForeground,
        ),
        .danger: (HeroUiTokens.dangerSoft, HeroUiTokens.dangerSoftForeground),
        .defaultColor: (
          HeroUiTokens.defaultSoft,
          HeroUiTokens.defaultSoftForeground,
        ),
      };
      for (final (label, color) in cases) {
        await tester.pumpHeroUi(heroUiDashboardStatusChip(label), mode: mode);
        expect(find.text(label), findsOneWidget, reason: label);
        final chip = tester.widget<HeroUiChip>(find.byType(HeroUiChip));
        expect(chip.color, color, reason: label);
        expect(chip.variant, HeroUiChipVariant.soft, reason: label);

        final (fill, foreground) = soft[color]!;
        final painted = tester
            .widget<RichText>(
              find.descendant(
                of: find.byType(HeroUiChip),
                matching: find.byType(RichText),
              ),
            )
            .text
            .style
            ?.color;
        expect(painted, heroUiToken(foreground, mode), reason: label);
        final fills = [
          for (final box in tester.widgetList<DecoratedBox>(
            find.descendant(
              of: find.byType(HeroUiChip),
              matching: find.byType(DecoratedBox),
            ),
          ))
            if (box.decoration case BoxDecoration(:final color?)) color,
        ];
        expect(fills, contains(heroUiToken(fill, mode)), reason: label);
      }
    });
  }

  testWidgets('the radius slider is one named node that can increase', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await _pumpDemo(tester, initialPage: RegistryDashboardDemoPage.settings);

    final radius = find.semantics.byLabel('Control radius');
    expect(radius, findsOne);
    expect(
      radius.evaluate().single.getSemanticsData().hasAction(
        SemanticsAction.increase,
      ),
      isTrue,
    );
    semantics.dispose();
  });

  testWidgets('theme settings switch the demo to dark and back', (
    tester,
  ) async {
    await _pumpDemo(tester);
    Brightness brightness() =>
        HeroUiTheme.of(tester.element(find.text('Revenue trend'))).brightness;

    await tester.tap(find.bySemanticsLabel('Open theme settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark').last);
    await tester.pumpAndSettle();
    expect(brightness(), Brightness.dark);
    // As in Vanilla, the popover closes as the appearance changes.
    await tester.tap(find.bySemanticsLabel('Open theme settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Light').last);
    await tester.pumpAndSettle();
    expect(brightness(), Brightness.light);
  });
}

/// Opens [page] from the sidebar, as a person would.
Future<void> _open(WidgetTester tester, String page) async {
  await tester.tap(find.text(page).first);
  await tester.pumpAndSettle();
}

typedef _Host = Widget Function(Widget child);

_Host _host(String mode) =>
    (child) =>
        HeroUiTheme(mode: HeroUiThemeMode.values.byName(mode), child: child);

Future<void> _pumpDemo(
  WidgetTester tester, {
  RegistryDashboardDemoPage initialPage = RegistryDashboardDemoPage.overview,
  _Host? host,
  GlobalKey? boundary,
}) async {
  tester.view
    ..devicePixelRatio = 1
    ..physicalSize = const Size(1280, 900);
  addTearDown(tester.view.reset);
  final app = WidgetsApp(
    color: const Color(0xFFFFFFFF),
    pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, _, _) => builder(context),
    ),
    home: HeroUiDashboardDemo(
      initialPage: initialPage,
      chatStepDelay: const Duration(milliseconds: 10),
    ),
  );
  final hosted = (host ?? _host('light'))(app);
  await tester.pumpWidget(
    boundary == null ? hosted : RepaintBoundary(key: boundary, child: hosted),
  );
  await tester.pump();
}
