import type { DOMRenderProps } from "../../utils/dom";
import type { DatePickerVariants } from "@heroui/styles";
import type { ComponentPropsWithRef } from "react";
import type { DateValue } from "react-aria-components/Calendar";
import React from "react";
import { Button as ButtonPrimitive } from "react-aria-components/Button";
import { DatePicker as DatePickerPrimitive, Popover as PopoverPrimitive } from "react-aria-components/DatePicker";
interface DatePickerRootProps<T extends DateValue> extends ComponentPropsWithRef<typeof DatePickerPrimitive<T>>, DatePickerVariants {
}
declare const DatePickerRoot: {
    <T extends DateValue>({ children, className, onOpenChange, ...props }: DatePickerRootProps<T>): React.JSX.Element;
    displayName: string;
};
interface DatePickerTriggerProps extends ComponentPropsWithRef<typeof ButtonPrimitive> {
}
declare const DatePickerTrigger: {
    ({ children, className, ref, ...props }: DatePickerTriggerProps): React.JSX.Element;
    displayName: string;
};
interface DatePickerTriggerIndicatorProps<E extends keyof React.JSX.IntrinsicElements = "span"> extends DOMRenderProps<E, undefined> {
    children?: React.ReactNode;
    className?: string;
}
declare const DatePickerTriggerIndicator: {
    <E extends keyof React.JSX.IntrinsicElements = "span">({ children, className, ...props }: DatePickerTriggerIndicatorProps<E> & Omit<React.JSX.IntrinsicElements[E], keyof DatePickerTriggerIndicatorProps<E>>): React.JSX.Element;
    displayName: string;
};
interface DatePickerPopoverProps extends Omit<ComponentPropsWithRef<typeof PopoverPrimitive>, "children"> {
    children: React.ReactNode;
}
declare const DatePickerPopover: {
    ({ children, className, placement, ...props }: DatePickerPopoverProps): React.JSX.Element;
    displayName: string;
};
export { DatePickerRoot, DatePickerTrigger, DatePickerTriggerIndicator, DatePickerPopover };
export type { DatePickerRootProps, DatePickerTriggerProps, DatePickerTriggerIndicatorProps, DatePickerPopoverProps, };
