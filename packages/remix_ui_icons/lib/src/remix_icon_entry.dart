import 'package:flutter/widgets.dart';

/// The family that drew a glyph.
enum RemixIconFamily { outline, rounded, mono }

/// Whether a glyph is the outline or the filled drawing of its concept.
enum RemixIconStyle { outline, filled }

/// One glyph in `remixIconEntries`, with the metadata catalogs need.
@immutable
final class RemixIconEntry {
  const RemixIconEntry({
    required this.name,
    required this.concept,
    required this.label,
    required this.family,
    required this.style,
    required this.master,
    required this.icon,
    required this.tags,
    required this.aliases,
    required this.requiresLabel,
    required this.usage,
    required this.since,
  });

  /// The constant's name on its family class, such as `searchFilled16`.
  final String name;

  /// The concept's name, shared by every family, style, and master.
  final String concept;

  /// The concept's English label, such as `Search`.
  final String label;

  final RemixIconFamily family;
  final RemixIconStyle style;

  /// The native master size in logical pixels: 12, 16, or 24.
  final int master;

  final IconData icon;

  /// Search keywords for the concept.
  final List<String> tags;

  /// Deprecated `RemixIcons` names that resolve to this exact glyph.
  final List<String> aliases;

  /// Whether this glyph must be shown with a visible text label. A tooltip
  /// or semantic label is not a substitute. The design contract sets this
  /// per family and master: Warning everywhere, the Mono Star, Rounded
  /// Branch, and some concepts only at their 12 px master.
  final bool requiresLabel;

  /// The design contract's supported-use notes for this glyph: why it needs
  /// a label, where a contextual label is recommended, and other limits.
  final List<String> usage;

  /// The package version that introduced the concept.
  final String since;
}
