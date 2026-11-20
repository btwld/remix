import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../../theme/theme.dart';
import '../calendar.dart';

({
  ButtonStyler placeholder,
  ButtonStyler expanded,
  ButtonStyler button,
  PopoverStyler popover,
  IconButtonStyler navigation,
  SelectStyler selector,
  CalendarStyler calendar,
})
fortalDatePickerStyles(
  BuildContext context, {
  required double minTriggerWidth,
  required CalendarStyler Function({CalendarStyler style}) calendarRecipe,
  required ButtonStyler outlineButton,
  required PopoverStyler popover,
  required ButtonStyler buttonStyle,
  required PopoverStyler popoverStyle,
  required IconButtonStyler navigationStyle,
  required SelectStyler selectorStyle,
  required CalendarStyler calendarStyle,
}) {
  final scaler = MediaQuery.textScalerOf(context);
  return (
    placeholder: ButtonStyler()
        .labelColor(FortalTokens.gray10())
        .labelFontWeight(FortalTokens.fontWeightRegular()),
    expanded: ButtonStyler().border(
      .color(FortalTokens.focus8()).width(FortalTokens.borderWidth1()),
    ),
    button: outlineButton
        .minHeight(fortalCalendarTarget)
        .minWidth(scaler.scale(minTriggerWidth))
        .spacing(FortalTokens.space2())
        .icon(.size(scaler.scale(FortalTokens.space4.resolve(context))))
        .merge(buttonStyle),
    popover: popover
        .padding(.all(0))
        .maxWidth(scaler.scale(480))
        .merge(popoverStyle),
    navigation: fortalCalendarNavigationStyle(context).merge(navigationStyle),
    selector: fortalCalendarSelectorStyle(context).merge(selectorStyle),
    calendar: calendarRecipe(
      style: fortalCalendarGeometry(context).merge(calendarStyle),
    ),
  );
}
