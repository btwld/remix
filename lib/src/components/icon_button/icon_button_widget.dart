part of 'icon_button.dart';

/// Builder function for customizing icon button icon rendering.
typedef RemixIconButtonIconBuilder = Widget Function(
  BuildContext context,
  IconSpec spec,
  IconData? icon,
);

/// Builder function for customizing icon button loading state rendering.
typedef RemixIconButtonLoadingBuilder = Widget Function(
  BuildContext context,
  SpinnerSpec spec,
);

/// A customizable icon button component optimized for icon-only interactions.
/// The button is square by default and centers the icon properly.
///
/// ## Examples
///
/// ```dart
/// // Basic icon button
/// RemixIconButton(
///   icon: Icons.add,
///   onPressed: () => print('Add pressed!'),
/// )
///
/// // Custom styled icon button
/// RemixIconButton(
///   icon: Icons.delete,
///   style: RemixIconButtonStyles.baseStyle.color(Colors.red),
///   onPressed: () => print('Delete pressed!'),
/// )
///
/// // Loading icon button
/// RemixIconButton(
///   icon: Icons.save,
///   loading: true,
///   onPressed: () => print('Save pressed!'),
/// )
/// ```
class RemixIconButton extends StatefulWidget with HasEnabled {
  /// Creates a Remix icon button.
  ///
  /// The [icon] parameter is required and specifies which icon to display.
  /// Use builders to customize rendering of specific parts.
  const RemixIconButton({
    super.key,
    required this.icon,
    this.iconBuilder,
    this.loadingBuilder,
    this.enabled = true,
    this.autofocus = false,
    this.loading = false,
    this.enableFeedback = true,
    required this.onPressed,
    this.onLongPress,
    this.onDoubleTap,
    this.focusNode,
    this.style = const RemixIconButtonStyle.create(),
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  });

  static late final styleFrom = RemixIconButtonStyle.new;

  /// Whether the button is enabled.
  ///
  /// When false, the button will not respond to user interaction and
  /// will be visually styled as disabled.
  final bool enabled;

  /// Whether the button is in a loading state.
  ///
  /// When true, the button will display a spinner and become non-interactive.
  final bool loading;

  /// Callback function called when the button is pressed.
  ///
  /// If null, the button will be considered disabled.
  final VoidCallback? onPressed;

  /// Callback function called when the button is long pressed.
  final VoidCallback? onLongPress;

  /// Callback function called when the button is double tapped.
  final VoidCallback? onDoubleTap;

  /// Optional focus node to control the button's focus behavior.
  final FocusNode? focusNode;

  /// The style configuration for the button.
  ///
  /// Controls visual properties like colors, padding, size etc.
  final RemixIconButtonStyle? style;

  /// Whether to provide feedback when the button is pressed.
  ///
  /// Defaults to true.
  final bool enableFeedback;

  /// Whether the button should automatically request focus when it is created.
  final bool autofocus;

  /// The icon to display in the button.
  final IconData icon;

  /// Builder for customizing the icon rendering.
  final RemixIconButtonIconBuilder? iconBuilder;

  /// Builder for customizing the loading state rendering.
  final RemixIconButtonLoadingBuilder? loadingBuilder;

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
  State<RemixIconButton> createState() => _RemixIconButtonState();
}

class _RemixIconButtonState extends State<RemixIconButton>
    with HasWidgetStateController, HasEnabledState {
  bool get _isEnabled =>
      widget.enabled && !widget.loading && widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    return StyleBuilder(
      style: RemixIconButtonStyles.baseStyle.merge(widget.style),
      controller: controller,
      builder: (context, spec) {
        final ContainerWidget = spec.container.createWidget;
        final IconWidget = spec.icon.createWidget;

        // Build the icon content
        final iconWidget = widget.iconBuilder != null
            ? StyleSpecBuilder(
                styleSpec: spec.icon,
                builder: (context, iconSpec) =>
                    widget.iconBuilder!(context, iconSpec, widget.icon),
              )
            : IconWidget(icon: widget.icon);

        // Build spinner (used when loading)
        final spinner = widget.loadingBuilder != null
            ? StyleSpecBuilder(
                styleSpec: spec.spinner,
                builder: (context, spinnerSpec) =>
                    widget.loadingBuilder!(context, spinnerSpec),
              )
            : StyleSpecBuilder(
                styleSpec: spec.spinner,
                builder: (context, spinnerSpec) => RemixSpinner(
                  style: RemixSpinnerStyle(
                    size: spinnerSpec.size,
                    strokeWidth: spinnerSpec.strokeWidth,
                    color: spinnerSpec.color,
                    duration: spinnerSpec.duration,
                    type: spinnerSpec.spinnerType,
                  ),
                ),
              );

        // Create content with proper layering for loading states
        final content = Stack(
          alignment: Alignment.center,
          children: [
            // Underlying icon: keep in the tree with state, but hide when loading
            Visibility(
              visible: !widget.loading,
              maintainState: true,
              maintainAnimation: true,
              maintainSize: true,
              child: iconWidget,
            ),
            // Spinner overlay, visible only when loading
            if (widget.loading) Center(child: spinner),
          ],
        );

        // Wrap in container and pressable
        return Semantics(
          excludeSemantics: widget.excludeSemantics,
          enabled: _isEnabled,
          button: true,
          focusable: _isEnabled,
          liveRegion: widget.loading,
          label: widget.semanticLabel ?? 'Icon Button',
          value: widget.loading ? 'Loading' : null,
          hint: widget.semanticHint,
          onTap: _isEnabled ? widget.onPressed : null,
          child: NakedButton(
            onPressed: _isEnabled ? widget.onPressed : null,
            onLongPress: _isEnabled ? widget.onLongPress : null,
            onDoubleTap: _isEnabled ? widget.onDoubleTap : null,
            enabled: _isEnabled,
            mouseCursor: widget.mouseCursor,
            enableFeedback: widget.enableFeedback,
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
            onFocusChange: (focused) => controller.focused = focused,
            onHoverChange: (hovered) => controller.hovered = hovered,
            onPressChange: (pressed) => controller.pressed = pressed,
            child: ContainerWidget(child: content),
            builder: (context, states, child) => child!,
          ),
        );
      },
    );
  }
}
