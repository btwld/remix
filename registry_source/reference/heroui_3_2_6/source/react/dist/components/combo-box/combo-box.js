"use client";
import { comboBoxVariants } from '@heroui/styles';
import React__default, { use, Children, isValidElement, createContext } from 'react';
import { useIsHidden } from 'react-aria/private/collections/Hidden';
import { Button } from 'react-aria-components/Button';
import { ComboBox, Popover, ComboBoxStateContext, ComboBoxValue as ComboBoxValue$1 } from 'react-aria-components/ComboBox';
import { Group } from 'react-aria-components/Group';
import { dataAttr } from '../../utils/assertion.js';
import { createCollectionSlot } from '../../utils/collection-prop-injection.js';
import { composeTwRenderProps } from '../../utils/compose.js';
import { dom } from '../../utils/dom.js';
import { FieldSlotsGate } from '../../utils/field-slots-gate.js';
import { IconChevronDown } from '../icons.js';
import { jsx, Fragment, jsxs } from 'react/jsx-runtime';
import { SurfaceContext } from '../surface/surface.js';

const ComboBoxContext = /*#__PURE__*/createContext({});

/* -------------------------------------------------------------------------------------------------
 * ComboBox Collection Slot
 * -----------------------------------------------------------------------------------------------*/

const inputGroupSlot = createCollectionSlot("combo-box.inputGroup");
const EMPTY_SIBLINGS = [];

/* -------------------------------------------------------------------------------------------------
 * ComboBox Root
 * -----------------------------------------------------------------------------------------------*/

const ComboBoxRoot = ({
  children,
  className,
  fullWidth,
  menuTrigger = "focus",
  variant,
  ...props
}) => {
  const slots = React__default.useMemo(() => comboBoxVariants({
    fullWidth
  }), [fullWidth]);
  const contextValue = React__default.useMemo(() => ({
    slots,
    variant
  }), [slots, variant]);
  return /*#__PURE__*/jsx(FieldSlotsGate, {
    children: /*#__PURE__*/jsx(ComboBoxContext, {
      value: contextValue,
      children: /*#__PURE__*/jsx(ComboBox, {
        "data-slot": "combo-box",
        menuTrigger: menuTrigger,
        ...props,
        className: composeTwRenderProps(className, slots?.base()),
        children: values => /*#__PURE__*/jsx(Fragment, {
          children: typeof children === "function" ? children(values) : children
        })
      })
    })
  });
};

/* -------------------------------------------------------------------------------------------------
 * ComboBox InputGroup
 * -----------------------------------------------------------------------------------------------*/

const ComboBoxInputGroup = ({
  children,
  className,
  render,
  ...containerProps
}) => {
  const childArray = Children.toArray(children).filter(isValidElement);
  // Trigger is last (Input + Trigger); inject only into it so Input stays out of the slot props.
  const trigger = childArray.at(-1);
  const siblings = childArray.slice(0, -1);
  if (!trigger) {
    return null;
  }
  return /*#__PURE__*/jsx(inputGroupSlot.Injector, {
    ...containerProps,
    className,
    render,
    siblings,
    children: trigger
  });
};

/* -------------------------------------------------------------------------------------------------
 * ComboBox Value
 * -----------------------------------------------------------------------------------------------*/

const ComboBoxValue = ({
  children,
  className,
  ...props
}) => {
  const {
    slots
  } = use(ComboBoxContext);
  return /*#__PURE__*/jsx(ComboBoxValue$1, {
    className: composeTwRenderProps(className, slots?.value()),
    "data-slot": "combo-box-value",
    ...props,
    children: children
  });
};

/* -------------------------------------------------------------------------------------------------
 * ComboBox Trigger
 * -----------------------------------------------------------------------------------------------*/

const ComboBoxTrigger = ({
  children,
  className,
  ...props
}) => {
  const {
    slots
  } = use(ComboBoxContext);
  const state = use(ComboBoxStateContext);
  const isHidden = useIsHidden();
  const [inputGroupProps, restProps] = inputGroupSlot.useSlot(props);
  if (!inputGroupProps) {
    return /*#__PURE__*/jsx(Button, {
      className: composeTwRenderProps(className, slots?.trigger()),
      "data-open": dataAttr(state?.isOpen),
      "data-slot": "combo-box-trigger",
      ...restProps,
      children: children ?? /*#__PURE__*/jsx(IconChevronDown, {
        "data-slot": "combo-box-trigger-default-icon"
      })
    });
  }
  if (isHidden) {
    return null;
  }
  const {
    className: containerClassName,
    render: containerRender,
    siblings = EMPTY_SIBLINGS,
    ...containerRest
  } = inputGroupProps;
  return /*#__PURE__*/jsx(Group, {
    ...containerRest,
    className: composeTwRenderProps(containerClassName, slots?.inputGroup()),
    "data-slot": "combo-box-input-group",
    render: renderProps => {
      const {
        children: _groupChildren,
        className: groupClassName,
        ref: groupRef,
        ...groupRest
      } = renderProps;
      return /*#__PURE__*/jsxs(dom.div, {
        className: groupClassName,
        "data-slot": "combo-box-input-group",
        render: containerRender,
        ...groupRest,
        ref: groupRef,
        children: [siblings, /*#__PURE__*/jsx(Button, {
          className: composeTwRenderProps(className, slots?.trigger()),
          "data-open": dataAttr(state?.isOpen),
          "data-slot": "combo-box-trigger",
          ...restProps,
          children: children ?? /*#__PURE__*/jsx(IconChevronDown, {
            "data-slot": "combo-box-trigger-default-icon"
          })
        })]
      });
    }
  });
};

/* -------------------------------------------------------------------------------------------------
 * ComboBox Popover
 * -----------------------------------------------------------------------------------------------*/

const ComboBoxPopover = ({
  children,
  className,
  placement = "bottom",
  ...props
}) => {
  const {
    slots
  } = use(ComboBoxContext);
  return /*#__PURE__*/jsx(SurfaceContext, {
    value: {
      variant: "default"
    },
    children: /*#__PURE__*/jsx(Popover, {
      ...props,
      className: composeTwRenderProps(className, slots?.popover()),
      "data-slot": "combo-box-popover",
      placement: placement,
      children: children
    })
  });
};

export { ComboBoxContext, ComboBoxInputGroup, ComboBoxPopover, ComboBoxRoot, ComboBoxTrigger, ComboBoxValue };
