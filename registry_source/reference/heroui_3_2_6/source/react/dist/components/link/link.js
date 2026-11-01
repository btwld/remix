"use client";
import { linkVariants } from '@heroui/styles';
import React__default, { use, createContext } from 'react';
import { Link } from 'react-aria-components/Link';
import { dataAttr } from '../../utils/assertion.js';
import { composeTwRenderProps, composeSlotClassName } from '../../utils/compose.js';
import { dom } from '../../utils/dom.js';
import { ExternalLinkIcon } from '../icons.js';
import { jsx, Fragment } from 'react/jsx-runtime';

const LinkContext = /*#__PURE__*/createContext({});

/* ------------------------------------------------------------------------------------------------
 * Link Root
 * --------------------------------------------------------------------------------------------- */

const LinkRoot = ({
  children,
  className,
  ...props
}) => {
  const slots = React__default.useMemo(() => linkVariants(), []);
  const contextValue = React__default.useMemo(() => ({
    slots
  }), [slots]);
  return /*#__PURE__*/jsx(LinkContext, {
    value: contextValue,
    children: /*#__PURE__*/jsx(Link, {
      "data-slot": "link",
      ...props,
      className: composeTwRenderProps(className, slots?.base()),
      children: values => /*#__PURE__*/jsx(Fragment, {
        children: typeof children === "function" ? children(values) : children
      })
    })
  });
};

/* ------------------------------------------------------------------------------------------------
 * Link Icon
 * --------------------------------------------------------------------------------------------- */

const LinkIcon = ({
  children,
  className,
  ...rest
}) => {
  const {
    slots
  } = use(LinkContext);
  return /*#__PURE__*/jsx(dom.span, {
    className: composeSlotClassName(slots?.icon, className),
    "data-default-icon": dataAttr(!children),
    "data-slot": "link-icon",
    ...rest,
    children: children ?? /*#__PURE__*/jsx(ExternalLinkIcon, {
      "data-slot": "link-default-icon"
    })
  });
};

export { LinkIcon, LinkRoot };
