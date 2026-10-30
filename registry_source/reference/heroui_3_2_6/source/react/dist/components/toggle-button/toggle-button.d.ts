import type { ToggleButtonVariants } from "@heroui/styles";
import type { ComponentPropsWithRef } from "react";
import { ToggleButton as ToggleButtonPrimitive } from "react-aria-components/ToggleButton";
interface ToggleButtonRootProps extends ComponentPropsWithRef<typeof ToggleButtonPrimitive>, ToggleButtonVariants {
}
declare const ToggleButtonRoot: ({ children, className, isIconOnly, size, style, variant, ...rest }: ToggleButtonRootProps) => import("react").JSX.Element;
export { ToggleButtonRoot };
export type { ToggleButtonRootProps };
