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
heroUiDatePickerStyles(
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
      .labelColor(HeroUiTokens.fieldPlaceholder())
      .labelFontWeight(FontWeight.w400),
  expanded: ButtonStyler()
      .color(HeroUiTokens.fieldFocus())
      .containerEffects(heroUiFocusRing()),
  popover: popover
      .padding(.all(0))
      .maxWidth(MediaQuery.textScalerOf(context).scale(480))
      .borderRadius(.all(popoverRadius()))
      .merge(popoverStyle),
  navigation: heroUiCalendarNavigationStyle(context).merge(navigationStyle),
  selector: heroUiCalendarSelectorStyle(context).merge(selectorStyle),
  calendar: calendarRecipe(
    style: heroUiCalendarGeometry(context).merge(calendarStyle),
  ),
);
