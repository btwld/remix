import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'timing.dart';
import 'visual.dart';

/// Which way swapped content travels: [up] brings the new child up from
/// below and lifts the old one away; [down] mirrors it.
enum FortalSwapDirection { up, down }

/// One side of a swap: the [visual] an entering child starts from, or an
/// exiting child ends at, and how each channel gets there.
@immutable
final class FortalSwapPhase {
  const FortalSwapPhase({required this.visual, required this.timing});

  final FortalVisual visual;
  final FortalVisualTiming timing;

  FortalSwapPhase _mirrored() => FortalSwapPhase(
    visual: FortalVisual(
      opacity: visual.opacity,
      offset: -visual.offset,
      scale: visual.scale,
      blur: visual.blur,
    ),
    timing: timing,
  );
}

/// The enter and exit phases of a [FortalSwap].
@immutable
final class FortalSwapMotion {
  const FortalSwapMotion({required this.enter, required this.exit});

  /// Text changing in place (badge labels, status lines): the new text rises
  /// 0.3 em out of a 4 px blur over 200 ms, the old one lifts 0.3 em into a
  /// 2 px blur over 150 ms.
  factory FortalSwapMotion.text({required double fontSize}) => FortalSwapMotion(
    enter: FortalSwapPhase(
      visual: FortalVisual(
        opacity: 0,
        offset: Offset(0, 0.3 * fontSize),
        blur: FortalMotion.blurSoft,
      ),
      timing: const FortalVisualTiming.all(FortalTiming.enter),
    ),
    exit: FortalSwapPhase(
      visual: FortalVisual(
        opacity: 0,
        offset: Offset(0, -0.3 * fontSize),
        blur: FortalMotion.blurSubtle,
      ),
      timing: const FortalVisualTiming.all(FortalTiming.fade),
    ),
  );

  /// One icon replacing another: the new icon grows from 0.6 out of a 2 px
  /// blur on the snappy spring, the old one shrinks back into it over 150 ms.
  static const icon = FortalSwapMotion(
    enter: FortalSwapPhase(
      visual: FortalVisual(
        opacity: 0,
        scale: 0.6,
        blur: FortalMotion.blurSubtle,
      ),
      timing: FortalVisualTiming.all(FortalTiming.snappy),
    ),
    exit: FortalSwapPhase(
      visual: FortalVisual(
        opacity: 0,
        scale: 0.6,
        blur: FortalMotion.blurSubtle,
      ),
      timing: FortalVisualTiming.all(FortalTiming.fade),
    ),
  );

  /// Opacity only, over [FortalTiming.instant]: what every swap does under
  /// reduced motion.
  static const reduced = FortalSwapMotion(
    enter: FortalSwapPhase(
      visual: FortalVisual(opacity: 0),
      timing: FortalVisualTiming.all(FortalTiming.instant),
    ),
    exit: FortalSwapPhase(
      visual: FortalVisual(opacity: 0),
      timing: FortalVisualTiming.all(FortalTiming.instant),
    ),
  );

  final FortalSwapPhase enter;
  final FortalSwapPhase exit;

  FortalSwapMotion _toward(FortalSwapDirection direction) =>
      direction == FortalSwapDirection.up
      ? this
      : FortalSwapMotion(enter: enter._mirrored(), exit: exit._mirrored());
}

/// Cross-swaps its child when the child's key or type changes: the old child
/// plays [motion]'s exit while the new one plays its enter, in the same spot.
///
/// The outgoing child leaves layout at once and keeps painting at its last
/// size, so the swap sizes to the new child only. Wrap it in a
/// `FortalSizeMorph` to spring between the two sizes.
///
/// With [FortalSwapMotion.icon] this is the icon switcher. `FortalTextSwap`
/// builds it for strings.
class FortalSwap extends StatefulWidget {
  const FortalSwap({
    super.key,
    this.motion = FortalSwapMotion.icon,
    this.direction = FortalSwapDirection.up,
    this.alignment = AlignmentDirectional.centerStart,
    required this.child,
  });

  final FortalSwapMotion motion;
  final FortalSwapDirection direction;

  /// Where the children sit when their sizes differ.
  final AlignmentGeometry alignment;

  final Widget child;

  @override
  State<FortalSwap> createState() => _FortalSwapState();
}

final class _SwapEntry {
  _SwapEntry(this.child, {required this.entering});

  Widget child;
  final bool entering;
  final Key key = UniqueKey();
  bool exiting = false;
  Size? size;
}

class _FortalSwapState extends State<FortalSwap> {
  late final List<_SwapEntry> _entries = [
    _SwapEntry(widget.child, entering: false),
  ];

  @override
  void didUpdateWidget(FortalSwap oldWidget) {
    super.didUpdateWidget(oldWidget);
    final current = _entries.last;
    if (Widget.canUpdate(current.child, widget.child)) {
      current.child = widget.child;

      return;
    }
    current.exiting = true;
    _entries.add(_SwapEntry(widget.child, entering: true));
  }

  void _remove(_SwapEntry entry) {
    if (!mounted || !_entries.contains(entry)) return;
    setState(() => _entries.remove(entry));
  }

  @override
  Widget build(BuildContext context) {
    return RemixReducedMotionBuilder(
      builder: (context, reduceMotion) {
        final motion = reduceMotion
            ? FortalSwapMotion.reduced
            : widget.motion._toward(widget.direction);

        return Stack(
          alignment: widget.alignment,
          clipBehavior: Clip.none,
          children: [
            for (final entry in _entries)
              Positioned(
                key: entry.key,
                width: entry.exiting ? entry.size?.width : null,
                height: entry.exiting ? entry.size?.height : null,
                child: _SizeProbe(
                  onSize: (size) => entry.size = size,
                  child: FortalAnimatedVisual(
                    visual: entry.exiting
                        ? motion.exit.visual
                        : FortalVisual.rest,
                    timing: entry.exiting
                        ? motion.exit.timing
                        : motion.enter.timing,
                    initial: entry.entering ? motion.enter.visual : null,
                    onEnd: entry.exiting ? () => _remove(entry) : null,
                    child: entry.child,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Swaps [text] with a blur and rise when it changes, sized to the new
/// string.
///
/// With [staggerWords], each word of the new text enters on its own,
/// [FortalMotion.staggerWord] after the one before; the old text leaves as
/// one line. Under reduced motion the text crossfades.
class FortalTextSwap extends StatefulWidget {
  const FortalTextSwap(
    this.text, {
    super.key,
    this.style,
    this.direction = FortalSwapDirection.up,
    this.staggerWords = false,
    this.alignment = AlignmentDirectional.centerStart,
  });

  final String text;
  final TextStyle? style;
  final FortalSwapDirection direction;
  final bool staggerWords;
  final AlignmentGeometry alignment;

  @override
  State<FortalTextSwap> createState() => _FortalTextSwapState();
}

class _FortalTextSwapState extends State<FortalTextSwap> {
  bool _changed = false;

  @override
  void didUpdateWidget(FortalTextSwap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) _changed = true;
  }

  @override
  Widget build(BuildContext context) {
    final style = DefaultTextStyle.of(context).style.merge(widget.style);
    final motion = FortalSwapMotion.text(
      fontSize: style.fontSize ?? 14,
    )._toward(widget.direction);

    return RemixReducedMotionBuilder(
      builder: (context, reduceMotion) {
        final staggered = widget.staggerWords && !reduceMotion;

        return FortalSwap(
          motion: staggered
              ? FortalSwapMotion(
                  enter: FortalSwapPhase(
                    visual: FortalVisual.rest,
                    timing: motion.enter.timing,
                  ),
                  exit: motion.exit,
                )
              : motion,
          alignment: widget.alignment,
          child: staggered
              ? _StaggeredWords(
                  key: ValueKey(widget.text),
                  text: widget.text,
                  style: style,
                  enter: _changed ? motion.enter : null,
                )
              : Text(widget.text, key: ValueKey(widget.text), style: style),
        );
      },
    );
  }
}

class _StaggeredWords extends StatelessWidget {
  const _StaggeredWords({
    super.key,
    required this.text,
    required this.style,
    required this.enter,
  });

  final String text;
  final TextStyle style;
  final FortalSwapPhase? enter;

  @override
  Widget build(BuildContext context) {
    final words = text.split(' ');
    final enter = this.enter;

    return Text.rich(
      TextSpan(
        children: [
          for (var index = 0; index < words.length; index++) ...[
            if (index > 0) const TextSpan(text: ' '),
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: FortalAnimatedVisual(
                visual: FortalVisual.rest,
                timing: enter == null
                    ? const FortalVisualTiming.all(FortalTiming.enter)
                    : enter.timing.delayed(FortalMotion.staggerWord * index),
                initial: enter?.visual,
                child: Text(words[index], style: style),
              ),
            ),
          ],
        ],
      ),
      style: style,
    );
  }
}

class _SizeProbe extends SingleChildRenderObjectWidget {
  const _SizeProbe({required this.onSize, super.child});

  final ValueChanged<Size> onSize;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderSizeProbe(onSize);

  @override
  void updateRenderObject(BuildContext context, _RenderSizeProbe renderObject) {
    renderObject.onSize = onSize;
  }
}

class _RenderSizeProbe extends RenderProxyBox {
  _RenderSizeProbe(this.onSize);

  ValueChanged<Size> onSize;

  @override
  void performLayout() {
    super.performLayout();
    onSize(size);
  }
}
