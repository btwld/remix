# Interface accessibility contract

Use actual native HTML buttons and label the action. The inner icon is usually decorative: hide it with `aria-hidden="true"` and remove a redundant accessible title/role. The ES-module helper emits decorative SVG by default. A nonempty `title` creates a named standalone symbol with escaped text.

Favorite is the guide's actual toggle. Its accessible name stays stable and `aria-pressed` changes. Other samples report a preview action; they do not pretend to perform a file operation or expose false toggle state.

Default sample controls are at least 44 px high. Icon size and control size are separate. Maintain visible keyboard focus on every surface; the guide uses the foreground color on icon cards, including cobalt. No hover-only information is required. Native dialog behavior provides Escape and focus handling.

Status meaning should include labels and shape, not color alone. Keep visible labels with Warning, Focus, Branch, and small Help. Actual application contrast depends on its colors and adjacent surfaces. Do not infer a full WCAG audit from icon geometry tests.

Literal arrows, media symbols, and glyph artwork do not automatically mirror under RTL. The application selects a left/right glyph when navigation semantics require it. No screen-reader or localized workflow study was performed in this pass.

See W3C's button pattern and non-text contrast guidance in `SOURCES.md`. This document is an implementation contract, not certification.


## Forced colors

Selected controls use the system `Highlight` fill with `CanvasText` as the
foreground fallback and `contrast-color(Highlight)` where supported. SVGs inherit
the control foreground. Normal controls use `ButtonFace` / `ButtonText`.
The scoped `forced-color-adjust` rule protects paired selected controls, not the
whole page. Verify winning computed foregrounds, focus, and keyboard state under
forced light and dark schemes. Emulation is not physical Windows contrast-theme
or screen-reader certification.

## Warning usage

Do not restate a size-specific exception here. The current authoritative rule
is in `catalog/restrictions.json`, rendered into `docs/usage-restrictions.md`,
the catalog, the inspector, and `getIconUsage`. A visible label is required in
both appearances at every supported master and their scaled uses.
