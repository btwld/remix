part of 'toast.dart';

/// A normal flex row at wide sizes; a message/action column beside the chrome
/// at narrow sizes. Both layouts measure the same children, including during
/// intrinsic and dry layout, without rebuilding controls during layout.
class _ToastReflow extends MultiChildRenderObjectWidget {
  const _ToastReflow({
    required this.flex,
    required this.minInlineWidth,
    required this.hasLeading,
    required this.hasClose,
    required super.children,
  });

  final FlexSpec flex;
  final double minInlineWidth;
  final bool hasLeading;
  final bool hasClose;

  @override
  _RenderToastReflow createRenderObject(BuildContext context) {
    final renderObject = _RenderToastReflow();
    updateRenderObject(context, renderObject);
    return renderObject;
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderToastReflow renderObject,
  ) {
    renderObject
      ..mainAxisAlignment = flex.mainAxisAlignment ?? .start
      ..mainAxisSize = flex.mainAxisSize ?? .max
      ..crossAxisAlignment = flex.crossAxisAlignment ?? .center
      ..textDirection = flex.textDirection ?? Directionality.of(context)
      ..verticalDirection = flex.verticalDirection ?? .down
      ..textBaseline = flex.textBaseline
      ..clipBehavior = flex.clipBehavior ?? .none
      ..spacing = flex.spacing ?? 0;
    renderObject.configure(
      minInlineWidth: minInlineWidth,
      hasLeading: hasLeading,
      hasClose: hasClose,
      contentDirection: Directionality.of(context),
    );
  }
}

class _RenderToastReflow extends RenderFlex {
  _RenderToastReflow() : super(direction: Axis.horizontal);

  double _minInlineWidth = 0;
  bool _hasLeading = false;
  bool _hasClose = false;
  TextDirection _contentDirection = TextDirection.ltr;

  void configure({
    required double minInlineWidth,
    required bool hasLeading,
    required bool hasClose,
    required TextDirection contentDirection,
  }) {
    if (_minInlineWidth == minInlineWidth &&
        _hasLeading == hasLeading &&
        _hasClose == hasClose &&
        _contentDirection == contentDirection) {
      return;
    }
    _minInlineWidth = minInlineWidth;
    _hasLeading = hasLeading;
    _hasClose = hasClose;
    _contentDirection = contentDirection;
    markNeedsLayout();
  }

  bool _below(double width) => width < _minInlineWidth;

  ({Size size, Map<RenderBox, Offset> offsets}) _layoutBelow(
    BoxConstraints constraints,
    Size Function(RenderBox, BoxConstraints) layoutChild,
  ) {
    final children = getChildrenAsList();
    final leading = _hasLeading ? children.first : null;
    final close = _hasClose ? children.last : null;
    final message = children[_hasLeading ? 1 : 0];
    final action = children[_hasLeading ? 2 : 1];
    final chromeConstraints = BoxConstraints(maxHeight: constraints.maxHeight);
    final leadingSize = leading == null
        ? Size.zero
        : layoutChild(leading, chromeConstraints);
    final closeSize = close == null
        ? Size.zero
        : layoutChild(close, chromeConstraints);
    final groups = childCount - 1; // Message and action share one column.
    final contentConstraints = BoxConstraints(
      maxWidth: math.max(
        0,
        constraints.maxWidth -
            leadingSize.width -
            closeSize.width -
            spacing * (groups - 1),
      ),
    );
    final messageSize = layoutChild(message, contentConstraints);
    final actionSize = layoutChild(action, contentConstraints);
    final contentWidth = math.max(messageSize.width, actionSize.width);
    final contentHeight = messageSize.height + spacing + actionSize.height;
    final usedWidth =
        leadingSize.width +
        contentWidth +
        closeSize.width +
        spacing * (groups - 1);
    final size = constraints.constrain(
      Size(
        mainAxisSize == .max ? constraints.maxWidth : usedWidth,
        math.max(contentHeight, math.max(leadingSize.height, closeSize.height)),
      ),
    );
    final free = math.max(0.0, size.width - usedWidth);
    final (before, between) = switch (mainAxisAlignment) {
      .start => (0.0, spacing),
      .end => (free, spacing),
      .center => (free / 2, spacing),
      .spaceBetween => (0.0, spacing + (groups > 1 ? free / (groups - 1) : 0)),
      .spaceAround => (free / groups / 2, spacing + free / groups),
      .spaceEvenly => (free / (groups + 1), spacing + free / (groups + 1)),
    };
    double left(double start, double width) =>
        textDirection == .rtl ? size.width - start - width : start;
    double top(double height) =>
        verticalDirection == .down ? 0 : size.height - height;
    var start = before;
    final offsets = <RenderBox, Offset>{};
    if (leading != null) {
      offsets[leading] = Offset(
        left(start, leadingSize.width),
        top(leadingSize.height),
      );
      start += leadingSize.width + between;
    }
    final contentLeft = left(start, contentWidth);
    double contentX(double width) =>
        contentLeft + (_contentDirection == .rtl ? contentWidth - width : 0);
    offsets[message] = Offset(contentX(messageSize.width), top(contentHeight));
    offsets[action] = Offset(
      contentX(actionSize.width),
      top(contentHeight) + messageSize.height + spacing,
    );
    if (close != null) {
      start += contentWidth + between;
      offsets[close] = Offset(
        left(start, closeSize.width),
        top(closeSize.height),
      );
    }
    return (size: size, offsets: offsets);
  }

  @override
  void performLayout() {
    if (!_below(constraints.maxWidth)) {
      super.performLayout();
      return;
    }
    final layout = _layoutBelow(constraints, (child, constraints) {
      child.layout(constraints, parentUsesSize: true);
      return child.size;
    });
    size = layout.size;
    for (final entry in layout.offsets.entries) {
      (entry.key.parentData! as FlexParentData).offset = entry.value;
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      _below(constraints.maxWidth)
      ? _layoutBelow(constraints, (child, c) => child.getDryLayout(c)).size
      : super.computeDryLayout(constraints);

  @override
  double computeMinIntrinsicHeight(double width) => _below(width)
      ? computeDryLayout(BoxConstraints(maxWidth: width)).height
      : super.computeMinIntrinsicHeight(width);

  @override
  double computeMaxIntrinsicHeight(double width) => _below(width)
      ? computeDryLayout(BoxConstraints(maxWidth: width)).height
      : super.computeMaxIntrinsicHeight(width);

  @override
  double? computeDryBaseline(
    BoxConstraints constraints,
    TextBaseline baseline,
  ) {
    if (!_below(constraints.maxWidth)) {
      return super.computeDryBaseline(constraints, baseline);
    }
    final baselines = <RenderBox, double>{};
    final layout = _layoutBelow(constraints, (child, c) {
      final distance = child.getDryBaseline(c, baseline);
      if (distance != null) baselines[child] = distance;
      return child.getDryLayout(c);
    });
    double? highest;
    for (final entry in baselines.entries) {
      final distance = entry.value + layout.offsets[entry.key]!.dy;
      highest = highest == null ? distance : math.min(highest, distance);
    }
    return highest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (!_below(constraints.maxWidth)) {
      super.paint(context, offset);
      return;
    }
    // RenderFlex's overflow cache belongs to the inline layout, not this one.
    final bounds = Offset.zero & size;
    if (clipBehavior == .none) {
      defaultPaint(context, offset);
    } else {
      context.pushClipRect(
        needsCompositing,
        offset,
        bounds,
        defaultPaint,
        clipBehavior: clipBehavior,
      );
    }
    assert(() {
      var childrenBounds = Rect.zero;
      for (final child in getChildrenAsList()) {
        final data = child.parentData! as FlexParentData;
        childrenBounds = childrenBounds.expandToInclude(
          data.offset & child.size,
        );
      }
      if (childrenBounds.left < -precisionErrorTolerance ||
          childrenBounds.top < -precisionErrorTolerance ||
          childrenBounds.right > size.width + precisionErrorTolerance ||
          childrenBounds.bottom > size.height + precisionErrorTolerance) {
        paintOverflowIndicator(context, offset, bounds, childrenBounds);
      }
      return true;
    }());
  }

  @override
  Rect? describeApproximatePaintClip(RenderObject child) =>
      _below(constraints.maxWidth)
      ? (clipBehavior == .none ? null : Offset.zero & size)
      : super.describeApproximatePaintClip(child);
}
