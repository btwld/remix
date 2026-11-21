import 'package:flutter/widgets.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

/// A starter set of icon aliases for the application's own screens.
///
/// Installed components reference the icon library directly, so editing these
/// aliases changes no component. Add, rename, or remove them as the
/// application's vocabulary evolves.
abstract final class HeroUiIcons {
  /// Confirms a successful or selected action.
  static const IconData check = RemixIcons.check;

  /// Dismisses, clears, or marks a failed action.
  static const IconData cross = RemixIcons.close;

  /// Opens content positioned below the current control.
  static const IconData chevronDown = RemixIcons.chevronDown;

  /// Opens primary navigation on compact layouts.
  static const IconData hamburgerMenu = RemixIcons.menu;

  /// Starts a search, or marks a search field.
  static const IconData magnifyingGlass = RemixIcons.search;

  /// Moves a start-edge panel toward the left.
  static const IconData doubleArrowLeft = RemixIcons.chevronsLeft;

  /// Moves a start-edge panel toward the right.
  static const IconData doubleArrowRight = RemixIcons.chevronsRight;

  /// Represents an overview or home destination.
  static const IconData dashboard = RemixIcons.dashboard;
}
