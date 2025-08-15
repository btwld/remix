part of 'radio.dart';

/// A widget that groups multiple [RemixRadio] widgets together.
///
/// The [RemixRadioGroup] manages the selected value for a group of radio buttons,
/// ensuring that only one radio button in the group can be selected at a time.
///
/// ## Example
///
/// ```dart
/// RemixRadioGroup<String>(
///   value: _selectedValue,
///   onChanged: (value) {
///     setState(() {
///       _selectedValue = value;
///     });
///   },
///   children: [
///     RemixRadio<String>(
///       value: 'option1',
///       groupValue: _selectedValue,
///       label: 'Option 1',
///     ),
///     RemixRadio<String>(
///       value: 'option2',
///       groupValue: _selectedValue,
///       label: 'Option 2',
///     ),
///   ],
/// )
/// ```
class RemixRadioGroup<T> extends StatelessWidget {
  const RemixRadioGroup({
    super.key,
    required this.value,
    required this.onChanged,
    required this.child,
    this.enabled = true,
    this.style = const RemixRadioStyle.create(),
  });

  /// The currently selected value for the group.
  final T? value;

  /// Called when a radio button in the group is selected.
  final ValueChanged<T?>? onChanged;

  /// The child widget that contains the radio buttons.
  final Widget child;

  /// Whether the radio group is enabled.
  final bool enabled;

  /// The style configuration for the radio group.
  final RemixRadioStyle style;

  @override
  Widget build(BuildContext context) {
    // Wrap with NakedRadioGroup for keyboard navigation and focus management
    // NakedRadioGroupScope is automatically provided by NakedRadioGroup
    return NakedRadioGroup<T>(
      groupValue: value,
      onChanged: enabled ? onChanged : null,
      enabled: enabled,
      child: StyleProvider<RadioSpec>(style: style, child: child),
    );
  }
}
