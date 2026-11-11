import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

/// HeroUI keyboard-key variants: the `default` fill, or `light` without one.
enum UiKbdVariant { defaultKbd, light }

/// HeroUI's `Kbd`: a shortcut drawn as a row of [keys], such as `['⌘', 'K']`.
class UiKbd extends StatelessWidget {
  const UiKbd({
    super.key,
    required this.keys,
    this.variant = .defaultKbd,
    this.style = const FlexBoxStyler.create(),
  });

  final List<String> keys;
  final UiKbdVariant variant;
  final FlexBoxStyler style;

  @override
  Widget build(BuildContext context) => RowBox(
    style: FlexBoxStyler()
        .height(_height)
        .padding(.horizontal(_paddingX))
        .spacing(_keyGap)
        .mainAxisSize(.min)
        .crossAxisAlignment(.center)
        .borderRadius(.all(UiTokens.radiusLg()))
        .color(
          variant == .light ? UiTokens.transparent : UiTokens.defaultColor(),
        )
        .merge(style),
    children: [for (final key in keys) StyledText(key, style: _text)],
  );
}

/// `text-sm font-medium text-muted`, with `word-spacing: -0.25rem`.
final _text = TextStyler()
    .style(UiTokens.textSm.mix())
    .fontWeight(.w500)
    .color(UiTokens.muted())
    .textAlign(TextAlign.center)
    .wordSpacing(-4);

/// `h-6 px-2`, and `space-x-0.5` between keys.
const _height = 24.0;
const _paddingX = 8.0;
const _keyGap = 2.0;
