part of 'accordion.dart';

class AccordionSpec extends Spec<AccordionSpec> with Diagnosticable {
  final BoxSpec itemContainer;
  final BoxSpec contentContainer;
  final FlexBoxSpec headerContainer;
  final IconSpec leading;
  final IconSpec trailing;
  final TextSpec titleStyle;
  final TextSpec contentStyle;

  const AccordionSpec({
    BoxSpec? itemContainer,
    BoxSpec? contentContainer,
    FlexBoxSpec? headerContainer,
    IconSpec? leading,
    IconSpec? trailing,
    TextSpec? titleStyle,
    TextSpec? contentStyle,
  })  : itemContainer = itemContainer ?? const BoxSpec(),
        contentContainer = contentContainer ?? const BoxSpec(),
        headerContainer = headerContainer ?? const FlexBoxSpec(),
        leading = leading ?? const IconSpec(),
        trailing = trailing ?? const IconSpec(),
        titleStyle = titleStyle ?? const TextSpec(),
        contentStyle = contentStyle ?? const TextSpec();

  @override
  AccordionSpec copyWith({
    BoxSpec? itemContainer,
    BoxSpec? contentContainer,
    FlexBoxSpec? headerContainer,
    IconSpec? leading,
    IconSpec? trailing,
    TextSpec? titleStyle,
    TextSpec? contentStyle,
  }) {
    return AccordionSpec(
      itemContainer: itemContainer ?? this.itemContainer,
      contentContainer: contentContainer ?? this.contentContainer,
      headerContainer: headerContainer ?? this.headerContainer,
      leading: leading ?? this.leading,
      trailing: trailing ?? this.trailing,
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
      leading: MixOps.lerp(leading, other.leading, t)!,
      trailing: MixOps.lerp(trailing, other.trailing, t)!,
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
      DiagnosticsProperty('leading', leading, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('trailing', trailing, defaultValue: null),
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
        leading,
        trailing,
        titleStyle,
        contentStyle,
      ];
}
