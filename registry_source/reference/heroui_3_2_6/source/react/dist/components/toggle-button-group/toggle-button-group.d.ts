import type { DOMRenderProps } from "../../utils/dom";
import type { ToggleButtonGroupVariants, ToggleButtonVariants } from "@heroui/styles";
import type { ComponentPropsWithRef } from "react";
import { toggleButtonGroupVariants } from "@heroui/styles";
import React from "react";
import { ToggleButtonGroup as ToggleButtonGroupPrimitive } from "react-aria-components/ToggleButtonGroup";
type ToggleButtonGroupContext = {
    slots?: ReturnType<typeof toggleButtonGroupVariants>;
    size?: ToggleButtonVariants["size"];
    isDisabled?: boolean;
};
declare const ToggleButtonGroupContext: React.Context<ToggleButtonGroupContext>;
export declare const TOGGLE_BUTTON_GROUP_CHILD = "__toggle_button_group_child";
interface ToggleButtonGroupRootProps extends ComponentPropsWithRef<typeof ToggleButtonGroupPrimitive>, ToggleButtonGroupVariants {
    /** Size to propagate to all child ToggleButtons */
    size?: ToggleButtonVariants["size"];
    /** Whether the group buttons are visually separated (detached) instead of connected */
    isDetached?: boolean;
}
declare const ToggleButtonGroupRoot: ({ children, className, fullWidth, isDetached, isDisabled, orientation: orientationProp, size, ...rest }: ToggleButtonGroupRootProps) => React.JSX.Element;
interface ToggleButtonGroupSeparatorProps<E extends keyof React.JSX.IntrinsicElements = "span"> extends DOMRenderProps<E, undefined> {
    className?: string;
}
declare const ToggleButtonGroupSeparator: <E extends keyof React.JSX.IntrinsicElements = "span">({ className, ...props }: ToggleButtonGroupSeparatorProps<E> & Omit<React.JSX.IntrinsicElements[E], keyof ToggleButtonGroupSeparatorProps<E>>) => React.JSX.Element;
export { ToggleButtonGroupRoot, ToggleButtonGroupSeparator, ToggleButtonGroupContext };
export type { ToggleButtonGroupRootProps, ToggleButtonGroupSeparatorProps };
