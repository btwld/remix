import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Radio', type: VanillaRadio)
Widget buildVanillaRadioUseCase(BuildContext context) {
  String? selected = 'pro';
  return Scaffold(
    body: Center(
      child: StatefulBuilder(
        builder: (context, setState) => RemixRadioGroup<String>(
          groupValue: selected,
          onChanged: (value) => setState(() => selected = value),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              VanillaRadio<String>(value: 'free', label: 'Free'),
              VanillaRadio<String>(value: 'pro', label: 'Pro'),
            ],
          ),
        ),
      ),
    ),
  );
}
