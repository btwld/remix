part of 'toast.dart';

/// Where a [RemixToast] places its action relative to the message.
enum RemixToastActionPlacement {
  /// Beside the message, before the close button, while the message has room.
  ///
  /// A toast too narrow for that row at the current text scale uses the
  /// [below] arrangement instead; a squeezed message is never wanted, so
  /// there is no way to keep the row at that width.
  inline,

  /// Under the title and description, aligned with their start.
  ///
  /// The icon, message, and close button align to the top of the row, so the
  /// close button stays on the first line, after the message.
  below,
}

/// Wraps one toast in its entrance and exit transition; see
/// [ToastSpec.transitionBuilder].
///
/// [animation] runs from zero to one on entrance and back on exit. [placement]
/// says which edge the stack grows from, so the toast can travel from it.
typedef RemixToastTransitionBuilder =
    Widget Function(
      BuildContext context,
      Animation<double> animation,
      RemixToastPlacement placement,
      Widget child,
    );

/// Resolved visual values for a [RemixToast].
///
/// [action] and [closeButton] deliberately hold *unresolved* styles, which the
/// toast hands to the composed [RemixButton] and [RemixIconButton] through
/// Mix's `StyleProvider` inheritance. Those controls own their interaction
/// state, so their styles must resolve against their own hover, focus, and
/// press states rather than the toast's.
@MixableSpec(
  target: RemixToast.new,
  extraStylerMixins: [RemixBoxStylerMixin, IconStyleMixin],
)
class ToastSpec with _$ToastSpec {
  /// Outer row: surface, padding, and the gap between icon, message, and
  /// controls.
  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<FlexBoxSpec> container;

  /// Column holding the title and description.
  @override
  final StyleSpec<FlexBoxSpec> content;

  @override
  final StyleSpec<TextSpec> title;

  @override
  final StyleSpec<TextSpec> description;

  /// The leading decorative icon.
  @override
  final StyleSpec<IconSpec> icon;

  /// A box around [icon], such as a tinted chip. `null`, the default, draws
  /// the bare icon.
  @override
  final StyleSpec<BoxSpec>? iconContainer;

  /// Unresolved style inherited by the composed action button.
  @override
  final Style<ButtonSpec>? action;

  /// Unresolved style inherited by the composed close button.
  @override
  final Style<IconButtonSpec>? closeButton;

  @override
  @MixableField(setterType: RemixBoxEffectsMix)
  final RemixBoxEffectsSpec? containerEffects;

  /// Where the action sits relative to the message.
  ///
  /// Null means [RemixToastActionPlacement.inline], which keeps the action in
  /// the row while the message has room and otherwise uses the
  /// [RemixToastActionPlacement.below] arrangement. Being a spec field, a
  /// variant can switch it, for example `ToastStyler().onBreakpoint(
  /// Breakpoint.maxWidth(768), ToastStyler().actionPlacement(.below))`.
  @override
  final RemixToastActionPlacement? actionPlacement;

  /// How [RemixToastScope] moves each toast in and out.
  ///
  /// `null`, the default, fades the toast while it travels 16 pixels from the
  /// stack's edge. The scope reads this and [animationStyle] from its own
  /// `style`, not from each toast's data style. A standalone [RemixToast]
  /// ignores both.
  @override
  final RemixToastTransitionBuilder? transitionBuilder;

  /// The entrance and exit curves and durations [RemixToastScope] uses.
  ///
  /// Unset fields keep 180 ms in and 120 ms out on [Curves.easeOutCubic].
  @override
  final AnimationStyle? animationStyle;

  const ToastSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<FlexBoxSpec>? content,
    StyleSpec<TextSpec>? title,
    StyleSpec<TextSpec>? description,
    StyleSpec<IconSpec>? icon,
    this.iconContainer,
    this.action,
    this.closeButton,
    this.containerEffects,
    this.actionPlacement,
    this.transitionBuilder,
    this.animationStyle,
  }) : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
       content = content ?? const StyleSpec(spec: FlexBoxSpec()),
       title = title ?? const StyleSpec(spec: TextSpec()),
       description = description ?? const StyleSpec(spec: TextSpec()),
       icon = icon ?? const StyleSpec(spec: IconSpec());

  // Deliberate: route effects through lerpNullable so shadows/blends animate;
  // the generator's default snap-lerps unrecognized spec types.
  @override
  ToastSpec lerp(ToastSpec? other, double t) {
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
