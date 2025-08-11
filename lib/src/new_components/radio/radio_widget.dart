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
    required this.groupValue,
    this.onChanged,
    this.enabled = true,
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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.enabled && widget.onChanged != null
          ? () => widget.onChanged!(widget.value)
          : null,
      child: MouseRegion(
        onEnter: (_) => stateController.hovered = true,
        onExit: (_) => stateController.hovered = false,
        child: StyleBuilder(
          style: DefaultRadioStyle.merge(widget.style),
          builder: (context, spec) {
            final radio = spec.indicatorContainer(
              child: widget.selected ? spec.indicator() : null,
            );

            if (widget.label == null) {
              return radio;
            }

            return spec.container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  radio,
                  const SizedBox(width: 8),
                  spec.label(widget.label!),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
