part of 'dialog.dart';

/// Resolved visual properties for a [RemixDialog].
///
/// [closeButton] holds an *unresolved* style, which the dialog hands to its
/// composed [RemixIconButton] through Mix's `StyleProvider` inheritance, so
/// the button resolves it against its own hover, focus, and press states.
@MixableSpec(target: RemixDialog.new, extraStylerMixins: [RemixBoxStylerMixin])
class DialogSpec with _$DialogSpec {
  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<BoxSpec> container;
  @override
  @MixableField(setterType: RemixBoxEffectsMix)
  final RemixBoxEffectsSpec? containerEffects;
  @override
  final StyleSpec<TextSpec> title;
  @override
  final StyleSpec<TextSpec> description;
  @override
  final StyleSpec<FlexBoxSpec> actions;

  /// A row holding the title and description, with the close button at its
  /// end.
  ///
  /// `null`, the default, keeps the single column: title, description, the
  /// custom body, then actions. Setting it, or passing
  /// [RemixDialog.onClose], moves the title and description into this row
  /// and the custom body into [body], so the header can carry its own
  /// padding and divider. The description then stays outside the scroll
  /// region of [RemixDialog.scrollable].
  @override
  final StyleSpec<FlexBoxSpec>? header;

  /// The box around the custom body while the dialog uses [header].
  @override
  final StyleSpec<BoxSpec> body;

  /// Unresolved style inherited by the composed close button.
  @override
  final Style<IconButtonSpec>? closeButton;

  const DialogSpec({
    StyleSpec<BoxSpec>? container,
    this.containerEffects,
    StyleSpec<TextSpec>? title,
    StyleSpec<TextSpec>? description,
    StyleSpec<FlexBoxSpec>? actions,
    this.header,
    StyleSpec<BoxSpec>? body,
    this.closeButton,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       title = title ?? const StyleSpec(spec: TextSpec()),
       description = description ?? const StyleSpec(spec: TextSpec()),
       actions = actions ?? const StyleSpec(spec: FlexBoxSpec()),
       body = body ?? const StyleSpec(spec: BoxSpec());

  // Deliberate: route effects through lerpNullable so shadows/blends animate;
  // the generator's default snap-lerps unrecognized spec types.
  @override
  DialogSpec lerp(DialogSpec? other, double t) {
    final generated = super.lerp(other, t);
    if (other == null) return generated;
    return generated.copyWith(
      containerEffects: RemixBoxEffectsSpec.lerpNullable(
        containerEffects,
        other.containerEffects,
        t,
      ),
    );
  }
}

/// Backward-compatible name for [DialogSpec].
///
/// The generated style API is based on [DialogSpec], so resolved values use
/// `DialogSpec` as their runtime type.
typedef RemixDialogSpec = DialogSpec;
