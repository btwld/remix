import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'ui/ui.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Web paints to canvas; without a live semantics tree the page has no
  // accessible names for browser review or Playwright clicks.
  if (kIsWeb) SemanticsBinding.instance.ensureSemantics();
  runApp(const PlaygroundApp());
}

class AppScrollBehavior extends ScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    ...super.dragDevices,
    PointerDeviceKind.mouse,
  };
}

class PlaygroundApp extends StatelessWidget {
  const PlaygroundApp({super.key, this.mode = PlaygroundThemeMode.light});

  final PlaygroundThemeMode mode;

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      title: 'Remix Playground',
      debugShowCheckedModeBanner: false,
      color: const Color(0xFFFAFAFA),
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) =>
            builder(context),
      ),
      builder: (context, child) => PlaygroundTheme(
        key: const ValueKey('playground-theme-scope'),
        mode: mode,
        child: ScrollConfiguration(
          behavior: const AppScrollBehavior(),
          child: Overlay.wrap(
            child: RemixToastScope(
              style: playgroundToastStyle(),
              child: child!,
            ),
          ),
        ),
      ),
      home: const PlaygroundDashboardDemo(),
    );
  }
}
