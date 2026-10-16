import 'package:flutter/material.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Icon Button', type: VanillaIconButton)
Widget buildVanillaIconButtonUseCase(BuildContext context) => Scaffold(
  body: Center(
    child: VanillaIconButton(
      icon: RemixIcons.check,
      semanticLabel: 'Confirm',
      onPressed: () {},
    ),
  ),
);
