part of 'list_item.dart';

class ListItemSpec extends Spec<ListItemSpec> with Diagnosticable {
  final WidgetSpec<BoxSpec> container;
  final WidgetSpec<FlexSpec> flex;
  final WidgetSpec<BoxSpec> contentContainer;
  final WidgetSpec<FlexSpec> contentFlex;
  final WidgetSpec<TextSpec> title;
  final WidgetSpec<TextSpec> subtitle;
  final WidgetSpec<IconSpec> leading;
  final WidgetSpec<IconSpec> trailing;

  const ListItemSpec({
    WidgetSpec<BoxSpec>? container,
    WidgetSpec<FlexSpec>? flex,
    WidgetSpec<BoxSpec>? contentContainer,
    WidgetSpec<FlexSpec>? contentFlex,
    WidgetSpec<TextSpec>? title,
    WidgetSpec<TextSpec>? subtitle,
    WidgetSpec<IconSpec>? leading,
    WidgetSpec<IconSpec>? trailing,
  })  : container = container ?? const WidgetSpec(spec: BoxSpec()),
        flex = flex ?? const WidgetSpec(spec: FlexSpec()),
        contentContainer = contentContainer ?? const WidgetSpec(spec: BoxSpec()),
        contentFlex = contentFlex ?? const WidgetSpec(spec: FlexSpec()),
        title = title ?? const WidgetSpec(spec: TextSpec()),
        subtitle = subtitle ?? const WidgetSpec(spec: TextSpec()),
        leading = leading ?? const WidgetSpec(spec: IconSpec()),
        trailing = trailing ?? const WidgetSpec(spec: IconSpec());

  ListItemSpec copyWith({
    WidgetSpec<BoxSpec>? container,
    WidgetSpec<FlexSpec>? flex,
    WidgetSpec<BoxSpec>? contentContainer,
    WidgetSpec<FlexSpec>? contentFlex,
    WidgetSpec<TextSpec>? title,
    WidgetSpec<TextSpec>? subtitle,
    WidgetSpec<IconSpec>? leading,
    WidgetSpec<IconSpec>? trailing,
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
  List<Object?> get props => [
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
