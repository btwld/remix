// ABOUTME: Factory for creating RemixTooltipStyle instances using Radix tokens
// ABOUTME: Adds size presets and common variants (surface, soft, solid)

import 'package:mix/mix.dart';

import '../../radix/radix.dart';
import 'tooltip.dart';

enum RadixTooltipSize {
  size1,
  size2,
  size3,
}

enum RadixTooltipVariant {
  surface,
  soft,
  solid,
}

class RadixTooltipStyles {
  const RadixTooltipStyles._();

  static RemixTooltipStyle create({
    RadixTooltipVariant variant = RadixTooltipVariant.surface,
    RadixTooltipSize size = RadixTooltipSize.size2,
  }) {
    return switch (variant) {
      RadixTooltipVariant.surface => surface(size: size),
      RadixTooltipVariant.soft => soft(size: size),
      RadixTooltipVariant.solid => solid(size: size),
    };
  }

  static RemixTooltipStyle base({RadixTooltipSize size = RadixTooltipSize.size2}) {
    return RemixTooltipStyle()
        .borderRadiusAll(RadixTokens.radius2())
        .merge(_sizeStyle(size));
  }

  /// Neutral panel tooltip
  static RemixTooltipStyle surface({RadixTooltipSize size = RadixTooltipSize.size2}) {
    return base(size: size)
        // NOTE: No tooltip-specific color token; use panel surface
        // TODO: Confirm final token mapping for tooltip background once available
        .color(RadixTokens.colorPanelSolid())
        .merge(RemixTooltipStyle(
          text: TextStyler(style: RadixTokens.text2.mix()).color(RadixTokens.gray12()),
        ));
  }

  /// Accent-tinted tooltip
  static RemixTooltipStyle soft({RadixTooltipSize size = RadixTooltipSize.size2}) {
    return base(size: size)
        .color(RadixTokens.accent3())
        .merge(RemixTooltipStyle(
          text: TextStyler(style: RadixTokens.text2.mix()).color(RadixTokens.accent11()),
        ));
  }

  /// Strong, high-contrast tooltip (dark background + light text)
  static RemixTooltipStyle solid({RadixTooltipSize size = RadixTooltipSize.size2}) {
    return base(size: size)
        .color(RadixTokens.gray12())
        .merge(RemixTooltipStyle(
          text: TextStyler(style: RadixTokens.text2.mix()).color(RadixTokens.gray1()),
        ));
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------
  static RemixTooltipStyle _sizeStyle(RadixTooltipSize size) {
    // Use popover-content-padding as guidance for padding
    // radix_components.generated.json: popover-content-padding = space-6 (24px)
    // Tooltips are smaller; we scale down by size.
    return switch (size) {
      RadixTooltipSize.size1 => RemixTooltipStyle()
          .padding(EdgeInsetsGeometryMix.symmetric(horizontal: 8.0, vertical: 4.0))
          .merge(RemixTooltipStyle(text: TextStyler(style: RadixTokens.text1.mix()))),
      RadixTooltipSize.size2 => RemixTooltipStyle()
          .padding(EdgeInsetsGeometryMix.symmetric(horizontal: 10.0, vertical: 6.0))
          .merge(RemixTooltipStyle(text: TextStyler(style: RadixTokens.text2.mix()))),
      RadixTooltipSize.size3 => RemixTooltipStyle()
          .padding(EdgeInsetsGeometryMix.symmetric(horizontal: 12.0, vertical: 8.0))
          .merge(RemixTooltipStyle(text: TextStyler(style: RadixTokens.text3.mix()))),
    };
  }
}
