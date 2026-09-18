import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../ui/ui.dart';

/// Interactive host for the installed default-preset dashboard shell.
class DashboardShellExample extends StatefulWidget {
  const DashboardShellExample({super.key});

  @override
  State<DashboardShellExample> createState() => _DashboardShellExampleState();
}

class _DashboardShellExampleState extends State<DashboardShellExample> {
  String _selected = 'Overview';
  String _query = '';

  static const _projects = [
    ('Website refresh', 'Design review', 'Updated today'),
    ('Customer portal', 'In progress', 'Updated 2 hours ago'),
    ('Mobile experience', 'Planning', 'Updated yesterday'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = PlaygroundTheme.of(context);
    final projects = _projects.where(
      (project) => '${project.$1} ${project.$2}'.toLowerCase().contains(
        _query.toLowerCase(),
      ),
    );

    return DefaultTextStyle(
      style: TextStyle(color: theme.foreground, fontSize: 14),
      child: ColoredBox(
        color: theme.background,
        child: PlaygroundDashboardShell<String>(
          sections: const [
            RemixSidebarSection(
              label: 'Workspace',
              destinations: [
                RemixSidebarDestination(
                  value: 'Overview',
                  label: 'Overview',
                  icon: RemixIcons.home,
                ),
                RemixSidebarDestination(
                  value: 'Projects',
                  label: 'Projects',
                  icon: RemixIcons.stack,
                ),
              ],
            ),
          ],
          selectedValue: _selected,
          onSelected: (value) => setState(() => _selected = value),
          title: _selected,
          brand: const Text(
            'Acme',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          account: const Text('Alex Morgan'),
          searchHintText: 'Search projects…',
          onSearchChanged: (value) => setState(() => _query = value),
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                _selected == 'Overview'
                    ? 'Workspace overview'
                    : 'Your projects',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'A little space to keep your team moving.',
                style: TextStyle(color: theme.mutedForeground),
              ),
              const SizedBox(height: 24),
              if (_selected == 'Overview') ...[
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    for (final metric in [
                      ('Active projects', '3'),
                      ('Team members', '12'),
                      ('Tasks completed', '28'),
                    ])
                      SizedBox(
                        width: 200,
                        child: PlaygroundCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(metric.$1),
                              const SizedBox(height: 12),
                              Text(
                                metric.$2,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
              const Text(
                'Projects',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              if (projects.isEmpty)
                const PlaygroundCard(child: Text('No matching projects.')),
              for (final project in projects)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: PlaygroundCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.$1,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${project.$2} · ${project.$3}',
                          style: TextStyle(color: theme.mutedForeground),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
