part of 'select.dart';

/// Where the new selection sits in [RemixSelect.items] relative to the one
/// it replaces. The placeholder counts as coming before the first item.
enum RemixSelectLabelDirection {
  /// The new selection comes later in the items.
  later,

  /// The new selection comes earlier in the items, or the selection was
  /// cleared back to the placeholder.
  earlier,
}

/// What a [RemixSelectLabelTransitionBuilder] receives for one trigger label.
@immutable
final class RemixSelectLabelTransitionInfo {
  const RemixSelectLabelTransitionInfo({
    required this.animation,
    required this.entering,
    required this.direction,
  });

  /// Runs from `0.0` to `1.0` while the new label arrives, paced by
  /// [RemixSelectLabelTransition.duration], and from `1.0` back to `0.0`
  /// while the old label leaves, paced by
  /// [RemixSelectLabelTransition.reverseDuration]. It is linear: apply a
  /// curve in the builder.
  final Animation<double> animation;

  /// Whether this is the label arriving. The label leaving gets `false`.
  final bool entering;

  /// Which way the selection moved, the same for both labels of one change.
  final RemixSelectLabelDirection direction;
}

/// Wraps one trigger label. `label` is the styled label or placeholder text.
typedef RemixSelectLabelTransitionBuilder =
    Widget Function(
      BuildContext context,
      RemixSelectLabelTransitionInfo info,
      Widget label,
    );

/// How the trigger's label changes when the selection changes.
///
/// Set it from a style, so a preset's recipe owns the motion:
///
/// ```dart
/// SelectTriggerStyler().labelTransition(
///   RemixSelectLabelTransition(
///     duration: const Duration(milliseconds: 200),
///     reverseDuration: const Duration(milliseconds: 150),
///     builder: (context, info, label) => FadeTransition(
///       opacity: info.animation,
///       child: label,
///     ),
///   ),
/// )
/// ```
///
/// The old and the new label overlap in the label's place while the old one
/// leaves. The leaving label is hidden from semantics.
///
/// While the user asks to reduce motion the label changes at once. Without a
/// transition the label changes at once.
@immutable
final class RemixSelectLabelTransition {
  const RemixSelectLabelTransition({
    required this.builder,
    this.duration = const Duration(milliseconds: 200),
    this.reverseDuration,
  });

  /// Wraps each label.
  final RemixSelectLabelTransitionBuilder builder;

  /// How long the new label takes to arrive.
  final Duration duration;

  /// How long the old label takes to leave. Defaults to [duration].
  final Duration? reverseDuration;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RemixSelectLabelTransition &&
          builder == other.builder &&
          duration == other.duration &&
          reverseDuration == other.reverseDuration;

  @override
  int get hashCode => Object.hash(builder, duration, reverseDuration);

  @override
  String toString() =>
      'RemixSelectLabelTransition(duration: $duration, '
      'reverseDuration: $reverseDuration)';
}

/// One label the switcher shows, with its own animation.
final class _RemixSelectLabelEntry {
  _RemixSelectLabelEntry({
    required this.selection,
    required this.index,
    required this.label,
    required this.controller,
    required this.direction,
  });

  final Object selection;
  final int index;
  Widget label;
  final AnimationController controller;
  RemixSelectLabelDirection direction;
}

/// Plays a [RemixSelectLabelTransition] each time [selection] changes.
class _RemixSelectLabelSwitcher extends StatefulWidget {
  const _RemixSelectLabelSwitcher({
    required this.selection,
    required this.index,
    required this.transition,
    required this.label,
  });

  /// Identifies the selection the label shows. A new value is a change.
  final Object selection;

  /// The selection's position in the items, `-1` for the placeholder.
  final int index;
  final RemixSelectLabelTransition? transition;
  final Widget label;

  @override
  State<_RemixSelectLabelSwitcher> createState() =>
      _RemixSelectLabelSwitcherState();
}

class _RemixSelectLabelSwitcherState extends State<_RemixSelectLabelSwitcher>
    with TickerProviderStateMixin {
  late _RemixSelectLabelEntry _current;
  final _leaving = <_RemixSelectLabelEntry>[];

  @override
  void initState() {
    super.initState();
    _current = _entry(value: 1);
  }

  _RemixSelectLabelEntry _entry({required double value}) {
    final transition = widget.transition;
    return _RemixSelectLabelEntry(
      selection: widget.selection,
      index: widget.index,
      label: widget.label,
      direction: .later,
      controller: AnimationController(
        vsync: this,
        value: value,
        duration: transition?.duration,
        reverseDuration: transition?.reverseDuration ?? transition?.duration,
      ),
    );
  }

  @override
  void didUpdateWidget(_RemixSelectLabelSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    final transition = widget.transition;
    if (transition == null || remixReducedMotionOf(context)) {
      _clearLeaving();
    }
    if (widget.selection == _current.selection) {
      _current.label = widget.label;
      if (transition != null) {
        _current.controller
          ..duration = transition.duration
          ..reverseDuration = transition.reverseDuration ?? transition.duration;
      }
      return;
    }

    final direction = widget.index > _current.index
        ? RemixSelectLabelDirection.later
        : RemixSelectLabelDirection.earlier;
    final outgoing = _current;
    final animate = transition != null && !remixReducedMotionOf(context);
    _current = _entry(value: animate ? 0 : 1)..direction = direction;
    if (!animate) {
      outgoing.controller.dispose();
      return;
    }

    _current.controller.forward();
    outgoing.direction = direction;
    _leaving.add(outgoing);
    outgoing.controller
      ..duration = transition.duration
      ..reverseDuration = transition.reverseDuration ?? transition.duration
      ..reverse().whenCompleteOrCancel(() {
        if (!mounted || !_leaving.remove(outgoing)) return;
        outgoing.controller.dispose();
        setState(() {});
      });
  }

  void _clearLeaving() {
    for (final entry in _leaving) {
      entry.controller.dispose();
    }
    _leaving.clear();
  }

  @override
  void dispose() {
    _clearLeaving();
    _current.controller.dispose();
    super.dispose();
  }

  Widget _build(
    RemixSelectLabelTransition transition,
    _RemixSelectLabelEntry entry, {
    required bool entering,
  }) {
    final label = transition.builder(
      context,
      RemixSelectLabelTransitionInfo(
        animation: entry.controller.view,
        entering: entering,
        direction: entry.direction,
      ),
      entry.label,
    );

    return KeyedSubtree(
      key: ObjectKey(entry),
      child: entering ? label : ExcludeSemantics(child: label),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transition = widget.transition;
    if (transition == null) return widget.label;

    // A Stack even with one label, so the arriving label keeps its element
    // when the leaving one is removed.
    return Stack(
      alignment: AlignmentDirectional.centerStart,
      children: [
        for (final entry in _leaving)
          _build(transition, entry, entering: false),
        _build(transition, _current, entering: true),
      ],
    );
  }
}
