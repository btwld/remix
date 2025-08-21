part of 'list_item.dart';

class ListItemSpec extends Spec<ListItemSpec> with Diagnosticable {
  final FlexBoxSpec container;
  final FlexBoxSpec contentContainer;
  final TextSpec title;
  final TextSpec subtitle;
  final IconSpec leading;
  final IconSpec trailing;

  const ListItemSpec({
    FlexBoxSpec? container,
    FlexBoxSpec? contentContainer,
    TextSpec? title,
    TextSpec? subtitle,
    IconSpec? leading,
    IconSpec? trailing,
  })  : container = container ?? const FlexBoxSpec(),
        contentContainer = contentContainer ?? const FlexBoxSpec(),
        title = title ?? const TextSpec(),
        subtitle = subtitle ?? const TextSpec(),
        leading = leading ?? const IconSpec(),
        trailing = trailing ?? const IconSpec();

  @override
  ListItemSpec copyWith({
    FlexBoxSpec? container,
    FlexBoxSpec? contentContainer,
    TextSpec? title,
    TextSpec? subtitle,
    IconSpec? leading,
    IconSpec? trailing,
  }) {
    return ListItemSpec(
      container: container ?? this.container,
      contentContainer: contentContainer ?? this.contentContainer,
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
      contentContainer:
          MixOps.lerp(contentContainer, other.contentContainer, t)!,
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
        .add(DiagnosticsProperty('container', container, defaultValue: null));
    properties.add(DiagnosticsProperty(
      'contentContainer',
      contentContainer,
      defaultValue: null,
    ));
    properties.add(DiagnosticsProperty('title', title, defaultValue: null));
    properties
        .add(DiagnosticsProperty('subtitle', subtitle, defaultValue: null));
    properties.add(
      DiagnosticsProperty('leading', leading, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('trailing', trailing, defaultValue: null),
    );
  }

  @override
  List<Object?> get props =>
      [container, contentContainer, title, subtitle, leading, trailing];
}
