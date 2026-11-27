part of 'tag_input.dart';

/// Wraps tags like [Wrap], then gives the last child (the editor) the rest of
/// its row, or a full row of its own when less than [editorMinWidth] is left.
class _TagInputFlow extends MultiChildRenderObjectWidget {
  const _TagInputFlow({
    required this.spacing,
    required this.runSpacing,
    required this.editorMinWidth,
    required super.children,
  });

  final double spacing;
  final double runSpacing;
  final double editorMinWidth;

  @override
  _RenderTagInputFlow createRenderObject(BuildContext context) =>
      _RenderTagInputFlow(
        spacing: spacing,
        runSpacing: runSpacing,
        editorMinWidth: editorMinWidth,
        textDirection: Directionality.of(context),
      );

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderTagInputFlow renderObject,
  ) {
    renderObject
      ..spacing = spacing
      ..runSpacing = runSpacing
      ..editorMinWidth = editorMinWidth
      ..textDirection = Directionality.of(context);
  }
}

class _TagInputFlowParentData extends ContainerBoxParentData<RenderBox> {}

class _RenderTagInputFlow extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _TagInputFlowParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _TagInputFlowParentData> {
  _RenderTagInputFlow({
    required double spacing,
    required double runSpacing,
    required double editorMinWidth,
    required TextDirection textDirection,
  }) : _spacing = spacing,
       _runSpacing = runSpacing,
       _editorMinWidth = editorMinWidth,
       _textDirection = textDirection;

  double _spacing;
  set spacing(double value) {
    if (_spacing == value) return;
    _spacing = value;
    markNeedsLayout();
  }

  double _runSpacing;
  set runSpacing(double value) {
    if (_runSpacing == value) return;
    _runSpacing = value;
    markNeedsLayout();
  }

  double _editorMinWidth;
  set editorMinWidth(double value) {
    if (_editorMinWidth == value) return;
    _editorMinWidth = value;
    markNeedsLayout();
  }

  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) return;
    _textDirection = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _TagInputFlowParentData) {
      child.parentData = _TagInputFlowParentData();
    }
  }

  Size _layout(BoxConstraints constraints, {required bool dry}) {
    final maxWidth = constraints.maxWidth;
    final children = <RenderBox>[];
    var child = firstChild;
    while (child != null) {
      children.add(child);
      child = childAfter(child);
    }
    if (children.isEmpty) return constraints.smallest;

    final sizes = <Size>[];
    final starts = <double>[];
    final runs = <int>[];
    final runHeights = <double>[0];
    var x = 0.0;
    var run = 0;
    var widest = 0.0;

    void place(Size size) {
      if (x > 0 && x + size.width > maxWidth + precisionErrorTolerance) {
        run++;
        runHeights.add(0);
        x = 0;
      }
      starts.add(x);
      runs.add(run);
      sizes.add(size);
      runHeights[run] = math.max(runHeights[run], size.height);
      x += size.width;
      widest = math.max(widest, x);
      x += _spacing;
    }

    Size measure(RenderBox box, BoxConstraints c) =>
        dry ? box.getDryLayout(c) : (box..layout(c, parentUsesSize: true)).size;

    final loose = BoxConstraints(maxWidth: maxWidth);
    for (final tag in children.take(children.length - 1)) {
      place(measure(tag, loose));
    }

    // A row that cannot fit the editor's minimum starts a new one, which
    // place() does because a full-width editor overflows any partial row.
    final remaining = maxWidth - x;
    final editorWidth = !maxWidth.isFinite
        ? _editorMinWidth
        : x > 0 && remaining >= _editorMinWidth
        ? remaining
        : maxWidth;
    place(measure(children.last, BoxConstraints.tightFor(width: editorWidth)));

    final tops = <double>[0];
    for (var i = 1; i < runHeights.length; i++) {
      tops.add(tops[i - 1] + runHeights[i - 1] + _runSpacing);
    }
    final height = tops.last + runHeights.last;
    final size = constraints.constrain(
      Size(maxWidth.isFinite ? maxWidth : widest, height),
    );
    if (dry) return size;

    for (final (i, box) in children.indexed) {
      final dx = _textDirection == TextDirection.rtl
          ? size.width - starts[i] - sizes[i].width
          : starts[i];
      final dy = tops[runs[i]] + (runHeights[runs[i]] - sizes[i].height) / 2;
      (box.parentData! as _TagInputFlowParentData).offset = Offset(dx, dy);
    }
    return size;
  }

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) =>
      _layout(constraints, dry: true);

  @override
  void performLayout() {
    size = _layout(constraints, dry: false);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);

  @override
  void paint(PaintingContext context, Offset offset) =>
      defaultPaint(context, offset);
}
