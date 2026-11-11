import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import 'slider.dart';

part 'range_slider.g.dart';

/// Two-bound slider sharing [fortalSliderStyle]'s variants, sizes and states.
/// Each thumb keeps independent hover, press and visible keyboard focus.
/// Supply distinct localized `semanticLabels`. For custom value announcements,
/// use [RemixRangeSlider] with this recipe and `semanticFormatterCallbacks`.
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
SliderStyler fortalRangeSliderStyle({
  FortalSliderVariant variant = .surface,
  FortalSliderSize size = .size2,
  bool highContrast = false,
  SliderStyler style = const SliderStyler.create(),
}) => fortalSliderStyle(
  variant: variant,
  size: size,
  highContrast: highContrast,
  style: style,
);
