import 'package:demo/helpers/catalog.dart';
import 'package:flutter/material.dart';
import 'package:demo/ui/ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Catalog', type: FortalKbd)
Widget buildKbdCatalogUseCase(BuildContext context) {
  return CatalogMatrix(
    columns: labelsOf(FortalTextSize.values),
    rows: noRowAxis,
    cell: (row, column) =>
        FortalKbd('Shift', size: FortalTextSize.values[column]),
  );
}
