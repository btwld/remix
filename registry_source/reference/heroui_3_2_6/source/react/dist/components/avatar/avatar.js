"use client";
import { avatarVariants } from '@heroui/styles';
import * as AvatarPrimitive from '@radix-ui/react-avatar';
import React__default, { use, createContext } from 'react';
import { composeSlotClassName } from '../../utils/compose.js';
import { AvatarGroupContext, AVATAR_GROUP_CHILD } from '../avatar-group/avatar-group-context.js';
import { jsx } from 'react/jsx-runtime';

const AvatarContext = /*#__PURE__*/createContext({});

/* -------------------------------------------------------------------------------------------------
 * Avatar Root
 * -----------------------------------------------------------------------------------------------*/

const AvatarRoot = ({
  children,
  className,
  color,
  size,
  variant,
  [AVATAR_GROUP_CHILD]: isAvatarGroupChild,
  ...props
}) => {
  const avatarGroupContext = use(AvatarGroupContext);

  // Only use group context when this avatar is a direct child of AvatarGroup
  const shouldUseContext = isAvatarGroupChild === true;

  // Merge props with precedence: direct props > context props
  const finalSize = size ?? (shouldUseContext ? avatarGroupContext?.size : undefined);
  const finalColor = color ?? (shouldUseContext ? avatarGroupContext?.color : undefined);
  const finalVariant = variant ?? (shouldUseContext ? avatarGroupContext?.variant : undefined);
  const slots = React__default.useMemo(() => avatarVariants({
    color: finalColor,
    size: finalSize,
    variant: finalVariant
  }), [finalColor, finalSize, finalVariant]);
  const contextValue = React__default.useMemo(() => ({
    slots
  }), [slots]);
  return /*#__PURE__*/jsx(AvatarContext, {
    value: contextValue,
    children: /*#__PURE__*/jsx(AvatarPrimitive.Root, {
      className: slots.base({
        className
      }),
      ...props,
      children: children
    })
  });
};

/* -------------------------------------------------------------------------------------------------
 * Avatar Image
 * -----------------------------------------------------------------------------------------------*/

const AvatarImage = ({
  className,
  crossOrigin,
  loading,
  onError,
  onLoad,
  sizes,
  src,
  srcSet,
  ...props
}) => {
  const {
    slots
  } = React__default.use(AvatarContext);
  return /*#__PURE__*/jsx(AvatarPrimitive.Image, {
    className: composeSlotClassName(slots?.image, className),
    crossOrigin: crossOrigin,
    loading: loading,
    sizes: sizes,
    src: src,
    srcSet: srcSet,
    onError: onError,
    onLoad: onLoad,
    ...props
  });
};

/* -------------------------------------------------------------------------------------------------
 * Avatar Fallback
 * -----------------------------------------------------------------------------------------------*/

const AvatarFallback = ({
  className,
  color,
  ...props
}) => {
  const {
    slots
  } = React__default.use(AvatarContext);
  return /*#__PURE__*/jsx(AvatarPrimitive.Fallback, {
    className: composeSlotClassName(slots?.fallback, className, {
      color
    }),
    "data-slot": "avatar-fallback",
    ...props
  });
};

export { AvatarFallback, AvatarImage, AvatarRoot };
