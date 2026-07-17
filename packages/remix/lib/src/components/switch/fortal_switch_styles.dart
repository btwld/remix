part of 'switch.dart';

/// Fortal switch size presets.
enum FortalSwitchSize {
  /// Compact switch.
  size1,

  /// Default switch.
  size2,

  /// Large switch.
  size3,
}

/// Fortal switch color variants.
enum FortalSwitchVariant {
  /// Surface treatment with a visible border.
  surface,

  /// Softer accent treatment.
  soft,
}

/// Fortal-themed preset for [RemixSwitch].
RemixSwitchStyler fortalSwitchStyler({
  FortalSwitchVariant variant = .surface,
  FortalSwitchSize size = .size2,
  bool highContrast = false,
}) {
  return switch (variant) {
    .surface => _fortalSwitchSurfaceStyler(size, highContrast: highContrast),
    .soft => _fortalSwitchSoftStyler(size, highContrast: highContrast),
  };
}

RemixSwitchStyler _fortalSwitchBaseStyler(FortalSwitchSize size) {
  return RemixSwitchStyler()
      .thumbColor(Colors.white)
      .thumb(
        BoxStyler()
            .borderRadiusAll(FortalTokens.radiusThumb())
            .shadow(
              BoxShadowMix()
                  .color(FortalTokens.grayA7())
                  .offset(x: 0, y: 2)
                  .blurRadius(3),
            ),
      )
      .onFocused(
        RemixSwitchStyler().borderAll(
          color: FortalTokens.focusA8(),
          width: FortalTokens.focusRingWidth(),
        ),
      )
      .merge(_fortalSwitchSizeStyler(size));
}

RemixSwitchStyler _fortalSwitchSurfaceStyler(
  FortalSwitchSize size, {
  bool highContrast = false,
}) {
  return _fortalSwitchBaseStyler(size)
      .trackColor(FortalTokens.gray5())
      .borderRadius(BorderRadiusMix.circular(999))
      .borderAll(
        color: FortalTokens.gray8(),
        width: FortalTokens.borderWidth1(),
        strokeAlign: BorderSide.strokeAlignCenter,
      )
      .onSelected(
        RemixSwitchStyler()
            .trackColor(
              highContrast
                  ? FortalTokens.accent12()
                  : FortalTokens.accentTrack(),
            )
            .borderAll(
              color: highContrast
                  ? FortalTokens.accent12()
                  : FortalTokens.accent9(),
            )
            .thumbColor(highContrast ? FortalTokens.accent1() : Colors.white),
      )
      .onDisabled(
        RemixSwitchStyler()
            .trackColor(FortalTokens.grayA3())
            .borderAll(color: FortalTokens.gray5())
            .thumbColor(FortalTokens.gray2()),
      );
}

RemixSwitchStyler _fortalSwitchSoftStyler(
  FortalSwitchSize size, {
  bool highContrast = false,
}) {
  return _fortalSwitchBaseStyler(size)
      .trackColor(FortalTokens.gray5())
      .borderRadius(BorderRadiusMix.circular(999))
      .borderAll(
        color: FortalTokens.gray5(),
        width: FortalTokens.borderWidth1(),
        strokeAlign: BorderSide.strokeAlignCenter,
      )
      .onSelected(
        RemixSwitchStyler()
            .trackColor(
              highContrast ? FortalTokens.accent12() : FortalTokens.accentA7(),
            )
            .borderAll(
              color: highContrast
                  ? FortalTokens.accent12()
                  : FortalTokens.accent7(),
            )
            .thumbColor(highContrast ? FortalTokens.accent1() : Colors.white),
      )
      .onDisabled(
        RemixSwitchStyler()
            .trackColor(FortalTokens.gray5())
            .borderAll(color: FortalTokens.gray5())
            .shadow(BoxShadowMix())
            .thumbColor(FortalTokens.gray2()),
      );
}

RemixSwitchStyler _fortalSwitchSizeStyler(FortalSwitchSize size) {
  return switch (size) {
    .size1 => RemixSwitchStyler(
      container: BoxStyler().width(28.0).height(16.0),
      thumb: BoxStyler().width(16.0).height(16.0),
    ),
    .size2 => RemixSwitchStyler(
      container: BoxStyler().width(35.0).height(20.0),
      thumb: BoxStyler().size(20.0, 20.0),
    ),
    .size3 => RemixSwitchStyler(
      container: BoxStyler().width(42.0).height(24.0),
      thumb: BoxStyler().size(24.0, 24.0),
    ),
  };
}

/// Fortal-themed preset for [RemixSwitch].
class FortalSwitch extends StatelessWidget {
  const FortalSwitch({
    super.key,
    this.variant = .surface,
    this.size = .size2,
    this.color,
    this.radius,
    this.highContrast = false,
    required this.selected,
    this.onChanged,
    this.enabled = true,
    this.enableFeedback = true,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
    this.mouseCursor = SystemMouseCursors.click,
  });

  /// Surface treatment with a visible border.
  const FortalSwitch.surface({
    super.key,
    this.size = .size2,
    this.color,
    this.radius,
    this.highContrast = false,
    required this.selected,
    this.onChanged,
    this.enabled = true,
    this.enableFeedback = true,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = FortalSwitchVariant.surface;

  /// Softer accent treatment.
  const FortalSwitch.soft({
    super.key,
    this.size = .size2,
    this.color,
    this.radius,
    this.highContrast = false,
    required this.selected,
    this.onChanged,
    this.enabled = true,
    this.enableFeedback = true,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = FortalSwitchVariant.soft;

  final FortalSwitchVariant variant;

  final FortalSwitchSize size;

  /// Optional accent color override for this switch subtree.
  final FortalAccentColor? color;

  /// Optional radius override for this switch subtree.
  final FortalRadius? radius;

  /// Whether to use higher-contrast accent colors.
  final bool highContrast;

  final bool selected;

  final ValueChanged<bool>? onChanged;

  final bool enabled;

  final bool enableFeedback;

  final FocusNode? focusNode;

  final bool autofocus;

  final String? semanticLabel;

  final MouseCursor mouseCursor;

  @override
  Widget build(BuildContext context) {
    return FortalOverride(
      color: this.color,
      radius: this.radius,
      child:
          fortalSwitchStyler(
            variant: this.variant,
            size: this.size,
            highContrast: this.highContrast,
          ).call(
            key: this.key,
            selected: this.selected,
            onChanged: this.onChanged,
            enabled: this.enabled,
            enableFeedback: this.enableFeedback,
            focusNode: this.focusNode,
            autofocus: this.autofocus,
            semanticLabel: this.semanticLabel,
            mouseCursor: this.mouseCursor,
          ),
    );
  }
}
