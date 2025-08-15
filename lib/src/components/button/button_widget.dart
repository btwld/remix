part of 'button.dart';

/// A customizable button component that supports icons, loading states, and styling.
/// The button integrates with the Mix styling system and follows Remix design patterns.
///
/// ## Examples
///
/// ```dart
/// // Basic button
/// RemixButton(
///   label: 'Click Me',
///   icon: Icons.star,
///   onPressed: () => print('Button pressed!'),
/// )
///
/// // Variant buttons with labels
/// RemixButton.primary(
///   label: 'Primary Button',
///   onPressed: () => print('Primary pressed!'),
/// )
///
/// RemixButton.secondary(
///   label: 'Secondary Button',
///   icon: Icons.settings,
///   onPressed: () => print('Secondary pressed!'),
/// )
///
/// // Icon-only buttons (use .icon constructor with style)
/// RemixButton.icon(
///   Icons.add,
///   style: ButtonStyles.primary,
///   onPressed: () => print('Add pressed!'),
/// )
///
/// RemixButton.icon(
///   Icons.edit,
///   style: ButtonStyles.outline,
///   onPressed: () => print('Edit pressed!'),
/// )
/// ```
///
class RemixButton extends StatefulWidget with HasEnabled, HasFocused {
  /// Creates a Remix button.
  ///
  /// Must provide either [label], [icon], or [child].
  /// If [child] is provided, it overrides the label and icon parameters.
  const RemixButton({
    super.key,
    this.label,
    this.icon,
    this.child,
    this.enabled = true,
    this.autofocus = false,
    this.loading = false,
    this.enableHapticFeedback = true,
    required this.onPressed,
    this.focusNode,
    this.style = const RemixButtonStyle.create(),
  }) : assert(
          label != null || icon != null || child != null,
          'Must provide either label, icon, or child',
        );

  /// Creates a Remix button with only an icon.
  ///
  /// This constructor creates a button with just an icon and no label.
  /// The [icon] parameter is required and will be displayed as the button's content.
  ///
  /// Example:
  /// ```dart
  /// RemixButton.icon(
  ///   Icons.star,
  ///   onPressed: () {},
  ///   style: ButtonStyles.primary,
  /// )
  /// ```
  RemixButton.icon(
    IconData icon, {
    super.key,
    this.enabled = true,
    this.autofocus = false,
    this.loading = false,
    this.enableHapticFeedback = true,
    required this.onPressed,
    this.focusNode,
    this.style = const RemixButtonStyle.create(),
  })  : label = null,
        icon = icon,
        child = Icon(icon);

  static late final styleFrom = RemixButtonStyle.new;

  /// Whether the button is enabled.
  ///
  /// When false, the button will not respond to user interaction and
  /// will be visually styled as disabled.
  final bool enabled;

  /// Whether the button is in a loading state.
  ///
  /// When true, the button will display a spinner and become non-interactive.
  /// The spinner can be customized via [spinnerBuilder].
  final bool loading;

  /// Callback function called when the button is pressed.
  ///
  /// If null, the button will be considered disabled.
  final VoidCallback? onPressed;

  /// Optional focus node to control the button's focus behavior.
  final FocusNode? focusNode;

  /// The style configuration for the button.
  ///
  /// Controls visual properties like colors, padding, typography etc.
  final RemixButtonStyle? style;

  /// Whether to provide haptic feedback when the button is pressed.
  ///
  /// Defaults to true.
  final bool enableHapticFeedback;

  /// Whether the button should automatically request focus when it is created.
  final bool autofocus;

  /// The label text to display in the button.
  /// If [child] is provided, this is ignored.
  final String? label;

  /// The icon to display in the button.
  /// If [child] is provided, this is ignored.
  final IconData? icon;

  /// The child widget to display inside the button.
  /// If provided, overrides [label] and [icon].
  final Widget? child;

  @override
  State<RemixButton> createState() => _RemixButtonState();
}

class _RemixButtonState extends State<RemixButton>
    with HasWidgetStateController, HasEnabledState, HasFocusedState {
  bool get _isEnabled =>
      widget.enabled && !widget.loading && widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    return NakedButton(
      onPressed: widget.onPressed,
      onHoverChange: (state) => controller.hovered = state,
      onPressChange: (state) => controller.pressed = state,
      enabled: _isEnabled,
      enableHapticFeedback: widget.enableHapticFeedback,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      child: StyleBuilder(
        style: DefaultRemixButtonStyle.merge(widget.style),
        controller: controller,
        builder: (context, spec) {
          // Create the child widget based on whether custom child is provided
          final effectiveChild = widget.child ??
              RemixLabel(
                widget.label ?? '',
                icon: widget.icon,
                style: RemixLabelStyle.value(spec.label),
              );

          final content = widget.loading
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    RemixSpinner(style: RemixSpinnerStyle.value(spec.spinner)),
                    Visibility(
                      visible: false,
                      maintainState: true,
                      maintainAnimation: true,
                      maintainSize: true,
                      child: effectiveChild,
                    ),
                  ],
                )
              : effectiveChild;

          return spec.container(child: content);
        },
      ),
    );
  }
}
