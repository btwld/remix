part of 'progress.dart';

class ProgressStyle extends SpecStyle<ProgressSpecUtility> {
  const ProgressStyle();

  @override
  Style makeStyle(SpecConfiguration<ProgressSpecUtility> spec) {
    final $ = spec.utilities;

    final containerStyle = [
      $.container.chain
        ..height(6)
        ..clipBehavior.antiAlias()
        ..borderRadius(99),
    ];

    final trackStyle = [$.track.color.black12()];

    final fillStyle = [$.fill.color.black()];

    return Style.create([...containerStyle, ...trackStyle, ...fillStyle]);
  }
}
