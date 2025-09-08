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
///   style: RemixButtonStyles.solid,
///   onPressed: () => print('Edit pressed!'),
/// )
/// ```
///
class RemixButton extends StatefulWidget with HasEnabled {
  /// Creates a Remix button.
  ///
  /// Must provide either [label] or [icon].
  /// Use builders to customize rendering of specific parts.
  const RemixButton({
    super.key,
    this.label,
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
  }) : assert(
          label != null || icon != null,
          'Must provide either label or icon',
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
    this.focusNode,
    this.style = const RemixButtonStyle.create(),
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  })  : label = null,
        icon = icon,
        textBuilder = null,
        iconBuilder = null,
        loadingBuilder = null;

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
  /// If [builder] is provided, this is ignored.
  final String? label;

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
      style: RemixButtonStyles.baseStyle.merge(widget.style),
      controller: controller,
      builder: (context, spec) {
        final FlexContaineWidget = spec.container.createWidget;
        final TextWidget = spec.label.createWidget;
        final IconWidget = spec.icon.createWidget;

        // Build the button content directly using FlexBox
        final List<Widget> children = [];

        // Add icon if present (leading icon pattern)
        if (widget.icon != null || widget.iconBuilder != null) {
          final iconWidget = widget.iconBuilder != null
              ? StyleSpecBuilder(
                  styleSpec: spec.icon,
                  builder: (context, iconSpec) =>
                      widget.iconBuilder!(context, iconSpec, widget.icon),
                )
              : (widget.icon != null
                  ? IconWidget(icon: widget.icon)
                  : const SizedBox.shrink());
          children.add(iconWidget);
        }

        // Add text if present
        if (widget.label?.isNotEmpty == true || widget.textBuilder != null) {
          final textWidget = widget.textBuilder != null
              ? StyleSpecBuilder(
                  styleSpec: spec.label,
                  builder: (context, textSpec) => widget.textBuilder!(
                    context,
                    textSpec,
                    widget.label ?? '',
                  ),
                )
              : TextWidget(widget.label ?? '');
          children.add(textWidget);
        }

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
                    style: spinnerSpec.style,
                  ),
                ),
              );

        // Create content with FlexBox layout
        Widget content =
            FlexContaineWidget(direction: Axis.horizontal, children: children);

        // Use a layered approach that preserves size and state of the content
        // while showing a centered spinner on top when loading.
        final layered = Stack(
          alignment: Alignment.center,
          children: [
            // Underlying content: keep in the tree with state, but hide when loading
            Visibility(
              visible: !widget.loading,
              maintainState: true,
              maintainAnimation: true,
              maintainSize: true,
              child: content,
            ),
            // Spinner overlay, visible only when loading
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
          child: pressable.NakedPressable(
            onPressed: _isEnabled ? widget.onPressed : null,
            onDoubleTap: _isEnabled ? widget.onDoubleTap : null,
            onLongPress: _isEnabled ? widget.onLongPress : null,
            enabled: _isEnabled,
            mouseCursor: widget.mouseCursor,
            disabledMouseCursor: SystemMouseCursors.basic,
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
            onFocusChange: (focused) => controller.focused = focused,
            statesController: controller,
            enableFeedback: widget.enableFeedback,
            child: layered,
            builder: (context, states, child) => child!,
          ),
        );
      },
    );
  }
}
