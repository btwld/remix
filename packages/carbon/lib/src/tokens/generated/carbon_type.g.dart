// GENERATED CODE - DO NOT MODIFY BY HAND.
// Carbon typography: fixed styles, fluid styles, weights, families.
//
// Source: IBM Carbon Design System (Apache-2.0)
//   repo commit b288a66af010622bedc6de4d6d0b81ee3c9f5520 (2026-07-09)
//   @carbon/type 11.62.0
// Regenerate: node tool/generate_tokens.mjs
// SPDX-License-Identifier: Apache-2.0
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../carbon_token_types.dart';
import 'carbon_tokens.g.dart';

/// Fixed (non-responsive) Carbon text styles (36).
Map<TextStyleToken, TextStyle> carbonTextStyleTokens() => {
    CarbonTokens.body01: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, height: 1.4286, letterSpacing: 0.16),
    CarbonTokens.body02: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, height: 1.5, letterSpacing: 0.0),
    CarbonTokens.bodyCompact01: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, height: 1.2857, letterSpacing: 0.16),
    CarbonTokens.bodyCompact02: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, height: 1.375, letterSpacing: 0.0),
    CarbonTokens.bodyLong01: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, height: 1.4286, letterSpacing: 0.16),
    CarbonTokens.bodyLong02: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, height: 1.5, letterSpacing: 0.0),
    CarbonTokens.bodyShort01: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, height: 1.2857, letterSpacing: 0.16),
    CarbonTokens.bodyShort02: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, height: 1.375, letterSpacing: 0.0),
    CarbonTokens.caption01: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, height: 1.3333, letterSpacing: 0.32),
    CarbonTokens.caption02: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, height: 1.2857, letterSpacing: 0.32),
    CarbonTokens.code01: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, height: 1.3333, letterSpacing: 0.32),
    CarbonTokens.code02: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, height: 1.4286, letterSpacing: 0.32),
    CarbonTokens.expressiveHeading01: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, height: 1.25, letterSpacing: 0.16),
    CarbonTokens.expressiveHeading02: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, height: 1.5, letterSpacing: 0.0),
    CarbonTokens.heading01: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, height: 1.4286, letterSpacing: 0.16),
    CarbonTokens.heading02: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, height: 1.5, letterSpacing: 0.0),
    CarbonTokens.heading03: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400, height: 1.4, letterSpacing: 0.0),
    CarbonTokens.heading04: const TextStyle(fontSize: 28.0, fontWeight: FontWeight.w400, height: 1.2857, letterSpacing: 0.0),
    CarbonTokens.heading05: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.w400, height: 1.25, letterSpacing: 0.0),
    CarbonTokens.heading06: const TextStyle(fontSize: 42.0, fontWeight: FontWeight.w300, height: 1.199, letterSpacing: 0.0),
    CarbonTokens.heading07: const TextStyle(fontSize: 54.0, fontWeight: FontWeight.w300, height: 1.199, letterSpacing: 0.0),
    CarbonTokens.headingCompact01: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, height: 1.2857, letterSpacing: 0.16),
    CarbonTokens.headingCompact02: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, height: 1.375, letterSpacing: 0.0),
    CarbonTokens.helperText01: const TextStyle(fontSize: 12.0, height: 1.3333, letterSpacing: 0.32),
    CarbonTokens.helperText02: const TextStyle(fontSize: 14.0, height: 1.2857, letterSpacing: 0.16),
    CarbonTokens.label01: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, height: 1.3333, letterSpacing: 0.32),
    CarbonTokens.label02: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, height: 1.2857, letterSpacing: 0.16),
    CarbonTokens.legal01: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, height: 1.3333, letterSpacing: 0.32),
    CarbonTokens.legal02: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, height: 1.2857, letterSpacing: 0.16),
    CarbonTokens.productiveHeading01: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, height: 1.2857, letterSpacing: 0.16),
    CarbonTokens.productiveHeading02: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, height: 1.375, letterSpacing: 0.0),
    CarbonTokens.productiveHeading03: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400, height: 1.4, letterSpacing: 0.0),
    CarbonTokens.productiveHeading04: const TextStyle(fontSize: 28.0, fontWeight: FontWeight.w400, height: 1.2857, letterSpacing: 0.0),
    CarbonTokens.productiveHeading05: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.w400, height: 1.25, letterSpacing: 0.0),
    CarbonTokens.productiveHeading06: const TextStyle(fontSize: 42.0, fontWeight: FontWeight.w300, height: 1.199, letterSpacing: 0.0),
    CarbonTokens.productiveHeading07: const TextStyle(fontSize: 54.0, fontWeight: FontWeight.w300, height: 1.199, letterSpacing: 0.0),
  };

/// Responsive Carbon type styles with per-breakpoint overrides (22).
const Map<String, CarbonFluidTypeStyle> carbonFluidTypeStyles = {
  'display01': CarbonFluidTypeStyle(
    base: CarbonTextStyleData(fontSize: 42.0, fontWeight: 300, lineHeight: 1.19, letterSpacing: 0.0),
    breakpoints: {
      'lg': CarbonTextStyleData(fontSize: 54.0),
      'max': CarbonTextStyleData(fontSize: 76.0, lineHeight: 1.13),
      'md': CarbonTextStyleData(fontSize: 42.0),
      'xlg': CarbonTextStyleData(fontSize: 60.0, lineHeight: 1.17),
    },
  ),
  'display02': CarbonFluidTypeStyle(
    base: CarbonTextStyleData(fontSize: 42.0, fontWeight: 600, lineHeight: 1.19, letterSpacing: 0.0),
    breakpoints: {
      'lg': CarbonTextStyleData(fontSize: 54.0),
      'max': CarbonTextStyleData(fontSize: 76.0, lineHeight: 1.13),
      'md': CarbonTextStyleData(fontSize: 42.0),
      'xlg': CarbonTextStyleData(fontSize: 60.0, lineHeight: 1.16),
    },
  ),
  'display03': CarbonFluidTypeStyle(
    base: CarbonTextStyleData(fontSize: 42.0, fontWeight: 300, lineHeight: 1.19, letterSpacing: 0.0),
    breakpoints: {
      'lg': CarbonTextStyleData(fontSize: 60.0, lineHeight: 1.16, letterSpacing: -0.64),
      'max': CarbonTextStyleData(fontSize: 84.0, lineHeight: 1.11, letterSpacing: -0.96),
      'md': CarbonTextStyleData(fontSize: 54.0, lineHeight: 1.18),
      'xlg': CarbonTextStyleData(fontSize: 76.0, lineHeight: 1.13),
    },
  ),
  'display04': CarbonFluidTypeStyle(
    base: CarbonTextStyleData(fontSize: 42.0, fontWeight: 300, lineHeight: 1.19, letterSpacing: 0.0),
    breakpoints: {
      'lg': CarbonTextStyleData(fontSize: 92.0, lineHeight: 1.11, letterSpacing: -0.64),
      'max': CarbonTextStyleData(fontSize: 156.0, lineHeight: 1.05, letterSpacing: -0.96),
      'md': CarbonTextStyleData(fontSize: 68.0, lineHeight: 1.15),
      'xlg': CarbonTextStyleData(fontSize: 122.0, lineHeight: 1.07, letterSpacing: -0.64),
    },
  ),
  'expressiveHeading03': CarbonFluidTypeStyle(
    base: CarbonTextStyleData(fontSize: 20.0, fontWeight: 400, lineHeight: 1.4, letterSpacing: 0.0),
    breakpoints: {
      'max': CarbonTextStyleData(fontSize: 24.0, lineHeight: 1.334),
      'xlg': CarbonTextStyleData(fontSize: 20.0, lineHeight: 1.4),
    },
  ),
  'expressiveHeading04': CarbonFluidTypeStyle(
    base: CarbonTextStyleData(fontSize: 28.0, fontWeight: 400, lineHeight: 1.2857, letterSpacing: 0.0),
    breakpoints: {
      'max': CarbonTextStyleData(fontSize: 32.0, fontWeight: 400),
      'xlg': CarbonTextStyleData(fontSize: 32.0, fontWeight: 400, lineHeight: 1.25),
    },
  ),
  'expressiveHeading05': CarbonFluidTypeStyle(
    base: CarbonTextStyleData(fontSize: 32.0, fontWeight: 400, lineHeight: 1.25, letterSpacing: 0.0),
    breakpoints: {
      'lg': CarbonTextStyleData(fontSize: 42.0, lineHeight: 1.19, letterSpacing: 0.0),
      'max': CarbonTextStyleData(fontSize: 60.0, letterSpacing: 0.0),
      'md': CarbonTextStyleData(fontSize: 36.0, fontWeight: 300, lineHeight: 1.22, letterSpacing: 0.0),
      'xlg': CarbonTextStyleData(fontSize: 48.0, lineHeight: 1.17, letterSpacing: 0.0),
    },
  ),
  'expressiveHeading06': CarbonFluidTypeStyle(
    base: CarbonTextStyleData(fontSize: 32.0, fontWeight: 600, lineHeight: 1.25, letterSpacing: 0.0),
    breakpoints: {
      'lg': CarbonTextStyleData(fontSize: 42.0, fontWeight: 600, lineHeight: 1.19, letterSpacing: 0.0),
      'max': CarbonTextStyleData(fontSize: 60.0, fontWeight: 600, letterSpacing: 0.0),
      'md': CarbonTextStyleData(fontSize: 36.0, fontWeight: 600, lineHeight: 1.22, letterSpacing: 0.0),
      'xlg': CarbonTextStyleData(fontSize: 48.0, fontWeight: 600, lineHeight: 1.17, letterSpacing: 0.0),
    },
  ),
  'expressiveParagraph01': CarbonFluidTypeStyle(
    base: CarbonTextStyleData(fontSize: 24.0, fontWeight: 300, lineHeight: 1.334, letterSpacing: 0.0),
    breakpoints: {
      'lg': CarbonTextStyleData(fontSize: 28.0, lineHeight: 1.2857),
      'max': CarbonTextStyleData(fontSize: 32.0, lineHeight: 1.25),
    },
  ),
  'fluidDisplay01': CarbonFluidTypeStyle(
    base: CarbonTextStyleData(fontSize: 42.0, fontWeight: 300, lineHeight: 1.19, letterSpacing: 0.0),
    breakpoints: {
      'lg': CarbonTextStyleData(fontSize: 54.0),
      'max': CarbonTextStyleData(fontSize: 76.0, lineHeight: 1.13),
      'md': CarbonTextStyleData(fontSize: 42.0),
      'xlg': CarbonTextStyleData(fontSize: 60.0, lineHeight: 1.17),
    },
  ),
  'fluidDisplay02': CarbonFluidTypeStyle(
    base: CarbonTextStyleData(fontSize: 42.0, fontWeight: 600, lineHeight: 1.19, letterSpacing: 0.0),
    breakpoints: {
      'lg': CarbonTextStyleData(fontSize: 54.0),
      'max': CarbonTextStyleData(fontSize: 76.0, lineHeight: 1.13),
      'md': CarbonTextStyleData(fontSize: 42.0),
      'xlg': CarbonTextStyleData(fontSize: 60.0, lineHeight: 1.16),
    },
  ),
  'fluidDisplay03': CarbonFluidTypeStyle(
    base: CarbonTextStyleData(fontSize: 42.0, fontWeight: 300, lineHeight: 1.19, letterSpacing: 0.0),
    breakpoints: {
      'lg': CarbonTextStyleData(fontSize: 60.0, lineHeight: 1.16, letterSpacing: -0.64),
      'max': CarbonTextStyleData(fontSize: 84.0, lineHeight: 1.11, letterSpacing: -0.96),
      'md': CarbonTextStyleData(fontSize: 54.0, lineHeight: 1.18),
      'xlg': CarbonTextStyleData(fontSize: 76.0, lineHeight: 1.13),
    },
  ),
  'fluidDisplay04': CarbonFluidTypeStyle(
    base: CarbonTextStyleData(fontSize: 42.0, fontWeight: 300, lineHeight: 1.19, letterSpacing: 0.0),
    breakpoints: {
      'lg': CarbonTextStyleData(fontSize: 92.0, lineHeight: 1.11, letterSpacing: -0.64),
      'max': CarbonTextStyleData(fontSize: 156.0, lineHeight: 1.05, letterSpacing: -0.96),
      'md': CarbonTextStyleData(fontSize: 68.0, lineHeight: 1.15),
      'xlg': CarbonTextStyleData(fontSize: 122.0, lineHeight: 1.07, letterSpacing: -0.64),
    },
  ),
  'fluidHeading03': CarbonFluidTypeStyle(
    base: CarbonTextStyleData(fontSize: 20.0, fontWeight: 400, lineHeight: 1.4, letterSpacing: 0.0),
    breakpoints: {
      'max': CarbonTextStyleData(fontSize: 24.0, lineHeight: 1.334),
      'xlg': CarbonTextStyleData(fontSize: 20.0, lineHeight: 1.4),
    },
  ),
  'fluidHeading04': CarbonFluidTypeStyle(
    base: CarbonTextStyleData(fontSize: 28.0, fontWeight: 400, lineHeight: 1.2857, letterSpacing: 0.0),
    breakpoints: {
      'max': CarbonTextStyleData(fontSize: 32.0, fontWeight: 400),
      'xlg': CarbonTextStyleData(fontSize: 32.0, fontWeight: 400, lineHeight: 1.25),
    },
  ),
  'fluidHeading05': CarbonFluidTypeStyle(
    base: CarbonTextStyleData(fontSize: 32.0, fontWeight: 400, lineHeight: 1.25, letterSpacing: 0.0),
    breakpoints: {
      'lg': CarbonTextStyleData(fontSize: 42.0, lineHeight: 1.19, letterSpacing: 0.0),
      'max': CarbonTextStyleData(fontSize: 60.0, letterSpacing: 0.0),
      'md': CarbonTextStyleData(fontSize: 36.0, fontWeight: 300, lineHeight: 1.22, letterSpacing: 0.0),
      'xlg': CarbonTextStyleData(fontSize: 48.0, lineHeight: 1.17, letterSpacing: 0.0),
    },
  ),
  'fluidHeading06': CarbonFluidTypeStyle(
    base: CarbonTextStyleData(fontSize: 32.0, fontWeight: 600, lineHeight: 1.25, letterSpacing: 0.0),
    breakpoints: {
      'lg': CarbonTextStyleData(fontSize: 42.0, fontWeight: 600, lineHeight: 1.19, letterSpacing: 0.0),
      'max': CarbonTextStyleData(fontSize: 60.0, fontWeight: 600, letterSpacing: 0.0),
      'md': CarbonTextStyleData(fontSize: 36.0, fontWeight: 600, lineHeight: 1.22, letterSpacing: 0.0),
      'xlg': CarbonTextStyleData(fontSize: 48.0, fontWeight: 600, lineHeight: 1.17, letterSpacing: 0.0),
    },
  ),
  'fluidParagraph01': CarbonFluidTypeStyle(
    base: CarbonTextStyleData(fontSize: 24.0, fontWeight: 300, lineHeight: 1.334, letterSpacing: 0.0),
    breakpoints: {
      'lg': CarbonTextStyleData(fontSize: 28.0, lineHeight: 1.2857),
      'max': CarbonTextStyleData(fontSize: 32.0, lineHeight: 1.25),
    },
  ),
  'fluidQuotation01': CarbonFluidTypeStyle(
    base: CarbonTextStyleData(fontSize: 20.0, fontWeight: 400, lineHeight: 1.3, letterSpacing: 0.0),
    breakpoints: {
      'lg': CarbonTextStyleData(fontSize: 24.0, fontWeight: 400, lineHeight: 1.334, letterSpacing: 0.0),
      'max': CarbonTextStyleData(fontSize: 32.0, fontWeight: 400, lineHeight: 1.25, letterSpacing: 0.0),
      'md': CarbonTextStyleData(fontSize: 20.0, fontWeight: 400, letterSpacing: 0.0),
      'xlg': CarbonTextStyleData(fontSize: 28.0, fontWeight: 400, lineHeight: 1.2857, letterSpacing: 0.0),
    },
  ),
  'fluidQuotation02': CarbonFluidTypeStyle(
    base: CarbonTextStyleData(fontSize: 32.0, fontWeight: 300, lineHeight: 1.25, letterSpacing: 0.0),
    breakpoints: {
      'lg': CarbonTextStyleData(fontSize: 42.0, lineHeight: 1.19),
      'max': CarbonTextStyleData(fontSize: 60.0),
      'md': CarbonTextStyleData(fontSize: 36.0, lineHeight: 1.22),
      'xlg': CarbonTextStyleData(fontSize: 48.0, lineHeight: 1.17),
    },
  ),
  'quotation01': CarbonFluidTypeStyle(
    base: CarbonTextStyleData(fontSize: 20.0, fontWeight: 400, lineHeight: 1.3, letterSpacing: 0.0),
    breakpoints: {
      'lg': CarbonTextStyleData(fontSize: 24.0, fontWeight: 400, lineHeight: 1.334, letterSpacing: 0.0),
      'max': CarbonTextStyleData(fontSize: 32.0, fontWeight: 400, lineHeight: 1.25, letterSpacing: 0.0),
      'md': CarbonTextStyleData(fontSize: 20.0, fontWeight: 400, letterSpacing: 0.0),
      'xlg': CarbonTextStyleData(fontSize: 28.0, fontWeight: 400, lineHeight: 1.2857, letterSpacing: 0.0),
    },
  ),
  'quotation02': CarbonFluidTypeStyle(
    base: CarbonTextStyleData(fontSize: 32.0, fontWeight: 300, lineHeight: 1.25, letterSpacing: 0.0),
    breakpoints: {
      'lg': CarbonTextStyleData(fontSize: 42.0, lineHeight: 1.19),
      'max': CarbonTextStyleData(fontSize: 60.0),
      'md': CarbonTextStyleData(fontSize: 36.0, lineHeight: 1.22),
      'xlg': CarbonTextStyleData(fontSize: 48.0, lineHeight: 1.17),
    },
  ),
};

/// Font-weight token values.
Map<FontWeightToken, FontWeight> carbonFontWeightValues() => {
    CarbonTokens.fontWeightLight: FontWeight.w300,
    CarbonTokens.fontWeightRegular: FontWeight.w400,
    CarbonTokens.fontWeightSemibold: FontWeight.w600,
  };

/// IBM Plex font-family fallback stacks.
class CarbonFontFamilies {
  CarbonFontFamilies._();
  static const String mono = "'IBM Plex Mono', 'Menlo', 'DejaVu Sans Mono', 'Bitstream Vera Sans Mono', Courier, monospace";
  static const String sans = "'IBM Plex Sans', system-ui, -apple-system, BlinkMacSystemFont, '.SFNSText-Regular', sans-serif";
  static const String sansCondensed = "'IBM Plex Sans Condensed', 'Helvetica Neue', Arial, sans-serif";
  static const String sansHebrew = "'IBM Plex Sans Hebrew', 'Helvetica Hebrew', 'Arial Hebrew', sans-serif";
  static const String serif = "'IBM Plex Serif', 'Georgia', Times, serif";
}
