import type { DOMRenderProps } from "../../utils/dom";
import type { SliderVariants } from "@heroui/styles";
import type { ComponentPropsWithRef } from "react";
import React from "react";
import { SliderOutput as SliderOutputPrimitive, Slider as SliderPrimitive, SliderThumb as SliderThumbPrimitive, SliderTrack as SliderTrackPrimitive } from "react-aria-components/Slider";
interface SliderRootProps extends ComponentPropsWithRef<typeof SliderPrimitive>, SliderVariants {
}
declare const SliderRoot: ({ children, className, orientation, ...props }: SliderRootProps) => React.JSX.Element;
interface SliderOutputProps extends ComponentPropsWithRef<typeof SliderOutputPrimitive> {
}
declare const SliderOutput: ({ children, className, ...props }: SliderOutputProps) => React.JSX.Element;
interface SliderTrackProps extends ComponentPropsWithRef<typeof SliderTrackPrimitive> {
}
declare const SliderTrack: ({ children, className, ...props }: SliderTrackProps) => React.JSX.Element;
interface SliderFillProps<E extends keyof React.JSX.IntrinsicElements = "div"> extends DOMRenderProps<E, undefined> {
    className?: string;
}
declare const SliderFill: <E extends keyof React.JSX.IntrinsicElements = "div">({ className, style, ...props }: SliderFillProps<E> & Omit<React.JSX.IntrinsicElements[E], keyof SliderFillProps<E>>) => React.JSX.Element;
interface SliderThumbProps extends ComponentPropsWithRef<typeof SliderThumbPrimitive> {
}
declare const SliderThumb: ({ children, className, ...props }: SliderThumbProps) => React.JSX.Element;
interface SliderMarksProps<E extends keyof React.JSX.IntrinsicElements = "div"> extends DOMRenderProps<E, undefined> {
    className?: string;
}
declare const SliderMarks: <E extends keyof React.JSX.IntrinsicElements = "div">({ className, ...props }: SliderMarksProps<E> & Omit<React.JSX.IntrinsicElements[E], keyof SliderMarksProps<E>>) => React.JSX.Element;
export { SliderRoot, SliderOutput, SliderTrack, SliderFill, SliderThumb, SliderMarks };
export type { SliderRootProps, SliderOutputProps, SliderTrackProps, SliderFillProps, SliderThumbProps, SliderMarksProps, };
