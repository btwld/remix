part of 'list_item.dart';

class ListItemSpec extends WidgetSpec<ListItemSpec> {
  final ContainerSpec container;
  final FlexProperties flex;
  final ContainerSpec contentContainer;
  final FlexProperties contentFlex;
  final TextSpec title;
  final TextSpec subtitle;
  final IconSpec leading;
  final IconSpec trailing;

  const ListItemSpec({
    ContainerSpec? container,
    FlexProperties? flex,
    ContainerSpec? contentContainer,
    FlexProperties? contentFlex,
    TextSpec? title,
    TextSpec? subtitle,
    IconSpec? leading,
    IconSpec? trailing,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  })  : container = container ?? const ContainerSpec(),
        flex = flex ?? const FlexProperties(),
        contentContainer = contentContainer ?? const ContainerSpec(),
        contentFlex = contentFlex ?? const FlexProperties(),
        title = title ?? const TextSpec(),
        subtitle = subtitle ?? const TextSpec(),
        leading = leading ?? const IconSpec(),
        trailing = trailing ?? const IconSpec(),
        super(animation: animation, widgetModifiers: widgetModifiers, inherit: inherit);

  @override
  ListItemSpec copyWith({
    ContainerSpec? container,
    FlexProperties? flex,
    ContainerSpec? contentContainer,
    FlexProperties? contentFlex,
    TextSpec? title,
    TextSpec? subtitle,
    IconSpec? leading,
    IconSpec? trailing,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  }) {
    return ListItemSpec(
      container: container ?? this.container,
      flex: flex ?? this.flex,
      contentContainer: contentContainer ?? this.contentContainer,
      contentFlex: contentFlex ?? this.contentFlex,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      leading: leading ?? this.leading,
      trailing: trailing ?? this.trailing,
      animation: animation ?? this.animation,
      widgetModifiers: widgetModifiers ?? this.widgetModifiers,
      inherit: inherit ?? this.inherit,
    );
  }

  @override
  ListItemSpec lerp(ListItemSpec? other, double t) {
    if (other == null) return this;

    return ListItemSpec(
      container: MixOps.lerp(container, other.container, t)!,
      flex: MixOps.lerp(flex, other.flex, t)!,
      contentContainer:
          MixOps.lerp(contentContainer, other.contentContainer, t)!,
      contentFlex: MixOps.lerp(contentFlex, other.contentFlex, t)!,
      title: MixOps.lerp(title, other.title, t)!,
      subtitle: MixOps.lerp(subtitle, other.subtitle, t)!,
      leading: MixOps.lerp(leading, other.leading, t)!,
      trailing: MixOps.lerp(trailing, other.trailing, t)!,
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
      ..add(DiagnosticsProperty('flex', flex))
      ..add(DiagnosticsProperty('contentContainer', contentContainer))
      ..add(DiagnosticsProperty('contentFlex', contentFlex))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('subtitle', subtitle))
      ..add(DiagnosticsProperty('leading', leading))
      ..add(DiagnosticsProperty('trailing', trailing));
  }

  @override
  List<Object?> get props => [
        ...super.props,
        container,
        flex,
        contentContainer,
        contentFlex,
        title,
        subtitle,
        leading,
        trailing,
      ];
}
