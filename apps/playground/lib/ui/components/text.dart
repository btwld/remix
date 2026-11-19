import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/tokens.dart';

part 'text.g.dart';

/// The styles of running text, after shadcn/ui's Typography page.
enum PlaygroundTextVariant {
  /// A paragraph: `textBase` on a 28px line, in `foreground`.
  p,

  /// The paragraph that opens a page: `textXl` in `mutedForeground`.
  lead,

  /// Text that stands out without being a heading: `textLg` at semibold
  /// weight, in `foreground`.
  large,

  /// A label: `textSm` at medium weight on a line as tall as the text, in
  /// `foreground`.
  small,

  /// Secondary text: `textSm` in `mutedForeground`.
  muted,

  /// A quotation: `textBase` in italics, 24px in from a 2px `border` rule at
  /// its start.
  blockquote,
}

/// The application's Text recipe.
///
/// Each variant is one of the Typography page's styles. Every variant sets
/// its own size, line, weight and color rather than inheriting them, so it
/// reads the same inside a button, a card, or a Material `Scaffold`. Align,
/// wrap, or truncate it through [style]:
///
/// ```dart
/// PlaygroundText.muted(
///   'Enter your email address.',
///   style: TextStyler().maxLines(1).overflow(.ellipsis),
/// )
/// ```
@MixWidget()
TextStyler playgroundTextStyle({
  PlaygroundTextVariant variant = .p,
  TextStyler style = const TextStyler.create(),
}) => switch (variant) {
  .p => _text(PlaygroundTokens.textBase).height(_paragraphLine()),
  .lead => _text(
    PlaygroundTokens.textXl,
  ).color(PlaygroundTokens.mutedForeground()),
  .large => _text(PlaygroundTokens.textLg).fontWeight(FontWeight.w600),
  .small => _text(
    PlaygroundTokens.textSm,
  ).height(1).fontWeight(FontWeight.w500),
  .muted => _text(
    PlaygroundTokens.textSm,
  ).color(PlaygroundTokens.mutedForeground()),
  .blockquote =>
    _text(PlaygroundTokens.textBase)
        .fontStyle(.italic)
        .wrap(
          .box(
            BoxStyler()
                .border(
                  .start(
                    .color(
                      PlaygroundTokens.border(),
                    ).width(PlaygroundTokens.strokeIndicator),
                  ),
                )
                .padding(.start(PlaygroundTokens.s6)),
          ),
        ),
}.merge(style);

/// [step] at regular weight in `foreground`, which each variant adjusts.
TextStyler _text(TextStyleToken step) => TextStyler()
    .style(step.mix())
    .fontWeight(FontWeight.w400)
    .color(PlaygroundTokens.foreground());

/// `leading-7`: a 28px line at whatever size `textBase` resolves to, where
/// the step's own line is 24px.
///
/// A top-level final because `ContextToken` equality is resolver identity.
final _paragraphLine = ContextToken<double>(
  (context) => 28 / PlaygroundTokens.textBase.resolve(context).fontSize!,
);
