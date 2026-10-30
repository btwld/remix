"use client";
import { checkboxVariants } from '@heroui/styles';
import React__default, { use, createContext } from 'react';
import { CheckboxField, CheckboxButton } from 'react-aria-components/Checkbox';
import { LabelContext } from 'react-aria-components/Label';
import { composeTwRenderProps, composeSlotClassName } from '../../utils/compose.js';
import { dom } from '../../utils/dom.js';
import { CheckboxGroupContext } from '../checkbox-group/checkbox-group.js';
import { jsx } from 'react/jsx-runtime';

const LABEL_SPAN_CONTEXT = {
  elementType: "span"
};
const CheckboxContext = /*#__PURE__*/createContext({});

/* -------------------------------------------------------------------------------------------------
 * Checkbox (Field) — React Aria `CheckboxField`.
 * -----------------------------------------------------------------------------------------------*/

const CheckboxRoot = ({
  children,
  className,
  variant,
  ...props
}) => {
  const checkboxGroupContext = use(CheckboxGroupContext);
  const effectiveVariant = variant ?? checkboxGroupContext.variant;
  const slots = React__default.useMemo(() => checkboxVariants({
    variant: effectiveVariant
  }), [effectiveVariant]);
  return /*#__PURE__*/jsx(CheckboxField, {
    "data-slot": "checkbox",
    ...props,
    className: composeTwRenderProps(className, slots.base()),
    children: state => /*#__PURE__*/jsx(CheckboxContext, {
      value: {
        slots,
        state
      },
      children: typeof children === "function" ? children(state) : children
    })
  });
};
CheckboxRoot.displayName = "HeroUI.Checkbox";

/* -------------------------------------------------------------------------------------------------
 * Checkbox.Content — the clickable `CheckboxButton` label wrapping the control + `Label`.
 * Keep `Description`/`FieldError` as siblings of `Checkbox.Content`.
 * -----------------------------------------------------------------------------------------------*/

const CheckboxContent = ({
  children,
  className,
  ...props
}) => {
  const {
    slots
  } = use(CheckboxContext);
  return /*#__PURE__*/jsx(CheckboxButton, {
    "data-slot": "checkbox-content",
    ...props,
    className: composeTwRenderProps(className, slots?.content()),
    children: state => /*#__PURE__*/jsx(LabelContext, {
      value: LABEL_SPAN_CONTEXT,
      children: typeof children === "function" ? children(state) : children
    })
  });
};
CheckboxContent.displayName = "HeroUI.Checkbox.Content";

/* -----------------------------------------------------------------------------------------------*/

const CheckboxControl = ({
  children,
  className,
  ...props
}) => {
  const {
    slots
  } = use(CheckboxContext);
  return /*#__PURE__*/jsx(dom.span, {
    className: composeSlotClassName(slots?.control, className),
    "data-slot": "checkbox-control",
    ...props,
    children: children
  });
};
CheckboxControl.displayName = "HeroUI.Checkbox.Control";

/* -----------------------------------------------------------------------------------------------*/

const CheckboxIndicator = ({
  children,
  className,
  ...props
}) => {
  const {
    slots,
    state
  } = use(CheckboxContext);
  const isSelected = state?.isSelected;
  const isIndeterminate = state?.isIndeterminate;
  const content = typeof children === "function" ? children(state ?? {}) : children ? children : isIndeterminate ? /*#__PURE__*/jsx("svg", {
    "aria-hidden": "true",
    "data-slot": "checkbox-default-indicator--indeterminate",
    fill: "none",
    role: "presentation",
    stroke: "currentColor",
    strokeLinecap: "round",
    strokeWidth: 3,
    viewBox: "0 0 24 24",
    children: /*#__PURE__*/jsx("line", {
      x1: "21",
      x2: "3",
      y1: "12",
      y2: "12"
    })
  }) : /*#__PURE__*/jsx("svg", {
    "aria-hidden": "true",
    "data-slot": "checkbox-default-indicator--checkmark",
    fill: "none",
    role: "presentation",
    stroke: "currentColor",
    strokeDasharray: 22,
    strokeDashoffset: isSelected ? 44 : 66,
    strokeLinecap: "round",
    strokeLinejoin: "round",
    strokeWidth: 2,
    viewBox: "0 0 17 18",
    children: /*#__PURE__*/jsx("polyline", {
      points: "1 9 7 14 15 4"
    })
  });
  return /*#__PURE__*/jsx(dom.span, {
    "aria-hidden": "true",
    className: composeSlotClassName(slots?.indicator, className),
    "data-slot": "checkbox-indicator",
    ...props,
    children: content
  });
};
CheckboxIndicator.displayName = "HeroUI.Checkbox.Indicator";

export { CheckboxContent, CheckboxControl, CheckboxIndicator, CheckboxRoot };
