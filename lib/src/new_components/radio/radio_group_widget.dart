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
class RemixRadioGroup<T> extends StatefulWidget {
  const RemixRadioGroup({
    super.key,
    required this.value,
    required this.onChanged,
    required this.child,
    this.enabled = true,
    this.style = const RadioStyle.create(),
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
  final RadioStyle style;

  @override
  State<RemixRadioGroup<T>> createState() => _RemixRadioGroupState<T>();
}

class _RemixRadioGroupState<T> extends State<RemixRadioGroup<T>> {
  T? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  void _handleRadioValueChange(T? value) {
    setState(() {
      _value = value;
    });
    widget.onChanged?.call(value);
  }

  @override
  void didUpdateWidget(covariant RemixRadioGroup<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _value = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _RadioGroupScope<T>(
      groupValue: _value,
      onChanged: widget.enabled ? _handleRadioValueChange : null,
      enabled: widget.enabled,
      style: widget.style,
      child: widget.child,
    );
  }
}

/// An InheritedWidget that provides radio group state to descendant radio buttons.
class _RadioGroupScope<T> extends InheritedWidget {
  const _RadioGroupScope({
    required super.child,
    required this.groupValue,
    required this.onChanged,
    required this.enabled,
    this.style,
  });

  static _RadioGroupScope<T>? maybeOf<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final bool enabled;
  final RadioStyle? style;

  @override
  bool updateShouldNotify(_RadioGroupScope<T> oldWidget) {
    return groupValue != oldWidget.groupValue ||
        onChanged != oldWidget.onChanged ||
        enabled != oldWidget.enabled ||
        style != oldWidget.style;
  }
}

/// Extension to make RemixRadio work seamlessly with RemixRadioGroup
extension RemixRadioGroupExtension<T> on RemixRadio<T> {
  /// Creates a version of this radio button that works with a RemixRadioGroup.
  ///
  /// When used inside a RemixRadioGroup, the groupValue and onChanged
  /// are automatically managed by the group.
  Widget inGroup() {
    return Builder(
      builder: (context) {
        final groupScope = _RadioGroupScope.maybeOf<T>(context);

        if (groupScope == null) {
          // If not in a group, use the radio as-is
          return this;
        }

        // Create a new radio with group-managed properties
        return RemixRadio<T>(
          key: key,
          value: value,
          groupValue: groupScope.groupValue,
          onChanged:
              groupScope.enabled && enabled ? groupScope.onChanged : null,
          enabled: groupScope.enabled && enabled,
          style: style,
          label: label,
          focusNode: focusNode,
        );
      },
    );
  }
}
