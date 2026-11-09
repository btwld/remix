/// Button-triggered, controlled date and date-range calendars.
library remix_date_picker;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:naked_ui/naked_ui.dart'
    show CivilDateRange, OverlayPositionConfig, isSameCivilDate;

import '../button/button.dart';
import '../calendar/calendar.dart';
import '../icon_button/icon_button.dart';
import '../popover/popover.dart';
import '../select/select.dart';

part 'date_range_picker.dart';

/// Composes a real button, popover and [RemixCalendar].
///
/// Selection remains parent-owned. A valid activation requests one date and
/// closes even when the parent keeps its old value. Dismissal never selects.
/// An Overlay ancestor is required. Labels default to English; callers own
/// localization through [placeholder], [semanticLabel], [formatDate] and
/// [calendarLabels], including [RemixCalendarLabels.noDate] for an empty value.
/// The popover contains focus but is not a modal dialog. Scrolling an ancestor
/// closes a root picker. A picker nested in a menu or popover closes when that
/// outer root closes. Removing an open picker does not call [onClose].
class RemixDatePicker extends StatelessWidget {
  const RemixDatePicker({
    super.key,
    required this.value,
    required this.firstDate,
    required this.lastDate,
    this.onChanged,
    this.onOpen,
    this.onClose,
    this.currentDate,
    this.isDateUnavailable,
    this.firstDayOfWeek = DateTime.sunday,
    this.enabled = true,
    this.semanticLabel = 'Choose date',
    this.placeholder = 'Select date',
    this.formatDate,
    this.calendarLabels = const RemixCalendarLabels(),
    this.focusNode,
    this.autofocus = false,
    this.positioning = const OverlayPositionConfig(
      sideOffset: 4,
      collisionPadding: EdgeInsets.all(8),
    ),
    this.icon,
    this.placeholderStyle = const ButtonStyler.create(),
    this.expandedStyle = const ButtonStyler.create(),
    this.buttonStyle = const ButtonStyler.create(),
    this.calendarStyle = const CalendarStyler.create(),
    this.popoverStyle = const PopoverStyler.create(),
    this.navigationStyle = const IconButtonStyler.create(),
    this.selectorStyle = const SelectStyler.create(),
  });

  /// Parent-owned selected date, or null for an empty selection.
  /// Civil-date comparison and bounds follow [RemixCalendar].
  final DateTime? value;

  /// Inclusive earliest selectable civil date; time and UTC flag are ignored.
  final DateTime firstDate;

  /// Inclusive latest selectable civil date, on or after [firstDate].
  final DateTime lastDate;

  /// Requests one available date, then closes even if the parent rejects it.
  /// A null callback disables the picker.
  final ValueChanged<DateTime>? onChanged;

  /// Called when the picker's popover opens.
  final VoidCallback? onOpen;

  /// Called when the popover closes: after [onChanged] for a completed
  /// selection, or alone when the picker is dismissed without selecting.
  /// Removing an open picker does not call this callback.
  final VoidCallback? onClose;

  /// Today marker and fallback focus date; defaults to the current date.
  final DateTime? currentDate;

  /// Marks in-range dates unselectable while keeping them keyboard-focusable.
  final bool Function(DateTime)? isDateUnavailable;

  /// First weekday column, from Monday=1 through Sunday=7.
  final int firstDayOfWeek;

  /// Whether the trigger can open the calendar and dates can be selected.
  /// Disabling an open picker closes it without selecting.
  final bool enabled;

  /// Field purpose and the trigger's accessible name, such as "Appointment
  /// date". The trigger's accessible value is the selected date from
  /// [RemixCalendarLabels.fullDate], or [RemixCalendarLabels.noDate].
  final String semanticLabel;

  /// Visible trigger text without a selected date.
  final String placeholder;

  /// Visible trigger date text. Defaults to [RemixCalendarLabels.fullDate].
  ///
  /// It only changes what is painted: the accessible value always uses the
  /// complete [RemixCalendarLabels.fullDate], so compact formats such as
  /// "20/2" are never announced as the date.
  final String Function(DateTime)? formatDate;

  /// Caller-owned date labels and formatters; English by default.
  final RemixCalendarLabels calendarLabels;

  /// Optional caller-owned trigger focus node. Replacing it closes the picker.
  final FocusNode? focusNode;

  /// Whether to focus the trigger automatically; does not open the calendar.
  final bool autofocus;

  /// Panel placement, offsets and collision padding relative to the trigger.
  /// The panel also avoids the view's safe area and keyboard exclusions.
  final OverlayPositionConfig positioning;

  /// Decorative leading trigger icon. Its size and color follow [buttonStyle].
  final IconData? icon;

  /// Fragment merged over [buttonStyle] only while [value] is null.
  /// Interaction variants, including disabled styling, still resolve normally.
  final ButtonStyler placeholderStyle;

  /// Fragment merged last while the calendar popover is open.
  /// Nested month/year selectors keep this fragment active until dismissal.
  final ButtonStyler expandedStyle;

  /// Trigger styling, resolved against the trigger's own interaction state.
  /// The default label is one line with an ellipsis under a finite width.
  /// Overrides may replace its text layout; accessible values stay complete.
  final ButtonStyler buttonStyle;

  /// Calendar and day styling, resolved against each part's own state.
  final CalendarStyler calendarStyle;

  /// Styling for the popover panel containing the calendar.
  final PopoverStyler popoverStyle;

  /// Month-navigation button styling, resolved in each button's state.
  final IconButtonStyler navigationStyle;

  /// Month/year selector styling, resolved in each selector’s state.
  final SelectStyler selectorStyle;

  @override
  Widget build(BuildContext context) {
    final value = this.value;
    final label = value == null
        ? placeholder
        : (formatDate ?? calendarLabels.fullDate)(value);
    return _DatePickerHost<DateTime>(
      enabled: enabled,
      onChanged: onChanged,
      onOpen: onOpen,
      onClose: onClose,
      label: label,
      semanticLabel: semanticLabel,
      semanticValue: value == null
          ? calendarLabels.noDate
          : calendarLabels.fullDate(value),
      focusNode: focusNode,
      autofocus: autofocus,
      positioning: positioning,
      icon: icon,
      placeholderStyle: value == null
          ? placeholderStyle
          : const ButtonStyler.create(),
      expandedStyle: expandedStyle,
      buttonStyle: buttonStyle,
      popoverStyle: popoverStyle,
      calendarBuilder: (focus, select) => RemixCalendar(
        value: value,
        firstDate: firstDate,
        lastDate: lastDate,
        onChanged: select,
        currentDate: currentDate,
        isDateUnavailable: isDateUnavailable,
        firstDayOfWeek: firstDayOfWeek,
        enabled: select != null,
        semanticLabel: semanticLabel,
        focusNode: focus,
        labels: calendarLabels,
        style: calendarStyle,
        navigationStyle: navigationStyle,
        selectorStyle: selectorStyle,
      ),
    );
  }
}

// The typed calendar builder keeps selection callbacks concrete while sharing
// the picker lifecycle and shell. It supplies a calendar, not behavior strategies
// or a public protocol.
class _DatePickerHost<T> extends StatefulWidget {
  const _DatePickerHost({
    required this.enabled,
    required this.onChanged,
    required this.onOpen,
    required this.onClose,
    required this.label,
    this.textBuilder,
    required this.semanticLabel,
    required this.semanticValue,
    required this.focusNode,
    required this.autofocus,
    required this.positioning,
    required this.icon,
    required this.placeholderStyle,
    required this.expandedStyle,
    required this.buttonStyle,
    required this.popoverStyle,
    required this.calendarBuilder,
  });

  final bool enabled;
  final ValueChanged<T>? onChanged;
  final VoidCallback? onOpen;
  final VoidCallback? onClose;
  final String label;
  final RemixButtonTextBuilder? textBuilder;

  /// The trigger's accessible name: the field purpose.
  final String semanticLabel;

  /// The trigger's accessible value: the complete selection, or the empty
  /// text. Kept apart from [semanticLabel] so assistive technology joins the
  /// two in its own locale, and independent of the painted [label].
  final String semanticValue;
  final FocusNode? focusNode;
  final bool autofocus;
  final OverlayPositionConfig positioning;
  final IconData? icon;
  final ButtonStyler placeholderStyle;
  final ButtonStyler expandedStyle;
  final ButtonStyler buttonStyle;
  final PopoverStyler popoverStyle;

  /// Builds the popover calendar around the host's focus node and the
  /// current opening's selection callback (null while not interactive).
  final Widget Function(FocusNode, ValueChanged<T>?) calendarBuilder;

  @override
  State<_DatePickerHost<T>> createState() => _DatePickerHostState<T>();
}

class _DatePickerHostState<T> extends State<_DatePickerHost<T>> {
  final _controller = MenuController();

  /// Each open advances this token. Selection, queued closure and focus entry
  /// also require an open controller, so closing needs no separate invalidation.
  /// The calendar key uses the same token to reset browsing and focus even
  /// when a same-frame close/reopen keeps the overlay mounted.
  int _session = 0;
  final _triggerFocus = FocusNode(debugLabel: 'Remix date picker trigger');
  final _calendarFocus = FocusNode(debugLabel: 'Remix date picker calendar');

  bool get _interactive => widget.enabled && widget.onChanged != null;
  FocusNode get _trigger => widget.focusNode ?? _triggerFocus;

  @override
  void didUpdateWidget(covariant _DatePickerHost<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_interactive || oldWidget.focusNode != widget.focusNode) {
      _scheduleClose();
    }
  }

  void _scheduleClose() {
    if (!_controller.isOpen) return;
    // Defensive: a newer opening must not be closed by an older update.
    final session = _session;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _controller.isOpen && session == _session) {
        _controller.close();
      }
    });
  }

  void _toggle() {
    if (!_interactive) return;
    if (_controller.isOpen) {
      _controller.close();
    } else {
      // Nested anchors do not establish this history automatically.
      _trigger.requestFocus();
      _controller.open();
    }
  }

  void _startSession() {
    final session = _session + 1;
    setState(() => _session = session);
    // A same-frame close/open can retain AnchoredOverlay, so its mount-only
    // initial-focus hook does not run for the newly keyed calendar.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted ||
          !_interactive ||
          !_controller.isOpen ||
          session != _session ||
          _calendarFocus.context?.mounted != true ||
          _calendarFocus.hasFocus) {
        return;
      }
      final primary = FocusManager.instance.primaryFocus;
      if (primary != null &&
          primary != _trigger &&
          !(_calendarFocus.enclosingScope?.hasFocus ?? false)) {
        return; // A newer external focus request wins over session entry.
      }
      _calendarFocus.requestFocus();
    });
    // Callers run after the host's own session work, so a throwing callback
    // cannot skip the focus entry.
    widget.onOpen?.call();
  }

  void _endSession() {
    if (mounted) setState(() {});
    widget.onClose?.call();
  }

  void _select(T value, int session) {
    if (!mounted ||
        !_interactive ||
        !_controller.isOpen ||
        session != _session) {
      return;
    }
    try {
      widget.onChanged!(value);
    } finally {
      if (mounted && _controller.isOpen && session == _session) {
        _controller.close();
      }
    }
  }

  @override
  void dispose() {
    _calendarFocus.dispose();
    _triggerFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = _session;
    return RemixPopover(
      controller: _controller,
      openOnTap: false,
      // Only this picker's own popover opens a session; nested month and year
      // selectors are separate anchors and leave the session and key alone.
      onOpen: _startSession,
      onClose: _endSession,
      triggerFocusNode: _trigger,
      initialFocusNode: _calendarFocus,
      constrainToAvailableSpace: true,
      avoidViewInsets: true,
      positioning: widget.positioning,
      style: widget.popoverStyle,
      popoverChild: KeyedSubtree(
        key: ValueKey(_session),
        child: widget.calendarBuilder(
          _calendarFocus,
          _interactive ? (value) => _select(value, session) : null,
        ),
      ),
      // Name and value stay separate semantics fields, merged into the trigger
      // by the popover, so assistive technology joins them in its own locale.
      child: Semantics(
        value: widget.semanticValue,
        child: RemixButton(
          label: widget.label,
          textBuilder: widget.textBuilder,
          leadingIcon: widget.icon,
          semanticLabel: widget.semanticLabel,
          onPressed: _interactive ? _toggle : null,
          enabled: _interactive,
          focusNode: _trigger,
          autofocus: widget.autofocus,
          style: ButtonStyler()
              .label(TextStyler().maxLines(1).overflow(TextOverflow.ellipsis))
              .merge(widget.buttonStyle)
              .merge(widget.placeholderStyle)
              .merge(_controller.isOpen ? widget.expandedStyle : null),
        ),
      ),
    );
  }
}
