"use client";
import { avatarGroupVariants } from '@heroui/styles';
import React__default, { useMemo, Children, isValidElement, use } from 'react';
import { composeSlotClassName } from '../../utils/compose.js';
import { dom } from '../../utils/dom.js';
import { Avatar } from '../avatar/index.js';
import { AvatarGroupContext, AVATAR_GROUP_CHILD } from './avatar-group-context.js';
import { jsx, jsxs } from 'react/jsx-runtime';

const AvatarGroupCount = ({
  children,
  className,
  color,
  size,
  variant,
  ...props
}) => {
  const group = use(AvatarGroupContext);
  const finalSize = size ?? group.size;
  const finalColor = color ?? group.color;
  const finalVariant = variant ?? group.variant;
  return /*#__PURE__*/jsx(Avatar, {
    className: composeSlotClassName(group.slots?.count, className),
    color: finalColor,
    "data-slot": "avatar-group-count",
    size: finalSize,
    variant: finalVariant,
    ...props,
    children: /*#__PURE__*/jsx(Avatar.Fallback, {
      children: children
    })
  });
};
AvatarGroupCount.displayName = "HeroUI.AvatarGroup.Count";
const isCountElement = el => el.type === AvatarGroupCount;

/* -------------------------------------------------------------------------------------------------
 * AvatarGroup Root
 * -----------------------------------------------------------------------------------------------*/

const AvatarGroupRoot = ({
  children,
  className,
  color,
  isGrid = false,
  max,
  overlap = "clip",
  size = "md",
  variant,
  ...props
}) => {
  const slots = useMemo(() => avatarGroupVariants({
    isGrid,
    overlap
  }), [isGrid, overlap]);
  const context = useMemo(() => ({
    slots,
    size,
    color,
    variant
  }), [slots, size, color, variant]);
  const avatarChildren = [];
  const countChildren = [];
  for (const child of Children.toArray(children)) {
    if (! /*#__PURE__*/isValidElement(child)) continue;
    if (isCountElement(child)) countChildren.push(child);else avatarChildren.push(child);
  }
  const visibleChildren = max == null ? avatarChildren : avatarChildren.slice(0, Math.max(0, max));
  const remaining = max == null ? 0 : Math.max(0, avatarChildren.length - visibleChildren.length);
  const wrappedChildren = visibleChildren.map(child => /*#__PURE__*/React__default.cloneElement(child, {
    [AVATAR_GROUP_CHILD]: true
  }));
  const hasExplicitCount = countChildren.length > 0;
  const countContent = hasExplicitCount ? countChildren : remaining > 0 ? /*#__PURE__*/jsxs(AvatarGroupCount, {
    children: ["+", remaining]
  }) : null;
  return /*#__PURE__*/jsx(AvatarGroupContext, {
    value: context,
    children: /*#__PURE__*/jsxs(dom.div, {
      className: slots.base({
        className
      }),
      "data-slot": "avatar-group",
      ...props,
      children: [wrappedChildren, countContent]
    })
  });
};

export { AVATAR_GROUP_CHILD, AvatarGroupContext, AvatarGroupCount, AvatarGroupRoot };
