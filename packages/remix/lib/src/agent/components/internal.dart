import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

/// Publishes a lifecycle value, such as a tool call's status, to the styles
/// resolved below it, so a styler's variants can read it.
@internal
final class AgentValueScope<T extends Enum> extends InheritedWidget {
  const AgentValueScope({super.key, required this.value, required super.child});

  final T value;

  static T? maybeOf<T extends Enum>(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AgentValueScope<T>>()?.value;

  @override
  bool updateShouldNotify(AgentValueScope<T> oldWidget) =>
      value != oldWidget.value;
}

/// One stable variant per value of [values], applied while the nearest
/// [AgentValueScope] of `T` holds that value.
@internal
Map<T, ContextVariant> agentValueVariants<T extends Enum>(
  String prefix,
  List<T> values,
) => {
  for (final value in values)
    value: ContextVariant(
      '$prefix.${value.name}',
      (context) => AgentValueScope.maybeOf<T>(context) == value,
    ),
};

/// Formats a duration the way the Agent surfaces show it: `840ms`, `2.9s`,
/// `1m 5s`.
@internal
String agentFormatDuration(Duration duration) {
  final milliseconds = duration.inMilliseconds;
  if (milliseconds < 1000) return '${milliseconds}ms';
  if (milliseconds < 60000) {
    final tenths = (milliseconds / 100).round();
    final whole = tenths ~/ 10;
    final fraction = tenths % 10;

    return fraction == 0 ? '${whole}s' : '$whole.${fraction}s';
  }
  final seconds = duration.inSeconds;

  return '${seconds ~/ 60}m ${seconds % 60}s';
}

/// [duration] in whole seconds, rounded up as `AgentRunClock.elapsedSeconds`
/// counts them.
@internal
int agentCeilSeconds(Duration duration) =>
    (duration.inMicroseconds + Duration.microsecondsPerSecond - 1) ~/
    Duration.microsecondsPerSecond;

/// Lays its child out at full height, clips it to [maxHeight] while [clip] is
/// true, and reports whether the child is taller than [maxHeight].
@internal
final class AgentOverflowClip extends SingleChildRenderObjectWidget {
  const AgentOverflowClip({
    super.key,
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
      _RenderAgentOverflowClip(maxHeight, clip, onOverflowChanged);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderAgentOverflowClip renderObject,
  ) {
    renderObject
      ..maxHeight = maxHeight
      ..clip = clip
      ..onOverflowChanged = onOverflowChanged;
  }
}

class _RenderAgentOverflowClip extends RenderProxyBox {
  _RenderAgentOverflowClip(this._maxHeight, this._clip, this.onOverflowChanged);

  double? _maxHeight;
  bool _clip;
  ValueChanged<bool> onOverflowChanged;
  bool _overflows = false;

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
    final overflows = limit != null && current.size.height > limit;
    size = constraints.constrain(
      Size(
        current.size.width,
        _clip && overflows ? limit : current.size.height,
      ),
    );
    if (overflows != _overflows) {
      _overflows = overflows;
      // Layout cannot rebuild; the owner hears about it after the frame.
      SchedulerBinding.instance.addPostFrameCallback(
        (_) => onOverflowChanged(overflows),
      );
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) return;
    if (!_clip) {
      super.paint(context, offset);
      return;
    }
    context.pushClipRect(
      needsCompositing,
      offset,
      Offset.zero & size,
      super.paint,
    );
  }
}
