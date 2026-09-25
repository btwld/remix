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
| 12 | outline | Required | warning-gap-12 | `d9d01bee7f8a4fe661d57aa621344b624ca4ecd78e9cf99fe06c1741199ec0d7` |
| 12 | filled | Required | None | `08e261fd0b04e6a36ab85c8884347a95bb3c826dc6951bd9ba4129b42bb560e6` |
| 16 | outline | Required | warning-gap-16 | `25208022afec19c70a90e9e5d37d56368da7b2df774027c719bb6fa8c564bcf5` |
| 16 | filled | Required | warning-filled-punctuation-16 | `43979e5c0d923bbf75381a5267f32f65355482fd93f20a62c92c757ed7912ffe` |
| 24 | outline | Required | warning-gap-24 | `2387cc9c7e37ce8e2d3230061aa5be1858a86f7c39aacc442dbdb02b7dcb806b` |
| 24 | filled | Required | warning-filled-punctuation-24 | `a538654374507fdbe1ece22a1f7f3b21dbf3c06138600c9c30c9f4229dc62be3` |

