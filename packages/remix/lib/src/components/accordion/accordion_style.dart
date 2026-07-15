part of 'accordion.dart';

/// Style configuration for [RemixAccordion] trigger, icons, title, and content.
extension RemixAccordionStylerRemixHelpers on RemixAccordionStyler {
  /// Sets the background color of the trigger.
  RemixAccordionStyler backgroundColor(Color value) {
    return merge(
      RemixAccordionStyler(
        trigger: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets title color.
  RemixAccordionStyler titleColor(Color value) {
    return title(TextStyler(style: TextStyleMix(color: value)));
  }

  /// Sets title font size.
  RemixAccordionStyler titleFontSize(double value) {
    return title(TextStyler(style: TextStyleMix(fontSize: value)));
  }

  /// Sets title font weight.
  RemixAccordionStyler titleFontWeight(FontWeight value) {
    return title(TextStyler(style: TextStyleMix(fontWeight: value)));
  }

  /// Sets title style using TextStyleMix directly.
  RemixAccordionStyler titleStyle(TextStyleMix value) {
    return title(TextStyler(style: value));
  }

  /// Sets leading icon color.
  RemixAccordionStyler leadingIconColor(Color value) {
    return leadingIcon(IconStyler(color: value));
  }

  /// Sets leading icon size.
  RemixAccordionStyler leadingIconSize(double value) {
    return leadingIcon(IconStyler(size: value));
  }

  /// Sets trailing icon color.
  RemixAccordionStyler trailingIconColor(Color value) {
    return trailingIcon(IconStyler(color: value));
  }

  /// Sets trailing icon size.
  RemixAccordionStyler trailingIconSize(double value) {
    return trailingIcon(IconStyler(size: value));
  }

  /// Sets content background color.
  RemixAccordionStyler contentColor(Color value) {
    return content(BoxStyler(decoration: BoxDecorationMix(color: value)));
  }

  /// Sets content padding.
  RemixAccordionStyler contentPadding(EdgeInsetsGeometryMix value) {
    return content(BoxStyler(padding: value));
  }

  /// Sets content decoration.
  RemixAccordionStyler contentDecoration(DecorationMix value) {
    return content(BoxStyler(decoration: value));
  }

  /// Style when the accordion is expanded.
  RemixAccordionStyler onExpanded<T>(RemixAccordionStyler value) {
    return variants([
      VariantStyle(
        ContextVariant('onExpanded', (context) {
          return NakedAccordionItemState.of<T>(context).isExpanded;
        }),
        value,
      ),
    ]);
  }

  /// Style when accordion is collapsed
  RemixAccordionStyler onCollapsed<T>(RemixAccordionStyler value) {
    return variants([
      VariantStyle(
        ContextVariant('onCollapsed', (context) {
          return !NakedAccordionItemState.of<T>(context).isExpanded;
        }),
        value,
      ),
    ]);
  }

  /// Style when the accordion item can collapse.
  RemixAccordionStyler onCanCollapse(RemixAccordionStyler value) {
    return variants([
      VariantStyle(
        ContextVariant('onCanCollapse', (context) {
          return NakedAccordionItemState.of(context).canCollapse;
        }),
        value,
      ),
    ]);
  }

  /// Style when the accordion item can expand.
  RemixAccordionStyler onCanExpand<T>(RemixAccordionStyler value) {
    return variants([
      VariantStyle(
        ContextVariant('onCanExpand', (context) {
          return NakedAccordionItemState.of<T>(context).canExpand;
        }),
        value,
      ),
    ]);
  }

  /// Creates a [RemixAccordion] widget with this style applied.
  RemixAccordion<T> call<T>({
    Key? key,
    required T value,
    required Widget child,
    String? title,
    IconData? leadingIcon,
    IconData? trailingIcon,
    NakedAccordionTriggerBuilder<T>? builder,
    bool enabled = true,
    MouseCursor mouseCursor = SystemMouseCursors.click,
    bool enableFeedback = true,
    bool autofocus = false,
    FocusNode? focusNode,
    ValueChanged<bool>? onFocusChange,
    ValueChanged<bool>? onHoverChange,
    ValueChanged<bool>? onPressChange,
    String? semanticLabel,
    Widget Function(Widget, Animation<double>)? transitionBuilder,
  }) {
    return RemixAccordion(
      key: key,
      value: value,
      title: title,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      enabled: enabled,
      mouseCursor: mouseCursor,
      enableFeedback: enableFeedback,
      autofocus: autofocus,
      focusNode: focusNode,
      onFocusChange: onFocusChange,
      onHoverChange: onHoverChange,
      onPressChange: onPressChange,
      semanticLabel: semanticLabel,
      transitionBuilder:
          transitionBuilder ?? RemixAccordion.defaultAccordionTransitionBuilder,
      style: this,
      child: child,
      builder: builder,
    );
  }

  RemixAccordionStyler flex(FlexStyler value) {
    return merge(RemixAccordionStyler(trigger: FlexBoxStyler().flex(value)));
  }
}
