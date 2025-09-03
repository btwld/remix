part of 'accordion.dart';

class AccordionSpec extends Spec<AccordionSpec> with Diagnosticable {
  final StyleSpec<BoxSpec> container;
  final StyleSpec<BoxSpec> content;
  final StyleSpec<TextSpec> contentText;
  final StyleSpec<BoxSpec> header;
  final StyleSpec<LabelSpec> headerLabel;

  AccordionSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? content,
    StyleSpec<TextSpec>? contentText,
    StyleSpec<BoxSpec>? header,
    StyleSpec<LabelSpec>? headerLabel,
  })  : container = container ?? const StyleSpec(spec: BoxSpec()),
        content = content ?? const StyleSpec(spec: BoxSpec()),
        contentText = contentText ?? const StyleSpec(spec: TextSpec()),
        header = header ?? const StyleSpec(spec: BoxSpec()),
        headerLabel = headerLabel ?? const StyleSpec(spec: LabelSpec());

  AccordionSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? content,
    StyleSpec<TextSpec>? contentText,
    StyleSpec<BoxSpec>? header,
    StyleSpec<LabelSpec>? headerLabel,
  }) {
    return AccordionSpec(
      container: container ?? this.container,
      content: content ?? this.content,
      contentText: contentText ?? this.contentText,
      header: header ?? this.header,
      headerLabel: headerLabel ?? this.headerLabel,
    );
  }

  AccordionSpec lerp(AccordionSpec? other, double t) {
    if (other == null) return this;

    return AccordionSpec(
      container: MixOps.lerp(container, other.container, t)!,
      content: MixOps.lerp(content, other.content, t)!,
      contentText: MixOps.lerp(contentText, other.contentText, t)!,
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
      ..add(DiagnosticsProperty('contentText', contentText))
      ..add(DiagnosticsProperty('header', header))
      ..add(DiagnosticsProperty('headerLabel', headerLabel));
  }

  @override
  List<Object?> get props => [container, content, contentText, header, headerLabel];
}
