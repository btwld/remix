import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'timing.dart';
import 'visual.dart';

/// Which way swapped content travels: [up] brings the new child up from
/// below and lifts the old one away; [down] mirrors it.
enum UiSwapDirection { up, down }

/// One side of a swap: the [visual] an entering child starts from, or an
/// exiting child ends at, and how each channel gets there.
@immutable
final class UiSwapPhase {
  const UiSwapPhase({required this.visual, required this.timing});

  final UiVisual visual;
  final UiVisualTiming timing;

  UiSwapPhase _mirrored() => UiSwapPhase(
    visual: UiVisual(
      opacity: visual.opacity,
      offset: -visual.offset,
      scale: visual.scale,
      blur: visual.blur,
    ),
    timing: timing,
  );
}

/// The enter and exit phases of a [UiSwap].
@immutable
final class UiSwapMotion {
  const UiSwapMotion({required this.enter, required this.exit});

  /// Text changing in place (badge labels, status lines): the new text rises
  /// 0.3 em out of a 4 px blur over 200 ms, the old one lifts 0.3 em into a
  /// 2 px blur over 150 ms.
  factory UiSwapMotion.text({required double fontSize}) => UiSwapMotion(
    enter: UiSwapPhase(
      visual: UiVisual(
        opacity: 0,
        offset: Offset(0, 0.3 * fontSize),
        blur: UiMotion.blurSoft,
      ),
      timing: const UiVisualTiming.all(UiTiming.enter),
    ),
    exit: UiSwapPhase(
      visual: UiVisual(
        opacity: 0,
        offset: Offset(0, -0.3 * fontSize),
        blur: UiMotion.blurSubtle,
      ),
      timing: const UiVisualTiming.all(UiTiming.fade),
    ),
  );

  /// One icon replacing another: the new icon grows from 0.6 out of a 2 px
  /// blur on the snappy spring, the old one shrinks back into it over 150 ms.
  static const icon = UiSwapMotion(
    enter: UiSwapPhase(
      visual: UiVisual(opacity: 0, scale: 0.6, blur: UiMotion.blurSubtle),
      timing: UiVisualTiming.all(UiTiming.snappy),
    ),
    exit: UiSwapPhase(
      visual: UiVisual(opacity: 0, scale: 0.6, blur: UiMotion.blurSubtle),
      timing: UiVisualTiming.all(UiTiming.fade),
    ),
  );

  /// Opacity only, over [UiTiming.instant]: what every swap does under
  /// reduced motion.
  static const reduced = UiSwapMotion(
    enter: UiSwapPhase(
      visual: UiVisual(opacity: 0),
      timing: UiVisualTiming.all(UiTiming.instant),
    ),
    exit: UiSwapPhase(
      visual: UiVisual(opacity: 0),
      timing: UiVisualTiming.all(UiTiming.instant),
    ),
  );

  final UiSwapPhase enter;
  final UiSwapPhase exit;

  UiSwapMotion _toward(UiSwapDirection direction) =>
      direction == UiSwapDirection.up
      ? this
      : UiSwapMotion(enter: enter._mirrored(), exit: exit._mirrored());
}

/// Cross-swaps its child when the child's key or type changes: the old child
/// plays [motion]'s exit while the new one plays its enter, in the same spot.
///
/// The outgoing child leaves layout at once and keeps painting at its last
/// size, so the swap sizes to the new child only. Wrap it in a
/// `UiSizeMorph` to spring between the two sizes.
///
/// With [UiSwapMotion.icon] this is the icon switcher. `UiTextSwap`
/// builds it for strings.
class UiSwap extends StatefulWidget {
  const UiSwap({
    super.key,
    this.motion = UiSwapMotion.icon,
    this.direction = UiSwapDirection.up,
    this.alignment = AlignmentDirectional.centerStart,
    required this.child,
  });

  final UiSwapMotion motion;
  final UiSwapDirection direction;

  /// Where the children sit when their sizes differ.
  final AlignmentGeometry alignment;

  final Widget child;

  @override
  State<UiSwap> createState() => _UiSwapState();
}

final class _SwapEntry {
  _SwapEntry(this.child, {required this.entering});

  Widget child;
  final bool entering;
  final Key key = UniqueKey();
  bool exiting = false;
  Size? size;
}

class _UiSwapState extends State<UiSwap> {
  late final List<_SwapEntry> _entries = [
    _SwapEntry(widget.child, entering: false),
  ];

  @override
  void didUpdateWidget(UiSwap oldWidget) {
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
            ? UiSwapMotion.reduced
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
                  child: UiAnimatedVisual(
                    visual: entry.exiting ? motion.exit.visual : UiVisual.rest,
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
/// [UiMotion.staggerWord] after the one before; the old text leaves as
/// one line. Under reduced motion the text crossfades.
class UiTextSwap extends StatefulWidget {
  const UiTextSwap(
    this.text, {
    super.key,
    this.style,
    this.direction = UiSwapDirection.up,
    this.staggerWords = false,
    this.alignment = AlignmentDirectional.centerStart,
  });

  final String text;
  final TextStyle? style;
  final UiSwapDirection direction;
  final bool staggerWords;
  final AlignmentGeometry alignment;

  @override
  State<UiTextSwap> createState() => _UiTextSwapState();
}

class _UiTextSwapState extends State<UiTextSwap> {
  bool _changed = false;

  @override
  void didUpdateWidget(UiTextSwap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) _changed = true;
  }

  @override
  Widget build(BuildContext context) {
    final style = DefaultTextStyle.of(context).style.merge(widget.style);
    final motion = UiSwapMotion.text(
      fontSize: style.fontSize ?? 14,
    )._toward(widget.direction);

    return RemixReducedMotionBuilder(
      builder: (context, reduceMotion) {
        final staggered = widget.staggerWords && !reduceMotion;

        return UiSwap(
          motion: staggered
              ? UiSwapMotion(
                  enter: UiSwapPhase(
                    visual: UiVisual.rest,
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
  final UiSwapPhase? enter;

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
              child: UiAnimatedVisual(
                visual: UiVisual.rest,
                timing: enter == null
                    ? const UiVisualTiming.all(UiTiming.enter)
                    : enter.timing.delayed(UiMotion.staggerWord * index),
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
