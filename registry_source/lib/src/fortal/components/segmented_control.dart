import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'segmented_control.g.dart';

/// The sizes a segmented control comes in. Pixel values are at 100% theme
/// scaling; the outer height adds the 3px track padding and the 1px frame on
/// each side.
enum FortalSegmentedControlSize {
  /// 28px segments in a 36px control, with 12px text.
  size1,

  /// 32px segments in a 40px control, with 13px text. The default.
  size2,

  /// 36px segments in a 44px control, with 13px text.
  size3,
}

/// The Fortal SegmentedControl recipe.
///
/// A muted track inside a 1px border holds content-width segments. One raised
/// pill, the surface fill with a border and the resting shadow, glides to the
/// selected segment on the standard ease. Labels are muted until hovered,
/// pressed or selected, and never change weight.
///
/// Content icons use 16px (12px at size 1) rather than the ambient icon size.
/// Control and item styles may override these defaults.
@MixWidget(target: RemixSegmentedControl.new)
SegmentedControlStyler fortalSegmentedControlStyle({
  FortalSegmentedControlSize size = .size2,
  SegmentedControlStyler style = const SegmentedControlStyler.create(),
}) {
  final metrics = _metrics(size);

  return SegmentedControlStyler()
      .mainAxisSize(.min)
      .segmentSizing(.content)
      .padding(.all(_trackPadding))
      .spacing(_segmentGap)
      .color(FortalTokens.gray3())
      .border(BoxBorderMix.all(_border()))
      .borderRadius(.all(metrics.frameRadius))
      .indicator(
        BoxStyler()
            .color(FortalTokens.gray2())
            .border(BoxBorderMix.all(_border()))
            .borderRadius(.all(metrics.segmentRadius))
            .decoration(
              BoxDecorationMix.create(boxShadow: FortalTokens.shadow1.mix()),
            ),
      )
      // Measured against the reference glide: the standard ease over 200ms
      // (0.33, 0.59, 0.76 of the travel at 16, 33 and 50ms), not a spring.
      .indicatorMotion(
        AnimationConfig.curve(
          duration: FortalMotion.standard,
          curve: FortalMotion.easeStandard,
        ),
      )
      .item(_item(metrics))
      .onDisabled(.wrap(.opacity(_disabledOpacity)))
      .merge(style);
}

/// The track's inset around the segments and the gap between them.
const _trackPadding = 3.0;
const _segmentGap = 2.0;

/// How much of a disabled control shows.
const _disabledOpacity = 0.52;

final _motion = AnimationConfig.curve(
  duration: FortalMotion.fast,
  curve: FortalMotion.easeStandard,
);

BorderSideMix _border() => BorderSideMix(
  color: FortalTokens.gray7(),
  width: FortalTokens.borderWidth1(),
);

SegmentedControlItemStyler _item(_Metrics metrics) {
  final active = SegmentedControlItemStyler()
      .label(TextStyler().color(FortalTokens.gray12()))
      .icon(IconStyler().color(FortalTokens.gray12()));

  return SegmentedControlItemStyler()
      .animate(_motion)
      .minHeight(metrics.height)
      .padding(.horizontal(metrics.paddingX))
      .spacing(FortalTokens.space1())
      .borderRadius(.all(metrics.segmentRadius))
      .label(
        TextStyler()
            .style(metrics.text.mix())
            .color(FortalTokens.gray10())
            .fontWeight(FortalTokens.fontWeightMedium())
            .maxLines(1)
            .overflow(TextOverflow.ellipsis),
      )
      .icon(IconStyler().color(FortalTokens.gray10()).size(metrics.iconSize))
      .onHovered(active)
      .onPressed(active)
      .onSelected(active)
      .onFocusVisible(.containerEffects(fortalFocusOutline()))
      .onDisabled(
        SegmentedControlItemStyler().containerEffects(
          RemixBoxEffectsMix(outline: BorderSideMix(style: .none)),
        ),
      );
}

class _Metrics {
  const _Metrics({
    required this.height,
    required this.paddingX,
    required this.frameRadius,
    required this.segmentRadius,
    required this.text,
    required this.iconSize,
  });

  final double height;
  final double paddingX;
  final Radius frameRadius;
  final Radius segmentRadius;
  final TextStyleToken text;
  final double iconSize;
}

_Metrics _metrics(FortalSegmentedControlSize size) => switch (size) {
  .size1 => _Metrics(
    height: _segmentHeight1(),
    paddingX: _segmentPadding1(),
    frameRadius: FortalTokens.radius4OrFull(),
    segmentRadius: FortalTokens.radius2OrFull(),
    text: FortalTokens.text1,
    iconSize: FortalTokens.space3(),
  ),
  .size2 => _Metrics(
    height: FortalTokens.controlHeight1(),
    paddingX: FortalTokens.space3(),
    frameRadius: FortalTokens.radius4OrFull(),
    segmentRadius: FortalTokens.radius2OrFull(),
    text: FortalTokens.text2,
    iconSize: FortalTokens.space4(),
  ),
  .size3 => _Metrics(
    height: _segmentHeight3(),
    paddingX: _segmentPadding3(),
    frameRadius: FortalTokens.radius5OrFull(),
    segmentRadius: FortalTokens.radius3OrFull(),
    text: FortalTokens.text2,
    iconSize: FortalTokens.space4(),
  ),
};

// Off-scale steps one 4px space either side of the default segment.
final _segmentHeight1 = ContextToken<double>(
  (context) =>
      FortalTokens.controlHeight1.resolve(context) -
      FortalTokens.space1.resolve(context),
);
final _segmentHeight3 = ContextToken<double>(
  (context) =>
      FortalTokens.controlHeight1.resolve(context) +
      FortalTokens.space1.resolve(context),
);
final _segmentPadding1 = ContextToken<double>(
  (context) =>
      FortalTokens.space3.resolve(context) -
      FortalTokens.space1.resolve(context) / 2,
);
final _segmentPadding3 = ContextToken<double>(
  (context) =>
      FortalTokens.space3.resolve(context) +
      FortalTokens.space1.resolve(context) / 2,
);
