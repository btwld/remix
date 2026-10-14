import 'package:flutter/widgets.dart';

import 'dashboard_demo_base.dart';
import 'dashboard_sample_data.dart';

/// Preset-specific widgets used by the shared dashboard demo content.
///
/// The content and information architecture stay identical across presets;
/// each implementation maps these slots to its own public recipes and enums.
abstract interface class RegistryDashboardDemoKit {
  Widget pageHeader(String title, String description);

  Widget charts(RegistryDashboardSampleData data);
}

/// Shared content for the charts showcase destination.
class RegistryDashboardDemoContent extends StatelessWidget {
  const RegistryDashboardDemoContent({
    super.key,
    required this.page,
    required this.kit,
    this.data = registryDashboardSampleData,
  });

  final RegistryDashboardDemoPage page;
  final RegistryDashboardDemoKit kit;
  final RegistryDashboardSampleData data;

  @override
  Widget build(BuildContext context) => RegistryDashboardDemoPageFrame(
    key: ValueKey('dashboard-demo-${page.name}'),
    header: kit.pageHeader(
      page.label,
      'Line, bar, and pie charts styled through the preset recipe.',
    ),
    children: [if (page == .charts) kit.charts(data)],
  );
}
