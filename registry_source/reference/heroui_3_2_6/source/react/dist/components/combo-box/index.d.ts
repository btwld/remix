import type { ComponentProps } from "react";
import { ComboBoxInputGroup, ComboBoxPopover, ComboBoxRoot, ComboBoxTrigger, ComboBoxValue } from "./combo-box";
export declare const ComboBox: (<T extends object = object, M extends "single" | "multiple" = "single">({ children, className, fullWidth, menuTrigger, variant, ...props }: import("./combo-box").ComboBoxRootProps<T, M>) => import("react").JSX.Element) & {
    Root: <T extends object = object, M extends "single" | "multiple" = "single">({ children, className, fullWidth, menuTrigger, variant, ...props }: import("./combo-box").ComboBoxRootProps<T, M>) => import("react").JSX.Element;
    InputGroup: <E extends keyof React.JSX.IntrinsicElements = "div">({ children, className, render, ...containerProps }: import("./combo-box").ComboBoxInputGroupProps<E> & Omit<React.JSX.IntrinsicElements[E], keyof import("./combo-box").ComboBoxInputGroupProps<E>>) => import("react").JSX.Element | null;
    Value: <T extends object = object>({ children, className, ...props }: import("./combo-box").ComboBoxValueProps<T>) => import("react").JSX.Element;
    Trigger: ({ children, className, ...props }: import("./combo-box").ComboBoxTriggerProps) => import("react").JSX.Element | null;
    Popover: ({ children, className, placement, ...props }: import("./combo-box").ComboBoxPopoverProps) => import("react").JSX.Element;
};
export type ComboBox<T extends object = object, M extends "single" | "multiple" = "single"> = {
    Props: ComponentProps<typeof ComboBoxRoot<T, M>>;
    RootProps: ComponentProps<typeof ComboBoxRoot<T, M>>;
    InputGroupProps: ComponentProps<typeof ComboBoxInputGroup>;
    ValueProps: ComponentProps<typeof ComboBoxValue<T>>;
    TriggerProps: ComponentProps<typeof ComboBoxTrigger>;
    PopoverProps: ComponentProps<typeof ComboBoxPopover>;
};
export { ComboBoxInputGroup, ComboBoxPopover, ComboBoxRoot, ComboBoxTrigger, ComboBoxValue };
export type { ComboBoxRootProps, ComboBoxRootProps as ComboBoxProps, ComboBoxInputGroupProps, ComboBoxValueProps, ComboBoxValueRenderProps, ComboBoxTriggerProps, ComboBoxPopoverProps, } from "./combo-box";
export { ComboBoxContext } from "./combo-box";
export { comboBoxVariants } from "@heroui/styles";
export type { ComboBoxVariants } from "@heroui/styles";
