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
///       ),
///       RemixRadio<String>(
///         value: 'option2',
///         label: 'Option 2',
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
      child: StyleProvider<RadioSpec>(style: style, child: child),
    );
  }
}

// Intentionally lean: rely on Flutter's RadioGroup for registry, semantics and keyboard.
