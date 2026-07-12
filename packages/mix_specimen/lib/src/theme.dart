import 'package:flutter/widgets.dart';

/// Wraps [child] with a design system's token scope (e.g. `FortalScope`).
typedef SpecimenThemeWrapper =
    Widget Function(BuildContext context, Widget child);

/// A design-system context under which specimens are rendered.
///
/// Themes are a sheet-level axis: the golden harness emits one image per
/// theme, and a live gallery renders the same list as a switcher.
@immutable
class SpecimenTheme {
  const SpecimenTheme(
    this.id, {
    this.brightness = Brightness.light,
    required this.background,
    required this.builder,
  });

  /// Identifier used in golden file paths and the manifest.
  final String id;

  /// Applied to the test window's platform brightness so context variants
  /// like `onDark` resolve correctly.
  final Brightness brightness;

  /// Canvas color painted behind the sheet.
  final Color background;

  /// Wraps the sheet with the design system's scope.
  final SpecimenThemeWrapper builder;
}
