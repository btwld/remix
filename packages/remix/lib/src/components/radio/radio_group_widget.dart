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
///       Row(
///         children: [
///           RemixRadio<String>(
///             value: 'option1',
///             style: radioStyle,
///           ),
///           const SizedBox(width: 8),
///           const Text('Option 1'),
///         ],
///       ),
///       Row(
///         children: [
///           RemixRadio<String>(
///             value: 'option2',
///             style: radioStyle,
///           ),
///           const SizedBox(width: 8),
///           const Text('Option 2'),
///         ],
///       ),
///     ],
///   ),
/// )
/// ```
class RemixRadioGroup<T> extends StatelessWidget {
  const RemixRadioGroup({
    super.key,
    required this.groupValue,
    required this.onChanged,
    required this.child,
  });

  /// The currently selected value for the group.
  final T? groupValue;

  /// Called when a radio button in the group is selected.
  final ValueChanged<T?> onChanged;

  /// The child widget that contains the radio buttons.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RadioGroup<T>(
      groupValue: groupValue,
      onChanged: onChanged,
      child: child,
    );
  }
}
