part of 'callout.dart';

/// Fortal callout size presets.
enum FortalCalloutSize { size1, size2, size3 }

/// Fortal callout color and emphasis variants.
enum FortalCalloutVariant { outline, surface, soft }

/// Fortal-themed preset for [RemixCallout].
RemixCalloutStyler fortalCalloutStyler({
  FortalCalloutVariant variant = .surface,
  FortalCalloutSize size = .size2,
  bool highContrast = false,
}) {
  return switch (variant) {
    .soft => _fortalCalloutSoftStyler(size, highContrast: highContrast),
    .outline => _fortalCalloutOutlineStyler(size, highContrast: highContrast),
    .surface => _fortalCalloutSurfaceStyler(size, highContrast: highContrast),
  };
}

RemixCalloutStyler _fortalCalloutBaseStyler(FortalCalloutSize size) {
  return RemixCalloutStyler()
      .merge(
        RemixCalloutStyler(
          container: FlexBoxStyler(
            direction: .horizontal,
            crossAxisAlignment: .center,
          ),
        ),
      )
      .merge(_fortalCalloutSizeStyler(size));
}

RemixCalloutStyler _fortalCalloutOutlineStyler(
  FortalCalloutSize size, {
  bool highContrast = false,
}) {
  return _fortalCalloutBaseStyler(size)
      .backgroundColor(Colors.transparent)
      .borderAll(
        color: FortalTokens.accent7(),
        width: FortalTokens.borderWidth1(),
      )
      .borderRadiusAll(FortalTokens.radius3())
      .foregroundColor(
        highContrast ? FortalTokens.accent12() : FortalTokens.accent11(),
      );
}

RemixCalloutStyler _fortalCalloutSurfaceStyler(
  FortalCalloutSize size, {
  bool highContrast = false,
}) {
  return _fortalCalloutBaseStyler(size)
      .backgroundColor(FortalTokens.accentSurface())
      .borderAll(
        color: FortalTokens.accent6(),
        width: FortalTokens.borderWidth1(),
      )
      .borderRadiusAll(FortalTokens.radius3())
      .foregroundColor(
        highContrast ? FortalTokens.accent12() : FortalTokens.accent11(),
      );
}

RemixCalloutStyler _fortalCalloutSoftStyler(
  FortalCalloutSize size, {
  bool highContrast = false,
}) {
  return _fortalCalloutBaseStyler(size)
      .backgroundColor(FortalTokens.accent3())
      .borderRadiusAll(FortalTokens.radius3())
      .foregroundColor(
        highContrast ? FortalTokens.accent12() : FortalTokens.accent11(),
      );
}

RemixCalloutStyler _fortalCalloutSizeStyler(FortalCalloutSize size) {
  return switch (size) {
    .size1 => RemixCalloutStyler(
      container: FlexBoxStyler()
          .paddingY(8.0)
          .paddingX(12.0)
          .spacing(FortalTokens.space2()),
      text: TextStyler(style: FortalTokens.text1.mix()),
      icon: IconStyler(size: 16.0),
    ),
    .size2 => RemixCalloutStyler(
      container: FlexBoxStyler()
          .paddingY(12.0)
          .paddingX(16.0)
          .spacing(FortalTokens.space2()),
      text: TextStyler(style: FortalTokens.text2.mix()),
      icon: IconStyler(size: 20.0),
    ),
    .size3 => RemixCalloutStyler(
      container: FlexBoxStyler()
          .paddingY(16.0)
          .paddingX(20.0)
          .spacing(FortalTokens.space3()),
      text: TextStyler(style: FortalTokens.text3.mix()),
      icon: IconStyler(size: 24.0),
    ),
  };
}

/// Fortal-themed preset for [RemixCallout].
class FortalCallout extends StatelessWidget {
  const FortalCallout({
    super.key,
    this.variant = .surface,
    this.size = .size2,
    this.color,
    this.radius,
    this.highContrast = false,
    this.text,
    this.icon,
    this.child,
  });

  const FortalCallout.outline({
    super.key,
    this.size = .size2,
    this.color,
    this.radius,
    this.highContrast = false,
    this.text,
    this.icon,
    this.child,
  }) : variant = FortalCalloutVariant.outline;

  const FortalCallout.surface({
    super.key,
    this.size = .size2,
    this.color,
    this.radius,
    this.highContrast = false,
    this.text,
    this.icon,
    this.child,
  }) : variant = FortalCalloutVariant.surface;

  const FortalCallout.soft({
    super.key,
    this.size = .size2,
    this.color,
    this.radius,
    this.highContrast = false,
    this.text,
    this.icon,
    this.child,
  }) : variant = FortalCalloutVariant.soft;

  final FortalCalloutVariant variant;

  final FortalCalloutSize size;

  /// Optional accent color override for this callout subtree.
  final FortalAccentColor? color;

  /// Optional radius override for this callout subtree.
  final FortalRadius? radius;

  /// Whether to use higher-contrast accent colors.
  final bool highContrast;

  final String? text;

  final IconData? icon;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return FortalOverride(
      color: this.color,
      radius: this.radius,
      child:
          fortalCalloutStyler(
            variant: this.variant,
            size: this.size,
            highContrast: this.highContrast,
          ).call(
            key: this.key,
            text: this.text,
            icon: this.icon,
            child: this.child,
          ),
    );
  }
}
