/** Rect, computed styles, pseudo-element styles, and attributes of one element. */
export function measureElement(locator, props, pseudoProps) {
  return locator.evaluate((el, {props, pseudoProps}) => {
    const style = getComputedStyle(el);
    const rect = el.getBoundingClientRect();
    const parent = el.parentElement.getBoundingClientRect();
    const pseudo = which => {
      const computed = getComputedStyle(el, which);
      return Object.fromEntries(pseudoProps.map(k => [k, computed[k]]));
    };
    return {
      tag: el.tagName,
      text: el.textContent,
      rect: {width: rect.width, height: rect.height, parentX: rect.x - parent.x, parentY: rect.y - parent.y},
      styles: Object.fromEntries(props.map(k => [k, style[k]])),
      before: pseudo('::before'),
      after: pseudo('::after'),
      attributes: Object.fromEntries([...el.attributes]
        .filter(a => a.name.startsWith('data-') || a.name.startsWith('aria-')
          || ['role', 'disabled', 'title', 'alt'].includes(a.name))
        .map(a => [a.name, a.value])),
    };
  }, {props, pseudoProps});
}
