part of 'slider.dart';

class _SliderRenderer extends StatefulWidget {
  const _SliderRenderer({
    required this.state,
    required this.style,
    this.styleSpec,
    this.range = false,
  });
  final NakedSliderState state;
  final SliderStyler style;
  final SliderSpec? styleSpec;
  final bool range;

  @override
  State<_SliderRenderer> createState() => _SliderRendererState();
}

class _SliderRendererState extends State<_SliderRenderer> {
  final _hoveredThumbs = <int>{};

  @override
  void didUpdateWidget(covariant _SliderRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.isDisabled) _hoveredThumbs.clear();
  }

  void _hover(int index, bool hovered) {
    if (!mounted || (hovered && widget.state.isDisabled)) return;
    if (hovered ? _hoveredThumbs.add(index) : _hoveredThumbs.remove(index)) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => RemixStyleSpecBuilder<SliderSpec>(
    style: widget.style,
    styleSpec: widget.styleSpec,
    controller: NakedSliderState.controllerOf(context),
    trackFocusVisibility: true,
    builder: (context, spec) => widget.range
        ? _resolveThumbs(context, spec, const [], [
            for (var i = 0; i < widget.state.values.length; i++)
              _thumbStates(i),
          ])
        : _layout(context, spec, [spec]),
  );

  Set<WidgetState> _thumbStates(int index) {
    final state = widget.state;
    return <WidgetState>{
      ...state.states.where(
        (s) =>
            s != WidgetState.focused &&
            s != WidgetState.pressed &&
            s != WidgetState.hovered,
      ),
      if (state.focusedThumbIndex == index && !state.isDisabled)
        WidgetState.focused,
      if (state.activeThumbIndex == index && !state.isDisabled)
        WidgetState.pressed,
      if (_hoveredThumbs.contains(index) && !state.isDisabled)
        WidgetState.hovered,
    };
  }

  Widget _resolveThumbs(
    BuildContext context,
    SliderSpec aggregate,
    List<SliderSpec> thumbs,
    List<Set<WidgetState>> thumbStates,
  ) {
    final index = thumbs.length;
    if (index == widget.state.values.length) {
      // The recursive builders collect independently animated sizes. Restore
      // aggregate state for the rail/range and scope each rendered thumb below.
      return WidgetStateProvider(
        states: widget.state.states,
        child: Builder(
          builder: (context) =>
              _layout(context, aggregate, thumbs, thumbStates: thumbStates),
        ),
      );
    }
    return WidgetStateProvider(
      states: thumbStates[index],
      child: Builder(
        builder: (context) {
          final inherited = Style.maybeOf<SliderSpec>(context);
          final resolved = widget.styleSpec == null
              ? (inherited == null
                        ? widget.style
                        : inherited.merge(widget.style))
                    .build(context)
              : StyleSpec(spec: widget.styleSpec!);
          // Resolve the complete composite under this thumb's state, including
          // nested variants. Consume only frame data: phase/keyframe outputs can
          // regenerate root modifiers, which the aggregate builder alone owns.
          // Mix still drives local interpolation and nested Box metadata survives.
          return StyleAnimationBuilder<SliderSpec>(
            spec: resolved.copyWith(
              animation: remixChildAnimation<SliderSpec>(resolved.animation),
            ),
            builder: (context, spec) => _resolveThumbs(context, aggregate, [
              ...thumbs,
              spec.spec,
            ], thumbStates),
          );
        },
      ),
    );
  }

  Widget _layout(
    BuildContext context,
    SliderSpec spec,
    List<SliderSpec> thumbs, {
    List<Set<WidgetState>>? thumbStates,
  }) {
    final state = widget.state;
    final sizes = [
      for (final thumb in thumbs)
        _resolveThumbSize(context, _thumbStyle(thumb)),
    ];
    final thickness = spec.trackThickness > 0
        ? spec.trackThickness
        : SliderSpec.defaultTrackStrokeWidth;
    final largestHeight = sizes.map((s) => s.height).reduce(math.max);
    final largestWidth = sizes.map((s) => s.width).reduce(math.max);
    final height = math.max(
      widget.range ? 48.0 : 0.0,
      math.max(largestHeight + thickness, thickness),
    );
    final inset = math.max(largestWidth / 2, thickness / 2);
    final override = WidgetStateStyleOverride.maybeOf(context);
    final last = state.activeThumbIndex ?? state.focusedThumbIndex;
    final order = [
      for (var i = 0; i < thumbs.length; i++)
        if (i != last) i,
      if (last != null) last,
    ];
    final slider = SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          assert(
            constraints.hasBoundedWidth,
            'Constrain the slider width with its parent',
          );
          final width = math.max(0.0, constraints.maxWidth - inset * 2);
          final first = widget.range
              ? state.visualPercentageAt(0)
              : state.visualPercentageOf(0);
          final end = state.visualPercentageAt(thumbs.length - 1);
          final start = math.min(first, end);
          final span = (end - first).abs();
          return Stack(
            alignment: Alignment.centerLeft,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: inset),
                child: NakedSliderTrack(
                  child: SizedBox(
                    width: double.infinity,
                    height: constraints.maxHeight,
                    child: LayoutBuilder(
                      builder: (context, railConstraints) => Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: spec.trackWidth,
                            child: RemixBoxAdapter(
                              styleSpec: _sliderRailStyle(
                                spec.track,
                                color: spec.trackColor,
                                thickness: spec.trackWidth,
                              ),
                              containerEffects: spec.trackEffects,
                            ),
                          ),
                          Positioned(
                            left: start * railConstraints.maxWidth,
                            width: span * railConstraints.maxWidth,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: SizedBox(
                                width: double.infinity,
                                height: spec.rangeWidth,
                                child: RemixBoxAdapter(
                                  styleSpec: _sliderRailStyle(
                                    spec.range,
                                    color: spec.rangeColor,
                                    thickness: spec.rangeWidth,
                                  ),
                                  containerEffects: spec.rangeEffects,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              for (final index in order)
                Transform.translate(
                  key: ValueKey(index),
                  offset: Offset(
                    inset + width * state.visualPercentageAt(index),
                    0,
                  ),
                  // Box constraints already include padding. Use the rendered size
                  // for centering rather than subtracting a predicted footprint.
                  child: FractionalTranslation(
                    translation: const Offset(-.5, 0),
                    child: thumbStates == null
                        ? _thumb(context, index, thumbs[index], override)
                        : WidgetStateProvider(
                            states: thumbStates[index],
                            child: _thumb(
                              context,
                              index,
                              thumbs[index],
                              override,
                            ),
                          ),
                  ),
                ),
            ],
          );
        },
      ),
    );
    return spec.blendMode == null
        ? slider
        : RemixBlendMode(blendMode: spec.blendMode!, child: slider);
  }

  StyleSpec<BoxSpec> _thumbStyle(SliderSpec spec) {
    final box = spec.thumb.spec;
    final constraints = box.constraints ?? const BoxConstraints();
    // Empty Box containers expand to their available space. Bound unspecified
    // range-thumb dimensions to the established fallback without overriding
    // supplied tight/loose constraints or reinterpreting Box padding/margins.
    return widget.range
        ? spec.thumb.copyWith(
            spec: box.copyWith(
              constraints: constraints.copyWith(
                maxWidth: constraints.hasBoundedWidth
                    ? constraints.maxWidth
                    : math.max(
                        constraints.minWidth,
                        SliderSpec.defaultThumbSize.width,
                      ),
                maxHeight: constraints.hasBoundedHeight
                    ? constraints.maxHeight
                    : math.max(
                        constraints.minHeight,
                        SliderSpec.defaultThumbSize.height,
                      ),
              ),
            ),
          )
        : spec.thumb;
  }

  Widget _thumb(
    BuildContext context,
    int index,
    SliderSpec spec,
    WidgetStateStyleOverride? override,
  ) {
    final showFocus = override != null
        ? override.states.contains(WidgetState.focused)
        : widget.state.focusedThumbIndex == index &&
              FocusVisibility.of(context);
    final thumb = RemixBoxAdapter(
      styleSpec: _thumbStyle(spec),
      containerEffects: (spec.thumbEffects ?? const RemixBoxEffectsSpec())
          .merge(showFocus ? spec.thumbFocusEffects : null),
    );
    return widget.range
        ? MouseRegion(
            opaque: true,
            onEnter: (_) => _hover(index, true),
            onExit: (_) => _hover(index, false),
            child: thumb,
          )
        : thumb;
  }
}

StyleSpec<BoxSpec> _sliderRailStyle(
  StyleSpec<BoxSpec> style, {
  required Color color,
  required double thickness,
}) {
  final box = style.spec;
  final decoration = switch (box.decoration) {
    final BoxDecoration value =>
      value.color == null ? value.copyWith(color: color) : value,
    null => BoxDecoration(color: color),
    final value => value,
  };
  final constraints = (box.constraints ?? const BoxConstraints()).copyWith(
    minHeight: thickness,
    maxHeight: thickness,
  );
  return style.copyWith(
    spec: box.copyWith(decoration: decoration, constraints: constraints),
  );
}

Size _resolveThumbSize(BuildContext context, StyleSpec<BoxSpec> thumb) {
  final box = thumb.spec;
  final constraints = box.constraints;

  final width = _resolveTightDimension(
    tight: constraints?.hasTightWidth ?? false,
    min: constraints?.minWidth,
    max: constraints?.maxWidth,
    fallback: SliderSpec.defaultThumbSize.width,
  );

  final height = _resolveTightDimension(
    tight: constraints?.hasTightHeight ?? false,
    min: constraints?.minHeight,
    max: constraints?.maxHeight,
    fallback: SliderSpec.defaultThumbSize.height,
  );

  final padding = box.padding?.resolve(Directionality.of(context));

  return Size(
    width + (padding?.horizontal ?? 0),
    height + (padding?.vertical ?? 0),
  );
}

double _resolveTightDimension({
  required bool tight,
  double? min,
  double? max,
  required double fallback,
}) {
  if (tight && max != null && max.isFinite) {
    return max;
  }

  final finiteMax = (max != null && max.isFinite && max > 0) ? max : null;
  if (finiteMax != null) return finiteMax;

  final finiteMin = (min != null && min.isFinite && min > 0) ? min : null;
  if (finiteMin != null) return finiteMin;

  return fallback;
}
