import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// Headless scrollbar built on [RawScrollbar].
///
/// Colors and thickness resolve against hovered and dragged states. When a
/// color property is null, the scrollbar uses [RawScrollbar]'s thumb color and
/// a transparent track.
class NakedScrollbar extends StatelessWidget {
  /// Creates a scrollbar over [child].
  const NakedScrollbar({
    super.key,
    required this.child,
    this.controller,
    this.thumbVisibility,
    this.trackVisibility,
    this.interactive,
    this.thumbColor,
    this.trackColor,
    this.trackBorderColor,
    this.thickness,
    this.radius,
    this.trackRadius,
    this.shape,
    this.minThumbLength = 18,
    this.mainAxisMargin = 0,
    this.crossAxisMargin = 0,
    this.minOverscrollLength,
    this.padding,
    this.fadeDuration = const Duration(milliseconds: 300),
    this.timeToFade = const Duration(milliseconds: 600),
    this.pressDuration = Duration.zero,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.scrollbarOrientation,
    this.onHoverChange,
    this.onDragChange,
  }) : assert(
         !(thumbVisibility == false && (trackVisibility ?? false)),
         'A scrollbar track cannot be drawn without a scrollbar thumb.',
       );

  /// The scrollable this scrollbar decorates.
  final Widget child;

  /// Scroll controller used for thumb dragging.
  final ScrollController? controller;

  /// Whether the thumb is always visible.
  final bool? thumbVisibility;

  /// Whether the track is visible.
  final bool? trackVisibility;

  /// Whether the thumb can be dragged.
  final bool? interactive;

  /// Thumb color for hovered and dragged states.
  final WidgetStateProperty<Color>? thumbColor;

  /// Track color for hovered and dragged states.
  final WidgetStateProperty<Color>? trackColor;

  /// Track border color for hovered and dragged states.
  final WidgetStateProperty<Color>? trackBorderColor;

  /// Thumb thickness for hovered and dragged states.
  final WidgetStateProperty<double>? thickness;

  /// Corner radius of the thumb.
  final Radius? radius;

  /// Corner radius of the track.
  final Radius? trackRadius;

  /// Shape of the thumb. Cannot be combined with [radius].
  final OutlinedBorder? shape;

  /// Minimum thumb length along the scroll axis.
  final double minThumbLength;

  /// Margin along the scroll axis.
  final double mainAxisMargin;

  /// Margin across the scroll axis.
  final double crossAxisMargin;

  /// Minimum thumb length while overscrolling.
  final double? minOverscrollLength;

  /// Padding around the scrollbar.
  final EdgeInsets? padding;

  /// How long the thumb takes to fade.
  final Duration fadeDuration;

  /// How long the thumb stays visible before fading.
  final Duration timeToFade;

  /// Delay before a thumb press becomes a drag.
  final Duration pressDuration;

  /// Which scroll notifications this scrollbar responds to.
  final ScrollNotificationPredicate notificationPredicate;

  /// Which side of the scrollable the scrollbar occupies.
  final ScrollbarOrientation? scrollbarOrientation;

  /// Called when the pointer enters or leaves the scrollbar.
  final ValueChanged<bool>? onHoverChange;

  /// Called when a thumb drag starts or ends.
  final ValueChanged<bool>? onDragChange;

  @override
  Widget build(BuildContext context) {
    return _NakedRawScrollbar(
      controller: controller,
      thumbVisibility: thumbVisibility,
      trackVisibility: trackVisibility,
      interactive: interactive,
      thumbColorProperty: thumbColor,
      trackColorProperty: trackColor,
      trackBorderColorProperty: trackBorderColor,
      thicknessProperty: thickness,
      radius: radius,
      trackRadius: trackRadius,
      shape: shape,
      minThumbLength: minThumbLength,
      mainAxisMargin: mainAxisMargin,
      crossAxisMargin: crossAxisMargin,
      minOverscrollLength: minOverscrollLength,
      padding: padding,
      fadeDuration: fadeDuration,
      timeToFade: timeToFade,
      pressDuration: pressDuration,
      notificationPredicate: notificationPredicate,
      scrollbarOrientation: scrollbarOrientation,
      onHoverChange: onHoverChange,
      onDragChange: onDragChange,
      child: child,
    );
  }
}

class _NakedRawScrollbar extends RawScrollbar {
  const _NakedRawScrollbar({
    required super.child,
    super.controller,
    super.thumbVisibility,
    super.trackVisibility,
    super.interactive,
    required this.thumbColorProperty,
    required this.trackColorProperty,
    required this.trackBorderColorProperty,
    required this.thicknessProperty,
    super.radius,
    super.trackRadius,
    super.shape,
    super.minThumbLength,
    super.mainAxisMargin,
    super.crossAxisMargin,
    super.minOverscrollLength,
    super.padding,
    super.fadeDuration,
    super.timeToFade,
    super.pressDuration,
    super.notificationPredicate,
    super.scrollbarOrientation,
    required this.onHoverChange,
    required this.onDragChange,
  });

  final WidgetStateProperty<Color>? thumbColorProperty;
  final WidgetStateProperty<Color>? trackColorProperty;
  final WidgetStateProperty<Color>? trackBorderColorProperty;
  final WidgetStateProperty<double>? thicknessProperty;
  final ValueChanged<bool>? onHoverChange;
  final ValueChanged<bool>? onDragChange;

  @override
  RawScrollbarState<_NakedRawScrollbar> createState() =>
      _NakedRawScrollbarState();
}

class _NakedRawScrollbarState extends RawScrollbarState<_NakedRawScrollbar> {
  static const Color _defaultThumbColor = Color(0x66BCBCBC);

  bool _hovered = false;
  bool _dragged = false;

  Set<WidgetState> get _states => <WidgetState>{
    if (_hovered) WidgetState.hovered,
    if (_dragged) WidgetState.dragged,
  };

  void _setHovered(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
    widget.onHoverChange?.call(value);
    updateScrollbarPainter();
  }

  void _setDragged(bool value) {
    if (_dragged == value) return;
    setState(() => _dragged = value);
    widget.onDragChange?.call(value);
    updateScrollbarPainter();
  }

  @override
  void updateScrollbarPainter() {
    final textDirection = Directionality.of(context);
    final states = _states;
    scrollbarPainter
      ..color = widget.thumbColorProperty?.resolve(states) ?? _defaultThumbColor
      ..trackColor =
          widget.trackColorProperty?.resolve(states) ?? const Color(0x00000000)
      ..trackBorderColor =
          widget.trackBorderColorProperty?.resolve(states) ??
          const Color(0x00000000)
      ..textDirection = textDirection
      ..thickness = widget.thicknessProperty?.resolve(states) ?? 6
      ..radius = widget.radius
      ..trackRadius = widget.trackRadius
      ..shape = widget.shape
      ..padding = (widget.padding ?? MediaQuery.paddingOf(context)).resolve(
        textDirection,
      )
      ..mainAxisMargin = widget.mainAxisMargin
      ..crossAxisMargin = widget.crossAxisMargin
      ..minLength = widget.minThumbLength
      ..minOverscrollLength =
          widget.minOverscrollLength ?? widget.minThumbLength
      ..scrollbarOrientation = widget.scrollbarOrientation
      ..ignorePointer = !enableGestures;
  }

  @override
  void handleThumbPressStart(Offset localPosition) {
    super.handleThumbPressStart(localPosition);
    _setDragged(true);
  }

  @override
  void handleThumbPressEnd(Offset localPosition, Velocity velocity) {
    super.handleThumbPressEnd(localPosition, velocity);
    _setDragged(false);
  }

  @override
  void handleHover(PointerHoverEvent event) {
    super.handleHover(event);
    _setHovered(
      isPointerOverScrollbar(event.position, event.kind, forHover: true),
    );
  }

  @override
  void handleHoverExit(PointerExitEvent event) {
    super.handleHoverExit(event);
    _setHovered(false);
  }
}
