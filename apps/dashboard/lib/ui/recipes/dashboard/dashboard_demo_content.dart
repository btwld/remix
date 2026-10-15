import 'package:flutter/widgets.dart';

import 'dashboard_demo_base.dart';

/// Shared page frame for the charts showcase destination.
class UiDashboardDemoContent extends StatelessWidget {
  const UiDashboardDemoContent({
    super.key,
    required this.header,
    required this.child,
  });

  final Widget header;
  final Widget child;

  @override
  Widget build(BuildContext context) => UiDashboardDemoPageFrame(
    key: ValueKey('dashboard-demo-${UiDashboardDemoPage.charts.name}'),
    header: header,
    children: [child],
  );
}
