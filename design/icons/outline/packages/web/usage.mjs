/** Read context requirements without changing or substituting any artwork. */
import {usageRecords} from './usage-data.mjs';
import {labels} from './data.mjs';
import {masterForSize} from './render.mjs';

export function getIconUsage(name, options = {}) {
  if (!Object.hasOwn(labels, name)) throw new RangeError(`Unknown canonical icon: ${name}`);
  const {appearance = 'outline', size = 24, pack = 'angular'} = options;
  const automatic = masterForSize(size);
  const master = options.master ?? automatic;
  if (pack !== 'angular') throw new RangeError(`Unavailable pack: ${pack}`);
  if (!['outline', 'filled'].includes(appearance)) throw new RangeError(`Unavailable appearance: ${appearance}`);
  if (![12,16,24].includes(master)) throw new RangeError(`Unavailable optical master: ${master}`);
  const record = Object.hasOwn(usageRecords, name) ? usageRecords[name] : null;
  const cell = record?.sizes[master][appearance];
  return Object.freeze({
    icon: name, pack, appearance, master,
    visibleLabelRequired: cell?.visibleLabelRequired ?? false,
    restrictionId: record?.id ?? null,
    status: record?.status ?? 'no-additional-restriction-recorded',
    geometrySha256: cell?.geometrySha256 ?? null,
    exceptionIds: Object.freeze([...(cell?.exceptionIds ?? [])]),
    note: cell?.visibleLabelRequired
      ? 'A visible text label is required, including scaled uses of this master. A tooltip or accessible name alone is not a substitute.'
      : 'No additional restriction recorded. Normal control labeling and product-context review still apply.'
  });
}
