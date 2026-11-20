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
vanillaDatePickerStyles(
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
  final dayWidth = vanillaCalendarDayWidth(context);
  final scaler = MediaQuery.textScalerOf(context);
  final iconSize = scaler.scale(VanillaTokens.icon);
  final calendarWidth =
      dayWidth * DateTime.daysPerWeek +
      VanillaTokens.s3 * 2 +
      VanillaTokens.strokeHairline * 2;
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
    placeholder: ButtonStyler().label(.color(VanillaTokens.mutedForeground())),
    expanded: ButtonStyler()
        .border(vanillaFocusBorder())
        .containerEffects(vanillaFocusRing()),
    button: ButtonStyler()
        .mainAxisAlignment(.start)
        .onHovered(ButtonStyler().icon(.color(VanillaTokens.mutedForeground())))
        .onPressed(ButtonStyler().icon(.color(VanillaTokens.mutedForeground())))
        .icon(.color(VanillaTokens.mutedForeground()).size(iconSize))
        .minWidth(VanillaTokens.s16 * 3 + VanillaTokens.s12)
        .maxWidth(panelWidth)
        .padding(.horizontal(VanillaTokens.s3))
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
    navigation: vanillaIconButtonStyle(
      variant: .ghost,
      style: IconButtonStyler()
          .size(dayWidth, dayWidth)
          .icon(.size(iconSize))
          .merge(navigationStyle),
    ),
    selector: vanillaSelectStyle(
      style: SelectStyler()
          .content(vanillaCalendarSelectorContentStyle())
          .trigger(
            SelectTriggerStyler()
                .indicator(.size(scaler.scale(VanillaTokens.s2_5)))
                .maxWidth(double.infinity)
                .minHeight(dayWidth)
                .minWidth(scaler.scale(VanillaTokens.s16 + VanillaTokens.s12)),
          )
          .merge(selectorStyle),
    ),
    calendar: CalendarStyler()
        .day(CalendarDayStyler().minWidth(dayWidth).minHeight(dayWidth))
        .merge(calendarStyle),
  );
}
