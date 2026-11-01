/// Vector UI icons for Flutter, as one tree-shakable icon font.
///
/// Two families draw the same concepts in their own construction:
/// [OutlineIcons] and [RoundedIcons]. [RemixIcons] is the
/// default, and is the Outline family under the same names.
///
/// Each concept comes in an outline and a filled style at native 24, 16, and
/// 12 px masters: `search`, `searchFilled`, `search16`, `searchFilled16`,
/// `search12`, and `searchFilled12`. Refer to the constants directly so a
/// release build keeps only the glyphs an application uses.
///
/// Two opt-in libraries are not exported here, because each refers to every
/// glyph it covers: `package:remix_ui_icons/sized.dart` picks a master from a
/// size at runtime, and `package:remix_ui_icons/icons_index.dart` enumerates
/// every glyph for catalogs and tests.
library;

export 'src/generated/outline_icons.dart';
export 'src/generated/remix_icons.dart';
export 'src/generated/rounded_icons.dart';
