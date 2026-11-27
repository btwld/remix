part of 'rating.dart';

/// Builds a text for a rating [value] out of [max]; `null` means not rated.
typedef RemixRatingValueLabelBuilder = String Function(int? value, int max);

/// Builds the accessible name of the star that sets [star] out of [max].
typedef RemixRatingStarLabelBuilder = String Function(int star, int max);

const _defaultRatingMotion = CurveAnimationConfig(
  duration: Duration(milliseconds: 150),
  curve: Curves.easeOut,
);

const _defaultRatingWords = ['Poor', 'Fair', 'Good', 'Great', 'Excellent'];

/// What one star of a [RemixRating] shows, published to the star's style.
///
/// Star styles read it through `onFilled`, `onKept` and `onRated`, or
/// through [maybeOf] inside `onBuilder`.
@immutable
class RemixRatingStarState {
  const RemixRatingStarState({
    required this.star,
    required this.max,
    required this.value,
    required this.preview,
    required this.sweepOrder,
  });

  /// The value this star sets, from 1 to [max].
  final int star;

  /// The number of stars.
  final int max;

  /// The committed value, or `null` when not rated.
  final int? value;

  /// The hovered star's value, or `null` when no star is hovered.
  final int? preview;

  /// This star's place along the last change of [shownValue], counted from
  /// the previous value: 0 for the first star the change reaches. Stars the
  /// change did not reach have a place past the last one that did.
  final int sweepOrder;

  /// The value the stars show: the preview, else the committed value, else 0.
  int get shownValue => preview ?? value ?? 0;

  /// Whether this star is inside [shownValue].
  bool get isFilled => star <= shownValue;

  /// Whether this star is inside the committed [value].
  bool get isKept => star <= (value ?? 0);

  /// Whether the rating shows any value.
  bool get isRated => shownValue > 0;

  /// The state of the nearest enclosing star, or `null` outside a star.
  static RemixRatingStarState? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_RatingStarScope>()?.state;

  @override
  bool operator ==(Object other) =>
      other is RemixRatingStarState &&
      other.star == star &&
      other.max == max &&
      other.value == value &&
      other.preview == preview &&
      other.sweepOrder == sweepOrder;

  @override
  int get hashCode => Object.hash(star, max, value, preview, sweepOrder);
}

class _RatingScope extends InheritedWidget {
  const _RatingScope({required this.shownValue, required super.child});

  final int shownValue;

  @override
  bool updateShouldNotify(_RatingScope oldWidget) =>
      shownValue != oldWidget.shownValue;
}

class _RatingStarScope extends InheritedWidget {
  const _RatingStarScope({required this.state, required super.child});

  final RemixRatingStarState state;

  @override
  bool updateShouldNotify(_RatingStarScope oldWidget) =>
      state != oldWidget.state;
}

/// A star rating: a radio group whose options are the values 1 to [max].
///
/// Selection, focus, arrow keys and semantics come from the radio group:
/// each star is a radio named by [starSemanticLabelBuilder], and the group is
/// named by [semanticLabel] or [label]. Hovering a star previews its value.
/// With [allowClear], choosing the committed star again clears the rating.
///
/// ```dart
/// RemixRating(
///   label: 'Rate this',
///   value: rating,
///   onChanged: (value) => setState(() => rating = value),
/// )
/// ```
class RemixRating extends StatefulWidget {
  const RemixRating({
    super.key,
    required this.value,
    this.onChanged,
    this.max = 5,
    this.allowClear = true,
    this.enabled = true,
    this.label,
    this.description,
    this.semanticLabel,
    this.valueLabelBuilder = RemixRating.defaultValueLabel,
    this.starSemanticLabelBuilder = RemixRating.defaultStarSemanticLabel,
    this.style = const RatingStyler.create(),
    this.styleSpec,
  }) : assert(max > 0, 'RemixRating.max must be positive.'),
       assert(
         value == null || (value > 0 && value <= max),
         'RemixRating.value must be null or between 1 and max.',
       ),
       assert(label != '', 'RemixRating.label must not be empty.'),
       assert(
         semanticLabel != '',
         'RemixRating.semanticLabel must not be empty.',
       ),
       assert(
         label != null || semanticLabel != null,
         'RemixRating requires a label or a semanticLabel.',
       );

  /// The committed value from 1 to [max], or `null` when not rated.
  final int? value;

  /// Called with the chosen value, or `null` when the rating is cleared.
  ///
  /// When `null`, the rating is disabled.
  final ValueChanged<int?>? onChanged;

  /// The number of stars.
  final int max;

  /// Whether choosing the committed star again clears the rating.
  final bool allowClear;

  /// Whether the rating is interactive.
  final bool enabled;

  /// Visible label above the stars, also the group's accessible name unless
  /// [semanticLabel] is set.
  final String? label;

  /// Visible text under the stars, announced as the group's hint.
  final String? description;

  /// Accessible name of the group. Defaults to [label].
  final String? semanticLabel;

  /// Text beside the stars for the shown value. `null` hides it.
  ///
  /// Defaults to [defaultValueLabel]. The text is visual only: the checked
  /// star's accessible name already carries the value.
  final RemixRatingValueLabelBuilder? valueLabelBuilder;

  /// Accessible name of each star. Defaults to [defaultStarSemanticLabel].
  final RemixRatingStarLabelBuilder starSemanticLabelBuilder;

  final RatingStyler style;

  final RatingSpec? styleSpec;

  static final styleFrom = RatingStyler.new;

  /// "Poor" through "Excellent" for five stars, "3 out of 7" otherwise, and
  /// "Not rated" for `null`.
  static String defaultValueLabel(int? value, int max) {
    if (value == null) return 'Not rated';
    if (max == _defaultRatingWords.length)
      return _defaultRatingWords[value - 1];
    return '$value out of $max';
  }

  /// "3 of 5 stars".
  static String defaultStarSemanticLabel(int star, int max) =>
      '$star of $max stars';

  @override
  State<RemixRating> createState() => _RemixRatingState();
}

class _RemixRatingState extends State<RemixRating> {
  late final _states = WidgetStatesController();
  int? _preview;
  int _sweepFrom = 0;
  int _sweepTo = 0;

  bool get _interactive => widget.enabled && widget.onChanged != null;

  @override
  void initState() {
    super.initState();
    _sweepFrom = _sweepTo = widget.value ?? 0;
    _syncStates();
  }

  @override
  void didUpdateWidget(RemixRating oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_interactive) _preview = null;
    _syncStates();
  }

  @override
  void dispose() {
    _states.dispose();
    super.dispose();
  }

  void _syncStates() => _states.update(WidgetState.disabled, !_interactive);

  void _hoverStar(int star, bool hovered) {
    if (hovered && _preview != star) setState(() => _preview = star);
  }

  void _leaveStars() {
    if (_preview != null) setState(() => _preview = null);
  }

  // The pointer still rests on the chosen star, so drop the preview: a cleared
  // rating must read as cleared until the pointer reaches another star.
  void _commit(int? value) {
    if (_preview != null) setState(() => _preview = null);
    widget.onChanged?.call(value);
  }

  int _sweepOrder(int star) {
    final order = _sweepTo >= _sweepFrom
        ? star - 1 - _sweepFrom
        : _sweepFrom - star;
    return order < 0 ? 0 : order;
  }

  RatingStyler get _effectiveStyle => RatingStyler(
    container: FlexBoxStyler(
      direction: .vertical,
      mainAxisSize: .min,
      crossAxisAlignment: .start,
    ),
    controlRow: FlexBoxStyler(
      direction: .horizontal,
      mainAxisSize: .min,
      crossAxisAlignment: .center,
    ),
    stars: FlexBoxStyler(direction: .horizontal, mainAxisSize: .min),
    star: RatingStarStyler(container: BoxStyler(alignment: .center)),
  ).merge(widget.style);

  @override
  Widget build(BuildContext context) {
    final shown = _preview ?? widget.value ?? 0;
    if (shown != _sweepTo) {
      _sweepFrom = _sweepTo;
      _sweepTo = shown;
    }
    final style = _effectiveStyle;
    final groupLabel = widget.semanticLabel ?? widget.label;

    return _RatingScope(
      shownValue: shown,
      child: RemixStyleSpecBuilder<RatingSpec>(
        style: style,
        styleSpec: widget.styleSpec,
        controller: _states,
        trackFocusVisibility: true,
        builder: (context, spec) {
          final valueLabel = widget.valueLabelBuilder;
          // Every label stays laid out, so the row keeps the widest one's width
          // and the stars never move while the value changes.
          final valueText = valueLabel == null
              ? null
              : IndexedStack(
                  index: shown,
                  children: [
                    for (var value = 0; value <= widget.max; value++)
                      StyledText(
                        valueLabel(value == 0 ? null : value, widget.max),
                        styleSpec: spec.valueText,
                      ),
                  ],
                );

          final stars = MouseRegion(
            onExit: (_) => _leaveStars(),
            child: FlexBox(
              styleSpec: spec.stars,
              children: [
                for (var star = 1; star <= widget.max; star++)
                  _RatingStar(
                    key: ValueKey(star),
                    star: RemixRatingStarState(
                      star: star,
                      max: widget.max,
                      value: widget.value,
                      preview: _preview,
                      sweepOrder: _sweepOrder(star),
                    ),
                    allowClear: widget.allowClear,
                    semanticLabel: widget.starSemanticLabelBuilder(
                      star,
                      widget.max,
                    ),
                    onHoverChange: (hovered) => _hoverStar(star, hovered),
                    style: widget.styleSpec == null ? style : null,
                    styleSpec: widget.styleSpec == null ? null : spec.star,
                    ratingSpec: spec,
                  ),
              ],
            ),
          );

          final group = Semantics(
            container: true,
            explicitChildNodes: true,
            label: groupLabel,
            hint: widget.description,
            child: NakedRadioGroup<int>(
              groupValue: widget.value,
              onChanged: _interactive ? _commit : null,
              child: stars,
            ),
          );

          return FlexBox(
            styleSpec: spec.container,
            children: [
              if (widget.label != null)
                ExcludeSemantics(
                  child: StyledText(widget.label!, styleSpec: spec.label),
                ),
              FlexBox(
                styleSpec: spec.controlRow,
                children: [
                  group,
                  if (valueText != null) ExcludeSemantics(child: valueText),
                ],
              ),
              if (widget.description != null)
                ExcludeSemantics(
                  child: StyledText(
                    widget.description!,
                    styleSpec: spec.description,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _RatingStar extends StatelessWidget {
  const _RatingStar({
    super.key,
    required this.star,
    required this.allowClear,
    required this.semanticLabel,
    required this.onHoverChange,
    required this.style,
    required this.styleSpec,
    required this.ratingSpec,
  });

  final RemixRatingStarState star;
  final bool allowClear;
  final String semanticLabel;
  final ValueChanged<bool> onHoverChange;
  final RatingStyler? style;
  final StyleSpec<RatingStarSpec>? styleSpec;
  final RatingSpec ratingSpec;

  @override
  Widget build(BuildContext context) {
    return NakedRadio<int>(
      value: star.star,
      toggleable: allowClear,
      semanticLabel: semanticLabel,
      onHoverChange: onHoverChange,
      builder: (context, state, _) {
        return _RatingStarScope(
          state: star,
          child: WidgetStateProvider(
            states: state.states,
            child: Builder(
              builder: (context) {
                // Resolve under this star's states and scope so widget-state
                // and star variants apply together.
                final resolved = styleSpec ?? style!.build(context).spec.star;

                return StyleSpecBuilder<RatingStarSpec>(
                  styleSpec: resolved,
                  builder: (context, spec) {
                    final size = spec.glyphSize ?? 24;
                    return RemixBoxAdapter(
                      styleSpec: spec.container,
                      containerEffects: spec.containerEffects,
                      child: Transform.scale(
                        scale: spec.glyphScale ?? 1,
                        child: SizedBox.square(
                          dimension: size,
                          child: RemixReducedMotionBuilder(
                            builder: (context, reduceMotion) =>
                                _RatingStarGlyph(
                                  spec: spec,
                                  fill: star.isFilled ? 1 : 0,
                                  kept: star.isKept ? 1 : 0,
                                  fillMotion: ratingSpec.fillMotion,
                                  fillDelay:
                                      (ratingSpec.fillStagger ??
                                          Duration.zero) *
                                      star.sweepOrder,
                                  keptMotion: ratingSpec.keptMotion,
                                  reduceMotion: reduceMotion,
                                ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _RatingStarGlyph extends StatefulWidget {
  const _RatingStarGlyph({
    required this.spec,
    required this.fill,
    required this.kept,
    required this.fillMotion,
    required this.fillDelay,
    required this.keptMotion,
    required this.reduceMotion,
  });

  final RatingStarSpec spec;
  final double fill;
  final double kept;
  final AnimationConfig? fillMotion;
  final Duration fillDelay;
  final AnimationConfig? keptMotion;
  final bool reduceMotion;

  @override
  State<_RatingStarGlyph> createState() => _RatingStarGlyphState();
}

class _RatingStarGlyphState extends State<_RatingStarGlyph>
    with TickerProviderStateMixin {
  late final _fill = AnimationController.unbounded(
    vsync: this,
    value: widget.fill,
  );
  late final _kept = AnimationController.unbounded(
    vsync: this,
    value: widget.kept,
  );
  Timer? _fillTimer;
  Timer? _keptTimer;

  @override
  void didUpdateWidget(_RatingStarGlyph oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fill != widget.fill) {
      _fillTimer?.cancel();
      _fillTimer = _move(
        _fill,
        widget.fill,
        widget.fillMotion,
        widget.fillDelay,
      );
    }
    if (oldWidget.kept != widget.kept) {
      _keptTimer?.cancel();
      _keptTimer = _move(_kept, widget.kept, widget.keptMotion, Duration.zero);
    }
  }

  Timer? _move(
    AnimationController controller,
    double target,
    AnimationConfig? motion,
    Duration stagger,
  ) {
    final config = motion ?? _defaultRatingMotion;
    if (widget.reduceMotion) {
      controller.value = target;
      return null;
    }

    void start() {
      switch (config) {
        case CurveAnimationConfig(:final duration, :final curve):
          controller.animateTo(target, duration: duration, curve: curve);
        case SpringAnimationConfig(:final spring):
          controller.animateWith(
            SpringSimulation(
              spring,
              controller.value,
              target,
              controller.velocity,
            ),
          );
        default:
          throw ArgumentError.value(
            config,
            'fillMotion',
            'Expected CurveAnimationConfig or SpringAnimationConfig',
          );
      }
    }

    final delay =
        stagger + (config is CurveAnimationConfig ? config.delay : .zero);
    if (delay == Duration.zero) {
      start();
      return null;
    }
    controller.stop();
    return Timer(delay, start);
  }

  @override
  void dispose() {
    _fillTimer?.cancel();
    _keptTimer?.cancel();
    _fill.dispose();
    _kept.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spec = widget.spec;
    return CustomPaint(
      painter: _RatingStarPainter(
        fill: _fill,
        kept: _kept,
        textDirection: Directionality.maybeOf(context) ?? TextDirection.ltr,
        strokeWidth: spec.strokeWidth ?? 1.5,
        emptyColor: spec.emptyColor,
        outlineColor: spec.outlineColor ?? const Color(0xFF8E8E93),
        keptColor: spec.keptColor,
        fillColor: spec.fillColor ?? const Color(0xFFFFB400),
      ),
    );
  }
}

class _RatingStarPainter extends CustomPainter {
  _RatingStarPainter({
    required this.fill,
    required this.kept,
    required this.textDirection,
    required this.strokeWidth,
    required this.emptyColor,
    required this.outlineColor,
    required this.keptColor,
    required this.fillColor,
  }) : super(repaint: Listenable.merge([fill, kept]));

  final Animation<double> fill;
  final Animation<double> kept;
  final TextDirection textDirection;
  final double strokeWidth;
  final Color? emptyColor;
  final Color outlineColor;
  final Color? keptColor;
  final Color fillColor;

  // A five-point star in a 24 x 24 box, tips 2 from the top and sides.
  static Path _star(Size size) {
    final scale = size.shortestSide / 24;
    final center = Offset(12 * scale, 12.6 * scale);
    final outer = 10.5 * scale;
    final inner = outer * 0.53;
    final path = Path();
    for (var point = 0; point < 10; point++) {
      final radius = point.isEven ? outer : inner;
      final angle = -pi / 2 + point * pi / 5;
      final vertex = center + Offset(cos(angle), sin(angle)) * radius;
      point == 0
          ? path.moveTo(vertex.dx, vertex.dy)
          : path.lineTo(vertex.dx, vertex.dy);
    }
    return path..close();
  }

  void _layer(Canvas canvas, Size size, Path path, Color color, double t) {
    final fraction = t.clamp(0.0, 1.0);
    if (fraction == 0) return;
    final width = size.width * fraction;
    final clip = textDirection == TextDirection.ltr
        ? Rect.fromLTWH(0, 0, width, size.height)
        : Rect.fromLTWH(size.width - width, 0, width, size.height);
    canvas
      ..save()
      ..clipRect(clip)
      ..drawPath(path, Paint()..color = color)
      ..drawPath(path, _stroke(color))
      ..restore();
  }

  Paint _stroke(Color color) => Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = strokeWidth
    ..strokeJoin = StrokeJoin.round
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    final path = _star(size);
    if (emptyColor case final color?) {
      canvas.drawPath(path, Paint()..color = color);
    }
    canvas.drawPath(path, _stroke(outlineColor));
    if (keptColor case final color?) {
      _layer(canvas, size, path, color, kept.value);
    }
    _layer(canvas, size, path, fillColor, fill.value);
  }

  @override
  bool shouldRepaint(_RatingStarPainter oldDelegate) =>
      oldDelegate.fill != fill ||
      oldDelegate.kept != kept ||
      oldDelegate.textDirection != textDirection ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.emptyColor != emptyColor ||
      oldDelegate.outlineColor != outlineColor ||
      oldDelegate.keptColor != keptColor ||
      oldDelegate.fillColor != fillColor;
}
