# Remix 1.0 Freeze — Feedback & Adjustment Checklist

**Branch:** `chore/1.0-release` (PR #63)  
**Generated:** 2026-07-08  
**Verified:** 2026-07-08 (full code audit — every item checked against tree; no assumptions)  
**Method:** Multi-agent review → independent verification against lib, docs, tests, lockfile, naked_ui, Material Tooltip

This document lists every item to resolve before tagging `1.0.0`. Breaking changes are expected — the goal is **zero API drift** (one rule per concept, documented and enforced).

**Verification tags:**

| Tag | Meaning |
|-----|---------|
| **CONFIRMED** | Claim true; action still needed or decision required |
| **WRONG** | Original claim false; do not implement as stated |
| **PARTIAL** | Half-right; severity or fix adjusted |
| **OVERSTATED** | Real pattern, but impact smaller than claimed |
| **PRODUCT** | Decision, not a bug |
| **MISSED** | Found during verification; not in original review |

---

## Executive summary

PR #63 is directionally correct (Fortal function API, nullable callbacks, docs rewrite, generator migration) but **standardization is half-finished**. Highest-risk gaps after verification:

1. **Two real functional bugs** — menu trigger icon order; Fortal TextField disabled color (surface + soft `Colors.red`)
2. **Tooltip is NOT a mapping bug** — `showDuration`→`touchDelay` matches Material; fix docs / optional `dismissDelay` exposure
3. **`styleSpec` has three shapes** — `StyleSpec<T>?`, raw `RemixXSpec?`, or absent — button uses a custom `StyleWidget` state path
4. **Color APIs are legitimately different per family** — do not flatten; document and fix only true bugs
5. **`skills/remix-skill/` is entirely stale** — teaches fictional `FortalXStyle.solid()` APIs
6. **Release blockers** — `mix_generator` git override; `naked_ui` beta on stable `1.0.0`
7. **Naming freeze (D1)** — **`RemixXStylerr`** everywhere for Mix alignment (1.0 not shipped yet; ignore interim CHANGELOG Style rename)

---

## Freeze decisions (pick once, apply everywhere)

| # | Decision | Options | Recommendation (verified) | Status |
|---|----------|---------|---------------------------|--------|
| D1 | Component builder naming | `RemixXStylerr` (current) vs `RemixXStylerr` (Mix) | **`RemixXStylerr`** — match Mix; rename all + `fortalXStylerr()` before tag. 1.0 not released — do **not** treat interim CHANGELOG Style rename as freeze | **DECIDED** |
| D2 | Widget `style` param name | `style:` vs `styler:` | **Keep `style:`** (Mix `StyleWidget` convention) | **PRODUCT** |
| D3 | `styleSpec` public type | `StyleSpec<T>?` everywhere vs raw `RemixXSpec?` for interactive widgets | **Pick one or document split**; three tiers confirmed in code | **CONFIRMED** |
| D4 | Button/icon-button architecture | `StyleWidget` + custom state vs `RemixStyleSpecBuilder` | **Align both** (icon-button model is simpler) | **CONFIRMED** |
| D5 | Overlay positioning | `OverlayPositionConfig` vs select anchors | **Unify on `OverlayPositionConfig`**; select has no `offset` | **CONFIRMED** |
| D6 | Disable semantics | Fold null callback into `enabled` at Remix layer | **Optional align for clarity** — NakedToggle/Checkbox/Slider already fold `enabled && onChanged != null` | **OVERSTATED** |
| D7 | Fortal widget coverage | 16/21 have `FortalX` | **Add or document exclusions** for dialog, menu, select, tabs, tooltip | **CONFIRMED** |
| D8 | `call()` on all styles | CHANGELOG claims all | **Add to 8 missing classes or amend CHANGELOG** (not 7) | **CONFIRMED** |

---

## P0 — Must fix before 1.0 tag

### Bugs (behavior ≠ documented API)

- [ ] **Menu trigger icon order contradicts API** · **CONFIRMED**  
  - File: `packages/remix/lib/src/components/menu/menu_widget.dart:263-267`  
  - Docs (`RemixMenuTrigger`): icon is leading / before label  
  - Code renders **label then icon** (trailing in LTR)  
  - Select trigger correctly does icon → label (`select_widget.dart:349-350`)  
  - Fix: swap to icon → label **or** rename field to `trailingIcon` and fix dartdoc if chevron-trailing is intentional  
  - Update demo if needed

- [ ] **Fortal TextField disabled state sets wrong paint target** · **CONFIRMED**  
  - File: `packages/remix/lib/src/components/textfield/fortal_textfield_styles.dart:90-99`  
  - `.color(FortalTokens.colorSurface())` on `RemixTextFieldStyler` where `.color()` = **editable text**, not background  
  - Fix: use `.backgroundColor(FortalTokens.colorSurface())`  
  - Confirmed: `textfield_style.dart` `color()` → text `TextStyler`; `backgroundColor()` → container fill

- [ ] **Fortal soft TextField disabled uses `Colors.red`** · **MISSED**  
  - File: `packages/remix/lib/src/components/textfield/fortal_textfield_styles.dart:130`  
  - `.onDisabled(RemixTextFieldStyler(text: TextStyler().color(Colors.red)))`  
  - Looks like a debug leftover — replace with proper disabled tokens

- [ ] **Tooltip duration — docs / unmapped dismiss, NOT Material remapping** · **WRONG as original; corrected action**  
  - File: `packages/remix/lib/src/components/tooltip/tooltip_widget.dart:47-48`  
  - **Current mapping is Material-correct:**  
    - `waitDuration` → `hoverDelay`  
    - `showDuration` → `touchDelay` (time visible after long-press release)  
  - Flutter `material/tooltip.dart` uses the same `showDuration→touchDelay`, `waitDuration→hoverDelay` wiring  
  - NakedTooltip also has `dismissDelay` (mouse-exit hide delay) — **Remix never sets it**  
  - Docs (`tooltip.mdx`): `showDuration` described as “before hiding” — misleading  
  - **Do not** remap `showDuration` → `dismissDelay`  
  - Fix: (1) correct docs to match Material semantics; (2) optionally expose `dismissDuration`/`dismissDelay`; (3) add real timing tests (hover/exit/long-press)

### Release blockers

- [ ] **Remove `mix_generator` git override before publish** · **CONFIRMED**  
  - File: `pubspec_overrides.yaml` (pins `btwld/mix.git@fix/mix-widget-generic-call`)  
  - Lock: `mix` **2.1.0** from pub.dev; `mix_generator` **2.1.2** from git override  
  - Merge/release Mix PR, publish generator, delete override, re-run `dart analyze` + `build_runner` + tests

- [ ] **`naked_ui: ^1.0.0-beta.1` on package version 1.0.0** · **CONFIRMED**  
  - File: `packages/remix/pubspec.yaml`  
  - Decide: wait for stable `naked_ui` 1.0 **or** ship `1.0.0-rc.1` / document beta dep in CHANGELOG + README

- [ ] **Rewrite `skills/remix-skill/` to match real 1.0 API** · **CONFIRMED**  
  - Files: `skills/remix-skill/SKILL.md`, `references/fortal-reference.md`, `references/components.md`  
  - Still teaches `FortalButtonStyle.solid()`, fictional Fortal classes  
  - Claims “20 components”; toggle not documented as real component  
  - `enableHapticFeedback` in components.md (real API: `enableFeedback`)  
  - Fabricated context variants `.onDark()` / `.onMobile()` etc. — **not** in remix lib  
  - Replace with `fortalXStylerr({variant, size})` + `FortalX` widgets; or **exclude skill from release branch**

### API structural blockers

- [ ] **Resolve `RemixButtonStyler extends MixStyler` drift** · **CONFIRMED**  
  - File: `packages/remix/lib/src/components/button/button_style.dart:9`  
  - Every other component uses `RemixStyler` / `RemixContainerStyler` / `RemixFlexContainerStyler`  
  - Fix: migrate button to `RemixFlexContainerStyler` (mirror icon-button) **or** document permanent exception in CHANGELOG

- [ ] **Resolve button custom `styleSpec` / widget state path** · **CONFIRMED**  
  - File: `packages/remix/lib/src/components/button/button_widget.dart:177,256-283`  
  - `RemixButton` extends `StyleWidget` but overrides `createState` with manual `StyleSpecBuilder`/`StyleBuilder`  
  - `RemixIconButton` uses `RemixStyleSpecBuilder` + raw `RemixIconButtonSpec?`  
  - Fix: align on one integration pattern (see D4)

- [ ] **Document or unify `styleSpec` three-tier split** · **CONFIRMED**  
  - **Tier A** `StyleSpec<T>?` via `StyleWidget`: button, avatar, badge, card, callout, divider, progress, spinner  
  - **Tier B** raw `RemixXSpec?` via `RemixStyleSpecBuilder`: checkbox, switch, slider, tooltip, radio, toggle, textfield, icon_button  
  - **Tier C** absent on public widget: accordion, dialog, menu, select, tabs  
  - Add package overview + CHANGELOG note; fix skills `components.md` types

---

## P1 — High priority (fix in PR or immediate follow-up)

### Naming & API consistency

- [ ] **Styler vs Style freeze (D1)** · **DECIDED: `RemixXStylerr`**  
  - Rename all 21 components to `RemixXStylerr`, `fortalXStylerr()`, base classes (`RemixStyler` / container styler bases), files, docs, tests, demos, skills  
  - Reverse interim `RemixButtonStyler` / `RemixXStylerr` naming on this branch before tag  
  - **Do not re-litigate:** Mix alignment wins; 1.0 is not shipped so CHANGELOG Style rename is not a freeze

- [ ] **`RemixRadio.enableFeedback` not forwarded to `NakedRadio`** · **CONFIRMED**  
  - File: `packages/remix/lib/src/components/radio/radio_widget.dart:40,72,110-117`  
  - Field exists on widget; omitted in naked call  
  - Existing test only pumps with `enableFeedback: false` and asserts widget exists — does not check naked

- [ ] **Disabled semantics inconsistent (D6)** · **OVERSTATED**  
  - Button/icon-button: `_isEnabled = enabled && !loading && onPressed != null` ✓  
  - Switch/toggle: gate `onChanged`, pass raw `enabled` to naked  
  - Checkbox: same  
  - Slider: passes raw `onChanged` + `enabled` (naked folds)  
  - Select: passes raw `onChanged` + `enabled`; `enabled: false` tested; **`onChanged: null` untested**  
  - NakedToggle / NakedCheckbox / NakedSlider: `_effectiveEnabled => enabled && onChanged != null`  
  - Fix (optional): fold at Remix layer for readability + `widgetControllerTest` for omitted callback → `WidgetState.disabled` where missing  
  - **Not a must-fix for correct disabled behavior on naked-backed controls**

- [ ] **Unify select overlay positioning (D5)** · **CONFIRMED**  
  - Menu/tooltip: `positioning: OverlayPositionConfig`  
  - Select: `targetAnchor` + `followerAnchor` only (no offset)  
  - Fix: add `positioning` param; deprecate anchor pair

- [ ] **Select trigger naming drift** · **PARTIAL**  
  - Menu: `RemixMenuTrigger.label`  
  - Select: `RemixSelectTrigger.placeholder` (used when no selection)  
  - Prefer **document intentional difference** over rename to `label` (placeholder is the right concept)

- [ ] **Select menu item style uses `text` not `label`** · **PARTIAL**  
  - File: `packages/remix/lib/src/components/select/select_style.dart:232,270-274`  
  - Field `$text`; `label()` already delegates to `text()`  
  - Fix: rename field to `label` for parity **or** document alias

- [ ] **`call()` missing on 8 style classes (D8)** · **CONFIRMED** (count was 7; is 8)  
  - Missing: `RemixAccordionStyler`, `RemixMenuStyler`, `RemixMenuTriggerStyler`, `RemixMenuItemStyler`, `RemixRadioStyler`, `RemixSelectStyler`, `RemixSelectTriggerStyler`, `RemixSelectMenuItemStyler`  
  - Present on all other major styles including dialog, tooltip, tabs parts  
  - Add `call()` or amend CHANGELOG line (“all” → “most”)

- [ ] **Generated `FortalX` widgets missing for 5 components (D7)** · **CONFIRMED**  
  - No `@MixWidget` on: dialog, menu, select, tabs, tooltip  
  - 16 components generate `FortalX` widgets  
  - Add `@MixWidget()` or document why excluded

### Color API (document families — do NOT flatten)

Color methods mean different things by component family. **Freeze per family, not globally.** Verified against style method bodies.

#### Family A — Dual-tone surfaces (`backgroundColor` + `foregroundColor`)

Components: avatar, callout, badge, button, icon-button, toggle

| Rule | Status |
|------|--------|
| Canonical pair: `backgroundColor()` + `foregroundColor()` | **CONFIRMED** where present |
| `color()` = container fill (mixin or override) | Badge/card via `DecorationStyleMixin` when `decoration()` implemented; button/avatar/icon-button/callout explicit |
| `labelColor` / `iconColor` mixins remain escape hatch | Document |

- [ ] Document Family A in package README or `docs/index.mdx`

#### Family B — Surface/chrome only

Components: card, dialog, tooltip, divider

| Rule | Status |
|------|--------|
| `backgroundColor()` / `color()` = surface | **CONFIRMED** |
| Foreground via nested `TextStyler` on slots | **CONFIRMED** |

- [ ] No forced `foregroundColor` on dialog/tooltip unless adding mixin

#### Family C — Input (inverted semantics)

Component: **textfield only**

| Method | Meaning | Status |
|--------|---------|--------|
| `color()` | **Editable text color** (NOT background) | **CONFIRMED** |
| `backgroundColor()` | Container fill | **CONFIRMED** |

- [ ] **P0 doc prominence:** TextField `.color()` is opposite of every other component — migration guide + `textfield.mdx` callout
- [ ] Consider `textColor()` alias delegating to `color()` (non-breaking, P2)

#### Family D — Multi-part controls

Components: checkbox, radio, switch, slider, progress, spinner

| Rule | Status |
|------|--------|
| Part names: `fillColor`, `thumbColor`, `trackColor`, `indicatorColor`, etc. | **CONFIRMED** |
| Do NOT add `foregroundColor` | **CONFIRMED** |
| `indicatorColor`: checkbox = checkmark icon; radio = inner dot `Box` | **CONFIRMED** |

- [ ] Document checkbox vs radio `indicatorColor` divergence; consider `checkmarkColor`/`dotColor` in 2.0

#### Family E — Multi-slot composites

Components: accordion, menu, tabs, select sub-styles

| Rule | Status |
|------|--------|
| Slot-specific helpers where present | **CONFIRMED** for accordion (`titleColor`, `contentColor`, icon colors) |
| Menu/select items have `labelColor` / `iconColor` | **WRONG** — only `label()` / `leadingIcon()` stylers; no those color helpers |
| Accordion `contentColor` = content panel **background** | **CONFIRMED** (method comment already says so; name still misleading) |

#### Color fixes checklist

- [ ] Fix Fortal TextField disabled `.color()` → `.backgroundColor()` · **CONFIRMED**
- [ ] Fix soft Fortal TextField `Colors.red` disabled · **MISSED**
- [ ] Document checkbox vs radio `indicatorColor` divergence · **CONFIRMED**
- [ ] Document accordion `contentColor` = background (or rename) · **CONFIRMED**
- [ ] Add per-component color semantics table to CHANGELOG or docs · **CONFIRMED** as gap
- [ ] P2: `backgroundColor()` alias on menu trigger, tab, select trigger (delegate to `color()`) · optional
- [ ] P2: optional `foregroundColor()` on menu trigger, tab, select trigger · optional

### Docs accuracy

- [ ] **Callout Fortal examples mislabel variants** · **CONFIRMED** — `docs/components/callout.mdx:77-91`  
  "Information/Success/Warning" mapped to `surface/soft/outline`

- [ ] **Incomplete Fortal variant coverage in docs** · **CONFIRMED**  
  - Badge: docs solid/soft; API has surface/outline  
  - Card: docs classic/surface; API also has ghost

- [ ] **Hallucinated API in source dartdoc** · **CONFIRMED**  
  - `menu_widget.dart:101` — `FortalMenuTheme.menu` does not exist; use `fortalMenuStyler()`

- [ ] **README typo** · **CONFIRMED** — "create a fully customizable **using**" in `README.md`, `packages/remix/README.md`, `docs/index.mdx`

- [ ] ~~**StackBox reference**~~ · **WRONG** as issue  
  - `StackBox` exists in Mix 2.1.0 — keep reference

- [ ] **README duplication** · **PARTIAL**  
  - root README ≡ package README (identical MD5)  
  - `docs/index.mdx` is **not** byte-identical (differs)  
  - Still worth diverging workspace vs pub.dev READMEs

- [ ] **Expand CHANGELOG breaking entries** · **CONFIRMED** as gap  
  - Fortal class → function migration  
  - `styleSpec` two/three shapes  
  - Tooltip duration semantics (Material-aligned; document clearly)  
  - Per-component color renames where applicable

### Tests

- [ ] **Add `styleSpec` widget test for `RemixButton`** · **CONFIRMED** — no `styleSpec` coverage in button tests  
- [ ] **Add `styleSpec` tests for badge, callout, card** · **CONFIRMED** — none  
- [ ] **Replace shallow tooltip duration tests** · **CONFIRMED** — `tooltip_widget_test.dart` duration group only `findsOneWidget`  
- [ ] **Tooltip positioning test** · **CONFIRMED** — only param equality, not overlay placement  
- [ ] **Null-callback disabled tests** · **PARTIAL**  
  - Switch/toggle already have “omitted onChanged disables interaction”  
  - Checkbox has null `onChanged` pump test  
  - Button has `widgetControllerTest` for omitted `onPressed` → `WidgetState.disabled`  
  - Gap: match button’s **widgetControllerTest** for omitted callback on switch/toggle/checkbox where missing; add select `onChanged: null`  
- [ ] **Assert `enableFeedback` forwarding** · **PARTIAL**  
  - Button/toggle assert naked `enableFeedback`  
  - Radio/switch/slider/checkbox/icon-button mostly shallow “accepts param”  
  - Radio cannot forward until P0 field fix  
- [ ] **Strengthen shallow `styleSpec` tests** · **CONFIRMED** — progress/divider/avatar/spinner mostly existence  
- [ ] **Review `styleMethodTest` helper** · **CONFIRMED** — encourages shallow style tests (`findsOneWidget`)

### Tooling

- [ ] **`analysis_options.yaml` TODOs** · **CONFIRMED** — `deprecated_member_use: ignore`, `public_member_api_docs: false`  
- [ ] **`docs.json` copyright** · **CONFIRMED** — still © 2024  

---

## P2 — Polish (non-blocking but reduces drift)

### Docs quality / AI slop

- [ ] **Trim accordion Style Methods boilerplate** · **CONFIRMED** — ~145 lines under Style Methods in `accordion.mdx`  
- [ ] **Systemic Style Methods sections** · **CONFIRMED** as quality issue (generated wrap/modifier noise)  
- [ ] **Document `styleSpec` type split** — package overview  
- [ ] **Document generated `FortalX` widgets** · **CONFIRMED** gap — docs only show `fortalXStylerr()`  
- [ ] **Document `styleFrom` static** · **CONFIRMED** — missing on `RemixDivider` only  
- [ ] **State variant guidance** — inconsistent across pages (not every page re-audited line-by-line)  
- [ ] **Dialog docs formatting** · **CONFIRMED** — mixed `->` and `→` in property headings  

### API polish

- [ ] **`RemixDivider` missing `styleFrom`** · **CONFIRMED**  
- [ ] ~~**Slider `onChangeStart` may pass stale value**~~ · **WRONG** as bug  
  - `onDragStart: () => onChangeStart?.call(value)` is value **at drag start** — Material-style semantics  
- [ ] **Menu vs select overlay animation** · **CONFIRMED** — menu static; select has `AnimationController` / `_AnimatedOverlayMenu`  
- [ ] **mix_generator duplicate `wrap()`/`modifier()`** · **CONFIRMED** in generated mixins  
- [ ] **`@Deprecated` typedef aliases** in `*.g.dart` · **CONFIRMED**  
- [ ] **Fortal paramless functions** · **CONFIRMED** — `fortalDialogStyler()`, `fortalTooltipStyler()`, `fortalTabStyler()` vs `{variant, size}` elsewhere  
- [ ] **`fortalTabStyler()` scopes to `RemixTab` only** · **CONFIRMED**  
- [ ] **Callout `text` vs `label`** · **CONFIRMED** — callout uses `text`, button uses `label`  
- [ ] **Avatar/Badge text→label** · **PARTIAL** — CHANGELOG renamed; styles use `label()`  
- [ ] **pub.dev `screenshots:`** · **CONFIRMED** missing from `packages/remix/pubspec.yaml`  

### Packaging

- [ ] **`packages/remix/scripts/README.md`** · **CONFIRMED** — documents `labelTextStyle()`; real mixin method is `labelStyle()`  
- [ ] **Consider diverging root README from package README** · product  

---

## Verified clean (no action needed)

- 21/21 component doc pages exist; dialog + toggle in `docs.json` (21 component hrefs)
- Docs site uses `fortalXStylerr({variant, size})` — not fictional Fortal classes
- Apps/docs currently use `RemixButtonStyler` consistently — will need full rename to `RemixButtonStyler` per D1 before tag
- `RemixMenuStyler.item()` merge fix works; covered by tests (`applies menu-level default item style`)
- `mix: ^2.1.0` resolves from pub (runtime OK; only generator overridden)
- `remix_theme.dart` export removed (no theme dir under package)
- Card docs no longer use `.textColor()` on `RemixCardStyler`
- Slider docs use `enableFeedback`
- Tooltip `positioning` param exists and is documented
- `release-please-config.json` exists; workflows present
- `meta` in `packages/remix` dev_dependencies
- Example, demo, playground use current Style naming + `fortalButtonStyler()` — update to Styler + `fortalButtonStyler()` with D1
- StackBox references are valid (Mix 2.1.0)

---

## Color semantics quick reference (freeze as-is unless noted)

| Component | `color()` means | `backgroundColor` | `foregroundColor` | Part-specific |
|-----------|-----------------|-------------------|-------------------|---------------|
| Avatar | container | ✓ alias | label + icon | labelColor, iconColor (mixins) |
| Callout | bg alias | ✓ | icon + text | iconColor, textColor |
| Badge | container (DecorationStyleMixin) | ✓ | label only | labelColor |
| Button | container | ✓ alias | label + icon | via mixins |
| IconButton | container | ✓ alias | icon only | iconColor |
| Toggle | container (via methods) | ✓ | label + icon | mixins |
| Card | container (mixin) | ✓ alias → color | — | nested TextStyler |
| Dialog | bg alias | ✓ | — | title/description stylers |
| Tooltip | container | ✓ alias | — | label TextStyler |
| Divider | line color | — | — | — |
| **TextField** | **TEXT color** | ✓ fill | — | hintColor, cursorColor |
| Checkbox | — | — | — | fillColor, indicatorColor (icon) |
| Radio | — | — | — | fillColor, indicatorColor (dot Box) |
| Switch | track (via decoration/trackColor) | — | — | thumbColor, trackColor |
| Slider | thumb | — | — | thumbColor, trackColor, rangeColor |
| Progress | — | — | — | trackColor, indicatorColor |
| Spinner | — | — | — | trackColor, indicatorColor |
| Accordion | trigger bg | ✓ trigger | — | titleColor, contentColor (=bg!) |
| Menu/Select items | item bg via `color()` where present | — | — | `label()` / icon stylers — **not** labelColor/iconColor helpers |

---

## Suggested execution order

1. **Fix real P0 bugs** — menu icon order; Fortal textfield disabled (surface + soft red)
2. **Tooltip** — fix docs + optional dismiss API + timing tests (**do not** remap to `dismissDelay`)
3. **Lock freeze decisions D1–D8** — **apply `RemixXStylerr` rename (D1)**; document styleSpec (D3)
4. **Remove mix_generator override** — after Mix PR merge
5. **Rewrite or exclude `skills/remix-skill/`**
6. **Structural alignment** — button/icon-button pattern, `call()` gaps, radio enableFeedback
7. **Document color families A–E** — CHANGELOG + docs; do not rename working part APIs
8. **Tests** — button styleSpec, tooltip timing, deepen enableFeedback / null-callback controller tests
9. **Docs polish** — callout examples, CHANGELOG completeness, README typo
10. **Tag `1.0.0`** (or `1.0.0-rc.1` if naked_ui still beta)

---

## Verification log (what was checked)

| Area | How verified |
|------|----------------|
| Tooltip mapping | Remix widget + naked_ui `NakedTooltip` + Flutter Material `tooltip.dart` |
| Menu / select layout | widget build children order + dartdoc |
| TextField color semantics | `color()` / `backgroundColor()` method bodies + Fortal styles |
| styleSpec tiers | constructor `styleSpec` type scan of all `*_widget.dart` |
| `call()` | presence scan of all `Remix*Styler` classes |
| FortalX | `@MixWidget` count vs generated `class Fortal*` |
| D6 / enableFeedback | widget naked calls + naked package `_effectiveEnabled` |
| Overlay API | select/menu/tooltip params |
| Color table | method body extraction per `*_style.dart` |
| Docs claims | mdx + enum variants in fortal files |
| Tests | ripgrep of widget tests for styleSpec / duration / feedback / null callback |
| Release | `pubspec.yaml`, `pubspec_overrides.yaml`, `pubspec.lock` |
| Skills | grep for Fortal classes / onDark / component count |
| Verified clean | docs.json, CHANGELOG, example/demo/playground greps |

---

## Agent review sources

| Agent focus | Key output |
|-------------|------------|
| API naming & structure | Styler/Style, styleSpec tiers, Fortal/skills drift, call()/FortalX gaps |
| Color semantics | Families A–E, TextField inversion, indicatorColor overload, Fortal color bugs |
| Interactive behavior | enabled/callbacks, overlay positioning, tooltip/menu bugs, radio enableFeedback |
| Docs/tests/release | skills stale, test gaps, release overrides, doc slop |
| Verification pass | Corrected tooltip claim; D6 overstated; soft textfield red; table/menu labelColor; StackBox; slider onChangeStart |

---

*End of feedback document. Check items off as resolved; do not tag 1.0 until all P0 items are closed or explicitly accepted with documented rationale. Prefer CONFIRMED/MISSED actions; ignore WRONG rows; treat OVERSTATED as optional polish.*
