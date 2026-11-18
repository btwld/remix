import 'package:demo/helpers/catalog.dart';
import 'package:flutter/widgets.dart';
import 'package:demo/ui/ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Search Field Component', type: FortalSearchField)
Widget buildSearchFieldUseCase(BuildContext context) => Center(
  child: SizedBox(
    width: 320,
    child: FortalSearchField(
      semanticLabel: 'Search editions',
      hintText: 'Search editions…',
      variant: context.knobs.object.dropdown(
        label: 'variant',
        options: FortalSearchFieldVariant.values,
        labelBuilder: (variant) => variant.name,
      ),
      size: context.knobs.object.dropdown(
        label: 'size',
        options: FortalSearchFieldSize.values,
        labelBuilder: (size) => size.name,
        initialOption: FortalSearchFieldSize.size2,
      ),
      enabled: context.knobs.boolean(label: 'enabled', initialValue: true),
      readOnly: context.knobs.boolean(label: 'readOnly'),
    ),
  ),
);

@widgetbook.UseCase(name: 'Catalog', type: FortalSearchField)
Widget buildSearchFieldCatalogUseCase(BuildContext context) => CatalogMatrix(
  cellWidth: 240,
  columns: labelsOf(FortalSearchFieldSize.values),
  rows: [
    for (final variant in FortalSearchFieldVariant.values) ...[
      '${variant.name} empty',
      '${variant.name} filled',
    ],
  ],
  cell: (row, column) => SizedBox(
    width: 224,
    child: _CatalogField(
      variant: FortalSearchFieldVariant.values[row ~/ 2],
      size: FortalSearchFieldSize.values[column],
      text: row.isOdd ? 'Mar Aberto' : '',
    ),
  ),
);

/// A catalog cell owns its controller, so a filled cell shows its clear
/// button.
class _CatalogField extends StatefulWidget {
  const _CatalogField({
    required this.variant,
    required this.size,
    required this.text,
  });

  final FortalSearchFieldVariant variant;
  final FortalSearchFieldSize size;
  final String text;

  @override
  State<_CatalogField> createState() => _CatalogFieldState();
}

class _CatalogFieldState extends State<_CatalogField> {
  late final _controller = TextEditingController(text: widget.text);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FortalSearchField(
    variant: widget.variant,
    size: widget.size,
    controller: _controller,
    semanticLabel: 'Search editions',
    hintText: 'Search editions…',
  );
}
