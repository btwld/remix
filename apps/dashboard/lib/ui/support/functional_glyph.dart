import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

abstract final class _Glyphs {
  static const arrowUp = RemixIcons.arrowUp;
  static const arrowDown = RemixIcons.arrowDown;
  static const square = RemixIcons.square;
  static const copy = RemixIcons.copy;
  static const rotateCcw = RemixIcons.refresh;
  static const chevronUp = RemixIcons.chevronUp;
  static const chevronDown = RemixIcons.chevronDown;
  static const circle = RemixIcons.circle;
  static const circleDot = RemixIcons.dotFilled;
  static const check = RemixIcons.check;
  static const x = RemixIcons.close;
  static const circleAlert = RemixIcons.warning;
  static const squareTerminal = RemixIcons.terminal;
  static const loaderCircle = RemixIcons.loader;
  static const circleCheck = RemixIcons.checkCircle;
  static const ban = RemixIcons.ban;
  static const circleX = RemixIcons.closeCircle;
  static const shieldCheck = RemixIcons.lock;
}

/// Builds the chevron that reports a collapsible surface's state.
///
/// Every collapsible surface lets the host replace the glyph with a builder.
/// Each surface names that builder for what it discloses (details, sources),
/// so only this body is shared.
class UiDisclosureIndicator extends StatelessWidget {
  const UiDisclosureIndicator({
    super.key,
    required this.styleSpec,
    required this.expanded,
    this.builder,
  });

  /// Icon style for the default chevron.
  final StyleSpec<IconSpec> styleSpec;

  /// Whether the surface is open; the default chevron points up when it is.
  final bool expanded;

  /// Replaces the default chevron.
  final Widget Function(BuildContext context, bool expanded)? builder;

  @override
  Widget build(BuildContext context) =>
      builder?.call(context, expanded) ??
      StyleSpecBuilder<IconSpec>(
        styleSpec: styleSpec,
        builder: (context, iconSpec) => UiFunctionalGlyph(
          kind: .chevron,
          spec: iconSpec,
          expanded: expanded,
        ),
      );
}

/// Material-free glyph set behind the Ui components' default icons.
///
/// The types are intentionally not exported from the package barrel. Public
/// icon and status builders remain the way to replace a glyph.
enum UiFunctionalGlyphKind {
  /// Submit a message.
  send,

  /// Stop a running turn.
  stop,

  /// Copy content.
  copy,

  /// Retry a turn or execution.
  retry,

  /// Disclosure chevron; points up when expanded, down otherwise.
  chevron,

  /// A plan or activity row that has not started.
  pending,

  /// The plan or activity row currently underway.
  active,

  /// A finished row.
  completed,

  /// An abandoned row or a denied request.
  cancelled,

  /// A failure.
  error,

  /// A tool.
  tool,

  /// Indeterminate progress; the only glyph that animates.
  loading,

  /// A successful execution.
  completedCircle,

  /// A canceled execution.
  cancelledCircle,

  /// A failed execution.
  errorCircle,

  /// A tool permission request.
  permission,

  /// Jump to the newest transcript content.
  latest,
}

/// Paints one [UiFunctionalGlyphKind] with an [IconSpec].
///
/// Unset [spec] fields fall back to the ambient [IconTheme].
class UiFunctionalGlyph extends StatelessWidget {
  const UiFunctionalGlyph({
    super.key,
    required this.kind,
    required this.spec,
    this.expanded = false,
  });

  /// Which glyph to draw.
  final UiFunctionalGlyphKind kind;

  /// Resolved icon style.
  final IconSpec spec;

  /// Selects the chevron direction; ignored by other kinds.
  final bool expanded;

  IconData get _icon => switch (kind) {
    .send => _Glyphs.arrowUp,
    .stop => _Glyphs.square,
    .copy => _Glyphs.copy,
    .retry => _Glyphs.rotateCcw,
    .chevron => expanded ? _Glyphs.chevronUp : _Glyphs.chevronDown,
    .pending => _Glyphs.circle,
    .active => _Glyphs.circleDot,
    .completed => _Glyphs.check,
    .cancelled => _Glyphs.x,
    .error => _Glyphs.circleAlert,
    .tool => _Glyphs.squareTerminal,
    .loading => _Glyphs.loaderCircle,
    .completedCircle => _Glyphs.circleCheck,
    .cancelledCircle => _Glyphs.ban,
    .errorCircle => _Glyphs.circleX,
    .permission => _Glyphs.shieldCheck,
    .latest => _Glyphs.arrowDown,
  };

  @override
  Widget build(BuildContext context) {
    final theme = IconTheme.of(context);
    final opacity = spec.opacity ?? theme.opacity;
    final baseColor = spec.color ?? theme.color;
    final color = opacity == null || baseColor == null
        ? baseColor
        : baseColor.withValues(alpha: baseColor.a * opacity.clamp(0, 1));

    final icon = Icon(
      _icon,
      size: spec.size ?? theme.size,
      fill: spec.fill ?? theme.fill,
      weight: spec.weight ?? theme.weight,
      grade: spec.grade ?? theme.grade,
      opticalSize: spec.opticalSize ?? theme.opticalSize,
      color: color,
      shadows: spec.shadows ?? theme.shadows,
      textDirection: spec.textDirection,
      applyTextScaling:
          spec.applyTextScaling ?? theme.applyTextScaling ?? false,
      blendMode: spec.blendMode ?? BlendMode.srcOver,
    );
    return ExcludeSemantics(
      child: kind == UiFunctionalGlyphKind.loading
          ? _LoadingGlyph(child: icon)
          : icon,
    );
  }
}

/// Animate only indeterminate loading; status labels own the semantics.
class _LoadingGlyph extends StatefulWidget {
  const _LoadingGlyph({required this.child});

  final Widget child;

  @override
  State<_LoadingGlyph> createState() => _LoadingGlyphState();
}

class _LoadingGlyphState extends State<_LoadingGlyph>
    with SingleTickerProviderStateMixin {
  late final _turns = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final animate =
        !(MediaQuery.maybeDisableAnimationsOf(context) ?? false) &&
        TickerMode.valuesOf(context).enabled;
    if (animate) {
      if (!_turns.isAnimating) _turns.repeat();
    } else {
      _turns.stop();
      _turns.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) =>
      RotationTransition(turns: _turns, child: widget.child);

  @override
  void dispose() {
    _turns.dispose();
    super.dispose();
  }
}
