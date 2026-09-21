import 'package:flutter/widgets.dart';

/// The application host shared by every example in `lib/api` and `lib/doc`.
///
/// Each example keeps its own `main()` so it can be run on its own, but the
/// host itself is identical across all of them: a neutral `WidgetsApp`, a page
/// route builder, a default text style, and a flat background. Repeating that
/// per file buys nothing and guarantees the copies drift apart.
///
/// `WidgetsApp` rather than `MaterialApp` on purpose. naked_ui ships behavior
/// and no design system, so an example that pulled in Material would be
/// demonstrating Material.
class ExampleApp extends StatelessWidget {
  const ExampleApp({
    super.key,
    required this.child,
    this.background = const Color(0xFFFAFAFA),
    this.title,
  });

  /// Rendered against [background], filling the window.
  final Widget child;

  /// Page background. Also the app `color` reported to the host platform.
  final Color background;

  final String? title;

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      title: title ?? '',
      color: background,
      debugShowCheckedModeBanner: false,
      // MaterialApp supplied a default text style through its theme; WidgetsApp
      // installs one only when asked.
      textStyle: const TextStyle(fontSize: 14, color: Color(0xFF1C1B1F)),
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) =>
            builder(context),
      ),
      home: ColoredBox(color: background, child: child),
    );
  }
}
