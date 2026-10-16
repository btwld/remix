import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Select', type: VanillaSelect)
Widget buildVanillaSelectUseCase(BuildContext context) => Scaffold(
  body: Center(child: SizedBox(width: 240, child: StatefulBuilder(builder: (context, setState) { String? v; return VanillaSelect<String>(trigger: const RemixSelectTrigger(placeholder: 'Fruit'), items: const [RemixSelectItem(value: 'apple', label: 'Apple'), RemixSelectItem(value: 'pear', label: 'Pear')], selectedValue: v, onChanged: (value) => setState(() => v = value)); }))),
);
