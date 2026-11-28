part of 'textfield.dart';

/// What a [RemixFieldMessageTransitionBuilder] receives for one message row.
@immutable
final class RemixFieldMessageTransitionInfo {
  const RemixFieldMessageTransitionInfo({
    required this.animation,
    required this.text,
  });

  /// Runs from `0.0` to `1.0` while the row appears and back to `0.0` while
  /// it leaves. It is paced by [RemixFieldMessageTransition.duration] and
  /// [RemixFieldMessageTransition.reverseDuration] and is linear: apply a
  /// curve in the builder.
  ///
  /// The row stays in the layout until the animation is dismissed.
  final Animation<double> animation;

  /// The message the row shows. While the row leaves it is the last message
  /// it showed. A new message on a row that is already shown updates it in
  /// place, so a builder that animates the change between two messages reads
  /// it from here.
  final String text;
}

/// Wraps one message row of a field, the helper row or the error row.
///
/// `row` is the styled message text.
typedef RemixFieldMessageTransitionBuilder =
    Widget Function(
      BuildContext context,
      RemixFieldMessageTransitionInfo info,
      Widget row,
    );

/// How a field's helper and error rows appear and leave.
///
/// Set it from a style, so a preset's recipe owns the motion:
///
/// ```dart
/// TextFieldStyler().messageTransition(
///   RemixFieldMessageTransition(
///     duration: const Duration(milliseconds: 200),
///     reverseDuration: const Duration(milliseconds: 100),
///     builder: (context, info, row) => SizeTransition(
///       sizeFactor: info.animation,
///       child: FadeTransition(opacity: info.animation, child: row),
///     ),
///   ),
/// )
/// ```
///
/// The layout's spacing before a row stays until the row has left. A recipe
/// that collapses the gap with the row puts the gap in the row's own padding.
///
/// While the user asks to reduce motion the rows appear and leave at once.
/// Without a transition a row appears and leaves at once.
@immutable
final class RemixFieldMessageTransition {
  const RemixFieldMessageTransition({
    required this.builder,
    this.duration = const Duration(milliseconds: 200),
    this.reverseDuration,
  });

  /// Wraps the row.
  final RemixFieldMessageTransitionBuilder builder;

  /// How long a row takes to appear.
  final Duration duration;

  /// How long a row takes to leave. Defaults to [duration].
  final Duration? reverseDuration;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RemixFieldMessageTransition &&
          builder == other.builder &&
          duration == other.duration &&
          reverseDuration == other.reverseDuration;

  @override
  int get hashCode => Object.hash(builder, duration, reverseDuration);

  @override
  String toString() =>
      'RemixFieldMessageTransition(duration: $duration, '
      'reverseDuration: $reverseDuration)';
}

/// One message row. It plays its entrance when mounted with [visible] set,
/// plays its exit when [visible] clears, and then calls [onExited] so the
/// field can drop it from the layout.
class _RemixFieldMessageRow extends StatefulWidget {
  const _RemixFieldMessageRow({
    super.key,
    required this.text,
    required this.visible,
    required this.styleSpec,
    required this.transition,
    required this.animateEntrance,
    required this.onExited,
  });

  final String text;
  final bool visible;

  /// Whether a row mounted shown plays its entrance. Rows shown when the
  /// field first builds start at rest.
  final bool animateEntrance;
  final StyleSpec<TextSpec> styleSpec;
  final RemixFieldMessageTransition? transition;
  final VoidCallback onExited;

  @override
  State<_RemixFieldMessageRow> createState() => _RemixFieldMessageRowState();
}

class _RemixFieldMessageRowState extends State<_RemixFieldMessageRow>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  bool _wasBuilt = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(_RemixFieldMessageRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  void _sync() {
    final transition = widget.transition;
    if (transition == null) {
      _controller?.stop();
      if (!widget.visible) _reportExited();
      return;
    }
    // A row that was already shown without a transition starts at rest.
    final controller = _controller ??= AnimationController(
      vsync: this,
      value: widget.visible && (_wasBuilt || !widget.animateEntrance) ? 1 : 0,
    )..addStatusListener(_onStatus);
    controller
      ..duration = transition.duration
      ..reverseDuration = transition.reverseDuration ?? transition.duration;

    final reduceMotion = remixReducedMotionOf(context);
    if (widget.visible) {
      if (reduceMotion) {
        controller.value = 1;
      } else if (!controller.isForwardOrCompleted) {
        controller.forward();
      }
    } else if (reduceMotion || controller.isDismissed) {
      controller.value = 0;
      _reportExited();
    } else if (controller.isForwardOrCompleted) {
      controller.reverse();
    }
  }

  void _onStatus(AnimationStatus status) {
    if (status.isDismissed && !widget.visible) _reportExited();
  }

  // Deferred: the exit can finish while the field is building, and the field
  // rebuilds to drop the row.
  void _reportExited() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || widget.visible) return;
      final controller = _controller;
      if (controller != null &&
          widget.transition != null &&
          !controller.isDismissed) {
        return;
      }
      widget.onExited();
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _wasBuilt = true;
    final row = ExcludeSemantics(
      child: StyledText(widget.text, styleSpec: widget.styleSpec),
    );
    final transition = widget.transition;
    final controller = _controller;
    if (transition == null || controller == null) return row;

    return transition.builder(
      context,
      RemixFieldMessageTransitionInfo(
        animation: controller.view,
        text: widget.text,
      ),
      row,
    );
  }
}
