"use client";
import { toggleButtonVariants } from '@heroui/styles';
import { use } from 'react';
import { ToggleButton } from 'react-aria-components/ToggleButton';
import { jsx } from 'react/jsx-runtime';
import { ToggleButtonGroupContext } from '../toggle-button-group/toggle-button-group.js';
import { composeTwRenderProps } from '../../utils/compose.js';

const ToggleButtonRoot = ({
  children,
  className,
  isIconOnly,
  size,
  style,
  variant,
  ...rest
}) => {
  const groupContext = use(ToggleButtonGroupContext);

  // Merge props with precedence: direct props > context props
  const finalSize = size ?? groupContext?.size;
  const styles = toggleButtonVariants({
    isIconOnly,
    size: finalSize,
    variant
  });
  return /*#__PURE__*/jsx(ToggleButton, {
    className: composeTwRenderProps(className, styles),
    "data-slot": "toggle-button",
    style: style,
    ...rest,
    children: renderProps => typeof children === "function" ? children(renderProps) : children
  });
};

export { ToggleButtonRoot };
