part of 'dialog.dart';

class DialogSpec extends Spec<DialogSpec> with Diagnosticable {
  final StyleSpec<BoxSpec> container;
  final StyleSpec<TextSpec> title;
  final StyleSpec<TextSpec> description;
  final StyleSpec<FlexBoxSpec> actions;
  final StyleSpec<BoxSpec> overlay;

  const DialogSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? title,
    StyleSpec<TextSpec>? description,
    StyleSpec<FlexBoxSpec>? actions,
    StyleSpec<BoxSpec>? overlay,
  })  : container = container ?? const StyleSpec(spec: BoxSpec()),
        title = title ?? const StyleSpec(spec: TextSpec()),
        description = description ?? const StyleSpec(spec: TextSpec()),
        actions = actions ?? const StyleSpec(spec: FlexBoxSpec()),
        overlay = overlay ?? const StyleSpec(spec: BoxSpec());

  DialogSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? title,
    StyleSpec<TextSpec>? description,
    StyleSpec<FlexBoxSpec>? actions,
    StyleSpec<BoxSpec>? overlay,
  }) {
    return DialogSpec(
      container: container ?? this.container,
      title: title ?? this.title,
      description: description ?? this.description,
      actions: actions ?? this.actions,
      overlay: overlay ?? this.overlay,
    );
  }

  DialogSpec lerp(DialogSpec? other, double t) {
    if (other == null) return this;

    return DialogSpec(
      container: MixOps.lerp(container, other.container, t)!,
      title: MixOps.lerp(title, other.title, t)!,
      description: MixOps.lerp(description, other.description, t)!,
      actions: MixOps.lerp(actions, other.actions, t)!,
      overlay: MixOps.lerp(overlay, other.overlay, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('actions', actions))
      ..add(DiagnosticsProperty('overlay', overlay));
  }

  @override
  List<Object?> get props => [container, title, description, actions, overlay];
}