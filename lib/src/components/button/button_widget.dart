part of 'button.dart';

/// Builder function for customizing button text rendering.
typedef RemixButtonTextBuilder = Widget Function(
  BuildContext context,
  TextSpec spec,
  String text,
);

/// Builder function for customizing button icon rendering.
typedef RemixButtonIconBuilder = Widget Function(
  BuildContext context,
  IconSpec spec,
  IconData? icon,
);

/// Builder function for customizing button loading state rendering.
typedef RemixButtonLoadingBuilder = Widget Function(
  BuildContext context,
  SpinnerSpec spec,
);

/// A customizable button component that supports text with optional icons, loading states, and styling.
/// The button integrates with the Mix styling system and follows Remix design patterns.
/// For icon-only buttons, use RemixIconButton instead.
///
/// ## Examples
///
/// ```dart
/// // Basic button
/// RemixButton(
///   label: 'Click Me',
///   onPressed: () => print('Button pressed!'),
/// )
///
/// // Button with icon
/// RemixButton(
///   label: 'Save Changes',
///   icon: Icons.save,
///   onPressed: () => print('Save pressed!'),
/// )
///
/// // Loading button
/// RemixButton(
///   label: 'Processing',
///   loading: true,
///   onPressed: () => print('Processing...'),
/// )
/// ```
///
class RemixButton extends StatefulWidget with HasEnabled {
  /// Creates a Remix button.
  ///
  /// The [label] parameter is required and specifies the button text.
  /// Use builders to customize rendering of specific parts.
  const RemixButton({
    super.key,
    required this.label,
    this.icon,
    this.textBuilder,
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
    this.style = const RemixButtonStyle.create(),
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  });

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
  /// If [textBuilder] is provided, this is ignored.
  final String label;

  /// The icon to display in the button.
  /// If [builder] is provided, this is ignored.
  final IconData? icon;

  /// Builder for customizing the text rendering.
  final RemixButtonTextBuilder? textBuilder;

  /// Builder for customizing the icon rendering.
  final RemixButtonIconBuilder? iconBuilder;

  /// Builder for customizing the loading state rendering.
  final RemixButtonLoadingBuilder? loadingBuilder;

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
    with HasWidgetStateController, HasEnabledState {
  bool get _isEnabled =>
      widget.enabled && !widget.loading && widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    return StyleBuilder(
      style: RadixButtonStyle.base().merge(widget.style),
      controller: controller,
      builder: (context, spec) {
        final FlexContaineWidget = spec.container.createWidget;
        final TextWidget = spec.label.createWidget;
        final IconWidget = spec.icon.createWidget;

        // Build icon widget (optional leading icon)
        final iconWidget = widget.icon != null || widget.iconBuilder != null
            ? (widget.iconBuilder != null
                ? StyleSpecBuilder(
                    styleSpec: spec.icon,
                    builder: (context, iconSpec) =>
                        widget.iconBuilder!(context, iconSpec, widget.icon),
                  )
                : IconWidget(icon: widget.icon))
            : null;

        // Build text widget (always present since label is required)
        final textWidget = widget.textBuilder != null
            ? StyleSpecBuilder(
                styleSpec: spec.label,
                builder: (context, textSpec) => widget.textBuilder!(
                  context,
                  textSpec,
                  widget.label,
                ),
              )
            : TextWidget(widget.label);

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

        // Create content inside the styled container. The container remains
        // visible in loading state to preserve background, padding and radius.
        final baseContainer = FlexContaineWidget(
          direction: Axis.horizontal,
          children: [
            Visibility(
              visible: !widget.loading,
              maintainState: true,
              maintainAnimation: true,
              maintainSize: true,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [if (iconWidget != null) iconWidget, textWidget],
              ),
            ),
          ],
        );

        // Layer spinner above the container while keeping size stable.
        final layered = Stack(
          alignment: Alignment.center,
          children: [
            baseContainer,
            if (widget.loading) Center(child: spinner),
          ],
        );

        // Use NakedPressable directly with integrated semantics - cleaner widget tree
        return Semantics(
          excludeSemantics: widget.excludeSemantics,
          enabled: _isEnabled,
          button: true,
          focusable: _isEnabled,
          liveRegion: widget.loading,
          label: widget.semanticLabel ?? widget.label,
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
            child: layered,
            builder: (context, states, child) => child!,
          ),
        );
      },
    );
  }
}
