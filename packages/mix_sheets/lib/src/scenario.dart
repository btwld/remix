import 'package:flutter/widgets.dart';

/// A named combination of forced widget states and component props.
///
/// Scenarios are the columns of a component sheet. Widget states
/// (hover, pressed, ...) are forced through Mix's `WidgetStateProvider`
/// during style resolution; [props] cover states that are component
/// properties rather than `WidgetState`s (loading, checked, ...).
@immutable
class SheetScenario {
  const SheetScenario(
    this.id, {
    this.label,
    this.states = const {},
    this.props = const {},
  });

  /// Identifier shown as the column label and recorded in the manifest.
  final String id;
  final String? label;

  /// Widget states forced while resolving styles for this scenario.
  final Set<WidgetState> states;

  /// Component props a cell builder should apply for this scenario.
  final Map<String, Object?> props;
}

/// Standard scenario sets shared across components.
abstract final class SheetScenarios {
  static const base = SheetScenario('default');
  static const hovered = SheetScenario(
    'hovered',
    states: {WidgetState.hovered},
  );
  static const pressed = SheetScenario(
    'pressed',
    states: {WidgetState.pressed},
  );
  static const focused = SheetScenario(
    'focused',
    states: {WidgetState.focused},
  );
  static const disabled = SheetScenario(
    'disabled',
    states: {WidgetState.disabled},
  );
  static const selected = SheetScenario(
    'selected',
    states: {WidgetState.selected},
  );
  static const error = SheetScenario('error', states: {WidgetState.error});

  /// Scenario set for pointer-interactive components (buttons, links).
  static const interactive = [base, hovered, pressed, focused, disabled];

  /// Scenario set for components with a selected state (checkbox, radio, toggle).
  static const selectable = [
    base,
    hovered,
    pressed,
    focused,
    selected,
    disabled,
  ];
}
