import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Menu', type: VanillaMenu)
Widget buildVanillaMenuUseCase(BuildContext context) => Scaffold(
  body: Center(
    child: VanillaMenu<String>(
      trigger: const RemixMenuTrigger(label: 'Actions'),
      items: const [
        RemixMenuItem(value: 'edit', label: 'Edit'),
        RemixMenuItem(value: 'duplicate', label: 'Duplicate'),
        RemixMenuDivider(),
        RemixMenuItem(value: 'archive', label: 'Archive'),
      ],
      onSelected: (_) {},
    ),
  ),
);
