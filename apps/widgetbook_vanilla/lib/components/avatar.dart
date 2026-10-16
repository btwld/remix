import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Avatar', type: VanillaAvatar)
Widget buildVanillaAvatarUseCase(BuildContext context) => Scaffold(
  body: Center(child: const VanillaAvatar(label: 'LF')),
);
