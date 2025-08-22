part of 'list_item.dart';

class ListItemSpec extends WidgetSpec<ListItemSpec> {
  final WidgetContainerProperties container;
  final WidgetFlexProperties flex;
  final WidgetContainerProperties contentContainer;
  final WidgetFlexProperties contentFlex;
  final TextSpec title;
  final TextSpec subtitle;
  final IconSpec leading;
  final IconSpec trailing;

  const ListItemSpec({
    WidgetContainerProperties? container,
    WidgetFlexProperties? flex,
    WidgetContainerProperties? contentContainer,
    WidgetFlexProperties? contentFlex,
    TextSpec? title,
    TextSpec? subtitle,
    IconSpec? leading,
    IconSpec? trailing,
  })  : container = container ?? const WidgetContainerProperties(),
        flex = flex ?? const WidgetFlexProperties(),
        contentContainer = contentContainer ?? const WidgetContainerProperties(),
        contentFlex = contentFlex ?? const WidgetFlexProperties(),
        title = title ?? const TextSpec(),
        subtitle = subtitle ?? const TextSpec(),
        leading = leading ?? const IconSpec(),
        trailing = trailing ?? const IconSpec();

  @override
  ListItemSpec copyWith({
    WidgetContainerProperties? container,
    WidgetFlexProperties? flex,
    WidgetContainerProperties? contentContainer,
    WidgetFlexProperties? contentFlex,
    TextSpec? title,
    TextSpec? subtitle,
    IconSpec? leading,
    IconSpec? trailing,
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
  List<Object?> get props =>
      [container, flex, contentContainer, contentFlex, title, subtitle, leading, trailing];
}
