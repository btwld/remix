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
class RemixDatePicker extends StatefulWidget {
  const RemixDatePicker({
    super.key,
    required this.value,
    required this.firstDate,
    required this.lastDate,
    this.onChanged,
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
  final DateTime? currentDate;
  final bool Function(DateTime)? isDateUnavailable;
  final int firstDayOfWeek;
  final bool enabled;

  /// Field purpose, combined with the displayed value on the trigger.
  final String semanticLabel;
  final String placeholder;

  /// Trigger date text. Defaults to [RemixCalendarLabels.fullDate].
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
  State<RemixDatePicker> createState() => _RemixDatePickerState();
}

class _RemixDatePickerState extends State<RemixDatePicker> {
  final _controller = MenuController();
  int _session = 0;
  final _triggerFocus = FocusNode(debugLabel: 'RemixDatePicker trigger');
  final _calendarFocus = FocusNode(debugLabel: 'RemixDatePicker calendar');
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
  void didUpdateWidget(covariant RemixDatePicker oldWidget) {
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

  void _select(DateTime date, int session) {
    if (!mounted ||
        !_interactive ||
        !_controller.isOpen ||
        session != _session) {
      return;
    }
    try {
      widget.onChanged!(date);
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
    final value = widget.value;
    final label = value == null
        ? widget.placeholder
        : (widget.formatDate ?? widget.calendarLabels.fullDate)(value);
    return RemixPopover(
      controller: _controller,
      onOpen: () => setState(() => _session++),
      onClose: () => setState(() => _session++),
      openOnTap: false,
      triggerFocusNode: _trigger,
      initialFocusNode: _calendarFocus,
      constrainToAvailableSpace: true,
      avoidViewInsets: true,
      positioning: widget.positioning,
      style: widget.popoverStyle,
      popoverChild: RemixCalendar(
        value: value,
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
        onChanged: _interactive ? (date) => _select(date, session) : null,
        currentDate: widget.currentDate,
        isDateUnavailable: widget.isDateUnavailable,
        firstDayOfWeek: widget.firstDayOfWeek,
        enabled: _interactive,
        semanticLabel: widget.semanticLabel,
        focusNode: _calendarFocus,
        labels: widget.calendarLabels,
        style: widget.calendarStyle,
        navigationStyle: widget.navigationStyle,
        selectorStyle: widget.selectorStyle,
      ),
      child: RemixButton(
        label: label,
        semanticLabel: '${widget.semanticLabel}, $label',
        onPressed: _interactive ? _toggle : null,
        enabled: _interactive,
        focusNode: _trigger,
        autofocus: widget.autofocus,
        style: widget.buttonStyle,
      ),
    );
  }
}
