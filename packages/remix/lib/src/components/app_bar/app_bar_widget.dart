part of 'app_bar.dart';

/// Default toolbar height in logical pixels when [AppBarSpec.toolbarHeight] is `null`.
const double _defaultToolbarHeight = 56;

/// A bar across the top of a page or pane with slots for leading, title,
/// actions, and bottom content.
///
/// The title acts as an accessibility heading. On Android, Fuchsia, Linux,
/// and Windows, it also names the enclosing route. Screen readers announce
/// this title when the route opens. Use [namesRoute] to override this behavior.
///
/// This widget manages layout, styling, and title semantics only. It does
/// not provide navigation buttons, read [Navigator] state, or react to
/// scrolling. Place the bar in a container with a bounded width, such as a
/// [Column] above the page body. When [safeArea] is `true`, wrap scrolling
/// body content in [MediaQuery.removePadding] with `removeTop: true` to avoid
/// reserving the top inset twice.
///
/// [NavigationToolbar] lays out the toolbar row. The leading widget appears
/// at the start, actions appear at the end, and the title sits between them.
/// When [centerTitle] is `true`, the title centers within the bar.
///
/// ```dart
/// RemixAppBar(
///   leading: RemixIconButton(
///     icon: menuIcon,
///     semanticLabel: 'Open navigation',
///     onPressed: openNavigation,
///   ),
///   title: 'Orders',
///   actions: [
///     RemixIconButton(
///       icon: settingsIcon,
///       semanticLabel: 'Settings',
///       onPressed: openSettings,
///     ),
///   ],
/// )
/// ```
class RemixAppBar extends StatelessWidget {
  /// Creates a [RemixAppBar].
  const RemixAppBar({
    super.key,
    this.leading,
    this.title,
    this.titleChild,
    this.actions = const [],
    this.bottom,
    this.centerTitle = false,
    this.safeArea = true,
    this.namesRoute,
    this.headingLevel,
    this.style = const AppBarStyler.create(),
    this.styleSpec,
  }) : assert(
         headingLevel == null || (headingLevel >= 1 && headingLevel <= 6),
         'RemixAppBar headingLevel must be between 1 and 6.',
       );

  /// Widget displayed at the start of the toolbar.
  ///
  /// This widget centers vertically within the toolbar. Common uses include
  /// navigation back buttons or menu buttons.
  final Widget? leading;

  /// Visible title text and heading accessible name.
  ///
  /// When [titleChild] is also provided, [titleChild] renders while [title]
  /// serves as the accessible name. When non-null, [title] must contain at
  /// least one non-whitespace character.
  final String? title;

  /// Custom title widget to render in place of [title].
  ///
  /// This widget inherits the [AppBarSpec.title] text style. When [title] is
  /// `null`, the widget tree preserves [titleChild] semantics, including
  /// interactive controls. Providing [title] replaces the semantics of
  /// [titleChild]. Omit [title] when [titleChild] contains interactive controls.
  final Widget? titleChild;

  /// Widgets displayed at the end of the toolbar.
  ///
  /// The toolbar lays out these widgets in a horizontal row sized to its
  /// content ([MainAxisSize.min]).
  final List<Widget> actions;

  /// Optional widget displayed below the toolbar, such as a tab bar or search field.
  final Widget? bottom;

  /// Whether to center the title horizontally in the bar.
  ///
  /// When `false`, the title sits immediately after the [leading] widget.
  final bool centerTitle;

  /// Whether to inset toolbar and [bottom] content to avoid window insets.
  ///
  /// When `true`, toolbar content sits below [MediaQuery] insets while the
  /// background surface paints behind them. Set to `false` when embedding the
  /// bar inside a container that does not touch the window edges, such as a
  /// sheet or nested pane.
  final bool safeArea;

  /// Whether the title names the enclosing route for assistive technology.
  ///
  /// When `null`, the component follows platform conventions: `true` on
  /// Android, Fuchsia, Linux, and Windows, and unset on iOS and macOS.
  final bool? namesRoute;

  /// Heading level from 1 to 6 for title accessibility semantics on the web.
  final int? headingLevel;

  /// Visual style configuration for the bar.
  final AppBarStyler style;

  /// Style specification that bypasses [style] resolution.
  final AppBarSpec? styleSpec;

  /// Creates a fluent [AppBarStyler] for this component.
  static final styleFrom = AppBarStyler.new;

  static bool? _platformNamesRoute() => switch (defaultTargetPlatform) {
    TargetPlatform.android ||
    TargetPlatform.fuchsia ||
    TargetPlatform.linux ||
    TargetPlatform.windows => true,
    TargetPlatform.iOS || TargetPlatform.macOS => null,
  };

  /// Restricts the title to a single line with an ellipsis when unspecified.
  static StyleSpec<TextSpec> _titleStyle(StyleSpec<TextSpec> value) {
    if (value.spec.maxLines != null) return value;

    return value.copyWith(
      spec: value.spec.copyWith(
        maxLines: 1,
        softWrap: value.spec.softWrap ?? false,
        overflow: value.spec.overflow ?? TextOverflow.ellipsis,
      ),
    );
  }

  /// Configures actions as a minimal horizontal row for [NavigationToolbar].
  static StyleSpec<FlexBoxSpec> _actionsStyle(StyleSpec<FlexBoxSpec> value) {
    final flex = value.spec.flex ?? const StyleSpec(spec: FlexSpec());

    return value.copyWith(
      spec: value.spec.copyWith(
        flex: flex.copyWith(
          spec: flex.spec.copyWith(
            direction: Axis.horizontal,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                flex.spec.crossAxisAlignment ?? CrossAxisAlignment.center,
          ),
        ),
      ),
    );
  }

  Widget? _buildTitle(AppBarSpec spec) {
    final text = title;
    final custom = titleChild;
    final titleStyle = _titleStyle(spec.title);

    final Widget titleWidget;
    if (custom != null) {
      titleWidget = RemixDefaultContentStyle(text: titleStyle, child: custom);
    } else if (text != null) {
      titleWidget = StyledText(text, styleSpec: titleStyle);
    } else {
      return null;
    }

    return Semantics(
      header: true,
      headingLevel: headingLevel,
      namesRoute: namesRoute ?? _platformNamesRoute(),
      label: text,
      excludeSemantics: text != null,
      child: titleWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(
      title == null || title!.trim().isNotEmpty,
      'RemixAppBar title must not be blank.',
    );

    return RemixStyleSpecBuilder<AppBarSpec>(
      style: style,
      styleSpec: styleSpec,
      builder: (context, spec) {
        final middle = _buildTitle(spec);
        final gap = middle == null ? 0.0 : math.max(0.0, spec.spacing ?? 0);

        // NavigationToolbar adds its middle spacing even without a leading
        // widget, so the gaps are padding on the parts that exist instead.
        final toolbar = NavigationToolbar(
          leading: leading == null
              ? null
              : Padding(
                  padding: EdgeInsetsDirectional.only(end: gap),
                  // The toolbar gives its leading slot the full bar height.
                  child: Align(widthFactor: 1, child: leading),
                ),
          middle: middle,
          trailing: actions.isEmpty
              ? null
              : Padding(
                  padding: EdgeInsetsDirectional.only(start: gap),
                  child: FlexBox(
                    styleSpec: _actionsStyle(spec.actions),
                    children: actions,
                  ),
                ),
          centerMiddle: centerTitle,
          middleSpacing: 0,
        );

        Widget content = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // NavigationToolbar fills its constraints, so it needs a fixed
            // height.
            SizedBox(
              height: math.max(
                0.0,
                spec.toolbarHeight ?? _defaultToolbarHeight,
              ),
              child: Box(styleSpec: spec.toolbar, child: toolbar),
            ),
            if (bottom case final bottom?)
              Box(styleSpec: spec.bottom, child: bottom),
          ],
        );
        if (safeArea) content = SafeArea(bottom: false, child: content);

        return Semantics(
          container: true,
          explicitChildNodes: true,
          child: Box(styleSpec: spec.container, child: content),
        );
      },
    );
  }
}
