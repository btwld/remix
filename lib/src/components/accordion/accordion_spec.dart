part of 'accordion.dart';

class AccordionSpec extends WidgetSpec<AccordionSpec> {
  final ContainerSpec container;
  final ContainerSpec content;
  final FlexContainerSpec header;
  final LabelSpec headerLabel;

  AccordionSpec({
    ContainerSpec? container,
    ContainerSpec? content,
    FlexContainerSpec? header,
    LabelSpec? headerLabel,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  })  : container = container ?? const ContainerSpec(),
        content = content ?? const ContainerSpec(),
        header = header ?? const FlexContainerSpec(),
        headerLabel = headerLabel ?? LabelSpec(),
        super(animation: animation, widgetModifiers: widgetModifiers, inherit: inherit);

  @override
  AccordionSpec copyWith({
    ContainerSpec? container,
    ContainerSpec? content,
    FlexContainerSpec? header,
    LabelSpec? headerLabel,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  }) {
    return AccordionSpec(
      container: container ?? this.container,
      content: content ?? this.content,
      header: header ?? this.header,
      headerLabel: headerLabel ?? this.headerLabel,
      animation: animation ?? this.animation,
      widgetModifiers: widgetModifiers ?? this.widgetModifiers,
      inherit: inherit ?? this.inherit,
    );
  }

  @override
  AccordionSpec lerp(AccordionSpec? other, double t) {
    if (other == null) return this;

    return AccordionSpec(
      container: MixOps.lerp(container, other.container, t)!,
      content:
          MixOps.lerp(content, other.content, t)!,
      header: MixOps.lerp(header, other.header, t)!,
      headerLabel: MixOps.lerp(headerLabel, other.headerLabel, t)!,
      animation: MixOps.lerp(animation, other.animation, t),
      widgetModifiers: MixOps.lerp(widgetModifiers, other.widgetModifiers, t),
      inherit: MixOps.lerp(inherit, other.inherit, t),
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
  List<Object?> get props => [
        ...super.props,
        container,
        content,
        header,
        headerLabel,
      ];
}
