import 'package:demo/helpers/theme_addon.dart';
import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'main.directories.g.dart';

@widgetbook.App()
void main() {
  runApp(const HotReload());
}

class HotReload extends StatelessWidget {
  const HotReload({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      addons: [
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(
              name: 'Light',
              data: ThemeData.light(),
            ),
            WidgetbookTheme(
              name: 'Dark',
              data: ThemeData.dark(),
            ),
          ],
          initialTheme: WidgetbookTheme(
            name: 'Light',
            data: ThemeData.light(),
          ),
        ),
        BuilderAddon(
          name: 'brightness',
          builder: (context, child) {
            final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
            return MediaQuery(
              data: MediaQueryData(
                  platformBrightness:
                      isDarkTheme ? Brightness.dark : Brightness.light),
              child: Container(
                color: isDarkTheme ? Colors.black87 : Colors.white,
                child: Center(child: child),
              ),
            );
          },
        ),
        RemixComponentThemeAddon(
          themes: [
            WidgetbookTheme(
              name: 'Fortaleza',
              data: (
                dark: RemixComponentTheme.fortalezaDark(),
                light: RemixComponentTheme.fortalezaLight()
              ),
            ),
            WidgetbookTheme(
              name: 'Base',
              data: (
                dark: RemixComponentTheme.base(),
                light: RemixComponentTheme.base(),
              ),
            ),
          ],
        ),
        InspectorAddon(),
      ],
      appBuilder: (context, child) => App(child: child),
      directories: directories,
    );
  }
}

class App extends StatelessWidget {
  const App({
    super.key,
    required this.child,
  });

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return RemixTheme(
      theme: RemixThemeData.base(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: child),
        ),
      ),
    );
  }
}
