"use client";
import { calendarVariants } from '@heroui/styles';
import { DateFormatter, createCalendar, CalendarDate } from '@internationalized/date';
import { useControlledState } from '@react-stately/utils';
import React__default, { use, createContext } from 'react';
import { Button } from 'react-aria-components/Button';
import { Calendar, CalendarCell as CalendarCell$1, CalendarHeaderCell as CalendarHeaderCell$1, CalendarGridBody as CalendarGridBody$1, CalendarGridHeader as CalendarGridHeader$1, CalendarGrid as CalendarGrid$1, CalendarHeading as CalendarHeading$1 } from 'react-aria-components/Calendar';
import { useLocale } from 'react-aria-components/I18nProvider';
import { cx } from 'tailwind-variants';
import { getGregorianYearOffset } from '../../utils/calendar.js';
import { composeTwRenderProps, composeSlotClassName } from '../../utils/compose.js';
import { dom } from '../../utils/dom.js';
import { YearPickerContext } from '../calendar-year-picker/year-picker-context.js';
import { IconChevronLeft, IconChevronRight } from '../icons.js';
import { CalendarDayViewGridBody } from './calendar-day-view-grid-body.js';
import { CalendarDayViewGridHeader } from './calendar-day-view-grid-header.js';
import { jsx } from 'react/jsx-runtime';

const CalendarContext = /*#__PURE__*/createContext({});
/**
 * Provides CalendarContext from inside the Calendar render prop, where hooks
 * cannot be called directly.
 */
const CalendarContextProvider = ({
  children,
  dayViewBase,
  slots,
  timeZone,
  visibleRange
}) => {
  // React Aria rebuilds visibleRange on every render, but the start/end dates it
  // holds are stable, so keying off those keeps the value stable in day view too.
  // Outside day view this collapses to undefined, which is stable either way.
  const {
    end,
    start
  } = visibleRange;
  const dayView = React__default.useMemo(() => dayViewBase ? {
    ...dayViewBase,
    timeZone,
    visibleRange: {
      end,
      start
    }
  } : undefined, [dayViewBase, timeZone, end, start]);
  const value = React__default.useMemo(() => ({
    dayView,
    slots
  }), [dayView, slots]);
  return /*#__PURE__*/jsx(CalendarContext, {
    value: value,
    children: children
  });
};

/* -------------------------------------------------------------------------------------------------
| * Calendar Root
| * -----------------------------------------------------------------------------------------------*/

function CalendarRoot({
  children,
  className,
  defaultYearPickerOpen: defaultYearPickerOpenProp = false,
  firstDayOfWeek,
  isYearPickerOpen: isYearPickerOpenProp,
  maxValue: maxValueProp,
  minValue: minValueProp,
  onYearPickerOpenChange: onYearPickerOpenChangeProp,
  visibleDuration,
  ...rest
}) {
  const isWeekView = visibleDuration?.weeks != null;
  const isDayView = visibleDuration?.days != null;
  const visibleDays = visibleDuration?.days;
  const {
    locale
  } = useLocale();
  const slots = React__default.useMemo(() => calendarVariants(), []);
  const calendarRef = React__default.useRef(null);
  const [isYearPickerOpen, setIsYearPickerOpen] = useControlledState(isYearPickerOpenProp, defaultYearPickerOpenProp, onYearPickerOpenChangeProp);
  const calendarProp = React__default.useMemo(() => {
    const calendarIdentifier = new DateFormatter(locale).resolvedOptions().calendar;
    return createCalendar(calendarIdentifier);
  }, [locale]);
  const gregorianYearOffset = React__default.useMemo(() => getGregorianYearOffset(calendarProp.identifier), [calendarProp.identifier]);
  // React Aria memoizes calendar state against minValue/maxValue identity, so
  // these bounds must be stable across renders.
  const minValue = React__default.useMemo(() => minValueProp ?? new CalendarDate(calendarProp, 1900 + gregorianYearOffset, 1, 1), [minValueProp, calendarProp, gregorianYearOffset]);
  const maxValue = React__default.useMemo(() => maxValueProp ?? new CalendarDate(calendarProp, 2099 + gregorianYearOffset, 12, 31), [maxValueProp, calendarProp, gregorianYearOffset]);
  const dayViewBase = React__default.useMemo(() => isDayView && visibleDays != null ? {
    days: visibleDays,
    firstDayOfWeek
  } : undefined, [isDayView, visibleDays, firstDayOfWeek]);
  const yearPickerContext = React__default.useMemo(() => ({
    calendarGridSlot: "calendar-grid",
    isYearPickerOpen,
    setIsYearPickerOpen,
    calendarRef
  }), [isYearPickerOpen, setIsYearPickerOpen]);
  return /*#__PURE__*/jsx(YearPickerContext, {
    value: yearPickerContext,
    children: /*#__PURE__*/jsx(Calendar, {
      ref: calendarRef,
      "data-slot": "calendar",
      firstDayOfWeek: firstDayOfWeek,
      maxValue: maxValue,
      minValue: minValue,
      visibleDuration: visibleDuration,
      ...rest,
      className: composeTwRenderProps(className, cx(slots.base(), isWeekView && "calendar--week-view", isDayView && "calendar--day-view")),
      children: values => /*#__PURE__*/jsx(CalendarContextProvider, {
        dayViewBase: dayViewBase,
        slots: slots,
        timeZone: values.state.timeZone,
        visibleRange: values.state.visibleRange,
        children: typeof children === "function" ? children(values) : children
      })
    })
  });
}
CalendarRoot.displayName = "HeroUI.Calendar";

/* -------------------------------------------------------------------------------------------------
| * Calendar Header
| * -----------------------------------------------------------------------------------------------*/

const CalendarHeader = ({
  children,
  className,
  ...props
}) => {
  const {
    slots
  } = use(CalendarContext);
  return /*#__PURE__*/jsx(dom.header, {
    className: composeSlotClassName(slots?.header, className),
    "data-slot": "calendar-header",
    ...props,
    children: children
  });
};
CalendarHeader.displayName = "HeroUI.Calendar.Header";

/* -------------------------------------------------------------------------------------------------
| * Calendar Heading
| * -----------------------------------------------------------------------------------------------*/

const CalendarHeading = ({
  className,
  ...props
}) => {
  const {
    slots
  } = use(CalendarContext);
  return /*#__PURE__*/jsx(CalendarHeading$1, {
    "data-slot": "calendar-heading",
    ...props,
    className: composeSlotClassName(slots?.heading, className)
  });
};
CalendarHeading.displayName = "HeroUI.Calendar.Heading";

/* -------------------------------------------------------------------------------------------------
| * Calendar Nav Button
| * -----------------------------------------------------------------------------------------------*/

const CalendarNavButton = ({
  children,
  className,
  slot,
  ...props
}) => {
  const {
    slots
  } = use(CalendarContext);
  return /*#__PURE__*/jsx(Button, {
    "data-slot": "calendar-nav-button",
    slot: slot,
    ...props,
    className: composeTwRenderProps(className, slots?.navButton()),
    children: children || (slot === "previous" ? /*#__PURE__*/jsx(IconChevronLeft, {
      className: slots?.navButtonIcon(),
      "data-slot": "calendar-nav-button-icon"
    }) : /*#__PURE__*/jsx(IconChevronRight, {
      className: slots?.navButtonIcon(),
      "data-slot": "calendar-nav-button-icon"
    }))
  });
};
CalendarNavButton.displayName = "HeroUI.Calendar.NavButton";

/* -------------------------------------------------------------------------------------------------
| * Calendar Grid
| * -----------------------------------------------------------------------------------------------*/

const CalendarGrid = ({
  children,
  className,
  weekdayStyle = "short",
  ...props
}) => {
  const calendarContext = use(CalendarContext);
  const {
    dayView,
    slots
  } = calendarContext;
  const contextValue = React__default.useMemo(() => ({
    ...calendarContext,
    dayView: dayView ? {
      ...dayView,
      weekdayStyle
    } : undefined
  }), [calendarContext, dayView, weekdayStyle]);
  return /*#__PURE__*/jsx(CalendarContext, {
    value: contextValue,
    children: /*#__PURE__*/jsx(CalendarGrid$1, {
      "data-slot": "calendar-grid",
      weekdayStyle: weekdayStyle,
      ...props,
      className: composeSlotClassName(slots?.grid, className),
      children: children
    })
  });
};
CalendarGrid.displayName = "HeroUI.Calendar.Grid";

/* -------------------------------------------------------------------------------------------------
| * Calendar Grid Header
| * -----------------------------------------------------------------------------------------------*/

const CalendarGridHeader = ({
  children,
  className,
  ...props
}) => {
  const {
    dayView,
    slots
  } = use(CalendarContext);
  if (dayView && dayView.days >= 7 && typeof children === "function") {
    return /*#__PURE__*/jsx(CalendarDayViewGridHeader, {
      className: composeSlotClassName(slots?.gridHeader, className),
      "data-slot": "calendar-grid-header",
      firstDayOfWeek: dayView.firstDayOfWeek,
      timeZone: dayView.timeZone,
      visibleRange: dayView.visibleRange,
      weekdayStyle: dayView.weekdayStyle,
      children: children
    });
  }
  return /*#__PURE__*/jsx(CalendarGridHeader$1, {
    "data-slot": "calendar-grid-header",
    ...props,
    className: composeSlotClassName(slots?.gridHeader, className),
    children: children
  });
};
CalendarGridHeader.displayName = "HeroUI.Calendar.GridHeader";

/* -------------------------------------------------------------------------------------------------
| * Calendar Grid Body
| * -----------------------------------------------------------------------------------------------*/

const CalendarGridBody = ({
  children,
  className,
  ...props
}) => {
  const {
    dayView,
    slots
  } = use(CalendarContext);
  if (dayView && dayView.days >= 7 && typeof children === "function") {
    return /*#__PURE__*/jsx(CalendarDayViewGridBody, {
      className: composeSlotClassName(slots?.gridBody, className),
      "data-slot": "calendar-grid-body",
      firstDayOfWeek: dayView.firstDayOfWeek,
      visibleRange: dayView.visibleRange,
      children: children
    });
  }
  return /*#__PURE__*/jsx(CalendarGridBody$1, {
    "data-slot": "calendar-grid-body",
    ...props,
    className: composeSlotClassName(slots?.gridBody, className),
    children: children
  });
};
CalendarGridBody.displayName = "HeroUI.Calendar.GridBody";

/* -------------------------------------------------------------------------------------------------
| * Calendar Header Cell
| * -----------------------------------------------------------------------------------------------*/

const CalendarHeaderCell = ({
  className,
  ...props
}) => {
  const {
    slots
  } = use(CalendarContext);
  return /*#__PURE__*/jsx(CalendarHeaderCell$1, {
    "data-slot": "calendar-header-cell",
    ...props,
    className: composeSlotClassName(slots?.headerCell, className)
  });
};
CalendarHeaderCell.displayName = "HeroUI.Calendar.HeaderCell";

/* -------------------------------------------------------------------------------------------------
| * Calendar Cell
| * -----------------------------------------------------------------------------------------------*/

const CalendarCell = ({
  children,
  className,
  ...props
}) => {
  const {
    slots
  } = use(CalendarContext);
  return /*#__PURE__*/jsx(CalendarCell$1, {
    "data-slot": "calendar-cell",
    ...props,
    className: composeTwRenderProps(className, slots?.cell()),
    children: values => {
      const {
        formattedDate
      } = values;
      return typeof children === "function" ? children(values) : children || formattedDate;
    }
  });
};
CalendarCell.displayName = "HeroUI.Calendar.Cell";

/* -------------------------------------------------------------------------------------------------
| * Calendar Cell Indicator
| * -----------------------------------------------------------------------------------------------*/

const CalendarCellIndicator = ({
  className,
  ...props
}) => {
  const {
    slots
  } = use(CalendarContext);
  return /*#__PURE__*/jsx(dom.span, {
    "aria-hidden": "true",
    className: composeSlotClassName(slots?.cellIndicator, className),
    "data-slot": "calendar-cell-indicator",
    ...props
  });
};
CalendarCellIndicator.displayName = "HeroUI.Calendar.CellIndicator";

export { CalendarCell, CalendarCellIndicator, CalendarGrid, CalendarGridBody, CalendarGridHeader, CalendarHeader, CalendarHeaderCell, CalendarHeading, CalendarNavButton, CalendarRoot };
