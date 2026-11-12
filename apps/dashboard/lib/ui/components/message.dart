import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../models/statuses.dart';
import '../support/disclosure.dart';

part 'message.g.dart';

/// Groups chronological message rows without imposing visual chrome.
class UiMessageGroup extends StatelessWidget {
  const UiMessageGroup({super.key, required this.children, this.spacing = 0});

  /// The rows, oldest first.
  final List<Widget> children;

  /// Gap between rows, in logical pixels.
  final double spacing;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    spacing: spacing,
    children: children,
  );
}

/// Sender-aware message row. Message bodies are never clamped automatically.
class UiMessage extends StatelessWidget {
  const UiMessage({
    super.key,
    required this.role,
    required this.child,
    this.align,
    this.avatar,
    this.showAvatar = false,
    this.placeholderAvatar = false,
    this.maxWidth,
    this.header,
    this.footer,
    this.semanticLabel,
    this.surfaceStyle = const CardStyler.create(),
    this.style = const UiMessageStyler.create(),
    this.styleSpec,
  });

  /// Who wrote the message; decides the default alignment and label.
  final UiRole role;

  /// The message body, rendered by the host.
  final Widget child;

  /// Which edge the message sits on.
  ///
  /// When null, a user message sits at the end and an assistant message at
  /// the start.
  final RemixPlacement? align;

  /// The sender's avatar, shown when [showAvatar] is true.
  final Widget? avatar;

  /// Whether [avatar] is shown beside the message.
  final bool showAvatar;

  /// Reserves the avatar's space without drawing it, so consecutive rows from
  /// one sender stay aligned.
  final bool placeholderAvatar;

  /// Widest the message card grows. When null, the spec's `maxWidth` applies.
  final double? maxWidth;

  /// Content above the card, such as the sender's name.
  final Widget? header;

  /// Content below the card, such as a timestamp.
  final Widget? footer;

  /// Accessible label. When null, "User message" or "Assistant message".
  final String? semanticLabel;

  /// Style of the card around the body.
  final CardStyler surfaceStyle;

  /// Style of the message's own slots.
  final UiMessageStyler style;

  /// A resolved spec that is used instead of resolving [style].
  final UiMessageSpec? styleSpec;

  bool get _alignEnd =>
      (align ??
          (role == UiRole.user ? RemixPlacement.end : RemixPlacement.start)) ==
      RemixPlacement.end;

  @override
  Widget build(BuildContext context) {
    return RemixStyleSpecBuilder<UiMessageSpec>(
      style: style,
      styleSpec: styleSpec,
      builder: (context, spec) {
        final body = RemixCard(
          style: surfaceStyle,
          child: Box(styleSpec: spec.body, child: child),
        );
        final cap = maxWidth ?? spec.maxWidth;
        final constrained = cap == null
            ? body
            : ConstrainedBox(
                constraints: BoxConstraints(maxWidth: cap),
                child: body,
              );
        final stack = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: _alignEnd
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (header != null) Box(styleSpec: spec.header, child: header),
            constrained,
            if (footer != null) Box(styleSpec: spec.footer, child: footer),
          ],
        );
        final avatarSlot = _avatarSlot(spec);
        final row = RowBox(
          styleSpec: spec.row,
          children: [
            if (!_alignEnd && avatarSlot != null) avatarSlot,
            Expanded(
              child: Align(
                alignment: _alignEnd
                    ? AlignmentDirectional.centerEnd
                    : AlignmentDirectional.centerStart,
                child: stack,
              ),
            ),
            if (_alignEnd && avatarSlot != null) avatarSlot,
          ],
        );
        return Semantics(
          container: true,
          explicitChildNodes: true,
          label:
              semanticLabel ??
              (role == UiRole.user ? 'User message' : 'Assistant message'),
          child: row,
        );
      },
    );
  }

  Widget? _avatarSlot(UiMessageSpec spec) {
    if (placeholderAvatar) return Box(styleSpec: spec.avatar);
    if (!showAvatar || avatar == null) return null;
    return Box(styleSpec: spec.avatar, child: avatar);
  }
}

/// Explicit, opt-in clipping for noninteractive message copy.
///
/// Do not place buttons, links, or other interactive descendants in [child].
/// While collapsed, the whole child remains readable to assistive technology
/// but is removed from pointer input, focus, and traversal.
class UiMessageCollapsible extends StatefulWidget {
  const UiMessageCollapsible({
    super.key,
    required this.child,
    this.expanded,
    this.defaultExpanded = false,
    this.onExpandedChanged,
    this.showMoreLabel = 'Show more',
    this.showLessLabel = 'Show less',
    this.toggleStyle = const ButtonStyler.create(),
    this.style = const UiMessageCollapsibleStyler.create(),
    this.styleSpec,
  });

  /// The noninteractive content to clip.
  final Widget child;

  /// Controls whether the content is open. When null, the widget manages it.
  final bool? expanded;

  /// Whether the content starts open when uncontrolled.
  final bool defaultExpanded;

  /// Called when the toggle asks to open or close the content.
  final ValueChanged<bool>? onExpandedChanged;

  /// Toggle label while the content is clipped.
  final String showMoreLabel;

  /// Toggle label while the content is open.
  final String showLessLabel;

  /// Style of the toggle button.
  final ButtonStyler toggleStyle;

  /// Style of the collapsible's own slots.
  final UiMessageCollapsibleStyler style;

  /// A resolved spec that is used instead of resolving [style].
  final UiMessageCollapsibleSpec? styleSpec;

  @override
  State<UiMessageCollapsible> createState() => _UiMessageCollapsibleState();
}

class _UiMessageCollapsibleState extends State<UiMessageCollapsible> {
  late final UiDisclosureEngine _disclosure;
  bool _overflows = false;

  bool get _expanded => _disclosure.value;

  @override
  void initState() {
    super.initState();
    _disclosure = UiDisclosureEngine(
      value: widget.expanded,
      defaultValue: widget.defaultExpanded,
    );
  }

  @override
  void didUpdateWidget(UiMessageCollapsible oldWidget) {
    super.didUpdateWidget(oldWidget);
    _disclosure.reconcile(widget.expanded);
  }

  void _toggle() {
    final next = !_expanded;
    if (_disclosure.request(next)) setState(() {});
    widget.onExpandedChanged?.call(next);
  }

  void _handleOverflow(bool value) {
    if (value == _overflows) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && value != _overflows) setState(() => _overflows = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RemixStyleSpecBuilder<UiMessageCollapsibleSpec>(
      style: widget.style,
      styleSpec: widget.styleSpec,
      builder: (context, spec) {
        final height = spec.collapsedHeight;
        final collapsed = !_expanded && height != null;
        Widget content = _OverflowClip(
          maxHeight: height,
          clip: collapsed,
          onOverflowChanged: _handleOverflow,
          child: Box(styleSpec: spec.clipped, child: widget.child),
        );
        if (collapsed) {
          content = IgnorePointer(
            child: Focus(
              canRequestFocus: false,
              skipTraversal: true,
              descendantsAreFocusable: false,
              descendantsAreTraversable: false,
              child: content,
            ),
          );
        }
        return Box(
          styleSpec: spec.container,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              content,
              if (_overflows)
                RemixButton(
                  label: _expanded
                      ? widget.showLessLabel
                      : widget.showMoreLabel,
                  semanticLabel: _expanded
                      ? widget.showLessLabel
                      : widget.showMoreLabel,
                  onPressed: _toggle,
                  style: widget.toggleStyle,
                ),
            ],
          ),
        );
      },
    );
  }
}

class _OverflowClip extends SingleChildRenderObjectWidget {
  const _OverflowClip({
    required this.maxHeight,
    required this.clip,
    required this.onOverflowChanged,
    required super.child,
  });

  final double? maxHeight;
  final bool clip;
  final ValueChanged<bool> onOverflowChanged;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderOverflowClip(maxHeight, clip, onOverflowChanged);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderOverflowClip renderObject,
  ) {
    renderObject
      ..maxHeight = maxHeight
      ..clip = clip
      ..onOverflowChanged = onOverflowChanged;
  }
}

class _RenderOverflowClip extends RenderProxyBox {
  _RenderOverflowClip(this._maxHeight, this._clip, this.onOverflowChanged);

  double? _maxHeight;
  bool _clip;
  ValueChanged<bool> onOverflowChanged;
  bool _reportedOverflow = false;

  set maxHeight(double? value) {
    if (value == _maxHeight) return;
    _maxHeight = value;
    markNeedsLayout();
  }

  set clip(bool value) {
    if (value == _clip) return;
    _clip = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    final current = child;
    if (current == null) {
      size = constraints.smallest;
      return;
    }
    current.layout(
      constraints.copyWith(minHeight: 0, maxHeight: double.infinity),
      parentUsesSize: true,
    );
    final limit = _maxHeight;
    final overflow = limit != null && current.size.height > limit;
    size = constraints.constrain(
      Size(current.size.width, _clip && overflow ? limit : current.size.height),
    );
    if (overflow != _reportedOverflow) {
      _reportedOverflow = overflow;
      onOverflowChanged(overflow);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) return;
    if (!_clip) {
      super.paint(context, offset);
      return;
    }
    // pushClipRect applies the paint offset to this local rectangle.
    context.pushClipRect(
      needsCompositing,
      offset,
      Offset.zero & size,
      super.paint,
    );
  }
}

@MixableSpec(target: UiMessage.new)
@immutable
final class UiMessageSpec with _$UiMessageSpec {
  /// Widest the message card grows; [UiMessage.maxWidth] overrides it.
  @override
  final double? maxWidth;

  /// Lays out the avatar beside the message.
  @override
  final StyleSpec<FlexBoxSpec> row;

  /// Wraps the avatar or its placeholder.
  @override
  final StyleSpec<BoxSpec> avatar;

  /// Wraps the header.
  @override
  final StyleSpec<BoxSpec> header;

  /// Wraps the body inside the card.
  @override
  final StyleSpec<BoxSpec> body;

  /// Wraps the footer.
  @override
  final StyleSpec<BoxSpec> footer;

  const UiMessageSpec({
    this.maxWidth,
    StyleSpec<FlexBoxSpec>? row,
    StyleSpec<BoxSpec>? avatar,
    StyleSpec<BoxSpec>? header,
    StyleSpec<BoxSpec>? body,
    StyleSpec<BoxSpec>? footer,
  }) : row = row ?? const StyleSpec(spec: FlexBoxSpec()),
       avatar = avatar ?? const StyleSpec(spec: BoxSpec()),
       header = header ?? const StyleSpec(spec: BoxSpec()),
       body = body ?? const StyleSpec(spec: BoxSpec()),
       footer = footer ?? const StyleSpec(spec: BoxSpec());
}

@MixableSpec(target: UiMessageCollapsible.new)
@immutable
final class UiMessageCollapsibleSpec with _$UiMessageCollapsibleSpec {
  /// Height at which the content is clipped while closed; null never clips.
  @override
  final double? collapsedHeight;

  /// Wraps the content and the toggle.
  @override
  final StyleSpec<BoxSpec> container;

  /// Wraps the clipped content.
  @override
  final StyleSpec<BoxSpec> clipped;

  const UiMessageCollapsibleSpec({
    this.collapsedHeight,
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? clipped,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       clipped = clipped ?? const StyleSpec(spec: BoxSpec());
}
