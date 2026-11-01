"use client";
import { closeButtonVariants } from '@heroui/styles';
import { useMemo } from 'react';
import { Button } from 'react-aria-components/Button';
import { CloseIcon } from '../icons.js';
import { jsx } from 'react/jsx-runtime';
import { composeTwRenderProps } from '../../utils/compose.js';

const CloseButtonRoot = ({
  children,
  className,
  slot,
  style,
  variant,
  ...rest
}) => {
  const styles = useMemo(() => closeButtonVariants({
    variant
  }), [variant]);
  return /*#__PURE__*/jsx(Button, {
    "aria-label": "Close",
    className: composeTwRenderProps(className, styles),
    "data-slot": "close-button",
    slot: slot,
    style: style,
    type: "button",
    ...rest,
    children: renderProps => typeof children === "function" ? children(renderProps) : children ?? /*#__PURE__*/jsx(CloseIcon, {
      "data-slot": "close-button-icon"
    })
  });
};

export { CloseButtonRoot };
