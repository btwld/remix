import 'package:flutter/material.dart';

import '../../ui/ui.dart';

/// Builds the installed default-preset starter inside the preview viewport.
Widget buildDashboardExample(BuildContext context) {
  final dark = Theme.of(context).brightness == Brightness.dark;
  return PlaygroundThemeScope(
    mode: dark ? PlaygroundThemeMode.dark : PlaygroundThemeMode.light,
    child: ColoredBox(
      color: dark ? const Color(0xFF111827) : const Color(0xFFF8FAFC),
      child: const PlaygroundDashboardDemo(
        brand: Text('Northstar'),
        account: Text('Workspace account'),
      ),
    ),
  );
}
