"use client";
import { radioGroupVariants } from '@heroui/styles';
import React__default from 'react';
import { RadioGroup } from 'react-aria-components/RadioGroup';
import { composeTwRenderProps } from '../../utils/compose.js';
import { jsx, Fragment } from 'react/jsx-runtime';

const RadioGroupRoot = ({
  children,
  className,
  variant,
  ...props
}) => {
  const styles = React__default.useMemo(() => radioGroupVariants({
    variant
  }), [variant]);
  return /*#__PURE__*/jsx(RadioGroup, {
    "data-slot": "radio-group",
    ...props,
    className: composeTwRenderProps(className, styles),
    children: values => /*#__PURE__*/jsx(Fragment, {
      children: typeof children === "function" ? children(values) : children
    })
  });
};

export { RadioGroupRoot };
