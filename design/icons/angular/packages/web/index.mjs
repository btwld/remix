/** Full-catalog convenience API. For one-icon imports use ./icons/sliders.mjs. */
import {paths, labels} from './data.mjs';
import {renderIcon} from './render.mjs';
export {masterForSize} from './render.mjs';
export const iconNames = Object.freeze(Object.keys(paths));
export function iconSvg(name, options = {}) {
  if (!Object.hasOwn(paths, name)) throw new RangeError(`Unknown canonical icon: ${name}`);
  return renderIcon(name, labels[name], paths[name], options);
}
export {getIconUsage} from './usage.mjs';
