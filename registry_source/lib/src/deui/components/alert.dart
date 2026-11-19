import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'alert.g.dart';

/// Deui alert statuses: the title and the icon take the status color.
enum DeuiAlertStatus {
  /// Neutral: the title keeps the `foreground` color.
  defaultStatus,

  /// Informational, in the `accent` tint.
  accent,

  /// A positive outcome, in the `success` tint.
  success,

  /// Something that needs attention, in the `warning` tint.
  warning,

  /// An error or destructive outcome, in the `danger` tint.
  danger,
}

/// Deui recipe for [RemixCallout]: an icon and a title on a surface.
///
/// [RemixCallout] holds one text or one custom child; a title with a
/// description is the app's composition inside `child`.
@MixWidget(target: RemixCallout.new)
CalloutStyler deuiAlertStyle({
  DeuiAlertStatus status = .defaultStatus,
  CalloutStyler style = const CalloutStyler.create(),
}) {
  final tone = switch (status) {
    .defaultStatus => null,
    .accent => DeuiTokens.accent,
    .success => DeuiTokens.success,
    .warning => DeuiTokens.warning,
    .danger => DeuiTokens.danger,
  };
  final fill = switch (status) {
    .defaultStatus => DeuiTokens.surfaceSecondary(),
    .accent => _accentFill(),
    .success => _successFill(),
    .warning => _warningFill(),
    .danger => _dangerFill(),
  };
  final edge = switch (status) {
    .defaultStatus => DeuiTokens.border(),
    .accent => _accentEdge(),
    .success => _successEdge(),
    .warning => _warningEdge(),
    .danger => _dangerEdge(),
  };
  final ink = tone == null ? DeuiTokens.foreground() : tone();

  return CalloutStyler()
      .direction(.horizontal)
      .mainAxisSize(.max)
      .crossAxisAlignment(.start)
      .spacing(_gap)
      .padding(.symmetric(horizontal: _paddingX, vertical: _paddingY))
      .color(fill)
      .border(.color(edge).width(1))
      .borderRadius(.circular(_radius))
      .icon(IconStyler().size(_icon).color(ink))
      .text(
        TextStyler(
          style: DeuiTokens.textSm.mix(),
        ).height(_titleHeight).fontWeight(.w500).color(DeuiTokens.foreground()),
      )
      .merge(style);
}

final _accentFill = deuiAlpha(DeuiTokens.accent, .10);
final _accentEdge = deuiAlpha(DeuiTokens.accent, .25);
final _successFill = deuiAlpha(DeuiTokens.success, .10);
final _successEdge = deuiAlpha(DeuiTokens.success, .25);
final _warningFill = deuiAlpha(DeuiTokens.warning, .10);
final _warningEdge = deuiAlpha(DeuiTokens.warning, .25);
final _dangerFill = deuiAlpha(DeuiTokens.danger, .10);
final _dangerEdge = deuiAlpha(DeuiTokens.danger, .25);

const _gap = 12.0;
const _paddingX = 14.0;
const _paddingY = 10.0;
const _radius = 12.0;
const _icon = 16.0;
const _titleHeight = 20 / 14;
