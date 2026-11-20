import 'package:flutter/widgets.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

/// An optional starter set of icon aliases for the application's own screens.
///
/// The HeroUI components name their icons directly and do not use these. HeroUI
/// draws its own icon set; these resolve to the project's icon library instead.
/// Add, rename, or remove aliases as the application vocabulary evolves.
abstract final class UiIcons {
  /// Confirms a successful or selected action.
  static const IconData check = RemixIcons.check;

  /// Dismisses, clears, or marks a failed action.
  static const IconData cross = RemixIcons.close;

  /// Opens content positioned below the current control.
  static const IconData chevronDown = RemixIcons.chevronDown;

  /// Opens primary navigation on compact layouts.
  static const IconData hamburgerMenu = RemixIcons.menu;

  /// Starts a search.
  static const IconData magnifyingGlass = RemixIcons.search;

  /// Moves a start-edge panel toward the left.
  static const IconData doubleArrowLeft = RemixIcons.chevronsLeft;

  /// Moves a start-edge panel toward the right.
  static const IconData doubleArrowRight = RemixIcons.chevronsRight;

  /// Marks an overview destination.
  static const IconData dashboard = RemixIcons.dashboard;
}
