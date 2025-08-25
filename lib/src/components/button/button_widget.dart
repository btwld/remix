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
///   leading: Icons.star,
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
///   leading: Icons.settings,
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
  /// Must provide either [label], [leading], [trailing], or [child].
  /// If [child] is provided, it overrides the label and icon parameters.
  const RemixButton({
    super.key,
    this.label,
    this.leading,
    this.trailing,
    this.child,
    this.enabled = true,
    this.autofocus = false,
    this.loading = false,
    this.enableFeedback = true,
    required this.onPressed,
    this.onLongPress,
    this.onDoubleTap,
    this.onFocusChange,
    this.onHoverChange,
    this.onPressChanged,
    this.onStatesChange,
    this.focusNode,
    this.style = const RemixButtonStyle.create(),
    this.isSemanticButton = true,
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  }) : assert(
          label != null || leading != null || trailing != null || child != null,
          'Must provide either label, leading, trailing, or child',
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
    this.enableFeedback = true,
    required this.onPressed,
    this.onLongPress,
    this.onDoubleTap,
    this.onFocusChange,
    this.onHoverChange,
    this.onPressChanged,
    this.onStatesChange,
    this.focusNode,
    this.style = const RemixButtonStyle.create(),
    this.isSemanticButton = true,
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  })  : label = null,
        leading = icon,
        trailing = null,
        child = StyledIcon(icon: icon);

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

  /// Callback function called when the button is long pressed.
  final VoidCallback? onLongPress;

  /// Callback function called when the button is double tapped.
  final VoidCallback? onDoubleTap;

  /// Called when focus state changes.
  final ValueChanged<bool>? onFocusChange;

  /// Called when hover state changes.
  final ValueChanged<bool>? onHoverChange;

  /// Called when pressed state changes.
  final ValueChanged<bool>? onPressChanged;

  /// Called when any widget state changes.
  final ValueChanged<Set<WidgetState>>? onStatesChange;

  /// Optional focus node to control the button's focus behavior.
  final FocusNode? focusNode;

  /// The style configuration for the button.
  ///
  /// Controls visual properties like colors, padding, typography etc.
  final RemixButtonStyle? style;

  /// Whether to provide feedback when the button is pressed.
  ///
  /// Defaults to true.
  final bool enableFeedback;

  /// Whether the button should automatically request focus when it is created.
  final bool autofocus;

  /// The label text to display in the button.
  /// If [child] is provided, this is ignored.
  final String? label;

  /// The leading icon to display in the button.
  /// If [child] is provided, this is ignored.
  final IconData? leading;

  /// The trailing icon to display in the button.
  /// If [child] is provided, this is ignored.
  final IconData? trailing;

  /// The child widget to display inside the button.
  /// If provided, overrides [label], [leading], and [trailing].
  final Widget? child;

  /// Whether the button should be treated as a semantic button.
  ///
  /// When true, the button will have proper button semantics for accessibility.
  /// Defaults to true.
  final bool isSemanticButton;

  /// The semantic label for the button.
  ///
  /// Used by screen readers to describe the button.
  final String? semanticLabel;

  /// The semantic hint for the button.
  ///
  /// Provides additional context about what will happen when the button is activated.
  final String? semanticHint;

  /// Whether to exclude child semantics.
  ///
  /// When true, the semantics of child widgets will be excluded.
  /// Defaults to false.
  final bool excludeSemantics;

  /// Cursor when hovering over the button.
  ///
  /// Defaults to [SystemMouseCursors.click] when enabled.
  final MouseCursor mouseCursor;

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
      onLongPress: widget.onLongPress,
      onDoubleTap: widget.onDoubleTap,
      enabled: _isEnabled,
      isSemanticButton: widget.isSemanticButton,
      semanticLabel: widget.semanticLabel ?? widget.label,
      semanticHint: widget.semanticHint,
      mouseCursor: widget.mouseCursor,
      enableFeedback: widget.enableFeedback,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      excludeSemantics: widget.excludeSemantics,
      onFocusChange: widget.onFocusChange,
      onHoverChange: widget.onHoverChange,
      onPressChange: widget.onPressChanged,
      onStatesChange: widget.onStatesChange,
      statesController: controller,
      child: StyleBuilder(
        style: DefaultRemixButtonStyle.merge(widget.style),
        controller: controller,
        builder: (context, spec) {
          final Label = spec.label;
          final Spinner = spec.spinner;
          final Container = spec.container;

          // Create the child widget based on whether custom child is provided
          final effectiveChild = widget.child ??
              Label(text: widget.label ?? '', leading: widget.leading, trailing: widget.trailing);

          final content = widget.loading
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Spinner(),
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

          return Container(child: content);
        },
      ),
    );
  }
}
