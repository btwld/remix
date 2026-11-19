import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'badge.g.dart';

/// Deui recipe for [RemixBadge]: a pill with a quiet border and a 12px label.
///
/// [DeuiColor.defaultColor] is the plain badge, muted text in a hairline
/// border. Any other colour tints the fill to 10% and the border to 25% and
/// colours the label, as deui's status badges do. [style] merges last.
@MixWidget(target: RemixBadge.new)
BadgeStyler deuiBadgeStyle({
  DeuiColor color = .defaultColor,
  BadgeStyler style = const BadgeStyler.create(),
}) {
  final tone = _tone(color);
  return BadgeStyler()
      .padding(.symmetric(horizontal: _paddingX, vertical: _paddingY))
      .borderRadius(.circular(_pill))
      .color(tone.fill)
      .border(.color(tone.edge).width(1))
      .label(
        .style(DeuiTokens.textXs.mix())
            .fontWeight(.w500)
            .color(tone.label)
            .softWrap(false)
            .maxLines(1)
            .overflow(TextOverflow.ellipsis),
      )
      .merge(style);
}

typedef _Tone = ({Color fill, Color edge, Color label});

_Tone _tone(DeuiColor color) => switch (color) {
  .defaultColor => (
    fill: DeuiTokens.transparent,
    edge: DeuiTokens.border(),
    label: DeuiTokens.muted(),
  ),
  .accent => (
    fill: _accentFill(),
    edge: _accentEdge(),
    label: DeuiTokens.accent(),
  ),
  .success => (
    fill: _successFill(),
    edge: _successEdge(),
    label: DeuiTokens.success(),
  ),
  .warning => (
    fill: _warningFill(),
    edge: _warningEdge(),
    label: DeuiTokens.warning(),
  ),
  .danger => (
    fill: _dangerFill(),
    edge: _dangerEdge(),
    label: DeuiTokens.danger(),
  ),
};

final _accentFill = deuiAlpha(DeuiTokens.accent, .10);
final _accentEdge = deuiAlpha(DeuiTokens.accent, .25);
final _successFill = deuiAlpha(DeuiTokens.success, .10);
final _successEdge = deuiAlpha(DeuiTokens.success, .25);
final _warningFill = deuiAlpha(DeuiTokens.warning, .10);
final _warningEdge = deuiAlpha(DeuiTokens.warning, .25);
final _dangerFill = deuiAlpha(DeuiTokens.danger, .10);
final _dangerEdge = deuiAlpha(DeuiTokens.danger, .25);

const _paddingX = 8.0;
const _paddingY = 2.0;
const _pill = 999.0;
