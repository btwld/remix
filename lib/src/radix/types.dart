// Shared Radix types: enums, theme config, and color scale (moved to radix/)

import 'package:flutter/painting.dart';

/// All available accent colors in Radix UI
enum RadixAccentColor {
  amber,
  blue,
  bronze,
  brown,
  crimson,
  cyan,
  gold,
  grass,
  gray,
  green,
  indigo,
  iris,
  jade,
  lime,
  mauve,
  mint,
  olive,
  orange,
  pink,
  plum,
  purple,
  red,
  ruby,
  sand,
  sage,
  sky,
  slate,
  teal,
  tomato,
  violet,
  yellow,
}

/// Available gray scales for neutral colors
enum RadixGrayColor {
  gray, // Pure gray
  mauve, // Purple-tinted gray
  slate, // Blue-tinted gray
  sage, // Green-tinted gray
  olive, // Yellow-green tinted gray
  sand, // Yellow-tinted gray
}

/// Theme configuration
class RadixTheme {
  final RadixAccentColor accent;
  final RadixGrayColor gray;
  final bool isDark;

  const RadixTheme({
    this.accent = RadixAccentColor.indigo,
    this.gray = RadixGrayColor.slate,
    this.isDark = false,
  });
}

/// Represents a complete 12-step color scale with alpha variants
class RadixColorScale {
  final ColorSwatch<int> solid;
  final ColorSwatch<int> alpha;

  const RadixColorScale(this.solid, this.alpha);

  // Semantic accessors based on Radix documentation

  // Steps 1-2: App backgrounds
  Color get appBackground => step(1);
  Color get subtleBackground => step(2);

  // Steps 3-5: Component backgrounds
  Color get componentBackground => step(3);
  Color get componentBackgroundHover => step(4);
  Color get componentBackgroundActive => step(5);

  // Steps 6-8: Borders
  Color get subtleBorder => step(6);
  Color get componentBorder => step(7);
  Color get componentBorderHover => step(8);

  // Steps 9-10: Solid backgrounds
  Color get solidBackground => step(9);
  Color get solidBackgroundHover => step(10);

  // Steps 11-12: Text
  Color get lowContrastText => step(11);
  Color get highContrastText => step(12);

  // Direct step access (1-12)
  Color step(int n) {
    assert(n >= 1 && n <= 12, 'Step must be between 1 and 12');

    return solid[n] ?? solid[9]!;
  }

  Color alphaStep(int n) {
    assert(n >= 1 && n <= 12, 'Step must be between 1 and 12');

    return alpha[n] ?? alpha[9]!;
  }
}
