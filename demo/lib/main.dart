import 'package:flutter/material.dart' hide Scaffold, ThemeMode;
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'addons/brightness_addon.dart';
import 'main.directories.g.dart';

@widgetbook.App(
  cloudAddonsConfigs: {
    'dark fortaleza': [
      BrightnessAddonConfig(WidgetBookBrightness.dark),
    ],
    'light fortaleza': [
      BrightnessAddonConfig(WidgetBookBrightness.light),
    ],
    'dark base': [
      BrightnessAddonConfig(WidgetBookBrightness.dark),
    ],
    'light base': [
      BrightnessAddonConfig(WidgetBookBrightness.light),
    ],
  },
)
void main() {
  runApp(const HotReload());
}

class HotReload extends StatelessWidget {
  const HotReload({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook(
      addons: [
        BrightnessAddon(),
        InspectorAddon(),
      ],
      appBuilder: (context, child) => createRemixScope(child: child),
      directories: directories,
    );
  }
}
