"use client";
import { switchVariants } from '@heroui/styles';
import React__default, { use, createContext } from 'react';
import { LabelContext } from 'react-aria-components/Label';
import { SwitchField, SwitchButton } from 'react-aria-components/Switch';
import { composeTwRenderProps, composeSlotClassName } from '../../utils/compose.js';
import { dom } from '../../utils/dom.js';
import { jsx } from 'react/jsx-runtime';

const LABEL_SPAN_CONTEXT = {
  elementType: "span"
};
const SwitchContext = /*#__PURE__*/createContext({});

/* -------------------------------------------------------------------------------------------------
 * Switch (Field) — React Aria `SwitchField`.
 * -----------------------------------------------------------------------------------------------*/

const SwitchRoot = ({
  children,
  className,
  size,
  ...props
}) => {
  const slots = React__default.useMemo(() => switchVariants({
    size
  }), [size]);
  return /*#__PURE__*/jsx(SwitchField, {
    "data-slot": "switch",
    ...props,
    className: composeTwRenderProps(className, slots.base()),
    children: state => /*#__PURE__*/jsx(SwitchContext, {
      value: {
        slots,
        state
      },
      children: typeof children === "function" ? children(state) : children
    })
  });
};
SwitchRoot.displayName = "HeroUI.Switch";

/* -------------------------------------------------------------------------------------------------
 * Switch.Content — the clickable `SwitchButton` label wrapping the control + `Label`.
 * Keep `Description`/`FieldError` as siblings of `Switch.Content`.
 * -----------------------------------------------------------------------------------------------*/

const SwitchContent = ({
  children,
  className,
  ...props
}) => {
  const {
    slots
  } = use(SwitchContext);
  return /*#__PURE__*/jsx(SwitchButton, {
    "data-slot": "switch-content",
    ...props,
    className: composeTwRenderProps(className, slots?.content()),
    children: state => /*#__PURE__*/jsx(LabelContext, {
      value: LABEL_SPAN_CONTEXT,
      children: typeof children === "function" ? children(state) : children
    })
  });
};
SwitchContent.displayName = "HeroUI.Switch.Content";

/* -----------------------------------------------------------------------------------------------*/

const SwitchControl = ({
  children,
  className,
  ...props
}) => {
  const {
    slots
  } = use(SwitchContext);
  return /*#__PURE__*/jsx(dom.span, {
    className: composeSlotClassName(slots?.control, className),
    "data-slot": "switch-control",
    ...props,
    children: children
  });
};
SwitchControl.displayName = "HeroUI.Switch.Control";

/* -----------------------------------------------------------------------------------------------*/

const SwitchThumb = ({
  children,
  className,
  ...props
}) => {
  const {
    slots
  } = use(SwitchContext);
  return /*#__PURE__*/jsx(dom.span, {
    className: composeSlotClassName(slots?.thumb, className),
    "data-slot": "switch-thumb",
    ...props,
    children: children
  });
};
SwitchThumb.displayName = "HeroUI.Switch.Thumb";

/* -----------------------------------------------------------------------------------------------*/

const SwitchIcon = ({
  children,
  className,
  ...props
}) => {
  const {
    slots
  } = use(SwitchContext);
  return /*#__PURE__*/jsx(dom.span, {
    className: composeSlotClassName(slots?.icon, className),
    "data-slot": "switch-icon",
    ...props,
    children: children
  });
};
SwitchIcon.displayName = "HeroUI.Switch.Icon";

export { SwitchContent, SwitchControl, SwitchIcon, SwitchRoot, SwitchThumb };
