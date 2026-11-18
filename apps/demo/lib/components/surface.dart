import 'package:demo/helpers/catalog.dart';
import 'package:flutter/widgets.dart';
import 'package:demo/ui/ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Surface Component', type: FortalSurface)
Widget buildSurfaceUseCase(BuildContext context) {
  final pressable = context.knobs.boolean(label: 'pressable');
  return Center(
    child: SizedBox(
      width: 320,
      child: FortalSurface(
        variant: context.knobs.object.dropdown(
          label: 'variant',
          options: FortalSurfaceVariant.values,
          labelBuilder: (variant) => variant.name,
        ),
        size: context.knobs.object.dropdown(
          label: 'size',
          options: FortalSurfaceSize.values,
          labelBuilder: (size) => size.name,
          initialOption: FortalSurfaceSize.size2,
        ),
        padded: context.knobs.boolean(label: 'padded', initialValue: true),
        onPressed: pressable ? () {} : null,
        semanticLabel: pressable ? 'Open revenue' : null,
        child: const _Content(),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Catalog', type: FortalSurface)
Widget buildSurfaceCatalogUseCase(BuildContext context) => surfaceCatalog();

/// Every variant at every size. [content] wraps each surface's content, so a
/// review board can re-apply its own typeface below the nested theme of an
/// inverse surface.
CatalogMatrix surfaceCatalog({
  Widget Function(Widget content) content = _unchanged,
}) => CatalogMatrix(
  cellWidth: 232,
  columns: labelsOf(FortalSurfaceSize.values),
  rows: labelsOf(FortalSurfaceVariant.values),
  cell: (row, column) => SizedBox(
    width: 224,
    child: FortalSurface(
      variant: FortalSurfaceVariant.values[row],
      size: FortalSurfaceSize.values[column],
      child: content(const _Content()),
    ),
  ),
);

Widget _unchanged(Widget content) => content;

/// A small block of supporting text and one control, so each surface shows
/// its text and an accent element in the appearance it resolves.
class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    spacing: 4,
    children: [
      const FortalText('Revenue', size: .size2, weight: .medium),
      const FortalText('R\$ 12.400 this week', size: .size1),
      const SizedBox(height: 4),
      FortalBadge(label: '+8%', size: .size1),
    ],
  );
}
