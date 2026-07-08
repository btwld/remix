part of 'accordion.dart';

/// Fortal accordion size presets.
enum FortalAccordionSize { size1, size2, size3 }

/// Fortal accordion color variants.
enum FortalAccordionVariant { surface, soft }

/// Creates a Fortal-themed [RemixAccordionStyler].
///
/// Fortal widget wrapper is hand-written: hosted `mix_generator` 2.1.1 does
/// not support generic `call<T>()` methods.
RemixAccordionStyler fortalAccordionStyler({
  FortalAccordionVariant variant = .surface,
  FortalAccordionSize size = .size2,
}) {
  return switch (variant) {
    .surface => _fortalAccordionSurfaceStyler(size),
    .soft => _fortalAccordionSoftStyler(size),
  };
}

RemixAccordionStyler _fortalAccordionBaseStyler(FortalAccordionSize size) {
  return RemixAccordionStyler()
      .trigger(FlexBoxStyler().direction(.horizontal))
      .title(
        TextStyler().fontWeight(FontWeight.w500).color(FortalTokens.gray12()),
      )
      .trailingIcon(IconStyler().color(FortalTokens.gray11()))
      .content(BoxStyler().width(double.infinity))
      .merge(_fortalAccordionSizeStyler(size));
}

RemixAccordionStyler _fortalAccordionSurfaceStyler([
  FortalAccordionSize size = .size2,
]) {
  return _fortalAccordionBaseStyler(size)
      .trigger(FlexBoxStyler().color(FortalTokens.gray1()))
      .content(
        BoxStyler()
            .borderTop(
              color: FortalTokens.gray6(),
              width: FortalTokens.borderWidth1(),
            )
            .color(FortalTokens.gray2()),
      );
}

RemixAccordionStyler _fortalAccordionSoftStyler([
  FortalAccordionSize size = .size2,
]) {
  return _fortalAccordionBaseStyler(size)
      .trigger(FlexBoxStyler().color(FortalTokens.accent2()))
      .title(TextStyler().color(FortalTokens.accent12()))
      .trailingIcon(IconStyler().color(FortalTokens.accent11()))
      .content(
        BoxStyler()
            .borderTop(
              color: FortalTokens.accent6(),
              width: FortalTokens.borderWidth1(),
            )
            .color(FortalTokens.accent2()),
      );
}

RemixAccordionStyler _fortalAccordionSizeStyler(FortalAccordionSize size) {
  return switch (size) {
    .size1 => RemixAccordionStyler(
      trigger: FlexBoxStyler()
          .paddingX(FortalTokens.space2())
          .paddingY(FortalTokens.space2()),
      title: TextStyler().fontSize(14),
      trailingIcon: IconStyler().size(16),
      content: BoxStyler().paddingAll(FortalTokens.space2()),
    ),
    .size2 => RemixAccordionStyler(
      trigger: FlexBoxStyler()
          .paddingX(FortalTokens.space3())
          .paddingY(FortalTokens.space3()),
      title: TextStyler().fontSize(15),
      trailingIcon: IconStyler().size(20),
      content: BoxStyler().paddingAll(FortalTokens.space3()),
    ),
    .size3 => RemixAccordionStyler(
      trigger: FlexBoxStyler()
          .paddingX(FortalTokens.space4())
          .paddingY(FortalTokens.space4()),
      title: TextStyler().fontSize(16),
      trailingIcon: IconStyler().size(24),
      content: BoxStyler().paddingAll(FortalTokens.space4()),
    ),
  };
}

/// Fortal-themed accordion widget wrapper.
class FortalAccordion<T> extends StatelessWidget {
  const FortalAccordion({
    super.key,
    this.variant = .surface,
    this.size = .size2,
    required this.value,
    required this.child,
    this.title,
    this.leadingIcon,
    this.trailingIcon,
    this.builder,
    this.enabled = true,
    this.mouseCursor = SystemMouseCursors.click,
    this.enableFeedback = true,
    this.autofocus = false,
    this.focusNode,
    this.onFocusChange,
    this.onHoverChange,
    this.onPressChange,
    this.semanticLabel,
    this.transitionBuilder,
  });

  final FortalAccordionVariant variant;
  final FortalAccordionSize size;
  final T value;
  final Widget child;
  final String? title;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final NakedAccordionTriggerBuilder<T>? builder;
  final bool enabled;
  final MouseCursor mouseCursor;
  final bool enableFeedback;
  final bool autofocus;
  final FocusNode? focusNode;
  final ValueChanged<bool>? onFocusChange;
  final ValueChanged<bool>? onHoverChange;
  final ValueChanged<bool>? onPressChange;
  final String? semanticLabel;
  final Widget Function(Widget, Animation<double>)? transitionBuilder;

  @override
  Widget build(BuildContext context) {
    return fortalAccordionStyler(variant: variant, size: size).call<T>(
      key: key,
      value: value,
      child: child,
      title: title,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      builder: builder,
      enabled: enabled,
      mouseCursor: mouseCursor,
      enableFeedback: enableFeedback,
      autofocus: autofocus,
      focusNode: focusNode,
      onFocusChange: onFocusChange,
      onHoverChange: onHoverChange,
      onPressChange: onPressChange,
      semanticLabel: semanticLabel,
      transitionBuilder: transitionBuilder,
    );
  }
}
