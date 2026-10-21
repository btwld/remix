import 'package:flutter/material.dart' hide Scaffold;
import 'package:widgetbook_vanilla/ui/ui.dart';
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
      addons: [VanillaThemeAddon()],
      appBuilder: (context, child) => child,
      directories: directories,
    );
  }
}

class VanillaThemeAddon extends ThemeAddon<ThemeData> {
  VanillaThemeAddon()
    : super(
        themes: [
          WidgetbookTheme(
            name: 'light',
            data: ThemeData(
              brightness: .light,
              scaffoldBackgroundColor: Colors.white,
            ),
          ),
          WidgetbookTheme(
            name: 'dark',
            data: ThemeData(
              brightness: .dark,
              scaffoldBackgroundColor: const Color(0xFF111111),
            ),
          ),
        ],
        themeBuilder: (context, theme, child) {
          return Theme(
            data: theme,
            child: VanillaTheme(
              mode: theme.brightness == Brightness.dark ? .dark : .light,
              child: child,
            ),
          );
        },
      );
}
