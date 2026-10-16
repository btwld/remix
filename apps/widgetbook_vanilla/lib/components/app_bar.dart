import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'AppBar', type: VanillaAppBar)
Widget buildVanillaAppBarUseCase(BuildContext context) => Scaffold(
  body: Align(
    alignment: Alignment.topCenter,
    child: VanillaAppBar(
      leading: VanillaIconButton.ghost(
        icon: Icons.arrow_back,
        semanticLabel: 'Back',
        onPressed: () {},
      ),
      title: 'Orders',
      actions: [
        VanillaIconButton.ghost(
          icon: Icons.search,
          semanticLabel: 'Search orders',
          onPressed: () {},
        ),
        VanillaButton(label: 'New order', onPressed: () {}),
      ],
    ),
  ),
);
