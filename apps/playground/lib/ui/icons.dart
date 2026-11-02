import 'package:flutter/widgets.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

/// Application-owned aliases for the icons used by this UI layer.
///
/// Add, rename, or remove aliases here as the application vocabulary evolves.
abstract final class PlaygroundIcons {
  /// Confirms a successful or selected action.
  static const IconData check = RemixIcons.check;

  /// Dismisses, clears, or marks a failed action.
  static const IconData cross = RemixIcons.close;

  /// Opens content positioned below the current control.
  static const IconData chevronDown = RemixIcons.chevronDown;

  /// Opens primary navigation on compact layouts.
  static const IconData hamburgerMenu = RemixIcons.menu;

  /// Finds content within the current dashboard.
  static const IconData magnifyingGlass = RemixIcons.search;

  /// Moves a start-edge panel toward the left.
  static const IconData doubleArrowLeft = RemixIcons.chevronsLeft;

  /// Moves a start-edge panel toward the right.
  static const IconData doubleArrowRight = RemixIcons.chevronsRight;

  /// Represents the dashboard overview destination.
  static const IconData dashboard = RemixIcons.dashboard;
}
