"use client";
import { textAreaVariants } from '@heroui/styles';
import { use } from 'react';
import { TextArea } from 'react-aria-components/TextArea';
import { jsx } from 'react/jsx-runtime';
import { TextFieldContext } from '../textfield/textfield.js';
import { composeTwRenderProps } from '../../utils/compose.js';

const TextAreaRoot = ({
  className,
  fullWidth,
  variant,
  ...rest
}) => {
  const textFieldContext = use(TextFieldContext);
  const resolvedVariant = variant ?? textFieldContext?.variant;
  return /*#__PURE__*/jsx(TextArea, {
    "data-slot": "textarea",
    className: composeTwRenderProps(className, textAreaVariants({
      fullWidth,
      variant: resolvedVariant
    })),
    ...rest
  });
};

export { TextAreaRoot };
