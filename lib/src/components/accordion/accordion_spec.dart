part of 'accordion.dart';

class AccordionSpec extends Spec<AccordionSpec> with Diagnosticable {
  final StyleSpec<BoxSpec> container;
  final StyleSpec<BoxSpec> content;
  final StyleSpec<BoxSpec> header;
  final StyleSpec<LabelSpec> headerLabel;

  AccordionSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? content,
    StyleSpec<BoxSpec>? header,
    StyleSpec<LabelSpec>? headerLabel,
  })  : container = container ?? const StyleSpec(spec: BoxSpec()),
        content = content ?? const StyleSpec(spec: BoxSpec()),
        header = header ?? const StyleSpec(spec: BoxSpec()),
        headerLabel = headerLabel ?? const StyleSpec(spec: LabelSpec());

  AccordionSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? content,
    StyleSpec<BoxSpec>? header,
    StyleSpec<LabelSpec>? headerLabel,
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
