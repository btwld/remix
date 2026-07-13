import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart' show SemanticsBinding;
import 'package:flutter_web_plugins/url_strategy.dart';

import 'registry/component_registry.dart';
import 'sheets/fortal_viewer.dart';

void main() {
  // Ensure bindings are initialized before enabling semantics
  WidgetsFlutterBinding.ensureInitialized();
  // Use the path URL strategy so `?sheet=&theme=` live in a real query
  // string instead of the `#` fragment. The viewer reads selection from
  // `Uri.base.queryParameters` and browser history; a fragment is invisible to
  // both, which breaks deep links, reload, and back/forward. No-op off web.
  usePathUrlStrategy();
  // Enable accessible semantics for automation tools (e.g., Playwright)
  SemanticsBinding.instance.ensureSemantics();
  runApp(const _App());
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    const defineKey = String.fromEnvironment('COMPONENT', defaultValue: '');
    final queryKey = kIsWeb ? Uri.base.queryParameters['component'] ?? '' : '';
    final key = (defineKey.isNotEmpty ? defineKey : queryKey).toLowerCase();

    // `?component=`/`COMPONENT` direct preview takes precedence over the viewer
    // and needs no URL routing; the viewer owns its own router (MaterialApp.router).
    final builder = components[key];
    if (builder == null) return const FortalViewerApp();

    return MaterialApp(
      home: Scaffold(body: Builder(builder: builder)),
      title: 'Remix Playground',
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
    );
  }
}
