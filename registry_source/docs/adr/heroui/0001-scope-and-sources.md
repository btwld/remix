# 0001 — Sources, naming, and theme model

Status: accepted. Scope and the component model are in
[0002](0002-reference-design-over-remix.md).

## Sources and precedence

1. Published `@heroui/react` and `@heroui/styles` **3.2.6** (npm integrity in
   `reference/heroui_3_2_6/sources.json`), provenance commit
   `e385ac202b2cdb94b1bf6fa76d32c31c8259cc5e`.
2. The pinned compiled CSS (`reference/heroui_3_2_6/source/dist`).
3. Chromium measurements of the real upstream components
   (`reference/heroui_3_2_6/measurements.json`, `chromium/tokens.json`).
4. Flutter tests, which never produce upstream expected values.

Package metadata says MIT while the repository's `LICENSE` is Apache-2.0. The
Apache text is retained in `reference/heroui_3_2_6/LICENSE.upstream` and
`theme/license.dart`; no affiliation with HeroUI is implied.

## Naming

Preset slug `heroui`; authoring words `HeroUi` / `heroUi`, rendered as the
consumer's prefix. Variant and size enums keep HeroUI's names. Dart-reserved
or hyphenated values are translated explicitly: `default` becomes
`defaultColor`/`defaultCard`, `danger-soft` becomes `dangerSoft`.

## Theme

HeroUI's semantic color roles (accent, default, surface, overlay, field, and
the status colors) are kept; numbered scales are not introduced. Light and
dark ship. The full variable inventory is `specs/heroui/tokens.json`.

HeroUI themes by overriding CSS variables; derived colors follow through
`color-mix`. `HeroUiThemeData.colors` keeps that model: an override replaces
one variable and every color derived from it recomputes. OKLCH values are
converted with the published OKLab matrices to extended sRGB without 8-bit
quantization; `color-mix(in oklab)` normalizes weights, premultiplies alpha,
and applies the alpha multiplier when weights sum below 100%. Paint values are
handed to Mix as channel-clipped sRGB, because `Color.lerp` rejects extended
sRGB. This is not CSS perceptual gamut mapping.

Units: rem = 16px; Tailwind `sm` = 640px and `md` = 768px. Mobile-first
responsive values map to Mix `onBreakpoint(Breakpoint.minWidth(...))`.

## Fonts

HeroUI uses the platform system font stack, so the preset leaves
`fontFamily` null (platform default) and lets apps supply one. Code text uses
Geist Mono from `remix_ui_fonts`, because CanvasKit does not resolve the CSS
`monospace` generic; this is a fixed-width approximation, not upstream's font.
