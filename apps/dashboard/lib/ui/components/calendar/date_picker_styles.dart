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
uiDatePickerStyles(
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
        .labelColor(UiTokens.gray10())
        .labelFontWeight(UiTokens.fontWeightRegular()),
    expanded: ButtonStyler().border(
      .color(UiTokens.focus8()).width(UiTokens.borderWidth1()),
    ),
    button: outlineButton
        .minHeight(uiCalendarTarget)
        .minWidth(scaler.scale(minTriggerWidth))
        .spacing(UiTokens.space2())
        .icon(.size(scaler.scale(UiTokens.space4.resolve(context))))
        .merge(buttonStyle),
    popover: popover
        .padding(.all(0))
        .maxWidth(scaler.scale(480))
        .merge(popoverStyle),
    navigation: uiCalendarNavigationStyle(context).merge(navigationStyle),
    selector: uiCalendarSelectorStyle(context).merge(selectorStyle),
    calendar: calendarRecipe(
      style: uiCalendarGeometry(context).merge(calendarStyle),
    ),
  );
}
