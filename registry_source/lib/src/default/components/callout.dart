import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/scale.dart';
import '../theme/tokens.dart';

part 'callout.g.dart';

/// The tones this application offers for a callout.
///
/// Two, not the usual four. `info`, `success`, and `warning` would each need a
/// color pair this theme does not have, and inventing three would triple the
/// token vocabulary to serve one component. An application that needs them
/// adds the tokens and one more enum value here.
enum VanillaCalloutVariant {
  /// A neutral aside on the `card` surface.
  neutral,

  /// A problem the reader has to act on.
  destructive,
}

/// The application's Callout recipe.
///
/// A callout is a block of text, usually with a leading icon, that says
/// something about the surrounding page. Remix owns the layout and the icon
/// slot; this recipe owns the surface, the outline, and the content colors.
///
/// It is shadcn's alert: the `card` surface inside a `border` hairline with
/// `radiusLg` corners, a 16px by 12px inset, and the icon 12px from `textSm`
/// prose. The icon takes the text's color, so the tone is set in one place.
/// The destructive tone keeps the neutral surface and outline and sets its
/// text in `destructive`, which clears 4.5:1 on `card` in both shipped
/// themes; a solid `destructive` fill would read as a pressed button rather
/// than as a notice.
///
/// There are no interaction fragments. A callout is not a control — anything
/// actionable inside it is a separate button or link with its own recipe.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it. Because [variant] is a non-nullable
/// enum, the generator also emits one named constructor per enum value:
///
/// ```dart
/// VanillaCallout.destructive(
///   icon: warningGlyph,
///   text: 'This deletes the workspace for everyone.',
/// )
/// ```
@MixWidget(target: RemixCallout.new)
CalloutStyler vanillaCalloutStyle({
  VanillaCalloutVariant variant = .neutral,
  CalloutStyler style = const CalloutStyler.create(),
}) => _base().merge(_variantStyle(variant)).merge(style);

/// Optical offset that aligns the icon with the first line's visible glyphs:
/// shadcn's `translate-y-0.5`.
///
/// The row stays top-aligned for multi-line prose. Font line boxes reserve
/// leading around their visible glyphs, so an icon at the line-box origin
/// looks high even though both layout bounds start together.
const _iconOffsetY = VanillaSpace.s0_5;

/// Layout, surface, and typography shared by both tones.
CalloutStyler _base() => CalloutStyler()
    .direction(.horizontal)
    .crossAxisAlignment(.start)
    .padding(.symmetric(horizontal: VanillaSpace.s4, vertical: VanillaSpace.s3))
    .spacing(VanillaSpace.s3)
    .color(VanillaTokens.card())
    .border(.color(VanillaTokens.border()).width(VanillaStroke.hairline))
    .borderRadius(.all(VanillaTokens.radiusLg()))
    .text(.style(VanillaTokens.textSm.mix()))
    .icon(.size(VanillaSize.icon).wrap(.translate(x: 0, y: _iconOffsetY)));

/// The tone: one content color for the sentence and its glyph.
CalloutStyler _variantStyle(VanillaCalloutVariant variant) =>
    _content(switch (variant) {
      .neutral => VanillaTokens.cardForeground(),
      .destructive => VanillaTokens.destructive(),
    });

/// Applies one content color to the text and the icon.
CalloutStyler _content(Color color) =>
    CalloutStyler().text(.color(color)).icon(.color(color));
