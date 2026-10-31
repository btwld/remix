# Vanilla Reference

Rules for the Vanilla preset that are easy to get wrong from a widget's name
alone. Vanilla is the `remix_cli` default: a neutral, minimal theme inspired
by shadcn/ui, editable the same way as Fortal. For
install commands, scope placement, and the preset chooser, see the
[main skill](../SKILL.md).

## Tokens

`<Prefix>Tokens` follows shadcn/ui's theme variable names (`card-foreground`
is `cardForeground`), so values from those themes carry over:

The installed `theme/tokens.dart` owns the full catalog: semantic colors,
radius/text steps, sidebar roles and chart colors. `colors`, `radii`,
`textStyles` and `chart` enumerate token groups.

`<Prefix>ThemeData` stores one `radius` (10); the four radius steps derive
from it (6, 8, 10, 14), so `copyWith(radius: ...)` rounds everything. Controls
use `radiusMd`, dialogs and callouts `radiusLg`, cards `radiusXl`, menu rows
`radiusSm`. The text steps carry the family, size, and line height only; set
weight and color in the recipe. `fontFamily` and `monoFontFamily` default to
Geist and Geist Mono from `remix_ui_fonts`, which `theme` adds to your
`dependencies`. Set `fontFamily` to null in the constructors (`copyWith`
cannot clear it) to leave the family to the platform; a null `monoFontFamily`
uses `fontFamily`.

`accent` is the interaction surface for otherwise transparent controls (the
hovered ghost button, the highlighted menu row, the toggle that is on), not a
brand hue. In the shipped themes it is the same gray as `muted`. Set a brand
color with `copyWith(primary: ...)`, and give it to `ring` too if focus rings
should follow.

`mutedForeground` clears 4.5:1 on `muted` as well as on `background` (the
light theme sets it at `#707070` for this), so muted text may sit on a muted
surface.

The dark theme's `destructive` is a light red: it reads as text on the page
but cannot carry white text as a solid fill, so recipes paint dark
destructive fills at 60%.

## Scales and helpers

`theme/tokens.dart` also holds the fixed scales as constants on `<Prefix>Tokens`:
spacing (`s0_5` through `s16`, a 4px grid), sizes (`controlSm`/`controlMd`/`controlLg`
32/36/40, icon sizes, panel widths, `pill`), strokes (`strokeHairline`,
`strokeIndicator`, `strokeRing`), `disabledOpacity`, and `motion` (150ms,
`Curves.fastOutSlowIn`). Spacing is deliberately not a token.

`theme/effects.dart` holds the shared helpers:

- `<prefix>Tint(token, alpha, {dark})`: a token at a fraction of its own
  opacity. Use it instead of
  `Tokens.x().withValues(...)`, which records a directive that survives
  later merges.
- `<prefix>ByBrightness(light:, dark:)`: one token in the light theme and
  another in the dark.
- `<Prefix>Shadow.xs` to `.lg`: the shadow scale, as `.box` for a
  styler's `shadows` or `.effects` for a `containerEffects` layer.
- `<prefix>FocusRing()`, `<prefix>FocusRingDecoration()`, and
  `<prefix>FocusBorder()`: the 3px `ring` band at half strength, and a
  bordered control's outline turned `ring`.

## Theme scope

The outermost `<Prefix>Theme` paints the theme's `background` and gives
bare `Text` the body run (`textSm` in `foreground`) and bare `Icon`s the
`foreground` color. Place it inside the host's `builder`, below `MaterialApp`
or `WidgetsApp`, so the host's own text defaults do not sit between the two.
A Material widget below the scope (`Scaffold`, `Material`, `Card`) sets its
own text style from the host's `ThemeData`, so give that `ThemeData` the
scope's brightness, or style that text with the theme's tokens. A
nested `<Prefix>Theme` re-scopes tokens; if its theme has a different `foreground` (a
region shown in the other brightness), it also recolors text and icons below
it, but it never paints a background.

## Theme values

`<Prefix>ThemeData.light()`/`.dark()` are the named constructors;
`copyWith(...)` derives a changed theme. Read the active theme with
`<Prefix>Theme.of(context)` or `<Prefix>Theme.maybeOf(context)`.

## Components

The installed recipe's enums in `lib/ui/components/<name>.dart` are
authoritative for a component's variants and sizes; do not assume Fortal's
families carry over.

- **Button** — `<Prefix>ButtonVariant { primary, secondary, outline, ghost,
  destructive }`; `<Prefix>ButtonSize { small, medium, large }` (32/36/40px).
  Every size sets its label in `textSm`. There is no pressed step: a press
  lands on the hover fill.
- **Toggle** — on is `accent` with `accentForeground`; a ghost toggle hovers
  onto `muted` with `mutedForeground`. There is no selected border.
- **Tabs** — compose `RemixTabs` (the behavioral root) with `<Prefix>TabBar`,
  `<Prefix>Tab`, and `<Prefix>TabView`. `<Prefix>TabsVariant { filled, line }`:
  `filled` (the default) is a recessed pill list, `line` an underline.
  Pass the same variant to the bar and to each tab.
- **Toast** — style lives on the scope:
  `RemixToastScope(style: uiToastStyle(), child: ...)`. A per-toast
  `RemixToastData.style` (for example `uiToastStyle(variant: .destructive)`)
  merges over it. `<Prefix>ToastVariant { neutral, destructive }`.
- **AppBar** — `VanillaAppBar` (`<Prefix>AppBar`) provides no variants or sizes.
  Its toolbar row height is 64px (`VanillaTokens.s16`, exposed as
  `<prefix>AppBarToolbarHeight`), which includes the bottom hairline border.
  Use this constant to align adjacent headers such as a sidebar brand row.
- **SidebarLayout** — `VanillaSidebarLayout` (`<Prefix>SidebarLayout`) defaults to
  a `collapsedWidth` of 48. In contrast, `VanillaDashboardShell`
  (`<Prefix>DashboardShell`) defaults to 72.
- **Chart** — the palette is a gray ramp. Pie labels are off by
  default; when you turn them on, color each slice's label with
  `<prefix>PieSliceLabelColor(context, sliceColor)`.

## Styling with tokens

Use [Styling](styling.md#styling-with-installed-tokens) for token call forms,
`.mix()` and `.resolve(context)`; the same mechanics apply to both presets.

## Updating an older install

If installed targets have no recorded owner, first complete
[legacy adoption](cli.md#projects-from-an-earlier-prerelease) and commit
`remix.ownership.json` with configuration and source.

A theme installed before the current token set names `focusRing` and a single
`radius` token. `--overwrite` replaces only the items named, so reinstall the
theme together with every installed Vanilla item in one command (check
`--diff` first on any you have edited); an item left out still reads the old
names and stops compiling. Then rename `focusRing` to `ring` in your own code,
replace `Tokens.radius` with a step (`radiusMd` for controls), and give a
hand-built `ThemeData` the new required colors (`card`, `popover`, `input`,
`ring`, and the `sidebar*` set), or start from `.light().copyWith(...)`.
