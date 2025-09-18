part of 'tooltip.dart';

enum FortalTooltipSize {
  size1,
  size2,
  size3,
}

enum FortalTooltipVariant {
  surface,
  soft,
  solid,
}

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

  static RemixTooltipStyle base(
      {FortalTooltipSize size = FortalTooltipSize.size2}) {
    return RemixTooltipStyle()
        .borderRadiusAll(FortalTokens.radius2())
        .merge(_sizeStyle(size));
  }

  /// Neutral panel tooltip
  static RemixTooltipStyle surface(
      {FortalTooltipSize size = FortalTooltipSize.size2}) {
    return base(size: size)
        // NOTE: No tooltip-specific color token; use panel surface
        // TODO: Confirm final token mapping for tooltip background once available
        .color(FortalTokens.colorPanelSolid())
        .merge(RemixTooltipStyle(
          text: TextStyler(style: FortalTokens.text2.mix())
              .color(FortalTokens.gray12()),
        ));
  }

  /// Accent-tinted tooltip
  static RemixTooltipStyle soft(
      {FortalTooltipSize size = FortalTooltipSize.size2}) {
    return base(size: size)
        .color(FortalTokens.accent3())
        .merge(RemixTooltipStyle(
          text: TextStyler(style: FortalTokens.text2.mix())
              .color(FortalTokens.accent11()),
        ));
  }

  /// Strong, high-contrast tooltip (dark background + light text)
  static RemixTooltipStyle solid(
      {FortalTooltipSize size = FortalTooltipSize.size2}) {
    return base(size: size)
        .color(FortalTokens.gray12())
        .merge(RemixTooltipStyle(
          text: TextStyler(style: FortalTokens.text2.mix())
              .color(FortalTokens.gray1()),
        ));
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------
  static RemixTooltipStyle _sizeStyle(FortalTooltipSize size) {
    // Use popover-content-padding as guidance for padding
    // radix_components.generated.json: popover-content-padding = space-6 (24px)
    // Tooltips are smaller; we scale down by size.
    return switch (size) {
      FortalTooltipSize.size1 => RemixTooltipStyle()
          .padding(
              EdgeInsetsGeometryMix.symmetric(vertical: 4.0, horizontal: 8.0))
          .merge(RemixTooltipStyle(
              text: TextStyler(style: FortalTokens.text1.mix()))),
      FortalTooltipSize.size2 => RemixTooltipStyle()
          .padding(
              EdgeInsetsGeometryMix.symmetric(vertical: 6.0, horizontal: 10.0))
          .merge(RemixTooltipStyle(
              text: TextStyler(style: FortalTokens.text2.mix()))),
      FortalTooltipSize.size3 => RemixTooltipStyle()
          .padding(
              EdgeInsetsGeometryMix.symmetric(vertical: 8.0, horizontal: 12.0))
          .merge(RemixTooltipStyle(
              text: TextStyler(style: FortalTokens.text3.mix()))),
    };
  }
}
