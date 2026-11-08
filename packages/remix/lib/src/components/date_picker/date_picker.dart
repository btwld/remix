/// A button-triggered, controlled single-date calendar.
library remix_date_picker;

import 'package:flutter/widgets.dart';
import 'package:naked_ui/naked_ui.dart' show OverlayPositionConfig;

import '../button/button.dart';
import '../calendar/calendar.dart';
import '../icon_button/icon_button.dart';
import '../popover/popover.dart';
import '../select/select.dart';

/// Composes a real button, popover and [RemixCalendar].
///
/// Selection remains parent-owned. A valid activation requests one date and
/// closes even when the parent keeps its old value. Dismissal never selects.
/// An Overlay ancestor is required. Labels default to English; callers own
/// localization through [placeholder], [semanticLabel], [formatDate] and
/// [calendarLabels]. The popover contains focus but is not a modal dialog.
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
    this.buttonStyle = const ButtonStyler.create(),
    this.calendarStyle = const CalendarStyler.create(),
    this.popoverStyle = const PopoverStyler.create(),
    this.navigationStyle = const IconButtonStyler.create(),
    this.selectorStyle = const SelectStyler.create(),
  });

  final DateTime? value;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime>? onChanged;

  /// Called when the picker's popover opens.
  final VoidCallback? onOpen;

  /// Called when the popover closes: after [onChanged] for a completed
  /// selection, or alone when the picker is dismissed without selecting.
  final VoidCallback? onClose;
  final DateTime? currentDate;
  final bool Function(DateTime)? isDateUnavailable;
  final int firstDayOfWeek;
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
  final RemixCalendarLabels calendarLabels;
  final FocusNode? focusNode;
  final bool autofocus;
  final OverlayPositionConfig positioning;

  /// Each child resolves its own style against its own interaction state.
  final ButtonStyler buttonStyle;
  final CalendarStyler calendarStyle;
  final PopoverStyler popoverStyle;
  final IconButtonStyler navigationStyle;
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

class _DatePickerHost<T> extends StatefulWidget {
  const _DatePickerHost({
    required this.enabled,
    required this.onChanged,
    required this.onOpen,
    required this.onClose,
    required this.label,
    required this.semanticLabel,
    required this.semanticValue,
    required this.focusNode,
    required this.autofocus,
    required this.positioning,
    required this.buttonStyle,
    required this.popoverStyle,
    required this.calendarBuilder,
  });

  final bool enabled;
  final ValueChanged<T>? onChanged;
  final VoidCallback? onOpen;
  final VoidCallback? onClose;
  final String label;

  /// The trigger's accessible name: the field purpose.
  final String semanticLabel;

  /// The trigger's accessible value: the complete selection, or the empty
  /// text. Kept apart from [semanticLabel] so assistive technology joins the
  /// two in its own locale, and independent of the painted [label].
  final String semanticValue;
  final FocusNode? focusNode;
  final bool autofocus;
  final OverlayPositionConfig positioning;
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

  /// Callback validity token. Every open and close advances it, and each
  /// selection callback, scheduled close and focus entry captures the value of
  /// its own opening, so work queued by an earlier opening never selects into
  /// or closes a newer one.
  int _session = 0;

  /// Identity of the current opening's calendar. Only opening advances it: a
  /// same-frame close/reopen can keep the overlay mounted, so the new key is
  /// what gives every opening a fresh calendar (browsed month, focus, draft),
  /// while a closing panel keeps its content through any exit animation.
  int _opening = 0;
  final _triggerFocus = FocusNode(debugLabel: 'Remix date picker trigger');
  final _calendarFocus = FocusNode(debugLabel: 'Remix date picker calendar');
  Size? _viewSize;

  bool get _interactive => widget.enabled && widget.onChanged != null;
  FocusNode get _trigger => widget.focusNode ?? _triggerFocus;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // A new view size invalidates the anchor's placement, so close as
    // RawMenuAnchor does. It only does so for root anchors; a picker nested in
    // another menu or popover still needs this. Keyboard and safe-area changes
    // only re-fit the view-safe panel: closing on them would dismiss the picker
    // while the keyboard hides after its trigger takes focus from a text field.
    final size = MediaQuery.maybeSizeOf(context);
    if (_viewSize != null && size != _viewSize) _scheduleClose();
    _viewSize = size;
  }

  @override
  void didUpdateWidget(covariant _DatePickerHost<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_interactive || oldWidget.focusNode != widget.focusNode) {
      _scheduleClose();
    }
  }

  void _scheduleClose() {
    if (!_controller.isOpen) return;
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
    setState(() {
      _session = session;
      _opening++;
    });
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
    setState(() => _session++);
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
        key: ValueKey(_opening),
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
          semanticLabel: widget.semanticLabel,
          onPressed: _interactive ? _toggle : null,
          enabled: _interactive,
          focusNode: _trigger,
          autofocus: widget.autofocus,
          style: widget.buttonStyle,
        ),
      ),
    );
  }
}
