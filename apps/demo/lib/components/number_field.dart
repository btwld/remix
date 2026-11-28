import 'package:demo/helpers/catalog.dart';
import 'package:flutter/widgets.dart';
import 'package:demo/ui/ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Number Field Component', type: FortalNumberField)
Widget buildNumberFieldUseCase(BuildContext context) => Center(
  child: _Field(
    size: context.knobs.object.dropdown(
      label: 'size',
      options: FortalNumberFieldSize.values,
      labelBuilder: (size) => size.name,
      initialOption: FortalNumberFieldSize.size2,
    ),
    initial: 4,
    label: 'Guests',
    helperText: 'Up to ten guests',
    enabled: context.knobs.boolean(label: 'enabled', initialValue: true),
    readOnly: context.knobs.boolean(label: 'readOnly'),
    highContrast: context.knobs.boolean(label: 'highContrast'),
  ),
);

@widgetbook.UseCase(name: 'Catalog', type: FortalNumberField)
Widget buildNumberFieldCatalogUseCase(BuildContext context) => CatalogMatrix(
  cellWidth: 240,
  columns: labelsOf(FortalNumberFieldSize.values),
  rows: const ['rest', 'at maximum', 'disabled', 'high contrast'],
  cell: (row, column) => _Field(
    size: FortalNumberFieldSize.values[column],
    initial: row == 1 ? 10 : 4,
    enabled: row != 2,
    highContrast: row == 3,
  ),
);

/// A cell owns its value, so its steps change it as an app would.
class _Field extends StatefulWidget {
  const _Field({
    required this.size,
    required this.initial,
    this.label,
    this.helperText,
    this.enabled = true,
    this.readOnly = false,
    this.highContrast = false,
  });

  final FortalNumberFieldSize size;
  final double initial;
  final String? label;
  final String? helperText;
  final bool enabled;
  final bool readOnly;
  final bool highContrast;

  @override
  State<_Field> createState() => _FieldState();
}

class _FieldState extends State<_Field> {
  late double? _value = widget.initial;

  @override
  Widget build(BuildContext context) => FortalNumberField(
    size: widget.size,
    highContrast: widget.highContrast,
    value: _value,
    min: 0,
    max: 10,
    label: widget.label,
    helperText: widget.helperText,
    semanticLabel: widget.label ?? 'Guests',
    enabled: widget.enabled,
    readOnly: widget.readOnly,
    onChanged: (next) => setState(() => _value = next),
  );
}
