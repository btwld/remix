/** Shared renderer. Expanded paths use currentColor; they are not SVG strokes. */
const escapeXML = value => String(value).replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&apos;'}[c]));
export function masterForSize(size) {
  if (typeof size !== 'number' || !Number.isFinite(size) || size < 1 || size > 1024) throw new RangeError('size must be a finite number from 1 to 1024');
  return size <= 12 ? 12 : size <= 16 ? 16 : 24;
}
export function renderIcon(name, label, paths, options = {}) {
  const {appearance = 'outline', size = 24, pack = 'angular', title = null} = options;
  const automatic = masterForSize(size);
  const master = options.master ?? automatic;
  if (pack !== 'angular') throw new RangeError(`Unavailable pack: ${pack}`);
  if (!['outline','filled'].includes(appearance)) throw new RangeError(`Unavailable appearance: ${appearance}`);
  if (![12,16,24].includes(master)) throw new RangeError(`Unavailable optical master: ${master}`);
  const path = paths?.[appearance]?.[master];
  if (typeof path !== 'string') throw new RangeError(`Unavailable drawing: ${name}/${appearance}/${master}`);
  if (title !== null && (typeof title !== 'string' || !title.trim())) throw new TypeError('title must be a nonempty string or null');
  const semantics = title === null ? 'aria-hidden="true"' : `role="img" aria-label="${escapeXML(title)}"`;
  return `<svg xmlns="http://www.w3.org/2000/svg" width="${size}" height="${size}" viewBox="0 0 ${master} ${master}" fill="currentColor" fill-rule="evenodd" focusable="false" ${semantics}>${title === null ? '' : `<title>${escapeXML(title)}</title>`}<path d="${path}"/></svg>`;
}
