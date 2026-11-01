"use client";
import { buttonGroupVariants } from '@heroui/styles';
import React__default, { Children, isValidElement, use, createContext } from 'react';
import { Group } from 'react-aria-components/Group';
import { useSlottedContext } from 'react-aria-components/slots';
import { ToggleButtonGroupContext } from 'react-aria-components/ToggleButtonGroup';
import { dom } from '../../utils/dom.js';
import { jsx } from 'react/jsx-runtime';
import { composeTwRenderProps, composeSlotClassName } from '../../utils/compose.js';

const ButtonGroupContext = /*#__PURE__*/createContext({});

// Property name to mark direct children of ButtonGroup
const BUTTON_GROUP_CHILD = "__button_group_child";

/* -------------------------------------------------------------------------------------------------
 * ButtonGroup Root
 * -----------------------------------------------------------------------------------------------*/

const ButtonGroupRoot = ({
  children,
  className,
  fullWidth,
  isDisabled,
  orientation: orientationProp,
  size,
  variant,
  ...rest
}) => {
  const racContext = useSlottedContext(ToggleButtonGroupContext);
  const orientation = orientationProp ?? racContext?.orientation ?? "horizontal";
  const slots = React__default.useMemo(() => buttonGroupVariants({
    fullWidth,
    orientation
  }), [fullWidth, orientation]);

  // Wrap only direct children with context provider
  const wrappedChildren = React__default.useMemo(() => Children.map(children, child => {
    if (! /*#__PURE__*/isValidElement(child)) {
      return child;
    }

    // Clone the child and add the special prop
    return /*#__PURE__*/React__default.cloneElement(child, {
      [BUTTON_GROUP_CHILD]: true
    });
  }), [children]);
  const context = React__default.useMemo(() => ({
    slots,
    size,
    variant,
    isDisabled,
    fullWidth
  }), [slots, size, variant, isDisabled, fullWidth]);
  return /*#__PURE__*/jsx(ButtonGroupContext, {
    value: context,
    children: /*#__PURE__*/jsx(Group, {
      className: composeTwRenderProps(className, slots.base()),
      "data-slot": "button-group",
      isDisabled: isDisabled,
      ...rest,
      children: wrappedChildren
    })
  });
};

/* -------------------------------------------------------------------------------------------------
 * ButtonGroup Separator
 * -----------------------------------------------------------------------------------------------*/

const ButtonGroupSeparator = ({
  className,
  ...props
}) => {
  const {
    slots
  } = use(ButtonGroupContext);
  return /*#__PURE__*/jsx(dom.span, {
    "aria-hidden": "true",
    className: composeSlotClassName(slots?.separator, className),
    "data-slot": "button-group-separator",
    ...props
  });
};

export { BUTTON_GROUP_CHILD, ButtonGroupContext, ButtonGroupRoot, ButtonGroupSeparator };
