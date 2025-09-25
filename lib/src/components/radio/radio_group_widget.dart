part of 'radio.dart';

/// A widget that groups multiple [RemixRadio] widgets together.
///
/// The [RemixRadioGroup] manages the selected value for a group of radio buttons,
/// ensuring that only one radio button in the group can be selected at a time.
/// It also provides style inheritance to all child [RemixRadio] widgets.
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
///           RemixRadio<String>(value: 'option1'),
///           const SizedBox(width: 8),
///           const Text('Option 1'),
///         ],
///       ),
///       Row(
///         children: [
///           RemixRadio<String>(value: 'option2'),
///           const SizedBox(width: 8),
///           const Text('Option 2'),
///         ],
///       ),
///     ],
///   ),
/// )
/// ```
///
/// With custom styling:
/// ```dart
/// RemixRadioGroup<String>(
///   groupValue: _selectedValue,
///   onChanged: (value) => setState(() => _selectedValue = value),
///   style: RemixRadioStyle().indicatorContainer(
///     (container) => container.border(color: Colors.blue),
///   ),
///   child: // Your radio buttons...
/// )
/// ```
class RemixRadioGroup<T> extends StatelessWidget {
  const RemixRadioGroup({
    super.key,
    required this.groupValue,
    required this.onChanged,
    required this.child,
    this.style = const RemixRadioStyle.create(),
  });

  /// The currently selected value for the group.
  final T? groupValue;

  /// Called when a radio button in the group is selected.
  final ValueChanged<T?> onChanged;

  /// The child widget that contains the radio buttons.
  final Widget child;

  /// The style configuration for the radio group.
  final RemixRadioStyle style;

  @override
  Widget build(BuildContext context) {
    // Use Flutter's RadioGroup directly (NakedRadioGroup no longer required)
    return RadioGroup<T>(
      groupValue: groupValue,
      onChanged: onChanged,
      child: StyleBuilder<RemixRadioSpec>(
        style: style,
        inheritable: true,
        builder: (context, spec) => child,
      ),
    );
  }
}
