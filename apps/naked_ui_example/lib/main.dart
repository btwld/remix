import 'package:flutter/widgets.dart';

import 'registry.dart';
import 'shell/shell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      title: 'Naked Kitchen Sink',
      color: const Color(0xFFFFFBFE),
      textStyle: const TextStyle(fontSize: 14, color: Color(0xFF1C1B1F)),
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) =>
            builder(context),
      ),
      onGenerateRoute: (settings) {
        final name = settings.name ?? '/';
        // Expecting hash URLs on web (/#/component/<id>)
        final path = name.startsWith('/#/') ? name.substring(3) : name;
        final parts = path.split('/').where((p) => p.isNotEmpty).toList();

        if (parts.isEmpty) {
          return _route(const KitchenShell());
        }

        if (parts.length >= 2 &&
            (parts[0] == 'component' || parts[0] == 'embed')) {
          final id = parts[1];
          final demo = DemoRegistry.find(id);
          if (demo != null) {
            return _route(
              KitchenShell(initialDemoId: id, embed: parts[0] == 'embed'),
            );
          }
        }

        // Fallback to index shell
        return _route(const KitchenShell());
      },
      home: const KitchenShell(),
    );
  }
}

/// WidgetsApp has no MaterialPageRoute; this is the plain equivalent.
PageRoute<void> _route(Widget child) => PageRouteBuilder<void>(
  pageBuilder: (context, animation, secondaryAnimation) => child,
);
