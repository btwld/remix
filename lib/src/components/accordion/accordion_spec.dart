part of 'accordion.dart';

class AccordionSpec extends Spec<AccordionSpec> with Diagnosticable {
  final BoxSpec itemContainer;
  final BoxSpec contentContainer;
  final FlexBoxSpec headerContainer;
  final IconSpec leadingIcon;
  final IconSpec trailingIcon;
  final TextSpec titleStyle;
  final TextSpec contentStyle;

  const AccordionSpec({
    BoxSpec? itemContainer,
    BoxSpec? contentContainer,
    FlexBoxSpec? headerContainer,
    IconSpec? leadingIcon,
    IconSpec? trailingIcon,
    TextSpec? titleStyle,
    TextSpec? contentStyle,
  })  : itemContainer = itemContainer ?? const BoxSpec(),
        contentContainer = contentContainer ?? const BoxSpec(),
        headerContainer = headerContainer ?? const FlexBoxSpec(),
        leadingIcon = leadingIcon ?? const IconSpec(),
        trailingIcon = trailingIcon ?? const IconSpec(),
        titleStyle = titleStyle ?? const TextSpec(),
        contentStyle = contentStyle ?? const TextSpec();

  @override
  AccordionSpec copyWith({
    BoxSpec? itemContainer,
    BoxSpec? contentContainer,
    FlexBoxSpec? headerContainer,
    IconSpec? leadingIcon,
    IconSpec? trailingIcon,
    TextSpec? titleStyle,
    TextSpec? contentStyle,
  }) {
    return AccordionSpec(
      itemContainer: itemContainer ?? this.itemContainer,
      contentContainer: contentContainer ?? this.contentContainer,
      headerContainer: headerContainer ?? this.headerContainer,
      leadingIcon: leadingIcon ?? this.leadingIcon,
      trailingIcon: trailingIcon ?? this.trailingIcon,
      titleStyle: titleStyle ?? this.titleStyle,
      contentStyle: contentStyle ?? this.contentStyle,
    );
  }

  @override
  AccordionSpec lerp(AccordionSpec? other, double t) {
    if (other == null) return this;

    return AccordionSpec(
      itemContainer: MixOps.lerp(itemContainer, other.itemContainer, t)!,
      contentContainer:
          MixOps.lerp(contentContainer, other.contentContainer, t)!,
      headerContainer: MixOps.lerp(headerContainer, other.headerContainer, t)!,
      leadingIcon: MixOps.lerp(leadingIcon, other.leadingIcon, t)!,
      trailingIcon: MixOps.lerp(trailingIcon, other.trailingIcon, t)!,
      titleStyle: MixOps.lerp(titleStyle, other.titleStyle, t)!,
      contentStyle: MixOps.lerp(contentStyle, other.contentStyle, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty(
      'itemContainer',
      itemContainer,
      defaultValue: null,
    ));
    properties.add(DiagnosticsProperty(
      'contentContainer',
      contentContainer,
      defaultValue: null,
    ));
    properties.add(DiagnosticsProperty(
      'headerContainer',
      headerContainer,
      defaultValue: null,
    ));
    properties.add(
      DiagnosticsProperty('leadingIcon', leadingIcon, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('trailingIcon', trailingIcon, defaultValue: null),
    );
    properties
        .add(DiagnosticsProperty('titleStyle', titleStyle, defaultValue: null));
    properties.add(
      DiagnosticsProperty('contentStyle', contentStyle, defaultValue: null),
    );
  }

  @override
  List<Object?> get props => [
        itemContainer,
        contentContainer,
        headerContainer,
        leadingIcon,
        trailingIcon,
        titleStyle,
        contentStyle,
      ];
}
