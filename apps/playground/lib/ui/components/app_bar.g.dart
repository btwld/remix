// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_bar.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Creates the default [AppBarStyler] for the Playground app bar.
///
/// Configures a `background` surface, a [playgroundAppBarToolbarHeight] toolbar row
/// with an inset bottom hairline border, horizontal padding, semibold `textLg`
/// title text, and 12px spacing between elements.
///
/// Merges [style] after the default styling to allow caller overrides:
///
/// ```dart
/// PlaygroundAppBar(
///   style: AppBarStyler().toolbarHeight(PlaygroundTokens.s12),
///   title: 'Orders',
/// )
/// ```
class PlaygroundAppBar extends StatelessWidget {
  const PlaygroundAppBar({
    super.key,
    this.style = const AppBarStyler.create(),
    this.leading,
    this.title,
    this.titleChild,
    this.actions = const [],
    this.bottom,
    this.centerTitle = false,
    this.safeArea = true,
    this.namesRoute,
    this.headingLevel,
  });

  final AppBarStyler style;

  final Widget? leading;

  final String? title;

  final Widget? titleChild;

  final List<Widget> actions;

  final Widget? bottom;

  final bool centerTitle;

  final bool safeArea;

  final bool? namesRoute;

  final int? headingLevel;

  @override
  Widget build(BuildContext context) {
    return RemixAppBar(
      key: this.key,
      style: playgroundAppBarStyle(style: this.style),
      leading: this.leading,
      title: this.title,
      titleChild: this.titleChild,
      actions: this.actions,
      bottom: this.bottom,
      centerTitle: this.centerTitle,
      safeArea: this.safeArea,
      namesRoute: this.namesRoute,
      headingLevel: this.headingLevel,
    );
  }
}
