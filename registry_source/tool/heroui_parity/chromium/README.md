# HeroUI web captures

Real `@heroui/react` and `@heroui/styles` **3.2.6**, rendered with the compiled
CSS in headless Chromium. The dependency graph is pinned in `package-lock.json`
and checked against `reference/heroui_3_2_6/sources.json` before every capture.
Nothing here imports Flutter or the preset.

```shell
cd registry_source/tool/heroui_parity/chromium
npm ci --ignore-scripts
node capture_families2.mjs          # or any script in the table below
cd ../../.. && dart run tool/heroui_parity/slim_measurements.dart
```

System Chrome is used; set `CHROME_PATH` for another binary. Each run opens an
isolated disposable browser context (device scale factor 1, sRGB, reduced
motion for state captures). Regeneration is an explicit maintainer operation:
CI reads the committed files and does not install npm.

## Pipeline

Each script serves its fixture through Vite, measures actual DOM nodes, and
writes one raw file to `reference/heroui_3_2_6/chromium/`.

| Script | Fixture | Raw output | Covers |
| --- | --- | --- | --- |
| `generate.mjs` (`npm run generate`) | `fixture.*`, `index.html` | `measurements.json`, `tokens.json` | Every theme token resolved to sRGB (`tokens.json`, checked by `check.dart`); Button, Chip, Card, TextField, Popover; custom accent and radius overrides |
| `capture_foundation.mjs` | `foundation.*` | `foundation.json` | Avatar, Badge, Surface, Separator, Typography, Kbd, Skeleton, Spinner, Link, CloseButton, ButtonGroup |
| `capture_selection.mjs` | `selection.*` | `selection.json` | Checkbox, Radio, Switch and their groups |
| `capture_toggles.mjs` | `toggles.*` | `toggles.json` | ToggleButton, ToggleButtonGroup |
| `capture_editors.mjs` | `editors.*` | `editors.json` | InputGroup, TextArea, SearchField |
| `capture_families2.mjs` | `families2.*` | `families2.json` | Tooltip, Modal, Accordion, Disclosure, Slider, Toast, Alert, ProgressBar, Meter, Table |
| `capture_tabs.mjs`, `capture_select.mjs`, `capture_menu.mjs`, `capture_dropdown.mjs` | `tabs.*`, `select.*`, `menu.*`, `dropdown.*` | `*_visual.json` | Tabs, Select, Menu, Dropdown: slots per state, mode, and width |
| `capture_breadcrumbs.mjs` | `breadcrumbs.*` | `breadcrumbs_visual.json` | Breadcrumbs item rects and list gap, at rest and with keyboard focus |

The matrix captures (`generate`, `foundation`, `selection`, `toggles`,
`editors`, `families2`) record light and dark at 375, 640, 768, and 1024 CSS
pixels as `modes.<mode>.viewports.<width>.<case id>`, with interaction states
(hover, pressed, focus, drag) under `modes.<mode>.states.<case id>`. A case is
`{tag, text, rect, styles, attributes}`; case ids read
`<family>-<variant>-<size|state>[-<slot>]`. A pseudo-element is its own case
with the same shape.

`families2` renders every overlay at a 768 CSS pixel high viewport, the height
`pumpHeroUi` uses, so dialog placement, `cover`, and `full` are directly
comparable. In its output `rect.x` and `rect.y` are viewport coordinates for
Modal and Toast and offsets from the trigger for Tooltip. `modes.<mode>.probes`
holds pixel columns sampled from screenshots (the table header/body boundary).

## `slim_measurements.dart`

`dart run tool/heroui_parity/slim_measurements.dart` (from `registry_source`)
merges the raw files into `reference/heroui_3_2_6/measurements.json`, the only
file recipe tests read:

- keeps the shipped families (`_families`), viewports 375 and 1024 (375 lists
  only cases that differ from 1024), and the geometry and paint styles in
  `_styles`, plus `_familyStyles` for families that need more;
- keeps `x`/`y` only for `_positioned` families;
- omits CSS initial values and writes one case per line so diffs stay reviewable.

To add a family, add its capture file to the matrix list and its id prefix to
`_families`, rerun the capture, then rerun the tool. `meter` is captured by
`families2` but left out of `measurements.json` because every Meter value
equals the matching ProgressBar case.

## Flutter comparison

`open_code/heroui_fixture/capture.mjs` captures the installed gallery for a
side-by-side review; see that fixture's README. Upstream screenshots from the
scripts here go to `out/`, which is not committed.
