part of 'accordion.dart';

class RemixAccordionSpec extends Spec<RemixAccordionSpec>
    with Diagnosticable {
  final StyleSpec<FlexBoxSpec> trigger;
  final StyleSpec<IconSpec> leadingIcon;
  final StyleSpec<TextSpec> title;
  final StyleSpec<IconSpec> trailingIcon;
  final StyleSpec<BoxSpec> content;

  const RemixAccordionSpec({
    StyleSpec<FlexBoxSpec>? trigger,
    StyleSpec<IconSpec>? leadingIcon,
    StyleSpec<TextSpec>? title,
    StyleSpec<IconSpec>? trailingIcon,
    StyleSpec<BoxSpec>? content,
  })  : trigger = trigger ?? const StyleSpec(spec: FlexBoxSpec()),
        leadingIcon = leadingIcon ?? const StyleSpec(spec: IconSpec()),
        title = title ?? const StyleSpec(spec: TextSpec()),
        trailingIcon = trailingIcon ?? const StyleSpec(spec: IconSpec()),
        content = content ?? const StyleSpec(spec: BoxSpec());

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

  RemixAccordionSpec lerp(RemixAccordionSpec? other, double t) {
    if (other == null) return this;

    return RemixAccordionSpec(
      trigger: MixOps.lerp(trigger, other.trigger, t)!,
      leadingIcon: MixOps.lerp(leadingIcon, other.leadingIcon, t)!,
      title: MixOps.lerp(title, other.title, t)!,
      trailingIcon: MixOps.lerp(trailingIcon, other.trailingIcon, t)!,
      content: MixOps.lerp(content, other.content, t)!,
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
  List<Object?> get props => [trigger, leadingIcon, title, trailingIcon, content];
}
