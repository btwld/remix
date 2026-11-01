"use client";
import { typographyVariants } from '@heroui/styles';
import { Text } from 'react-aria-components/Text';
import { composeSlotClassName } from '../../utils/compose.js';
import { jsx } from 'react/jsx-runtime';

const defaultElementByType = {
  body: "p",
  "body-sm": "p",
  "body-xs": "p",
  code: "code",
  h1: "h1",
  h2: "h2",
  h3: "h3",
  h4: "h4",
  h5: "h5",
  h6: "h6"
};
const TypographyRoot = ({
  align = "start",
  children,
  className,
  color = "default",
  truncate,
  type = "body",
  weight,
  ...props
}) => {
  const slots = typographyVariants({
    align,
    color,
    truncate,
    type,
    weight
  });
  return /*#__PURE__*/jsx(Text, {
    className: composeSlotClassName(slots.base, className),
    "data-slot": "typography",
    "data-type": type,
    elementType: defaultElementByType[type],
    ...props,
    children: children
  });
};
const Heading = ({
  level = 1,
  ...props
}) => {
  return /*#__PURE__*/jsx(TypographyRoot, {
    type: `h${level}`,
    ...props
  });
};
const Paragraph = ({
  size = "base",
  ...props
}) => {
  const type = size === "base" ? "body" : `body-${size}`;
  return /*#__PURE__*/jsx(TypographyRoot, {
    type: type,
    ...props
  });
};
const Code = props => {
  return /*#__PURE__*/jsx(TypographyRoot, {
    type: "code",
    ...props
  });
};
const Prose = ({
  children,
  className,
  ...props
}) => {
  const slots = typographyVariants();
  return /*#__PURE__*/jsx("div", {
    className: composeSlotClassName(slots.prose, className),
    "data-slot": "prose",
    ...props,
    children: children
  });
};

export { Code, Heading, Paragraph, Prose, TypographyRoot };
