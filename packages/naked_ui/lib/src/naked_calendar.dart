import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'mixins/naked_mixins.dart';
import 'naked_date_range.dart';
import 'utilities/civil_date.dart';
import 'utilities/focus_in_view.dart';
import 'utilities/naked_focusable_detector.dart';
import 'utilities/naked_state_scope.dart';
import 'utilities/state.dart';

DateTime _date(DateTime date) => civilDate(date.year, date.month, date.day);
DateTime _month(DateTime date) => civilDate(date.year, date.month);

bool _same(DateTime? a, DateTime? b) => isSameCivilDate(a, b);
int _daysInMonth(int year, int month) => switch (month) {
  2 => year % 4 == 0 && (year % 100 != 0 || year % 400 == 0) ? 29 : 28,
  4 || 6 || 9 || 11 => 30,
  _ => 31,
};

/// Immutable calendar view and bounded navigation actions.
///
/// Dates are civil year/month/day fields. [weeks] contains the displayed
/// month's dates, with null padding rather than interactive adjacent dates.
class NakedCalendarState extends NakedState {
  /// Creates a snapshot for a calendar builder.
  NakedCalendarState({
    required super.states,
    required this.displayedMonth,
    required this.focusedDate,
    required this.value,
    required this.weeks,
    required this.showPreviousMonth,
    required this.showNextMonth,
    required this.showMonth,
  });

  /// First day of the month currently shown.
  final DateTime displayedMonth;

  /// Current keyboard entry date, independently clamped to the bounds.
  final DateTime focusedDate;

  /// Parent-owned selected date, compared by year/month/day fields.
  final DateTime? value;

  /// Immutable rows of seven dates with null padding outside the month.
  final List<List<DateTime?>> weeks;

  /// Previous-month action, or null at the first month or when disabled.
  final VoidCallback? showPreviousMonth;

  /// Next-month action, or null at the last month or when disabled.
  final VoidCallback? showNextMonth;

  /// Requests a month, clamped to the inclusive bounds, without selecting.
  final ValueChanged<DateTime>? showMonth;

  /// Reads the nearest calendar builder state.
  static NakedCalendarState of(BuildContext context) => NakedState.of(context);

  /// Returns the nearest [NakedCalendarState], if one is available.
  static NakedCalendarState? maybeOf(BuildContext context) =>
      NakedState.maybeOf(context);

  /// Returns the controller from the nearest state scope.
  static WidgetStatesController controllerOf(BuildContext context) =>
      NakedState.controllerOf<NakedCalendarState>(context);

  /// Returns the nearest state scope's controller, if one is available.
  static WidgetStatesController? maybeControllerOf(BuildContext context) =>
      NakedState.maybeControllerOf<NakedCalendarState>(context);

  @override
  List<Object?> get props => [
    ...super.props,
    displayedMonth,
    focusedDate,
    value,
    weeks,
    showPreviousMonth,
    showNextMonth,
    showMonth,
  ];
}

/// Headless controlled single-date calendar.
///
/// Build visible dates with [NakedCalendarDay]. Builders replace presentation,
/// not selection, keyboard, focus or semantics behavior. Bounds are inclusive.
/// An external value outside the bounds is retained; only focus/view are
/// clamped. Unavailable dates within the bounds remain keyboard-focusable.
class NakedCalendar extends StatelessWidget {
  /// Creates a headless single-date calendar.
  const NakedCalendar({
    super.key,
    required this.value,
    required this.firstDate,
    required this.lastDate,
    required this.builder,
    this.onChanged,
    this.currentDate,
    this.isDateUnavailable,
    this.firstDayOfWeek = DateTime.sunday,
    this.enabled = true,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
    this.excludeSemantics = false,
  });

  /// Parent-owned selected date, compared by year/month/day fields.
  final DateTime? value;

  /// Inclusive earliest date; its time and UTC flag are ignored.
  final DateTime firstDate;

  /// Inclusive latest date, on or after [firstDate].
  final DateTime lastDate;

  /// Selection request. Null disables all calendar interaction.
  ///
  /// Returns local civil dates where representable, otherwise a UTC date that
  /// preserves the fields of a skipped local day. Do not convert timezones.
  final ValueChanged<DateTime>? onChanged;

  /// Today marker and initial fallback date; defaults to DateTime.now().
  final DateTime? currentDate;

  /// Marks in-bound dates nonselectable, but still keyboard-focusable.
  final bool Function(DateTime)? isDateUnavailable;

  /// First weekday column, from Monday=1 through Sunday=7.
  final int firstDayOfWeek;

  /// Whether calendar navigation, focus and selection are enabled.
  final bool enabled;

  /// Accessible name for the calendar group.
  final String? semanticLabel;

  /// Focus entry point. Requesting it transfers focus to the current day.
  final FocusNode? focusNode;

  /// Whether to focus the current keyboard entry date on mount.
  final bool autofocus;

  /// Builds the layout from immutable dates and bounded navigation actions.
  final ValueWidgetBuilder<NakedCalendarState> builder;

  /// Whether to hide this widget and its children from accessibility services.
  final bool excludeSemantics;

  @override
  Widget build(BuildContext context) => _Calendar(
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
    builder: builder,
    excludeSemantics: excludeSemantics,
  );
}

/// Immutable range selection and calendar navigation snapshot.
///
/// [value] is committed and parent-owned. [anchor] and [preview] describe only
/// the local draft; navigating never requests a selection.
class NakedRangeCalendarState extends NakedState {
  /// Creates a range calendar builder snapshot.
  NakedRangeCalendarState({
    required super.states,
    required this.displayedMonth,
    required this.focusedDate,
    required this.value,
    required this.anchor,
    required this.preview,
    required this.isPreviewValid,
    required this.isValueValid,
    required this.weeks,
    required this.showPreviousMonth,
    required this.showNextMonth,
    required this.showMonth,
  });

  /// First day of the displayed month.
  final DateTime displayedMonth;

  /// Current keyboard entry date, independently clamped to the bounds.
  final DateTime focusedDate;

  /// Parent-owned complete inclusive range, never clamped or corrected.
  final NakedDateRange? value;

  /// First activated date of an incomplete local draft.
  final DateTime? anchor;

  /// Ordered interval from [anchor] to [focusedDate], or null without a draft.
  final NakedDateRange? preview;

  /// Whether [preview] can complete under the current bounds and availability.
  final bool isPreviewValid;

  /// Whether the supplied complete range satisfies bounds and availability.
  ///
  /// Null values are valid. Invalid values remain parent-owned and selected.
  /// Every widget update revalidates the committed range with O(span)
  /// availability-predicate calls, even when the predicate identity is unchanged.
  /// Internal focus moves and browsing reuse that result.
  final bool isValueValid;

  /// Immutable rows of seven dates, padded with nulls outside this month.
  final List<List<DateTime?>> weeks;

  /// Previous-month action, or null at the first month or when disabled.
  final VoidCallback? showPreviousMonth;

  /// Next-month action, or null at the last month or when disabled.
  final VoidCallback? showNextMonth;

  /// Shows a bounded month without selecting.
  final ValueChanged<DateTime>? showMonth;

  /// Reads the nearest range calendar builder state.
  static NakedRangeCalendarState of(BuildContext context) =>
      NakedState.of(context);

  @override
  List<Object?> get props => [
    ...super.props,
    displayedMonth,
    focusedDate,
    value,
    anchor,
    preview,
    isPreviewValid,
    isValueValid,
    weeks,
    showPreviousMonth,
    showNextMonth,
    showMonth,
  ];
}

/// Headless controlled complete-range calendar using [NakedCalendarDay].
///
/// First activation anchors a draft; a second eligible activation requests one
/// ordered inclusive range and clears the draft, even if the parent rejects it.
/// Unavailable interior dates prevent completion without discarding the anchor.
/// Unavailable and blocked completion dates remain keyboard-focusable.
///
/// Navigation and blur never commit. Escape discards the draft and bubbles to
/// an enclosing overlay. Changing the supplied civil range, disabling interaction
/// or invalidating the anchor cancels the draft. Equal values preserve browsing.
/// Accepting this calendar's request in the request frame preserves the completed
/// end's focus and month. Any other changed nonnull value recentres on its
/// clamped start, including a previously rejected request supplied later.
class NakedRangeCalendar extends StatelessWidget {
  /// Creates a headless range calendar with one shared navigation/focus engine.
  const NakedRangeCalendar({
    super.key,
    required this.value,
    required this.firstDate,
    required this.lastDate,
    required this.builder,
    this.onChanged,
    this.currentDate,
    this.isDateUnavailable,
    this.firstDayOfWeek = DateTime.sunday,
    this.enabled = true,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
  });

  /// Parent-owned complete range. Invalid external values are retained.
  final NakedDateRange? value;

  /// Inclusive earliest date; time and UTC flag are ignored.
  final DateTime firstDate;

  /// Inclusive latest date, on or after [firstDate].
  final DateTime lastDate;

  /// Complete-range request. Null disables all interaction.
  final ValueChanged<NakedDateRange>? onChanged;

  /// Today marker and initial fallback date; defaults to DateTime.now().
  final DateTime? currentDate;

  /// Pure current-availability predicate, checked for every inclusive date.
  ///
  /// Rebuild when its results change: between widget updates, results for
  /// the draft and the committed value are cached, so focus moves and browsing
  /// cost only newly exposed dates. Activation rechecks the whole interval,
  /// including offscreen dates, even when the function object is unchanged.
  final bool Function(DateTime)? isDateUnavailable;

  /// First weekday column, Monday=1 through Sunday=7.
  final int firstDayOfWeek;

  /// Enables navigation, focus and selection when [onChanged] is nonnull.
  final bool enabled;

  /// Localized accessible calendar group name or current range instruction.
  final String? semanticLabel;

  /// Focus entry point, transferred to the current keyboard day.
  final FocusNode? focusNode;

  /// Focuses the keyboard entry date on mount.
  final bool autofocus;

  /// Builds presentation; retain [NakedCalendarDay] for visible dates.
  final ValueWidgetBuilder<NakedRangeCalendarState> builder;

  @override
  Widget build(BuildContext context) => _Calendar(
    rangeValue: value,
    firstDate: firstDate,
    lastDate: lastDate,
    onRangeChanged: onChanged,
    currentDate: currentDate,
    isDateUnavailable: isDateUnavailable,
    firstDayOfWeek: firstDayOfWeek,
    enabled: enabled,
    semanticLabel: semanticLabel,
    focusNode: focusNode,
    autofocus: autofocus,
    rangeBuilder: builder,
  );
}

// Only the two concrete public roots configure this private engine. Day parts,
// navigation, focus registration and input dispatch have one lifecycle owner.
class _Calendar extends StatefulWidget {
  const _Calendar({
    this.value,
    this.rangeValue,
    required this.firstDate,
    required this.lastDate,
    this.onChanged,
    this.onRangeChanged,
    required this.currentDate,
    required this.isDateUnavailable,
    required this.firstDayOfWeek,
    required this.enabled,
    required this.semanticLabel,
    required this.focusNode,
    required this.autofocus,
    this.excludeSemantics = false,
    this.builder,
    this.rangeBuilder,
  });

  final DateTime? value;
  final NakedDateRange? rangeValue;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime>? onChanged;
  final ValueChanged<NakedDateRange>? onRangeChanged;
  final DateTime? currentDate;
  final bool Function(DateTime)? isDateUnavailable;
  final int firstDayOfWeek;
  final bool enabled;
  final String? semanticLabel;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool excludeSemantics;
  final ValueWidgetBuilder<NakedCalendarState>? builder;
  final ValueWidgetBuilder<NakedRangeCalendarState>? rangeBuilder;

  bool get isRange => rangeBuilder != null;
  DateTime? get entryValue => isRange ? rangeValue?.start : value;

  @override
  State<_Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<_Calendar> with FocusNodeMixin<_Calendar> {
  DateTime? _anchor;
  // The last range this calendar requested. A parent that accepts it has not
  // moved the selection elsewhere, so browsing stays on the completed end.
  NakedDateRange? _requested;
  DateTime? _blockedBefore;
  DateTime? _blockedAfter;
  // Availability scans around the draft anchor are cached across internal
  // updates (focus moves, browsing) and extended only over newly exposed
  // dates. Any widget update resets them: a rebuild is how a parent reports
  // new predicate results, even for the same function object.
  DateTime? _scanAnchor;
  DateTime? _scannedBefore;
  DateTime? _scannedAfter;
  bool? _valueValid;
  late DateTime _focused;
  late DateTime _displayed;
  final _days = <DateTime, FocusNode>{};
  final _dayOrder = <DateTime, int>{};
  bool get _interactive =>
      mounted &&
      widget.enabled &&
      (widget.isRange
          ? widget.onRangeChanged != null
          : widget.onChanged != null);
  @override
  FocusNode? get widgetProvidedNode => widget.focusNode;

  void _validate() {
    assert(
      compareCivilDates(widget.firstDate, widget.lastDate) <= 0,
      'firstDate must be on or before lastDate.',
    );
    assert(
      widget.firstDayOfWeek >= 1 && widget.firstDayOfWeek <= 7,
      'firstDayOfWeek must be 1 through 7.',
    );
  }

  bool _inBounds(DateTime date) =>
      compareCivilDates(date, widget.firstDate) >= 0 &&
      compareCivilDates(date, widget.lastDate) <= 0;
  DateTime _clamp(DateTime date) => _date(
    compareCivilDates(date, widget.firstDate) < 0
        ? widget.firstDate
        : compareCivilDates(date, widget.lastDate) > 0
        ? widget.lastDate
        : date,
  );
  bool _available(DateTime date) =>
      _inBounds(date) && !(widget.isDateUnavailable?.call(date) ?? false);

  bool _selected(DateTime date) => widget.isRange
      ? (widget.rangeValue?.contains(date) ?? false)
      : _same(date, widget.value);

  // The nearest blocked dates come from the cached anchor scan, not from
  // scanning the interval separately for every visible day and state update.
  bool _selectable(DateTime date) =>
      _interactive &&
      _available(date) &&
      (_anchor == null ||
          (_blockedBefore == null ||
                  compareCivilDates(date, _blockedBefore!) > 0) &&
              (_blockedAfter == null ||
                  compareCivilDates(date, _blockedAfter!) < 0));

  NakedDateRange _range(DateTime a, DateTime b) => compareCivilDates(a, b) <= 0
      ? NakedDateRange(start: a, end: b)
      : NakedDateRange(start: b, end: a);

  // Set by build, read by this build's days.
  NakedDateRange? _preview;

  NakedRangePosition _rangePosition(DateTime date) {
    final interval = _preview ?? (widget.isRange ? widget.rangeValue : null);
    if (interval == null || !interval.contains(date)) {
      return NakedRangePosition.none;
    }
    final start = _same(date, interval.start);
    final end = _same(date, interval.end);
    return switch ((start, end)) {
      (true, true) => NakedRangePosition.single,
      (true, false) => NakedRangePosition.start,
      (false, true) => NakedRangePosition.end,
      (false, false) => NakedRangePosition.middle,
    };
  }

  bool _inPreview(DateTime date) => _preview?.contains(date) ?? false;

  bool _validRange(NakedDateRange range) {
    if (!_inBounds(range.start) || !_inBounds(range.end)) return false;
    if (widget.isDateUnavailable == null) return true;
    var date = range.start;
    while (true) {
      if (widget.isDateUnavailable!(date)) return false;
      if (_same(date, range.end)) return true;
      date = civilDate(date.year, date.month, date.day + 1);
    }
  }

  void _resetScans() {
    _scanAnchor = null;
    _valueValid = null;
  }

  // Finds the nearest unavailable dates on each side of the anchor, scanning
  // only up to the displayed month. A scan resumes where the previous one
  // stopped, so browsing away from the anchor costs each date once.
  void _prepareRange() {
    final anchor = _anchor;
    final predicate = widget.isDateUnavailable;
    if (anchor == null) {
      _scanAnchor = null;
      _blockedBefore = _blockedAfter = null;
      return;
    }
    if (!_interactive || !_available(anchor)) {
      // An unusable anchor blocks every completion until it is discarded.
      _scanAnchor = null;
      _blockedBefore = _blockedAfter = anchor;
      return;
    }
    if (predicate == null) {
      _scanAnchor = null;
      _blockedBefore = _blockedAfter = null;
      return;
    }
    if (!_same(_scanAnchor, anchor)) {
      _scanAnchor = anchor;
      _scannedBefore = _scannedAfter = anchor;
      _blockedBefore = _blockedAfter = null;
    }
    final first = _clamp(_displayed);
    final last = _clamp(
      civilDate(
        _displayed.year,
        _displayed.month,
        _daysInMonth(_displayed.year, _displayed.month),
      ),
    );
    if (_blockedBefore == null) {
      var date = _scannedBefore!;
      while (compareCivilDates(date, first) > 0) {
        date = civilDate(date.year, date.month, date.day - 1);
        if (predicate(date)) {
          _blockedBefore = date;
          break;
        }
      }
      _scannedBefore = date;
    }
    if (_blockedAfter == null) {
      var date = _scannedAfter!;
      while (compareCivilDates(date, last) < 0) {
        date = civilDate(date.year, date.month, date.day + 1);
        if (predicate(date)) {
          _blockedAfter = date;
          break;
        }
      }
      _scannedAfter = date;
    }
  }

  @override
  void initState() {
    super.initState();
    _validate();
    final value = widget.entryValue;
    _focused = _clamp(
      value != null && _inBounds(value)
          ? value
          : widget.currentDate ?? DateTime.now(),
    );
    _displayed = _month(_focused);
  }

  @override
  void didUpdateWidget(_Calendar oldWidget) {
    final ownedFocus = effectiveFocusNode.hasFocus;
    super.didUpdateWidget(oldWidget);
    _resetScans();
    final previous = _focused;
    final valueChanged = widget.isRange
        ? widget.rangeValue != oldWidget.rangeValue
        : !_same(widget.value, oldWidget.value);
    if (valueChanged ||
        !_interactive ||
        (_anchor != null && !_available(_anchor!))) {
      _anchor = null;
    }
    final accepted =
        widget.isRange && valueChanged && widget.rangeValue == _requested;
    if (valueChanged) _requested = null;
    // Clearing selection does not reset browsing, and neither does accepting
    // this calendar's own request. Any other new supplied value does.
    if (widget.entryValue != null && valueChanged && !accepted) {
      _focused = _clamp(widget.entryValue!);
      _displayed = _month(_focused);
    } else {
      _focused = _clamp(_focused);
      _displayed = _month(_focused);
    }
    if (_interactive &&
        ownedFocus &&
        (!_same(previous, _focused) ||
            oldWidget.firstDayOfWeek != widget.firstDayOfWeek)) {
      _requestDayFocus();
    }
  }

  void _requestDayFocus() {
    final priorFocus = FocusManager.instance.primaryFocus;
    final priorScope = priorFocus?.enclosingScope;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_interactive) return;
      final primary = FocusManager.instance.primaryFocus;
      // A removed day may yield to its scope. A user-focused external control
      // must win over this deferred handoff.
      if (primary != priorFocus &&
          !effectiveFocusNode.hasPrimaryFocus &&
          !(priorFocus?.context?.mounted != true &&
              (primary == null || primary == priorScope)))
        return;
      final node = _days[_focused];
      if (node != null) requestFocusInView(node);
    });
  }

  void _move(DateTime date, {bool requestFocus = true}) {
    if (!_interactive) return;
    final target = _clamp(date);
    setState(() {
      _focused = target;
      _displayed = _month(target);
    });
    if (requestFocus) _requestDayFocus();
  }

  void _showMonth(DateTime date) {
    if (!_interactive) return;
    final target = _month(_clampMonth(date));
    final dayOwnedFocus = _days.values.any((node) => node.hasFocus);
    _move(
      civilDate(
        target.year,
        target.month,
        _focused.day.clamp(1, _daysInMonth(target.year, target.month)),
      ),
      requestFocus: dayOwnedFocus,
    );
  }

  DateTime _clampMonth(DateTime date) {
    if (compareCivilDates(_month(date), _month(widget.firstDate)) < 0)
      return widget.firstDate;
    if (compareCivilDates(_month(date), _month(widget.lastDate)) > 0)
      return widget.lastDate;
    return date;
  }

  DateTime _shiftMonth(DateTime date, int amount) {
    final index = date.year * 12 + date.month - 1 + amount;
    final first = widget.firstDate.year * 12 + widget.firstDate.month - 1;
    final last = widget.lastDate.year * 12 + widget.lastDate.month - 1;
    if (index < first) return _date(widget.firstDate);
    if (index > last) return _date(widget.lastDate);
    final year = (index / 12).floor();
    final month = index - year * 12 + 1;
    return _clamp(
      civilDate(year, month, date.day.clamp(1, _daysInMonth(year, month))),
    );
  }

  void _select(DateTime date) {
    if (!_interactive) return;
    if (!widget.isRange) {
      if (_available(date)) widget.onChanged!(_date(date));
      return;
    }
    final anchor = _anchor;
    if (anchor != null && !_available(anchor)) {
      setState(() => _anchor = null);
      return;
    }
    if (!_available(date)) return;
    // Semantic activation need not move input focus (notably on iOS). Keep an
    // existing keyboard session aligned with the activated date, but do not
    // acquire input focus from an external control or accessibility focus alone.
    if (effectiveFocusNode.hasFocus) {
      final node = _days[_date(date)];
      if (node != null) requestFocusInView(node);
    }
    if (anchor == null) {
      setState(() {
        _anchor = _date(date);
        _focused = _date(date);
      });
      return;
    }
    final range = _range(anchor, date);
    // Recheck current inputs at activation; cached visual eligibility is not
    // an authorization to commit after availability has changed.
    if (!_validRange(range)) return;
    setState(() => _anchor = null);
    _requested = range;
    // Acceptance in this request's frame preserves browsing. Once that frame
    // passes, an equal value is a new external selection and must recentre.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && identical(_requested, range)) _requested = null;
    });
    widget.onRangeChanged!(range);
  }

  KeyEventResult _key(DateTime date, KeyEvent event, TextDirection direction) {
    if (!_interactive || event is KeyUpEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;
    final rtl = direction == TextDirection.rtl;
    int? delta;
    if (key == LogicalKeyboardKey.arrowLeft) delta = rtl ? 1 : -1;
    if (key == LogicalKeyboardKey.arrowRight) delta = rtl ? -1 : 1;
    if (key == LogicalKeyboardKey.arrowUp) delta = -7;
    if (key == LogicalKeyboardKey.arrowDown) delta = 7;
    final offset = (date.weekday - widget.firstDayOfWeek + 7) % 7;
    if (key == LogicalKeyboardKey.home) delta = -offset;
    if (key == LogicalKeyboardKey.end) delta = 6 - offset;
    if (delta != null) {
      // Field construction deliberately avoids 24-hour duration arithmetic.
      // Stop at the inclusive bounds before constructing each next day.
      var target = date;
      for (var i = 0; i < delta.abs(); i++) {
        if (delta < 0 && compareCivilDates(target, widget.firstDate) <= 0 ||
            delta > 0 && compareCivilDates(target, widget.lastDate) >= 0)
          break;
        target = civilDate(target.year, target.month, target.day + delta.sign);
      }
      _move(target);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.pageUp ||
        key == LogicalKeyboardKey.pageDown) {
      final amount = HardwareKeyboard.instance.isShiftPressed ? 12 : 1;
      _move(
        _shiftMonth(date, key == LogicalKeyboardKey.pageUp ? -amount : amount),
      );
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter ||
        key == LogicalKeyboardKey.space) {
      if (event is KeyDownEvent) _select(date);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  List<List<DateTime?>> _weeks() {
    final offset = (_displayed.weekday - widget.firstDayOfWeek + 7) % 7;
    final count = _daysInMonth(_displayed.year, _displayed.month);
    return List.unmodifiable(
      List.generate(
        (offset + count + 6) ~/ 7,
        (week) => List<DateTime?>.unmodifiable(
          List.generate(7, (column) {
            final day = week * 7 + column - offset + 1;
            return day < 1 || day > count
                ? null
                : civilDate(_displayed.year, _displayed.month, day);
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _validate();
    // Visible parts register again when this snapshot changes. Clearing before
    // reconciliation avoids stale nodes from the previous month's layout.
    _days.clear();
    _dayOrder.clear();
    _prepareRange();
    _preview = widget.isRange && _anchor != null
        ? _range(_anchor!, _focused)
        : null;
    final states = {if (!_interactive) WidgetState.disabled};
    final showPreviousMonth =
        !_interactive || _same(_displayed, _month(widget.firstDate))
        ? null
        : () => _showMonth(_shiftMonth(_displayed, -1));
    final showNextMonth =
        !_interactive || _same(_displayed, _month(widget.lastDate))
        ? null
        : () => _showMonth(_shiftMonth(_displayed, 1));
    final weeks = _weeks();
    final Widget content;
    if (widget.isRange) {
      final preview = _preview;
      final state = NakedRangeCalendarState(
        states: states,
        displayedMonth: _displayed,
        focusedDate: _focused,
        value: widget.rangeValue,
        anchor: _anchor,
        preview: preview,
        isPreviewValid: preview != null && _selectable(_focused),
        // Validity depends only on widget inputs, so it is rechecked when the
        // widget updates rather than on every focus move or browse.
        isValueValid: _valueValid ??=
            widget.rangeValue == null || _validRange(widget.rangeValue!),
        weeks: weeks,
        showPreviousMonth: showPreviousMonth,
        showNextMonth: showNextMonth,
        showMonth: _interactive ? _showMonth : null,
      );
      content = NakedStateScopeBuilder(
        value: state,
        builder: widget.rangeBuilder!,
      );
    } else {
      final state = NakedCalendarState(
        states: states,
        displayedMonth: _displayed,
        focusedDate: _focused,
        value: widget.value,
        weeks: weeks,
        showPreviousMonth: showPreviousMonth,
        showNextMonth: showNextMonth,
        showMonth: _interactive ? _showMonth : null,
      );
      content = NakedStateScopeBuilder(value: state, builder: widget.builder!);
    }
    return Focus(
      focusNode: effectiveFocusNode,
      skipTraversal: true,
      canRequestFocus: _interactive,
      descendantsAreFocusable: _interactive,
      descendantsAreTraversable: _interactive,
      autofocus: widget.autofocus,
      includeSemantics: false,
      onKeyEvent: (_, event) {
        if (widget.isRange &&
            _anchor != null &&
            event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          setState(() => _anchor = null);
        }
        return KeyEventResult.ignored;
      },
      onFocusChange: (focused) {
        if (focused && effectiveFocusNode.hasPrimaryFocus) _requestDayFocus();
      },
      child: ExcludeSemantics(
        excluding: widget.excludeSemantics,
        child: Semantics(
          container: true,
          explicitChildNodes: true,
          label: widget.semanticLabel,
          child: _CalendarScope(
            owner: this,
            displayedMonth: _displayed,
            child: content,
          ),
        ),
      ),
    );
  }
}

class _CalendarScope extends InheritedWidget {
  const _CalendarScope({
    required this.owner,
    required this.displayedMonth,
    required super.child,
  });
  final _CalendarState owner;
  final DateTime displayedMonth;
  @override
  bool updateShouldNotify(_CalendarScope oldWidget) => true;
}

/// Where a day sits in the interval a [NakedRangeCalendar] paints.
///
/// The painted interval is the draft while one exists, otherwise the
/// committed value. Single-date calendars always report [none].
enum NakedRangePosition {
  /// Outside the painted interval, or in a single-date calendar.
  none,

  /// First day of an interval longer than one day.
  start,

  /// A day strictly between the first and last day.
  middle,

  /// Last day of an interval longer than one day.
  end,

  /// The only day of a one-day interval.
  single,
}

/// Immutable interaction state for a calendar day.
class NakedCalendarDayState extends NakedState {
  /// Creates a date and interaction snapshot.
  NakedCalendarDayState({
    required super.states,
    required this.date,
    required this.isToday,
    required this.isUnavailable,
    this.isOutsideMonth = false,
    this.rangePosition = NakedRangePosition.none,
    this.isInPreview = false,
  });

  /// Date represented by this day, compared by civil fields.
  final DateTime date;

  /// Whether this is the configured current date.
  final bool isToday;

  /// Whether the availability predicate rejects this in-bounds date.
  ///
  /// Dates outside the calendar bounds are disabled but not unavailable.
  final bool isUnavailable;

  /// Whether this day is not in the displayed month, such as a grid that is
  /// still animating out. Such a day is inert: disabled, unfocusable and
  /// excluded from semantics.
  final bool isOutsideMonth;

  /// Position in the painted interval: the draft while one exists, otherwise
  /// the committed value. Use it to draw interval caps and connections.
  final NakedRangePosition rangePosition;

  /// Whether this day is inside the current draft, from its anchor to the
  /// focused day. Draft days are never selected; selection stays committed.
  final bool isInPreview;

  /// Reads the nearest day interaction snapshot.
  static NakedCalendarDayState of(BuildContext context) =>
      NakedState.of(context);

  /// Returns the nearest [NakedCalendarDayState], if one is available.
  static NakedCalendarDayState? maybeOf(BuildContext context) =>
      NakedState.maybeOf(context);

  /// Returns the controller from the nearest state scope.
  static WidgetStatesController controllerOf(BuildContext context) =>
      NakedState.controllerOf<NakedCalendarDayState>(context);

  /// Returns the nearest state scope's controller, if one is available.
  static WidgetStatesController? maybeControllerOf(BuildContext context) =>
      NakedState.maybeControllerOf<NakedCalendarDayState>(context);

  @override
  List<Object?> get props => [
    ...super.props,
    date,
    isToday,
    isUnavailable,
    isOutsideMonth,
    rangePosition,
    isInPreview,
  ];
}

/// Behavior-owning part of the nearest [NakedCalendar] or [NakedRangeCalendar].
///
/// Build each displayed date once. Provide a complete, localized date in
/// [semanticLabel], including any desired today context. The visual builder
/// cannot remove gestures or keyboard handling. Use [excludeSemantics] to
/// hide the day from accessibility services.
///
/// A day outside the displayed month builds inert rather than failing, so a
/// month transition can keep the outgoing grid mounted. If a displayed date is
/// built twice, the most recently mounted day owns keyboard focus.
class NakedCalendarDay extends StatefulWidget {
  /// Creates a behavior-owning visible day with stable civil-date identity.
  NakedCalendarDay({
    Key? key,
    required this.date,
    required this.semanticLabel,
    required this.builder,
    this.excludeSemantics = false,
  }) : super(key: key ?? ValueKey(_date(date)));

  /// Date represented by this day, compared by civil fields.
  final DateTime date;

  /// Complete localized date name, replacing visual descendant semantics.
  final String semanticLabel;

  /// Builds only the day visual inside owned interaction and semantics.
  final ValueWidgetBuilder<NakedCalendarDayState> builder;

  /// Whether to hide this widget and its children from accessibility services.
  final bool excludeSemantics;

  @override
  State<NakedCalendarDay> createState() => _NakedCalendarDayState();
}

class _NakedCalendarDayState extends State<NakedCalendarDay>
    with WidgetStatesMixin<NakedCalendarDay>, FocusNodeMixin<NakedCalendarDay> {
  static int _mounts = 0;
  // Orders duplicate builds of one date, such as an incoming and an outgoing
  // grid during a transition: the newest mounted day owns keyboard focus.
  final int _mountOrder = _mounts++;
  _CalendarState? _owner;
  DateTime? _registered;
  bool _outside = false;
  @override
  FocusNode? get widgetProvidedNode => null;
  DateTime get _day => _date(widget.date);

  void _unregister() {
    final owner = _owner;
    if (owner != null && owner._days[_registered] == effectiveFocusNode) {
      owner._days.remove(_registered);
      owner._dayOrder.remove(_registered);
    }
    _registered = null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scope = context.dependOnInheritedWidgetOfExactType<_CalendarScope>();
    if (scope == null)
      throw FlutterError(
        'NakedCalendarDay requires a NakedCalendar or NakedRangeCalendar ancestor.',
      );
    _attach(scope);
  }

  void _attach(_CalendarScope scope) {
    _owner = scope.owner;
    final displayed = scope.displayedMonth;
    _outside = _day.year != displayed.year || _day.month != displayed.month;
    if (_outside) {
      _unregister();
    } else {
      _register(scope.owner);
    }
    _syncInteractionState();
  }

  void _register(_CalendarState owner) {
    _unregister();
    final newer = owner._dayOrder[_day];
    if (newer != null && newer > _mountOrder) return;
    owner._days[_day] = effectiveFocusNode;
    owner._dayOrder[_day] = _mountOrder;
    _registered = _day;
  }

  @override
  void didUpdateWidget(NakedCalendarDay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_same(oldWidget.date, widget.date)) {
      _attach(context.dependOnInheritedWidgetOfExactType<_CalendarScope>()!);
    } else {
      _syncInteractionState();
    }
  }

  void _syncInteractionState() {
    final selectable = !_outside && _owner!._selectable(_day);
    if (!selectable && isPressed) updatePressState(false, null);
    // Hover advertises a click; unavailable and inert days have none.
    if (!selectable && isHovered) updateHoverState(false, null);
    if (_outside && isFocused) updateFocusState(false, null);
  }

  @override
  void dispose() {
    _unregister();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final owner = _owner!;
    final inBounds = owner._inBounds(_day);
    final unavailable =
        inBounds && (owner.widget.isDateUnavailable?.call(_day) ?? false);
    final isToday = _same(_day, owner.widget.currentDate ?? DateTime.now());
    // Outgoing days keep their interval position so a transition still
    // paints the range they belong to.
    final rangePosition = owner._rangePosition(_day);
    final inPreview = owner._inPreview(_day);
    if (_outside) {
      // Inert, but a selected date keeps painting as selected while its grid
      // fades out.
      return ExcludeSemantics(
        child: NakedStateScopeBuilder(
          value: NakedCalendarDayState(
            states: {
              WidgetState.disabled,
              if (_same(_day, owner.widget.value)) WidgetState.selected,
            },
            date: _day,
            isToday: isToday,
            isUnavailable: unavailable,
            isOutsideMonth: true,
            rangePosition: rangePosition,
            isInPreview: inPreview,
          ),
          builder: widget.builder,
        ),
      );
    }
    final interactive = owner._interactive;
    final focusable = interactive && inBounds;
    final selectable = owner._selectable(_day);
    final state = NakedCalendarDayState(
      states: {
        ...widgetStates,
        if (!selectable) WidgetState.disabled,
        if (owner._selected(_day)) WidgetState.selected,
      },
      date: _day,
      isToday: isToday,
      isUnavailable: unavailable,
      rangePosition: rangePosition,
      isInPreview: inPreview,
    );
    return NakedFocusableDetector(
      enabled: interactive,
      canRequestFocus: focusable,
      // Only the newest duplicate of the focused date is a tab stop; an older
      // one, such as the outgoing grid of a month transition, is not.
      skipTraversal:
          !_same(_day, owner._focused) || owner._dayOrder[_day] != _mountOrder,
      includeSemantics: false,
      focusNode: effectiveFocusNode,
      onFocusChange: (focused) {
        updateFocusState(focused, null);
        if (focused && !_same(owner._focused, _day))
          owner._move(_day, requestFocus: false);
      },
      onHoverChange: (hovered) => updateHoverState(hovered && selectable, null),
      mouseCursor: selectable
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onKeyEvent: (_, event) =>
          owner._key(_day, event, Directionality.of(context)),
      child: ExcludeSemantics(
        excluding: widget.excludeSemantics,
        child: Semantics(
          container: true,
          button: true,
          enabled: selectable,
          selected: state.isSelected,
          focusable: focusable,
          focused: state.isFocused,
          // Match Focus's platform policy while owning the single day node.
          onFocus: defaultTargetPlatform != TargetPlatform.iOS && focusable
              ? () => requestFocusInView(effectiveFocusNode)
              : null,
          label: widget.semanticLabel,
          excludeSemantics: true,
          onTap: selectable ? () => owner._select(_day) : null,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            excludeFromSemantics: true,
            onTapDown: selectable
                ? (_) {
                    effectiveFocusNode.requestFocus();
                    updatePressState(true, null);
                  }
                : null,
            onTapUp: selectable ? (_) => updatePressState(false, null) : null,
            onTapCancel: selectable
                ? () => updatePressState(false, null)
                : null,
            onTap: selectable ? () => owner._select(_day) : null,
            child: NakedStateScopeBuilder(
              value: state,
              builder: widget.builder,
            ),
          ),
        ),
      ),
    );
  }
}
