part of 'callout.dart';

enum FortalCalloutSize {
  size1,
  size2,
  size3,
}

enum FortalCalloutVariant {
  classic,
  surface,
  soft,
}

/// Factory class for creating Fortal-compliant callout styles.
///
/// Provides base + variant + size composition like the button pattern.
/// Uses component tokens from radix_components.generated.json where available.
class FortalCalloutStyles {
  const FortalCalloutStyles._();

  /// Factory constructor with variant and size parameters.
  static RemixCalloutStyle create({
    FortalCalloutVariant variant = FortalCalloutVariant.surface,
    FortalCalloutSize size = FortalCalloutSize.size2,
  }) {
    return switch (variant) {
      FortalCalloutVariant.classic => classic(size: size),
      FortalCalloutVariant.surface => surface(size: size),
      FortalCalloutVariant.soft => soft(size: size),
    };
  }

  static RemixCalloutStyle base({
    FortalCalloutSize size = FortalCalloutSize.size2,
  }) {
    return RemixCalloutStyle()
        // Horizontal layout with spacing between icon and text
        .merge(
          RemixCalloutStyle(
            container: FlexBoxStyler(
              direction: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          ),
        )
        // Merge with size-specific styles
        .merge(_sizeStyle(size));
  }

  /// Neutral/gray variant (surface background with gray border + gray text)
  static RemixCalloutStyle classic({
    FortalCalloutSize size = FortalCalloutSize.size2,
  }) {
    return base(size: size)
        .color(FortalTokens.colorSurface())
        .borderAll(
          color: FortalTokens.gray7(),
          width: FortalTokens.borderWidth1(),
        )
        .borderRadiusAll(FortalTokens.radius3())
        .textColor(FortalTokens.gray12())
        .iconColor(FortalTokens.gray12());
  }

  /// Accent-tinted surface variant (accentSurface background + accent border/text)
  static RemixCalloutStyle surface({
    FortalCalloutSize size = FortalCalloutSize.size2,
  }) {
    return base(size: size)
        .color(FortalTokens.accentSurface())
        .borderAll(
          color: FortalTokens.accent6(),
          width: FortalTokens.borderWidth1(),
        )
        .borderRadiusAll(FortalTokens.radius3())
        .textColor(FortalTokens.accent11())
        .iconColor(FortalTokens.accent11());
  }

  /// Soft tinted variant (accent3 background + accent6 border + accent11 text)
  static RemixCalloutStyle soft({
    FortalCalloutSize size = FortalCalloutSize.size2,
  }) {
    return base(size: size)
        .color(FortalTokens.accent3())
        .borderAll(
          color: FortalTokens.accent6(),
          width: FortalTokens.borderWidth1(),
        )
        .borderRadiusAll(FortalTokens.radius3())
        .textColor(FortalTokens.accent11())
        .iconColor(FortalTokens.accent11());
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixCalloutStyle _sizeStyle(FortalCalloutSize size) {
    // NOTE: JSON token "callout-icon-height: var(--line-height-3)" implies
    // icon sized to match text line-height. We approximate sizes below.
    return switch (size) {
      FortalCalloutSize.size1 => RemixCalloutStyle(
          container: FlexBoxStyler(
            padding: EdgeInsetsGeometryMix.symmetric(
              vertical: 8.0,
              horizontal: 12.0,
            ),
            spacing: FortalTokens.space2(), // 8px between icon and text
          ),
          text: TextStyler(style: FortalTokens.text1.mix()),
          icon: IconStyler(
            size: 16.0,
          ), // TODO: align to exact line-height token if exposed
        ),
      FortalCalloutSize.size2 => RemixCalloutStyle(
          container: FlexBoxStyler(
            padding: EdgeInsetsGeometryMix.symmetric(
              vertical: 12.0,
              horizontal: 16.0,
            ),
            spacing: FortalTokens.space2(),
          ),
          text: TextStyler(style: FortalTokens.text2.mix()),
          icon: IconStyler(size: 20.0), // --line-height-3 approximated as 20px
        ),
      FortalCalloutSize.size3 => RemixCalloutStyle(
          container: FlexBoxStyler(
            padding: EdgeInsetsGeometryMix.symmetric(
              vertical: 16.0,
              horizontal: 20.0,
            ),
            spacing: FortalTokens.space3(),
          ),
          text: TextStyler(style: FortalTokens.text3.mix()),
          icon: IconStyler(size: 24.0), // TODO: confirm with token mapping
        ),
    };
  }
}
