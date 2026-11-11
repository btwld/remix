import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_fonts/remix_ui_fonts.dart';

import 'ui/ui.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Web paints to canvas; without a live semantics tree the page has no
  // accessible names for browser review or Playwright clicks.
  if (kIsWeb) SemanticsBinding.instance.ensureSemantics();
  runApp(const DashboardHeroUiApp());
}

/// Lets a mouse drag scroll the pages, as on the web.
class AppScrollBehavior extends ScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    ...super.dragDevices,
    PointerDeviceKind.mouse,
  };
}

/// HeroUI's theme with the Geist face the registry's fonts package ships.
/// HeroUI web sets no family of its own; the app chooses one so every
/// platform draws the same glyphs.
const lightTheme = UiThemeData.light(fontFamily: RemixFonts.geist);
const darkTheme = UiThemeData.dark(fontFamily: RemixFonts.geist);

/// Mounts the installed HeroUI dashboard demo at the root.
///
/// The theme and toast host sit above the navigator, so the demo's popovers,
/// menus, dialogs, and toasts resolve the installed tokens. The demo's own
/// appearance toggle and Settings page switch light and dark from there.
class DashboardHeroUiApp extends StatelessWidget {
  const DashboardHeroUiApp({super.key, this.mode = UiThemeMode.light});

  final UiThemeMode mode;

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      title: 'Remix HeroUI Dashboard',
      debugShowCheckedModeBanner: false,
      color: const Color(0xFFF5F5F5),
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) =>
            builder(context),
      ),
      builder: (context, child) => UiTheme(
        key: const ValueKey('dashboard-heroui-theme-scope'),
        theme: lightTheme,
        darkTheme: darkTheme,
        mode: mode,
        child: ScrollConfiguration(
          behavior: const AppScrollBehavior(),
          child: Overlay.wrap(
            child: RemixToastScope(style: uiToastStyle(), child: child!),
          ),
        ),
      ),
      home: const UiDashboardDemo(),
    );
  }
}
