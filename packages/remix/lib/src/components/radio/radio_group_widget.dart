part of 'radio.dart';

/// A widget that groups multiple [RemixRadio] widgets together.
///
/// The [RemixRadioGroup] manages the selected value for a group of radio buttons,
/// ensuring that only one radio button in the group can be selected at a time.
/// This widget is purely behavioral and does not provide any styling.
/// Each [RemixRadio] widget must be styled individually.
///
/// ## Examples
///
/// Basic usage:
/// ```dart
/// RemixRadioGroup<String>(
///   groupValue: _selectedValue,
///   onChanged: (value) {
///     setState(() {
///       _selectedValue = value;
///     });
///   },
///   child: Column(
///     children: [
///       RemixRadio<String>(
///         value: 'option1',
///         label: 'Option 1',
///         style: radioStyle,
///       ),
///       RemixRadio<String>(
///         value: 'option2',
///         label: 'Option 2',
///         style: radioStyle,
///       ),
///     ],
///   ),
/// )
/// ```
class RemixRadioGroup<T> extends StatelessWidget {
  const RemixRadioGroup({
    super.key,
    required this.groupValue,
    this.onChanged,
    this.enabled = true,
    this.semanticLabel,
    required this.child,
  });

  /// The currently selected value for the group.
  final T? groupValue;

  /// Called when a radio button in the group is selected.
  ///
  /// When null, the radio group is disabled and selection cannot change.
  final ValueChanged<T?>? onChanged;

  /// Whether the group is enabled.
  final bool enabled;

  /// Accessible name for the radio group.
  final String? semanticLabel;

  /// The child widget that contains the radio buttons.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return NakedRadioGroup<T>(
      groupValue: groupValue,
      onChanged: onChanged,
      enabled: enabled,
      semanticLabel: semanticLabel,
      child: child,
    );
  }
}
