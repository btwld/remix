"use client";
import { radioVariants } from '@heroui/styles';
import React__default, { use, createContext } from 'react';
import { LabelContext } from 'react-aria-components/Label';
import { RadioField, RadioButton } from 'react-aria-components/RadioGroup';
import { composeTwRenderProps, composeSlotClassName } from '../../utils/compose.js';
import { dom } from '../../utils/dom.js';
import { jsx } from 'react/jsx-runtime';

const LABEL_SPAN_CONTEXT = {
  elementType: "span"
};
const RadioContext = /*#__PURE__*/createContext({});

/* -------------------------------------------------------------------------------------------------
 * Radio (Field) — React Aria `RadioField`.
 * -----------------------------------------------------------------------------------------------*/

const RadioRoot = ({
  children,
  className,
  ...props
}) => {
  const slots = React__default.useMemo(() => radioVariants(), []);
  return /*#__PURE__*/jsx(RadioField, {
    "data-slot": "radio",
    ...props,
    className: composeTwRenderProps(className, slots.base()),
    children: state => /*#__PURE__*/jsx(RadioContext, {
      value: {
        slots,
        state
      },
      children: typeof children === "function" ? children(state) : children
    })
  });
};
RadioRoot.displayName = "HeroUI.Radio";

/* -------------------------------------------------------------------------------------------------
 * Radio.Content — the clickable `RadioButton` label wrapping the control + `Label`.
 * Keep `Description`/`FieldError` as siblings of `Radio.Content`.
 * -----------------------------------------------------------------------------------------------*/

const RadioContent = ({
  children,
  className,
  ...props
}) => {
  const {
    slots
  } = use(RadioContext);
  return /*#__PURE__*/jsx(RadioButton, {
    "data-slot": "radio-content",
    ...props,
    className: composeTwRenderProps(className, slots?.content()),
    children: state => /*#__PURE__*/jsx(LabelContext, {
      value: LABEL_SPAN_CONTEXT,
      children: typeof children === "function" ? children(state) : children
    })
  });
};
RadioContent.displayName = "HeroUI.Radio.Content";

/* -----------------------------------------------------------------------------------------------*/

const RadioControl = ({
  children,
  className,
  ...props
}) => {
  const {
    slots
  } = use(RadioContext);
  return /*#__PURE__*/jsx(dom.span, {
    className: composeSlotClassName(slots?.control, className),
    "data-slot": "radio-control",
    ...props,
    children: children
  });
};
RadioControl.displayName = "HeroUI.Radio.Control";

/* -----------------------------------------------------------------------------------------------*/

const RadioIndicator = ({
  children,
  className,
  ...props
}) => {
  const {
    slots,
    state
  } = use(RadioContext);
  const content = typeof children === "function" ? children(state ?? {}) : children;
  return /*#__PURE__*/jsx(dom.span, {
    "aria-hidden": "true",
    className: composeSlotClassName(slots?.indicator, className),
    "data-slot": "radio-indicator",
    ...props,
    children: content
  });
};
RadioIndicator.displayName = "HeroUI.Radio.Indicator";

export { RadioContent, RadioControl, RadioIndicator, RadioRoot };
