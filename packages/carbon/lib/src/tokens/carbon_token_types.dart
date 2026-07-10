import 'package:flutter/widgets.dart';

/// Plain, dependency-light data holders shared by the generated token files and
/// the runtime foundation. Kept in a leaf module (no imports beyond Flutter) so
/// both `generated/*.g.dart` and `foundation/*` can depend on it without cycles.

/// A responsive breakpoint from `@carbon/layout`.
@immutable
class CarbonBreakpointData {
  const CarbonBreakpointData({
    required this.name,
    required this.width,
    required this.columns,
    required this.margin,
  });

  /// Carbon breakpoint key (`sm`, `md`, `lg`, `xlg`, `max`).
  final String name;

  /// Minimum viewport width, in logical pixels, at which the breakpoint applies.
  final double width;

  /// Number of grid columns at this breakpoint.
  final int columns;

  /// Grid margin, in logical pixels, at this breakpoint.
  final double margin;
}

/// The unit a fluid spacing step is expressed in.
enum CarbonSpaceUnit { px, vw }

/// A fluid spacing step: either a fixed pixel value or a viewport-relative one.
@immutable
class CarbonFluidSpaceData {
  const CarbonFluidSpaceData(this.value, this.unit);

  final double value;
  final CarbonSpaceUnit unit;

  /// Resolves against a viewport [width] (logical pixels).
  double resolve(double width) =>
      unit == CarbonSpaceUnit.vw ? width * value / 100.0 : value;
}

/// One (possibly partial) set of text-style measurements. Fields are nullable so
/// fluid breakpoint overrides can carry only the properties Carbon changes.
@immutable
class CarbonTextStyleData {
  const CarbonTextStyleData({
    this.fontSize,
    this.fontWeight,
    this.lineHeight,
    this.letterSpacing,
  });

  /// Font size in logical pixels.
  final double? fontSize;

  /// CSS numeric font weight (300/400/600).
  final int? fontWeight;

  /// Line height as a ratio (Flutter `TextStyle.height`).
  final double? lineHeight;

  /// Letter spacing in logical pixels.
  final double? letterSpacing;

  // Carbon type uses only the light/regular/semibold weights.
  FontWeight? get flutterFontWeight => switch (fontWeight) {
        300 => FontWeight.w300,
        400 => FontWeight.w400,
        600 => FontWeight.w600,
        null => null,
        _ => FontWeight.w400,
      };

  /// Builds a Flutter [TextStyle] from these measurements, optionally applying
  /// [fontFamily] and [overrides] (used by the fluid resolver).
  TextStyle toTextStyle({String? fontFamily, CarbonTextStyleData? overrides}) {
    final size = overrides?.fontSize ?? fontSize;
    final weight = overrides?.flutterFontWeight ?? flutterFontWeight;
    final height = overrides?.lineHeight ?? lineHeight;
    final spacing = overrides?.letterSpacing ?? letterSpacing;

    return TextStyle(
      fontFamily: fontFamily,
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: spacing,
    );
  }
}

/// A responsive Carbon type style with a base and per-breakpoint overrides.
@immutable
class CarbonFluidTypeStyle {
  const CarbonFluidTypeStyle({required this.base, required this.breakpoints});

  final CarbonTextStyleData base;

  /// Overrides keyed by Carbon breakpoint (`md`, `lg`, `xlg`, `max`).
  final Map<String, CarbonTextStyleData> breakpoints;

  /// Resolves the effective style at a viewport [width], applying every override
  /// whose breakpoint has been reached (breakpoints are cumulative in Carbon).
  CarbonTextStyleData resolveAt(double width, List<CarbonBreakpointData> bps) {
    var effective = base;
    for (final bp in bps) {
      if (width >= bp.width && breakpoints.containsKey(bp.name)) {
        final ov = breakpoints[bp.name]!;
        effective = CarbonTextStyleData(
          fontSize: ov.fontSize ?? effective.fontSize,
          fontWeight: ov.fontWeight ?? effective.fontWeight,
          lineHeight: ov.lineHeight ?? effective.lineHeight,
          letterSpacing: ov.letterSpacing ?? effective.letterSpacing,
        );
      }
    }
    return effective;
  }
}
