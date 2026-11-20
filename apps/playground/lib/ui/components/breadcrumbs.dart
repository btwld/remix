import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../theme/tokens.dart';
import 'link.dart';

/// One step of a [PlaygroundBreadcrumbs] trail.
///
/// A step with [onPressed] is a link back to that page; one without is plain
/// muted text, for a level that has no page of its own. The last step is the
/// current page and is never a link, so its [onPressed] is not used.
@immutable
class PlaygroundBreadcrumbItem {
  const PlaygroundBreadcrumbItem(
    this.label, {
    this.onPressed,
    this.semanticLabel,
  });

  /// The visible text.
  final String label;

  /// Navigates to this step's page.
  final VoidCallback? onPressed;

  /// Replaces [label] for assistive technology.
  final String? semanticLabel;
}

/// The application's Breadcrumbs: the pages above the current one, then the
/// current page.
///
/// A composition of [PlaygroundLink]s rather than a recipe, because Remix has no
/// breadcrumb widget. The trail is `textSm` in `mutedForeground`; a link
/// turns `foreground` under the pointer and rings on keyboard focus, and the
/// current page is `foreground` at regular weight. A 14px chevron sits 10px
/// from the steps on either side, mirrored in right-to-left text.
///
/// The trail stays on one line. Every step keeps its full width while the
/// trail fits. Past that, the chevrons and gaps keep theirs and the steps
/// share what is left: a step shorter than its share stays whole, and the
/// longer ones ellipsize.
///
/// ```dart
/// PlaygroundBreadcrumbs(
///   items: [
///     PlaygroundBreadcrumbItem('Home', onPressed: openHome),
///     PlaygroundBreadcrumbItem('Components', onPressed: openComponents),
///     const PlaygroundBreadcrumbItem('Breadcrumb'),
///   ],
/// )
/// ```
class PlaygroundBreadcrumbs extends StatelessWidget {
  const PlaygroundBreadcrumbs({
    super.key,
    required this.items,
    this.semanticLabel = 'Breadcrumb',
  });

  /// The steps from the top level down; the last is the current page.
  final List<PlaygroundBreadcrumbItem> items;

  /// Names the trail's navigation landmark for assistive technology.
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    assert(items.isNotEmpty, 'A trail needs at least the current page.');
    final current = items.length - 1;

    return Semantics(
      container: true,
      explicitChildNodes: true,
      role: .navigation,
      label: semanticLabel,
      child: _PlaygroundBreadcrumbTrail(
        children: [
          for (final (index, item) in items.indexed) ...[
            if (index > 0) const _PlaygroundBreadcrumbSeparator(),
            if (index == current || item.onPressed == null)
              _step(item, current: index == current)
            else
              PlaygroundLink(
                label: item.label,
                semanticLabel: item.semanticLabel,
                onPressed: item.onPressed,
                style: _linkStyle(),
              ),
          ],
        ],
      ),
    );
  }

  /// A step that is not a link: the current page in `foreground`, or a level
  /// with no page in the trail's muted color.
  Widget _step(PlaygroundBreadcrumbItem item, {required bool current}) {
    final text = StyledText(
      item.label,
      style: _oneLine(
        TextStyler()
            .style(PlaygroundTokens.textSm.mix())
            .fontWeight(FontWeight.w400)
            .color(
              current
                  ? PlaygroundTokens.foreground()
                  : PlaygroundTokens.mutedForeground(),
            ),
      ),
    );
    final semanticLabel = item.semanticLabel;

    return semanticLabel == null
        ? text
        : Semantics(label: semanticLabel, excludeSemantics: true, child: text);
  }
}

/// The trail's colors over the Link recipe: regular weight in
/// `mutedForeground`, turning `foreground` under the pointer instead of
/// underlining, on one line. The recipe's focus ring and motion stay.
LinkStyler _linkStyle() => LinkStyler()
    .label(
      _oneLine(
        TextStyler()
            .fontWeight(FontWeight.w400)
            .color(PlaygroundTokens.mutedForeground()),
      ),
    )
    .onHovered(
      .label(
        .color(PlaygroundTokens.foreground()).decoration(TextDecoration.none),
      ),
    );

/// [text] on a single line that ellipsizes when the trail runs out of room.
TextStyler _oneLine(TextStyler text) =>
    text.maxLines(1).softWrap(false).overflow(.ellipsis);

/// The chevron between two steps, mirrored in right-to-left text.
class _PlaygroundBreadcrumbSeparator extends StatelessWidget {
  const _PlaygroundBreadcrumbSeparator();

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Transform.flip(
      flipX: Directionality.of(context) == TextDirection.rtl,
      child: StyledIcon(
        icon: RemixIcons.chevronRight,
        style: IconStyler()
            .size(PlaygroundTokens.iconSm)
            .color(PlaygroundTokens.mutedForeground()),
      ),
    ),
  );
}

/// The space between a step and a chevron.
const _gap = PlaygroundTokens.s2_5;

/// Lays out alternating steps and chevrons on one centered line, [_gap]
/// apart.
///
/// A [Row] of flexible steps would cap every step at an equal share, so a
/// long page beside a short parent would ellipsize while the parent's unused
/// share stayed empty. This keeps every child at its natural width while
/// they fit, and otherwise shares the space the chevrons leave fairly: the
/// shortest steps stay whole, and the rest split what remains.
class _PlaygroundBreadcrumbTrail extends MultiChildRenderObjectWidget {
  const _PlaygroundBreadcrumbTrail({required super.children});

  @override
  _RenderPlaygroundBreadcrumbTrail createRenderObject(BuildContext context) =>
      _RenderPlaygroundBreadcrumbTrail(Directionality.of(context));

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderPlaygroundBreadcrumbTrail renderObject,
  ) => renderObject.textDirection = Directionality.of(context);
}

class _PlaygroundBreadcrumbTrailParentData
    extends ContainerBoxParentData<RenderBox> {}

class _RenderPlaygroundBreadcrumbTrail extends RenderBox
    with
        ContainerRenderObjectMixin<
          RenderBox,
          _PlaygroundBreadcrumbTrailParentData
        >,
        RenderBoxContainerDefaultsMixin<
          RenderBox,
          _PlaygroundBreadcrumbTrailParentData
        > {
  _RenderPlaygroundBreadcrumbTrail(this._textDirection);

  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (value == _textDirection) return;
    _textDirection = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _PlaygroundBreadcrumbTrailParentData) {
      child.parentData = _PlaygroundBreadcrumbTrailParentData();
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
      (child.parentData! as _PlaygroundBreadcrumbTrailParentData).offset =
          Offset(
            _textDirection == .ltr ? start : size.width - start - width,
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
