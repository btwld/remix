part of 'radio.dart';

/// Fortal radio size presets.
enum FortalRadioSize {
  /// Compact radio.
  size1,

  /// Default radio.
  size2,

  /// Large radio.
  size3,
}

/// Fortal radio color variants.
enum FortalRadioVariant {
  /// Surface treatment with neutral border.
  surface,

  /// Soft accent treatment.
  soft,
}

/// Creates a Fortal-themed [RemixRadioStyle].
///
/// The returned style can be passed to [RemixRadio.style] or called directly
/// as a widget factory via [RemixRadioStyle.call].
RemixRadioStyle fortalRadioStyle({
  FortalRadioVariant variant = .surface,
  FortalRadioSize size = .size2,
}) {
  return switch (variant) {
    .surface => _fortalRadioSurfaceStyle(size),
    .soft => _fortalRadioSoftStyle(size),
  };
}

/// A [RemixRadio] preconfigured with Fortal size and variant presets.
class FortalRadio<T> extends StatelessWidget {
  /// Creates a Fortal-themed radio.
  const FortalRadio({
    super.key,
    this.variant = .surface,
    this.size = .size2,
    required this.value,
    this.enabled = true,
    this.autofocus = false,
    this.toggleable = false,
    this.focusNode,
    this.mouseCursor,
    this.enableFeedback = true,
  });

  /// Visual treatment variant for the radio.
  final FortalRadioVariant variant;

  /// Size preset for the radio.
  final FortalRadioSize size;

  /// The value represented by this radio button.
  final T value;

  /// Whether this radio button is enabled.
  final bool enabled;

  /// Whether the radio button should request focus when it is created.
  final bool autofocus;

  /// Whether the radio button can be unselected when selected.
  final bool toggleable;

  /// Focus node used by the underlying radio.
  final FocusNode? focusNode;

  /// Mouse cursor used when hovering over the radio.
  final MouseCursor? mouseCursor;

  /// Whether interactions should trigger platform feedback.
  final bool enableFeedback;

  @override
  Widget build(BuildContext context) {
    return RemixRadio<T>(
      key: key,
      value: value,
      style: fortalRadioStyle(variant: variant, size: size),
      enabled: enabled,
      autofocus: autofocus,
      toggleable: toggleable,
      focusNode: focusNode,
      mouseCursor: mouseCursor,
      enableFeedback: enableFeedback,
    );
  }
}

RemixRadioStyle _fortalRadioBaseStyle(FortalRadioSize size) {
  return RemixRadioStyle()
      .onFocused(
        RemixRadioStyle().borderAll(
          color: FortalTokens.focusA8(),
          width: FortalTokens.focusRingWidth(),
        ),
      )
      .merge(_fortalRadioSizeStyle(size));
}

RemixRadioStyle _fortalRadioSurfaceStyle([FortalRadioSize size = .size2]) {
  return _fortalRadioBaseStyle(size)
      .fillColor(FortalTokens.colorSurface())
      .borderAll(
        color: FortalTokens.gray6(),
        width: FortalTokens.borderWidth1(),
      )
      .borderRadiusAll(FortalTokens.radiusFull())
      .indicator(
        BoxStyler()
            .color(FortalTokens.accent9())
            .borderRadiusAll(FortalTokens.radiusFull()),
      )
      .onSelected(
        RemixRadioStyle()
            .fillColor(FortalTokens.accent9())
            .borderAll(
              color: FortalTokens.accent9(),
              width: FortalTokens.borderWidth1(),
            )
            .indicator(BoxStyler().color(Colors.white)),
      )
      .onDisabled(
        RemixRadioStyle()
            .fillColor(FortalTokens.gray3())
            .borderAll(
              color: FortalTokens.gray6(),
              width: FortalTokens.borderWidth1(),
            )
            .indicator(BoxStyler().color(FortalTokens.gray9())),
      );
}

RemixRadioStyle _fortalRadioSoftStyle([FortalRadioSize size = .size2]) {
  return _fortalRadioBaseStyle(size)
      .fillColor(FortalTokens.accentA4())
      .borderRadiusAll(FortalTokens.radiusFull())
      .indicator(
        BoxStyler()
            .color(FortalTokens.accent11())
            .borderRadiusAll(FortalTokens.radiusFull()),
      )
      .onSelected(
        RemixRadioStyle()
            .fillColor(FortalTokens.accentA4())
            .indicator(BoxStyler().color(FortalTokens.accent11())),
      )
      .onDisabled(
        RemixRadioStyle()
            .fillColor(FortalTokens.gray3())
            .indicator(BoxStyler().color(FortalTokens.gray7())),
      );
}

RemixRadioStyle _fortalRadioSizeStyle(FortalRadioSize size) {
  return switch (size) {
    .size1 => RemixRadioStyle(
      container: BoxStyler().width(16.0).height(16.0).alignment(.center),
      indicator: BoxStyler().width(6.0).height(6.0),
    ),
    .size2 => RemixRadioStyle(
      container: BoxStyler().width(20.0).height(20.0).alignment(.center),
      indicator: BoxStyler().width(8.0).height(8.0),
    ),
    .size3 => RemixRadioStyle(
      container: BoxStyler().width(24.0).height(24.0).alignment(.center),
      indicator: BoxStyler().width(10.0).height(10.0),
    ),
  };
}
