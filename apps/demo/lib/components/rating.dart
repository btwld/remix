import 'package:demo/helpers/catalog.dart';
import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:demo/ui/ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _key = GlobalKey();
final _value = ValueNotifier<int?>(4);

@widgetbook.UseCase(name: 'Rating Component', type: RemixRating)
Widget buildRatingUseCase(BuildContext context) {
  return KeyedSubtree(
    key: _key,
    child: Scaffold(
      body: Center(
        child: ListenableBuilder(
          listenable: _value,
          builder: (context, _) => FortalRating(
            label: 'Rate this recipe',
            description:
                context.knobs.boolean(label: 'Description', initialValue: true)
                ? 'Your rating is shared with the author'
                : null,
            value: _value.value,
            size: context.knobs.object.dropdown(
              label: 'size',
              options: FortalRatingSize.values,
              labelBuilder: (size) => size.name,
              initialOption: FortalRatingSize.size2,
            ),
            highContrast: context.knobs.boolean(label: 'High contrast'),
            enabled: context.knobs.boolean(
              label: 'Enabled',
              initialValue: true,
            ),
            onChanged: (value) => _value.value = value,
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Catalog', type: RemixRating)
Widget buildRatingCatalogUseCase(BuildContext context) {
  const values = [null, 3];
  return CatalogMatrix(
    columns: labelsOf(FortalRatingSize.values),
    rows: const ['unrated', 'rated'],
    cellWidth: 240,
    cell: (row, column) => FortalRating(
      semanticLabel: 'Rating',
      valueLabelBuilder: null,
      size: FortalRatingSize.values[column],
      value: values[row],
      onChanged: (_) {},
    ),
  );
}
