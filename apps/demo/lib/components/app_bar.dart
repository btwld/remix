import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:demo/ui/ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Page header', type: RemixAppBar)
Widget buildAppBarUseCase(BuildContext context) => const AppBarExample();

class AppBarExample extends StatelessWidget {
  const AppBarExample({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Align(
      alignment: Alignment.topCenter,
      child: RemixAppBar(
        leading: FortalIconButton.ghost(
          icon: Icons.arrow_back,
          semanticLabel: 'Back',
          onPressed: () {},
        ),
        title: 'Orders',
        actions: [
          FortalIconButton.ghost(
            icon: Icons.search,
            semanticLabel: 'Search orders',
            onPressed: () {},
          ),
          FortalButton(label: 'New order', onPressed: () {}),
        ],
      ),
    ),
  );
}
