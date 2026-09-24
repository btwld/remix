import 'package:flutter/widgets.dart';

import 'ui/ui.dart';

/// Runs a minimal application composed from installed Carbon source.
void main() => runApp(const AcmeApp());

/// Minimal consumer shell for the Carbon preset.
class AcmeApp extends StatelessWidget {
  /// Creates the example application.
  const AcmeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AcmeScope(
      theme: AcmeTheme.g10,
      child: WidgetsApp(
        color: const Color(0xFFF4F4F4),
        builder: (context, _) => Center(
          child: AcmeButton(label: 'Continue', onPressed: () {}),
        ),
      ),
    );
  }
}
