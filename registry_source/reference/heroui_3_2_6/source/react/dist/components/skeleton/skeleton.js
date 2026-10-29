"use client";
import { skeletonVariants } from '@heroui/styles';
import React__default from 'react';
import { useCSSVariable } from '../../hooks/use-css-variable.js';
import { dom } from '../../utils/dom.js';
import { jsx } from 'react/jsx-runtime';

const SkeletonRoot = ({
  animationType,
  className,
  ...props
}) => {
  // Use the new hook to get CSS variable value with SSR support
  const resolvedAnimationType = useCSSVariable("--skeleton-animation", animationType);
  const slots = React__default.useMemo(() => skeletonVariants({
    animationType: resolvedAnimationType
  }), [resolvedAnimationType]);
  return /*#__PURE__*/jsx(dom.div, {
    className: slots.base({
      className
    }),
    ...props
  });
};

export { SkeletonRoot };
