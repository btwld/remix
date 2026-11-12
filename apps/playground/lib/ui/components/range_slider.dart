import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import 'slider.dart';

part 'range_slider.g.dart';

/// The application's two-bound Slider recipe.
///
/// It is [playgroundSliderStyle]: the same rail, filled interval and thumb states
/// serve both thumbs. Pass [surfaceColor] on a card or tinted panel so the
/// thumb halos blend with it rather than the page.
///
/// Give each bound a distinct name in `semanticLabels`. The generated
/// `PlaygroundRangeSlider` omits `semanticFormatterCallbacks`, whose type comes
/// from `package:naked_ui`; use `RemixRangeSlider` for custom announcements.
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
SliderStyler playgroundRangeSliderStyle({
  Color? surfaceColor,
  SliderStyler style = const SliderStyler.create(),
}) => playgroundSliderStyle(surfaceColor: surfaceColor, style: style);
