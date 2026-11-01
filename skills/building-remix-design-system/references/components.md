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
an environment-dependent value; the active `MixScope` supplies it. Fixed scales
(spacing, sizes, strokes, opacity, and motion) are declared directly on `<Prefix>Tokens`
as plain `const` values alongside token identities so every recipe reads from one place
without dynamic scope lookup or arithmetic limitations. Token IDs use the value word
so they render per consumer.

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

**State fragments merge by state.** A caller override that must beat the
recipe's hover fill must itself be an `.onHovered(...)` fragment. Declare
`.onDisabled` last so it wins over every other state.

**Set foreground with fill in every state.** When hover or press changes the
fill, set label, icon, and spinner colors in the same fragment. Touch devices
never report hover, so a press fragment that changes only the fill paints the
pressed surface under the rest foreground.

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

A spinner animates forever, so `pumpAndSettle` never returns in loading tests;
use `tester.pump(const Duration(milliseconds: 100))`. Assert token-derived
expected values documented with their token name, so a value change fails
with a reviewable diff.
