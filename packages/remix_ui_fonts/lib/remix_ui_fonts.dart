/// Open-licensed fonts for Flutter, bundled so they work offline.
///
/// Pass a [RemixFonts] constant as `TextStyle.fontFamily`, and set
/// `fontWeight` to choose a weight. Each constant is the fully qualified
/// family name, so it resolves from any consumer package without a
/// `package:` argument.
library;

/// Fully qualified font family names bundled by `remix_ui_fonts`.
abstract final class RemixFonts {
  /// Geist, weights 400, 500, 600, and 700.
  static const String geist = 'packages/remix_ui_fonts/Geist';

  /// Geist Mono, weights 400 and 500.
  static const String geistMono = 'packages/remix_ui_fonts/GeistMono';
}
