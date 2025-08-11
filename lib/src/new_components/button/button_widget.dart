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
class RemixButton extends StatefulWidget implements Disableable {
  /// Creates a Remix button.
  ///
  /// The [label] and [onPressed] parameters are required unless [child] is provided.
  /// If [child] is provided, it overrides the label and icon parameters.
  RemixButton({
    super.key,
    String? label,
    IconData? icon,
    Widget? child,
    this.enabled = true,
    this.loading = false,
    this.spinnerBuilder,
    this.enableHapticFeedback = true,
    required this.onPressed,
    this.focusNode,
    this.variants = const [],
    this.style,
  })  : assert(child != null || label != null,
            'Either child or label must be provided'),
        label = label,
        icon = icon,
        child = child;

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
    this.loading = false,
    this.spinnerBuilder,
    this.enableHapticFeedback = true,
    required this.onPressed,
    this.focusNode,
    this.variants = const [],
    this.style,
  })  : label = null,
        icon = icon,
        child = Icon(icon);

  /// Creates a Remix button with a raw child widget.
  ///
  /// This constructor allows for custom button content beyond the default layout.
  /// The [child] parameter must be provided and will be used as the button's content.
  ///
  /// Example:
  /// ```dart
  /// RemixButton.raw(
  ///   child: Icon(Icons.star),
  ///   onPressed: () {},
  ///   style: ButtonStyles.primary,
  /// )
  /// ```
  const RemixButton.raw({
    super.key,
    required Widget child,
    this.enabled = true,
    this.loading = false,
    this.spinnerBuilder,
    this.enableHapticFeedback = true,
    required this.onPressed,
    this.focusNode,
    this.variants = const [],
    this.style,
  })  : label = null,
        icon = null,
        child = child;

  /// Whether the button is enabled.
  ///
  /// When false, the button will not respond to user interaction and
  /// will be visually styled as disabled.
  @override
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

  /// Custom widget to display when the button is in loading state.
  ///
  /// If not provided, a default spinner from the button's spec will be used.
  ///
  /// Example:
  /// ```dart
  /// RemixButton(
  ///   label: 'Submit',
  ///   loading: true,
  ///   spinnerBuilder: (context) => CircularProgressIndicator(),
  ///   onPressed: () {},
  /// )
  /// ```
  final WidgetBuilder? spinnerBuilder;

  /// The style configuration for the button.
  ///
  /// Controls visual properties like colors, padding, typography etc.
  final ButtonStyle? style;

  /// Whether to provide haptic feedback when the button is pressed.
  ///
  /// Defaults to true.
  final bool enableHapticFeedback;

  /// The label text to display in the button.
  /// If [child] is provided, this is ignored.
  final String? label;

  /// The icon to display in the button.
  /// If [child] is provided, this is ignored.
  final IconData? icon;

  /// The child widget to display inside the button.
  /// If provided, overrides [label] and [icon].
  final Widget? child;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  @override
  State<RemixButton> createState() => _RemixButtonState();
}

class _RemixButtonState extends State<RemixButton> with MixControllerMixin {
  /// Builds the loading overlay that shows a spinner while preserving layout.
  Widget _buildLoadingOverlay(
    ButtonSpec? spec,
    Widget child,
    BuildContext context,
  ) {
    final Widget spinner = widget.spinnerBuilder?.call(context) ??
        spec?.spinner() ??
        SizedBox(
          width: 16,
          height: 16,
          child: RemixSpinner(style: DefaultSpinnerStyle),
        );

    return widget.loading
        ? Stack(
            alignment: Alignment.center,
            children: [spinner, Opacity(opacity: 0.0, child: child)],
          )
        : child;
  }

  bool get _isEnabled => widget.enabled && !widget.loading;

  @override
  Widget build(BuildContext context) {
    return NakedButton(
      onPressed: widget.onPressed,
      onHoverState: (state) => stateController.hovered = state,
      onPressedState: (state) => stateController.pressed = state,
      onFocusState: (state) => stateController.focused = state,
      onDisabledState: (state) => stateController.disabled = state,
      enabled: _isEnabled,
      enableHapticFeedback: widget.enableHapticFeedback,
      focusNode: widget.focusNode,
      child: StyleBuilder(
        style: DefaultButtonStyle.merge(widget.style),
        builder: (context, spec) {

          // Create the child widget based on whether custom child is provided
          final effectiveChild = widget.child ??
              RemixLabel(
                widget.label!,
                icon: widget.icon,
                style: LabelStyle.value(spec.label),
              );

          return spec.container(
            child: widget.loading
                ? Builder(builder: (context) {
                    return _buildLoadingOverlay(
                      spec,
                      effectiveChild,
                      context,
                    );
                  })
                : effectiveChild,
          );
        },
        controller: stateController,
      ),
    );
  }
}
