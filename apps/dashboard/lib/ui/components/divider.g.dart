// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'divider.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal Divider recipe: a 1px gray line, horizontal or vertical.
class UiDivider extends StatelessWidget {
  const UiDivider({
    super.key,
    this.size = .size1,
    this.orientation = Axis.horizontal,
    this.style = const DividerStyler.create(),
  });

  final UiDividerSize size;

  final Axis orientation;

  final DividerStyler style;

  @override
  Widget build(BuildContext _) {
    return RemixDivider(
      style: uiDividerStyle(size: size, orientation: orientation, style: style),
    );
  }
}
