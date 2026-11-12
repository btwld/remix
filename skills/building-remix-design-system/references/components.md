# Theme and components reference

The shapes a registry's installed source takes, and the Remix and Mix
behaviors that have produced real bugs. The sketches use the authoring word
`Acme` and agree with each other; the official Vanilla preset is the complete
reference
([theme](https://github.com/btwld/remix/tree/registry-stable/registry/vanilla/templates/theme),
[button](https://github.com/btwld/remix/blob/registry-stable/registry/vanilla/templates/button/button.dart.tmpl)).

## 1. Theme item

Three files at the least, installed together as the `theme` item. Vanilla
adds fixed scales directly on `<Prefix>Tokens` in `tokens.dart` (spacing,
sizes, strokes, opacity, and motion as plain constants) and a fourth file,
`effects.dart` (tints, shadows, and the focus ring every
control draws). Anything a recipe needs from the theme belongs in the item, so
a component never imports another component to get it.

**`tokens.dart` — token identities and fixed scale constants.** A Mix token names
an environment-dependent value; the active `MixScope` supplies it. A fixed scale
is a plain `const` beside the token identities: it needs no scope lookup and
supports arithmetic. Token IDs use the value word so they render per consumer.

```dart
import 'package:remix/remix.dart';

abstract final class AcmeTokens {
  // Fixed scale constants.
  static const s1 = 4.0;
  static const s2 = 8.0;
  static const s4 = 16.0;
  static const strokeIndicator = 2.0;
  static const disabledOpacity = 0.5;
  static const motion = CurveAnimationConfig.fastOutSlowIn(
    Duration(milliseconds: 150),
  );

  // Mix token identities.
  static const background = ColorToken('acme.color.background');
  static const text = ColorToken('acme.color.text');
  static const interactivePrimary = ColorToken(
    'acme.color.interactive-primary',
  );
  static const onInteractive = ColorToken('acme.color.on-interactive');
  static const hoverSurface = ColorToken('acme.color.hover-surface');
  static const pressedSurface = ColorToken('acme.color.pressed-surface');
  static const focus = ColorToken('acme.color.focus');
  static const radius = RadiusToken('acme.radius');
}
```

**`theme_data.dart` — values per mode.** An immutable class with one field per
token, `const` named constructors per mode, `copyWith`, value equality over
every field, and a `tokens` getter returning an unmodifiable
`Map<MixToken<Object?>, Object>`. Every token needs an entry: a recipe that
resolves a token missing from the active scope throws at runtime. Mix tokens
override `==`, so a `const` map keyed by them does not compile; build it at
runtime.

Use the analyzed [Vanilla theme data](https://github.com/btwld/remix/blob/main/registry_source/lib/src/default/theme/theme_data.dart)
for the complete constructor/copy/equality pattern. Map every token to a value;
keep fixed scales as constants rather than scope lookups.

**`theme_scope.dart` — installation.** Match Vanilla's contract so consumers
set up every Remix design system the same way:

- `AcmeTheme({theme, darkTheme, mode, child})`. `mode` selects between
  the pair; `system` reads `MediaQuery.maybePlatformBrightnessOf`, and a scope
  mounted above any `MediaQuery` supplies one with `MediaQuery.fromView`.
  Detect that case with
  `context.getElementForInheritedWidgetOfExactType<MediaQuery>()`, which does
  not subscribe; `MediaQuery.maybeOf` would rebuild the scope on every
  MediaQuery change. An empty nested scope inherits the parent's pair and
  selection.
- It installs a private `_AcmeInheritedTheme` (an `InheritedTheme`) and
  `MixScope(tokens: selected.tokens, child: child)` together.
- `AcmeTheme.of(context)` throws a `FlutterError` naming the missing scope;
  `AcmeTheme.maybeOf(context)` returns null. Provide both: only `maybeOf` can
  tell "no scope" from "scope chose its default".
- The outermost scope sets the page up: it paints the theme's background and
  installs a root `DefaultTextStyle` in the body text and foreground, so a bare
  `Text` reads correctly in every mode. A nested scope re-scopes tokens and,
  when its foreground differs, recolors the inherited text run; it never
  repaints the background or replaces the rest of the run.
- `_AcmeInheritedTheme.wrap` rebuilds the `MixScope` as well as itself (see §3).
- `updateShouldNotify` compares every carried field; this is why theme data
  needs value equality.
- Consumers place the scope inside `WidgetsApp.builder`, above the Navigator.
  Document that in the README.

Add a token only with its value in every mode; add a mode only if the source
defines it. A single-mode system ships one constructor, and its scope falls
back to that theme for both slots; say in the README that `mode` has no
visible effect.

## 2. Recipes

A component is a top-level recipe function annotated with
`@MixWidget(target: Remix<Component>.new)`. The generator emits
`<Prefix><Component>` into the file's `.g.dart` part: a widget whose
constructor is the recipe's parameters plus the Remix widget's parameters,
and whose `build` calls the Remix widget with the resolved style.

Recipe outline (the analyzed [Vanilla button](https://github.com/btwld/remix/blob/main/registry_source/lib/src/default/components/button.dart)
owns the complete implementation):

<!-- dart-excerpt: recipe shape; helpers and theme imports are in the linked source -->

```dart
@MixWidget(target: RemixButton.new)
ButtonStyler acmeButtonStyle({
  AcmeButtonVariant variant = .primary,
  AcmeButtonSize size = .medium,
  bool loading = false,
  ButtonStyler style = const ButtonStyler.create(),
}) => _base(size)
    .merge(_variantStyle(variant))
    .onFocusVisible(_focusRing())
    .onDisabled(loading ? _loading() : _disabled())
    .merge(style);
```

Keep `part 'button.g.dart'`, enum definitions and helpers in the authored file.
`_focusRing` and the derived-fill pattern are illustrated in §3.

- **Return the target's own styler type**: `RemixButton` takes a
  `ButtonStyler`, `RemixBadge` a `BadgeStyler`. A styler's methods are in the
  `remix` package source, `lib/src/components/<name>/<name>.g.dart` (find the
  package root in `.dart_tool/package_config.json`); read them there instead
  of guessing.
- **Naming**: `lib/components/<name>.dart` holds `acme<Component>Style` and
  `part '<name>.g.dart'`; the generated widget is `Acme<Component>`. File
  names never contain the authoring word.
- **Variants**: keep the parameter named `variant` so the generator emits
  named constructors, and put the system's vocabulary in the enum:
  `AcmeBadgeTone { neutral, info }` gives `AcmeBadge.info(...)`. Size names
  come from the source; if it has none, record the chosen names in the visual spec.
- Merge the caller's `style` **last** so one call site can override anything
  without forking the recipe.
- Style only through tokens: `AcmeTokens.x()` inside styler chains,
  `AcmeTokens.x.resolve(context)` in widget code. A copied value "kept in
  sync" with a token is drift waiting to happen.
- Vanilla does not cache recipe results; add a cache only when profiling
  shows the recipe is a cost.
- Display components (badge, card, callout) need only tokens, variants, and
  geometry; the state pitfalls in §3 apply to interactive components.

### Readable source

Installed source is the product: the consumer owns it, reads it, and edits it.
Write each recipe so a reader who opens that one file learns the component.
The [Vanilla button](https://github.com/btwld/remix/blob/main/registry_source/lib/src/default/components/button.dart)
is the reference for a variant × size recipe and the
[Fortal button](https://github.com/btwld/remix/blob/main/registry_source/lib/src/fortal/components/button.dart)
for one that adds a `highContrast` axis.

- **The recipe function is the table of contents.** It merges, in order,
  what every instance shares, the size, the variant, focus, disabled, then the
  caller's `style`. Helpers follow in the order it names them.
- **A variant is one chain that names every state it changes.** Rest, hover,
  press and disabled sit together in styler calls, so one screen answers
  "what does a pressed outline button look like".

<!-- dart-excerpt: one variant; tokens and helpers are in the linked source -->

```dart
ButtonStyler _soft() => _content(AcmeTokens.accentText())
    .color(AcmeTokens.accentA3())
    .onHovered(.color(AcmeTokens.accentA4()))
    .onPressed(.color(AcmeTokens.accentA5()))
    .onDisabled(_disabledContent().color(AcmeTokens.grayA3()));
```

- **Express state in stylers.** A styler already is the description of a
  state. A data object holding `foreground`/`background`/`effects` that a
  second function translates back into styler calls is a second style system
  for the reader to learn.
- **One recipe, one file; restate what two components share.** Button and
  IconButton each write out their variants, so each reads and edits alone.
  Keep the pair equal with a test that resolves both and compares (§5). A
  shared file is for computed logic only, such as color arithmetic, and is its
  own catalog item.
- **One enum per public choice.** A mirror enum joined by a `.solid => .solid`
  switch exists for the code's sake, not the reader's.
- **A helper removes repetition inside the file without hiding a value.**
  `_content(color)`, which paints label, icon and spinner, earns its name; a
  helper that only forwards its arguments does not.
- **Start a chain with the concrete styler; use dot shorthand for a one-call
  fragment** (`.onHovered(.color(x))`). A fragment with several calls starts
  with the styler too, so the formatter breaks it one call per line.
- **A doc comment says what the code cannot.** The design intent, the pixel
  value behind a token, or the Mix or Remix behavior that makes a line
  necessary, in a line or two. Leave out history, a defense of the
  implementation, and a restatement of the next line.
- **Ship only live code.** Remove ignored parameters, deprecated aliases and
  helpers nothing calls before a recipe is published.

The `mix` skill's code-generation reference owns the rest of the `@MixWidget`
contract (`name`, `widgetParameters`, `factoryParameters`, generic targets).
Install it with `npx skills add btwld/mix --skill mix`; without it, read
`mix_widget_generator.dart` in the `mix_generator` package source.

**Curate parameters with `widgetParameters`** before reaching for a
hand-written facade. A facade over an existing Remix widget is the exception:
record why in the owning visual contract, build the recipe inside it, and keep
Remix's parameter names and shapes. Reference ports never adopt upstream prop
shapes (`isSelected`/`defaultSelected`, compound children).

**No Remix widget for the component.** Compose existing Remix widgets and Mix
primitives (`Box`, `FlexBox`, `StyledText`, all re-exported by `remix`) in a
stateless facade. If the family needs behavior composition cannot supply,
defer it. A third-party registry that must ship such a widget can declare
`naked_ui` or author a `@MixableSpec(target: ...)` spec; document the consumer
build configuration and any significant boundary decision in the existing log.
First-party presets and reference ports compose or defer.

Map upstream families to Remix widgets by role, not name: a label-like Chip
fits `RemixBadge`, while an anchored notification Badge is a composition.
See [Reference ports](reference-parity.md) §1–2.

## 3. Pitfalls

Each of these has produced a real bug.

**Loading is the disabled state.** `RemixButton` passes
`enabled: enabled && !loading` to its Naked UI button, so `.onDisabled`
styles loading too. If the system's loading button keeps its variant visuals,
declare `bool loading = false` on the recipe and branch the disabled fragment
on it. With `target: RemixButton.new`, a recipe parameter with the same name
and type as a target parameter becomes one widget field passed to both, so
the recipe and `RemixButton` always agree. A different type for the same name
fails generation.

Map an upstream pending or busy state onto `loading`. Its focus and semantics
are Remix's; do not rebuild the upstream contract in a facade.

**Focus rings: outline effects, not borders.** `.onFocused(.border(...))`
replaces the variant's border and shifts layout by the border width. Paint the
ring outside the box on keyboard focus only; `onFocusVisible` hides it after a
pointer press until the next keyboard input:

<!-- dart-excerpt: continuation of components/button.dart -->

```dart
ButtonStyler _focusRing() => ButtonStyler().containerEffects(
  .outline(
    .color(
      AcmeTokens.focus(),
    ).width(2.0).strokeAlign(BorderSide.strokeAlignInside),
  ).outlineOffset(2.0),
);
```

Text inputs ring on any focus, as browsers do, so key their ring on
`onFocused` instead.

Tab, toggle, toggle group item, select menu item, menu item, and menu trigger
take `containerEffects` like a button, and so does a sidebar destination, which
is a toggle. Accordion and disclosure take `triggerEffects`, because their
`containerEffects` wraps the revealed content too. A toggle group styled with
`clipBehavior` (every shipped preset sets one) clips its items, and so can a
select, menu, accordion, or disclosure container, or a bounded sidebar's scroll
region; a ring outside the part is cropped at that edge. Items also paint in order, so
a filled item after the focused one covers that side of an outside ring. Draw it
inside with a negative `outlineOffset` equal to the ring width, or pad the
clipping container by the offset plus the width. Padding does not help once a
select or menu list scrolls: the scroll view clips at its own edges, inside the
panel's padding, so draw row rings inside.

**Derived colors: `ContextToken`, not `withValues`.**
`AcmeTokens.interactivePrimary().withValues(alpha: 0.9)` records a Mix directive that
survives every later merge, so a caller who replaces the hover fill still gets
the alpha on top. Resolve the arithmetic instead, as top-level finals
(`ContextToken` equality is resolver identity):

<!-- dart-excerpt: continuation of components/button.dart -->

```dart
ContextToken<Color> _dimmed(ColorToken source, double alpha) =>
    ContextToken<Color>(
      (context) => source.resolve(context).withValues(alpha: alpha),
    );

final _primaryHoverFill = _dimmed(AcmeTokens.interactivePrimary, 0.9);
final _primaryPressedFill = _dimmed(AcmeTokens.interactivePrimary, 0.8);
```

A helper that caches its tokens by argument, as Vanilla's `vanillaTint` does,
returns the same token for the same arguments. Call it where the color is used
(`vanillaTint(VanillaTokens.primary, 0.9)()`) so the variant reads in one place.

**State fragments merge by state and keep their first position.** Mix merges
every fragment declared for one state into the place that state was first
declared: `.onDisabled(a).onFocusVisible(f).onDisabled(b)` resolves as
disabled (`a` and `b`), then focus. Among active states the later position
wins, but only on the properties both set; a Mix value such as an outline
merges field by field.

- Declare each state once, in priority order: hover, press, focus, then
  disabled, so disabled wins.
- A caller override that must beat the recipe's hover fill must itself be an
  `.onHovered(...)` fragment. It changes that fragment's properties, never its
  position.
- Clear the focus ring of a disabled control with
  `.onDisabled(.containerEffects(.outline(.style(.none))))`. It switches the
  outline's style off whatever color and width the focus fragment sets, so it
  holds from any position.
- In a calendar, declare `CalendarDayStyler.onRangeStart`, `onRangeMiddle`,
  `onRangeEnd`, `onRangeSingle` and `onRangePreview` after `onSelected` in the
  preset's base style. Range variants apply only to `RemixRangeCalendar`.

**A state that changes the foreground sets it in hover and in press.** When a
hover fill needs a different label, icon, and spinner color, repeat those
colors in the press fragment. Touch devices never report hover, so a press
fragment with the fill alone paints the pressed surface under the rest
foreground. A variant whose foreground is the same in every state sets it once
at rest.

**Icon placement is style-driven.** `ButtonStyler().iconAlignment(RemixPlacement.end)`
moves a single icon, whichever slot the caller used; with both icons, Remix
keeps leading → label → trailing. Test both if the system specifies placement.

**`RemixButton` prepends `.mainAxisSize(.min)`.** Alignment only matters when
the parent forces a width; set it for that case and leave the min default.

**`InheritedTheme.wrap` must rebuild the `MixScope`.** Routes and overlays
capture `InheritedTheme`s only. A `wrap` that rebuilds just the theme keeps
theme values but loses the token values every recipe resolves.

**Widgets layer only.** Recipes and tests use `WidgetsApp`, never Material;
consumers may not have a Material ancestor.

## 4. Worksheet

For a new measurable visual contract, write its anatomy, measurements and
source before implementation. Use `specs/components/<component>.yaml` or extend
the existing owning specification; do not create a worksheet for an ordinary
fix. During review, flag missing contract evidence rather than a missing filename.
Designed values cite the committed brief (`docs/brief.md`).

```yaml
component: Button                 # source system's name
widget: AcmeButton                # installed as <Prefix>Button
status: planned | implemented | complete
source:
  ref: <pinned commit, doc version, or brief section>
  pages: [<component page, frames, style files>]
anatomy: [container, label, leading icon, trailing icon, spinner]
variants: [primary, secondary, ghost]   # target system's names
sizes: {supported: [small, medium, large], default: medium}
states: [rest, hover, pressed, focus-visible, disabled, loading]
tokens: [interactive-primary, text-on-interactive, focus, radius]
measurements:                     # non-token values, each with a source
  - {what: medium height, value: 36, cite: "button spec p.3"}
approximations: <every deviation from the source>
```

## 5. Tests

In the authoring package, pumping a `WidgetsApp` whose `builder` installs
`AcmeTheme`, the placement the README documents:

- every variant × size builds in every theme mode;
- measured default geometry (`tester.getSize(...)`), with and without an
  explicit size;
- focus ring appears on keyboard focus and does not change the widget's size;
- disabled and loading visuals match the worksheet;
- `AcmeTheme.of` throws without a scope and `maybeOf` returns null;
- the token test against `specs/tokens.yaml` (`references/tokens.md` §4).

For reference ports, assert geometry against measured upstream values at each
breakpoint the source defines, and review a side-by-side capture
(`references/reference-parity.md` §3–4).

Two recipes that restate each other (Button and IconButton) get one test that
resolves both for every variant × state × mode and compares fill, effects, and
foreground.

To prove a recipe rewrite changes nothing, copy the previous implementation
beside a temporary test, call `.build(context)` on old and new for every
variant × size × state × mode, with and without a caller `style`, and expect
the two `StyleSpec`s equal. Delete the copy and the test once they pass.

A spinner animates forever, so `pumpAndSettle` never returns in loading tests;
use `tester.pump(const Duration(milliseconds: 100))`. Assert token-derived
expected values documented with their token name, so a value change fails
with a reviewable diff.
