import 'package:flutter/widgets.dart';

import 'dashboard_demo_base.dart';

/// Shared page frame for the charts showcase destination.
class RegistryDashboardDemoContent extends StatelessWidget {
  const RegistryDashboardDemoContent({
    super.key,
    required this.header,
    required this.child,
  });

  final Widget header;
  final Widget child;

  @override
  Widget build(BuildContext context) => RegistryDashboardDemoPageFrame(
    key: ValueKey('dashboard-demo-${RegistryDashboardDemoPage.charts.name}'),
    header: header,
    children: [child],
  );
}
