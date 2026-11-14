import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'dashboard_demo_artwork.dart';

/// The reporting window the overview and analytics charts cover.
enum FortalDashboardRange {
  week('7D', 'Last 7 days', 'vs previous 7 days'),
  month('30D', 'Last 30 days', 'vs previous 30 days'),
  quarter('90D', 'Last 90 days', 'vs previous 90 days');

  const FortalDashboardRange(this.label, this.description, this.comparison);

  /// The short label on the range switch.
  final String label;

  /// The window in words, for headings and accessible names.
  final String description;

  /// What a change over this window is compared with.
  final String comparison;
}

/// One headline figure with the trend behind it.
final class FortalDashboardMetric {
  const FortalDashboardMetric({
    required this.id,
    required this.label,
    required this.value,
    required this.delta,
    required this.trend,
    this.positive = true,
    this.caption = 'vs last week',
    this.progress,
  });

  /// Identifies the metric.
  final String id;

  /// What the metric measures.
  final String label;

  /// The headline figure, already formatted.
  final String value;

  /// The change since the previous period, such as `+12.4%`.
  final String delta;

  /// Recent values, oldest first, drawn as a sparkline.
  final List<double> trend;

  /// Whether [delta] is good news, which decides its tone.
  final bool positive;

  /// The period [delta] compares with.
  final String caption;

  /// Fraction from 0 to 1 shown as a progress bar. Omitted when null.
  final double? progress;
}

/// One point of the revenue series, in thousands of dollars.
final class FortalDashboardPoint {
  const FortalDashboardPoint(this.label, this.value, this.previous);

  /// The x-axis label.
  final String label;

  /// Revenue in this period.
  final double value;

  /// Revenue at the same point of the previous period.
  final double previous;
}

/// One sales channel and its share of revenue.
final class FortalDashboardChannel {
  const FortalDashboardChannel({
    required this.id,
    required this.label,
    required this.share,
    required this.revenue,
    required this.delta,
  });

  /// Identifies the channel.
  final String id;

  /// The channel name.
  final String label;

  /// Share of revenue, in percent. The shares add up to 100.
  final double share;

  /// Revenue through the channel, in dollars.
  final double revenue;

  /// The change since the previous period, such as `+4.2%`.
  final String delta;
}

/// Orders placed in one week, by channel.
final class FortalDashboardWeek {
  const FortalDashboardWeek(this.label, this.orders);

  /// The x-axis label.
  final String label;

  /// Orders through each channel, in [FortalDashboardData.channels] order.
  final List<double> orders;
}

/// Where an edition is in its release.
enum FortalDashboardEditionStatus {
  live('Live'),
  lowStock('Low stock'),
  soldOut('Sold out'),
  draft('Draft');

  const FortalDashboardEditionStatus(this.label);

  /// The status as shown on a badge.
  final String label;
}

/// One limited-edition print in the collection.
final class FortalDashboardEdition {
  const FortalDashboardEdition({
    required this.id,
    required this.title,
    required this.series,
    required this.artist,
    required this.price,
    required this.sold,
    required this.editionSize,
    required this.status,
    required this.motif,
    required this.accent,
    required this.format,
    required this.description,
    this.seed = 0,
    this.image,
  });

  /// Identifies the edition.
  final String id;

  /// The work's title.
  final String title;

  /// The series the work belongs to.
  final String series;

  /// Who made it.
  final String artist;

  /// The price of one print, in dollars.
  final double price;

  /// Prints sold so far.
  final int sold;

  /// Prints in the edition.
  final int editionSize;

  /// The release status.
  final FortalDashboardEditionStatus status;

  /// The composition of the generated cover.
  final FortalArtworkMotif motif;

  /// The palette of the generated cover.
  final FortalAccentColor accent;

  /// Paper size and print process.
  final String format;

  /// A sentence about the work.
  final String description;

  /// Varies the generated cover between works that share a motif.
  final int seed;

  /// A photograph of the work. The generated cover is used when null.
  final ImageProvider? image;

  /// Fraction of the edition sold, from 0 to 1.
  double get soldFraction => editionSize == 0 ? 0 : sold / editionSize;

  /// Prints still available.
  int get remaining => editionSize - sold;

  /// Revenue from the prints sold, in dollars.
  double get revenue => sold * price;
}

/// The first letters of the first two words of [name]. Empty words, as in a
/// name with doubled spaces, are skipped.
String _initials(String name) => name
    .split(' ')
    .where((part) => part.isNotEmpty)
    .take(2)
    .map((part) => part.substring(0, 1))
    .join();

/// Where a customer is in their account lifecycle.
enum FortalDashboardCustomerStatus { active, invited, paused }

/// How much a customer collects.
enum FortalDashboardCustomerTier {
  patron('Patron'),
  collector('Collector'),
  member('Member');

  const FortalDashboardCustomerTier(this.label);

  /// The tier as shown in the table.
  final String label;
}

/// One row in the customers table.
final class FortalDashboardCustomer {
  const FortalDashboardCustomer({
    required this.id,
    required this.name,
    required this.email,
    required this.city,
    required this.tier,
    required this.status,
    required this.orders,
    required this.spent,
    required this.joinedAt,
  });

  /// The customer identifier.
  final String id;

  /// The customer's full name.
  final String name;

  /// The customer's email address.
  final String email;

  /// Where the customer is based.
  final String city;

  /// The collecting tier.
  final FortalDashboardCustomerTier tier;

  /// The account status.
  final FortalDashboardCustomerStatus status;

  /// Orders placed.
  final int orders;

  /// Lifetime spend, in dollars.
  final double spent;

  /// When the customer joined.
  final DateTime joinedAt;

  /// The first letters of the first two words of [name], for an avatar.
  String get initials => _initials(name);
}

/// Where an order is in payment and fulfillment.
enum FortalDashboardOrderStatus { paid, pending, shipped, refunded, cancelled }

/// One row in the orders table.
final class FortalDashboardOrder {
  const FortalDashboardOrder({
    required this.id,
    required this.customer,
    required this.edition,
    required this.date,
    required this.amount,
    required this.status,
    required this.channel,
  });

  /// The order identifier.
  final String id;

  /// The customer's name.
  final String customer;

  /// The title of the edition ordered.
  final String edition;

  /// When the order was placed.
  final DateTime date;

  /// The order total, in dollars.
  final double amount;

  /// The order status.
  final FortalDashboardOrderStatus status;

  /// The channel the order came through.
  final String channel;
}

/// The category of an activity feed event.
enum FortalDashboardActivityKind { customer, order, payment, alert, release }

/// One event in the activity feed.
final class FortalDashboardActivity {
  const FortalDashboardActivity({
    required this.title,
    required this.detail,
    required this.relativeTime,
    required this.kind,
  });

  /// A short headline.
  final String title;

  /// One line of supporting text.
  final String detail;

  /// When it happened, relative to now, such as `12 min ago`.
  final String relativeTime;

  /// The event's category.
  final FortalDashboardActivityKind kind;
}

/// A target the studio is working toward.
final class FortalDashboardGoal {
  const FortalDashboardGoal({
    required this.label,
    required this.value,
    required this.detail,
  });

  /// What the goal tracks.
  final String label;

  /// Progress from 0 to 1.
  final double value;

  /// Where the goal stands, in words.
  final String detail;
}

/// Someone on the studio team.
final class FortalDashboardMember {
  const FortalDashboardMember({
    required this.name,
    required this.role,
    required this.accent,
    this.online = false,
  });

  /// The member's full name.
  final String name;

  /// What they do.
  final String role;

  /// The tint of their avatar.
  final FortalAccentColor accent;

  /// Whether they are active right now.
  final bool online;

  /// The first letters of the first two words of [name], for an avatar.
  String get initials => _initials(name);
}

/// What kind of thing is on the studio calendar.
enum FortalDashboardEventKind {
  release('Release'),
  proof('Proof'),
  pickup('Pickup'),
  studio('Studio');

  const FortalDashboardEventKind(this.label);

  /// The kind as shown on a badge.
  final String label;
}

/// Something on the studio calendar.
final class FortalDashboardEvent {
  const FortalDashboardEvent({
    required this.title,
    required this.date,
    required this.time,
    required this.kind,
  });

  /// What is happening.
  final String title;

  /// The day it happens.
  final DateTime date;

  /// The time of day, in words.
  final String time;

  /// What kind of event it is.
  final FortalDashboardEventKind kind;
}

/// Everything the dashboard shows. Local, deterministic and meant to be
/// replaced with your own records after install.
final class FortalDashboardData {
  const FortalDashboardData({
    required this.metrics,
    required this.revenue,
    required this.channels,
    required this.weeks,
    required this.editions,
    required this.customers,
    required this.orders,
    required this.activities,
    required this.goals,
    required this.team,
    required this.events,
    required this.today,
  });

  /// The headline metric cards.
  final List<FortalDashboardMetric> metrics;

  /// The revenue series for each reporting window.
  final Map<FortalDashboardRange, List<FortalDashboardPoint>> revenue;

  /// Revenue by sales channel.
  final List<FortalDashboardChannel> channels;

  /// Weekly orders by channel, oldest first.
  final List<FortalDashboardWeek> weeks;

  /// The collection. The first edition is the featured one.
  final List<FortalDashboardEdition> editions;

  /// The customers table rows.
  final List<FortalDashboardCustomer> customers;

  /// The orders table rows, newest first.
  final List<FortalDashboardOrder> orders;

  /// The activity feed, newest first.
  final List<FortalDashboardActivity> activities;

  /// The studio's targets.
  final List<FortalDashboardGoal> goals;

  /// The studio team.
  final List<FortalDashboardMember> team;

  /// The studio calendar, soonest first.
  final List<FortalDashboardEvent> events;

  /// The day the sample is set on. Everything dated is relative to it.
  final DateTime today;

  /// The events on [today] or after it, soonest first.
  List<FortalDashboardEvent> get upcoming => [
    for (final event in events)
      if (!event.date.isBefore(today)) event,
  ];

  /// Total revenue over [range], in thousands of dollars.
  double revenueTotal(FortalDashboardRange range) =>
      revenue[range]!.fold(0, (sum, point) => sum + point.value);

  /// Total revenue over the window before [range], in thousands of dollars.
  double previousRevenueTotal(FortalDashboardRange range) =>
      revenue[range]!.fold(0, (sum, point) => sum + point.previous);

  /// The change in revenue over [range], such as `+12.4%`.
  String revenueDelta(FortalDashboardRange range) {
    final previous = previousRevenueTotal(range);
    if (previous == 0) return '0.0%';
    final change = (revenueTotal(range) - previous) / previous * 100;
    return '${change >= 0 ? '+' : ''}${change.toStringAsFixed(1)}%';
  }
}

const _monthAbbreviations = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

final _thousands = RegExp(r'\B(?=(\d{3})+$)');

/// The abbreviated month of [date], for example `Jul`.
String fortalDashboardMonth(DateTime date) =>
    _monthAbbreviations[date.month - 1];

const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

/// Formats [date] as a weekday and day, for example `Sat, Jul 18`.
String fortalDashboardDay(DateTime date) =>
    '${_weekdays[date.weekday - 1]}, ${fortalDashboardMonth(date)} ${date.day}';

/// Formats [date] as a short US date, for example `Jul 18, 2026`.
String fortalDashboardShortDate(DateTime date) =>
    '${_monthAbbreviations[date.month - 1]} ${date.day}, ${date.year}';

/// Formats [value] with thousands separators, for example `2,420`.
String fortalDashboardCount(int value) =>
    '${value < 0 ? '-' : ''}'
    '${value.abs().toString().replaceAllMapped(_thousands, (_) => ',')}';

/// Formats [value] as US dollars with thousands separators, for example
/// `$1,249.00`. Whole amounts drop the cents when [cents] is false.
String fortalDashboardCurrency(double value, {bool cents = true}) {
  final fixed = value.abs().toStringAsFixed(cents ? 2 : 0);
  final dot = fixed.indexOf('.');
  final whole = (dot < 0 ? fixed : fixed.substring(0, dot)).replaceAllMapped(
    _thousands,
    (_) => ',',
  );
  return '${value < 0 ? '-' : ''}\$$whole${dot < 0 ? '' : fixed.substring(dot)}';
}

/// Formats [thousands] of dollars compactly, for example `$84.4K` or `$1.2M`.
String fortalDashboardCompactCurrency(double thousands) => thousands >= 1000
    ? '\$${(thousands / 1000).toStringAsFixed(2)}M'
    : '\$${thousands.toStringAsFixed(1)}K';

FortalDashboardCustomer _customer(
  String id,
  String name,
  String email,
  String city,
  FortalDashboardCustomerTier tier,
  FortalDashboardCustomerStatus status,
  int orders,
  double spent,
  int month,
  int day,
) => FortalDashboardCustomer(
  id: id,
  name: name,
  email: email,
  city: city,
  tier: tier,
  status: status,
  orders: orders,
  spent: spent,
  joinedAt: DateTime(2025, month, day),
);

FortalDashboardOrder _order(
  String id,
  String customer,
  String edition,
  int month,
  int day,
  double amount,
  FortalDashboardOrderStatus status,
  String channel,
) => FortalDashboardOrder(
  id: id,
  customer: customer,
  edition: edition,
  date: DateTime(2026, month, day),
  amount: amount,
  status: status,
  channel: channel,
);

FortalDashboardEvent _event(
  String title,
  int month,
  int day,
  String time,
  FortalDashboardEventKind kind,
) => FortalDashboardEvent(
  title: title,
  date: DateTime(2026, month, day),
  time: time,
  kind: kind,
);

/// The editable sample data every page renders by default.
final fortalDashboardSampleData = FortalDashboardData(
  metrics: const [
    FortalDashboardMetric(
      id: 'orders',
      label: 'Orders',
      value: '1,284',
      delta: '+8.2%',
      trend: [32, 38, 35, 44, 41, 52, 49, 58, 61, 57, 66, 72],
    ),
    FortalDashboardMetric(
      id: 'collectors',
      label: 'Active collectors',
      value: '2,420',
      delta: '+5.1%',
      trend: [210, 214, 221, 219, 226, 231, 229, 236, 240, 238, 241, 242],
    ),
    FortalDashboardMetric(
      id: 'order-value',
      label: 'Avg. order value',
      value: r'$318',
      delta: '-2.3%',
      positive: false,
      trend: [340, 336, 342, 331, 328, 334, 325, 322, 327, 319, 321, 318],
    ),
    FortalDashboardMetric(
      id: 'fulfillment',
      label: 'Shipped on time',
      value: '94.2%',
      delta: '+4.1%',
      trend: [86, 88, 87, 90, 89, 91, 92, 91, 93, 92, 94, 94.2],
      progress: 0.942,
    ),
  ],
  revenue: const {
    FortalDashboardRange.week: [
      FortalDashboardPoint('Mon', 9.2, 8.1),
      FortalDashboardPoint('Tue', 11.4, 9.6),
      FortalDashboardPoint('Wed', 10.1, 10.4),
      FortalDashboardPoint('Thu', 12.8, 10.9),
      FortalDashboardPoint('Fri', 12.2, 11.2),
      FortalDashboardPoint('Sat', 13.9, 12.0),
      FortalDashboardPoint('Sun', 14.8, 12.9),
    ],
    FortalDashboardRange.month: [
      FortalDashboardPoint('Jun 19', 24.0, 22.5),
      FortalDashboardPoint('Jun 22', 27.5, 23.8),
      FortalDashboardPoint('Jun 25', 26.1, 25.9),
      FortalDashboardPoint('Jun 28', 31.2, 26.4),
      FortalDashboardPoint('Jul 1', 29.8, 28.0),
      FortalDashboardPoint('Jul 4', 34.6, 29.3),
      FortalDashboardPoint('Jul 7', 33.1, 30.7),
      FortalDashboardPoint('Jul 10', 37.9, 31.5),
      FortalDashboardPoint('Jul 13', 36.4, 33.2),
      FortalDashboardPoint('Jul 16', 41.8, 34.9),
    ],
    FortalDashboardRange.quarter: [
      FortalDashboardPoint('Apr 20', 58.0, 51.0),
      FortalDashboardPoint('Apr 27', 61.5, 54.2),
      FortalDashboardPoint('May 4', 57.9, 56.0),
      FortalDashboardPoint('May 11', 66.2, 55.1),
      FortalDashboardPoint('May 18', 70.4, 59.8),
      FortalDashboardPoint('May 25', 68.1, 62.3),
      FortalDashboardPoint('Jun 1', 74.9, 63.0),
      FortalDashboardPoint('Jun 8', 73.2, 66.7),
      FortalDashboardPoint('Jun 15', 79.6, 68.1),
      FortalDashboardPoint('Jun 22', 77.8, 70.4),
      FortalDashboardPoint('Jun 29', 83.5, 71.9),
      FortalDashboardPoint('Jul 6', 82.0, 74.6),
      FortalDashboardPoint('Jul 13', 88.4, 76.2),
    ],
  },
  channels: const [
    FortalDashboardChannel(
      id: 'studio',
      label: 'Studio store',
      share: 46,
      revenue: 38830,
      delta: '+9.4%',
    ),
    FortalDashboardChannel(
      id: 'galleries',
      label: 'Galleries',
      share: 31,
      revenue: 26170,
      delta: '+3.1%',
    ),
    FortalDashboardChannel(
      id: 'marketplace',
      label: 'Marketplace',
      share: 23,
      revenue: 19420,
      delta: '-1.8%',
    ),
  ],
  weeks: const [
    FortalDashboardWeek('Jun 8', [58, 34, 26]),
    FortalDashboardWeek('Jun 15', [64, 38, 24]),
    FortalDashboardWeek('Jun 22', [61, 41, 29]),
    FortalDashboardWeek('Jun 29', [72, 39, 27]),
    FortalDashboardWeek('Jul 6', [70, 46, 31]),
    FortalDashboardWeek('Jul 13', [81, 44, 28]),
  ],
  editions: const [
    FortalDashboardEdition(
      id: 'duna-branca',
      title: 'Duna Branca',
      series: 'Litoral',
      artist: 'Lia Moreira',
      price: 480,
      sold: 82,
      editionSize: 120,
      status: .live,
      motif: .dunes,
      accent: .duna,
      format: '50 × 70 cm · Giclée',
      description:
          'Wind-cut dunes at the edge of Jericoacoara, printed on cotton rag.',
    ),
    FortalDashboardEdition(
      id: 'mar-aberto',
      title: 'Mar Aberto',
      series: 'Litoral',
      artist: 'Tomás Braga',
      price: 360,
      sold: 141,
      editionSize: 150,
      status: .lowStock,
      motif: .waves,
      accent: .mar,
      format: '40 × 50 cm · Risograph',
      description:
          'Five layers of green water, each one pulled by hand in the studio.',
    ),
    FortalDashboardEdition(
      id: 'sol-a-pino',
      title: 'Sol a Pino',
      series: 'Meio-dia',
      artist: 'Ana Cavalcante',
      price: 420,
      sold: 96,
      editionSize: 200,
      status: .live,
      motif: .sun,
      accent: .sol,
      format: '50 × 70 cm · Screen print',
      description: 'The noon sun over the equator, reduced to seven rings.',
    ),
    FortalDashboardEdition(
      id: 'serra-grande',
      title: 'Serra Grande',
      series: 'Sertão',
      artist: 'Rui Feitosa',
      price: 540,
      sold: 60,
      editionSize: 60,
      status: .soldOut,
      motif: .peaks,
      accent: .serra,
      format: '60 × 80 cm · Giclée',
      description: 'The Ibiapaba ridge at first light, seen from the plain.',
    ),
    FortalDashboardEdition(
      id: 'ceu-de-agosto',
      title: 'Céu de Agosto',
      series: 'Meio-dia',
      artist: 'Ana Cavalcante',
      price: 390,
      sold: 48,
      editionSize: 180,
      status: .live,
      motif: .arches,
      accent: .ceu,
      format: '50 × 70 cm · Screen print',
      description: 'August wind and kite season, drawn as stacked arches.',
    ),
    FortalDashboardEdition(
      id: 'cobogo-1',
      title: 'Cobogó Nº 1',
      series: 'Cobogó',
      artist: 'Lia Moreira',
      price: 280,
      sold: 174,
      editionSize: 250,
      status: .live,
      motif: .cobogo,
      accent: .caju,
      format: '30 × 40 cm · Risograph',
      description:
          'The breeze blocks of Fortaleza façades, one tile at a time.',
      seed: 3,
    ),
    FortalDashboardEdition(
      id: 'caju-maduro',
      title: 'Caju Maduro',
      series: 'Sertão',
      artist: 'Rui Feitosa',
      price: 340,
      sold: 112,
      editionSize: 120,
      status: .lowStock,
      motif: .sun,
      accent: .caju,
      format: '40 × 50 cm · Screen print',
      description: 'Cashew season in one colour and its shadow.',
      seed: 5,
    ),
    FortalDashboardEdition(
      id: 'orla-6h',
      title: 'Orla, 6h',
      series: 'Litoral',
      artist: 'Tomás Braga',
      price: 310,
      sold: 37,
      editionSize: 150,
      status: .live,
      motif: .waves,
      accent: .orla,
      format: '40 × 50 cm · Risograph',
      description: 'The seafront before the city wakes, in graphite and fog.',
      seed: 2,
    ),
    FortalDashboardEdition(
      id: 'cobogo-2',
      title: 'Cobogó Nº 2',
      series: 'Cobogó',
      artist: 'Lia Moreira',
      price: 280,
      sold: 121,
      editionSize: 250,
      status: .live,
      motif: .cobogo,
      accent: .mar,
      format: '30 × 40 cm · Risograph',
      description: 'A second façade study, cooler and more open.',
      seed: 11,
    ),
    FortalDashboardEdition(
      id: 'jangada',
      title: 'Jangada',
      series: 'Litoral',
      artist: 'Tomás Braga',
      price: 450,
      sold: 0,
      editionSize: 100,
      status: .draft,
      motif: .peaks,
      accent: .ceu,
      format: '50 × 70 cm · Giclée',
      description: 'Raft sails against the afternoon, releasing in August.',
      seed: 4,
    ),
    FortalDashboardEdition(
      id: 'praia-do-futuro',
      title: 'Praia do Futuro',
      series: 'Litoral',
      artist: 'Ana Cavalcante',
      price: 400,
      sold: 64,
      editionSize: 140,
      status: .live,
      motif: .dunes,
      accent: .sol,
      format: '50 × 70 cm · Giclée',
      description: 'Low tide, long shadows and the first beach huts.',
      seed: 7,
    ),
    FortalDashboardEdition(
      id: 'cobogo-3',
      title: 'Cobogó Nº 3',
      series: 'Cobogó',
      artist: 'Lia Moreira',
      price: 280,
      sold: 0,
      editionSize: 250,
      status: .draft,
      motif: .cobogo,
      accent: .serra,
      format: '30 × 40 cm · Risograph',
      description: 'The third study in the series, proofing now.',
      seed: 19,
    ),
  ],
  customers: [
    _customer(
      'cus_001',
      'Olivia Martin',
      'olivia@northstar.co',
      'Lisbon',
      .patron,
      .active,
      14,
      6120,
      1,
      8,
    ),
    _customer(
      'cus_002',
      'Jackson Lee',
      'jackson@monument.dev',
      'Toronto',
      .collector,
      .active,
      7,
      2540,
      1,
      21,
    ),
    _customer(
      'cus_003',
      'Sophia Brown',
      'sophia@loomworks.io',
      'London',
      .member,
      .invited,
      0,
      0,
      2,
      4,
    ),
    _customer(
      'cus_004',
      'Noah Williams',
      'noah@horizon.studio',
      'Berlin',
      .patron,
      .active,
      11,
      4980,
      2,
      18,
    ),
    _customer(
      'cus_005',
      'Emma Davis',
      'emma@fieldnote.co',
      'Austin',
      .collector,
      .paused,
      4,
      1310,
      3,
      2,
    ),
    _customer(
      'cus_006',
      'Liam Garcia',
      'liam@kindred.app',
      'Madrid',
      .member,
      .active,
      2,
      640,
      3,
      14,
    ),
    _customer(
      'cus_007',
      'Ava Wilson',
      'ava@brightpath.com',
      'New York',
      .patron,
      .active,
      16,
      7460,
      4,
      1,
    ),
    _customer(
      'cus_008',
      'Ethan Martinez',
      'ethan@paperplane.dev',
      'Mexico City',
      .collector,
      .invited,
      0,
      0,
      4,
      11,
    ),
    _customer(
      'cus_009',
      'Mia Anderson',
      'mia@evergreen.design',
      'Stockholm',
      .member,
      .active,
      3,
      880,
      4,
      29,
    ),
    _customer(
      'cus_010',
      'Lucas Thomas',
      'lucas@relaylabs.io',
      'São Paulo',
      .collector,
      .active,
      8,
      2910,
      5,
      7,
    ),
    _customer(
      'cus_011',
      'Isabella Taylor',
      'isabella@assembly.co',
      'Milan',
      .patron,
      .active,
      12,
      5330,
      5,
      23,
    ),
    _customer(
      'cus_012',
      'Mason Moore',
      'mason@oakline.com',
      'Chicago',
      .member,
      .paused,
      1,
      280,
      6,
      3,
    ),
    _customer(
      'cus_013',
      'Amelia Jackson',
      'amelia@archway.dev',
      'Dublin',
      .collector,
      .active,
      6,
      2300,
      6,
      19,
    ),
    _customer(
      'cus_014',
      'Logan White',
      'logan@stillwater.io',
      'Sydney',
      .patron,
      .invited,
      0,
      0,
      7,
      2,
    ),
    _customer(
      'cus_015',
      'Harper Harris',
      'harper@wildwood.co',
      'Portland',
      .collector,
      .active,
      5,
      1870,
      7,
      17,
    ),
    _customer(
      'cus_016',
      'Elijah Clark',
      'elijah@commonthread.app',
      'Cape Town',
      .member,
      .active,
      2,
      590,
      8,
      5,
    ),
    _customer(
      'cus_017',
      'Evelyn Lewis',
      'evelyn@sunroom.design',
      'Paris',
      .patron,
      .active,
      10,
      4420,
      8,
      22,
    ),
    _customer(
      'cus_018',
      'James Walker',
      'james@granite.dev',
      'Denver',
      .collector,
      .paused,
      3,
      1020,
      9,
      9,
    ),
    _customer(
      'cus_019',
      'Luna Hall',
      'luna@afterglow.co',
      'Fortaleza',
      .member,
      .active,
      2,
      560,
      9,
      25,
    ),
    _customer(
      'cus_020',
      'Benjamin Allen',
      'ben@wayfinder.io',
      'Amsterdam',
      .patron,
      .active,
      13,
      5890,
      10,
      8,
    ),
    _customer(
      'cus_021',
      'Sofia Young',
      'sofia@roam.studio',
      'Barcelona',
      .collector,
      .invited,
      0,
      0,
      10,
      24,
    ),
    _customer(
      'cus_022',
      'Henry King',
      'henry@tandem.app',
      'Seattle',
      .member,
      .active,
      1,
      310,
      11,
      6,
    ),
    _customer(
      'cus_023',
      'Camila Wright',
      'camila@workbench.co',
      'Recife',
      .patron,
      .active,
      9,
      3960,
      11,
      21,
    ),
    _customer(
      'cus_024',
      'Alexander Scott',
      'alex@signalworks.dev',
      'Edinburgh',
      .collector,
      .active,
      6,
      2150,
      12,
      4,
    ),
  ],
  orders: [
    _order(
      'ORD-1048',
      'Olivia Martin',
      'Duna Branca',
      7,
      18,
      960,
      .paid,
      'Studio store',
    ),
    _order(
      'ORD-1047',
      'Jackson Lee',
      'Mar Aberto',
      7,
      17,
      360,
      .pending,
      'Marketplace',
    ),
    _order(
      'ORD-1046',
      'Ava Wilson',
      'Serra Grande',
      7,
      16,
      1620,
      .shipped,
      'Galleries',
    ),
    _order(
      'ORD-1045',
      'Emma Davis',
      'Cobogó Nº 1',
      7,
      15,
      280,
      .refunded,
      'Studio store',
    ),
    _order(
      'ORD-1044',
      'Noah Williams',
      'Sol a Pino',
      7,
      13,
      840,
      .paid,
      'Studio store',
    ),
    _order(
      'ORD-1043',
      'Mia Anderson',
      'Orla, 6h',
      7,
      12,
      310,
      .cancelled,
      'Marketplace',
    ),
    _order(
      'ORD-1042',
      'Lucas Thomas',
      'Caju Maduro',
      7,
      10,
      680,
      .shipped,
      'Studio store',
    ),
    _order(
      'ORD-1041',
      'Isabella Taylor',
      'Duna Branca',
      7,
      9,
      1440,
      .pending,
      'Galleries',
    ),
    _order(
      'ORD-1040',
      'Liam Garcia',
      'Cobogó Nº 2',
      7,
      8,
      280,
      .paid,
      'Marketplace',
    ),
    _order(
      'ORD-1039',
      'Harper Harris',
      'Céu de Agosto',
      7,
      6,
      780,
      .shipped,
      'Studio store',
    ),
    _order(
      'ORD-1038',
      'Mason Moore',
      'Cobogó Nº 1',
      7,
      4,
      280,
      .refunded,
      'Marketplace',
    ),
    _order(
      'ORD-1037',
      'Amelia Jackson',
      'Serra Grande',
      7,
      2,
      1080,
      .paid,
      'Galleries',
    ),
    _order(
      'ORD-1036',
      'Benjamin Allen',
      'Praia do Futuro',
      6,
      30,
      800,
      .pending,
      'Studio store',
    ),
    _order(
      'ORD-1035',
      'Evelyn Lewis',
      'Sol a Pino',
      6,
      28,
      840,
      .shipped,
      'Galleries',
    ),
    _order(
      'ORD-1034',
      'James Walker',
      'Mar Aberto',
      6,
      26,
      360,
      .cancelled,
      'Marketplace',
    ),
    _order(
      'ORD-1033',
      'Luna Hall',
      'Cobogó Nº 2',
      6,
      24,
      280,
      .paid,
      'Studio store',
    ),
    _order(
      'ORD-1032',
      'Ava Wilson',
      'Duna Branca',
      6,
      22,
      1920,
      .shipped,
      'Galleries',
    ),
    _order(
      'ORD-1031',
      'Camila Wright',
      'Caju Maduro',
      6,
      20,
      680,
      .pending,
      'Studio store',
    ),
    _order(
      'ORD-1030',
      'Henry King',
      'Orla, 6h',
      6,
      18,
      310,
      .paid,
      'Marketplace',
    ),
    _order(
      'ORD-1029',
      'Olivia Martin',
      'Céu de Agosto',
      6,
      16,
      1170,
      .refunded,
      'Studio store',
    ),
    _order(
      'ORD-1028',
      'Alexander Scott',
      'Sol a Pino',
      6,
      14,
      420,
      .shipped,
      'Studio store',
    ),
    _order(
      'ORD-1027',
      'Elijah Clark',
      'Cobogó Nº 1',
      6,
      12,
      280,
      .pending,
      'Marketplace',
    ),
    _order(
      'ORD-1026',
      'Noah Williams',
      'Serra Grande',
      6,
      10,
      1620,
      .paid,
      'Galleries',
    ),
    _order(
      'ORD-1025',
      'Harper Harris',
      'Mar Aberto',
      6,
      8,
      360,
      .cancelled,
      'Marketplace',
    ),
    _order(
      'ORD-1024',
      'Isabella Taylor',
      'Praia do Futuro',
      6,
      6,
      800,
      .shipped,
      'Studio store',
    ),
    _order(
      'ORD-1023',
      'Lucas Thomas',
      'Sol a Pino',
      6,
      4,
      420,
      .paid,
      'Studio store',
    ),
    _order(
      'ORD-1022',
      'Benjamin Allen',
      'Duna Branca',
      6,
      2,
      1440,
      .pending,
      'Galleries',
    ),
    _order(
      'ORD-1021',
      'Mia Anderson',
      'Cobogó Nº 2',
      5,
      30,
      280,
      .refunded,
      'Marketplace',
    ),
    _order(
      'ORD-1020',
      'Evelyn Lewis',
      'Caju Maduro',
      5,
      28,
      1020,
      .shipped,
      'Galleries',
    ),
    _order(
      'ORD-1019',
      'Camila Wright',
      'Céu de Agosto',
      5,
      26,
      390,
      .paid,
      'Studio store',
    ),
  ],
  activities: const [
    FortalDashboardActivity(
      title: 'New collector',
      detail: 'Camila Wright joined as a Patron',
      relativeTime: '12 min ago',
      kind: .customer,
    ),
    FortalDashboardActivity(
      title: 'Payment received',
      detail: r'ORD-1048 · $960.00',
      relativeTime: '38 min ago',
      kind: .payment,
    ),
    FortalDashboardActivity(
      title: 'Edition running low',
      detail: 'Mar Aberto has 9 prints left',
      relativeTime: '1 hr ago',
      kind: .alert,
    ),
    FortalDashboardActivity(
      title: 'Order shipped',
      detail: 'ORD-1046 is on its way to Ava Wilson',
      relativeTime: '3 hrs ago',
      kind: .order,
    ),
    FortalDashboardActivity(
      title: 'Release scheduled',
      detail: 'Jangada goes live on Aug 4',
      relativeTime: '5 hrs ago',
      kind: .release,
    ),
    FortalDashboardActivity(
      title: 'Refund processed',
      detail: r'ORD-1045 · $280.00',
      relativeTime: 'Yesterday',
      kind: .payment,
    ),
  ],
  goals: const [
    FortalDashboardGoal(
      label: 'Quarterly revenue',
      value: 0.78,
      detail: r'$941K of $1.2M',
    ),
    FortalDashboardGoal(
      label: 'New collectors',
      value: 0.64,
      detail: '320 of 500',
    ),
    FortalDashboardGoal(
      label: 'Editions released',
      value: 0.9,
      detail: '9 of 10',
    ),
  ],
  team: const [
    FortalDashboardMember(
      name: 'Leo Farias',
      role: 'Studio director',
      accent: .orla,
      online: true,
    ),
    FortalDashboardMember(
      name: 'Lia Moreira',
      role: 'Artist',
      accent: .caju,
      online: true,
    ),
    FortalDashboardMember(name: 'Tomás Braga', role: 'Printer', accent: .mar),
    FortalDashboardMember(
      name: 'Ana Cavalcante',
      role: 'Artist',
      accent: .sol,
      online: true,
    ),
    FortalDashboardMember(
      name: 'Rui Feitosa',
      role: 'Fulfillment',
      accent: .ceu,
    ),
  ],
  events: [
    _event('Print run · Praia do Futuro', 7, 14, '9:00 AM', .studio),
    _event('Proof review · Cobogó Nº 3', 7, 18, '2:00 PM', .proof),
    _event('Studio visit · Olivia Martin', 7, 18, '4:30 PM', .studio),
    _event('Gallery pickup · Serra Grande', 7, 21, '10:30 AM', .pickup),
    _event('Frame delivery', 7, 24, '1:00 PM', .studio),
    _event('Proof review · Jangada', 7, 28, '11:00 AM', .proof),
    _event('Release · Jangada', 8, 4, '9:00 AM', .release),
    _event('Gallery pickup · Mar Aberto', 8, 7, '3:00 PM', .pickup),
    _event('Release · Cobogó Nº 3', 8, 18, '9:00 AM', .release),
  ],
  today: DateTime(2026, 7, 18),
);
