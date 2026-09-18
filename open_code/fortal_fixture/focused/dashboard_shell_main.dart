import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'ui/ui.dart';

void main() => runApp(const AcmeShellApp());

class AcmeShellApp extends StatelessWidget {
  const AcmeShellApp({super.key});

  @override
  Widget build(BuildContext context) => WidgetsApp(
    color: const Color(0xFFFFFFFF),
    pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    ),
    home: const AcmeScope(child: AcmeShellHost()),
  );
}

class AcmeShellHost extends StatefulWidget {
  const AcmeShellHost({super.key});

  @override
  State<AcmeShellHost> createState() => _AcmeShellHostState();
}

class _AcmeShellHostState extends State<AcmeShellHost> {
  String _selected = 'overview';

  @override
  Widget build(BuildContext context) => AcmeDashboardShell<String>(
    sections: const [
      RemixSidebarSection(
        label: 'Workspace',
        destinations: [
          RemixSidebarDestination(value: 'overview', label: 'Overview'),
          RemixSidebarDestination(value: 'reports', label: 'Reports'),
        ],
      ),
    ],
    selectedValue: _selected,
    onSelected: (value) => setState(() => _selected = value),
    body: IndexedStack(
      index: _selected == 'overview' ? 0 : 1,
      children: const [_CounterPage(), Text('Reports page')],
    ),
    title: _selected == 'overview' ? 'Overview' : 'Reports',
    brand: const Text('Northstar'),
  );
}

class _CounterPage extends StatefulWidget {
  const _CounterPage();

  @override
  State<_CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<_CounterPage> {
  int _count = 0;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text('Count $_count'),
      Semantics(
        button: true,
        child: GestureDetector(
          key: const ValueKey('increment'),
          onTap: () => setState(() => _count += 1),
          child: const Text('Increment'),
        ),
      ),
    ],
  );
}
