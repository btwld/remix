import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import 'scenario.dart';

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
  const SpecimenRow(this.id, this.builder);

  /// Identifier shown as the row label and recorded in the manifest.
  final String id;

  final SpecimenCellBuilder builder;
}

/// A component's full specimen: rows (variants) crossed with scenario columns.
@immutable
class Specimen {
  const Specimen({
    required this.id,
    required this.scenarios,
    required this.rows,
  });

  /// Component identifier used in golden file paths and the manifest.
  final String id;

  final List<SpecimenScenario> scenarios;

  final List<SpecimenRow> rows;
}
