import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Headless text magnifier built on [RawMagnifier].
///
/// Positioning follows the Android loupe rules: the lens tracks the gesture
/// along the current line, stays on screen, and animates only when the caret
/// jumps between lines. Visuals come from [decoration].
class NakedTextMagnifier extends StatefulWidget {
  /// Creates a magnifier that follows [magnifierInfo].
  const NakedTextMagnifier({
    super.key,
    required this.magnifierInfo,
    this.size = const Size(80, 40),
    this.magnificationScale = 1.25,
    this.decoration = const MagnifierDecoration(),
    this.verticalFocalPointShift = 22,
    this.lineJumpDuration = const Duration(milliseconds: 70),
  });

  /// Gesture and caret geometry from the text field.
  final ValueNotifier<MagnifierInfo> magnifierInfo;

  /// Lens size. Does not include decoration shadows.
  final Size size;

  /// How far the lens zooms. `1` is no magnification.
  final double magnificationScale;

  /// Shape, shadows, and opacity of the lens.
  final MagnifierDecoration decoration;

  /// How far above the caret the lens sits.
  final double verticalFocalPointShift;

  /// Duration of the animation when the caret changes lines.
  final Duration lineJumpDuration;

  /// A [TextMagnifierConfiguration] that builds this magnifier.
  static TextMagnifierConfiguration configuration({
    Size size = const Size(80, 40),
    double magnificationScale = 1.25,
    MagnifierDecoration decoration = const MagnifierDecoration(),
    double verticalFocalPointShift = 22,
    Duration lineJumpDuration = const Duration(milliseconds: 70),
    bool shouldDisplayHandlesInMagnifier = false,
  }) {
    return TextMagnifierConfiguration(
      shouldDisplayHandlesInMagnifier: shouldDisplayHandlesInMagnifier,
      magnifierBuilder: (context, controller, magnifierInfo) {
        return NakedTextMagnifier(
          magnifierInfo: magnifierInfo,
          size: size,
          magnificationScale: magnificationScale,
          decoration: decoration,
          verticalFocalPointShift: verticalFocalPointShift,
          lineJumpDuration: lineJumpDuration,
        );
      },
    );
  }

  /// Android, iOS, and Fuchsia use [configuration]. Desktop platforms return
  /// [TextMagnifierConfiguration.disabled]. On the web this follows the
  /// browser's platform, so mobile browsers get the lens.
  static TextMagnifierConfiguration adaptiveConfiguration() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        return configuration();
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return TextMagnifierConfiguration.disabled;
    }
  }

  @override
  State<NakedTextMagnifier> createState() => _NakedTextMagnifierState();
}

class _NakedTextMagnifierState extends State<NakedTextMagnifier> {
  Offset? _magnifierPosition;
  Timer? _lineJumpTimer;
  Offset _extraFocalPointOffset = Offset.zero;

  bool get _animatingLineJump => _lineJumpTimer != null;

  @override
  void initState() {
    super.initState();
    widget.magnifierInfo.addListener(_position);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _position();
  }

  @override
  void didUpdateWidget(NakedTextMagnifier oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.magnifierInfo != widget.magnifierInfo) {
      oldWidget.magnifierInfo.removeListener(_position);
      widget.magnifierInfo.addListener(_position);
    }
  }

  @override
  void dispose() {
    widget.magnifierInfo.removeListener(_position);
    _lineJumpTimer?.cancel();
    super.dispose();
  }

  void _position() {
    final info = widget.magnifierInfo.value;
    final screenRect = Offset.zero & MediaQuery.sizeOf(context);
    final size = widget.size;
    final basicOffset = Offset(
      size.width / 2,
      size.height + widget.verticalFocalPointShift,
    );
    final magnifierX = clampDouble(
      info.globalGesturePosition.dx,
      info.currentLineBoundaries.left,
      info.currentLineBoundaries.right,
    );
    final unadjusted =
        Offset(magnifierX, info.caretRect.center.dy) - basicOffset & size;
    final adjusted = MagnifierController.shiftWithinBounds(
      bounds: screenRect,
      rect: unadjusted,
    );
    final position = adjusted.topLeft;
    final horizontalInset = (size.width / 2) / widget.magnificationScale;
    final double focalX;
    if (info.fieldBounds.width < horizontalInset * 2) {
      focalX = info.fieldBounds.center.dx;
    } else {
      focalX = clampDouble(
        adjusted.center.dx,
        info.fieldBounds.left + horizontalInset,
        info.fieldBounds.right - horizontalInset,
      );
    }
    final focal = Offset(
      focalX - adjusted.center.dx,
      unadjusted.top - adjusted.top,
    );

    Timer? lineJump = _lineJumpTimer;
    if (_magnifierPosition != null && position.dy != _magnifierPosition!.dy) {
      _lineJumpTimer?.cancel();
      lineJump = Timer(widget.lineJumpDuration, () {
        if (!mounted) return;
        setState(() => _lineJumpTimer = null);
      });
    }

    setState(() {
      _magnifierPosition = position;
      _lineJumpTimer = lineJump;
      _extraFocalPointOffset = focal;
    });
  }

  @override
  Widget build(BuildContext context) {
    final position = _magnifierPosition;
    if (position == null) return const SizedBox.shrink();

    return AnimatedPositioned(
      top: position.dy,
      left: position.dx,
      duration: _animatingLineJump ? widget.lineJumpDuration : Duration.zero,
      child: RawMagnifier(
        size: widget.size,
        decoration: widget.decoration,
        magnificationScale: widget.magnificationScale,
        focalPointOffset:
            _extraFocalPointOffset +
            Offset(0, widget.verticalFocalPointShift + widget.size.height / 2),
      ),
    );
  }
}
