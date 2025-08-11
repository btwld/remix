part of 'list_item.dart';

class ListItemSpec extends Spec<ListItemSpec> with Diagnosticable {
  final BoxSpec container;
  final BoxSpec contentContainer;
  final TextSpec title;
  final TextSpec subtitle;
  final IconSpec leadingIcon;
  final IconSpec trailingIcon;

  const ListItemSpec({
    BoxSpec? container,
    BoxSpec? contentContainer,
    TextSpec? title,
    TextSpec? subtitle,
    IconSpec? leadingIcon,
    IconSpec? trailingIcon,
  })  : container = container ?? const BoxSpec(),
        contentContainer = contentContainer ?? const BoxSpec(),
        title = title ?? const TextSpec(),
        subtitle = subtitle ?? const TextSpec(),
        leadingIcon = leadingIcon ?? const IconSpec(),
        trailingIcon = trailingIcon ?? const IconSpec();

  @override
  ListItemSpec copyWith({
    BoxSpec? container,
    BoxSpec? contentContainer,
    TextSpec? title,
    TextSpec? subtitle,
    IconSpec? leadingIcon,
    IconSpec? trailingIcon,
  }) {
    return ListItemSpec(
      container: container ?? this.container,
      contentContainer: contentContainer ?? this.contentContainer,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      leadingIcon: leadingIcon ?? this.leadingIcon,
      trailingIcon: trailingIcon ?? this.trailingIcon,
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
      leadingIcon: MixOps.lerp(leadingIcon, other.leadingIcon, t)!,
      trailingIcon: MixOps.lerp(trailingIcon, other.trailingIcon, t)!,
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
      DiagnosticsProperty('leadingIcon', leadingIcon, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('trailingIcon', trailingIcon, defaultValue: null),
    );
  }

  @override
  List<Object?> get props =>
      [container, contentContainer, title, subtitle, leadingIcon, trailingIcon];
}
