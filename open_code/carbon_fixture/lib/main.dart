import 'package:flutter/material.dart';

import 'ui/ui.dart';

/// Runs a minimal application composed from installed Carbon source.
void main() => runApp(const AcmeApp());

/// Minimal consumer shell for the Carbon preset.
class AcmeApp extends StatelessWidget {
  /// Creates the example application.
  const AcmeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AcmeScope(
        theme: AcmeTheme.g10,
        child: Scaffold(
          body: Center(
            child: AcmeButton(label: 'Continue', onPressed: () {}),
          ),
        ),
      ),
    );
  }
}
