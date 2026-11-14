import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../components/calendar.dart';
import '../../components/date_picker.dart';
import '../../components/date_range_picker.dart';
import 'dashboard_demo_data.dart';
import 'dashboard_demo_page_header.dart';
import 'dashboard_demo_typography.dart';
import 'dashboard_demo_ui.dart';
import 'dashboard_demo_widgets.dart';
import 'dashboard_overview.dart';

/// The Schedule page: the studio calendar beside the day and the weeks ahead.
///
/// Picking a day on the calendar shows what is on it. The agenda lists
/// everything inside a date range the user can change, and new events are
/// dated with a date picker.
class FortalDashboardSchedulePage extends StatefulWidget {
  const FortalDashboardSchedulePage({super.key, this.data});

  /// The records the page shows. Defaults to [fortalDashboardSampleData].
  final FortalDashboardData? data;

  @override
  State<FortalDashboardSchedulePage> createState() =>
      _FortalDashboardSchedulePageState();
}

class _FortalDashboardSchedulePageState
    extends State<FortalDashboardSchedulePage> {
  static final _split = GridBoxStyler.columns(const [.fixed(372), .fr(1)])
      .gap(fortalDashboardGap)
      .onConstraints(
        const .maxWidth(859),
        .equalColumns(1).gap(fortalDashboardGap),
      );

  /// Events the user added on this page, kept apart from the caller's data.
  final _added = <FortalDashboardEvent>[];
  late DateTime _day = _data.today;
  late CivilDateRange _range = CivilDateRange(
    start: _data.today,
    end: _data.today.add(const Duration(days: 30)),
  );

  FortalDashboardData get _data => widget.data ?? fortalDashboardSampleData;

  DateTime get _first => DateTime(_data.today.year - 1);

  DateTime get _last => DateTime(_data.today.year + 2, 12, 31);

  List<FortalDashboardEvent> get _events =>
      [..._data.events, ..._added]..sort((a, b) => a.date.compareTo(b.date));

  @override
  Widget build(BuildContext context) {
    final events = _events;
    final onDay = [
      for (final event in events)
        if (_sameDay(event.date, _day)) event,
    ];
    final inRange = [
      for (final event in events)
        if (!event.date.isBefore(_range.start) &&
            !event.date.isAfter(_range.end))
          event,
    ];

    return FortalPage(
      key: const ValueKey('dashboard-schedule'),
      title: 'Schedule',
      description: 'Releases, proofs and pickups on the studio calendar.',
      actions: [
        FortalButton(
          key: const ValueKey('schedule-new-event'),
          label: 'New event',
          leadingIcon: RemixIcons.plus,
          onPressed: _addEvent,
        ),
      ],
      children: [
        GridBox(
          key: const ValueKey('schedule-split'),
          style: _split,
          children: [
            FortalSurface(
              child: ColumnBox(
                style: FlexBoxStyler()
                    .crossAxisAlignment(.center)
                    .spacing(FortalTokens.space3()),
                children: [
                  FortalCalendar(
                    key: const ValueKey('schedule-calendar'),
                    value: _day,
                    firstDate: _first,
                    lastDate: _last,
                    currentDate: _data.today,
                    semanticLabel: 'Studio calendar',
                    onChanged: (day) => setState(() => _day = day),
                  ),
                  const FortalDivider(size: .size4),
                  ColumnBox(
                    key: const ValueKey('schedule-day'),
                    style: FlexBoxStyler()
                        .crossAxisAlignment(.stretch)
                        .spacing(FortalTokens.space3()),
                    children: [
                      FortalCardHeader(
                        title: fortalDashboardDay(_day),
                        description: switch (onDay.length) {
                          0 => 'Nothing scheduled',
                          1 => '1 event',
                          final count => '$count events',
                        },
                      ),
                      for (final event in onDay)
                        FortalEventTile(event, showKind: true),
                    ],
                  ),
                ],
              ),
            ),
            FortalSurface(
              child: ColumnBox(
                style: FlexBoxStyler()
                    .crossAxisAlignment(.stretch)
                    .spacing(FortalTokens.space3()),
                children: [
                  // The picker is wide, so it drops under the title when the
                  // card cannot hold both.
                  WrapBox(
                    style: WrapBoxStyler()
                        .wrapAlignment(.spaceBetween)
                        .crossAxisAlignment(.center)
                        .spacing(FortalTokens.space3())
                        .runSpacing(FortalTokens.space3()),
                    children: [
                      FortalCardTitle(
                        title: 'Agenda',
                        description: switch (inRange.length) {
                          1 => '1 event in range',
                          final count => '$count events in range',
                        },
                      ),
                      FortalDateRangePicker(
                        key: const ValueKey('schedule-range'),
                        value: _range,
                        firstDate: _first,
                        lastDate: _last,
                        currentDate: _data.today,
                        semanticLabel: 'Agenda range',
                        formatRange: (range) =>
                            '${fortalDashboardMonth(range.start)} '
                            '${range.start.day} – '
                            '${fortalDashboardMonth(range.end)} '
                            '${range.end.day}',
                        onChanged: (range) => setState(() => _range = range),
                      ),
                    ],
                  ),
                  if (inRange.isEmpty)
                    const FortalEmptyState(
                      icon: RemixIcons.calendar,
                      title: 'Nothing in this range',
                      body: 'Widen the range or add an event.',
                    )
                  else
                    for (final (index, event) in inRange.indexed) ...[
                      if (index > 0) const FortalDivider(size: .size4),
                      FortalEventTile(event, showKind: true),
                    ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _addEvent() async {
    final event = await showRemixDialog<FortalDashboardEvent>(
      context: context,
      barrierLabel: 'Dismiss',
      builder: (context) =>
          _NewEventDialog(initial: _day, first: _first, last: _last),
    );
    if (!mounted || event == null) return;
    setState(() {
      _added.add(event);
      _day = event.date;
    });
    showRemixToast(
      context,
      RemixToastData(
        title: '${event.title} added to ${fortalDashboardDay(event.date)}',
        icon: RemixIcons.checkCircle,
      ),
    );
  }
}

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

class _NewEventDialog extends StatefulWidget {
  const _NewEventDialog({
    required this.initial,
    required this.first,
    required this.last,
  });

  final DateTime initial;
  final DateTime first;
  final DateTime last;

  @override
  State<_NewEventDialog> createState() => _NewEventDialogState();
}

class _NewEventDialogState extends State<_NewEventDialog> {
  final _title = TextEditingController();
  late DateTime _date = widget.initial;
  bool _submitted = false;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _title.text.trim();
    if (title.isEmpty) {
      setState(() => _submitted = true);
      return;
    }
    Navigator.of(context).pop(
      FortalDashboardEvent(
        title: title,
        date: _date,
        time: 'All day',
        kind: .studio,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final missing = _submitted && _title.text.trim().isEmpty;
    return FortalDialog(
      key: const ValueKey('schedule-dialog'),
      title: 'New event',
      description: 'Add something to the studio calendar.',
      actions: [
        FortalButton.soft(
          label: 'Cancel',
          onPressed: () => Navigator.of(context).pop(),
        ),
        FortalButton(
          key: const ValueKey('schedule-dialog-add'),
          label: 'Add event',
          onPressed: _submit,
        ),
      ],
      child: ColumnBox(
        style: FlexBoxStyler()
            .mainAxisSize(.min)
            .crossAxisAlignment(.stretch)
            .spacing(FortalTokens.space4()),
        children: [
          FortalTextField(
            key: const ValueKey('schedule-dialog-title'),
            controller: _title,
            label: 'Title',
            hintText: 'Proof review',
            autofocus: true,
            error: missing,
            helperText: missing ? 'Give the event a title.' : null,
            onChanged: (_) {
              if (_submitted) setState(() {});
            },
            onSubmitted: (_) => _submit(),
          ),
          ColumnBox(
            style: FlexBoxStyler()
                .crossAxisAlignment(.start)
                .spacing(FortalTokens.space2()),
            children: [
              // The picker below carries the accessible name.
              const ExcludeSemantics(
                child: FortalText('Date', size: .size2, weight: .medium),
              ),
              FortalDatePicker(
                key: const ValueKey('schedule-dialog-date'),
                value: _date,
                firstDate: widget.first,
                lastDate: widget.last,
                semanticLabel: 'Event date',
                formatDate: fortalDashboardShortDate,
                onChanged: (date) => setState(() => _date = date),
              ),
            ],
          ),
          StyledText(
            'It is added for this session only.',
            style: dashboardText(.size1, tone: .muted),
          ),
        ],
      ),
    );
  }
}
