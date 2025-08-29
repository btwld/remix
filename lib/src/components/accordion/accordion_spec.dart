part of 'accordion.dart';

class AccordionSpec extends Spec<AccordionSpec> with Diagnosticable {
  final WidgetSpec<BoxSpec> container;
  final WidgetSpec<BoxSpec> content;
  final WidgetSpec<BoxSpec> header;
  final WidgetSpec<LabelSpec> headerLabel;

  AccordionSpec({
    WidgetSpec<BoxSpec>? container,
    WidgetSpec<BoxSpec>? content,
    WidgetSpec<BoxSpec>? header,
    WidgetSpec<LabelSpec>? headerLabel,
  })  : container = container ?? const WidgetSpec(spec: BoxSpec()),
        content = content ?? const WidgetSpec(spec: BoxSpec()),
        header = header ?? const WidgetSpec(spec: BoxSpec()),
        headerLabel = headerLabel ?? const WidgetSpec(spec: LabelSpec());

  AccordionSpec copyWith({
    WidgetSpec<BoxSpec>? container,
    WidgetSpec<BoxSpec>? content,
    WidgetSpec<BoxSpec>? header,
    WidgetSpec<LabelSpec>? headerLabel,
  }) {
    return AccordionSpec(
      container: container ?? this.container,
      content: content ?? this.content,
      header: header ?? this.header,
      headerLabel: headerLabel ?? this.headerLabel,
    );
  }

  AccordionSpec lerp(AccordionSpec? other, double t) {
    if (other == null) return this;

    return AccordionSpec(
      container: MixOps.lerp(container, other.container, t)!,
      content: MixOps.lerp(content, other.content, t)!,
      header: MixOps.lerp(header, other.header, t)!,
      headerLabel: MixOps.lerp(headerLabel, other.headerLabel, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('content', content))
      ..add(DiagnosticsProperty('header', header))
      ..add(DiagnosticsProperty('headerLabel', headerLabel));
  }

  @override
  List<Object?> get props => [container, content, header, headerLabel];
}
