# Size-aware usage restrictions

<!-- GENERATED; authoritative input: catalog/restrictions.json -->

The same record drives catalog notes, the inspector, and the JavaScript usage helper.
Geometry hashes refer to the exact standalone SVG bytes. Null owner/reviewer fields remain release blockers.

```js
import {getIconUsage} from "./packages/web/index.mjs";
const usage = getIconUsage("warning", {appearance: "filled", size: 20});
// size 20 selects master 24; usage.visibleLabelRequired === true
```

The helper reports restrictions. It cannot enforce the surrounding interface text.
An accessible name or tooltip is not a substitute for a visible text label.

## Warning

Visible text label required for outline at 12 / 16 / 24 px and filled at 12 / 16 / 24 px. This also applies to scaled uses of those masters. A tooltip or accessible name alone does not replace the visible label.

Status: `inherited-restriction-owner-review-pending`. Named owner and reviewer: **pending**.

| Master | Appearance | Visible label | Exceptions | Exact SVG SHA-256 |
|---|---|---|---|---|
| 12 | outline | Required | None | `fe469b881ac3b31a565231051aaafa255405277978a16d13ca85f191b2f86dac` |
| 12 | filled | Required | None | `7845ad6471a730e397347a3b5cc3046c780fca453a16e5d4ce63f699bfec4636` |
| 16 | outline | Required | warning-stem-dot-gap-16 | `3519bb8c5aed14581041f99b27e886947cadf8e129b85a6d7e57589c3e5aacb9` |
| 16 | filled | Required | None | `fd93e4569b5c982532275052af8f7a27998613e3e386513dc4efa596a9db5823` |
| 24 | outline | Required | None | `17aa70594f1eb4578fb62302466ecb905d5541d9ebd073e8657cf01106c4e9d6` |
| 24 | filled | Required | None | `d8bd8d73af829ba8418cb8eb0bddb1db38321eebfa3f7574a45cca4e4e9b791e` |
