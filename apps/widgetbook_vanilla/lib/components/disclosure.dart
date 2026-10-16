import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Disclosure', type: VanillaDisclosure)
Widget buildVanillaDisclosureUseCase(BuildContext context) => Scaffold(
  body: Center(
    child: const VanillaDisclosure(
      trigger: Text('Details'),
      content: Text('More information'),
      defaultExpanded: true,
    ),
  ),
);
