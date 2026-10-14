// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_bar.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's App Bar recipe.
///
/// An app bar is the row across the top of a page: an optional Back or menu
/// button, the page title, and the page's actions. Remix owns the layout, the
/// heading semantics, and the top safe area; this recipe owns the surface,
/// the row height, the insets, and the title type.
///
/// It takes no variant and no size. The bar is the `background` surface. Its
/// toolbar row is [vanillaAppBarToolbarHeight] (64px) tall including a `border`
/// hairline along its bottom edge, inset 16px from both sides, with a 12px
/// gap between the leading button, the title, and the actions, and between
/// the actions themselves. The title is `textLg` at semibold weight in
/// `foreground`.
///
/// The hairline belongs to the row rather than the surface so it sits inside
/// the 64px, as CSS's `h-16 border-b` does, instead of adding a pixel below
/// it. That keeps the bar exactly as tall as anything built the same way
/// beside it, such as a sidebar's brand row with the same height and edge.
/// Content in the bar's `bottom` slot brings its own edge.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it:
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
  Widget build(BuildContext context) {
    return RemixAppBar(
      key: this.key,
      style: vanillaAppBarStyle(style: this.style),
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
