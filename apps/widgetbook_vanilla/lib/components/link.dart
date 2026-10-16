import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Link', type: VanillaLink)
Widget buildVanillaLinkUseCase(BuildContext context) => Scaffold(
  body: Center(child: VanillaLink(label: 'Documentation', onPressed: () {})),
);
