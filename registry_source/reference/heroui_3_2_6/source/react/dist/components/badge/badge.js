"use client";
import { badgeVariants } from '@heroui/styles';
import React__default, { use, createContext } from 'react';
import { cx } from 'tailwind-variants';
import { composeSlotClassName } from '../../utils/compose.js';
import { dom } from '../../utils/dom.js';
import { jsx } from 'react/jsx-runtime';

const BadgeContext = /*#__PURE__*/createContext({});

/* -------------------------------------------------------------------------------------------------
 * Badge Anchor
 * -----------------------------------------------------------------------------------------------*/

const BadgeAnchor = ({
  children,
  className,
  ...props
}) => {
  return /*#__PURE__*/jsx(dom.span, {
    ...props,
    className: cx("badge-anchor", className) ?? undefined,
    "data-slot": "badge-anchor",
    children: children
  });
};

/* -------------------------------------------------------------------------------------------------
 * Badge Root
 * -----------------------------------------------------------------------------------------------*/

const BadgeRoot = ({
  children,
  className,
  color,
  placement,
  size,
  variant,
  ...props
}) => {
  const slots = React__default.useMemo(() => badgeVariants({
    color,
    placement,
    size,
    variant
  }), [color, placement, size, variant]);
  const badgeChildren = React__default.useMemo(() => {
    if (typeof children === "string" || typeof children === "number") {
      return /*#__PURE__*/jsx(BadgeLabel, {
        children: children
      });
    }
    return children;
  }, [children]);
  const contextValue = React__default.useMemo(() => ({
    slots
  }), [slots]);
  return /*#__PURE__*/jsx(BadgeContext, {
    value: contextValue,
    children: /*#__PURE__*/jsx(dom.span, {
      ...props,
      className: composeSlotClassName(slots.base, className),
      "data-slot": "badge",
      children: badgeChildren
    })
  });
};

/* -------------------------------------------------------------------------------------------------
 * Badge Label
 * -----------------------------------------------------------------------------------------------*/

const BadgeLabel = ({
  children,
  className,
  ...props
}) => {
  const {
    slots
  } = use(BadgeContext);
  return /*#__PURE__*/jsx(dom.span, {
    className: composeSlotClassName(slots?.label, className),
    "data-slot": "badge-label",
    ...props,
    children: children
  });
};

export { BadgeAnchor, BadgeLabel, BadgeRoot };
