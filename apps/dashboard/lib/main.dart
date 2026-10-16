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
  runApp(const DashboardApp());
}

class AppScrollBehavior extends ScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    ...super.dragDevices,
    PointerDeviceKind.mouse,
  };
}

class DashboardApp extends StatefulWidget {
  const DashboardApp({
    super.key,
    this.initialSettings = const UiThemeSettings(),
  });

  final UiThemeSettings initialSettings;

  @override
  State<DashboardApp> createState() => _DashboardAppState();
}

class _DashboardAppState extends State<DashboardApp> {
  late UiThemeSettings _settings = widget.initialSettings;

  @override
  Widget build(BuildContext context) {
    return UiDashboardThemeScope(
      settings: _settings,
      onChanged: (settings) => setState(() => _settings = settings),
      child: WidgetsApp(
        title: 'Dashboard',
        debugShowCheckedModeBanner: false,
        color: const Color(0xFFF8FAFC),
        pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
        ),
        // UiTheme goes *below* WidgetsApp and *above* the Navigator.
        //
        // `builder` wraps the whole Navigator, so this placement reaches
        // pushed routes and dialogs. A nearer DefaultTextStyle retains its
        // normal priority through Flutter's inheritance.
        builder: (context, child) => UiTheme(
          key: const ValueKey('dashboard-theme-scope'),
          accent: _settings.accentColor,
          gray: _settings.grayColor,
          mode: _settings.appearance,
          panelBackground: _settings.panelBackground,
          radius: _settings.radius,
          scaling: _settings.scaling,
          // RemixToastScope sits above the Navigator, in its own Overlay, so
          // showRemixToast() works from every route, including dialogs and
          // the compact navigation sheet. It inherits the live Fortal tokens
          // UiTheme publishes above.
          //
          // WidgetsApp has no `scrollBehavior`, so the behavior MaterialApp
          // used to install is applied explicitly here.
          child: ScrollConfiguration(
            behavior: const AppScrollBehavior(),
            child: Overlay.wrap(
              child: RemixToastScope(style: uiToastStyle(), child: child!),
            ),
          ),
        ),
        home: const UiDashboardDemo(),
      ),
    );
  }
}
