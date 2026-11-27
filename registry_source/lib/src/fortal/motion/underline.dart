import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Draws a [thickness] line of [color] across its child, [offset] below the
/// child's first alphabetic baseline.
///
/// Flutter's [TextDecoration.underline] sits where the font puts it, with no
/// offset. This is for single-line labels such as links and breadcrumbs;
/// animate [color] to fade the line in.
class FortalUnderline extends SingleChildRenderObjectWidget {
  const FortalUnderline({
    super.key,
    required this.color,
    this.offset = 4,
    this.thickness = 1,
    required Widget super.child,
  });

  final Color color;

  /// Logical pixels from the baseline to the top of the line.
  final double offset;

  final double thickness;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderUnderline(color: color, offset: offset, thickness: thickness);

  @override
  void updateRenderObject(BuildContext context, _RenderUnderline renderObject) {
    renderObject
      ..color = color
      ..offset = offset
      ..thickness = thickness;
  }
}

class _RenderUnderline extends RenderProxyBox {
  _RenderUnderline({
    required Color color,
    required double offset,
    required double thickness,
  }) : _color = color,
       _offset = offset,
       _thickness = thickness;

  Color get color => _color;
  Color _color;
  set color(Color value) {
    if (value == _color) return;
    _color = value;
    markNeedsPaint();
  }

  double get offset => _offset;
  double _offset;
  set offset(double value) {
    if (value == _offset) return;
    _offset = value;
    markNeedsPaint();
  }

  double get thickness => _thickness;
  double _thickness;
  set thickness(double value) {
    if (value == _thickness) return;
    _thickness = value;
    markNeedsPaint();
  }

  double? _baseline;

  @override
  void performLayout() {
    super.performLayout();
    _baseline = child?.getDistanceToActualBaseline(TextBaseline.alphabetic);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    if (color.a == 0) return;
    final top = (_baseline ?? size.height) + _offset;
    context.canvas.drawRect(
      Rect.fromLTWH(offset.dx, offset.dy + top, size.width, thickness),
      Paint()..color = color,
    );
  }
}
