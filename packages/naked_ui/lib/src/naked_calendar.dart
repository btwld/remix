import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'mixins/naked_mixins.dart';
import 'utilities/civil_date.dart';
import 'utilities/naked_focusable_detector.dart';
import 'utilities/focus_in_view.dart';
import 'utilities/naked_state_scope.dart';
import 'utilities/state.dart';

DateTime _date(DateTime date) => civilDate(date.year, date.month, date.day);
DateTime _month(DateTime date) => civilDate(date.year, date.month);

bool _same(DateTime? a, DateTime? b) =>
    a == null || b == null ? a == b : compareCivilDates(a, b) == 0;
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
    required this.previousMonth,
    required this.nextMonth,
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
  final VoidCallback? previousMonth;

  /// Next-month action, or null at the last month or when disabled.
  final VoidCallback? nextMonth;

  /// Requests a month, clamped to the inclusive bounds, without selecting.
  final ValueChanged<DateTime>? showMonth;

  /// Reads the nearest calendar builder state.
  static NakedCalendarState of(BuildContext context) => NakedState.of(context);

  @override
  List<Object?> get props => [
    ...super.props,
    displayedMonth,
    focusedDate,
    value,
    weeks,
    previousMonth,
    nextMonth,
    showMonth,
  ];
}

/// Headless controlled single-date calendar.
///
/// Build visible dates with [NakedCalendarDay]. Builders replace presentation,
/// not selection, keyboard, focus or semantics behavior. Bounds are inclusive.
/// An external value outside the bounds is retained; only focus/view are
/// clamped. Unavailable dates within the bounds remain keyboard-focusable.
class NakedCalendar extends StatefulWidget {
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

  @override
  State<NakedCalendar> createState() => _NakedCalendarState();
}

class _NakedCalendarState extends State<NakedCalendar>
    with FocusNodeMixin<NakedCalendar> {
  late DateTime _focused;
  late DateTime _displayed;
  final _days = <DateTime, FocusNode>{};
  bool get _interactive => widget.enabled && widget.onChanged != null;
  @override
  FocusNode? get widgetProvidedNode => widget.focusNode;

  void _validate() {
    if (compareCivilDates(widget.firstDate, widget.lastDate) > 0) {
      throw ArgumentError('firstDate must be on or before lastDate.');
    }
    if (widget.firstDayOfWeek < 1 || widget.firstDayOfWeek > 7) {
      throw ArgumentError.value(
        widget.firstDayOfWeek,
        'firstDayOfWeek',
        'Must be 1 through 7.',
      );
    }
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
  bool _selectable(DateTime date) =>
      _interactive &&
      _inBounds(date) &&
      !(widget.isDateUnavailable?.call(date) ?? false);

  @override
  void initState() {
    super.initState();
    _validate();
    final value = widget.value;
    _focused = _clamp(
      value != null && _inBounds(value)
          ? value
          : widget.currentDate ?? DateTime.now(),
    );
    _displayed = _month(_focused);
  }

  @override
  void didUpdateWidget(NakedCalendar oldWidget) {
    final ownedFocus = effectiveFocusNode.hasFocus;
    super.didUpdateWidget(oldWidget);
    final previous = _focused;
    // Clearing selection does not reset browsing. A new supplied date does.
    if (widget.value != null && !_same(widget.value, oldWidget.value)) {
      _focused = _clamp(widget.value!);
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
          !(priorFocus?.context == null && primary == priorScope))
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
    if (_selectable(date)) widget.onChanged!(_date(date));
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
    final state = NakedCalendarState(
      states: {if (!_interactive) WidgetState.disabled},
      displayedMonth: _displayed,
      focusedDate: _focused,
      value: widget.value,
      weeks: _weeks(),
      previousMonth:
          !_interactive || _same(_displayed, _month(widget.firstDate))
          ? null
          : () => _showMonth(_shiftMonth(_displayed, -1)),
      nextMonth: !_interactive || _same(_displayed, _month(widget.lastDate))
          ? null
          : () => _showMonth(_shiftMonth(_displayed, 1)),
      showMonth: _interactive ? _showMonth : null,
    );
    return Focus(
      focusNode: effectiveFocusNode,
      skipTraversal: true,
      canRequestFocus: _interactive,
      descendantsAreFocusable: _interactive,
      descendantsAreTraversable: _interactive,
      autofocus: widget.autofocus,
      includeSemantics: false,
      onFocusChange: (focused) {
        if (focused && effectiveFocusNode.hasPrimaryFocus) _requestDayFocus();
      },
      child: Semantics(
        container: true,
        explicitChildNodes: true,
        label: widget.semanticLabel,
        child: _CalendarScope(
          owner: this,
          snapshot: state,
          child: NakedStateScopeBuilder(value: state, builder: widget.builder),
        ),
      ),
    );
  }
}

class _CalendarScope extends InheritedWidget {
  const _CalendarScope({
    required this.owner,
    required this.snapshot,
    required super.child,
  });
  final _NakedCalendarState owner;
  final NakedCalendarState snapshot;
  @override
  bool updateShouldNotify(_CalendarScope oldWidget) =>
      !identical(snapshot, oldWidget.snapshot);
}

/// Immutable interaction state for a calendar day.
class NakedCalendarDayState extends NakedState {
  /// Creates a date and interaction snapshot.
  NakedCalendarDayState({
    required super.states,
    required this.date,
    required this.isToday,
    required this.isUnavailable,
  });

  /// Date represented by this day, compared by civil fields.
  final DateTime date;

  /// Whether this is the configured current date.
  final bool isToday;

  /// Whether the calendar predicate marks this date unavailable.
  final bool isUnavailable;

  /// Reads the nearest day interaction snapshot.
  static NakedCalendarDayState of(BuildContext context) =>
      NakedState.of(context);
  @override
  List<Object?> get props => [...super.props, date, isToday, isUnavailable];
}

/// Behavior-owning part of the nearest [NakedCalendar].
///
/// Each visible date must appear once. Provide a complete, localized date in
/// [semanticLabel], including any desired today context. The visual builder
/// cannot remove the button semantics, gestures or keyboard handling.
class NakedCalendarDay extends StatefulWidget {
  /// Creates a behavior-owning visible day with stable civil-date identity.
  NakedCalendarDay({
    Key? key,
    required this.date,
    required this.semanticLabel,
    required this.builder,
  }) : super(key: key ?? ValueKey(_date(date)));

  /// Date represented by this day, compared by civil fields.
  final DateTime date;

  /// Complete localized date name, replacing visual descendant semantics.
  final String semanticLabel;

  /// Builds only the day visual inside owned interaction and semantics.
  final ValueWidgetBuilder<NakedCalendarDayState> builder;
  @override
  State<NakedCalendarDay> createState() => _NakedCalendarDayState();
}

class _NakedCalendarDayState extends State<NakedCalendarDay>
    with WidgetStatesMixin<NakedCalendarDay>, FocusNodeMixin<NakedCalendarDay> {
  _NakedCalendarState? _owner;
  DateTime? _registered;
  @override
  FocusNode? get widgetProvidedNode => null;
  DateTime get _day => _date(widget.date);

  void _unregister() {
    if (_owner?._days[_registered] == effectiveFocusNode)
      _owner?._days.remove(_registered);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scope = context.dependOnInheritedWidgetOfExactType<_CalendarScope>();
    if (scope == null)
      throw FlutterError('NakedCalendarDay requires a NakedCalendar ancestor.');
    if (_day.year != scope.snapshot.displayedMonth.year ||
        _day.month != scope.snapshot.displayedMonth.month) {
      throw FlutterError(
        'NakedCalendarDay must belong to the displayed month.',
      );
    }
    _register(scope);
    _syncInteractionState();
  }

  void _register(_CalendarScope scope) {
    _unregister();
    _owner = scope.owner;
    final existing = _owner!._days[_day];
    assert(
      existing == null || existing == effectiveFocusNode,
      'Each calendar date must appear once.',
    );
    _owner!._days[_day] = effectiveFocusNode;
    _registered = _day;
  }

  @override
  void didUpdateWidget(NakedCalendarDay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_same(oldWidget.date, widget.date)) {
      final scope = context
          .dependOnInheritedWidgetOfExactType<_CalendarScope>()!;
      if (_day.year != scope.snapshot.displayedMonth.year ||
          _day.month != scope.snapshot.displayedMonth.month) {
        throw FlutterError(
          'NakedCalendarDay must belong to the displayed month.',
        );
      }
      _register(scope);
    }
    _syncInteractionState();
  }

  void _syncInteractionState() {
    final owner = _owner!;
    if (!owner._selectable(_day) && isPressed) updatePressState(false, null);
    if (!owner._interactive && isHovered) updateHoverState(false, null);
  }

  @override
  void dispose() {
    _unregister();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final owner = _owner!;
    final interactive = owner._interactive;
    final focusable = interactive && owner._inBounds(_day);
    final selectable = owner._selectable(_day);
    final unavailable = owner.widget.isDateUnavailable?.call(_day) ?? false;
    final state = NakedCalendarDayState(
      states: {
        ...widgetStates,
        if (!selectable) WidgetState.disabled,
        if (_same(_day, owner.widget.value)) WidgetState.selected,
      },
      date: _day,
      isToday: _same(_day, owner.widget.currentDate ?? DateTime.now()),
      isUnavailable: unavailable,
    );
    return NakedFocusableDetector(
      enabled: interactive,
      canRequestFocus: focusable,
      skipTraversal: !_same(_day, owner._focused),
      includeSemantics: false,
      focusNode: effectiveFocusNode,
      onFocusChange: (focused) {
        updateFocusState(focused, null);
        if (focused && !_same(owner._focused, _day))
          owner._move(_day, requestFocus: false);
      },
      onHoverChange: (hovered) => updateHoverState(hovered, null),
      mouseCursor: selectable
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onKeyEvent: (_, event) =>
          owner._key(_day, event, Directionality.of(context)),
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
          onTapCancel: selectable ? () => updatePressState(false, null) : null,
          onTap: selectable ? () => owner._select(_day) : null,
          child: NakedStateScopeBuilder(value: state, builder: widget.builder),
        ),
      ),
    );
  }
}
