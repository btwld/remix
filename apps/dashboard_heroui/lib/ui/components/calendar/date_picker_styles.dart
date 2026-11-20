import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../../theme/theme.dart';
import '../calendar.dart';

({
  ButtonStyler placeholder,
  ButtonStyler expanded,
  PopoverStyler popover,
  IconButtonStyler navigation,
  SelectStyler selector,
  CalendarStyler calendar,
})
uiDatePickerStyles(
  BuildContext context, {
  required CalendarStyler Function({CalendarStyler style}) calendarRecipe,
  required PopoverStyler popover,
  required ContextToken<Radius> popoverRadius,
  required PopoverStyler popoverStyle,
  required IconButtonStyler navigationStyle,
  required SelectStyler selectorStyle,
  required CalendarStyler calendarStyle,
}) => (
  placeholder: ButtonStyler()
      .labelColor(UiTokens.fieldPlaceholder())
      .labelFontWeight(FontWeight.w400),
  expanded: ButtonStyler()
      .color(UiTokens.fieldFocus())
      .containerEffects(uiFocusRing()),
  popover: popover
      .padding(.all(0))
      .maxWidth(MediaQuery.textScalerOf(context).scale(480))
      .borderRadius(.all(popoverRadius()))
      .merge(popoverStyle),
  navigation: uiCalendarNavigationStyle(context).merge(navigationStyle),
  selector: uiCalendarSelectorStyle(context).merge(selectorStyle),
  calendar: calendarRecipe(
    style: uiCalendarGeometry(context).merge(calendarStyle),
  ),
);
