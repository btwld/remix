# Changelog

## 0.0.1

Initial pre-1.0 foundation release.

### Added

- **Deterministic token pipeline** (`tool/`) that extracts, normalizes, generates
  and verifies Carbon design tokens from the pinned official `@carbon/*` npm
  packages. Regeneration from the source lock is byte-identical (CI-enforced).
  - `@carbon/themes` 11.76.0, `@carbon/colors` 11.53.0, `@carbon/layout` 11.54.0,
    `@carbon/type` 11.62.0, `@carbon/motion` 11.47.0.
  - Carbon repo commit `b288a66af010622bedc6de4d6d0b81ee3c9f5520`.
- **Generated tokens** (`lib/src/tokens/generated/`): 246-color primitive palette,
  234 color roles × 4 themes, 78 component tokens (fallbacks and partial-theme
  omissions preserved), 13-step spacing, control/container/icon sizes, fixed and
  fluid typography, motion durations and easing curves, and a provenance manifest.
- **Foundation runtime**: `CarbonScope` / `CarbonTheme` (White, Gray 10, Gray 90,
  Gray 100), `CarbonLayer` contextual layer model, `CarbonLayoutScope`
  (`CarbonSize`, `CarbonDensity`), `CarbonType` fluid resolver, `CarbonMotion`
  reduced-motion helpers, and typed theme overrides.
- **Carbon Button** vertical slice: seven kinds (primary, secondary, tertiary,
  ghost, danger, danger-tertiary, danger-ghost), the Carbon size scale, and
  hover/pressed/focus/disabled/loading states, implemented as a hand-written
  facade over Remix's button machinery.
- Package scaffolding, example gallery, tests, and the token-pipeline ADR.
