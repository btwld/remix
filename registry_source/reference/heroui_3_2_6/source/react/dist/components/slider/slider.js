"use client";
import { sliderVariants } from '@heroui/styles';
import React__default, { use, createContext } from 'react';
import { Slider, SliderThumb as SliderThumb$1, SliderTrack as SliderTrack$1, SliderOutput as SliderOutput$1 } from 'react-aria-components/Slider';
import { dataAttr } from '../../utils/assertion.js';
import { composeTwRenderProps, composeSlotClassName } from '../../utils/compose.js';
import { dom } from '../../utils/dom.js';
import { jsx, Fragment } from 'react/jsx-runtime';

const SliderContext = /*#__PURE__*/createContext({});

/* -------------------------------------------------------------------------------------------------
 * Slider Root
 * -----------------------------------------------------------------------------------------------*/

const SliderRoot = ({
  children,
  className,
  orientation = "horizontal",
  ...props
}) => {
  const slots = React__default.useMemo(() => sliderVariants({}), []);
  return /*#__PURE__*/jsx(Slider, {
    "data-slot": "slider",
    orientation: orientation,
    ...props,
    className: composeTwRenderProps(className, slots.base()),
    children: values => /*#__PURE__*/jsx(SliderContext, {
      value: {
        slots,
        state: values
      },
      children: typeof children === "function" ? children(values) : children
    })
  });
};

/* -------------------------------------------------------------------------------------------------
 * Slider Output
 * -----------------------------------------------------------------------------------------------*/

const SliderOutput = ({
  children,
  className,
  ...props
}) => {
  const {
    slots
  } = use(SliderContext);
  return /*#__PURE__*/jsx(SliderOutput$1, {
    className: composeTwRenderProps(className, slots?.output()),
    "data-slot": "slider-output",
    ...props,
    children: children ? values => /*#__PURE__*/jsx(Fragment, {
      children: typeof children === "function" ? children(values) : children
    }) : ({
      state
    }) => state.values.map((_, i) => state.getThumbValueLabel(i)).join(" – ")
  });
};

/* -------------------------------------------------------------------------------------------------
 * Slider Track
 * -----------------------------------------------------------------------------------------------*/

const SliderTrack = ({
  children,
  className,
  ...props
}) => {
  const {
    slots,
    state
  } = use(SliderContext);
  const {
    getThumbPercent,
    values
  } = state?.state || {};
  const singleThumb = values?.length && values.length === 1;
  const [startOffset, endOffset] = [values?.length && values.length > 1 ? getThumbPercent?.(0) : 0, getThumbPercent?.(values?.length ? values.length - 1 : 0)].sort();
  const fillWidth = (endOffset - startOffset) * 100;
  return /*#__PURE__*/jsx(SliderTrack$1, {
    className: composeTwRenderProps(className, slots?.track()),
    "data-disabled": dataAttr(state?.isDisabled),
    "data-slot": "slider-track",
    ...(singleThumb ? {
      "data-fill-start": dataAttr(fillWidth > 0),
      "data-fill-end": dataAttr(fillWidth == 100)
    } : {
      "data-fill-start": dataAttr(startOffset == 0),
      "data-fill-end": dataAttr(startOffset * 100 + fillWidth == 100)
    }),
    ...props,
    children: values => /*#__PURE__*/jsx(Fragment, {
      children: typeof children === "function" ? children(values) : children
    })
  });
};

/* -------------------------------------------------------------------------------------------------
 * Slider Fill
 * -----------------------------------------------------------------------------------------------*/

const SliderFill = ({
  className,
  style,
  ...props
}) => {
  const {
    slots,
    state
  } = use(SliderContext);
  const {
    getThumbPercent,
    orientation,
    values
  } = state?.state || {};
  const [startOffset, endOffset] = [values?.length && values.length > 1 ? getThumbPercent?.(0) : 0, getThumbPercent?.(values?.length ? values.length - 1 : 0)].sort();
  const isVertical = orientation === "vertical";
  return /*#__PURE__*/jsx(dom.div, {
    className: composeSlotClassName(slots?.fill, className),
    "data-disabled": dataAttr(state?.isDisabled),
    "data-slot": "slider-fill",
    style: {
      ...style,
      // TODO: rtl support
      [isVertical ? "bottom" : "left"]: `${startOffset * 100}%`,
      ...(isVertical ? {
        height: `${(endOffset - startOffset) * 100}%`
      } : {
        width: `${(endOffset - startOffset) * 100}%`
      })
    },
    ...props
  });
};

/* -------------------------------------------------------------------------------------------------
 * Slider Thumb
 * -----------------------------------------------------------------------------------------------*/

const SliderThumb = ({
  children,
  className,
  ...props
}) => {
  const {
    slots
  } = use(SliderContext);
  return /*#__PURE__*/jsx(SliderThumb$1, {
    className: composeTwRenderProps(className, slots?.thumb()),
    "data-slot": "slider-thumb",
    ...props,
    children: values => /*#__PURE__*/jsx(Fragment, {
      children: typeof children === "function" ? children(values) : children
    })
  });
};

/* -------------------------------------------------------------------------------------------------
 * TODO: Slider Marks
 * -----------------------------------------------------------------------------------------------*/

const SliderMarks = ({
  className,
  ...props
}) => {
  const {
    slots
  } = use(SliderContext);
  return /*#__PURE__*/jsx(dom.div, {
    className: composeSlotClassName(slots?.marks, className),
    "data-slot": "slider-marks",
    ...props
  });
};

export { SliderFill, SliderMarks, SliderOutput, SliderRoot, SliderThumb, SliderTrack };
