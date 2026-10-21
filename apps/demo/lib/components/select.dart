import 'package:demo/helpers/catalog.dart';
import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:demo/ui/ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// Widgetbook remounts a story on every knob change; the GlobalKey keeps the
// selection across those remounts.
final _key = GlobalKey();

@widgetbook.UseCase(name: 'Select Component', type: RemixSelect)
Widget buildSelectUseCase(BuildContext context) {
  return SelectExample(
    key: _key,
    variant: context.knobs.object.dropdown(
      label: 'variant',
      options: FortalSelectVariant.values,
      labelBuilder: (variant) => variant.name,
    ),
    size: context.knobs.object.dropdown(
      label: 'size',
      options: FortalSelectSize.values,
      labelBuilder: (size) => size.name,
      initialOption: FortalSelectSize.size2,
    ),
    placeholder: context.knobs.string(
      label: 'Placeholder',
      initialValue: 'Select item...',
    ),
  );
}

class SelectExample extends StatefulWidget {
  const SelectExample({
    super.key,
    required this.variant,
    required this.size,
    required this.placeholder,
  });

  final FortalSelectVariant variant;
  final FortalSelectSize size;
  final String placeholder;

  @override
  State<SelectExample> createState() => _SelectExampleState();
}

class _SelectExampleState extends State<SelectExample> {
  String _selectedValue = 'Apple';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FortalSelect(
          variant: widget.variant,
          size: widget.size,
          trigger: RemixSelectTrigger(placeholder: widget.placeholder),
          selectedValue: _selectedValue,
          onChanged: (value) {
            setState(() => _selectedValue = value ?? 'Apple');
          },
          items: [
            RemixSelectItem(value: 'Apple', label: 'Apple'),
            RemixSelectItem(value: 'Banana', label: 'Banana'),
            RemixSelectItem(value: 'Orange', label: 'Orange'),
          ],
        ),
      ),
    );
  }
}

@widgetbook.UseCase(name: 'Catalog', type: RemixSelect)
Widget buildSelectCatalogUseCase(BuildContext context) {
  return CatalogMatrix(
    cellWidth: 220,
    columns: labelsOf(FortalSelectSize.values),
    rows: labelsOf(FortalSelectVariant.values),
    // The closed trigger is the part the size and variant enums paint; the
    // popup surface only exists once a cell is tapped.
    cell: (row, column) => FortalSelect<String>(
      trigger: const RemixSelectTrigger(placeholder: 'Select...'),
      items: [RemixSelectItem(value: 'apple', label: 'Apple')],
      selectedValue: 'apple',
      onChanged: (_) {},
      size: FortalSelectSize.values[column],
      variant: FortalSelectVariant.values[row],
    ),
  );
}
