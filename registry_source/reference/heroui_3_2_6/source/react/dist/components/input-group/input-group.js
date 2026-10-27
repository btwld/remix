"use client";
import { inputGroupVariants } from '@heroui/styles';
import React__default, { use, createContext } from 'react';
import { Group } from 'react-aria-components/Group';
import { Input } from 'react-aria-components/Input';
import { TextArea } from 'react-aria-components/TextArea';
import { composeTwRenderProps, composeSlotClassName } from '../../utils/compose.js';
import { jsx } from 'react/jsx-runtime';
import { TextFieldContext } from '../textfield/textfield.js';

const InputGroupContext = /*#__PURE__*/createContext({});

/* -------------------------------------------------------------------------------------------------
 * InputGroup Root
 * -----------------------------------------------------------------------------------------------*/

const InputGroupRoot = ({
  children,
  className,
  fullWidth,
  onClick,
  variant,
  ...props
}) => {
  const textFieldContext = use(TextFieldContext);
  const resolvedVariant = variant ?? textFieldContext?.variant;
  const groupRef = React__default.useRef(null);
  const slots = React__default.useMemo(() => inputGroupVariants({
    fullWidth,
    variant: resolvedVariant
  }), [fullWidth, resolvedVariant]);
  const handleClick = e => {
    const target = e.target;
    const input = groupRef.current?.querySelector("input");
    if (input && target !== input && !input.contains(target)) {
      input.focus();
    }
    onClick?.(e);
  };
  const contextValue = React__default.useMemo(() => ({
    slots
  }), [slots]);
  return /*#__PURE__*/jsx(InputGroupContext, {
    value: contextValue,
    children: /*#__PURE__*/jsx(Group, {
      ...props,
      ref: groupRef,
      className: composeTwRenderProps(className, slots?.base()),
      "data-slot": "input-group",
      onClick: handleClick,
      children: renderProps => typeof children === "function" ? children(renderProps) : children
    })
  });
};

/* -------------------------------------------------------------------------------------------------
 * InputGroup Input
 * -----------------------------------------------------------------------------------------------*/

const InputGroupInput = ({
  className,
  ...props
}) => {
  const {
    slots
  } = use(InputGroupContext);
  return /*#__PURE__*/jsx(Input, {
    className: composeTwRenderProps(className, slots?.input()),
    "data-slot": "input-group-input",
    ...props
  });
};

/* -------------------------------------------------------------------------------------------------
 * InputGroup Prefix
 * -----------------------------------------------------------------------------------------------*/

const InputGroupPrefix = ({
  children,
  className,
  ...props
}) => {
  const {
    slots
  } = use(InputGroupContext);
  return /*#__PURE__*/jsx("div", {
    className: composeSlotClassName(slots?.prefix, className),
    "data-slot": "input-group-prefix",
    ...props,
    children: children
  });
};

/* -------------------------------------------------------------------------------------------------
 * InputGroup TextArea
 * -----------------------------------------------------------------------------------------------*/

const InputGroupTextArea = ({
  className,
  ...props
}) => {
  const {
    slots
  } = use(InputGroupContext);
  return /*#__PURE__*/jsx(TextArea, {
    className: composeTwRenderProps(className, slots?.input()),
    "data-slot": "input-group-textarea",
    ...props
  });
};

/* -------------------------------------------------------------------------------------------------
 * InputGroup Suffix
 * -----------------------------------------------------------------------------------------------*/

const InputGroupSuffix = ({
  children,
  className,
  ...props
}) => {
  const {
    slots
  } = use(InputGroupContext);
  return /*#__PURE__*/jsx("div", {
    className: composeSlotClassName(slots?.suffix, className),
    "data-slot": "input-group-suffix",
    ...props,
    children: children
  });
};

export { InputGroupInput, InputGroupPrefix, InputGroupRoot, InputGroupSuffix, InputGroupTextArea };
