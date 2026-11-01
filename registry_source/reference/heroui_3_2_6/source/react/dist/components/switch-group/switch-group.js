"use client";
import { switchGroupVariants } from '@heroui/styles';
import React__default from 'react';
import { dom } from '../../utils/dom.js';
import { jsx } from 'react/jsx-runtime';

const SwitchGroupRoot = ({
  children,
  className,
  orientation,
  ...props
}) => {
  const slots = React__default.useMemo(() => switchGroupVariants({
    orientation
  }), [orientation]);
  return /*#__PURE__*/jsx(dom.div, {
    "data-slot": "switch-group",
    ...props,
    className: slots.base({
      className
    }),
    children: /*#__PURE__*/jsx(dom.div, {
      className: slots.items(),
      "data-slot": "switch-group-items",
      children: children
    })
  });
};

export { SwitchGroupRoot };
