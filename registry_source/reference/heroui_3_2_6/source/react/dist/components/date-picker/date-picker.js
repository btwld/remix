"use client";
import { datePickerVariants } from '@heroui/styles';
import { mergeRefs } from '@react-aria/utils';
import React__default, { useRef, useEffect, use, createContext } from 'react';
import { Button } from 'react-aria-components/Button';
import { DatePicker, Popover } from 'react-aria-components/DatePicker';
import { dataAttr } from '../../utils/assertion.js';
import { composeTwRenderProps, composeSlotClassName } from '../../utils/compose.js';
import { dom } from '../../utils/dom.js';
import { IconCalendar } from '../icons.js';
import { jsx, Fragment } from 'react/jsx-runtime';
import { SurfaceContext } from '../surface/surface.js';

const DatePickerContext = /*#__PURE__*/createContext({
  triggerRef: {
    current: null
  }
});

/* -------------------------------------------------------------------------------------------------
 * DatePicker Root
 * -----------------------------------------------------------------------------------------------*/

const DatePickerRoot = ({
  children,
  className,
  onOpenChange,
  ...props
}) => {
  const slots = React__default.useMemo(() => datePickerVariants(), []);
  const triggerRef = useRef(null);
  const [isOpen, setIsOpen] = React__default.useState(false);
  const shouldRestoreFocusToTriggerRef = useRef(false);
  useEffect(() => {
    if (!isOpen) return;
    const handleGlobalKeyDown = event => {
      if (!event.metaKey && !event.ctrlKey && !event.altKey) {
        shouldRestoreFocusToTriggerRef.current = true;
      }
    };
    window.addEventListener("keydown", handleGlobalKeyDown, true);
    return () => {
      window.removeEventListener("keydown", handleGlobalKeyDown, true);
    };
  }, [isOpen]);
  const handleOpenChange = nextIsOpen => {
    setIsOpen(nextIsOpen);
    if (!nextIsOpen && shouldRestoreFocusToTriggerRef.current) {
      window.requestAnimationFrame(() => {
        triggerRef.current?.focus();
      });
    }
    shouldRestoreFocusToTriggerRef.current = false;
    onOpenChange?.(nextIsOpen);
  };
  const contextValue = React__default.useMemo(() => ({
    slots,
    triggerRef
  }), [slots, triggerRef]);
  return /*#__PURE__*/jsx(DatePickerContext, {
    value: contextValue,
    children: /*#__PURE__*/jsx(DatePicker, {
      "data-required": dataAttr(props.isRequired),
      "data-slot": "date-picker",
      ...props,
      className: composeTwRenderProps(className, slots?.base()),
      onOpenChange: handleOpenChange,
      children: values => /*#__PURE__*/jsx(Fragment, {
        children: typeof children === "function" ? children(values) : children
      })
    })
  });
};
DatePickerRoot.displayName = "HeroUI.DatePicker";

/* -------------------------------------------------------------------------------------------------
 * DatePicker Trigger
 * -----------------------------------------------------------------------------------------------*/

const DatePickerTrigger = ({
  children,
  className,
  ref,
  ...props
}) => {
  const {
    slots,
    triggerRef
  } = use(DatePickerContext);
  const contextRefCallback = React__default.useCallback(node => {
    triggerRef.current = node;
  }, [triggerRef]);
  const mergedRef = React__default.useMemo(() => mergeRefs(contextRefCallback, ref), [contextRefCallback, ref]);
  return /*#__PURE__*/jsx(Button, {
    ref: mergedRef,
    className: composeTwRenderProps(className, slots?.trigger()),
    "data-slot": "date-picker-trigger",
    ...props,
    children: values => /*#__PURE__*/jsx(Fragment, {
      children: typeof children === "function" ? children(values) : children
    })
  });
};
DatePickerTrigger.displayName = "HeroUI.DatePicker.Trigger";

/* -------------------------------------------------------------------------------------------------
 * DatePicker Trigger Indicator
 * -----------------------------------------------------------------------------------------------*/

const DatePickerTriggerIndicator = ({
  children,
  className,
  ...props
}) => {
  const {
    slots
  } = use(DatePickerContext);
  return /*#__PURE__*/jsx(dom.span, {
    "aria-hidden": "true",
    className: composeSlotClassName(slots?.triggerIndicator, className),
    "data-slot": "date-picker-trigger-indicator",
    ...props,
    children: children || /*#__PURE__*/jsx(IconCalendar, {})
  });
};
DatePickerTriggerIndicator.displayName = "HeroUI.DatePicker.TriggerIndicator";

/* -------------------------------------------------------------------------------------------------
 * DatePicker Popover
 * -----------------------------------------------------------------------------------------------*/

const DatePickerPopover = ({
  children,
  className,
  placement = "bottom",
  ...props
}) => {
  const {
    slots
  } = use(DatePickerContext);
  return /*#__PURE__*/jsx(SurfaceContext, {
    value: {
      variant: "default"
    },
    children: /*#__PURE__*/jsx(Popover, {
      ...props,
      className: composeTwRenderProps(className, slots?.popover()),
      "data-slot": "date-picker-popover",
      placement: placement,
      children: children
    })
  });
};
DatePickerPopover.displayName = "HeroUI.DatePicker.Popover";

export { DatePickerPopover, DatePickerRoot, DatePickerTrigger, DatePickerTriggerIndicator };
