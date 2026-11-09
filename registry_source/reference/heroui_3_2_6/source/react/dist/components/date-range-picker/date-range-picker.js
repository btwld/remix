"use client";
import { dateRangePickerVariants } from '@heroui/styles';
import { mergeRefs } from '@react-aria/utils';
import React__default, { useRef, useEffect, use, createContext } from 'react';
import { Button } from 'react-aria-components/Button';
import { DateRangePicker, Popover } from 'react-aria-components/DateRangePicker';
import { dataAttr } from '../../utils/assertion.js';
import { composeTwRenderProps, composeSlotClassName } from '../../utils/compose.js';
import { dom } from '../../utils/dom.js';
import { IconCalendar } from '../icons.js';
import { jsx, Fragment } from 'react/jsx-runtime';
import { SurfaceContext } from '../surface/surface.js';

const DateRangePickerContext = /*#__PURE__*/createContext({
  triggerRef: {
    current: null
  }
});

/* -------------------------------------------------------------------------------------------------
 * DateRangePicker Root
 * -----------------------------------------------------------------------------------------------*/

const DateRangePickerRoot = ({
  children,
  className,
  onOpenChange,
  ...props
}) => {
  const slots = React__default.useMemo(() => dateRangePickerVariants(), []);
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
  return /*#__PURE__*/jsx(DateRangePickerContext, {
    value: contextValue,
    children: /*#__PURE__*/jsx(DateRangePicker, {
      "data-required": dataAttr(props.isRequired),
      "data-slot": "date-range-picker",
      ...props,
      className: composeTwRenderProps(className, slots?.base()),
      onOpenChange: handleOpenChange,
      children: values => /*#__PURE__*/jsx(Fragment, {
        children: typeof children === "function" ? children(values) : children
      })
    })
  });
};
DateRangePickerRoot.displayName = "HeroUI.DateRangePicker";

/* -------------------------------------------------------------------------------------------------
 * DateRangePicker Trigger
 * -----------------------------------------------------------------------------------------------*/

const DateRangePickerTrigger = ({
  children,
  className,
  ref,
  ...props
}) => {
  const {
    slots,
    triggerRef
  } = use(DateRangePickerContext);
  const contextRefCallback = React__default.useCallback(node => {
    triggerRef.current = node;
  }, [triggerRef]);
  const mergedRef = React__default.useMemo(() => mergeRefs(contextRefCallback, ref), [contextRefCallback, ref]);
  return /*#__PURE__*/jsx(Button, {
    ref: mergedRef,
    className: composeTwRenderProps(className, slots?.trigger()),
    "data-slot": "date-range-picker-trigger",
    ...props,
    children: values => /*#__PURE__*/jsx(Fragment, {
      children: typeof children === "function" ? children(values) : children
    })
  });
};
DateRangePickerTrigger.displayName = "HeroUI.DateRangePicker.Trigger";

/* -------------------------------------------------------------------------------------------------
 * DateRangePicker Trigger Indicator
 * -----------------------------------------------------------------------------------------------*/

const DateRangePickerTriggerIndicator = ({
  children,
  className,
  ...props
}) => {
  const {
    slots
  } = use(DateRangePickerContext);
  return /*#__PURE__*/jsx(dom.span, {
    "aria-hidden": "true",
    className: composeSlotClassName(slots?.triggerIndicator, className),
    "data-slot": "date-range-picker-trigger-indicator",
    ...props,
    children: children || /*#__PURE__*/jsx(IconCalendar, {})
  });
};
DateRangePickerTriggerIndicator.displayName = "HeroUI.DateRangePicker.TriggerIndicator";

/* -------------------------------------------------------------------------------------------------
 * DateRangePicker Range Separator
 * -----------------------------------------------------------------------------------------------*/

const DateRangePickerRangeSeparator = ({
  children = " - ",
  className,
  ...props
}) => {
  const {
    slots
  } = use(DateRangePickerContext);
  return /*#__PURE__*/jsx(dom.span, {
    "aria-hidden": "true",
    className: composeSlotClassName(slots?.rangeSeparator, className),
    "data-slot": "date-range-picker-range-separator",
    ...props,
    children: children
  });
};
DateRangePickerRangeSeparator.displayName = "HeroUI.DateRangePicker.RangeSeparator";

/* -------------------------------------------------------------------------------------------------
 * DateRangePicker Popover
 * -----------------------------------------------------------------------------------------------*/

const DateRangePickerPopover = ({
  children,
  className,
  placement = "bottom",
  ...props
}) => {
  const {
    slots
  } = use(DateRangePickerContext);
  return /*#__PURE__*/jsx(SurfaceContext, {
    value: {
      variant: "default"
    },
    children: /*#__PURE__*/jsx(Popover, {
      ...props,
      className: composeTwRenderProps(className, slots?.popover()),
      "data-slot": "date-range-picker-popover",
      placement: placement,
      children: children
    })
  });
};
DateRangePickerPopover.displayName = "HeroUI.DateRangePicker.Popover";

export { DateRangePickerPopover, DateRangePickerRangeSeparator, DateRangePickerRoot, DateRangePickerTrigger, DateRangePickerTriggerIndicator };
