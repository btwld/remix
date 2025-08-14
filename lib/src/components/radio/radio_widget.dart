part of 'radio.dart';

/// A customizable radio button component.
///
/// ## Example
///
/// ```dart
/// RemixRadio<String>(
///   value: 'option1',
///   groupValue: _selectedValue,
///   onChanged: (value) {
///     setState(() {
///       _selectedValue = value;
///     });
///   },
///   label: 'Option 1',
/// )
/// ```
class RemixRadio<T> extends StatefulWidget implements Disableable {
  const RemixRadio({
    super.key,
    required this.value,
    this.groupValue,
    this.onChanged,
    this.enabled = true,
    this.enableHapticFeedback = true,
    this.style = const RadioStyle.create(),
    this.label,
    this.focusNode,
  });

  /// The value represented by this radio button.
  final T value;

  /// The currently selected value for a group of radio buttons.
  final T? groupValue;

  /// Called when the user selects this radio button.
  final ValueChanged<T?>? onChanged;

  /// Whether this radio button is enabled.
  @override
  final bool enabled;

  /// Whether to enable haptic feedback when selected.
  final bool enableHapticFeedback;

  /// The style configuration for the radio button.
  final RadioStyle style;

  /// An optional label that will be displayed next to the radio button.
  final String? label;

  /// The focus node for the radio button.
  final FocusNode? focusNode;

  bool get selected => value == groupValue;

  @override
  State<RemixRadio<T>> createState() => _RemixRadioState<T>();
}

class _RemixRadioState<T> extends State<RemixRadio<T>>
    with MixControllerMixin, DisableableMixin, SelectableMixin {
  
  T? get _groupValue {
    // Check if we're inside a RadioGroup
    final groupScope = _RadioGroupScope.maybeOf<T>(context);
    if (groupScope != null) {
      return groupScope.groupValue;
    }
    // Otherwise use the provided groupValue
    return widget.groupValue;
  }

  ValueChanged<T?>? get _onChanged {
    // Check if we're inside a RadioGroup
    final groupScope = _RadioGroupScope.maybeOf<T>(context);
    if (groupScope != null) {
      return widget.enabled && groupScope.enabled ? groupScope.onChanged : null;
    }
    // Otherwise use the provided onChanged
    return widget.onChanged;
  }

  bool get _enabled {
    // Check if we're inside a RadioGroup
    final groupScope = _RadioGroupScope.maybeOf<T>(context);
    if (groupScope != null) {
      return widget.enabled && groupScope.enabled;
    }
    return widget.enabled;
  }

  RadioStyle get _style {
    // Check if we're inside a RadioGroup
    final groupScope = _RadioGroupScope.maybeOf<T>(context);
    if (groupScope != null && groupScope.style != null) {
      return groupScope.style!.merge(widget.style);
    }
    return widget.style;
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.value == _groupValue;
    
    return GestureDetector(
      onTap: _enabled && _onChanged != null 
          ? () => _onChanged!(widget.value) 
          : null,
      child: MouseRegion(
        onEnter: (_) => stateController.hovered = true,
        onExit: (_) => stateController.hovered = false,
        cursor: _enabled 
            ? SystemMouseCursors.click 
            : SystemMouseCursors.forbidden,
        child: FocusableActionDetector(
          enabled: _enabled,
          focusNode: widget.focusNode,
          onFocusChange: (focused) => stateController.focused = focused,
          child: StyleBuilder(
            style: DefaultRadioStyle.merge(_style),
            builder: (context, spec) {
              final radio = spec.indicatorContainer(
                child: isSelected ? spec.indicator() : null,
              );

              if (widget.label == null) {
                return radio;
              }

              return spec.container(
                direction: Axis.horizontal,
                children: [
                  radio,
                  spec.label(widget.label!)
                ]
              );
            },
            controller: stateController,
          ),
        ),
      ),
    );
  }
}
