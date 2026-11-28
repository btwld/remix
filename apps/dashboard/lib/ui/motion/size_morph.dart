import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'timing.dart';

/// Springs its own size toward its child's size whenever the child resizes,
/// clipping the child while the two differ.
///
/// Width and height take separate timings. The first layout takes the child's
/// size as is, and a resize in mid-flight keeps the current velocity. Under
/// reduced motion the size follows the child at once.
class UiSizeMorph extends StatefulWidget {
  const UiSizeMorph({
    super.key,
    this.widthTiming = UiTiming.morph,
    this.heightTiming = UiTiming.morph,
    this.alignment = AlignmentDirectional.topStart,
    this.clipBehavior = Clip.hardEdge,
    required this.child,
  });

  final UiTiming widthTiming;
  final UiTiming heightTiming;

  /// Where the child sits while the box is smaller or larger than it.
  final AlignmentGeometry alignment;

  final Clip clipBehavior;
  final Widget child;

  @override
  State<UiSizeMorph> createState() => _UiSizeMorphState();
}

class _UiSizeMorphState extends State<UiSizeMorph>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return RemixReducedMotionBuilder(
      builder: (context, reduceMotion) => _SizeMorph(
        vsync: this,
        widthTiming: widget.widthTiming,
        heightTiming: widget.heightTiming,
        alignment: widget.alignment,
        clipBehavior: widget.clipBehavior,
        reduceMotion: reduceMotion,
        child: widget.child,
      ),
    );
  }
}

class _SizeMorph extends SingleChildRenderObjectWidget {
  const _SizeMorph({
    required this.vsync,
    required this.widthTiming,
    required this.heightTiming,
    required this.alignment,
    required this.clipBehavior,
    required this.reduceMotion,
    super.child,
  });

  final TickerProvider vsync;
  final UiTiming widthTiming;
  final UiTiming heightTiming;
  final AlignmentGeometry alignment;
  final Clip clipBehavior;
  final bool reduceMotion;

  @override
  _RenderSizeMorph createRenderObject(BuildContext context) => _RenderSizeMorph(
    vsync: vsync,
    widthTiming: widthTiming,
    heightTiming: heightTiming,
    alignment: alignment,
    textDirection: Directionality.maybeOf(context),
    clipBehavior: clipBehavior,
    reduceMotion: reduceMotion,
  );

  @override
  void updateRenderObject(BuildContext context, _RenderSizeMorph renderObject) {
    renderObject
      ..widthTiming = widthTiming
      ..heightTiming = heightTiming
      ..alignment = alignment
      ..textDirection = Directionality.maybeOf(context)
      ..clipBehavior = clipBehavior
      ..reduceMotion = reduceMotion;
  }
}

class _RenderSizeMorph extends RenderAligningShiftedBox {
  _RenderSizeMorph({
    required TickerProvider vsync,
    required this.widthTiming,
    required this.heightTiming,
    required super.alignment,
    required super.textDirection,
    required this._clipBehavior,
    required this.reduceMotion,
  }) {
    _clock = UiMotionClock(vsync, markNeedsLayout);
  }

  late final UiMotionClock _clock;
  UiChannel? _width;
  UiChannel? _height;
  UiTiming widthTiming;
  UiTiming heightTiming;
  bool reduceMotion;

  Clip get clipBehavior => _clipBehavior;
  Clip _clipBehavior;
  set clipBehavior(Clip value) {
    if (value == _clipBehavior) return;
    _clipBehavior = value;
    markNeedsPaint();
  }

  final _clipLayer = LayerHandle<ClipRectLayer>();
  bool _clipped = false;

  @override
  void performLayout() {
    final child = this.child;
    if (child == null) {
      size = constraints.smallest;

      return;
    }
    child.layout(constraints, parentUsesSize: true);
    final target = child.size;
    final width = _width ??= _clock.channel(target.width);
    final height = _height ??= _clock.channel(target.height);
    _clock
      ..animate(width, target.width, widthTiming, jump: reduceMotion)
      ..animate(height, target.height, heightTiming, jump: reduceMotion);
    size = constraints.constrain(Size(width.value, height.value));
    alignChild();
    _clipped = size.width < target.width || size.height < target.height;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final width = _width;
    final height = _height;
    if (width == null || height == null) {
      return child?.getDryLayout(constraints) ?? constraints.smallest;
    }

    return constraints.constrain(Size(width.value, height.value));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) return;
    if (_clipped && clipBehavior != Clip.none) {
      _clipLayer.layer = context.pushClipRect(
        needsCompositing,
        offset,
        Offset.zero & size,
        super.paint,
        clipBehavior: clipBehavior,
        oldLayer: _clipLayer.layer,
      );
    } else {
      _clipLayer.layer = null;
      super.paint(context, offset);
    }
  }

  @override
  void dispose() {
    _clipLayer.layer = null;
    _clock.dispose();
    super.dispose();
  }
}
