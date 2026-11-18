import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../theme/theme.dart';
import 'link.dart';
import 'text.dart';
import 'typography.dart';

/// The sizes a breadcrumb trail comes in. Pixel values are at 100% theme
/// scaling.
enum UiBreadcrumbsSize {
  /// 12px text, 12px chevrons 4px from the steps.
  size1,

  /// 14px text, 12px chevrons 8px from the steps. The default.
  size2,

  /// 16px text, 16px chevrons 8px from the steps.
  size3,
}

/// One step of a [UiBreadcrumbs] trail.
@immutable
class UiBreadcrumbItem {
  const UiBreadcrumbItem(this.label, {this.onPressed, this.semanticLabel})
    : assert(label != ''),
      assert(semanticLabel == null || semanticLabel != '');

  /// The step's text.
  final String label;

  /// Makes the step a link. The last step ignores it: it is the current page.
  final VoidCallback? onPressed;

  /// Replaces [label] for assistive technology.
  final String? semanticLabel;
}

/// Where the current page sits: a trail of steps separated by chevrons.
///
/// A step with an `onPressed` is a [UiLink], with the link's accent text,
/// hover underline, focus ring and Enter activation. A step without one is
/// muted text. The last step is the current page in strong, medium-weight
/// text, and never a link.
///
/// The trail keeps to one line. Every step keeps its full width while the
/// trail fits. Past that, the chevrons keep theirs and the steps share what
/// is left: a step shorter than its share stays whole, and the longer ones
/// ellipsize. Chevrons point toward the current page and mirror in
/// right-to-left text; assistive technology skips them.
class UiBreadcrumbs extends StatelessWidget {
  const UiBreadcrumbs({
    super.key,
    required this.items,
    this.size = .size2,
    this.semanticLabel,
  }) : assert(semanticLabel == null || semanticLabel != '');

  /// The steps, from the outermost to the current page.
  final List<UiBreadcrumbItem> items;

  /// The text size, and the chevrons and space that go with it.
  final UiBreadcrumbsSize size;

  /// Names the trail as one group, such as "Breadcrumbs". Without it, the
  /// steps join their surroundings.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final (text, separator, gap) = switch (size) {
      .size1 => (UiTextSize.size1, UiTokens.space3, UiTokens.space1),
      .size2 => (UiTextSize.size2, UiTokens.space3, UiTokens.space2),
      .size3 => (UiTextSize.size3, UiTokens.space4, UiTokens.space2),
    };

    final trail = _Trail(
      gap: gap.resolve(context),
      children: [
        for (final (index, item) in items.indexed) ...[
          if (index > 0) _Chevron(size: separator()),
          _step(item, size: text, current: index == items.length - 1),
        ],
      ],
    );
    if (semanticLabel == null) return trail;

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: semanticLabel,
      child: trail,
    );
  }
}

/// A link when [item] is actionable, otherwise text: muted for a step on the
/// way, strong for the [current] page.
Widget _step(
  UiBreadcrumbItem item, {
  required UiTextSize size,
  required bool current,
}) {
  if (!current && item.onPressed != null) {
    return UiLink(
      item.label,
      size: size,
      truncate: true,
      onPressed: item.onPressed,
      semanticLabel: item.semanticLabel,
    );
  }

  final text = StyledText(
    item.label,
    style: current
        ? uiTextStyle(size: size, weight: .medium, truncate: true)
        : uiTextStyle(size: size, truncate: true).color(UiTokens.gray11()),
  );
  if (item.semanticLabel == null) return text;

  return Semantics(
    label: item.semanticLabel,
    excludeSemantics: true,
    child: text,
  );
}

/// The separator: a gray chevron toward the current page, mirrored in
/// right-to-left text and hidden from assistive technology.
class _Chevron extends StatelessWidget {
  const _Chevron({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Transform.flip(
      flipX: Directionality.of(context) == TextDirection.rtl,
      child: StyledIcon(
        icon: RemixIcons.chevronRight,
        style: IconStyler().size(size).color(UiTokens.gray11()),
      ),
    ),
  );
}

/// Lays out alternating steps and chevrons on one centered line, [gap]
/// apart.
///
/// A [Row] of flexible steps would split the width evenly and ellipsize a
/// long step beside a short one even when the whole trail fits. This keeps
/// every child at its natural width while they fit, and otherwise shares the
/// space left after the chevrons fairly: the shortest steps stay whole, and
/// the rest split what remains.
class _Trail extends MultiChildRenderObjectWidget {
  const _Trail({required this.gap, required super.children});

  final double gap;

  @override
  _RenderTrail createRenderObject(BuildContext context) =>
      _RenderTrail(gap, Directionality.of(context));

  @override
  void updateRenderObject(BuildContext context, _RenderTrail renderObject) =>
      renderObject
        ..gap = gap
        ..textDirection = Directionality.of(context);
}

class _TrailParentData extends ContainerBoxParentData<RenderBox> {}

class _RenderTrail extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _TrailParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _TrailParentData> {
  _RenderTrail(this._gap, this._textDirection);

  double _gap;
  set gap(double value) {
    if (value == _gap) return;
    _gap = value;
    markNeedsLayout();
  }

  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (value == _textDirection) return;
    _textDirection = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _TrailParentData) {
      child.parentData = _TrailParentData();
    }
  }

  List<RenderBox> get _children => [
    for (var child = firstChild; child != null; child = childAfter(child))
      child,
  ];

  double get _gaps => _gap * math.max(0, childCount - 1);

  /// Steps can ellipsize to nothing; the chevrons and gaps cannot shrink.
  @override
  double computeMinIntrinsicWidth(double height) => _children.indexed
      .where((entry) => entry.$1.isOdd)
      .fold(_gaps, (sum, entry) => sum + entry.$2.getMinIntrinsicWidth(height));

  @override
  double computeMaxIntrinsicWidth(double height) => _children.fold(
    _gaps,
    (sum, child) => sum + child.getMaxIntrinsicWidth(height),
  );

  @override
  double computeMinIntrinsicHeight(double width) =>
      computeMaxIntrinsicHeight(width);

  @override
  double computeMaxIntrinsicHeight(double width) => _children.fold(
    0,
    (tallest, child) =>
        math.max(tallest, child.getMaxIntrinsicHeight(double.infinity)),
  );

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      _layout(constraints, place: false);

  @override
  void performLayout() => size = _layout(constraints, place: true);

  /// Sizes every child, and positions them when [place] is set.
  Size _layout(BoxConstraints constraints, {required bool place}) {
    final children = _children;
    final widths = _fit([
      for (final child in children) child.getMaxIntrinsicWidth(double.infinity),
    ], constraints.maxWidth - _gaps);
    final sizes = <Size>[];
    for (final (index, child) in children.indexed) {
      final childConstraints = BoxConstraints(
        maxWidth: widths[index],
        maxHeight: constraints.maxHeight,
      );
      if (place) {
        child.layout(childConstraints, parentUsesSize: true);
        sizes.add(child.size);
      } else {
        sizes.add(child.getDryLayout(childConstraints));
      }
    }
    final size = constraints.constrain(
      Size(
        sizes.fold(_gaps, (sum, size) => sum + size.width),
        sizes.fold(0, (tallest, size) => math.max(tallest, size.height)),
      ),
    );
    if (!place) return size;

    var start = 0.0;
    for (final (index, child) in children.indexed) {
      final width = sizes[index].width;
      (child.parentData! as _TrailParentData).offset = Offset(
        _textDirection == TextDirection.ltr
            ? start
            : size.width - start - width,
        (size.height - sizes[index].height) / 2,
      );
      start += width + _gap;
    }

    return size;
  }

  /// The width of each child: [natural] while the children fit [available];
  /// otherwise the chevrons, at odd indices, keep theirs, and the steps take
  /// fair shares of the rest, shortest first.
  static List<double> _fit(List<double> natural, double available) {
    final total = natural.fold(0.0, (sum, width) => sum + width);
    if (total <= available) return natural;

    final widths = [...natural];
    var remaining = available;
    for (var index = 1; index < natural.length; index += 2) {
      remaining -= natural[index];
    }
    final steps = [
      for (var index = 0; index < natural.length; index += 2) index,
    ]..sort((a, b) => natural[a].compareTo(natural[b]));
    for (final (order, index) in steps.indexed) {
      final share = math.max(0.0, remaining) / (steps.length - order);
      widths[index] = math.min(natural[index], share);
      remaining -= widths[index];
    }

    return widths;
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) =>
      defaultComputeDistanceToHighestActualBaseline(baseline);

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);

  @override
  void paint(PaintingContext context, Offset offset) =>
      defaultPaint(context, offset);
}
