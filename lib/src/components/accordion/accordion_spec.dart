part of 'accordion.dart';

class AccordionSpec extends Spec<AccordionSpec> with Diagnosticable {
  final StyleSpec<FlexBoxSpec> container;
  final StyleSpec<AccordionItemSpec> item;

  const AccordionSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<AccordionItemSpec>? item,
  })  : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
        item = item ?? const StyleSpec(spec: AccordionItemSpec());

  AccordionSpec copyWith({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<AccordionItemSpec>? item,
  }) {
    return AccordionSpec(
      container: container ?? this.container,
      item: item ?? this.item,
    );
  }

  AccordionSpec lerp(AccordionSpec? other, double t) {
    if (other == null) return this;

    return AccordionSpec(
      container: MixOps.lerp(container, other.container, t)!,
      item: MixOps.lerp(item, other.item, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('item', item));
  }

  @override
  List<Object?> get props => [container, item];
}

class AccordionItemSpec extends Spec<AccordionItemSpec> with Diagnosticable {
  final StyleSpec<FlexBoxSpec> trigger;
  final StyleSpec<TextSpec> title;
  final StyleSpec<IconSpec> icon;
  final StyleSpec<BoxSpec> content;

  const AccordionItemSpec({
    StyleSpec<FlexBoxSpec>? trigger,
    StyleSpec<TextSpec>? title,
    StyleSpec<IconSpec>? icon,
    StyleSpec<BoxSpec>? content,
  })  : trigger = trigger ?? const StyleSpec(spec: FlexBoxSpec()),
        title = title ?? const StyleSpec(spec: TextSpec()),
        icon = icon ?? const StyleSpec(spec: IconSpec()),
        content = content ?? const StyleSpec(spec: BoxSpec());

  AccordionItemSpec copyWith({
    StyleSpec<FlexBoxSpec>? trigger,
    StyleSpec<TextSpec>? title,
    StyleSpec<IconSpec>? icon,
    StyleSpec<BoxSpec>? content,
  }) {
    return AccordionItemSpec(
      trigger: trigger ?? this.trigger,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      content: content ?? this.content,
    );
  }

  AccordionItemSpec lerp(AccordionItemSpec? other, double t) {
    if (other == null) return this;

    return AccordionItemSpec(
      trigger: MixOps.lerp(trigger, other.trigger, t)!,
      title: MixOps.lerp(title, other.title, t)!,
      icon: MixOps.lerp(icon, other.icon, t)!,
      content: MixOps.lerp(content, other.content, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('trigger', trigger))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('icon', icon))
      ..add(DiagnosticsProperty('content', content));
  }

  @override
  List<Object?> get props => [trigger, title, icon, content];
}