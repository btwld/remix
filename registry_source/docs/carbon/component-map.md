# Carbon registry component map

This is the source of truth for Carbon item names after the initial slice.
Implementations are lifted from repository commit `606bfbb36` under
`packages/remix_carbon/lib/src/components/` and adapted to the current Remix
API. The [runbook](runbook.md) controls ownership, sequencing, and verification.

The registry item name is the argument to `remix add` and should match an
existing default/Fortal item when the concept aligns. Authoring types use the
`Carbide` prefix. File names use the item name, not the historical `carbon_*`
name.

## Waves 1–2 — vertical slice and foundation

| Item | Historical family | Remix target | Strategy | Delivery |
| --- | --- | --- | --- | --- |
| `theme` | foundation + tokens | `MixScope` | shared item | Wave 1: real white/Gray 10 button tokens; Wave 2: pinned full foundation and four themes |
| `button` | `button` (`CarbonButton`) | `RemixButton` | Remix recipe | Wave 1: fixed 48 px; Wave 2 restores optional contextual sizing |

## Wave 3a — independent recipes

| Item | Historical family / types | Remix target | Notes |
| --- | --- | --- | --- |
| `checkbox` | `checkbox` | `RemixCheckbox` plus group item | Group root is behavioral and is imported from Remix. |
| `radio` | `radio_button` | `RemixRadio` | `RemixRadioGroup` is not a registry item. |
| `slider` | `slider` | `RemixSlider` | |
| `tooltip` | `tooltip` | `RemixTooltip` | |
| `popover` | `popover` | `RemixPopover` | |
| `spinner` | `loading` | `RemixSpinner` | |
| `progress` | `progress_bar` | `RemixProgress` | |

## Wave 3b — grouped and input recipes

| Item | Historical family / types | Remix target | Notes |
| --- | --- | --- | --- |
| `accordion` | `accordion` | `RemixAccordion` | Group root is behavioral. |
| `tabs` | `tabs` | `RemixTabBar`, `RemixTab`, `RemixTabView` | `RemixTabs` has no style. |
| `menu` | `menu` | `RemixMenu` | Adapt to current root-variant behavior. |
| `textfield` | `text_input` (`TextInput`, `TextArea`, `PasswordInput`) | `RemixTextField`, `RemixTextArea` | One registry item may contain multiple generated widgets, as in Fortal. |
| `switch` | `toggle` | `RemixSwitch` | Carbon's “Toggle” maps to the shared `switch` item. |

## Wave 3c — button extension

| Item | Historical family | Remix target | Notes |
| --- | --- | --- | --- |
| `base_button` | shared button metrics, if a split is required | none | Add only if `icon_button` needs it; the Integrator owns the shared/file item registration. |
| `icon_button` | `CarbonIconButton` in `button` | `RemixIconButton` | Depends on `theme` and, only if introduced, `base_button`. |

## Wave 3d — adapters

| Item | Historical family | Remix target | Notes |
| --- | --- | --- | --- |
| `dialog` | `modal` | `RemixDialog` | |
| `select` | `select` | `RemixSelect` | |
| `callout` | `notification` | `RemixCallout` | |
| `badge` | `tag` | `RemixBadge` | Carbon vocabulary can remain in the Dart API where appropriate. |
| `card` | `tile` | `RemixCard`, possibly `RemixDisclosure` | Prefer one item even if implementation needs multiple files. |
| `link` | `link` | `RemixLink` | May be non-generated, as in Fortal. |

## Wave 3e — composites and mapped extras

| Item | Historical family | Remix target | Notes |
| --- | --- | --- | --- |
| `segmented_control` | `content_switcher` | `RemixSegmentedControl` | |
| `search` | `search` | `RemixTextField` | Composite. |
| `data_table` | `data_table` | `RemixDataTable` | May depend on `checkbox`, `icon_button`, and `select`. |

Defer `ai_label`, `inline_loading`, `menu_button`, `toggletip`, and
`number_input` unless another component requires them. They introduce unique
catalog names and therefore need consumer-documentation updates. Prefer
composition from installed items over unnecessary new items.

## Wave 4 — Carbon-native items

These names are new to the shared catalog. Update catalog documentation in the
same change. Use plain application-owned widgets unless a current Remix anatomy
genuinely matches.

| Item | Historical family | Generated Mix widget? |
| --- | --- | --- |
| `breadcrumb` | `breadcrumb` | No |
| `date_picker` | `date_picker` | No |
| `tree_view` | `tree_view` | No |
| `pagination` | `pagination` | No |
| `file_uploader` | `file_uploader` | No |
| `code_snippet` | `code_snippet` | No |
| `contained_list` | `contained_list` | No |
| `structured_list` | `structured_list` | No |
| `list` | `list` | No |
| `form` | `form` | No |
| `multiselect` | `multiselect` | No |
| `progress_indicator` | `progress_indicator` | No |
| `dropdown` | `dropdown` | Only if demonstrably distinct from `select` |
| `ui_shell` | `ui_shell` | Grouped recipe |

## Wave 5 — separately contracted packages

| Item | Historical family | Notes |
| --- | --- | --- |
| `chart` | `bar_chart`, `line_chart`, `pie_chart` | One item, as in Fortal; requires an explicit chart dependency contract. |
| `icons` | generated `CarbonIcons` font | Application alias plus a separately reviewed hosted icon package. Do not restore `packages/remix_carbon`. |

## Explicit exclusions

The historical Carbon comparison matrix did not define Carbon equivalents for
Remix-only Avatar, Badge-as-Remix, Card-as-Remix, Data List, Divider, Skeleton,
Toggle Button, or Toggle Group. Carbon uses Tag, Tile, Contained List, Content
Switcher, and other system-specific concepts instead. Do not add Remix-only
families merely to mirror Fortal's catalog.

Carbon v1–4 also does not copy Fortal-only `typography`, `text`, `heading`,
`kbd`, `code`, `avatar`, `skeleton`, `divider`, `toggle`, `toggle_group`,
`sidebar`, `sidebar_layout`, dashboard items, or Agent surfaces. Add one later
only with a product reason and an executable contract.
