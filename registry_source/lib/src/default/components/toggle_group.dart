import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/scale.dart';
import '../theme/tokens.dart';

part 'toggle_group.g.dart';

/// The visual weights this application offers for a toggle group.
///
/// The same two the single toggle offers, because a group is a row of them.
enum VanillaToggleGroupVariant {
  /// No fill and no border until an option is hovered or on.
  ghost,

  /// An `input` outline around the whole group, so the set is visible while
  /// off.
  outline,
}

/// The control densities this application offers for a toggle group.
///
/// These are compact, web-oriented defaults. A touch-first application should
/// raise them to meet platform hit-target guidance.
enum VanillaToggleGroupSize {
  /// 32px minimum height.
  small,

  /// 36px minimum height. The default.
  medium,

  /// 40px minimum height.
  large,
}

/// The application's ToggleGroup recipe.
///
/// A toggle group is a set of toggles that share one selection. Remix owns the
/// rendering, the roving focus and arrow-key traversal, the single- or
/// multi-select rules, and the group accessibility semantics; this recipe
/// owns the strip's layout and every option's appearance.
///
/// The group is drawn as one control: the options sit edge to edge with no gap,
/// the strip is rounded and clipped as a whole, and the outline variant draws
/// one outline around the strip rather than one per option. Each option carries
/// the single toggle's states — `muted` under the pointer, `accent` while on.
///
/// One recipe covers both, because `ToggleGroupSpec` carries the option's
/// style as a field: the group's `item` is the default every
/// `RemixToggleGroupItem` resolves against. That is what makes an option in a
/// loop impossible to leave unstyled, and it is why this file has one
/// `@MixWidget` rather than two.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it. Because [variant] is a non-nullable
/// enum, the generator also emits one named constructor per enum value.
@MixWidget(target: RemixToggleGroup.new)
ToggleGroupStyler vanillaToggleGroupStyle({
  VanillaToggleGroupVariant variant = .ghost,
  VanillaToggleGroupSize size = .medium,
  ToggleGroupStyler style = const ToggleGroupStyler.create(),
}) => ToggleGroupStyler()
    .direction(.horizontal)
    .mainAxisSize(.min)
    .spacing(0)
    .borderRadius(.all(VanillaTokens.radiusMd()))
    // The clip is what rounds the first and last options: they are square, and
    // the strip's corners cut them.
    .clipBehavior(Clip.antiAlias)
    .merge(_groupOutline(variant))
    .item(_itemStyle(_heightFor(size), variant))
    .merge(style);

/// A fill that paints nothing, the resting fill of every option.
const _noFill = Color(0x00000000);

/// The option height for one [VanillaToggleGroupSize]: 32, 36, or 40px.
double _heightFor(VanillaToggleGroupSize size) => switch (size) {
  .small => VanillaSize.controlSm,
  .medium => VanillaSize.controlMd,
  .large => VanillaSize.controlLg,
};

/// The outline variant's one outline around the strip.
///
/// No shadow: the strip has no effects layer, and a decoration shadow under its
/// transparent fill shows through as a gray wash.
ToggleGroupStyler _groupOutline(VanillaToggleGroupVariant variant) =>
    switch (variant) {
      .ghost => ToggleGroupStyler(),
      .outline => ToggleGroupStyler().border(
        .color(VanillaTokens.input()).width(VanillaStroke.hairline),
      ),
    };

/// One option: the single toggle's off/hover/on/focus/disabled story, square
/// and with a 12px side inset.
ToggleGroupItemStyler _itemStyle(
  double height,
  VanillaToggleGroupVariant variant,
) {
  return _content(VanillaTokens.foreground())
      .animate(VanillaMotion.standard)
      .color(_noFill)
      .direction(.horizontal)
      .mainAxisSize(.min)
      .mainAxisAlignment(.center)
      .crossAxisAlignment(.center)
      .minHeight(height)
      .padding(.horizontal(VanillaSpace.s3))
      .spacing(VanillaSpace.s2)
      .label(.style(VanillaTokens.textSm.mix()).fontWeight(FontWeight.w500))
      .icon(.size(VanillaSize.icon))
      .onHovered(switch (variant) {
        .ghost => _content(
          VanillaTokens.mutedForeground(),
        ).color(VanillaTokens.muted()),
        .outline => _content(
          VanillaTokens.accentForeground(),
        ).color(VanillaTokens.accent()),
      })
      .onSelected(
        _content(
          VanillaTokens.accentForeground(),
        ).color(VanillaTokens.accent()),
      )
      .onFocusVisible(_focusVisibleStyle())
      .onDisabled(_disabledStyle());
}

/// Applies one content color to the label and the icons.
ToggleGroupItemStyler _content(Color foreground) =>
    ToggleGroupItemStyler().label(.color(foreground)).icon(.color(foreground));

/// The keyboard focus ring: a 3px band of `ring` at half strength.
///
/// A *foreground* decoration, because `ToggleGroupItemSpec` has no
/// `containerEffects` layer to paint an outline into. It is stroked inside
/// the option rather than outside: the strip clips its options, and an
/// outside ring on the first or last option would be cut off at its edge.
ToggleGroupItemStyler _focusVisibleStyle() =>
    ToggleGroupItemStyler().foregroundDecoration(
      vanillaFocusRingDecoration(radius: Radius.zero, inset: true),
    );

/// Declared last so it wins over every other state fragment.
ToggleGroupItemStyler _disabledStyle() => ToggleGroupItemStyler()
    .foregroundDecoration(BoxDecorationMix.border(.style(.none)))
    .wrap(.opacity(VanillaOpacity.disabled));
