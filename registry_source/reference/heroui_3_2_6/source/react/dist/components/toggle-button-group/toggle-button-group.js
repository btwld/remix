"use client";
import { toggleButtonGroupVariants } from '@heroui/styles';
import React__default, { use, createContext } from 'react';
import { useSlottedContext } from 'react-aria-components/slots';
import { ToggleButtonGroupContext as ToggleButtonGroupContext$1, ToggleButtonGroup } from 'react-aria-components/ToggleButtonGroup';
import { dom } from '../../utils/dom.js';
import { jsx } from 'react/jsx-runtime';
import { composeTwRenderProps, composeSlotClassName } from '../../utils/compose.js';

const ToggleButtonGroupContext = /*#__PURE__*/createContext({});

// Property name to mark direct children of ToggleButtonGroup
const TOGGLE_BUTTON_GROUP_CHILD = "__toggle_button_group_child";

/* -------------------------------------------------------------------------------------------------
 * ToggleButtonGroup Root
 * -----------------------------------------------------------------------------------------------*/

const ToggleButtonGroupRoot = ({
  children,
  className,
  fullWidth,
  isDetached = false,
  isDisabled,
  orientation: orientationProp,
  size,
  ...rest
}) => {
  const racContext = useSlottedContext(ToggleButtonGroupContext$1);
  const orientation = orientationProp ?? racContext?.orientation ?? "horizontal";
  const slots = React__default.useMemo(() => toggleButtonGroupVariants({
    fullWidth,
    isDetached,
    orientation
  }), [fullWidth, isDetached, orientation]);
  const contextValue = React__default.useMemo(() => ({
    slots,
    size,
    isDisabled
  }), [slots, size, isDisabled]);
  return /*#__PURE__*/jsx(ToggleButtonGroupContext, {
    value: contextValue,
    children: /*#__PURE__*/jsx(ToggleButtonGroup, {
      className: composeTwRenderProps(className, slots.base()),
      "data-slot": "toggle-button-group",
      isDisabled: isDisabled,
      orientation: orientation,
      ...rest,
      children: children
    })
  });
};

/* -------------------------------------------------------------------------------------------------
 * ToggleButtonGroup Separator
 * -----------------------------------------------------------------------------------------------*/

const ToggleButtonGroupSeparator = ({
  className,
  ...props
}) => {
  const {
    slots
  } = use(ToggleButtonGroupContext);
  return /*#__PURE__*/jsx(dom.span, {
    "aria-hidden": "true",
    className: composeSlotClassName(slots?.separator, className),
    "data-slot": "toggle-button-group-separator",
    ...props
  });
};

export { TOGGLE_BUTTON_GROUP_CHILD, ToggleButtonGroupContext, ToggleButtonGroupRoot, ToggleButtonGroupSeparator };
