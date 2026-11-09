import type { DOMRenderProps } from "../../utils/dom";
import type { ComboBoxVariants } from "@heroui/styles";
import type { ComponentPropsWithRef, ReactNode } from "react";
import type { ButtonProps } from "react-aria-components/Button";
import type { ComboBoxValueRenderProps } from "react-aria-components/ComboBox";
import { comboBoxVariants } from "@heroui/styles";
import React from "react";
import { ComboBox as ComboBoxPrimitive, ComboBoxValue as ComboBoxValuePrimitive, Popover as PopoverPrimitive } from "react-aria-components/ComboBox";
type ComboBoxContext = {
    slots?: ReturnType<typeof comboBoxVariants>;
    variant?: "primary" | "secondary";
};
declare const ComboBoxContext: React.Context<ComboBoxContext>;
interface ComboBoxRootProps<T extends object, M extends "single" | "multiple" = "single"> extends ComponentPropsWithRef<typeof ComboBoxPrimitive<T, M>>, ComboBoxVariants {
    items?: Iterable<T>;
    /**
     * The variant of the combo box.
     * @default "primary"
     */
    variant?: "primary" | "secondary";
}
declare const ComboBoxRoot: <T extends object = object, M extends "single" | "multiple" = "single">({ children, className, fullWidth, menuTrigger, variant, ...props }: ComboBoxRootProps<T, M>) => React.JSX.Element;
interface ComboBoxInputGroupProps<E extends keyof React.JSX.IntrinsicElements = "div"> extends DOMRenderProps<E, undefined> {
    children?: ReactNode;
    className?: string;
}
declare const ComboBoxInputGroup: <E extends keyof React.JSX.IntrinsicElements = "div">({ children, className, render, ...containerProps }: ComboBoxInputGroupProps<E> & Omit<React.JSX.IntrinsicElements[E], keyof ComboBoxInputGroupProps<E>>) => React.JSX.Element | null;
interface ComboBoxValueProps<T extends object> extends ComponentPropsWithRef<typeof ComboBoxValuePrimitive<T>> {
}
declare const ComboBoxValue: <T extends object = object>({ children, className, ...props }: ComboBoxValueProps<T>) => React.JSX.Element;
interface ComboBoxTriggerProps extends ButtonProps {
    className?: string;
    children?: ReactNode;
}
declare const ComboBoxTrigger: ({ children, className, ...props }: ComboBoxTriggerProps) => React.JSX.Element | null;
interface ComboBoxPopoverProps extends Omit<ComponentPropsWithRef<typeof PopoverPrimitive>, "children"> {
    children: React.ReactNode;
}
declare const ComboBoxPopover: ({ children, className, placement, ...props }: ComboBoxPopoverProps) => React.JSX.Element;
export { ComboBoxRoot, ComboBoxInputGroup, ComboBoxValue, ComboBoxTrigger, ComboBoxPopover, ComboBoxContext, };
export type { ComboBoxRootProps, ComboBoxInputGroupProps, ComboBoxValueProps, ComboBoxValueRenderProps, ComboBoxTriggerProps, ComboBoxPopoverProps, };
