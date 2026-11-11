"use client";
import { rangeCalendarVariants } from '@heroui/styles';
import { DateFormatter, createCalendar, CalendarDate } from '@internationalized/date';
import { useControlledState } from '@react-stately/utils';
import React__default, { use, createContext } from 'react';
import { Button } from 'react-aria-components/Button';
import { useLocale } from 'react-aria-components/I18nProvider';
import { RangeCalendar, CalendarCell, CalendarHeaderCell, CalendarGridBody, CalendarGridHeader, CalendarGrid, CalendarHeading } from 'react-aria-components/RangeCalendar';
import { cx } from 'tailwind-variants';
import { dataAttr } from '../../utils/assertion.js';
import { getGregorianYearOffset } from '../../utils/calendar.js';
import { composeTwRenderProps, composeSlotClassName } from '../../utils/compose.js';
import { dom } from '../../utils/dom.js';
import { CalendarDayViewGridBody } from '../calendar/calendar-day-view-grid-body.js';
import { CalendarDayViewGridHeader } from '../calendar/calendar-day-view-grid-header.js';
import { YearPickerContext } from '../calendar-year-picker/year-picker-context.js';
import { IconChevronLeft, IconChevronRight } from '../icons.js';
import { jsx } from 'react/jsx-runtime';

const RangeCalendarContext = /*#__PURE__*/createContext({});
/**
 * Provides RangeCalendarContext from inside the RangeCalendar render prop,
 * where hooks cannot be called directly.
 */
const RangeCalendarContextProvider = ({
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
  return /*#__PURE__*/jsx(RangeCalendarContext, {
    value: value,
    children: children
  });
};

/* -------------------------------------------------------------------------------------------------
| * RangeCalendar Root
| * -----------------------------------------------------------------------------------------------*/

function RangeCalendarRoot({
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
  const slots = React__default.useMemo(() => rangeCalendarVariants(), []);
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
    calendarGridSlot: "range-calendar-grid",
    isYearPickerOpen,
    setIsYearPickerOpen,
    calendarRef
  }), [isYearPickerOpen, setIsYearPickerOpen]);
  return /*#__PURE__*/jsx(YearPickerContext, {
    value: yearPickerContext,
    children: /*#__PURE__*/jsx(RangeCalendar, {
      ref: calendarRef,
      "data-slot": "range-calendar",
      firstDayOfWeek: firstDayOfWeek,
      maxValue: maxValue,
      minValue: minValue,
      visibleDuration: visibleDuration,
      ...rest,
      className: composeTwRenderProps(className, cx(slots.base(), isWeekView && "range-calendar--week-view", isDayView && "range-calendar--day-view")),
      children: values => /*#__PURE__*/jsx(RangeCalendarContextProvider, {
        dayViewBase: dayViewBase,
        slots: slots,
        timeZone: values.state.timeZone,
        visibleRange: values.state.visibleRange,
        children: typeof children === "function" ? children(values) : children
      })
    })
  });
}
RangeCalendarRoot.displayName = "HeroUI.RangeCalendar";

/* -------------------------------------------------------------------------------------------------
| * RangeCalendar Header
| * -----------------------------------------------------------------------------------------------*/

const RangeCalendarHeader = ({
  children,
  className,
  ...props
}) => {
  const {
    slots
  } = use(RangeCalendarContext);
  return /*#__PURE__*/jsx(dom.header, {
    className: composeSlotClassName(slots?.header, className),
    "data-slot": "range-calendar-header",
    ...props,
    children: children
  });
};
RangeCalendarHeader.displayName = "HeroUI.RangeCalendar.Header";

/* -------------------------------------------------------------------------------------------------
| * RangeCalendar Heading
| * -----------------------------------------------------------------------------------------------*/

const RangeCalendarHeading = ({
  className,
  ...props
}) => {
  const {
    slots
  } = use(RangeCalendarContext);
  return /*#__PURE__*/jsx(CalendarHeading, {
    "data-slot": "range-calendar-heading",
    ...props,
    className: composeSlotClassName(slots?.heading, className)
  });
};
RangeCalendarHeading.displayName = "HeroUI.RangeCalendar.Heading";

/* -------------------------------------------------------------------------------------------------
| * RangeCalendar Nav Button
| * -----------------------------------------------------------------------------------------------*/

const RangeCalendarNavButton = ({
  children,
  className,
  slot,
  ...props
}) => {
  const {
    slots
  } = use(RangeCalendarContext);
  return /*#__PURE__*/jsx(Button, {
    "data-slot": "range-calendar-nav-button",
    slot: slot,
    ...props,
    className: composeTwRenderProps(className, slots?.navButton()),
    children: children || (slot === "previous" ? /*#__PURE__*/jsx(IconChevronLeft, {
      className: slots?.navButtonIcon(),
      "data-slot": "range-calendar-nav-button-icon"
    }) : /*#__PURE__*/jsx(IconChevronRight, {
      className: slots?.navButtonIcon(),
      "data-slot": "range-calendar-nav-button-icon"
    }))
  });
};
RangeCalendarNavButton.displayName = "HeroUI.RangeCalendar.NavButton";

/* -------------------------------------------------------------------------------------------------
| * RangeCalendar Grid
| * -----------------------------------------------------------------------------------------------*/

const RangeCalendarGrid = ({
  children,
  className,
  weekdayStyle = "short",
  ...props
}) => {
  const rangeCalendarContext = use(RangeCalendarContext);
  const {
    dayView,
    slots
  } = rangeCalendarContext;
  const contextValue = React__default.useMemo(() => ({
    ...rangeCalendarContext,
    dayView: dayView ? {
      ...dayView,
      weekdayStyle
    } : undefined
  }), [dayView, rangeCalendarContext, weekdayStyle]);
  return /*#__PURE__*/jsx(RangeCalendarContext, {
    value: contextValue,
    children: /*#__PURE__*/jsx(CalendarGrid, {
      "data-slot": "range-calendar-grid",
      weekdayStyle: weekdayStyle,
      ...props,
      className: composeSlotClassName(slots?.grid, className),
      children: children
    })
  });
};
RangeCalendarGrid.displayName = "HeroUI.RangeCalendar.Grid";

/* -------------------------------------------------------------------------------------------------
| * RangeCalendar Grid Header
| * -----------------------------------------------------------------------------------------------*/

const RangeCalendarGridHeader = ({
  children,
  className,
  ...props
}) => {
  const {
    dayView,
    slots
  } = use(RangeCalendarContext);
  if (dayView && dayView.days >= 7 && typeof children === "function") {
    return /*#__PURE__*/jsx(CalendarDayViewGridHeader, {
      className: composeSlotClassName(slots?.gridHeader, className),
      "data-slot": "range-calendar-grid-header",
      firstDayOfWeek: dayView.firstDayOfWeek,
      timeZone: dayView.timeZone,
      visibleRange: dayView.visibleRange,
      weekdayStyle: dayView.weekdayStyle,
      children: children
    });
  }
  return /*#__PURE__*/jsx(CalendarGridHeader, {
    "data-slot": "range-calendar-grid-header",
    ...props,
    className: composeSlotClassName(slots?.gridHeader, className),
    children: children
  });
};
RangeCalendarGridHeader.displayName = "HeroUI.RangeCalendar.GridHeader";

/* -------------------------------------------------------------------------------------------------
| * RangeCalendar Grid Body
| * -----------------------------------------------------------------------------------------------*/

const RangeCalendarGridBody = ({
  children,
  className,
  ...props
}) => {
  const {
    dayView,
    slots
  } = use(RangeCalendarContext);
  if (dayView && dayView.days >= 7 && typeof children === "function") {
    return /*#__PURE__*/jsx(CalendarDayViewGridBody, {
      className: composeSlotClassName(slots?.gridBody, className),
      "data-slot": "range-calendar-grid-body",
      firstDayOfWeek: dayView.firstDayOfWeek,
      visibleRange: dayView.visibleRange,
      children: children
    });
  }
  return /*#__PURE__*/jsx(CalendarGridBody, {
    "data-slot": "range-calendar-grid-body",
    ...props,
    className: composeSlotClassName(slots?.gridBody, className),
    children: children
  });
};
RangeCalendarGridBody.displayName = "HeroUI.RangeCalendar.GridBody";

/* -------------------------------------------------------------------------------------------------
| * RangeCalendar Header Cell
| * -----------------------------------------------------------------------------------------------*/

const RangeCalendarHeaderCell = ({
  className,
  ...props
}) => {
  const {
    slots
  } = use(RangeCalendarContext);
  return /*#__PURE__*/jsx(CalendarHeaderCell, {
    "data-slot": "range-calendar-header-cell",
    ...props,
    className: composeSlotClassName(slots?.headerCell, className)
  });
};
RangeCalendarHeaderCell.displayName = "HeroUI.RangeCalendar.HeaderCell";

/* -------------------------------------------------------------------------------------------------
| * RangeCalendar Cell
| * -----------------------------------------------------------------------------------------------*/

const RangeCalendarCell = ({
  children,
  className,
  ...props
}) => {
  const {
    slots
  } = use(RangeCalendarContext);
  return /*#__PURE__*/jsx(CalendarCell, {
    "data-slot": "range-calendar-cell",
    ...props,
    className: composeTwRenderProps(className, slots?.cell()),
    children: values => {
      const {
        formattedDate,
        isDisabled,
        isHovered,
        isPressed,
        isSelectionEnd,
        isSelectionStart
      } = values;
      const content = typeof children === "function" ? children(values) : children || formattedDate;
      return /*#__PURE__*/jsx("span", {
        className: "range-calendar__cell-button",
        "data-disabled": dataAttr(isDisabled),
        "data-hovered": dataAttr(isHovered),
        "data-pressed": dataAttr(isPressed),
        "data-selected": dataAttr(isSelectionStart || isSelectionEnd),
        "data-slot": "range-calendar-cell-button",
        children: content
      });
    }
  });
};
RangeCalendarCell.displayName = "HeroUI.RangeCalendar.Cell";

/* -------------------------------------------------------------------------------------------------
| * RangeCalendar Cell Indicator
| * -----------------------------------------------------------------------------------------------*/

const RangeCalendarCellIndicator = ({
  className,
  ...props
}) => {
  const {
    slots
  } = use(RangeCalendarContext);
  return /*#__PURE__*/jsx(dom.span, {
    "aria-hidden": "true",
    className: composeSlotClassName(slots?.cellIndicator, className),
    "data-slot": "range-calendar-cell-indicator",
    ...props
  });
};
RangeCalendarCellIndicator.displayName = "HeroUI.RangeCalendar.CellIndicator";

export { RangeCalendarCell, RangeCalendarCellIndicator, RangeCalendarGrid, RangeCalendarGridBody, RangeCalendarGridHeader, RangeCalendarHeader, RangeCalendarHeaderCell, RangeCalendarHeading, RangeCalendarNavButton, RangeCalendarRoot };
