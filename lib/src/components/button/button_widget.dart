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
class RemixButton extends StatelessWidget {
  /// Creates a Remix button.
  ///
  /// The [label] parameter is required and specifies the button text.
  /// Use builders to customize rendering of specific parts.
  const RemixButton({
    this.style = const RemixButtonStyle.create(),
    this.styleSpec,
    super.key,
    this.label = '',
    this.icon,
    this.textBuilder,
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

  final RemixButtonStyle style;

  final ButtonSpec? styleSpec;

  static late final styleFrom = RemixButtonStyle.new;

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
  /// If [iconBuilder] is provided, this is ignored.
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

  bool get _isEnabled => !loading && onPressed != null;

  @override
  Widget build(BuildContext context) {
    return NakedButton(
      onPressed: _isEnabled ? onPressed : null,
      onLongPress: _isEnabled ? onLongPress : null,
      enabled: _isEnabled,
      mouseCursor: mouseCursor,
      enableFeedback: enableFeedback,
      focusNode: focusNode,
      autofocus: autofocus,
      semanticLabel: semanticLabel,
      builder: (context, __, _) {
        return StyleBuilder(
          style: style,
          controller: NakedState.controllerOf(context),
          builder: (context, spec) {
            Widget? iconWidget;

            if (icon != null || iconBuilder != null) {
              iconWidget = iconBuilder == null
                  ? StyledIcon(icon: icon, styleSpec: spec.icon)
                  : StyleSpecBuilder(
                      styleSpec: spec.icon,
                      builder: (context, iconSpec) =>
                          iconBuilder!(context, iconSpec, icon),
                    );
            }

            // Build text widget (always present since label is required)
            final textWidget = textBuilder == null
                ? StyledText(label, styleSpec: spec.label)
                : StyleSpecBuilder(
                    styleSpec: spec.label,
                    builder: (context, textSpec) =>
                        textBuilder!(context, textSpec, label),
                  );

            // Build spinner (used when loading)
            final spinner = Center(
              child: loadingBuilder == null
                  ? RemixSpinner(styleSpec: spec.spinner)
                  : StyleSpecBuilder(
                      styleSpec: spec.spinner,
                      builder: loadingBuilder!,
                    ),
            );

            // Create content row with visibility control for loading state
            final contentRow = Visibility(
              visible: !loading,
              maintainState: true,
              maintainAnimation: true,
              maintainSize: true,
              child: RowBox(
                styleSpec: spec.container,
                children: [if (iconWidget != null) iconWidget, textWidget],
              ),
            );

            // Layer spinner above the content while keeping size stable.
            final layered = Stack(
              alignment: Alignment.center,
              children: [contentRow, if (loading) spinner],
            );

            return MergeSemantics(
              child: Semantics(
                excludeSemantics: excludeSemantics,
                liveRegion: loading,
                label: semanticLabel ?? label,
                hint: semanticHint,
                child: layered,
              ),
            );
          },
        );
      },
    );
  }
}
