import 'package:flutter/widgets.dart';

import '../theme/theme.dart';
import 'field_layout.dart';
import 'switch.dart';

/// One labeled switch of a [UiSwitchGroup].
class UiSwitchOption {
  const UiSwitchOption({
    required this.selected,
    required this.label,
    this.onChanged,
    this.description,
    this.invalid = false,
    this.enabled = true,
  });

  final bool selected;
  final String label;
  final ValueChanged<bool>? onChanged;
  final String? description;

  /// Turns the label danger, as `[data-invalid] .label`; the switch itself has
  /// no invalid treatment.
  final bool invalid;
  final bool enabled;
}

/// Labeled switches laid out as HeroUI's `SwitchGroup`.
///
/// Each switch keeps its own value, so the group coordinates nothing: it lays
/// the optional [label] and the switches out with `gap-4`. Horizontal groups
/// wrap where the CSS row would shrink.
class UiSwitchGroup extends StatelessWidget {
  const UiSwitchGroup({
    super.key,
    required this.options,
    this.size = .md,
    this.orientation = Axis.vertical,
    this.enabled = true,
    this.label,
  });

  final List<UiSwitchOption> options;
  final UiSwitchSize size;
  final Axis orientation;
  final bool enabled;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final rows = [
      for (final option in options)
        _row(
          option,
          optionEnabled: enabled && option.enabled && option.onChanged != null,
        ),
    ];
    return UiFieldLayout(
      orientation: orientation,
      label: label,
      enabled: enabled,
      items: rows,
    );
  }

  Widget _row(UiSwitchOption option, {required bool optionEnabled}) =>
      UiDescribedControl(
        descriptionInset: size.trackWidth + uiControlGap,
        enabled: optionEnabled,
        description: option.description,
        control: UiSwitch(
          size: size,
          selected: option.selected,
          onChanged: option.onChanged,
          enabled: optionEnabled,
          label: option.label,
          invalid: option.invalid,
        ),
      );
}
