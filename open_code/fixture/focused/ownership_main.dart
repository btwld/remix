import 'package:flutter/widgets.dart';

import 'ui/ui.dart';

void main() => runApp(const OwnershipApp());

class OwnershipApp extends StatelessWidget {
  const OwnershipApp({super.key});

  @override
  Widget build(BuildContext context) => WidgetsApp(
    color: const Color(0xFFFFFFFF),
    pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    ),
    home: AcmeTheme(
      mode: AcmeThemeMode.light,
      child: Column(
        children: [
          AcmeButton(label: 'Official', onPressed: () {}),
          AcmeExtraButton(label: 'Add-on', onPressed: () {}),
        ],
      ),
    ),
  );
}
