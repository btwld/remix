import 'package:flutter/widgets.dart';
import 'package:demo/ui/ui.dart';
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
    return Widgetbook(
      addons: [FortalThemeAddon()],
      appBuilder: (context, child) => child,
      directories: directories,
    );
  }
}

class FortalThemeAddon extends ThemeAddon<FortalThemeMode> {
  FortalThemeAddon()
    : super(
        themes: [
          WidgetbookTheme(name: 'light', data: FortalThemeMode.light),
          WidgetbookTheme(name: 'dark', data: FortalThemeMode.dark),
        ],
        themeBuilder: (context, mode, child) =>
            FortalTheme(mode: mode, child: child),
      );
}
