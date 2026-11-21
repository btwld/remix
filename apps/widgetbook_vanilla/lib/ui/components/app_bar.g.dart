// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_bar.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's AppBar recipe: a `background` surface over a toolbar row
/// with a bottom hairline and a semibold `textLg` title.
///
/// [style] merges last:
///
/// ```dart
/// VanillaAppBar(
///   style: AppBarStyler().toolbarHeight(VanillaTokens.s12),
///   title: 'Orders',
/// )
/// ```
class VanillaAppBar extends StatelessWidget {
  const VanillaAppBar({
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
      style: vanillaAppBarStyle(style: style),
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
