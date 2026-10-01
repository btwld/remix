import 'package:flutter/widgets.dart';

import 'ui/ui.dart';

void main() => runApp(const AcmeIconsApp());

class AcmeIconsApp extends StatelessWidget {
  const AcmeIconsApp({super.key});

  @override
  Widget build(BuildContext context) => WidgetsApp(
    color: const Color(0xFFFFFFFF),
    pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    ),
    home: const AcmeThemeScope(
      mode: AcmeThemeMode.light,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Icon(AcmeIcons.check),
      ),
    ),
  );
}
