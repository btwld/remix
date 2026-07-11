# Foundation runtime patterns

The foundation layer turns generated tokens into a runtime API. Reference:
`packages/carbon/lib/src/foundation/`. Substitute your system's concepts —
the patterns below are system-agnostic; the code sketches use carbon names.

## Theme enum + token map builder (`<sys>_theme.dart`)

```dart
enum CarbonTheme {
  white, g10, g90, g100;
  Brightness get brightness => ...;   // map each theme to light/dark
}
```

Build the `MixScope` token map from the generated finals, **cached per theme**:

```dart
final Map<CarbonTheme, Map<MixToken, Object>> _baseTokenMaps = {};

Map<MixToken, Object> _baseTokenMapFor(CarbonTheme theme) {
  return _baseTokenMaps.putIfAbsent(theme, () => Map.unmodifiable({
    ...switch (theme) { /* per-theme role + component color finals */ },
    ...carbonSpacingValues,      // theme-independent finals
    ...carbonTextStyleTokens,
    ...carbonDurationValues,
    ...carbonFontWeightValues,
  }));
}

Map<MixToken, Object> buildCarbonTokenMap(CarbonTheme theme,
    {CarbonThemeOverrides overrides = const CarbonThemeOverrides()}) {
  final base = _baseTokenMapFor(theme);
  if (/* overrides empty */) return base;      // identical instance!
  return {...base, /* fontFamily-rewritten text styles */, ...overrides.colors};
}
```

Why it matters: the scope is a `StatelessWidget`; any ancestor rebuild re-runs
`build()`. Returning the identical cached instance lets `MixScope`'s
dependents short-circuit on `identical()` instead of deep-comparing hundreds
of entries per frame.

**Overrides objects need value equality.** `updateShouldNotify` compares them;
without `==`/`hashCode` (use `mapEquals` for the color map) every rebuild
notifies every dependent.

## Scope (`<sys>_scope.dart`)

An `InheritedWidget` above a `MixScope`:

```dart
class CarbonScope extends StatelessWidget {
  // theme, overrides, orderOfModifiers, child
  static CarbonTheme? maybeThemeOf(BuildContext context) => ...;
  static CarbonTheme themeOf(BuildContext context) => ...;       // asserts
  static CarbonThemeOverrides overridesOf(BuildContext context) => ...;
}
```

**Everything configurable on the scope must be readable back via a static
accessor.** The review found `fontFamily` reached fixed text tokens but not
fluid type or component labels — because nothing could read the override from
context. `overridesOf` closes that class of bug: any helper that builds
`TextStyle`s reads the scope's setting as its default.

## Contextual/indexed scopes (layers, elevation levels, …)

If the system defines leveled tokens (Carbon layers 1–3):

- The scope **increments** its parent level by default; the "no scope" state
  is the page itself, i.e. **level 1** — so the *first* scope in a tree
  resolves to level 2. Off-by-one here makes a single scope a silent no-op
  (`?? 1`, not `?? 0`, for the missing-parent default).
- Alias → indexed-token resolution is a `static const
  Map<AliasEnum, List<Token>>`, one line per alias, indexed by
  `level.clamp(1, n).toInt() - 1`. No per-call list allocation.
- The alias enum must be **tested against the generated grouping**
  (`carbonIndexedRoleFamilies`) so an upstream addition fails a test instead
  of silently becoming unreachable.

## Size/density scope (`<sys>_layout_scope.dart`)

```dart
enum CarbonSize { xs, sm, md, lg, xl, x2l;
  double get height => carbonControlSizePx[_key]!;   // generated map
  CarbonSize clampTo(CarbonSize min, CarbonSize max) =>
      CarbonSize.values[index.clamp(min.index, max.index).toInt()];
}
```

- Provide **both `of` (defaulted) and `maybeOf` (nullable)**. Components whose
  own default differs from the scope default (Carbon Button defaults `lg`,
  scope defaults `md`) need `maybeOf` to tell "no scope" from "scope default":

  ```dart
  final size = widget.size ?? CarbonLayoutScope.maybeOf(context)?.size ?? CarbonSize.lg;
  ```

- Any enum→generated-map string bridge gets a test iterating every enum value
  (an upstream key rename must fail in tests, not at first widget build).

## Responsive/fluid type (`<sys>_type.dart`)

- Fixed styles are plain Mix `TextStyleToken`s — nothing to build here.
- Fluid styles resolve against viewport width with **cumulative** breakpoint
  overrides, using a single merge rule (`CarbonTextStyleData.merge`) — never
  two copies of the field-coalescing logic.
- Name-keyed lookups **throw `ArgumentError` in all build modes**. An
  `assert` + silent fallback ships typos as plausible-looking wrong text.
- The context-taking helper reads the scope's font family as its default:

  ```dart
  final family = fontFamily ?? CarbonScope.overridesOf(context).fontFamily;
  ```

## Motion (`<sys>_motion.dart`)

- Emit curves as generated `Cubic` constants; expose an intent/mode accessor.
- Provide reduced-motion helpers and route recipes through them:

  ```dart
  static bool reducedMotionOf(BuildContext c) =>
      MediaQuery.maybeOf(c)?.disableAnimations ?? false;
  static Duration duration(BuildContext c, Duration v) =>
      reducedMotionOf(c) ? Duration.zero : v;
  ```

- If no component consumes motion yet, say so in the worksheet's
  approximations — don't let docs imply animated transitions exist.

## Mix API cheatsheet (verified against mix 2.1)

| Need | API |
| --- | --- |
| token value inside a styler chain | `CarbonTokens.spacing05()` (i.e. `token.call()`) |
| token → concrete value in a widget | `CarbonTokens.background.resolve(context)` |
| text-style token into a TextStyler | `TextStyler().style(CarbonTokens.bodyCompact01.mix())` |
| provide tokens to a subtree | `MixScope(tokens: Map<MixToken, Object>, child: …)` |
| tokens as map keys | runtime maps only — Mix tokens override `==`, so **const maps are a compile error** |
