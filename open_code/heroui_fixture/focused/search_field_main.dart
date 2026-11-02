import 'package:flutter/widgets.dart';

import 'ui/ui.dart';

void main() => runApp(const AcmeSearchApp());

class AcmeSearchApp extends StatelessWidget {
  const AcmeSearchApp({super.key});

  @override
  Widget build(BuildContext context) => WidgetsApp(
    color: const Color(0xFFFFFFFF),
    pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    ),
    home: const AcmeTheme(child: AcmeSearchHost()),
  );
}

class AcmeSearchHost extends StatefulWidget {
  const AcmeSearchHost({super.key});

  @override
  State<AcmeSearchHost> createState() => _AcmeSearchHostState();
}

class _AcmeSearchHostState extends State<AcmeSearchHost> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Center(
    child: SizedBox(
      width: 320,
      child: ValueListenableBuilder(
        valueListenable: _controller,
        builder: (context, value, _) => AcmeSearchField(
          controller: _controller,
          label: 'Search projects',
          hintText: 'Name or owner',
          leading: const AcmeSearchIcon(),
          trailing: value.text.isEmpty
              ? null
              : AcmeSearchClearButton(onPressed: _controller.clear),
        ),
      ),
    ),
  );
}
