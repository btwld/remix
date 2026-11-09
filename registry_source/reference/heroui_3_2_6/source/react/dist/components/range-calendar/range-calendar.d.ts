import type { DOMRenderProps } from "../../utils/dom";
import type { RangeCalendarVariants } from "@heroui/styles";
import type { ComponentPropsWithRef, ReactNode } from "react";
import type { DateValue } from "react-aria-components/Calendar";
import React from "react";
import { Button as ButtonPrimitive } from "react-aria-components/Button";
import { CalendarCell as CalendarCellPrimitive, CalendarGridBody as CalendarGridBodyPrimitive, CalendarGridHeader as CalendarGridHeaderPrimitive, CalendarGrid as CalendarGridPrimitive, CalendarHeaderCell as CalendarHeaderCellPrimitive, CalendarHeading as CalendarHeadingPrimitive, RangeCalendar as RangeCalendarPrimitive } from "react-aria-components/RangeCalendar";
interface RangeCalendarRootProps<T extends DateValue = DateValue> extends ComponentPropsWithRef<typeof RangeCalendarPrimitive<T>>, RangeCalendarVariants {
    isYearPickerOpen?: boolean;
    onYearPickerOpenChange?: (isYearPickerOpen: boolean) => void;
    defaultYearPickerOpen?: boolean;
}
declare function RangeCalendarRoot<T extends DateValue = DateValue>({ children, className, defaultYearPickerOpen: defaultYearPickerOpenProp, firstDayOfWeek, isYearPickerOpen: isYearPickerOpenProp, maxValue: maxValueProp, minValue: minValueProp, onYearPickerOpenChange: onYearPickerOpenChangeProp, visibleDuration, ...rest }: RangeCalendarRootProps<T>): React.JSX.Element;
declare namespace RangeCalendarRoot {
    var displayName: string;
}
interface RangeCalendarHeaderProps<E extends keyof React.JSX.IntrinsicElements = "header"> extends DOMRenderProps<E, undefined> {
    children?: ReactNode;
    className?: string;
}
declare const RangeCalendarHeader: {
    <E extends keyof React.JSX.IntrinsicElements = "header">({ children, className, ...props }: RangeCalendarHeaderProps<E> & Omit<React.JSX.IntrinsicElements[E], keyof RangeCalendarHeaderProps<E>>): React.JSX.Element;
    displayName: string;
};
interface RangeCalendarHeadingProps extends ComponentPropsWithRef<typeof CalendarHeadingPrimitive> {
}
declare const RangeCalendarHeading: {
    ({ className, ...props }: RangeCalendarHeadingProps): React.JSX.Element;
    displayName: string;
};
interface RangeCalendarNavButtonProps extends ComponentPropsWithRef<typeof ButtonPrimitive> {
    slot?: "previous" | "next";
}
declare const RangeCalendarNavButton: {
    ({ children, className, slot, ...props }: RangeCalendarNavButtonProps): React.JSX.Element;
    displayName: string;
};
interface RangeCalendarGridProps extends ComponentPropsWithRef<typeof CalendarGridPrimitive> {
}
declare const RangeCalendarGrid: {
    ({ children, className, weekdayStyle, ...props }: RangeCalendarGridProps): React.JSX.Element;
    displayName: string;
};
interface RangeCalendarGridHeaderProps extends ComponentPropsWithRef<typeof CalendarGridHeaderPrimitive> {
}
declare const RangeCalendarGridHeader: {
    ({ children, className, ...props }: RangeCalendarGridHeaderProps): React.JSX.Element;
    displayName: string;
};
interface RangeCalendarGridBodyProps extends ComponentPropsWithRef<typeof CalendarGridBodyPrimitive> {
}
declare const RangeCalendarGridBody: {
    ({ children, className, ...props }: RangeCalendarGridBodyProps): React.JSX.Element;
    displayName: string;
};
interface RangeCalendarHeaderCellProps extends ComponentPropsWithRef<typeof CalendarHeaderCellPrimitive> {
}
declare const RangeCalendarHeaderCell: {
    ({ className, ...props }: RangeCalendarHeaderCellProps): React.JSX.Element;
    displayName: string;
};
interface RangeCalendarCellProps extends ComponentPropsWithRef<typeof CalendarCellPrimitive> {
}
declare const RangeCalendarCell: {
    ({ children, className, ...props }: RangeCalendarCellProps): React.JSX.Element;
    displayName: string;
};
interface RangeCalendarCellIndicatorProps<E extends keyof React.JSX.IntrinsicElements = "span"> extends DOMRenderProps<E, undefined> {
    className?: string;
}
declare const RangeCalendarCellIndicator: {
    <E extends keyof React.JSX.IntrinsicElements = "span">({ className, ...props }: RangeCalendarCellIndicatorProps<E> & Omit<React.JSX.IntrinsicElements[E], keyof RangeCalendarCellIndicatorProps<E>>): React.JSX.Element;
    displayName: string;
};
export { RangeCalendarRoot, RangeCalendarHeader, RangeCalendarHeading, RangeCalendarNavButton, RangeCalendarGrid, RangeCalendarGridHeader, RangeCalendarGridBody, RangeCalendarHeaderCell, RangeCalendarCell, RangeCalendarCellIndicator, };
export type { RangeCalendarRootProps, RangeCalendarHeaderProps, RangeCalendarHeadingProps, RangeCalendarNavButtonProps, RangeCalendarGridProps, RangeCalendarGridHeaderProps, RangeCalendarGridBodyProps, RangeCalendarHeaderCellProps, RangeCalendarCellProps, RangeCalendarCellIndicatorProps, };
