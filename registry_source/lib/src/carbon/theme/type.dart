// Adapted from remix_carbon at commit 606bfbb36 and from design tokens in the
// IBM Carbon Design System. Copyright 2026 the Remix authors; IBM Carbon
// Design System copyright IBM Corp. and the Carbon authors. Apache-2.0.
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/widgets.dart';

import 'token_types.dart';
import 'generated/carbon_layout.dart';
import 'generated/carbon_type.dart';
import 'theme_scope.dart';

/// Access to Carbon typography.
///
/// Fixed styles are exposed as ordinary Mix text-style tokens (`CarbideTokens.body01`
/// etc.) and resolve inside a `CarbideScope`. Fluid styles change across Carbon's
/// five breakpoints and need a viewport, so they are resolved here.
class CarbideType {
  const CarbideType._();

  /// All responsive (fluid) styles, keyed by Carbon name (e.g. `fluidHeading05`).
  static const Map<String, CarbideFluidTypeStyle> fluidStyles =
      carbideFluidTypeStyles;

  /// Whether [name] is a known fluid style.
  static bool isFluid(String name) => carbideFluidTypeStyles.containsKey(name);

  /// Resolves the effective measurements of fluid style [name] at [width].
  ///
  /// Throws [ArgumentError] for an unknown [name] in every build mode, so a
  /// typo cannot silently ship as fallback body text.
  static CarbideTextStyleData resolveFluid(String name, double width) {
    final style = carbideFluidTypeStyles[name];
    if (style == null) {
      throw ArgumentError.value(name, 'name', 'Unknown fluid type style');
    }

    return style.resolveAt(width, carbideBreakpoints);
  }

  /// Builds a Flutter [TextStyle] for fluid style [name] using the viewport
  /// width from [context]. Rebuilds responsively via `MediaQuery`.
  ///
  /// When [fontFamily] is null, the enclosing `CarbideScope`'s configured
  /// font family (via `CarbideThemeOverrides.fontFamily`) is used, keeping
  /// fluid and fixed typography on the same font without re-passing it at
  /// every call site.
  static TextStyle fluidTextStyle(
    BuildContext context,
    String name, {
    String? fontFamily,
  }) {
    final width = MediaQuery.widthOf(context);
    final family = fontFamily ?? CarbideScope.overridesOf(context).fontFamily;

    return resolveFluid(name, width).toTextStyle(fontFamily: family);
  }
}
