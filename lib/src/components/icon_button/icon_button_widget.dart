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
class RemixIconButton extends StyleWidget<IconButtonSpec> {
  /// Creates a Remix icon button.
  ///
  /// The [icon] parameter is required and specifies which icon to display.
  /// Use builders to customize rendering of specific parts.
  const RemixIconButton({
    super.style = const RemixIconButtonStyle.create(),
    super.styleSpec,
    super.key,
    required this.icon,
    this.iconBuilder,
    this.loadingBuilder,
    this.autofocus = false,
    this.loading = false,
    this.enableFeedback = true,
    required this.onPressed,
    this.onLongPress,
    this.onDoubleTap,
    this.focusNode,
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  });

  static late final styleFrom = RemixIconButtonStyle.new;


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

  bool get _isEnabled => !loading && onPressed != null;

  @override
  Widget build(BuildContext context, IconButtonSpec spec) {
    Widget? iconWidget;

    if (iconBuilder != null) {
      iconWidget = StyleSpecBuilder(
        styleSpec: spec.icon,
        builder: (context, iconSpec) => iconBuilder!(context, iconSpec, icon),
      );
    } else {
      iconWidget = StyledIcon(icon: icon, styleSpec: spec.icon);
    }

    // Build spinner (used when loading)
    final spinner = Center(
      child: loadingBuilder == null
          ? RemixSpinner(styleSpec: spec.spinner)
          : StyleSpecBuilder(
              styleSpec: spec.spinner,
              builder: loadingBuilder!,
            ),
    );

    // Create content with visibility control for loading state
    final content = Visibility(
      visible: !loading,
      maintainState: true,
      maintainAnimation: true,
      maintainSize: true,
      child: iconWidget,
    );

    // Layer spinner above the content while keeping size stable.
    final layered = Stack(
      alignment: Alignment.center,
      children: [content, if (loading) spinner],
    );

    return NakedButton(
      onPressed: _isEnabled ? onPressed : null,
      onLongPress: _isEnabled ? onLongPress : null,
      enabled: _isEnabled,
      mouseCursor: mouseCursor,
      enableFeedback: enableFeedback,
      focusNode: focusNode,
      autofocus: autofocus,
      semanticLabel: semanticLabel,
      builder: (context, states, child) {
        return MergeSemantics(
          child: Semantics(
            excludeSemantics: excludeSemantics,
            liveRegion: loading,
            label: semanticLabel ?? 'Icon Button',
            hint: semanticHint,
            child: Box(
              styleSpec: spec.container,
              child: layered,
            ),
          ),
        );
      },
    );
  }
}
