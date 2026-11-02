# Porting a reference web design system

Use this when the target is an existing web library (HeroUI, Radix Themes,
shadcn) and looking like it is the requirement. A port reproduces the
library's **design decisions** on Remix: tokens, geometry, variants, sizes,
states, and modes. Behavior and widget parameters stay Remix's, so the same
Remix API works under every preset's styles.

## 1. Scope the port to Remix

- Pin the web product, major version, exact packages, and source commit in one
  manifest. Do not mix a v2 theme, v3 docs, and a similarly named native
  library.
- Inventory upstream families and map each to a Remix widget by role:
  **recipe** (`@MixWidget(target: Remix<X>.new)`), **composition** (Remix
  widgets and Mix primitives in a stateless facade), or **deferred**: the
  family needs behavior or state Remix does not provide and composition cannot
  supply (form engines, text-editing state machines, collection or date
  logic). The inventory records coverage; it is not a backlog.
- Map upstream concepts onto Remix rather than copying them. A pending button
  is `loading`; an `isSelected`/`defaultSelected` pair becomes the single
  value and `onChanged` Remix already exposes; compound children become Remix
  parameters. Do not port React prop shapes, form engines, or interaction
  policies.

## 2. Extend in this order

When styling seems unable to express a design decision:

1. **Style it.** Most gaps close with a Remix styler field, variant, or
   `containerEffects`. Read the component's `*Styler` before concluding.
2. **Compose it** in the preset from Remix widgets and Mix primitives. A
   composition owns no gestures, focus, keyboard, or semantics.
3. **Propose a general Remix API** only when the gap is visual, would recur
   for other presets, and fits Remix's part-builder convention
   (`<part>Builder(context, <Part>Spec, …)`). It is additive, tested, and
   documented: a separate, reviewed change to the shared library, recorded in
   `ARCHITECTURE.md`, never a preset-specific flag.
4. **Approximate or defer**, and record the difference in the worksheet.

Never change existing shared behavior to match a web library.

## 3. Evidence for appearance

- Extract tokens from the pinned stylesheet with its real pipeline (compile
  Tailwind `@apply`, resolve `var`, `calc`, `color-mix`, OKLCH). Record the
  sRGB conversion and rounding policy; see `tokens.md`.
- Capture resolved values from rendered upstream components: colors, padding,
  heights, radii, borders, font size and weight, shadows. Cover both modes,
  each variant and size, the visual states (hover, pressed, focus-visible,
  disabled, selected, invalid), and both sides of any breakpoint the source
  defines. Record root size, viewport, browser, and fonts.
- Never derive the expected values from the Flutter implementation.
- Keep the evidence small: tokens and measurements for the components in
  scope, plus the pinned CSS. Interaction recordings are not needed because
  behavior is Remix's.

## 4. Acceptance

- The token test matches the extracted values.
- Recipe tests assert measured geometry per size and breakpoint, every
  variant × size × mode builds, the focus ring does not shift layout, and
  disabled/loading visuals match the worksheet.
- A side-by-side capture of the installed gallery and the upstream fixture is
  reviewed by a person.
- Worksheets list every approximation (fonts, shadow kernels, motion).
- Every shipped item installs in a fresh consumer with a non-authoring prefix.
