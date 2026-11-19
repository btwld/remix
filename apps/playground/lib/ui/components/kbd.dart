import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';

part 'kbd.g.dart';

/// Where a key cap sits, which decides its colors.
enum PlaygroundKbdVariant {
  /// On the page, a card, or a popover: a `muted` cap under `mutedForeground`
  /// text.
  muted,

  /// Inside a tooltip's content, which inverts the page: `background` at 20%
  /// (10% in the dark theme) under `background` text.
  tooltip,
}

/// The application's Kbd recipe: one keyboard key drawn as a key cap.
///
/// `textXs` at medium weight on a `radiusSm` cap at least 20px square, with
/// 4px beside the label. The cap is the 16px line plus 2px above and below,
/// so it grows with the text scale instead of clipping it. Put the keys of
/// one shortcut in a [PlaygroundKbdGroup].
///
/// Assistive technology reads the key as the text it shows. Name a symbol
/// key through [style]:
///
/// ```dart
/// PlaygroundKbd('⌘', style: TextStyler().semanticsLabel('Command'))
/// ```
@MixWidget()
TextStyler playgroundKbdStyle({
  PlaygroundKbdVariant variant = .muted,
  TextStyler style = const TextStyler.create(),
}) {
  final (:fill, :foreground) = switch (variant) {
    .muted => (
      fill: PlaygroundTokens.muted(),
      foreground: PlaygroundTokens.mutedForeground(),
    ),
    .tooltip => (
      fill: playgroundTint(PlaygroundTokens.background, 0.2, dark: 0.1)(),
      foreground: PlaygroundTokens.background(),
    ),
  };

  return TextStyler()
      .style(PlaygroundTokens.textXs.mix())
      .fontWeight(FontWeight.w500)
      .color(foreground)
      // Centers a one-character key inside the 20px minimum width.
      .textAlign(.center)
      .wrap(
        .box(
          BoxStyler()
              .minWidth(PlaygroundTokens.s5)
              .padding(
                .symmetric(
                  horizontal: PlaygroundTokens.s1,
                  vertical: PlaygroundTokens.s0_5,
                ),
              )
              .borderRadius(.all(PlaygroundTokens.radiusSm()))
              .color(fill),
        ),
      )
      .merge(style);
}

/// The keys of one shortcut, such as Ctrl and B, 4px apart.
///
/// Assistive technology reads the group as one phrase rather than one key at
/// a time. Text between the keys, such as a `+`, is a child like the keys.
///
/// ```dart
/// PlaygroundKbdGroup(children: [PlaygroundKbd('Ctrl'), PlaygroundKbd('B')])
/// ```
class PlaygroundKbdGroup extends StatelessWidget {
  const PlaygroundKbdGroup({super.key, required this.children});

  /// The keys, and any text between them, in reading order.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => MergeSemantics(
    child: RowBox(
      style: FlexBoxStyler()
          .mainAxisSize(.min)
          .crossAxisAlignment(.center)
          .spacing(PlaygroundTokens.s1),
      children: children,
    ),
  );
}
