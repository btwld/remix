import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Dialog', type: VanillaDialog)
Widget buildVanillaDialogUseCase(BuildContext context) => Scaffold(
  body: Center(
    child: VanillaDialog(
      title: 'Invite teammates',
      description: 'Share this workspace.',
      actions: [VanillaButton(label: 'Send invite', onPressed: () {})],
    ),
  ),
);
