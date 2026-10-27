# 0002 — A reference design over Remix components

Status: accepted.

## Decision

HeroUI is a Remix design system in the shape the design-system skill
prescribes, and the reference others copy. It adds HeroUI's design
decisions to Remix; Remix keeps rendering, interaction, focus, semantics, and
loading/disabled behavior.

- Each component is a `@MixWidget(target: Remix<X>.new)` recipe returning the
  target's styler, with HeroUI `variant`/`size` enums, token-only styling, and
  the caller's `style` merged last.
- Where Remix has no widget, a stateless composition of Remix widgets and Mix
  primitives fills in (Kbd, Surface, Typography, groups, Breadcrumbs).
- HeroUI's React API and React Aria behavior are not ported: pending maps to
  Remix `loading`, controlled/uncontrolled pairs to Remix's single value, and
  validation stays with the app: text fields use Remix's `error`, other
  controls a recipe `invalid` flag, both painting the error treatment.
- Families that need behavior Remix lacks are deferred, for example Form,
  NumberField, InputOTP, ComboBox, and a standalone Menu (`RemixMenu` always has
  a trigger). `reference/heroui_3_2_6/families.json` lists every upstream family
  with its mapping or its reason.

## Family map

| HeroUI | Remix target |
| --- | --- |
| Button, CloseButton | `RemixButton`, `RemixIconButton` |
| Chip, Badge | `RemixBadge` (Badge composes it as an anchored label) |
| Card, Avatar, Link, Separator | `RemixCard`, `RemixAvatar`, `RemixLink`, `RemixDivider` |
| Spinner, Skeleton, ProgressBar | `RemixSpinner`, `RemixSkeleton`, `RemixProgress` |
| TextField, TextArea, SearchField, InputGroup | `RemixTextField` (leading/trailing) |
| Checkbox(+Group), Radio(+Group), Switch | `RemixCheckbox`, `RemixCheckboxGroupItem`, `RemixRadio`, `RemixSwitch` |
| ToggleButton(+Group) | `RemixToggle`, `RemixToggleGroup` |
| Tabs | `RemixTabBar`, `RemixTab`, `RemixTabView` (inside `RemixTabs`) |
| Popover, Tooltip, Select, Dropdown, Modal | `RemixPopover`, `RemixTooltip`, `RemixSelect`, `RemixMenu`, `RemixDialog` |
| Accordion, Disclosure, Slider, Toast, Alert, Table | `RemixAccordion`, `RemixDisclosure`, `RemixSlider`, `RemixToast`, `RemixCallout`, `RemixDataTable` |

## Shared-library decisions

Default: no change to Naked UI or Remix. A general API needs all of: (a) the
gap is visual and styling or composition cannot express it, (b) every preset
benefits, (c) it follows Remix's part-builder or styler conventions, and (d)
it is additive, tested, and documented, shipped as its own reviewed change.

| Gap found while prototyping | Today | Verdict |
| --- | --- | --- |
| `TabStyler`, `ToggleStyler`, `ToggleGroupItemStyler`, `SelectMenuItemStyler`, `MenuItemStyler`, `MenuTriggerStyler`, `TooltipStyler`, and the accordion and disclosure trigger slots have no `containerEffects`, so focus rings cannot be outlines and token shadows cannot apply | The focus ring is an outline effect (`heroUiFocusRing()`) on those parts, so focus takes no layout space; toggle group items and the surface accordion, whose parent clips, draw it inside (`ring-inset`). Surface shadow on tabs and toggles is still plain box shadows | Passes (a)–(d); Vanilla and Fortal hit the same gap. Shipped as a separate Remix change: `containerEffects` on those stylers and a `triggerEffects` slot on accordion and disclosure (their `containerEffects` covers the whole panel), adopted here. Tooltip is not focusable and was left out. |
| HeroUI's spinner fades a full ring; Remix draws an arc | Remix arc on the same ring geometry | Defer: shape polish, fails (b) until another preset needs a custom spinner. |
| HeroUI's check mark draws in | Remix check glyph; `checkedIcon` can swap it | Defer: motion polish, fails (b). |
| HeroUI's skeleton shimmer | Remix's pulse | Defer: motion polish, fails (b). |
| A select popover at least as wide as its trigger | The select content takes `remixAnchorWidth()` as its `minWidth`, the port of `min-w-(--trigger-width)` | Passes (a)–(d): Radix and shadcn selects size content to the trigger too; the select overlay already receives the trigger's rect. Shipped as a separate Remix change, a context token the recipe reads as `minWidth`, adopted here. |
| Radio and switch labels | `HeroUiRadio` and `HeroUiSwitch` pass `label`, so the label is inside the tap target; only the description beneath it is composed | Passes (a)–(d): `label` and `labelSpacing` on `RemixRadio` and `RemixSwitch`, as `RemixCheckbox` has. Shipped as a separate Remix change, adopted here. |
| A widget as the dropdown trigger | A `HeroUiButton` is the trigger through `RemixMenuTrigger.control`; the recipe's trigger style stays for label and builder triggers (`.dropdown__trigger`) | Passes (a)–(d): `RemixMenuTrigger.builder` must stay non-interactive, because `NakedMenu` wraps it in its own button. A control trigger hands the builder the menu's focus node and toggle, so a styled button is the trigger while Naked UI keeps focus return, expanded semantics, and the overlay. Shipped as a separate Naked UI (`NakedMenu.openOnTap`) and Remix change, adopted here. |
| A Button opening a popover | `RemixPopover(openOnTap: false)` with a `MenuController`; the Button opens it from `onPressed` and shares one `FocusNode` with the popover's `triggerFocusNode` | No gap in Remix. A shared node keeps the Button the only tab stop and returns focus to it on close (a Naked UI fix shipped with the control trigger). |

None was required for the preset to ship, so it first shipped with the
approximations those rows describe. The proposals above landed as separate
changes in Remix 1.0.0-beta.14 and naked_ui 1.3.0, and the preset now uses them.

## Approximations

Recorded per component in `specs/heroui/components/`. Across the preset:
style transitions animate whatever the OS motion setting (as in Vanilla and
Fortal), because Mix's `.animate` does not read it yet (btwld/mix#1070); CSS shadow blur is passed to Flutter's `blurRadius` (as in Fortal), so
shadows render slightly softer; the platform font replaces the browser's
system stack; motion such as the sliding tab indicator is not reproduced.
