import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import 'scenario.dart';
import 'theme.dart';

/// Handed to cell builders with the active scenario applied.
///
/// The sheet has already forced [SheetScenario.states] through a
/// `WidgetStateProvider` above the cell, so [resolve] produces the spec a
/// user would see in that state without any real interaction.
class SheetCellContext {
  const SheetCellContext(this.scenario);

  final SheetScenario scenario;

  Set<WidgetState> get states => scenario.states;
  bool get hovered => states.contains(WidgetState.hovered);
  bool get pressed => states.contains(WidgetState.pressed);
  bool get focused => states.contains(WidgetState.focused);
  bool get disabled => states.contains(WidgetState.disabled);
  bool get selected => states.contains(WidgetState.selected);
  bool get error => states.contains(WidgetState.error);

  T? prop<T>(String key) => scenario.props[key] as T?;

  T propOr<T>(String key, T fallback) =>
      (scenario.props[key] as T?) ?? fallback;

  /// Resolves [style] with this scenario's widget states forced.
  ///
  /// Pass the result to the component's `styleSpec` parameter, which renders
  /// a pre-resolved spec and bypasses interaction-driven resolution.
  /// [context] must be the cell builder's context (below the sheet's
  /// `WidgetStateProvider` and the theme's token scope).
  StyleSpec<S> resolve<S extends Spec<S>>(
    BuildContext context,
    Style<S> style,
  ) {
    assert(
      WidgetStateProvider.of(context) != null,
      'SheetCellContext.resolve must be called with the cell builder context so '
      'forced widget states are visible to style resolution.',
    );

    return style.build(context);
  }
}

/// Builds one cell of a component sheet for a given scenario.
typedef SheetCellBuilder =
    Widget Function(BuildContext context, SheetCellContext cell);

/// A row of a component sheet, typically one component variant.
@immutable
class SheetRow {
  const SheetRow(this.id, this.builder, {this.label, this.values = const {}});

  /// Identifier shown as the row label and recorded in the manifest.
  final String id;
  final String? label;

  final SheetCellBuilder builder;

  /// Values for each axis declared by [ComponentSheet.rowAxes].
  final Map<String, SheetAxisValue> values;
}

@immutable
class SheetAxis {
  const SheetAxis(this.id, this.label);

  final String id;
  final String label;
}

@immutable
class SheetAxisValue {
  const SheetAxisValue(this.id, this.label);

  final String id;
  final String label;
}

/// A component's full sheet: rows (variants) crossed with scenario columns.
@immutable
class ComponentSheet {
  const ComponentSheet({
    required this.id,
    required this.scenarios,
    required this.rows,
    this.label,
    this.rowAxes = const [],
  });

  /// Component identifier used in golden file paths and the manifest.
  final String id;
  final String? label;

  final List<SheetScenario> scenarios;

  final List<SheetRow> rows;

  /// Ordered axes used to group and label rows.
  final List<SheetAxis> rowAxes;

  /// Validates identifiers and the row/scenario matrix before rendering.
  void validate() {
    _requireId(id, 'sheet');
    _requireUnique(scenarios.map((item) => item.id), 'scenario');
    _requireUnique(rowAxes.map((item) => item.id), 'axis');
    _requireUnique(rows.map((item) => item.id), 'row');
    for (final axis in rowAxes) {
      _requireId(axis.id, 'axis');
    }

    final axisIds = rowAxes.map((axis) => axis.id).toSet();
    final combinations = <String>{};
    for (final row in rows) {
      _requireId(row.id, 'row');
      final valueIds = row.values.keys.toSet();
      final missing = axisIds.difference(valueIds);
      final unknown = valueIds.difference(axisIds);
      if (missing.isNotEmpty || unknown.isNotEmpty) {
        throw ArgumentError(
          'Row "${row.id}" has invalid axis values '
          '(missing: ${missing.toList()}, unknown: ${unknown.toList()}).',
        );
      }
      for (final value in row.values.values) {
        _requireId(value.id, 'axis value');
      }
      if (rowAxes.isNotEmpty) {
        final combination = rowAxes
            .map((axis) => row.values[axis.id]!.id)
            .join('\u0000');
        if (!combinations.add(combination)) {
          throw ArgumentError('Duplicate axis combination on row "${row.id}".');
        }
      }
    }
  }
}

void _requireId(String id, String kind) {
  if (id.trim().isEmpty) throw ArgumentError('$kind ID must not be empty.');
}

void _requireUnique(Iterable<String> ids, String kind) {
  final seen = <String>{};
  for (final id in ids) {
    _requireId(id, kind);
    if (!seen.add(id)) throw ArgumentError('Duplicate $kind ID "$id".');
  }
}

/// Shared source of themes and sheets for snapshots and future viewers.
@immutable
class SheetCatalog {
  const SheetCatalog({
    required this.id,
    required this.themes,
    required this.sheets,
    this.label,
  });

  final String id;
  final String? label;
  final List<SheetTheme> themes;
  final List<ComponentSheet> sheets;

  void validate() {
    _requireId(id, 'catalog');
    _requireUnique(themes.map((item) => item.id), 'theme');
    _requireUnique(sheets.map((item) => item.id), 'sheet');
    for (final sheet in sheets) {
      sheet.validate();
    }
  }
}
