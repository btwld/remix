import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_demo_artwork.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_demo_data.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_demo_records.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_demo_widgets.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('FortalArtwork', () {
    testWidgets('paints every motif in every palette and appearance', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1200, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      for (final mode in const [FortalThemeMode.light, FortalThemeMode.dark]) {
        await tester.pumpRemixApp(
          SingleChildScrollView(
            child: Wrap(
              children: [
                for (final motif in FortalArtworkMotif.values)
                  for (final accent in FortalAccentColor.values)
                    for (final size in const [
                      Size(160, 120),
                      Size(44, 44),
                      Size(300, 60),
                      Size(0, 0),
                    ])
                      SizedBox.fromSize(
                        size: size,
                        child: FortalArtwork(
                          motif: motif,
                          accent: accent,
                          seed: motif.index + accent.index,
                        ),
                      ),
              ],
            ),
          ),
          mode: mode,
        );
        expect(tester.takeException(), isNull, reason: mode.name);
      }
    });

    testWidgets('paints the same picture for the same inputs', (tester) async {
      Future<List<int>> pixels(Key key) async {
        final boundary = tester.renderObject<RenderRepaintBoundary>(
          find.byKey(key),
        );
        final bytes = await tester.runAsync(() async {
          final image = await boundary.toImage();
          final data = await image.toByteData(
            format: ui.ImageByteFormat.rawRgba,
          );
          image.dispose();

          return data!.buffer.asUint8List().toList();
        });

        return bytes!;
      }

      Widget cover(String key, int seed) => RepaintBoundary(
        key: ValueKey(key),
        child: SizedBox(
          width: 120,
          height: 90,
          child: FortalArtwork(motif: .cobogo, accent: .caju, seed: seed),
        ),
      );
      await tester.pumpRemixApp(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [cover('a', 3), cover('b', 3), cover('c', 11)],
        ),
      );

      final a = await pixels(const ValueKey('a'));
      expect(await pixels(const ValueKey('b')), a);
      expect(await pixels(const ValueKey('c')), isNot(a));
    });

    testWidgets('is decorative unless it is given a label', (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpRemixApp(
        const SizedBox(
          width: 100,
          height: 100,
          child: FortalArtwork(
            motif: .sun,
            accent: .sol,
            semanticLabel: 'Cover of Sol a Pino',
          ),
        ),
      );
      expect(
        tester.getSemantics(find.bySemanticsLabel('Cover of Sol a Pino')),
        isSemantics(isImage: true),
      );
      semantics.dispose();
    });
  });

  group('status and change badges', () {
    testWidgets('carry their meaning in text and reinforce it with a palette', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FortalStatusBadge.order(.paid),
            FortalStatusBadge.order(.refunded),
            FortalStatusBadge.customer(.paused),
            FortalStatusBadge.edition(.lowStock),
            const FortalDeltaBadge('+8.2%'),
            const FortalDeltaBadge('-2.3%', positive: false),
          ],
        ),
        mode: .light,
      );

      FortalThemeData themeOf(String label) =>
          FortalTheme.of(tester.element(find.text(label)));
      expect(themeOf('Paid').accent, FortalAccentColor.mar);
      expect(themeOf('Refunded').accentPalette, fortalError);
      expect(themeOf('Paused').accent, FortalAccentColor.orla);
      expect(themeOf('Low stock').accent, FortalAccentColor.sol);
      expect(themeOf('+8.2%').accent, FortalAccentColor.mar);
      expect(themeOf('-2.3%').accentPalette, fortalError);
    });
  });

  group('sample data', () {
    final data = fortalDashboardSampleData;

    test('formats money, counts and dates one way', () {
      expect(fortalDashboardCurrency(1249), r'$1,249.00');
      expect(fortalDashboardCurrency(1249, cents: false), r'$1,249');
      expect(fortalDashboardCurrency(-1234567.5), r'-$1,234,567.50');
      expect(fortalDashboardCurrency(0), r'$0.00');
      expect(fortalDashboardCompactCurrency(84.4), r'$84.4K');
      expect(fortalDashboardCompactCurrency(1240), r'$1.24M');
      expect(fortalDashboardCount(2420), '2,420');
      expect(fortalDashboardCount(-1000000), '-1,000,000');
      expect(fortalDashboardShortDate(DateTime(2026, 7, 18)), 'Jul 18, 2026');
    });

    test('derives revenue totals and changes from the series', () {
      expect(data.revenueTotal(.week), closeTo(84.4, 1e-9));
      expect(data.previousRevenueTotal(.week), closeTo(75.1, 1e-9));
      expect(data.revenueDelta(.week), '+12.4%');
      expect(data.revenueTotal(.month), closeTo(322.4, 1e-9));
    });

    test('is consistent with itself', () {
      expect(data.revenue.keys, FortalDashboardRange.values);
      expect(
        data.channels.fold(0.0, (sum, channel) => sum + channel.share),
        100,
      );
      for (final week in data.weeks) {
        expect(week.orders, hasLength(data.channels.length));
      }
      final titles = {for (final edition in data.editions) edition.title};
      final customers = {for (final customer in data.customers) customer.name};
      final channels = {for (final channel in data.channels) channel.label};
      for (final order in data.orders) {
        expect(titles, contains(order.edition), reason: order.id);
        expect(customers, contains(order.customer), reason: order.id);
        expect(channels, contains(order.channel), reason: order.id);
      }
      expect({
        for (final edition in data.editions) edition.id,
      }, hasLength(data.editions.length));
      for (final edition in data.editions) {
        expect(edition.sold, lessThanOrEqualTo(edition.editionSize));
        expect(
          edition.status == .soldOut,
          edition.remaining == 0,
          reason: edition.title,
        );
        expect(
          edition.status == .draft,
          edition.sold == 0,
          reason: edition.title,
        );
      }
      // Newest first, as the tables and the overview assume.
      for (var index = 1; index < data.orders.length; index += 1) {
        expect(
          data.orders[index].date.isAfter(data.orders[index - 1].date),
          isFalse,
        );
      }
    });

    test('pages clamp to the rows there are', () {
      final rows = List.generate(23, (index) => index);
      expect(
        fortalDashboardPaginate(rows, page: 0, rowsPerPage: 10).items,
        hasLength(10),
      );
      final last = fortalDashboardPaginate(rows, page: 9, rowsPerPage: 10);
      expect(last.page, 2);
      expect(last.items, [20, 21, 22]);
      final none = fortalDashboardPaginate(<int>[], page: 3, rowsPerPage: 10);
      expect(none.page, 0);
      expect(none.items, isEmpty);
    });
  });
}
