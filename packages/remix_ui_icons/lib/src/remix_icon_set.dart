import 'package:flutter/widgets.dart';

/// One concept and style at its three native masters.
///
/// The masters are separate drawings, not one glyph scaled: a 12 px master
/// has thicker relative strokes and fewer details than the 24 px one. [at]
/// applies the pack's master rule, so code that only knows a size at runtime
/// still gets the drawing reviewed for it.
///
/// ```dart
/// Icon(OutlineIconSets.search.at(size), size: size)
/// ```
///
/// Prefer a constant such as `OutlineIcons.search16` when the size is fixed.
@immutable
final class RemixIconSet {
  /// Creates a set from its 12, 16, and 24 px masters.
  const RemixIconSet(this.s12, this.s16, this.s24);

  /// The 12 px master.
  final IconData s12;

  /// The 16 px master.
  final IconData s16;

  /// The 24 px master.
  final IconData s24;

  /// The master for an icon rendered at [size] logical pixels: the 12 px
  /// master up to 12, the 16 px master up to 16, and the 24 px master above.
  ///
  /// Sizes below 12 px are not reviewed and use the 12 px master.
  IconData at(double size) => size <= 12
      ? s12
      : size <= 16
      ? s16
      : s24;

  /// Every master, smallest first.
  List<IconData> get masters => [s12, s16, s24];

  @override
  bool operator ==(Object other) =>
      other is RemixIconSet &&
      other.s12 == s12 &&
      other.s16 == s16 &&
      other.s24 == s24;

  @override
  int get hashCode => Object.hash(s12, s16, s24);
}
