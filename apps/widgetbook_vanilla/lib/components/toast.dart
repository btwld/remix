import 'package:flutter/material.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Toast', type: VanillaToast)
Widget buildVanillaToastUseCase(BuildContext context) => Scaffold(
  body: Center(child: const VanillaToast(title: 'Changes saved', description: 'Your settings are up to date.', icon: RemixIcons.checkCircled)),
);
