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
    this.onChanged,
    required this.child,
  });

  /// The currently selected value for the group.
  final T? groupValue;

  /// Called when a radio button in the group is selected.
  ///
  /// When null, the radio group is disabled and selection cannot change.
  final ValueChanged<T?>? onChanged;

  /// The child widget that contains the radio buttons.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final groupEnabled = onChanged != null;

    return RadioGroup<T>(
      groupValue: groupValue,
      onChanged: onChanged ?? _disabledRadioGroupOnChanged,
      child: _RemixRadioGroupScope<T>(enabled: groupEnabled, child: child),
    );
  }
}

void _disabledRadioGroupOnChanged<T>(T? _) => null;

class _RemixRadioGroupScope<T> extends InheritedWidget {
  const _RemixRadioGroupScope({required this.enabled, required super.child});

  static _RemixRadioGroupScope<T>? maybeOf<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  final bool enabled;

  @override
  bool updateShouldNotify(_RemixRadioGroupScope<T> oldWidget) {
    return enabled != oldWidget.enabled;
  }
}
