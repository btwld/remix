"use client";
import { checkboxGroupVariants } from '@heroui/styles';
import React__default, { createContext } from 'react';
import { CheckboxGroup as CheckboxGroup$1 } from 'react-aria-components/CheckboxGroup';
import { composeTwRenderProps } from '../../utils/compose.js';
import { jsx, Fragment } from 'react/jsx-runtime';

const CheckboxGroupContext = /*#__PURE__*/createContext({});
const CheckboxGroup = ({
  children,
  className,
  variant,
  ...props
}) => {
  const styles = React__default.useMemo(() => checkboxGroupVariants({
    variant
  }), [variant]);
  return /*#__PURE__*/jsx(CheckboxGroupContext.Provider, {
    value: {
      variant
    },
    children: /*#__PURE__*/jsx(CheckboxGroup$1, {
      className: composeTwRenderProps(className, styles),
      "data-slot": "checkbox-group",
      ...props,
      children: values => /*#__PURE__*/jsx(Fragment, {
        children: typeof children === "function" ? children(values) : children
      })
    })
  });
};

export { CheckboxGroup, CheckboxGroupContext };
