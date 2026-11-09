import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../ui/ui.dart';

// Calendar touch targets have no matching step on Fortal’s spacing scale.
const calendarDemoTarget = 44.0;
// Fits localized month captions; no spacing token represents this width.
const calendarDemoSelectorWidth = 146.0;

@widgetbook.UseCase(name: 'Appointment date', type: RemixCalendar)
Widget buildCalendarUseCase(BuildContext context) => const CalendarExample();

class CalendarExample extends StatefulWidget {
  const CalendarExample({super.key});

  @override
  State<CalendarExample> createState() => _CalendarExampleState();
}

class _CalendarExampleState extends State<CalendarExample> {
  DateTime? _value = DateTime(2026, 11, 12);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.all(FortalTokens.space1.resolve(context)),
    child: Center(
      child: RemixCalendar(
        value: _value,
        firstDate: DateTime(2025),
        lastDate: DateTime(2028, 12, 31),
        currentDate: DateTime(2026, 11, 6),
        semanticLabel: 'Appointment date',
        firstDayOfWeek: DateTime.monday,
        isDateUnavailable: (date) => date.weekday >= DateTime.saturday,
        onChanged: (date) => setState(() => _value = date),
        navigationStyle: fortalIconButtonStyle(
          variant: .ghost,
        ).size(calendarDemoTarget, calendarDemoTarget),
        selectorStyle: calendarDemoSelectorStyle(context),
        style: appointmentCalendarStyle(context),
      ),
    ),
  );
}

/// Shared geometry and day states for the inline and picker stories.
CalendarStyler appointmentCalendarStyle(
  BuildContext context,
) => CalendarStyler()
    .padding(.all(FortalTokens.space3()))
    .headerSpacing(FortalTokens.space2())
    .weekdaySpacing(FortalTokens.space1())
    .rowSpacing(FortalTokens.space1())
    .onDisabled(
      CalendarStyler().weekday(TextStyler().color(FortalTokens.gray9())),
    )
    .minWidth(
      MediaQuery.textScalerOf(context).scale(calendarDemoTarget) * 7 +
          FortalTokens.space3.resolve(context) * 2,
    )
    .weekday(
      TextStyler().style(FortalTokens.text1.mix()).color(FortalTokens.gray11()),
    )
    .day(
      CalendarDayStyler()
          .minWidth(MediaQuery.textScalerOf(context).scale(calendarDemoTarget))
          .minHeight(MediaQuery.textScalerOf(context).scale(calendarDemoTarget))
          .borderRadius(.all(FortalTokens.radius3()))
          .label(TextStyler().style(FortalTokens.text2.mix()))
          .onToday(
            CalendarDayStyler()
                .border(.color(FortalTokens.gray9()).width(1))
                .label(
                  TextStyler()
                      .color(FortalTokens.accent11())
                      .fontWeight(FontWeight.w700),
                ),
          )
          .onSelected(
            CalendarDayStyler()
                .color(FortalTokens.accentSolid())
                .label(TextStyler().color(FortalTokens.accentContrast())),
          )
          .onHovered(
            CalendarDayStyler()
                .color(FortalTokens.gray4())
                .onSelected(CalendarDayStyler().color(_selectedHover())),
          )
          .onPressed(
            CalendarDayStyler()
                .color(FortalTokens.gray6())
                .onSelected(CalendarDayStyler().color(_selectedPressed())),
          )
          .onFocusVisible(
            CalendarDayStyler().border(.color(FortalTokens.focus8()).width(2)),
          )
          .onDisabled(
            CalendarDayStyler().label(TextStyler().color(FortalTokens.gray9())),
          )
          .onUnavailable(
            CalendarDayStyler().label(
              TextStyler().decoration(TextDecoration.lineThrough),
            ),
          ),
    );

final _selectedHover = ContextToken<Color>(
  (context) => FortalTokens.accentSolid.resolve(context).withValues(alpha: .9),
);
final _selectedPressed = ContextToken<Color>(
  (context) => FortalTokens.accentSolid.resolve(context).withValues(alpha: .8),
);

/// Keep overflow discoverable in the capped month and year panels.
SelectStyler calendarDemoSelectorStyle(BuildContext context) =>
    fortalSelectStyle()
        .trigger(
          SelectTriggerStyler()
              .padding(.horizontal(FortalTokens.space2()))
              .height(FortalTokens.touchTargetMin())
              .width(
                MediaQuery.textScalerOf(
                  context,
                ).scale(calendarDemoSelectorWidth),
              ),
        )
        .content(
          SelectContentStyler().wrap(
            WidgetModifierConfig.modifier(const _CalendarScrollCueMix()),
          ),
        );

final class _CalendarScrollCueMix extends ModifierMix<_CalendarScrollCue> {
  const _CalendarScrollCueMix();
  @override
  _CalendarScrollCue resolve(BuildContext context) =>
      const _CalendarScrollCue();
  @override
  _CalendarScrollCueMix merge(_CalendarScrollCueMix? other) => other ?? this;
  @override
  List<Object?> get props => const [];
}

final class _CalendarScrollCue extends WidgetModifier<_CalendarScrollCue> {
  const _CalendarScrollCue();
  @override
  Widget build(Widget child) => ScrollConfiguration(
    behavior: const _CalendarScrollBehavior(),
    child: child,
  );
  @override
  _CalendarScrollCue copyWith() => this;
  @override
  _CalendarScrollCue lerp(_CalendarScrollCue? other, double t) => this;
  @override
  List<Object?> get props => const [];
}

class _CalendarScrollBehavior extends ScrollBehavior {
  const _CalendarScrollBehavior();
  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => RawScrollbar(
    controller: details.controller,
    thumbVisibility: true,
    thumbColor: FortalTokens.gray9.resolve(context),
    thickness: FortalTokens.space1.resolve(context),
    child: child,
  );
}
