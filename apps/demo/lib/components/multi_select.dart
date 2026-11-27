import 'package:demo/helpers/catalog.dart';
import 'package:flutter/widgets.dart';
import 'package:demo/ui/ui.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Multi Select Component', type: FortalMultiSelect)
Widget buildMultiSelectUseCase(BuildContext context) => Center(
  child: _Field(
    size: context.knobs.object.dropdown(
      label: 'size',
      options: FortalMultiSelectSize.values,
      labelBuilder: (size) => size.name,
      initialOption: FortalMultiSelectSize.size2,
    ),
    initial: const {'design', 'engineering'},
    enabled: context.knobs.boolean(label: 'enabled', initialValue: true),
    highContrast: context.knobs.boolean(label: 'highContrast'),
  ),
);

@widgetbook.UseCase(name: 'Catalog', type: FortalMultiSelect)
Widget buildMultiSelectCatalogUseCase(BuildContext context) => CatalogMatrix(
  cellWidth: 280,
  columns: labelsOf(FortalMultiSelectSize.values),
  rows: const ['empty', 'two picks', 'overflow', 'disabled', 'high contrast'],
  cell: (row, column) => _Field(
    size: FortalMultiSelectSize.values[column],
    initial: switch (row) {
      0 => const {},
      1 || 3 || 4 => const {'design', 'engineering'},
      _ => const {'design', 'engineering', 'marketing'},
    },
    enabled: row != 3,
    highContrast: row == 4,
  ),
);

/// A cell owns its picks, so toggling an option changes them as an app would.
class _Field extends StatefulWidget {
  const _Field({
    required this.size,
    required this.initial,
    this.enabled = true,
    this.highContrast = false,
  });

  final FortalMultiSelectSize size;
  final Set<String> initial;
  final bool enabled;
  final bool highContrast;

  @override
  State<_Field> createState() => _FieldState();
}

class _FieldState extends State<_Field> {
  late Set<String> _value = widget.initial;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 260,
    child: FortalMultiSelect<String>(
      size: widget.size,
      highContrast: widget.highContrast,
      trigger: const RemixSelectTrigger(placeholder: 'Select teams'),
      items: const [
        RemixSelectItem(value: 'design', label: 'Design'),
        RemixSelectItem(value: 'engineering', label: 'Engineering'),
        RemixSelectItem(value: 'marketing', label: 'Marketing'),
        RemixSelectItem(value: 'sales', label: 'Sales', enabled: false),
      ],
      selectedValues: _value,
      enabled: widget.enabled,
      onChanged: (next) => setState(() => _value = next),
    ),
  );
}
