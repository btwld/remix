import 'package:demo/helpers/catalog.dart';
import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:demo/ui/ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Card Component', type: RemixCard)
Widget buildCardUseCase(BuildContext context) {
  return Scaffold(
    body: Center(
      child: FortalCard(
        variant: context.knobs.object.dropdown(
          label: 'variant',
          options: FortalCardVariant.values,
          labelBuilder: (variant) => variant.name,
        ),
        size: context.knobs.object.dropdown(
          label: 'size',
          options: FortalCardSize.values,
          labelBuilder: (size) => size.name,
          initialOption: FortalCardSize.size1,
        ),
        child: Row(
          mainAxisSize: .min,
          spacing: 16,
          children: [
            const FortalAvatar.solid(label: 'LF', size: FortalAvatarSize.size3),
            Column(
              mainAxisSize: .min,
              crossAxisAlignment: .start,
              children: [
                FortalText(
                  context.knobs.string(
                    label: 'Name',
                    initialValue: 'Leo Farias',
                  ),
                  size: .size2,
                  weight: .bold,
                ),
                FortalText(
                  context.knobs.string(
                    label: 'Title',
                    initialValue: 'Flutter Engineer',
                  ),
                  size: .size1,
                  style: TextStyler().color(FortalTokens.gray11()),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Catalog', type: RemixCard)
Widget buildCardCatalogUseCase(BuildContext context) {
  return CatalogMatrix(
    cellWidth: 200,
    columns: labelsOf(FortalCardSize.values),
    rows: labelsOf(FortalCardVariant.values),
    cell: (row, column) => FortalCard(
      size: FortalCardSize.values[column],
      variant: FortalCardVariant.values[row],
      child: const FortalText('Card'),
    ),
  );
}
