part of 'dialog.dart';

class DialogStyle extends SpecStyle<DialogSpecUtility> {
  const DialogStyle();

  @override
  Style makeStyle(SpecConfiguration<DialogSpecUtility> spec) {
    final $ = spec.utilities;

    final containerStyle = $.container
      ..padding.all(16)
      ..borderRadius.all(8)
      ..color.white()
      ..constraints.minWidth(300)
      ..constraints.maxWidth(500)
      ..flex.mainAxisSize.min()
      ..flex.gap(4)
      ..flex.crossAxisAlignment.start()
      ..flex.direction.vertical();

    final actionsContainer = $.actionsContainer
      ..mainAxisSize.max()
      ..mainAxisAlignment.end()
      ..gap(12)
      ..wrap.padding.top(8);

    final titleStyle = $.title
      ..style.fontSize(18)
      ..style.bold()
      ..style.color.black()
      ..maxLines(3);

    final descriptionStyle = $.description
      ..style.fontSize(14)
      ..style.color.black54();

    return Style.create(
      [
        $with.align(alignment: Alignment.center),
        containerStyle,
        titleStyle,
        descriptionStyle,
        actionsContainer,
      ],
    );
  }
}

class DialogDarkStyle extends DialogStyle {
  const DialogDarkStyle();

  @override
  Style makeStyle(SpecConfiguration<DialogSpecUtility> spec) {
    final $ = spec.utilities;

    return Style.create([
      super.makeStyle(spec),
      $.container
        ..color.black()
        ..border.all.width(1)
        ..border.color.grey.shade900(),
      $.title.style.color.white(),
      $.description
        ..style.color.white()
        ..style.color.grey.shade400(),
    ]);
  }
}
