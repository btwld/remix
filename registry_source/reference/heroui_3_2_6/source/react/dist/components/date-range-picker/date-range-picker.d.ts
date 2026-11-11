import type { DOMRenderProps } from "../../utils/dom";
import type { DateRangePickerVariants } from "@heroui/styles";
import type { ComponentPropsWithRef, ReactNode } from "react";
import type { DateValue } from "react-aria-components/Calendar";
import React from "react";
import { Button as ButtonPrimitive } from "react-aria-components/Button";
import { DateRangePicker as DateRangePickerPrimitive, Popover as PopoverPrimitive } from "react-aria-components/DateRangePicker";
interface DateRangePickerRootProps<T extends DateValue> extends ComponentPropsWithRef<typeof DateRangePickerPrimitive<T>>, DateRangePickerVariants {
}
declare const DateRangePickerRoot: {
    <T extends DateValue>({ children, className, onOpenChange, ...props }: DateRangePickerRootProps<T>): React.JSX.Element;
    displayName: string;
};
interface DateRangePickerTriggerProps extends ComponentPropsWithRef<typeof ButtonPrimitive> {
}
declare const DateRangePickerTrigger: {
    ({ children, className, ref, ...props }: DateRangePickerTriggerProps): React.JSX.Element;
    displayName: string;
};
interface DateRangePickerTriggerIndicatorProps<E extends keyof React.JSX.IntrinsicElements = "span"> extends DOMRenderProps<E, undefined> {
    children?: React.ReactNode;
    className?: string;
}
declare const DateRangePickerTriggerIndicator: {
    <E extends keyof React.JSX.IntrinsicElements = "span">({ children, className, ...props }: DateRangePickerTriggerIndicatorProps<E> & Omit<React.JSX.IntrinsicElements[E], keyof DateRangePickerTriggerIndicatorProps<E>>): React.JSX.Element;
    displayName: string;
};
interface DateRangePickerRangeSeparatorProps<E extends keyof React.JSX.IntrinsicElements = "span"> extends DOMRenderProps<E, undefined> {
    children?: ReactNode;
    className?: string;
}
declare const DateRangePickerRangeSeparator: {
    <E extends keyof React.JSX.IntrinsicElements = "span">({ children, className, ...props }: DateRangePickerRangeSeparatorProps<E> & Omit<React.JSX.IntrinsicElements[E], keyof DateRangePickerRangeSeparatorProps<E>>): React.JSX.Element;
    displayName: string;
};
interface DateRangePickerPopoverProps extends Omit<ComponentPropsWithRef<typeof PopoverPrimitive>, "children"> {
    children: React.ReactNode;
}
declare const DateRangePickerPopover: {
    ({ children, className, placement, ...props }: DateRangePickerPopoverProps): React.JSX.Element;
    displayName: string;
};
export { DateRangePickerRoot, DateRangePickerTrigger, DateRangePickerTriggerIndicator, DateRangePickerRangeSeparator, DateRangePickerPopover, };
export type { DateRangePickerRootProps, DateRangePickerTriggerProps, DateRangePickerTriggerIndicatorProps, DateRangePickerRangeSeparatorProps, DateRangePickerPopoverProps, };
