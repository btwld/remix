import 'package:flutter/widgets.dart';

import 'dashboard_demo_base.dart';
import 'dashboard_sample_data.dart';

/// Preset-specific widgets used by the shared dashboard demo content.
///
/// The content and information architecture stay identical across presets;
/// each implementation maps these slots to its own public recipes and enums.
abstract interface class PlaygroundDashboardDemoKit {
  Widget pageHeader(String title, String description);

  Widget charts(PlaygroundDashboardSampleData data);
}

/// Shared content for the charts showcase destination.
class PlaygroundDashboardDemoContent extends StatelessWidget {
  const PlaygroundDashboardDemoContent({
    super.key,
    required this.page,
    required this.kit,
    this.data = playgroundDashboardSampleData,
  });

  final PlaygroundDashboardDemoPage page;
  final PlaygroundDashboardDemoKit kit;
  final PlaygroundDashboardSampleData data;

  @override
  Widget build(BuildContext context) => PlaygroundDashboardDemoPageFrame(
    key: ValueKey('dashboard-demo-${page.name}'),
    header: kit.pageHeader(
      page.label,
      'Line, bar, and pie charts styled through the preset recipe.',
    ),
    children: [if (page == .charts) kit.charts(data)],
  );
}
