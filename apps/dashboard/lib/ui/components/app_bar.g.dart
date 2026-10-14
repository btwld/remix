// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_bar.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Ui-themed preset for [RemixAppBar].
///
/// The recipe paints the solid panel surface, sets the toolbar row to the
/// `space9` token (64 logical pixels at 100% scaling) including a bottom edge
/// border, insets it by `space4`, and separates the leading button, the
/// title, and the actions by `space3`. The title uses the bold `size4` text
/// step.
///
/// The edge belongs to the row rather than the surface so it sits inside the
/// row height instead of adding a pixel below it. Anything built the same way
/// beside the bar, such as a sidebar's brand row with a `space9` height and
/// the same edge, lines up with it under every Ui scaling setting.
/// Content in the bar's `bottom` slot brings its own edge.
///
/// App bar is a Ui extension, not a Radix Themes parity family.
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
  Widget build(BuildContext context) {
    return RemixAppBar(
      key: this.key,
      style: uiAppBarStyle(style: this.style),
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
