"use client";
import { kbdVariants } from '@heroui/styles';
import React__default, { use, createContext } from 'react';
import { composeSlotClassName } from '../../utils/compose.js';
import { dom } from '../../utils/dom.js';
import { kbdKeysMap, kbdKeysLabelMap } from './kbd.constants.js';
import { jsx } from 'react/jsx-runtime';

const KbdContext = /*#__PURE__*/createContext({});

/* -------------------------------------------------------------------------------------------------
 * Kbd Root
 * -----------------------------------------------------------------------------------------------*/

const KbdRoot = ({
  children,
  className,
  variant,
  ...props
}) => {
  const slots = React__default.useMemo(() => kbdVariants({
    variant
  }), [variant]);
  const contextValue = React__default.useMemo(() => ({
    slots
  }), [slots]);
  return /*#__PURE__*/jsx(KbdContext, {
    value: contextValue,
    children: /*#__PURE__*/jsx(dom.kbd, {
      ...props,
      className: slots.base({
        className
      }),
      children: children
    })
  });
};

/* -------------------------------------------------------------------------------------------------
 * Kbd Abbr
 * -----------------------------------------------------------------------------------------------*/

const KbdAbbr = ({
  className,
  keyValue,
  ...props
}) => {
  const {
    slots
  } = use(KbdContext);
  return /*#__PURE__*/jsx(dom.abbr, {
    className: composeSlotClassName(slots?.abbr, className),
    title: kbdKeysLabelMap[keyValue],
    ...props,
    children: kbdKeysMap[keyValue]
  });
};

/* -------------------------------------------------------------------------------------------------
 * Kbd Content
 * -----------------------------------------------------------------------------------------------*/

const KbdContent = ({
  children,
  className,
  ...props
}) => {
  const {
    slots
  } = use(KbdContext);
  return /*#__PURE__*/jsx(dom.span, {
    className: composeSlotClassName(slots?.content, className),
    ...props,
    children: children
  });
};

export { KbdAbbr, KbdContent, KbdRoot };
