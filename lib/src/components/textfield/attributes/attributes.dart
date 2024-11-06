import 'dart:ui';

import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'attributes.g.dart';

@MixableEnumUtility()
final class BoxHeightStyleUtility<T extends Attribute>
    extends MixUtility<T, BoxHeightStyle> with _$BoxHeightStyleUtility {
  const BoxHeightStyleUtility(super.builder);
}

@MixableEnumUtility()
final class BoxWidthStyleUtility<T extends Attribute>
    extends MixUtility<T, BoxWidthStyle> with _$BoxWidthStyleUtility {
  const BoxWidthStyleUtility(super.builder);
}

@MixableEnumUtility()
final class BrightnessUtility<T extends Attribute>
    extends MixUtility<T, Brightness> with _$BrightnessUtility {
  const BrightnessUtility(super.builder);
}
