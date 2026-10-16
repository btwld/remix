import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'DataTable', type: VanillaDataTable)
Widget buildVanillaDataTableUseCase(BuildContext context) => Scaffold(
  body: Center(
    child: SizedBox(
      width: 360,
      child: VanillaDataTable<String>(
        rows: const ['Ada Lovelace', 'Grace Hopper'],
        columns: [
          RemixDataTableColumn<String>(
            id: 'name',
            label: 'Name',
            cellBuilder: (context, name) => Text(name),
          ),
        ],
      ),
    ),
  ),
);
