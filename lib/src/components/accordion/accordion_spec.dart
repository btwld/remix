part of 'accordion.dart';

class AccordionSpec extends WidgetSpec<AccordionSpec> {
  final ContainerProperties itemContainer;
  final ContainerProperties contentContainer;
  final ContainerProperties headerContainer;
  final FlexProperties headerFlex;
  final IconSpec leading;
  final IconSpec trailing;
  final TextSpec titleStyle;
  final TextSpec contentStyle;

  const AccordionSpec({
    ContainerProperties? itemContainer,
    ContainerProperties? contentContainer,
    ContainerProperties? headerContainer,
    FlexProperties? headerFlex,
    IconSpec? leading,
    IconSpec? trailing,
    TextSpec? titleStyle,
    TextSpec? contentStyle,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  })  : itemContainer = itemContainer ?? const ContainerProperties(),
        contentContainer = contentContainer ?? const ContainerProperties(),
        headerContainer = headerContainer ?? const ContainerProperties(),
        headerFlex = headerFlex ?? const FlexProperties(),
        leading = leading ?? const IconSpec(),
        trailing = trailing ?? const IconSpec(),
        titleStyle = titleStyle ?? const TextSpec(),
        contentStyle = contentStyle ?? const TextSpec(),
        super(animation: animation, widgetModifiers: widgetModifiers, inherit: inherit);

  @override
  AccordionSpec copyWith({
    ContainerProperties? itemContainer,
    ContainerProperties? contentContainer,
    ContainerProperties? headerContainer,
    FlexProperties? headerFlex,
    IconSpec? leading,
    IconSpec? trailing,
    TextSpec? titleStyle,
    TextSpec? contentStyle,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
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
      animation: animation ?? this.animation,
      widgetModifiers: widgetModifiers ?? this.widgetModifiers,
      inherit: inherit ?? this.inherit,
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
      animation: MixOps.lerp(animation, other.animation, t),
      widgetModifiers: MixOps.lerp(widgetModifiers, other.widgetModifiers, t),
      inherit: MixOps.lerp(inherit, other.inherit, t),
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
        ...super.props,
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
