part of 'calendar.dart';

/// Caller-owned range descriptions. Defaults are explicitly English.
@immutable
class RemixRangeCalendarLabels {
  const RemixRangeCalendarLabels({
    this.start = 'Range start',
    this.end = 'Range end',
    this.draftStart = 'Draft start',
    this.draftEnd = 'Draft end',
    this.draftRange = 'Draft range',
    this.chooseStart = 'Choose start date',
    this.chooseEnd = 'Choose end date',
    this.unavailableRange = 'Range contains unavailable dates',
    this.invalidRange = 'Selected range is unavailable',
    this.selectedRange = _selectedRange,
  });

  final String start;
  final String end;
  final String draftStart;
  final String draftEnd;
  final String draftRange;
  final String chooseStart;
  final String chooseEnd;
  final String unavailableRange;
  final String invalidRange;

  /// Formats already-localized endpoint names, not raw DateTime values.
  final String Function(String start, String end) selectedRange;

  static String _selectedRange(String start, String end) =>
      'Selected range: $start to $end';
}

/// Controlled inclusive range selection over the shared calendar anatomy.
///
/// First activation anchors a draft; second eligible activation requests one
/// complete range. Focus/navigation/blur never commit. Selected semantics always
/// describe [value], not the draft. An Overlay is required for default selectors.
///
/// The painted interval is the draft while anchored, otherwise [value]. Styles
/// layer base day, then draft preview, then single OR start/end endpoint fragment.
/// The one-day fragment is explicit: it does not merge opposing endpoint caps.
/// Normal Mix priority still applies: an endpoint/preview plain value does not
/// override a base day state variant; override the matching variant when needed.
class RemixRangeCalendar extends StatelessWidget {
  const RemixRangeCalendar({
    super.key,
    required this.value,
    required this.firstDate,
    required this.lastDate,
    this.onChanged,
    this.currentDate,
    this.isDateUnavailable,
    this.firstDayOfWeek = DateTime.sunday,
    this.enabled = true,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
    this.labels = const RemixCalendarLabels(),
    this.rangeLabels = const RemixRangeCalendarLabels(),
    this.headerBuilder,
    this.navigationStyle = const IconButtonStyler.create(),
    this.selectorStyle = const SelectStyler.create(),
    this.style = const CalendarStyler.create(),
    this.styleSpec,
  });

  final NakedDateRange? value;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<NakedDateRange>? onChanged;
  final DateTime? currentDate;
  final bool Function(DateTime)? isDateUnavailable;
  final int firstDayOfWeek;
  final bool enabled;
  final String? semanticLabel;
  final FocusNode? focusNode;
  final bool autofocus;
  final RemixCalendarLabels labels;
  final RemixRangeCalendarLabels rangeLabels;
  final Widget Function(BuildContext, NakedRangeCalendarState)? headerBuilder;
  final IconButtonStyler navigationStyle;
  final SelectStyler selectorStyle;
  final CalendarStyler style;

  /// Bypasses inherited/local stylers. Raw fragment nonnull properties override
  /// the base; resolved decoration defaults (including shape/corner zeros) are
  /// explicit values, not a lossless sparse representation of an unresolved
  /// styler. Modifiers compose; later animation metadata wins.
  final CalendarSpec? styleSpec;

  static final styleFrom = CalendarStyler.new;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = CalendarStyler(
      day: CalendarDayStyler(
        container: BoxStyler()
            .constraints(.minWidth(44).minHeight(44))
            .alignment(Alignment.center),
      ),
    ).merge(style);
    return NakedRangeCalendar(
      value: value,
      firstDate: firstDate,
      lastDate: lastDate,
      onChanged: onChanged,
      currentDate: currentDate,
      isDateUnavailable: isDateUnavailable,
      firstDayOfWeek: firstDayOfWeek,
      enabled: enabled,
      semanticLabel: semanticLabel,
      focusNode: focusNode,
      autofocus: autofocus,
      builder: (context, state, _) => _CalendarView(
        style: effectiveStyle,
        styleSpec: styleSpec,
        controller: NakedState.controllerOf<NakedRangeCalendarState>(context),
        labels: labels,
        firstDayOfWeek: firstDayOfWeek,
        weeks: state.weeks,
        summary: _summary(state),
        headerBuilder: (context, spec) =>
            headerBuilder?.call(context, state) ??
            _CalendarHeader(
              displayedMonth: state.displayedMonth,
              previousMonth: state.previousMonth,
              nextMonth: state.nextMonth,
              showMonth: state.showMonth,
              firstDate: firstDate,
              lastDate: lastDate,
              labels: labels,
              navigationStyle: navigationStyle,
              selectorStyle: selectorStyle,
              spec: spec,
            ),
        dayBuilder: (date) => _day(date, state, effectiveStyle),
      ),
    );
  }

  String _summary(NakedRangeCalendarState state) => [
    if (state.value case final value?)
      rangeLabels.selectedRange(
        labels.fullDate(value.start),
        labels.fullDate(value.end),
      ),
    if (!state.isValueValid) rangeLabels.invalidRange,
    state.anchor == null ? rangeLabels.chooseStart : rangeLabels.chooseEnd,
    if (state.preview != null && !state.isPreviewValid)
      rangeLabels.unavailableRange,
  ].join('. ');

  String _dayLabel(DateTime date, NakedRangeCalendarState state) {
    final today = currentDate ?? DateTime.now();
    final committed = state.value;
    final draft = state.preview;
    return [
      labels.fullDate(date),
      if (_sameCalendarDate(date, today)) labels.today,
      if (committed != null && _sameCalendarDate(date, committed.start))
        rangeLabels.start,
      if (committed != null && _sameCalendarDate(date, committed.end))
        rangeLabels.end,
      if (draft != null && draft.contains(date)) rangeLabels.draftRange,
      if (state.anchor != null && _sameCalendarDate(date, state.anchor!))
        rangeLabels.draftStart,
      if (draft != null && _sameCalendarDate(date, state.focusedDate))
        rangeLabels.draftEnd,
    ].join(', ');
  }

  Widget _day(
    DateTime date,
    NakedRangeCalendarState state,
    CalendarStyler effectiveStyle,
  ) {
    final interval = state.preview ?? state.value;
    final inInterval = interval?.contains(date) ?? false;
    final single =
        inInterval && _sameCalendarDate(interval!.start, interval.end);
    final start = inInterval && _sameCalendarDate(date, interval!.start);
    final end = inInterval && _sameCalendarDate(date, interval!.end);
    final preview = state.preview != null && inInterval;
    return NakedCalendarDay(
      date: date,
      semanticLabel: _dayLabel(date, state),
      builder: (context, day, _) => WidgetStateProvider(
        states: day.states,
        child: Builder(
          builder: (context) {
            Widget render(StyleSpec<CalendarDaySpec> resolved) =>
                StyleSpecBuilder<CalendarDaySpec>(
                  styleSpec: resolved,
                  builder: (context, spec) => Box(
                    styleSpec: spec.container,
                    child: StyledText(labels.day(date), styleSpec: spec.label),
                  ),
                );
            final raw = styleSpec;
            if (raw != null) {
              return render(
                _resolvedRangeDay(
                  raw,
                  preview: preview,
                  start: start,
                  end: end,
                  single: single,
                ),
              );
            }
            final inherited = Style.maybeOf<CalendarSpec>(context);
            final merged = inherited?.merge(effectiveStyle) ?? effectiveStyle;
            final projected = merged is CalendarStyler;
            final resolved = projected
                ? _RangeDayStyle(
                    merged,
                    preview: preview,
                    start: start,
                    end: end,
                    single: single,
                  ).build(context)
                : merged.build(context);
            // Consume root frame data without rendering its effects or
            // completing its callback once for every day.
            return StyleAnimationBuilder<CalendarSpec>(
              spec: resolved.copyWith(
                animation: remixChildAnimation<CalendarSpec>(
                  resolved.animation,
                ),
              ),
              builder: (context, frame) => render(
                projected
                    ? frame.spec.day
                    : _resolvedRangeDay(
                        frame.spec,
                        preview: preview,
                        start: start,
                        end: end,
                        single: single,
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}

bool _sameCalendarDate(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

// Participate in ordinary Style.build's variant merge, then promote just the
// chosen day fragments before resolving. This retains partial Mix values,
// context/state variants, modifiers and animation without calling test-only
// mergeActiveVariants or interpreting generated styler internals recursively.
class _RangeDayStyle extends CalendarStyler {
  _RangeDayStyle(
    this.source, {
    required this.preview,
    required this.start,
    required this.end,
    required this.single,
  }) : super.create(variants: source.$variants);

  final CalendarStyler source;
  final bool preview;
  final bool start;
  final bool end;
  final bool single;

  @override
  CalendarStyler merge(CalendarStyler? other) => _RangeDayStyle(
    source.merge(other),
    preview: preview,
    start: start,
    end: end,
    single: single,
  );

  @override
  StyleSpec<CalendarSpec> resolve(BuildContext context) {
    var day = source.$day;
    for (final fragment in [
      if (preview) source.$rangePreview,
      if (single) source.$rangeSingle,
      if (!single && start) source.$rangeStart,
      if (!single && end) source.$rangeEnd,
    ]) {
      day = day?.mergeProp(fragment) ?? fragment;
    }
    return CalendarStyler.create(
      day: day,
      animation: _projectAnimation(source.$animation),
    ).resolve(context);
  }

  _RangeDayFrameStyle _projectFrame(Style<CalendarSpec> frame) =>
      _RangeDayFrameStyle(frame);

  AnimationConfig? _projectAnimation(AnimationConfig? config) =>
      switch (config) {
        PhaseAnimationConfig<CalendarSpec, Style<CalendarSpec>>() =>
          PhaseAnimationConfig<CalendarSpec, CalendarStyler>(
            styles: config.styles.map(_projectFrame).toList(),
            curveConfigs: config.curveConfigs,
            trigger: config.trigger,
            onEnd: config.onEnd,
          ),
        KeyframeAnimationConfig<CalendarSpec>() =>
          KeyframeAnimationConfig<CalendarSpec>(
            trigger: config.trigger,
            timeline: config.timeline,
            // Retain the original source independently of the current interval.
            initialStyle: _projectFrame(config.initialStyle),
            styleBuilder: (values, initial) => _projectFrame(
              config.styleBuilder(
                values,
                (initial as _RangeDayFrameStyle).source,
              ),
            ),
          ),
        _ => config,
      };

  @override
  List<Object?> get props => [source, preview, start, end, single];
}

// Mix phase/keyframe drivers resolve stored styles directly. Re-enter the
// same unresolved fragment/variant projection for each generated frame.
class _RangeDayFrameStyle extends CalendarStyler {
  _RangeDayFrameStyle(this.source);

  final Style<CalendarSpec> source;

  @override
  StyleSpec<CalendarSpec> resolve(BuildContext context) {
    // Interval changes must update frame projection without resetting its
    // animation config. Existing calendar/day scopes own these live values.
    final state = NakedRangeCalendarState.of(context);
    final date = NakedCalendarDayState.of(context).date;
    final interval = state.preview ?? state.value;
    final inInterval = interval?.contains(date) ?? false;
    final single =
        inInterval && _sameCalendarDate(interval!.start, interval.end);
    final start = inInterval && _sameCalendarDate(date, interval!.start);
    final end = inInterval && _sameCalendarDate(date, interval!.end);
    final preview = state.preview != null && inInterval;
    final source = this.source;
    if (source is CalendarStyler) {
      return _RangeDayStyle(
        source,
        preview: preview,
        start: start,
        end: end,
        single: single,
      ).build(context);
    }
    return StyleSpec(
      spec: CalendarSpec(
        day: _resolvedRangeDay(
          source.build(context).spec,
          preview: preview,
          start: start,
          end: end,
          single: single,
        ),
      ),
    );
  }

  @override
  List<Object?> get props => [source];
}

StyleSpec<CalendarDaySpec> _resolvedRangeDay(
  CalendarSpec spec, {
  required bool preview,
  required bool start,
  required bool end,
  required bool single,
}) {
  var day = spec.day;
  for (final fragment in [
    if (preview) spec.rangePreview,
    if (single) spec.rangeSingle,
    if (!single && start) spec.rangeStart,
    if (!single && end) spec.rangeEnd,
  ]) {
    day = StyleSpec(
      spec: CalendarDaySpec(
        container: _overlayCalendarBox(
          day.spec.container,
          fragment.spec.container,
        ),
        label: _overlayCalendarText(day.spec.label, fragment.spec.label),
      ),
      animation: fragment.animation ?? day.animation,
      widgetModifiers: [...?day.widgetModifiers, ...?fragment.widgetModifiers],
    );
  }
  return day;
}

// A raw resolved spec has explicit values, not unresolved sparse Mix sources.
// Keep this overlay local to the two known day slots; do not infer absent
// corners or discard explicit zeros/default shape values.
StyleSpec<BoxSpec> _overlayCalendarBox(
  StyleSpec<BoxSpec> base,
  StyleSpec<BoxSpec> overlay,
) {
  final a = base.spec;
  final b = overlay.spec;
  return StyleSpec(
    spec: a.copyWith(
      alignment: b.alignment,
      padding: b.padding,
      margin: b.margin,
      constraints: b.constraints,
      decoration: _overlayCalendarDecoration(a.decoration, b.decoration),
      foregroundDecoration: _overlayCalendarDecoration(
        a.foregroundDecoration,
        b.foregroundDecoration,
      ),
      transform: b.transform,
      transformAlignment: b.transformAlignment,
      clipBehavior: b.clipBehavior,
    ),
    animation: overlay.animation ?? base.animation,
    widgetModifiers: [...?base.widgetModifiers, ...?overlay.widgetModifiers],
  );
}

Decoration? _overlayCalendarDecoration(Decoration? base, Decoration? overlay) =>
    switch ((base, overlay)) {
      (_, null) => base,
      (BoxDecoration a, BoxDecoration b) => BoxDecoration(
        color: b.color ?? a.color,
        image: b.image ?? a.image,
        border: b.border ?? a.border,
        borderRadius: b.shape == BoxShape.circle
            ? null
            : b.borderRadius ?? a.borderRadius,
        boxShadow: b.boxShadow ?? a.boxShadow,
        gradient: b.gradient ?? a.gradient,
        backgroundBlendMode: b.backgroundBlendMode ?? a.backgroundBlendMode,
        shape: b.shape,
      ),
      _ => overlay,
    };

StyleSpec<TextSpec> _overlayCalendarText(
  StyleSpec<TextSpec> base,
  StyleSpec<TextSpec> overlay,
) {
  final a = base.spec;
  final b = overlay.spec;
  return StyleSpec(
    spec: a.copyWith(
      overflow: b.overflow,
      strutStyle: b.strutStyle,
      textAlign: b.textAlign,
      maxLines: b.maxLines,
      textWidthBasis: b.textWidthBasis,
      textScaler: b.textScaler,
      style: a.style?.merge(b.style) ?? b.style,
      textDirection: b.textDirection,
      softWrap: b.softWrap,
      textHeightBehavior: b.textHeightBehavior,
      textDirectives: b.textDirectives,
      selectionColor: b.selectionColor,
      semanticsLabel: b.semanticsLabel,
      locale: b.locale,
    ),
    animation: overlay.animation ?? base.animation,
    widgetModifiers: [...?base.widgetModifiers, ...?overlay.widgetModifiers],
  );
}
