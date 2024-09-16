part of 'radio.dart';

class RadioStyle extends SpecStyle<RadioSpecUtility> {
  const RadioStyle();

  @override
  Style makeStyle(SpecConfiguration<RadioSpecUtility> spec) {
    final $ = spec.utilities;

    final containerStyle = [
      $.container.chain
        ..borderRadius(99)
        ..alignment.center()
        ..size(14)
        ..border.all.width(1)
        ..border.all.color.black(),
      spec.on.disabled($.container.border.color.black45()),
    ];

    final indicatorStyle = [
      $.indicator.chain
        ..borderRadius(99)
        ..color.black()
        ..wrap.padding.all(2)
        ..wrap.opacity(0)
        ..wrap.scale(0.5),
      spec.on.selected($.indicator.wrap.opacity(1), $.indicator.wrap.scale(1)),
      spec.on.disabled($.indicator.color.black45()),
    ];

    final textStyle = [
      $.text.chain
        ..style.fontSize(14)
        ..style.height(1)
        ..style.fontWeight.w500()
        ..textHeightBehavior(
          const TextHeightBehavior(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
          ),
        ),
    ];

    final flexStyle = [
      $.flex.chain
        ..row()
        ..mainAxisAlignment.start()
        ..crossAxisAlignment.center()
        ..gap(8),
    ];

    return Style.create([
      ...containerStyle,
      ...indicatorStyle,
      ...textStyle,
      ...flexStyle,
    ]).animate(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOutQuad,
    );
  }
}
