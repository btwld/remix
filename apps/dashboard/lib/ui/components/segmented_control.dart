import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'segmented_control.g.dart';

/// The sizes a segmented control comes in. Pixel values are at 100% theme
/// scaling.
enum UiSegmentedControlSize {
  /// 24px tall, with 12px text and 12px icons.
  size1,

  /// 32px tall, with 14px text and 16px icons. The default.
  size2,

  /// 40px tall, with 16px text and 20px icons.
  size3,
}

/// The looks a segmented control comes in.
enum UiSegmentedControlVariant {
  /// A gray track with a raised surface under the selected item.
  surface,
}

/// The Ui SegmentedControl recipe.
///
/// The track is a gray tint blended over the surface. The selected item sits
/// on a raised fill with a 1px edge, and turns medium weight.
///
/// Content icons use the size's 12, 16 or 20px default rather than the ambient
/// icon size. Control and item styles may override these defaults.
@MixWidget(target: RemixSegmentedControl.new)
SegmentedControlStyler uiSegmentedControlStyle({
  UiSegmentedControlVariant variant = .surface,
  UiSegmentedControlSize size = .size2,
  SegmentedControlStyler style = const SegmentedControlStyler.create(),
}) {
  final metrics = _metrics(size);
  final item = _item(variant, metrics);

  return SegmentedControlStyler()
      .mainAxisSize(.min)
      .minHeight(metrics.height)
      .borderRadius(.all(metrics.radius))
      .color(_segmentedControlTrackBackground())
      .item(item)
      .onDisabled(.color(_segmentedControlDisabledTrackBackground()))
      .merge(style);
}

SegmentedControlItemStyler _item(
  UiSegmentedControlVariant variant,
  _Metrics metrics,
) {
  final base = SegmentedControlItemStyler()
      .wrap(uiTouchTarget())
      .minHeight(metrics.height)
      .padding(.horizontal(metrics.paddingX))
      .spacing(metrics.itemGap)
      .label(
        TextStyler()
            .style(metrics.text.mix())
            .color(UiTokens.gray12())
            .fontWeight(UiTokens.fontWeightRegular())
            .letterSpacing(0)
            .wordSpacing(0)
            .maxLines(1)
            .overflow(TextOverflow.ellipsis),
      )
      .icon(IconStyler().color(UiTokens.gray12()).size(metrics.iconSize))
      .containerEffects(
        RemixBoxEffectsMix(
          behindContent: RemixBoxEffectLayerMix(),
          overContent: RemixBoxEffectLayerMix(),
        ),
      );
  final selected = _selectedItem(variant, metrics);
  final disabled = SegmentedControlItemStyler()
      .containerEffects(
        RemixBoxEffectsMix(outline: BorderSideMix(style: .none)),
      )
      .label(TextStyler().color(UiTokens.grayA8()))
      .icon(IconStyler().color(UiTokens.grayA8()));
  final disabledSelected = disabled
      .color(const Color(0x00000000))
      .borderRadius(.all(metrics.radius))
      .containerEffects(
        RemixBoxEffectsMix(
          behindContent: _fill(UiTokens.grayA3()),
          overContent: RemixBoxEffectLayerMix(shadows: const []),
        ),
      );

  return base
      .onHovered(.color(UiTokens.grayA2()))
      .onSelected(
        selected
            .onHovered(.color(const Color(0x00000000)))
            .onDisabled(disabledSelected),
      )
      .onFocusVisible(
        SegmentedControlItemStyler()
            .borderRadius(.all(metrics.radius))
            .containerEffects(uiFocusOutline()),
      )
      .onDisabled(disabled.onSelected(disabledSelected));
}

SegmentedControlItemStyler _selectedItem(
  UiSegmentedControlVariant variant,
  _Metrics metrics,
) {
  final overContent = switch (variant) {
    .surface => RemixBoxEffectLayerMix(
      shadows: [
        RemixBoxShadowMix(
          color: UiTokens.grayA4(),
          spreadRadius: UiTokens.borderWidth1(),
          shapeInset: 1,
        ),
      ],
    ),
  };

  return SegmentedControlItemStyler()
      .color(const Color(0x00000000))
      .borderRadius(.all(metrics.radius))
      .label(
        TextStyler()
            .fontWeight(UiTokens.fontWeightMedium())
            .letterSpacing(metrics.activeLetterSpacing)
            .wordSpacing(0),
      )
      .containerEffects(
        RemixBoxEffectsMix(
          behindContent: _fill(
            UiTokens.segmentedControlIndicatorBackground(),
            inset: 1,
          ),
          overContent: overContent,
        ),
      );
}

RemixBoxEffectLayerMix _fill(Color color, {double? inset}) =>
    RemixBoxEffectLayerMix(
      gradients: [
        RemixLinearGradientMix(colors: [color, color]),
      ],
      gradientInsets: inset == null ? const [] : [inset],
    );

class _Metrics {
  const _Metrics({
    required this.height,
    required this.paddingX,
    required this.itemGap,
    required this.radius,
    required this.text,
    required this.activeLetterSpacing,
    required this.iconSize,
  });

  final double height;
  final double paddingX;
  final double itemGap;
  final Radius radius;
  final TextStyleToken text;
  final double activeLetterSpacing;
  final double iconSize;
}

_Metrics _metrics(UiSegmentedControlSize size) => switch (size) {
  .size1 => _Metrics(
    height: UiTokens.space5(),
    paddingX: UiTokens.space3(),
    itemGap: UiTokens.space1(),
    radius: UiTokens.radius2OrFull(),
    text: UiTokens.text1,
    activeLetterSpacing: UiTokens.tabActiveLetterSpacing1(),
    iconSize: UiTokens.space3(),
  ),
  .size2 => _Metrics(
    height: UiTokens.space6(),
    paddingX: UiTokens.space4(),
    itemGap: UiTokens.space2(),
    radius: UiTokens.radius2OrFull(),
    text: UiTokens.text2,
    activeLetterSpacing: UiTokens.tabActiveLetterSpacing2(),
    iconSize: UiTokens.space4(),
  ),
  .size3 => _Metrics(
    height: UiTokens.space7(),
    paddingX: UiTokens.space4(),
    itemGap: UiTokens.space3(),
    radius: UiTokens.radius3OrFull(),
    text: UiTokens.text3,
    activeLetterSpacing: _segmentedControlActiveLetterSpacing3(),
    iconSize: UiTokens.spinnerSize3(),
  ),
};

/// The selected item's label tightens by 1% of the size-3 font size, so the
/// bolder text keeps its width. It follows the resolved text token, so it stays
/// exact at every theme scaling.
final _segmentedControlActiveLetterSpacing3 = ContextToken<double>(
  (context) => -0.01 * UiTokens.text3.resolve(context).fontSize!,
);

/// The track: the gray tint blended over the surface.
final _segmentedControlTrackBackground = ContextToken<Color>(
  (context) => Color.alphaBlend(
    UiTokens.grayA3.resolve(context),
    UiTokens.colorSurface.resolve(context),
  ),
);

/// The disabled track swaps only the base color to gray 3; the gray-alpha-3
/// layer over it persists, so it stays in the blend.
final _segmentedControlDisabledTrackBackground = ContextToken<Color>(
  (context) => Color.alphaBlend(
    UiTokens.grayA3.resolve(context),
    UiTokens.gray3.resolve(context),
  ),
);
