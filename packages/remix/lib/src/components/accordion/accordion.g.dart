// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accordion.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixAccordionSpecMethods on Spec<RemixAccordionSpec>, Diagnosticable {
  StyleSpec<FlexBoxSpec>? get trigger;
  StyleSpec<IconSpec>? get leadingIcon;
  StyleSpec<TextSpec>? get title;
  StyleSpec<IconSpec>? get trailingIcon;
  StyleSpec<BoxSpec>? get content;

  @override
  RemixAccordionSpec copyWith({
    StyleSpec<FlexBoxSpec>? trigger,
    StyleSpec<IconSpec>? leadingIcon,
    StyleSpec<TextSpec>? title,
    StyleSpec<IconSpec>? trailingIcon,
    StyleSpec<BoxSpec>? content,
  }) {
    return RemixAccordionSpec(
      trigger: trigger ?? this.trigger,
      leadingIcon: leadingIcon ?? this.leadingIcon,
      title: title ?? this.title,
      trailingIcon: trailingIcon ?? this.trailingIcon,
      content: content ?? this.content,
    );
  }

  @override
  RemixAccordionSpec lerp(RemixAccordionSpec? other, double t) {
    return RemixAccordionSpec(
      trigger: trigger?.lerp(other?.trigger, t),
      leadingIcon: leadingIcon?.lerp(other?.leadingIcon, t),
      title: title?.lerp(other?.title, t),
      trailingIcon: trailingIcon?.lerp(other?.trailingIcon, t),
      content: content?.lerp(other?.content, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('trigger', trigger))
      ..add(DiagnosticsProperty('leadingIcon', leadingIcon))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('trailingIcon', trailingIcon))
      ..add(DiagnosticsProperty('content', content));
  }

  @override
  List<Object?> get props => [
    trigger,
    leadingIcon,
    title,
    trailingIcon,
    content,
  ];
}

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixAccordionStyleMixin on Style<RemixAccordionSpec>, Diagnosticable {
  Prop<StyleSpec<BoxSpec>>? get $content;
  Prop<StyleSpec<IconSpec>>? get $leadingIcon;
  Prop<StyleSpec<TextSpec>>? get $title;
  Prop<StyleSpec<IconSpec>>? get $trailingIcon;
  Prop<StyleSpec<FlexBoxSpec>>? get $trigger;

  /// Sets the content.
  RemixAccordionStyle content(BoxStyler value) {
    return merge(RemixAccordionStyle(content: value));
  }

  /// Sets the leadingIcon.
  RemixAccordionStyle leadingIcon(IconStyler value) {
    return merge(RemixAccordionStyle(leadingIcon: value));
  }

  /// Sets the title.
  RemixAccordionStyle title(TextStyler value) {
    return merge(RemixAccordionStyle(title: value));
  }

  /// Sets the trailingIcon.
  RemixAccordionStyle trailingIcon(IconStyler value) {
    return merge(RemixAccordionStyle(trailingIcon: value));
  }

  /// Sets the trigger.
  RemixAccordionStyle trigger(FlexBoxStyler value) {
    return merge(RemixAccordionStyle(trigger: value));
  }

  /// Sets the animation configuration.
  RemixAccordionStyle animate(AnimationConfig value) {
    return merge(RemixAccordionStyle(animation: value));
  }

  /// Sets the style variants.
  RemixAccordionStyle variants(List<VariantStyle<RemixAccordionSpec>> value) {
    return merge(RemixAccordionStyle(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixAccordionStyle wrap(WidgetModifierConfig value) {
    return merge(RemixAccordionStyle(modifier: value));
  }

  /// Merges with another [RemixAccordionStyle].
  @override
  RemixAccordionStyle merge(RemixAccordionStyle? other) {
    return RemixAccordionStyle.create(
      content: MixOps.merge($content, other?.$content),
      leadingIcon: MixOps.merge($leadingIcon, other?.$leadingIcon),
      title: MixOps.merge($title, other?.$title),
      trailingIcon: MixOps.merge($trailingIcon, other?.$trailingIcon),
      trigger: MixOps.merge($trigger, other?.$trigger),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixAccordionSpec>] using context.
  @override
  StyleSpec<RemixAccordionSpec> resolve(BuildContext context) {
    final spec = RemixAccordionSpec(
      content: MixOps.resolve(context, $content),
      leadingIcon: MixOps.resolve(context, $leadingIcon),
      title: MixOps.resolve(context, $title),
      trailingIcon: MixOps.resolve(context, $trailingIcon),
      trigger: MixOps.resolve(context, $trigger),
    );

    return StyleSpec(
      spec: spec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('content', $content))
      ..add(DiagnosticsProperty('leadingIcon', $leadingIcon))
      ..add(DiagnosticsProperty('title', $title))
      ..add(DiagnosticsProperty('trailingIcon', $trailingIcon))
      ..add(DiagnosticsProperty('trigger', $trigger));
  }

  @override
  List<Object?> get props => [
    $content,
    $leadingIcon,
    $title,
    $trailingIcon,
    $trigger,
    $animation,
    $modifier,
    $variants,
  ];
}
