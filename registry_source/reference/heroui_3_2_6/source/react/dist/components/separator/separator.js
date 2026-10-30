"use client";
import { separatorVariants } from '@heroui/styles';
import { SeparatorContext, Separator } from 'react-aria-components/Separator';
import { useSlottedContext } from 'react-aria-components/slots';
import { jsx } from 'react/jsx-runtime';

const SeparatorRoot = ({
  className,
  orientation,
  variant,
  ...props
}) => {
  const context = useSlottedContext(SeparatorContext);
  const resolvedOrientation = orientation ?? context?.orientation ?? "horizontal";
  return /*#__PURE__*/jsx(Separator, {
    "data-orientation": resolvedOrientation,
    "data-slot": "separator",
    orientation: resolvedOrientation,
    className: separatorVariants({
      orientation: resolvedOrientation,
      variant,
      className
    }),
    ...props
  });
};

export { SeparatorRoot };
