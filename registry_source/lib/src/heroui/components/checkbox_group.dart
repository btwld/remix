import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import 'checkbox.dart';
import 'field_layout.dart';

part 'checkbox_group.g.dart';

/// HeroUI recipe for [RemixCheckboxGroupItem]: the checkbox recipe on an item
/// that carries its own label.
///
/// [minimumTapTargetSize] sets the widget's default tap target, as on
/// `HeroUiCheckbox`.
@MixWidget(target: RemixCheckboxGroupItem.new)
CheckboxStyler heroUiCheckboxGroupItemStyle({
  HeroUiCheckboxVariant variant = .primary,
  bool invalid = false,
  Size minimumTapTargetSize = heroUiCheckboxTapTarget,
  CheckboxStyler style = const CheckboxStyler.create(),
}) => heroUiCheckboxStyle(variant: variant, invalid: invalid, style: style);

/// One option of a [HeroUiCheckboxGroup].
class HeroUiCheckboxOption<T extends Object> {
  const HeroUiCheckboxOption({
    required this.value,
    required this.label,
    this.enabled = true,
  });

  final T value;
  final String label;
  final bool enabled;
}

/// A [RemixCheckboxGroup] with HeroUI's label, option spacing, and description.
///
/// [variant], [invalid], and [enabled] apply to every option. While [invalid],
/// [errorText] shows after [helperText].
class HeroUiCheckboxGroup<T extends Object> extends StatelessWidget {
  const HeroUiCheckboxGroup({
    super.key,
    required this.values,
    required this.options,
    this.onChanged,
    this.variant = .primary,
    this.invalid = false,
    this.enabled = true,
    this.label,
    this.helperText,
    this.errorText,
  });

  final Set<T> values;
  final List<HeroUiCheckboxOption<T>> options;
  final ValueChanged<Set<T>>? onChanged;
  final HeroUiCheckboxVariant variant;
  final bool invalid;
  final bool enabled;
  final String? label;
  final String? helperText;
  final String? errorText;

  @override
  Widget build(BuildContext context) => RemixCheckboxGroup<T>(
    values: values,
    onChanged: onChanged,
    enabled: enabled,
    semanticLabel: label,
    child: HeroUiFieldLayout(
      label: label,
      helperText: helperText,
      errorText: errorText,
      invalid: invalid,
      enabled: enabled,
      items: [
        for (final option in options)
          HeroUiCheckboxGroupItem<T>(
            value: option.value,
            label: option.label,
            enabled: option.enabled,
            variant: variant,
            invalid: invalid,
          ),
      ],
    ),
  );
}
