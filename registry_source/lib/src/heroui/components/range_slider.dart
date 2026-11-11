import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import 'slider.dart';

part 'range_slider.g.dart';

/// Two-bound interval sharing [heroUiSliderStyle]'s pill track and thumbs.
/// Remix owns independent thumb interaction, RTL, spacing and announcements.
/// Give each bound a distinct localized name with `semanticLabels`.
/// Custom formatters use [RemixRangeSlider] with this recipe.
@MixWidget(
  target: RemixRangeSlider.new,
  widgetParameters: .only({
    'values',
    'onChanged',
    'onChangeStart',
    'onChangeEnd',
    'min',
    'max',
    'minSpacing',
    'snapDivisions',
    'enabled',
    'enableFeedback',
    'focusNodes',
    'autofocusThumbIndex',
    'semanticLabels',
    'excludeSemantics',
  }),
)
SliderStyler heroUiRangeSliderStyle({
  SliderStyler style = const SliderStyler.create(),
}) => heroUiSliderStyle(style: style);
