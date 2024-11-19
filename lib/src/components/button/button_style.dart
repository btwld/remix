part of 'button.dart';

class ButtonStyle extends SpecStyle<ButtonSpecUtility> {
  const ButtonStyle();

  @override
  Style makeStyle(SpecConfiguration<ButtonSpecUtility> spec) {
    final $ = spec.utilities;

    final iconStyle = [
      $.icon.chain
        ..size(24)
        ..color.white(),
    ];

    final labelStyle = [
      $.label.chain
        ..textHeightBehavior.heightToFirstAscent.off()
        ..textHeightBehavior.heightToLastDescent.on()
        ..style.fontSize(14)
        ..style.height(1.5)
        ..style.color.white()
        ..style.fontWeight.w500(),
    ];

    final spinnerStyle = [
      $.spinner.chain
        ..strokeWidth(0.9)
        ..size(15)
        ..color.white(),
    ];

    final flexboxStyle = [
      $.container.chain
        ..borderRadius(6)
        ..color.black()
        ..padding.vertical(8)
        ..padding.horizontal(12)
        ..flex.mainAxisAlignment.center()
        ..flex.crossAxisAlignment.center()
        ..flex.mainAxisSize.min()
        ..flex.gap(8),
      spec.on.disabled($.container.color.grey.shade400()),
    ];

    return Style.create([
      ...flexboxStyle,
      ...iconStyle,
      ...labelStyle,
      ...spinnerStyle,
    ]);
  }
}

class ButtonDarkStyle extends ButtonStyle {
  const ButtonDarkStyle();

  @override
  Style makeStyle(SpecConfiguration<ButtonSpecUtility> spec) {
    final $ = spec.utilities;

    return Style.create([
      super.makeStyle(spec).call(),
      $.container.color.white(),
      $.label.style.color.black(),
    ]);
  }
}
