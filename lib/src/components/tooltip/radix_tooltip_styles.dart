part of 'tooltip.dart';

enum FortalTooltipSize { size1, size2, size3 }

enum FortalTooltipVariant { surface, soft, solid }

class FortalTooltipStyles {
  const FortalTooltipStyles._();

  static RemixTooltipStyle create({
    FortalTooltipVariant variant = FortalTooltipVariant.surface,
    FortalTooltipSize size = FortalTooltipSize.size2,
  }) {
    return switch (variant) {
      FortalTooltipVariant.surface => surface(size: size),
      FortalTooltipVariant.soft => soft(size: size),
      FortalTooltipVariant.solid => solid(size: size),
    };
  }

  static RemixTooltipStyle base({
    FortalTooltipSize size = FortalTooltipSize.size2,
  }) {
    return RemixTooltipStyle()
        .borderRadiusAll(FortalTokens.radius2())
        .merge(_sizeStyle(size));
  }

  /// Neutral panel tooltip
  static RemixTooltipStyle surface({
    FortalTooltipSize size = FortalTooltipSize.size2,
  }) {
    return base(size: size)
        // NOTE: No tooltip-specific color token; use panel surface
        // TODO: Confirm final token mapping for tooltip background once available
        .textColor(FortalTokens.colorPanelSolid())
        .labelTextStyle(FortalTokens.text2.mix())
        .labelColor(FortalTokens.gray12());
  }

  /// Accent-tinted tooltip
  static RemixTooltipStyle soft({
    FortalTooltipSize size = FortalTooltipSize.size2,
  }) {
    return base(size: size)
        .textColor(FortalTokens.accent3())
        .labelTextStyle(FortalTokens.text2.mix())
        .labelColor(FortalTokens.accent11());
  }

  /// Strong, high-contrast tooltip (dark background + light text)
  static RemixTooltipStyle solid({
    FortalTooltipSize size = FortalTooltipSize.size2,
  }) {
    return base(size: size)
        .textColor(FortalTokens.gray12())
        .labelTextStyle(FortalTokens.text2.mix())
        .labelColor(FortalTokens.gray1());
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------
  static RemixTooltipStyle _sizeStyle(FortalTooltipSize size) {
    // Use popover-content-padding as guidance for padding
    // radix_components.generated.json: popover-content-padding = space-6 (24px)
    // Tooltips are smaller; we scale down by size.
    return switch (size) {
      FortalTooltipSize.size1 =>
        RemixTooltipStyle()
            .paddingY(4.0)
            .paddingX(8.0)
            .labelTextStyle(FortalTokens.text1.mix()),
      FortalTooltipSize.size2 =>
        RemixTooltipStyle()
            .paddingY(6.0)
            .paddingX(10.0)
            .labelTextStyle(FortalTokens.text2.mix()),
      FortalTooltipSize.size3 =>
        RemixTooltipStyle()
            .paddingY(8.0)
            .paddingX(12.0)
            .labelTextStyle(FortalTokens.text3.mix()),
    };
  }
}
