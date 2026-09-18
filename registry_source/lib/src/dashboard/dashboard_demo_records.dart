enum RegistryDashboardCustomerStatus { active, invited, suspended }

enum RegistryDashboardOrderStatus { paid, pending, refunded, cancelled }

final class RegistryDashboardCustomer {
  const RegistryDashboardCustomer({
    required this.id,
    required this.name,
    required this.email,
    required this.plan,
    required this.status,
    required this.joinedAt,
  });

  final String id;
  final String name;
  final String email;
  final String plan;
  final RegistryDashboardCustomerStatus status;
  final DateTime joinedAt;

  String get initials =>
      name.split(' ').take(2).map((part) => part.substring(0, 1)).join();
}

final class RegistryDashboardOrder {
  const RegistryDashboardOrder({
    required this.id,
    required this.customer,
    required this.date,
    required this.amount,
    required this.status,
  });

  final String id;
  final String customer;
  final DateTime date;
  final double amount;
  final RegistryDashboardOrderStatus status;
}

RegistryDashboardCustomer _customer(
  String id,
  String name,
  String email,
  String plan,
  RegistryDashboardCustomerStatus status,
  int month,
  int day,
) => RegistryDashboardCustomer(
  id: id,
  name: name,
  email: email,
  plan: plan,
  status: status,
  joinedAt: DateTime(2025, month, day),
);

final registryDashboardCustomers = <RegistryDashboardCustomer>[
  _customer(
    'cus_001',
    'Olivia Martin',
    'olivia@northstar.co',
    'Business',
    .active,
    1,
    8,
  ),
  _customer(
    'cus_002',
    'Jackson Lee',
    'jackson@monument.dev',
    'Pro',
    .active,
    1,
    21,
  ),
  _customer(
    'cus_003',
    'Sophia Brown',
    'sophia@loomworks.io',
    'Starter',
    .invited,
    2,
    4,
  ),
  _customer(
    'cus_004',
    'Noah Williams',
    'noah@horizon.studio',
    'Business',
    .active,
    2,
    18,
  ),
  _customer(
    'cus_005',
    'Emma Davis',
    'emma@fieldnote.co',
    'Pro',
    .suspended,
    3,
    2,
  ),
  _customer(
    'cus_006',
    'Liam Garcia',
    'liam@kindred.app',
    'Starter',
    .active,
    3,
    14,
  ),
  _customer(
    'cus_007',
    'Ava Wilson',
    'ava@brightpath.com',
    'Business',
    .active,
    4,
    1,
  ),
  _customer(
    'cus_008',
    'Ethan Martinez',
    'ethan@paperplane.dev',
    'Pro',
    .invited,
    4,
    11,
  ),
  _customer(
    'cus_009',
    'Mia Anderson',
    'mia@evergreen.design',
    'Starter',
    .active,
    4,
    29,
  ),
  _customer(
    'cus_010',
    'Lucas Thomas',
    'lucas@relaylabs.io',
    'Pro',
    .active,
    5,
    7,
  ),
  _customer(
    'cus_011',
    'Isabella Taylor',
    'isabella@assembly.co',
    'Business',
    .active,
    5,
    23,
  ),
  _customer(
    'cus_012',
    'Mason Moore',
    'mason@oakline.com',
    'Starter',
    .suspended,
    6,
    3,
  ),
  _customer(
    'cus_013',
    'Amelia Jackson',
    'amelia@archway.dev',
    'Pro',
    .active,
    6,
    19,
  ),
  _customer(
    'cus_014',
    'Logan White',
    'logan@stillwater.io',
    'Business',
    .invited,
    7,
    2,
  ),
  _customer(
    'cus_015',
    'Harper Harris',
    'harper@wildwood.co',
    'Pro',
    .active,
    7,
    17,
  ),
  _customer(
    'cus_016',
    'Elijah Clark',
    'elijah@commonthread.app',
    'Starter',
    .active,
    8,
    5,
  ),
  _customer(
    'cus_017',
    'Evelyn Lewis',
    'evelyn@sunroom.design',
    'Business',
    .active,
    8,
    22,
  ),
  _customer(
    'cus_018',
    'James Walker',
    'james@granite.dev',
    'Pro',
    .suspended,
    9,
    9,
  ),
  _customer(
    'cus_019',
    'Luna Hall',
    'luna@afterglow.co',
    'Starter',
    .active,
    9,
    25,
  ),
  _customer(
    'cus_020',
    'Benjamin Allen',
    'ben@wayfinder.io',
    'Business',
    .active,
    10,
    8,
  ),
  _customer(
    'cus_021',
    'Sofia Young',
    'sofia@roam.studio',
    'Pro',
    .invited,
    10,
    24,
  ),
  _customer(
    'cus_022',
    'Henry King',
    'henry@tandem.app',
    'Starter',
    .active,
    11,
    6,
  ),
  _customer(
    'cus_023',
    'Camila Wright',
    'camila@workbench.co',
    'Business',
    .active,
    11,
    21,
  ),
  _customer(
    'cus_024',
    'Alexander Scott',
    'alex@signalworks.dev',
    'Pro',
    .active,
    12,
    4,
  ),
];

RegistryDashboardOrder _order(
  String id,
  String customer,
  int month,
  int day,
  double amount,
  RegistryDashboardOrderStatus status,
) => RegistryDashboardOrder(
  id: id,
  customer: customer,
  date: DateTime(2026, month, day),
  amount: amount,
  status: status,
);

final registryDashboardOrders = <RegistryDashboardOrder>[
  _order('ORD-1048', 'Olivia Martin', 7, 18, 1249, .paid),
  _order('ORD-1047', 'Jackson Lee', 7, 17, 349, .pending),
  _order('ORD-1046', 'Ava Wilson', 7, 16, 2780, .paid),
  _order('ORD-1045', 'Emma Davis', 7, 15, 189, .refunded),
  _order('ORD-1044', 'Noah Williams', 7, 13, 940, .paid),
  _order('ORD-1043', 'Mia Anderson', 7, 12, 64, .cancelled),
  _order('ORD-1042', 'Lucas Thomas', 7, 10, 512, .paid),
  _order('ORD-1041', 'Isabella Taylor', 7, 9, 1575, .pending),
  _order('ORD-1040', 'Liam Garcia', 7, 8, 128, .paid),
  _order('ORD-1039', 'Harper Harris', 7, 6, 749, .paid),
  _order('ORD-1038', 'Mason Moore', 7, 4, 88, .refunded),
  _order('ORD-1037', 'Amelia Jackson', 7, 2, 2300, .paid),
  _order('ORD-1036', 'Logan White', 6, 30, 419, .pending),
  _order('ORD-1035', 'Evelyn Lewis', 6, 28, 965, .paid),
  _order('ORD-1034', 'James Walker', 6, 26, 210, .cancelled),
  _order('ORD-1033', 'Luna Hall', 6, 24, 145, .paid),
  _order('ORD-1032', 'Benjamin Allen', 6, 22, 3200, .paid),
  _order('ORD-1031', 'Sofia Young', 6, 20, 579, .pending),
  _order('ORD-1030', 'Henry King', 6, 18, 92, .paid),
  _order('ORD-1029', 'Camila Wright', 6, 16, 1180, .refunded),
  _order('ORD-1028', 'Alexander Scott', 6, 14, 680, .paid),
  _order('ORD-1027', 'Sophia Brown', 6, 12, 235, .pending),
  _order('ORD-1026', 'Ethan Martinez', 6, 10, 1640, .paid),
  _order('ORD-1025', 'Elijah Clark', 6, 8, 119, .cancelled),
  _order('ORD-1024', 'Olivia Martin', 6, 6, 890, .paid),
  _order('ORD-1023', 'Ava Wilson', 6, 4, 420, .paid),
  _order('ORD-1022', 'Noah Williams', 6, 2, 1999, .pending),
  _order('ORD-1021', 'Mia Anderson', 5, 30, 79, .refunded),
  _order('ORD-1020', 'Lucas Thomas', 5, 28, 1340, .paid),
  _order('ORD-1019', 'Isabella Taylor', 5, 26, 299, .paid),
];

String registryDashboardShortDate(DateTime date) =>
    '${const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][date.month - 1]} ${date.day}, ${date.year}';

({int page, List<T> items}) registryDashboardPaginate<T>(
  List<T> items, {
  required int page,
  required int rowsPerPage,
}) {
  final pages = (items.length / rowsPerPage).ceil();
  final safePage = pages == 0 ? 0 : page.clamp(0, pages - 1);
  final start = safePage * rowsPerPage;
  final end = (start + rowsPerPage).clamp(0, items.length);
  return (page: safePage, items: items.sublist(start, end));
}
