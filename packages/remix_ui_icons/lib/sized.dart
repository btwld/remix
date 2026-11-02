/// Picks an icon's native master from a size at runtime.
///
/// [OutlineIconSets] and [RoundedIconSets] hold every
/// concept and style as a [RemixIconSet]. Import this library only where the
/// size is not known until runtime: a set refers to all three of its masters,
/// so each set used keeps three glyphs in a release build.
library;

export 'src/generated/icon_sets.dart';
export 'src/remix_icon_set.dart';
