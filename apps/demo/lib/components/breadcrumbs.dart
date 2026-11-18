import 'package:demo/helpers/catalog.dart';
import 'package:flutter/widgets.dart';
import 'package:demo/ui/ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Breadcrumbs Component', type: FortalBreadcrumbs)
Widget buildBreadcrumbsUseCase(BuildContext context) {
  final links = context.knobs.boolean(label: 'links', initialValue: true);
  return Center(
    child: SizedBox(
      width: context.knobs.double.slider(
        label: 'width',
        initialValue: 420,
        min: 160,
        max: 640,
      ),
      child: FortalBreadcrumbs(
        size: context.knobs.object.dropdown(
          label: 'size',
          options: FortalBreadcrumbsSize.values,
          labelBuilder: (size) => size.name,
          initialOption: FortalBreadcrumbsSize.size2,
        ),
        semanticLabel: 'Breadcrumbs',
        items: [
          FortalBreadcrumbItem('Studio', onPressed: links ? () {} : null),
          FortalBreadcrumbItem('Collection', onPressed: links ? () {} : null),
          const FortalBreadcrumbItem('Mar Aberto, a print in four colors'),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Catalog', type: FortalBreadcrumbs)
Widget buildBreadcrumbsCatalogUseCase(BuildContext context) => CatalogMatrix(
  cellWidth: 300,
  columns: labelsOf(FortalBreadcrumbsSize.values),
  rows: const ['links', 'text', 'truncated'],
  cell: (row, column) => SizedBox(
    width: row == 2 ? 200 : 290,
    child: FortalBreadcrumbs(
      size: FortalBreadcrumbsSize.values[column],
      items: [
        FortalBreadcrumbItem('Studio', onPressed: row == 1 ? null : () {}),
        const FortalBreadcrumbItem('Collection'),
        FortalBreadcrumbItem(row == 2 ? 'Mar Aberto, a print' : 'Mar Aberto'),
      ],
    ),
  ),
);
