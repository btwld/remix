import type { DOMRenderProps } from "../../utils/dom";
import type { CalendarVariants } from "@heroui/styles";
import type { ComponentPropsWithRef, ReactNode } from "react";
import type { CalendarSelectionMode, DateValue, CalendarProps as RACCalendarProps } from "react-aria-components/Calendar";
import React from "react";
import { Button as ButtonPrimitive } from "react-aria-components/Button";
import { CalendarCell as CalendarCellPrimitive, CalendarGridBody as CalendarGridBodyPrimitive, CalendarGridHeader as CalendarGridHeaderPrimitive, CalendarGrid as CalendarGridPrimitive, CalendarHeaderCell as CalendarHeaderCellPrimitive, CalendarHeading as CalendarHeadingPrimitive } from "react-aria-components/Calendar";
interface CalendarRootProps<T extends DateValue = DateValue, M extends CalendarSelectionMode = "single"> extends RACCalendarProps<T, M>, CalendarVariants {
    isYearPickerOpen?: boolean;
    onYearPickerOpenChange?: (isYearPickerOpen: boolean) => void;
    defaultYearPickerOpen?: boolean;
}
declare function CalendarRoot<T extends DateValue = DateValue, M extends CalendarSelectionMode = "single">({ children, className, defaultYearPickerOpen: defaultYearPickerOpenProp, firstDayOfWeek, isYearPickerOpen: isYearPickerOpenProp, maxValue: maxValueProp, minValue: minValueProp, onYearPickerOpenChange: onYearPickerOpenChangeProp, visibleDuration, ...rest }: CalendarRootProps<T, M>): React.JSX.Element;
declare namespace CalendarRoot {
    var displayName: string;
}
interface CalendarHeaderProps<E extends keyof React.JSX.IntrinsicElements = "header"> extends DOMRenderProps<E, undefined> {
    children?: ReactNode;
    className?: string;
}
declare const CalendarHeader: {
    <E extends keyof React.JSX.IntrinsicElements = "header">({ children, className, ...props }: CalendarHeaderProps<E> & Omit<React.JSX.IntrinsicElements[E], keyof CalendarHeaderProps<E>>): React.JSX.Element;
    displayName: string;
};
interface CalendarHeadingProps extends ComponentPropsWithRef<typeof CalendarHeadingPrimitive> {
}
declare const CalendarHeading: {
    ({ className, ...props }: CalendarHeadingProps): React.JSX.Element;
    displayName: string;
};
interface CalendarNavButtonProps extends ComponentPropsWithRef<typeof ButtonPrimitive> {
    slot?: "previous" | "next";
}
declare const CalendarNavButton: {
    ({ children, className, slot, ...props }: CalendarNavButtonProps): React.JSX.Element;
    displayName: string;
};
interface CalendarGridProps extends ComponentPropsWithRef<typeof CalendarGridPrimitive> {
}
declare const CalendarGrid: {
    ({ children, className, weekdayStyle, ...props }: CalendarGridProps): React.JSX.Element;
    displayName: string;
};
interface CalendarGridHeaderProps extends ComponentPropsWithRef<typeof CalendarGridHeaderPrimitive> {
}
declare const CalendarGridHeader: {
    ({ children, className, ...props }: CalendarGridHeaderProps): React.JSX.Element;
    displayName: string;
};
interface CalendarGridBodyProps extends ComponentPropsWithRef<typeof CalendarGridBodyPrimitive> {
}
declare const CalendarGridBody: {
    ({ children, className, ...props }: CalendarGridBodyProps): React.JSX.Element;
    displayName: string;
};
interface CalendarHeaderCellProps extends ComponentPropsWithRef<typeof CalendarHeaderCellPrimitive> {
}
declare const CalendarHeaderCell: {
    ({ className, ...props }: CalendarHeaderCellProps): React.JSX.Element;
    displayName: string;
};
interface CalendarCellProps extends ComponentPropsWithRef<typeof CalendarCellPrimitive> {
}
declare const CalendarCell: {
    ({ children, className, ...props }: CalendarCellProps): React.JSX.Element;
    displayName: string;
};
interface CalendarCellIndicatorProps<E extends keyof React.JSX.IntrinsicElements = "span"> extends DOMRenderProps<E, undefined> {
    children?: ReactNode;
    className?: string;
}
declare const CalendarCellIndicator: {
    <E extends keyof React.JSX.IntrinsicElements = "span">({ className, ...props }: CalendarCellIndicatorProps<E> & Omit<React.JSX.IntrinsicElements[E], keyof CalendarCellIndicatorProps<E>>): React.JSX.Element;
    displayName: string;
};
export { CalendarRoot, CalendarHeader, CalendarHeading, CalendarNavButton, CalendarGrid, CalendarGridHeader, CalendarGridBody, CalendarHeaderCell, CalendarCell, CalendarCellIndicator, };
export type { CalendarRootProps, CalendarHeaderProps, CalendarHeadingProps, CalendarNavButtonProps, CalendarGridProps, CalendarGridHeaderProps, CalendarGridBodyProps, CalendarHeaderCellProps, CalendarCellProps, CalendarCellIndicatorProps, };
