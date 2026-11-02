/// Every glyph in the package, with its family, style, master, and tags.
///
/// For catalogs, galleries, and tests. Do not import this library from
/// application code that only needs a few icons: [remixIconEntries] refers to
/// every glyph, so it keeps the whole font in a release build. Use the
/// constants from `package:remix_ui_icons/remix_ui_icons.dart` instead.
library;

export 'src/generated/icons_index.dart';
export 'src/remix_icon_entry.dart';
