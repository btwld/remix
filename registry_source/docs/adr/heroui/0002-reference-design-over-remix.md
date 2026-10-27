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
| `TabStyler`, `ToggleStyler`, `ToggleGroupItemStyler`, `SelectMenuItemStyler`, `MenuItemStyler`, `MenuTriggerStyler`, `TooltipStyler`, and the accordion and disclosure trigger slots have no `containerEffects`, so focus rings cannot be outlines and token shadows cannot apply | An always-present transparent 2px inside border recolored on focus; surface shadow as plain box shadows | Passes (a)–(d); Vanilla and Fortal hit the same gap. Proposed as a separate Remix change: `containerEffects` on those stylers and a `triggerEffects` slot on accordion and disclosure (their `containerEffects` already covers the whole panel). Tooltip is not focusable and is left out. HeroUI keeps the border until it ships. |
| HeroUI's spinner fades a full ring; Remix draws an arc | Remix arc on the same ring geometry | Defer: shape polish, fails (b) until another preset needs a custom spinner. |
| HeroUI's check mark draws in | Remix check glyph; `checkedIcon` can swap it | Defer: motion polish, fails (b). |
| HeroUI's skeleton shimmer | Remix's pulse | Defer: motion polish, fails (b). |
| A select popover at least as wide as its trigger | Remix sizes the popover to its content | Passes (a)–(d): Radix and shadcn selects size content to the trigger too; the select overlay already receives the trigger's rect, so Remix can expose its width to the content style (for example a context token the recipe reads as `minWidth`). Proposed as a separate Remix change. |
| Radio and switch labels | A composed label beside the bare control; the label is not a tap target | Passes (a)–(d): `label` and `labelSpacing` on `RemixRadio` and `RemixSwitch`, as `RemixCheckbox` has. Proposed as a separate Remix change. |
| A widget as the dropdown trigger | `RemixMenu` draws its own trigger button; HeroUI's trigger is a label inside it | Passes (a)–(d): `RemixMenuTrigger.builder` exists but must stay non-interactive, because `NakedMenu` wraps it in its own button. A control trigger that hands the builder the menu's focus node and toggle lets a styled button be the trigger while Naked UI keeps focus return, expanded semantics, and the overlay; it needs a `NakedMenu` mode that does not add its own button, as `NakedPopover` already has. Proposed as a separate Naked UI and Remix change. |
| A Button opening a popover | `RemixPopover(openOnTap: false)` with a `MenuController`; the Button opens it from `onPressed` | No gap: no shared change needed. `RemixMenu` draws its own trigger button, so a dropdown trigger is a label, not a Button. |

None is required for the preset to ship, so this change leaves Naked UI and
Remix untouched.

## Approximations

Recorded per component in `specs/heroui/components/`. Across the preset:
style transitions animate whatever the OS motion setting (as in Vanilla and
Fortal); CSS shadow blur is passed to Flutter's `blurRadius` (as in Fortal), so
shadows render slightly softer; the platform font replaces the browser's
system stack; motion such as the sliding tab indicator is not reproduced.

## Adoption revision — 2026-10-27

The shared-library table above is the 2026-10-19 decision and stays as decided.
The proposals it records now exist as separate changes to Remix and Naked UI
(labels on radio and switch, the anchor width token, `containerEffects` and
`triggerEffects`, and a control trigger for `RemixMenu`, with the Naked UI
`NakedMenu.openOnTap` and popover focus changes under it). They come from the
follow-up pull requests on btwld/remix and ship with the next Remix beta and
naked_ui 1.3.0; the HeroUI registry's Remix floor moves with that release, and
this preset needs it. The preset adopts them and four recorded approximations
go away:

| Approximation above | Now |
| --- | --- |
| An always-present transparent 2px inside border recolored on focus (tabs, toggles, toggle group items, select and menu rows, the menu trigger, accordion and disclosure triggers) | `heroUiFocusRing()` through `containerEffects` and `triggerEffects`: the measured background gap, then the 2px ring, drawn outside the part and taking no layout space. Padding no longer subtracts the ring width. The selected tab's surface shadow is `containerEffects(heroUiSurfaceEffects())` instead of plain box shadows, so it follows `--surface-shadow` (none in dark), combines with the ring, and matches upstream |
| The select popover as wide as its content | `SelectContentStyler().minWidth(remixAnchorWidth())`, the port of `min-w-(--trigger-width)` |
| Labels composed beside bare radios and switches, outside the tap target | `HeroUiRadio` and `HeroUiSwitch` pass `label`, inside the one tap target. `HeroUiControlRow` becomes `HeroUiDescribedControl`, which lays out only the description beneath the label |
| A label-only dropdown trigger inside Remix's own button | A `HeroUiButton` through `RemixMenuTrigger.control`; label and builder triggers keep the bare `.dropdown__trigger` look |

The Button-opening-a-popover row's verdict, "No gap: no shared change needed.",
still holds for the popover. Its reason, that a dropdown trigger is a label and
not a Button, is superseded by the control trigger above. The preset now
documents sharing one `FocusNode` as the popover's `triggerFocusNode` and the
button's `focusNode`, so the button is the only tab stop and takes focus back
on close.

What differs from upstream after the move, with its attribution:

- A ring is an outline an enclosing clip can crop. Toggle group items draw it
  inside the item, as `toggle-button-group.css` does (`ring-inset`). The surface
  accordion's trigger also draws it inside, but that is an approximation:
  `accordion.css` has no `ring-inset`, and its card clips an outside ring. The
  card's rounded clip then crops even the inside ring at its outer corners
  (`accordion.yaml`).
- The toast stacks its action under the message at 768px and below
  (`actionPlacement`) with `mt-2` below 640px. From 640 to 768 upstream has no
  margin and Remix keeps the container spacing (`toast.yaml`).
- Style transitions still animate whatever the OS motion setting: Mix 2.3.1's
  `.animate` does not read reduced motion. Remix's own select, accordion,
  spinner, and dialog motion honors it.

This supersedes five rows of the table: for the four above, the "Today" cell
and the verdict's "proposed as a separate change" and "HeroUI keeps the border
until it ships"; for the popover row, its reason. It also supersedes the
sentence that this change leaves Naked UI and Remix untouched. The spinner,
check mark, and skeleton verdicts and the family map are unchanged.
