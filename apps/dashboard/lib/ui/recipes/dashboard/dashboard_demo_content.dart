import 'package:flutter/widgets.dart';

import 'dashboard_demo_base.dart';
import 'dashboard_sample_data.dart';

/// Preset-specific widgets used by the shared dashboard demo content.
///
/// The content and information architecture stay identical across presets;
/// each implementation maps these slots to its own public recipes and enums.
abstract interface class UiDashboardDemoKit {
  Widget pageHeader(String title, String description);

  Widget charts(UiDashboardSampleData data);
}

/// Shared content for the charts showcase destination.
class UiDashboardDemoContent extends StatelessWidget {
  const UiDashboardDemoContent({
    super.key,
    required this.page,
    required this.kit,
    this.data = uiDashboardSampleData,
  });

  final UiDashboardDemoPage page;
  final UiDashboardDemoKit kit;
  final UiDashboardSampleData data;

  @override
  Widget build(BuildContext context) => UiDashboardDemoPageFrame(
    key: ValueKey('dashboard-demo-${page.name}'),
    header: kit.pageHeader(
      page.label,
      'Line, bar, and pie charts styled through the preset recipe.',
    ),
    children: [if (page == .charts) kit.charts(data)],
  );
}
