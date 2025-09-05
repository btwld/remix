part of 'list_item.dart';

class ListItemSpec extends Spec<ListItemSpec> with Diagnosticable {
  final StyleSpec<BoxSpec> container;
  final StyleSpec<BoxSpec> contentContainer;
  final StyleSpec<TextSpec> title;
  final StyleSpec<TextSpec> subtitle;
  final StyleSpec<IconSpec> leading;
  final StyleSpec<IconSpec> trailing;

  const ListItemSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? contentContainer,
    StyleSpec<TextSpec>? title,
    StyleSpec<TextSpec>? subtitle,
    StyleSpec<IconSpec>? leading,
    StyleSpec<IconSpec>? trailing,
  })  : container = container ?? const StyleSpec(spec: BoxSpec()),
        contentContainer = contentContainer ?? const StyleSpec(spec: BoxSpec()),
        title = title ?? const StyleSpec(spec: TextSpec()),
        subtitle = subtitle ?? const StyleSpec(spec: TextSpec()),
        leading = leading ?? const StyleSpec(spec: IconSpec()),
        trailing = trailing ?? const StyleSpec(spec: IconSpec());

  ListItemSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? contentContainer,
    StyleSpec<TextSpec>? title,
    StyleSpec<TextSpec>? subtitle,
    StyleSpec<IconSpec>? leading,
    StyleSpec<IconSpec>? trailing,
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

  ListItemSpec lerp(ListItemSpec? other, double t) {
    if (other == null) return this;

    return ListItemSpec(
      container: MixOps.lerp(container, other.container, t)!,
      contentContainer: MixOps.lerp(contentContainer, other.contentContainer, t)!,
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
      ..add(DiagnosticsProperty('contentContainer', contentContainer))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('subtitle', subtitle))
      ..add(DiagnosticsProperty('leading', leading))
      ..add(DiagnosticsProperty('trailing', trailing));
  }

  @override
  List<Object?> get props => [
        container,
        contentContainer,
        title,
        subtitle,
        leading,
        trailing,
      ];
}
