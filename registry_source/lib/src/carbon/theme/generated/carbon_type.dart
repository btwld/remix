// GENERATED CODE - DO NOT MODIFY BY HAND.
// Carbon typography: fixed styles, fluid styles, weights, families.
//
// Source: IBM Carbon Design System (Apache-2.0)
//   repo commit 188d23202ec1092322dee92cf0df9d9958224ae4 (2026-08-13)
//   @carbon/type 11.65.0
// Regenerate: node registry_source/tool/carbon/generate_tokens.mjs
// SPDX-License-Identifier: Apache-2.0
// dart format off
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../token_types.dart';
import 'carbon_tokens.dart';

/// Fixed (non-responsive) Carbon text styles (36).
final Map<TextStyleToken, TextStyle> carbideTextStyleTokens = {
  CarbideTokens.body01: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, height: 1.4286, letterSpacing: 0.16),
  CarbideTokens.body02: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, height: 1.5, letterSpacing: 0.0),
  CarbideTokens.bodyCompact01: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, height: 1.2857, letterSpacing: 0.16),
  CarbideTokens.bodyCompact02: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, height: 1.375, letterSpacing: 0.0),
  CarbideTokens.bodyLong01: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, height: 1.4286, letterSpacing: 0.16),
  CarbideTokens.bodyLong02: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, height: 1.5, letterSpacing: 0.0),
  CarbideTokens.bodyShort01: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, height: 1.2857, letterSpacing: 0.16),
  CarbideTokens.bodyShort02: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, height: 1.375, letterSpacing: 0.0),
  CarbideTokens.caption01: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, height: 1.3333, letterSpacing: 0.32),
  CarbideTokens.caption02: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, height: 1.2857, letterSpacing: 0.32),
  CarbideTokens.code01: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, height: 1.3333, letterSpacing: 0.32),
  CarbideTokens.code02: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, height: 1.4286, letterSpacing: 0.32),
  CarbideTokens.expressiveHeading01: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, height: 1.25, letterSpacing: 0.16),
  CarbideTokens.expressiveHeading02: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, height: 1.5, letterSpacing: 0.0),
  CarbideTokens.heading01: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, height: 1.4286, letterSpacing: 0.16),
  CarbideTokens.heading02: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, height: 1.5, letterSpacing: 0.0),
  CarbideTokens.heading03: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400, height: 1.4, letterSpacing: 0.0),
  CarbideTokens.heading04: const TextStyle(fontSize: 28.0, fontWeight: FontWeight.w400, height: 1.2857, letterSpacing: 0.0),
  CarbideTokens.heading05: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.w400, height: 1.25, letterSpacing: 0.0),
  CarbideTokens.heading06: const TextStyle(fontSize: 42.0, fontWeight: FontWeight.w300, height: 1.199, letterSpacing: 0.0),
  CarbideTokens.heading07: const TextStyle(fontSize: 54.0, fontWeight: FontWeight.w300, height: 1.199, letterSpacing: 0.0),
  CarbideTokens.headingCompact01: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, height: 1.2857, letterSpacing: 0.16),
  CarbideTokens.headingCompact02: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, height: 1.375, letterSpacing: 0.0),
  CarbideTokens.helperText01: const TextStyle(fontSize: 12.0, height: 1.3333, letterSpacing: 0.32),
  CarbideTokens.helperText02: const TextStyle(fontSize: 14.0, height: 1.2857, letterSpacing: 0.16),
  CarbideTokens.label01: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, height: 1.3333, letterSpacing: 0.32),
  CarbideTokens.label02: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, height: 1.2857, letterSpacing: 0.16),
  CarbideTokens.legal01: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, height: 1.3333, letterSpacing: 0.32),
  CarbideTokens.legal02: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, height: 1.2857, letterSpacing: 0.16),
  CarbideTokens.productiveHeading01: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, height: 1.2857, letterSpacing: 0.16),
  CarbideTokens.productiveHeading02: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, height: 1.375, letterSpacing: 0.0),
  CarbideTokens.productiveHeading03: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400, height: 1.4, letterSpacing: 0.0),
  CarbideTokens.productiveHeading04: const TextStyle(fontSize: 28.0, fontWeight: FontWeight.w400, height: 1.2857, letterSpacing: 0.0),
  CarbideTokens.productiveHeading05: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.w400, height: 1.25, letterSpacing: 0.0),
  CarbideTokens.productiveHeading06: const TextStyle(fontSize: 42.0, fontWeight: FontWeight.w300, height: 1.199, letterSpacing: 0.0),
  CarbideTokens.productiveHeading07: const TextStyle(fontSize: 54.0, fontWeight: FontWeight.w300, height: 1.199, letterSpacing: 0.0),
};

/// Responsive Carbon type styles with per-breakpoint overrides (22).
const Map<String, CarbideFluidTypeStyle> carbideFluidTypeStyles = {
  'display01': CarbideFluidTypeStyle(
    base: const CarbideTextStyleData(fontSize: 42.0, fontWeight: 300, lineHeight: 1.19, letterSpacing: 0.0),
    breakpoints: {
      'lg': const CarbideTextStyleData(fontSize: 54.0),
      'max': const CarbideTextStyleData(fontSize: 76.0, lineHeight: 1.13),
      'md': const CarbideTextStyleData(fontSize: 42.0),
      'xlg': const CarbideTextStyleData(fontSize: 60.0, lineHeight: 1.17),
    },
  ),
  'display02': CarbideFluidTypeStyle(
    base: const CarbideTextStyleData(fontSize: 42.0, fontWeight: 600, lineHeight: 1.19, letterSpacing: 0.0),
    breakpoints: {
      'lg': const CarbideTextStyleData(fontSize: 54.0),
      'max': const CarbideTextStyleData(fontSize: 76.0, lineHeight: 1.13),
      'md': const CarbideTextStyleData(fontSize: 42.0),
      'xlg': const CarbideTextStyleData(fontSize: 60.0, lineHeight: 1.16),
    },
  ),
  'display03': CarbideFluidTypeStyle(
    base: const CarbideTextStyleData(fontSize: 42.0, fontWeight: 300, lineHeight: 1.19, letterSpacing: 0.0),
    breakpoints: {
      'lg': const CarbideTextStyleData(fontSize: 60.0, lineHeight: 1.16, letterSpacing: -0.64),
      'max': const CarbideTextStyleData(fontSize: 84.0, lineHeight: 1.11, letterSpacing: -0.96),
      'md': const CarbideTextStyleData(fontSize: 54.0, lineHeight: 1.18),
      'xlg': const CarbideTextStyleData(fontSize: 76.0, lineHeight: 1.13),
    },
  ),
  'display04': CarbideFluidTypeStyle(
    base: const CarbideTextStyleData(fontSize: 42.0, fontWeight: 300, lineHeight: 1.19, letterSpacing: 0.0),
    breakpoints: {
      'lg': const CarbideTextStyleData(fontSize: 92.0, lineHeight: 1.11, letterSpacing: -0.64),
      'max': const CarbideTextStyleData(fontSize: 156.0, lineHeight: 1.05, letterSpacing: -0.96),
      'md': const CarbideTextStyleData(fontSize: 68.0, lineHeight: 1.15),
      'xlg': const CarbideTextStyleData(fontSize: 122.0, lineHeight: 1.07, letterSpacing: -0.64),
    },
  ),
  'expressiveHeading03': CarbideFluidTypeStyle(
    base: const CarbideTextStyleData(fontSize: 20.0, fontWeight: 400, lineHeight: 1.4, letterSpacing: 0.0),
    breakpoints: {
      'max': const CarbideTextStyleData(fontSize: 24.0, lineHeight: 1.334),
      'xlg': const CarbideTextStyleData(fontSize: 20.0, lineHeight: 1.4),
    },
  ),
  'expressiveHeading04': CarbideFluidTypeStyle(
    base: const CarbideTextStyleData(fontSize: 28.0, fontWeight: 400, lineHeight: 1.2857, letterSpacing: 0.0),
    breakpoints: {
      'max': const CarbideTextStyleData(fontSize: 32.0, fontWeight: 400),
      'xlg': const CarbideTextStyleData(fontSize: 32.0, fontWeight: 400, lineHeight: 1.25),
    },
  ),
  'expressiveHeading05': CarbideFluidTypeStyle(
    base: const CarbideTextStyleData(fontSize: 32.0, fontWeight: 400, lineHeight: 1.25, letterSpacing: 0.0),
    breakpoints: {
      'lg': const CarbideTextStyleData(fontSize: 42.0, lineHeight: 1.19, letterSpacing: 0.0),
      'max': const CarbideTextStyleData(fontSize: 60.0, letterSpacing: 0.0),
      'md': const CarbideTextStyleData(fontSize: 36.0, fontWeight: 300, lineHeight: 1.22, letterSpacing: 0.0),
      'xlg': const CarbideTextStyleData(fontSize: 48.0, lineHeight: 1.17, letterSpacing: 0.0),
    },
  ),
  'expressiveHeading06': CarbideFluidTypeStyle(
    base: const CarbideTextStyleData(fontSize: 32.0, fontWeight: 600, lineHeight: 1.25, letterSpacing: 0.0),
    breakpoints: {
      'lg': const CarbideTextStyleData(fontSize: 42.0, fontWeight: 600, lineHeight: 1.19, letterSpacing: 0.0),
      'max': const CarbideTextStyleData(fontSize: 60.0, fontWeight: 600, letterSpacing: 0.0),
      'md': const CarbideTextStyleData(fontSize: 36.0, fontWeight: 600, lineHeight: 1.22, letterSpacing: 0.0),
      'xlg': const CarbideTextStyleData(fontSize: 48.0, fontWeight: 600, lineHeight: 1.17, letterSpacing: 0.0),
    },
  ),
  'expressiveParagraph01': CarbideFluidTypeStyle(
    base: const CarbideTextStyleData(fontSize: 24.0, fontWeight: 300, lineHeight: 1.334, letterSpacing: 0.0),
    breakpoints: {
      'lg': const CarbideTextStyleData(fontSize: 28.0, lineHeight: 1.2857),
      'max': const CarbideTextStyleData(fontSize: 32.0, lineHeight: 1.25),
    },
  ),
  'fluidDisplay01': CarbideFluidTypeStyle(
    base: const CarbideTextStyleData(fontSize: 42.0, fontWeight: 300, lineHeight: 1.19, letterSpacing: 0.0),
    breakpoints: {
      'lg': const CarbideTextStyleData(fontSize: 54.0),
      'max': const CarbideTextStyleData(fontSize: 76.0, lineHeight: 1.13),
      'md': const CarbideTextStyleData(fontSize: 42.0),
      'xlg': const CarbideTextStyleData(fontSize: 60.0, lineHeight: 1.17),
    },
  ),
  'fluidDisplay02': CarbideFluidTypeStyle(
    base: const CarbideTextStyleData(fontSize: 42.0, fontWeight: 600, lineHeight: 1.19, letterSpacing: 0.0),
    breakpoints: {
      'lg': const CarbideTextStyleData(fontSize: 54.0),
      'max': const CarbideTextStyleData(fontSize: 76.0, lineHeight: 1.13),
      'md': const CarbideTextStyleData(fontSize: 42.0),
      'xlg': const CarbideTextStyleData(fontSize: 60.0, lineHeight: 1.16),
    },
  ),
  'fluidDisplay03': CarbideFluidTypeStyle(
    base: const CarbideTextStyleData(fontSize: 42.0, fontWeight: 300, lineHeight: 1.19, letterSpacing: 0.0),
    breakpoints: {
      'lg': const CarbideTextStyleData(fontSize: 60.0, lineHeight: 1.16, letterSpacing: -0.64),
      'max': const CarbideTextStyleData(fontSize: 84.0, lineHeight: 1.11, letterSpacing: -0.96),
      'md': const CarbideTextStyleData(fontSize: 54.0, lineHeight: 1.18),
      'xlg': const CarbideTextStyleData(fontSize: 76.0, lineHeight: 1.13),
    },
  ),
  'fluidDisplay04': CarbideFluidTypeStyle(
    base: const CarbideTextStyleData(fontSize: 42.0, fontWeight: 300, lineHeight: 1.19, letterSpacing: 0.0),
    breakpoints: {
      'lg': const CarbideTextStyleData(fontSize: 92.0, lineHeight: 1.11, letterSpacing: -0.64),
      'max': const CarbideTextStyleData(fontSize: 156.0, lineHeight: 1.05, letterSpacing: -0.96),
      'md': const CarbideTextStyleData(fontSize: 68.0, lineHeight: 1.15),
      'xlg': const CarbideTextStyleData(fontSize: 122.0, lineHeight: 1.07, letterSpacing: -0.64),
    },
  ),
  'fluidHeading03': CarbideFluidTypeStyle(
    base: const CarbideTextStyleData(fontSize: 20.0, fontWeight: 400, lineHeight: 1.4, letterSpacing: 0.0),
    breakpoints: {
      'max': const CarbideTextStyleData(fontSize: 24.0, lineHeight: 1.334),
      'xlg': const CarbideTextStyleData(fontSize: 20.0, lineHeight: 1.4),
    },
  ),
  'fluidHeading04': CarbideFluidTypeStyle(
    base: const CarbideTextStyleData(fontSize: 28.0, fontWeight: 400, lineHeight: 1.2857, letterSpacing: 0.0),
    breakpoints: {
      'max': const CarbideTextStyleData(fontSize: 32.0, fontWeight: 400),
      'xlg': const CarbideTextStyleData(fontSize: 32.0, fontWeight: 400, lineHeight: 1.25),
    },
  ),
  'fluidHeading05': CarbideFluidTypeStyle(
    base: const CarbideTextStyleData(fontSize: 32.0, fontWeight: 400, lineHeight: 1.25, letterSpacing: 0.0),
    breakpoints: {
      'lg': const CarbideTextStyleData(fontSize: 42.0, lineHeight: 1.19, letterSpacing: 0.0),
      'max': const CarbideTextStyleData(fontSize: 60.0, letterSpacing: 0.0),
      'md': const CarbideTextStyleData(fontSize: 36.0, fontWeight: 300, lineHeight: 1.22, letterSpacing: 0.0),
      'xlg': const CarbideTextStyleData(fontSize: 48.0, lineHeight: 1.17, letterSpacing: 0.0),
    },
  ),
  'fluidHeading06': CarbideFluidTypeStyle(
    base: const CarbideTextStyleData(fontSize: 32.0, fontWeight: 600, lineHeight: 1.25, letterSpacing: 0.0),
    breakpoints: {
      'lg': const CarbideTextStyleData(fontSize: 42.0, fontWeight: 600, lineHeight: 1.19, letterSpacing: 0.0),
      'max': const CarbideTextStyleData(fontSize: 60.0, fontWeight: 600, letterSpacing: 0.0),
      'md': const CarbideTextStyleData(fontSize: 36.0, fontWeight: 600, lineHeight: 1.22, letterSpacing: 0.0),
      'xlg': const CarbideTextStyleData(fontSize: 48.0, fontWeight: 600, lineHeight: 1.17, letterSpacing: 0.0),
    },
  ),
  'fluidParagraph01': CarbideFluidTypeStyle(
    base: const CarbideTextStyleData(fontSize: 24.0, fontWeight: 300, lineHeight: 1.334, letterSpacing: 0.0),
    breakpoints: {
      'lg': const CarbideTextStyleData(fontSize: 28.0, lineHeight: 1.2857),
      'max': const CarbideTextStyleData(fontSize: 32.0, lineHeight: 1.25),
    },
  ),
  'fluidQuotation01': CarbideFluidTypeStyle(
    base: const CarbideTextStyleData(fontSize: 20.0, fontWeight: 400, lineHeight: 1.3, letterSpacing: 0.0),
    breakpoints: {
      'lg': const CarbideTextStyleData(fontSize: 24.0, fontWeight: 400, lineHeight: 1.334, letterSpacing: 0.0),
      'max': const CarbideTextStyleData(fontSize: 32.0, fontWeight: 400, lineHeight: 1.25, letterSpacing: 0.0),
      'md': const CarbideTextStyleData(fontSize: 20.0, fontWeight: 400, letterSpacing: 0.0),
      'xlg': const CarbideTextStyleData(fontSize: 28.0, fontWeight: 400, lineHeight: 1.2857, letterSpacing: 0.0),
    },
  ),
  'fluidQuotation02': CarbideFluidTypeStyle(
    base: const CarbideTextStyleData(fontSize: 32.0, fontWeight: 300, lineHeight: 1.25, letterSpacing: 0.0),
    breakpoints: {
      'lg': const CarbideTextStyleData(fontSize: 42.0, lineHeight: 1.19),
      'max': const CarbideTextStyleData(fontSize: 60.0),
      'md': const CarbideTextStyleData(fontSize: 36.0, lineHeight: 1.22),
      'xlg': const CarbideTextStyleData(fontSize: 48.0, lineHeight: 1.17),
    },
  ),
  'quotation01': CarbideFluidTypeStyle(
    base: const CarbideTextStyleData(fontSize: 20.0, fontWeight: 400, lineHeight: 1.3, letterSpacing: 0.0),
    breakpoints: {
      'lg': const CarbideTextStyleData(fontSize: 24.0, fontWeight: 400, lineHeight: 1.334, letterSpacing: 0.0),
      'max': const CarbideTextStyleData(fontSize: 32.0, fontWeight: 400, lineHeight: 1.25, letterSpacing: 0.0),
      'md': const CarbideTextStyleData(fontSize: 20.0, fontWeight: 400, letterSpacing: 0.0),
      'xlg': const CarbideTextStyleData(fontSize: 28.0, fontWeight: 400, lineHeight: 1.2857, letterSpacing: 0.0),
    },
  ),
  'quotation02': CarbideFluidTypeStyle(
    base: const CarbideTextStyleData(fontSize: 32.0, fontWeight: 300, lineHeight: 1.25, letterSpacing: 0.0),
    breakpoints: {
      'lg': const CarbideTextStyleData(fontSize: 42.0, lineHeight: 1.19),
      'max': const CarbideTextStyleData(fontSize: 60.0),
      'md': const CarbideTextStyleData(fontSize: 36.0, lineHeight: 1.22),
      'xlg': const CarbideTextStyleData(fontSize: 48.0, lineHeight: 1.17),
    },
  ),
};

/// Font-weight token values.
final Map<FontWeightToken, FontWeight> carbideFontWeightValues = {
  CarbideTokens.fontWeightLight: FontWeight.w300,
  CarbideTokens.fontWeightRegular: FontWeight.w400,
  CarbideTokens.fontWeightSemibold: FontWeight.w600,
};

/// IBM Plex font families from Carbon's official stacks, split into a
/// primary family name (for `TextStyle.fontFamily`) and fallback list
/// (for `TextStyle.fontFamilyFallback`).
class CarbideFontFamilies {
  CarbideFontFamilies._();

  /// Primary family of Carbon's `mono` stack. Register the font asset
  /// in the app before using it.
  static const String mono = "IBM Plex Mono";

  /// Fallback families of Carbon's `mono` stack, for `TextStyle.fontFamilyFallback`.
  static const List<String> monoFallback = [
    "Menlo",
    "DejaVu Sans Mono",
    "Bitstream Vera Sans Mono",
    "Courier",
    "monospace",
  ];

  /// Primary family of Carbon's `sans` stack. Register the font asset
  /// in the app before using it.
  static const String sans = "IBM Plex Sans";

  /// Fallback families of Carbon's `sans` stack, for `TextStyle.fontFamilyFallback`.
  static const List<String> sansFallback = [
    "system-ui",
    "-apple-system",
    "BlinkMacSystemFont",
    ".SFNSText-Regular",
    "sans-serif",
  ];

  /// Primary family of Carbon's `sansCondensed` stack. Register the font asset
  /// in the app before using it.
  static const String sansCondensed = "IBM Plex Sans Condensed";

  /// Fallback families of Carbon's `sansCondensed` stack, for `TextStyle.fontFamilyFallback`.
  static const List<String> sansCondensedFallback = [
    "Helvetica Neue",
    "Arial",
    "sans-serif",
  ];

  /// Primary family of Carbon's `sansHebrew` stack. Register the font asset
  /// in the app before using it.
  static const String sansHebrew = "IBM Plex Sans Hebrew";

  /// Fallback families of Carbon's `sansHebrew` stack, for `TextStyle.fontFamilyFallback`.
  static const List<String> sansHebrewFallback = [
    "Helvetica Hebrew",
    "Arial Hebrew",
    "sans-serif",
  ];

  /// Primary family of Carbon's `serif` stack. Register the font asset
  /// in the app before using it.
  static const String serif = "IBM Plex Serif";

  /// Fallback families of Carbon's `serif` stack, for `TextStyle.fontFamilyFallback`.
  static const List<String> serifFallback = [
    "Georgia",
    "Times",
    "serif",
  ];
}
