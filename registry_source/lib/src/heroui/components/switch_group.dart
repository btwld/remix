import 'package:flutter/widgets.dart';

import 'field_layout.dart';
import 'switch.dart';

/// One labeled switch of a [HeroUiSwitchGroup].
class HeroUiSwitchOption {
  const HeroUiSwitchOption({
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
class HeroUiSwitchGroup extends StatelessWidget {
  const HeroUiSwitchGroup({
    super.key,
    required this.items,
    this.size = .md,
    this.orientation = Axis.vertical,
    this.enabled = true,
    this.label,
  });

  final List<HeroUiSwitchOption> items;
  final HeroUiSwitchSize size;
  final Axis orientation;
  final bool enabled;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final rows = [
      for (final item in items)
        _row(
          item,
          itemEnabled: enabled && item.enabled && item.onChanged != null,
        ),
    ];
    return HeroUiFieldLayout(
      axis: orientation,
      label: label,
      enabled: enabled,
      items: rows,
    );
  }

  Widget _row(HeroUiSwitchOption item, {required bool itemEnabled}) =>
      HeroUiControlRow(
        controlWidth: size.trackWidth,
        invalid: item.invalid,
        enabled: itemEnabled,
        label: item.label,
        description: item.description,
        control: HeroUiSwitch(
          size: size,
          selected: item.selected,
          onChanged: item.onChanged,
          enabled: itemEnabled,
          semanticLabel: item.label,
        ),
      );
}
