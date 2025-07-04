part of 'checkbox.dart';

/// A customizable checkbox component that supports various styles and behaviors.
/// The checkbox integrates with the Mix styling system and follows Remix design patterns.
///
/// ## Example
///
/// ```dart
/// RxCheckbox(
///   selected: _isChecked,
///   onChanged: (value) {
///     setState(() {
///       _isChecked = value;
///     });
///   },
///   iconChecked: Icons.check_rounded,
///   iconUnchecked: Icons.close_rounded,
///   style: RxCheckboxStyle()
///     ..icon.size(24)
///     ..icon.color(Colors.blue),
///   label: 'Accept Terms',
/// )
/// ```

class RxCheckbox extends StatefulWidget implements Disableable, Selectable {
  const RxCheckbox({
    super.key,
    this.enabled = true,
    required this.selected,
    this.onChanged,
    this.iconChecked = Icons.check_rounded,
    this.iconUnchecked,
    this.style,
    this.variants = const [],
    this.label,
    this.focusNode,
  });

  /// {@macro remix.component.enabled}
  @override
  final bool enabled;

  /// {@macro remix.component.selected}
  @override
  final bool selected;

  /// The icon to display when the checkbox is checked.
  final IconData iconChecked;

  /// The icon to display when the checkbox is unchecked.
  final IconData? iconUnchecked;

  /// The callback function that is called when the checkbox is tapped.
  final ValueChanged<bool>? onChanged;

  /// {@macro remix.component.style}
  final RxCheckboxStyle? style;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  /// An optional label that will be displayed next to the checkbox.
  final String? label;

  /// {@macro remix.component.focusNode}
  final FocusNode? focusNode;

  @override
  State<RxCheckbox> createState() => _RxCheckboxState();
}

class _RxCheckboxState extends State<RxCheckbox>
    with MixControllerMixin, DisableableMixin, SelectableMixin {
  RxCheckboxStyle get _style =>
      RxCheckboxStyle._default().merge(widget.style ?? RxCheckboxStyle());

  @override
  Widget build(BuildContext context) {
    return NakedCheckbox(
      value: widget.selected,
      onChanged: (value) => widget.onChanged?.call(value ?? false),
      onHoverState: (state) {
        mixController.hovered = state;
      },
      onPressedState: (state) {
        mixController.pressed = state;
      },
      onFocusState: (state) {
        mixController.focused = state;
      },
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      child: RemixBuilder(
        builder: (context) {
          final spec = CheckboxSpec.of(context);

          final ContainerLayout = spec.container;
          final ContainerWidget = spec.indicatorContainer;
          final IconWidget = spec.indicator;

          return ContainerLayout(
            direction: Axis.horizontal,
            children: [
              ContainerWidget(
                child: IconWidget(
                  widget.selected
                      ? widget.iconChecked
                      : (widget.iconUnchecked ?? widget.iconChecked),
                ),
              ),
              if (widget.label != null) spec.label(widget.label!),
            ],
          );
        },
        style: Style(_style).applyVariants(widget.variants),
        controller: mixController,
      ),
    );
  }
}
