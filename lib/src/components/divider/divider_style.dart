part of 'divider.dart';

class DividerStyle extends SpecStyle<DividerSpecUtility> {
  static const vertical = Variant('divider.vertical');
  static const horizontal = Variant('divider.horizontal');

  const DividerStyle();

  @override
  Style makeStyle(SpecConfiguration<DividerSpecUtility> spec) {
    final $ = spec.utilities;

    final containerStyle = [
      $.container.chain
        ..color.black12()
        ..borderRadius(99),
      horizontal($.container.height(1)),
      vertical($.container.width(1)),
    ];

    return Style.create([...containerStyle]);
  }
}
