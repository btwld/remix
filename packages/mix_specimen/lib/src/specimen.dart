import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import 'scenario.dart';
import 'theme.dart';

/// Handed to cell builders with the active scenario applied.
///
/// The sheet has already forced [SpecimenScenario.states] through a
/// `WidgetStateProvider` above the cell, so [resolve] produces the spec a
/// user would see in that state without any real interaction.
class SpecimenSim {
  const SpecimenSim(this.scenario);

  final SpecimenScenario scenario;

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
      'SpecimenSim.resolve must be called with the cell builder context so '
      'forced widget states are visible to style resolution.',
    );

    return style.build(context);
  }
}

/// Builds one cell of a specimen sheet for a given scenario.
typedef SpecimenCellBuilder =
    Widget Function(BuildContext context, SpecimenSim sim);

/// A row of a specimen sheet, typically one component variant.
@immutable
class SpecimenRow {
  const SpecimenRow(this.id, this.builder, {this.values = const {}});

  /// Identifier shown as the row label and recorded in the manifest.
  final String id;

  final SpecimenCellBuilder builder;

  /// Values for each axis declared by [Specimen.rowAxes].
  final Map<String, SpecimenAxisValue> values;
}

@immutable
class SpecimenAxis {
  const SpecimenAxis(this.id, this.label);

  final String id;
  final String label;
}

@immutable
class SpecimenAxisValue {
  const SpecimenAxisValue(this.id, this.label);

  final String id;
  final String label;
}

/// A component's full specimen: rows (variants) crossed with scenario columns.
@immutable
class Specimen {
  const Specimen({
    required this.id,
    required this.scenarios,
    required this.rows,
    this.rowAxes = const [],
  });

  /// Component identifier used in golden file paths and the manifest.
  final String id;

  final List<SpecimenScenario> scenarios;

  final List<SpecimenRow> rows;

  /// Ordered axes used to group and label rows.
  final List<SpecimenAxis> rowAxes;

  /// Validates identifiers and the row/scenario matrix before rendering.
  void validate() {
    _requireId(id, 'specimen');
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

/// Shared source of themes and specimens for snapshots and future viewers.
@immutable
class SpecimenCatalog {
  const SpecimenCatalog({
    required this.id,
    required this.themes,
    required this.specimens,
  });

  final String id;
  final List<SpecimenTheme> themes;
  final List<Specimen> specimens;

  void validate() {
    _requireId(id, 'catalog');
    _requireUnique(themes.map((item) => item.id), 'theme');
    _requireUnique(specimens.map((item) => item.id), 'specimen');
    for (final specimen in specimens) {
      specimen.validate();
    }
  }
}
