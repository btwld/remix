import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'field_layout.dart';
import 'radio.dart';

/// One option of a [HeroUiRadioGroup].
class HeroUiRadioOption<T> {
  const HeroUiRadioOption({
    required this.value,
    required this.label,
    this.description,
    this.enabled = true,
  });

  final T value;
  final String label;
  final String? description;
  final bool enabled;
}

/// A [RemixRadioGroup] of labeled [HeroUiRadio] options.
///
/// [variant], [invalid], and [enabled] apply to every option. While [invalid],
/// [errorText] shows after [helperText].
class HeroUiRadioGroup<T> extends StatelessWidget {
  const HeroUiRadioGroup({
    super.key,
    required this.groupValue,
    required this.options,
    this.onChanged,
    this.orientation = Axis.vertical,
    this.variant = .primary,
    this.invalid = false,
    this.enabled = true,
    this.label,
    this.helperText,
    this.errorText,
  });

  final T? groupValue;
  final List<HeroUiRadioOption<T>> options;
  final ValueChanged<T?>? onChanged;
  final Axis orientation;
  final HeroUiRadioVariant variant;
  final bool invalid;
  final bool enabled;
  final String? label;
  final String? helperText;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final interactive = enabled && onChanged != null;
    final items = [
      for (final option in options)
        _row(option, optionEnabled: interactive && option.enabled),
    ];
    return RemixRadioGroup<T>(
      groupValue: groupValue,
      onChanged: onChanged,
      enabled: enabled,
      semanticLabel: label,
      child: HeroUiFieldLayout(
        axis: orientation,
        label: label,
        helperText: helperText,
        errorText: errorText,
        invalid: invalid,
        enabled: interactive,
        items: items,
      ),
    );
  }

  Widget _row(HeroUiRadioOption<T> option, {required bool optionEnabled}) =>
      HeroUiDescribedControl(
        descriptionInset: heroUiRadioSize + heroUiControlGap,
        enabled: optionEnabled,
        description: option.description,
        control: HeroUiRadio<T>(
          value: option.value,
          label: option.label,
          variant: variant,
          invalid: invalid,
          enabled: optionEnabled,
        ),
      );
}
