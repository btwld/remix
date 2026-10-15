import 'package:flutter/widgets.dart';

import 'dashboard_demo_base.dart';

/// Shared page frame for the charts showcase destination.
class PlaygroundDashboardDemoContent extends StatelessWidget {
  const PlaygroundDashboardDemoContent({
    super.key,
    required this.header,
    required this.child,
  });

  final Widget header;
  final Widget child;

  @override
  Widget build(BuildContext context) => PlaygroundDashboardDemoPageFrame(
    key: ValueKey('dashboard-demo-${PlaygroundDashboardDemoPage.charts.name}'),
    header: header,
    children: [child],
  );
}
