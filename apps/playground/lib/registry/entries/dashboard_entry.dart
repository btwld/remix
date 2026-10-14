import 'package:flutter/material.dart';

import '../../ui/ui.dart';

/// Builds the installed default-preset starter inside the preview viewport.
Widget buildDashboardExample(BuildContext context) {
  final dark = Theme.of(context).brightness == Brightness.dark;
  return PlaygroundTheme(
    mode: dark ? PlaygroundThemeMode.dark : PlaygroundThemeMode.light,
    child: const PlaygroundDashboardDemo(),
  );
}
