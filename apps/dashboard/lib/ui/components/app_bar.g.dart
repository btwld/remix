// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_bar.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Creates the default [AppBarStyler] for the Fortal app bar.
///
/// Configures a solid panel surface, a `space9` toolbar height with an inset
/// bottom border, `space4` horizontal padding, and bold `size4` title
/// typography.
///
/// Merges [style] after the default styling to allow caller overrides.
class UiAppBar extends StatelessWidget {
  const UiAppBar({
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
  Widget build(BuildContext _) {
    return RemixAppBar(
      style: uiAppBarStyle(style: style),
      leading: leading,
      title: title,
      titleChild: titleChild,
      actions: actions,
      bottom: bottom,
      centerTitle: centerTitle,
      safeArea: safeArea,
      namesRoute: namesRoute,
      headingLevel: headingLevel,
    );
  }
}
