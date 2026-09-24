import 'package:flutter/widgets.dart';

import 'ui/ui.dart';

void main() => runApp(const AcmeDashboardApp());

class AcmeDashboardApp extends StatelessWidget {
  const AcmeDashboardApp({super.key});

  @override
  Widget build(BuildContext context) => WidgetsApp(
    color: const Color(0xFFFFFFFF),
    debugShowCheckedModeBanner: false,
    pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    ),
    home: const AcmeDashboardHost(),
  );
}

class AcmeDashboardHost extends StatefulWidget {
  const AcmeDashboardHost({super.key});

  @override
  State<AcmeDashboardHost> createState() => _AcmeDashboardHostState();
}

class _AcmeDashboardHostState extends State<AcmeDashboardHost> {
  bool _dark = false;

  @override
  Widget build(BuildContext context) => AcmeThemeScope(
    mode: _dark ? AcmeThemeMode.dark : AcmeThemeMode.light,
    child: ColoredBox(
      color: _dark ? const Color(0xFF0A0A0A) : const Color(0xFFFFFFFF),
      child: DefaultTextStyle(
        style: TextStyle(
          color: _dark ? const Color(0xFFFAFAFA) : const Color(0xFF171717),
        ),
        child: AcmeDashboardDemo(
          brand: const Text('Northstar'),
          account: const Text('Workspace account'),
          headerActions: [
            Semantics(
              button: true,
              label: 'Toggle theme',
              child: GestureDetector(
                key: const ValueKey('toggle-theme'),
                onTap: () => setState(() => _dark = !_dark),
                child: Text(_dark ? 'Light' : 'Dark'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
