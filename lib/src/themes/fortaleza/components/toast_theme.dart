import 'package:mix/mix.dart';

import '../../../components/feedback/toast/toast.dart';
import '../../../helpers/spec_style.dart';
import '../tokens.dart';

class FortalezaToastStyle extends ToastStyle {
  const FortalezaToastStyle();

  @override
  Style makeStyle(SpecConfiguration<ToastSpecUtility> spec) {
    final $ = spec.utilities;

    final containerStyle = $.container
      ..borderRadius.all.$radius2()
      ..color.$neutral(2)
      ..border.all.color.$neutral(6)
      ..padding.all.$space4()
      ..margin.all.$space4()
      ..flex.gap.$space5();

    final titleSubtitleContainerStyle =
        $.titleSubtitleContainer.flex.gap.$space1();

    final titleStyle = $.title
      ..style.$text2()
      ..style.color.$neutral(12);

    final subtitleStyle = $.subtitle
      ..style.$text1()
      ..style.color.$neutral(9);

    return Style.create([
      super.makeStyle(spec),
      containerStyle,
      titleSubtitleContainerStyle,
      titleStyle,
      subtitleStyle,
    ]);
  }
}
