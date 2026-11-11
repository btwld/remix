// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_bar.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Page header recipe for [RemixAppBar], styled with HeroUI tokens.
///
/// An extension: HeroUI web 3.2.6 has no navbar or app bar to port. The bar
/// sits on the page `background`, with a [heroUiAppBarToolbarHeight] toolbar
/// row, a `separator` line beneath it, `px-4` insets, a `text-base`
/// semibold `foreground` title, and `gap-3` between leading, title, and
/// actions.
///
/// Merges [style] last, so a caller can override anything:
///
/// ```dart
/// HeroUiAppBar(
///   style: AppBarStyler().toolbarHeight(56),
///   title: 'Orders',
/// )
/// ```
class HeroUiAppBar extends StatelessWidget {
  const HeroUiAppBar({
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
      style: heroUiAppBarStyle(style: this.style),
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
