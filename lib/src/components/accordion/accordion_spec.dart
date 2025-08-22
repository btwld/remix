part of 'accordion.dart';

class AccordionSpec extends WidgetSpec<AccordionSpec> {
  final WidgetContainerProperties itemContainer;
  final WidgetContainerProperties contentContainer;
  final WidgetContainerProperties headerContainer;
  final WidgetFlexProperties headerFlex;
  final IconSpec leading;
  final IconSpec trailing;
  final TextSpec titleStyle;
  final TextSpec contentStyle;

  const AccordionSpec({
    WidgetContainerProperties? itemContainer,
    WidgetContainerProperties? contentContainer,
    WidgetContainerProperties? headerContainer,
    WidgetFlexProperties? headerFlex,
    IconSpec? leading,
    IconSpec? trailing,
    TextSpec? titleStyle,
    TextSpec? contentStyle,
  })  : itemContainer = itemContainer ?? const WidgetContainerProperties(),
        contentContainer = contentContainer ?? const WidgetContainerProperties(),
        headerContainer = headerContainer ?? const WidgetContainerProperties(),
        headerFlex = headerFlex ?? const WidgetFlexProperties(),
        leading = leading ?? const IconSpec(),
        trailing = trailing ?? const IconSpec(),
        titleStyle = titleStyle ?? const TextSpec(),
        contentStyle = contentStyle ?? const TextSpec();

  @override
  AccordionSpec copyWith({
    WidgetContainerProperties? itemContainer,
    WidgetContainerProperties? contentContainer,
    WidgetContainerProperties? headerContainer,
    WidgetFlexProperties? headerFlex,
    IconSpec? leading,
    IconSpec? trailing,
    TextSpec? titleStyle,
    TextSpec? contentStyle,
  }) {
    return AccordionSpec(
      itemContainer: itemContainer ?? this.itemContainer,
      contentContainer: contentContainer ?? this.contentContainer,
      headerContainer: headerContainer ?? this.headerContainer,
      headerFlex: headerFlex ?? this.headerFlex,
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
      headerFlex: MixOps.lerp(headerFlex, other.headerFlex, t)!,
      leading: MixOps.lerp(leading, other.leading, t)!,
      trailing: MixOps.lerp(trailing, other.trailing, t)!,
      titleStyle: MixOps.lerp(titleStyle, other.titleStyle, t)!,
      contentStyle: MixOps.lerp(contentStyle, other.contentStyle, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('itemContainer', itemContainer))
      ..add(DiagnosticsProperty('contentContainer', contentContainer))
      ..add(DiagnosticsProperty('headerContainer', headerContainer))
      ..add(DiagnosticsProperty('headerFlex', headerFlex))
      ..add(DiagnosticsProperty('leading', leading))
      ..add(DiagnosticsProperty('trailing', trailing))
      ..add(DiagnosticsProperty('titleStyle', titleStyle))
      ..add(DiagnosticsProperty('contentStyle', contentStyle));
  }

  @override
  List<Object?> get props => [
        itemContainer,
        contentContainer,
        headerContainer,
        headerFlex,
        leading,
        trailing,
        titleStyle,
        contentStyle,
      ];
}
