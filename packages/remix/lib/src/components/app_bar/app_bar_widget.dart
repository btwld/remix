part of 'app_bar.dart';

/// Toolbar height used when the style sets no [AppBarSpec.toolbarHeight].
const double _defaultToolbarHeight = 56;

/// A bar across the top of a page or pane, with an optional leading widget,
/// a title, trailing actions, and optional bottom content.
///
/// The title is a semantics heading. On Android, Fuchsia, Linux, and Windows
/// it also names the enclosing route, so screen readers announce it when a
/// route opens; set [namesRoute] to override that.
///
/// This widget owns layout, styling, and title semantics only. It adds no
/// Back or menu button of its own, reads no `Navigator` or route, and does
/// not react to scrolling. Callers place it in their own frame, usually a
/// `Column` above the page body. Wrap that body in `MediaQuery.removePadding`
/// with `removeTop: true` when [safeArea] is on, so scrolling content below
/// does not reserve the top inset a second time.
///
/// Give the bar a bounded width, as a `Column` does. Leading, title, and
/// actions are laid out by Flutter's [NavigationToolbar]: the leading widget
/// sits at the start, the actions at the end, and the title after the leading
/// widget, or centered in the bar when [centerTitle] is true.
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

  /// Optional widget at the start of the toolbar, such as a Back or menu
  /// button. It is centered vertically in the toolbar.
  final Widget? leading;

  /// Visible title text and the heading's accessible name.
  ///
  /// When [titleChild] is also provided, this remains the accessible name and
  /// [titleChild] is what renders. When provided, it must contain at least one
  /// non-whitespace character.
  final String? title;

  /// Optional custom title content, such as a breadcrumb.
  ///
  /// It inherits the [AppBarSpec.title] text style. Without [title], its own
  /// semantics are merged to name the heading. When [title] is also set,
  /// [title] replaces [titleChild]'s semantics, so interactive controls in
  /// [titleChild] require omitting [title].
  final Widget? titleChild;

  /// Widgets at the end of the toolbar, laid out in an intrinsic-width
  /// horizontal row ([MainAxisSize.min]).
  final List<Widget> actions;

  /// Optional content below the toolbar, such as a `RemixTabBar` or a search
  /// field.
  final Widget? bottom;

  /// Whether to center the title in the bar instead of placing it after the
  /// leading widget.
  final bool centerTitle;

  /// Whether to keep the toolbar and [bottom] below the top and side insets
  /// from `MediaQuery`, such as a status bar or display cutout, while the
  /// surface still paints behind them.
  ///
  /// Turn this off for a bar that does not touch the top of the screen, such
  /// as one inside a sheet or a nested pane.
  final bool safeArea;

  /// Whether the title names the enclosing route for assistive technology.
  ///
  /// Null uses the platform convention: true on Android, Fuchsia, Linux, and
  /// Windows, unset on iOS and macOS.
  final bool? namesRoute;

  /// Optional heading level from 1 to 6 for the title, used on the web.
  final int? headingLevel;

  /// Fluent visual style for the bar.
  final AppBarStyler style;

  /// Optional raw style spec that bypasses fluent style resolution.
  final AppBarSpec? styleSpec;

  /// Creates a fluent style for this component.
  static final styleFrom = AppBarStyler.new;

  static bool? _platformNamesRoute() => switch (defaultTargetPlatform) {
    TargetPlatform.android ||
    TargetPlatform.fuchsia ||
    TargetPlatform.linux ||
    TargetPlatform.windows => true,
    TargetPlatform.iOS || TargetPlatform.macOS => null,
  };

  /// Keeps the title on one line with an ellipsis unless the style sets its
  /// own line limit, so a long title cannot overflow the fixed toolbar.
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

  /// Forces the actions into one horizontal row sized to its content, which
  /// [NavigationToolbar] needs to place them at the end.
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
    if (text == null && custom == null) return null;

    final titleStyle = _titleStyle(spec.title);

    return MergeSemantics(
      child: Semantics(
        header: true,
        headingLevel: headingLevel,
        namesRoute: namesRoute ?? _platformNamesRoute(),
        label: text,
        excludeSemantics: text != null,
        child: custom == null
            ? StyledText(text!, styleSpec: titleStyle)
            : RemixDefaultContentStyle(text: titleStyle, child: custom),
      ),
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
        final leadingWidget = leading;

        // NavigationToolbar adds its middle spacing even without a leading
        // widget, so the gaps are padding on the parts that exist instead.
        final toolbar = NavigationToolbar(
          leading: leadingWidget == null
              ? null
              : Padding(
                  padding: EdgeInsetsDirectional.only(end: gap),
                  // The toolbar gives its leading slot the full bar height.
                  child: Align(widthFactor: 1, child: leadingWidget),
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
