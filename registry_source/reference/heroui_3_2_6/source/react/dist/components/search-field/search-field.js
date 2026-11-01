"use client";
import { searchFieldVariants } from '@heroui/styles';
import React__default, { use, createContext } from 'react';
import { Group } from 'react-aria-components/Group';
import { Input } from 'react-aria-components/Input';
import { SearchField } from 'react-aria-components/SearchField';
import { composeTwRenderProps, composeSlotClassName } from '../../utils/compose.js';
import { CloseButton } from '../close-button/index.js';
import { IconSearch } from '../icons.js';
import { jsx, Fragment } from 'react/jsx-runtime';

const SearchFieldContext = /*#__PURE__*/createContext({});

/* -------------------------------------------------------------------------------------------------
 * SearchField Root
 * -----------------------------------------------------------------------------------------------*/

const SearchFieldRoot = ({
  children,
  className,
  fullWidth,
  variant,
  ...props
}) => {
  const slots = React__default.useMemo(() => searchFieldVariants({
    fullWidth,
    variant
  }), [fullWidth, variant]);
  const contextValue = React__default.useMemo(() => ({
    slots
  }), [slots]);
  return /*#__PURE__*/jsx(SearchFieldContext, {
    value: contextValue,
    children: /*#__PURE__*/jsx(SearchField, {
      "data-slot": "search-field",
      ...props,
      className: composeTwRenderProps(className, slots?.base()),
      children: values => /*#__PURE__*/jsx(Fragment, {
        children: typeof children === "function" ? children(values) : children
      })
    })
  });
};

/* -------------------------------------------------------------------------------------------------
 * SearchField Group
 * -----------------------------------------------------------------------------------------------*/

const SearchFieldGroup = ({
  children,
  className,
  ...props
}) => {
  const {
    slots
  } = use(SearchFieldContext);
  return /*#__PURE__*/jsx(Group, {
    className: composeTwRenderProps(className, slots?.group()),
    "data-slot": "search-field-group",
    ...props,
    children: values => /*#__PURE__*/jsx(Fragment, {
      children: typeof children === "function" ? children(values) : children
    })
  });
};

/* -------------------------------------------------------------------------------------------------
 * SearchField Input
 * -----------------------------------------------------------------------------------------------*/

const SearchFieldInput = ({
  className,
  ...props
}) => {
  const {
    slots
  } = use(SearchFieldContext);
  return /*#__PURE__*/jsx(Input, {
    className: composeTwRenderProps(className, slots?.input()),
    "data-slot": "search-field-input",
    ...props
  });
};

/* -------------------------------------------------------------------------------------------------
 * SearchField Search Icon
 * -----------------------------------------------------------------------------------------------*/

const SearchFieldSearchIcon = ({
  children,
  className,
  ...props
}) => {
  const {
    slots
  } = use(SearchFieldContext);
  if (children && /*#__PURE__*/React__default.isValidElement(children)) {
    return /*#__PURE__*/React__default.cloneElement(children, {
      ...props,
      className: composeSlotClassName(slots?.searchIcon, className),
      "data-slot": "search-field-search-icon"
    });
  }
  return /*#__PURE__*/jsx(IconSearch, {
    className: composeSlotClassName(slots?.searchIcon, className),
    "data-slot": "search-field-search-icon",
    ...props
  });
};

/* -------------------------------------------------------------------------------------------------
 * SearchField Clear Button
 * -----------------------------------------------------------------------------------------------*/

const SearchFieldClearButton = ({
  className,
  ...props
}) => {
  const {
    slots
  } = use(SearchFieldContext);
  return /*#__PURE__*/jsx(CloseButton, {
    className: composeTwRenderProps(className, slots?.clearButton()),
    "data-slot": "search-field-clear-button",
    slot: "clear",
    ...props
  });
};

export { SearchFieldClearButton, SearchFieldGroup, SearchFieldInput, SearchFieldRoot, SearchFieldSearchIcon };
