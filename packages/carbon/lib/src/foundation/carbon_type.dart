import 'package:flutter/widgets.dart';

import '../tokens/carbon_token_types.dart';
import '../tokens/generated/carbon_layout.g.dart';
import '../tokens/generated/carbon_type.g.dart';

/// Access to Carbon typography.
///
/// Fixed styles are exposed as ordinary Mix text-style tokens (`CarbonTokens.body01`
/// etc.) and resolve inside a `CarbonScope`. Fluid styles change across Carbon's
/// five breakpoints and need a viewport, so they are resolved here.
class CarbonType {
  CarbonType._();

  /// All responsive (fluid) styles, keyed by Carbon name (e.g. `fluidHeading05`).
  static const Map<String, CarbonFluidTypeStyle> fluidStyles =
      carbonFluidTypeStyles;

  /// Whether [name] is a known fluid style.
  static bool isFluid(String name) => carbonFluidTypeStyles.containsKey(name);

  /// Resolves the effective measurements of fluid style [name] at [width].
  static CarbonTextStyleData resolveFluid(String name, double width) {
    final style = carbonFluidTypeStyles[name];
    assert(style != null, 'Unknown fluid type style: $name');

    return (style ?? _fallback).resolveAt(width, carbonBreakpoints);
  }

  /// Builds a Flutter [TextStyle] for fluid style [name] using the viewport
  /// width from [context]. Rebuilds responsively via `MediaQuery`.
  static TextStyle fluidTextStyle(
    BuildContext context,
    String name, {
    String? fontFamily,
  }) {
    final width = MediaQuery.sizeOf(context).width;

    return resolveFluid(name, width).toTextStyle(fontFamily: fontFamily);
  }

  static const CarbonFluidTypeStyle _fallback = CarbonFluidTypeStyle(
    base: CarbonTextStyleData(fontSize: 16, lineHeight: 1.5),
    breakpoints: {},
  );
}
