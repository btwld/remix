import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../../theme/effects.dart';
import '../../theme/tokens.dart';
import '../calendar.dart';
import '../icon_button.dart';
import '../select.dart';

({
  ButtonStyler placeholder,
  ButtonStyler expanded,
  ButtonStyler button,
  PopoverStyler popover,
  IconButtonStyler navigation,
  SelectStyler selector,
  CalendarStyler calendar,
})
playgroundDatePickerStyles(
  BuildContext context,
  BoxConstraints constraints, {
  required ButtonStyler buttonStyle,
  required PopoverStyler popoverStyle,
  required IconButtonStyler navigationStyle,
  required SelectStyler selectorStyle,
  required CalendarStyler calendarStyle,
}) {
  final requested = buttonStyle
      .build(context)
      .spec
      .container
      .spec
      .box
      ?.spec
      .constraints;
  final dayWidth = playgroundCalendarDayWidth(context);
  final scaler = MediaQuery.textScalerOf(context);
  final iconSize = scaler.scale(PlaygroundTokens.icon);
  final calendarWidth =
      dayWidth * DateTime.daysPerWeek +
      PlaygroundTokens.s3 * 2 +
      PlaygroundTokens.strokeHairline * 2;
  final triggerMaxWidth = requested != null && requested.hasBoundedWidth
      ? requested.maxWidth
      : 0.0;
  final panelWidth = math.max(
    calendarWidth,
    math.max(
      constraints.minWidth,
      math.max(requested?.minWidth ?? 0.0, triggerMaxWidth),
    ),
  );
  return (
    placeholder: ButtonStyler().label(
      .color(PlaygroundTokens.mutedForeground()),
    ),
    expanded: ButtonStyler()
        .border(playgroundFocusBorder())
        .containerEffects(playgroundFocusRing()),
    button: ButtonStyler()
        .mainAxisAlignment(.start)
        .onHovered(
          ButtonStyler().icon(.color(PlaygroundTokens.mutedForeground())),
        )
        .onPressed(
          ButtonStyler().icon(.color(PlaygroundTokens.mutedForeground())),
        )
        .icon(.color(PlaygroundTokens.mutedForeground()).size(iconSize))
        .minWidth(PlaygroundTokens.s16 * 3 + PlaygroundTokens.s12)
        .maxWidth(panelWidth)
        .padding(.horizontal(PlaygroundTokens.s3))
        .label(
          .fontWeight(
            FontWeight.w400,
          ).textAlign(.start).maxLines(1).overflow(.ellipsis),
        )
        .merge(buttonStyle),
    popover: PopoverStyler()
        .minWidth(panelWidth)
        .maxWidth(double.infinity)
        .padding(.all(0))
        .merge(popoverStyle),
    navigation: playgroundIconButtonStyle(
      variant: .ghost,
      style: IconButtonStyler()
          .size(dayWidth, dayWidth)
          .icon(.size(iconSize))
          .merge(navigationStyle),
    ),
    selector: playgroundSelectStyle(
      style: SelectStyler()
          .content(playgroundCalendarSelectorContentStyle())
          .trigger(
            SelectTriggerStyler()
                .indicator(.size(scaler.scale(PlaygroundTokens.s2_5)))
                .maxWidth(double.infinity)
                .minHeight(dayWidth)
                .minWidth(
                  scaler.scale(PlaygroundTokens.s16 + PlaygroundTokens.s12),
                ),
          )
          .merge(selectorStyle),
    ),
    calendar: CalendarStyler()
        .day(CalendarDayStyler().minWidth(dayWidth).minHeight(dayWidth))
        .merge(calendarStyle),
  );
}
