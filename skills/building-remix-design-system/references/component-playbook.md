# Component playbook

How to implement one design-system component on Remix, and the Remix/Mix
behaviors that have produced real bugs in first reviews of packages built
this way. Code sketches use a placeholder system named "Acme".

## 1. Worksheet first

Create `specs/components/<component>.yaml` before writing code:

```yaml
component: <Source name>              # e.g. Button
flutter_name: <Sys><Name>             # e.g. AcmeButton
status: planned | implemented (vertical slice) | complete

source:
  ref: <pinned commit / doc version / brief section>
  files: [<source style/behavior files, pages, or frames>]
  docs: <official component page, if any>

anatomy:            # slots, child structure
kinds:              # the system's variants — NEVER Fortal/Remix names
sizes:              # supported range + default + contextual inheritance
states:             # rest/hover/active/focus/disabled/loading/…
tokens:
  role: [...]       # semantic tokens consumed
  component: [...]  # component-scoped tokens consumed
  type: [...]
  layout: [...]
non_token_measurements:   # each with its source — keep this list short
behavior:           # keyboard, focus, pointer, screen reader, RTL
approximations:     # every deviation from the source, honestly stated
```

The worksheet is the review artifact: a reviewer checks the code against the
worksheet and the worksheet against the design source.

## 2. Wrapper decision rule

Use a generated `@MixWidget` wrapper **only if all of**:

- the source anatomy matches the Remix component's anatomy;
- the generated constructor reads in the target system's vocabulary;
- no Remix-only public types leak;
- required states already exist in the underlying widget;
- semantics/keyboard behavior match.

Otherwise write a **hand-written facade**: a `StatelessWidget` in the target
vocabulary that builds a `Remix*Styler` recipe and invokes its `.call(...)`.
(With `mix_generator` 2.1.2 or newer, a generic `call<T>()` target is not by
itself a reason to hand-write the facade: `@MixWidget` supports generic
wrappers and generates named constructors for enum-backed variants.)
(Note: `@MixWidget` generation from a package *outside* remix is unproven —
run a spike before committing to it.)

For that spike, add the generator surface explicitly:

```yaml
dependencies:
  remix: ^1.0.0
  mix_annotations: ^2.1.2

dev_dependencies:
  build_runner: ^2.10.1
  mix_generator: ^2.1.2
```

Import `mix_annotations`, add a `part '<component>.g.dart';` directive to the
library containing the annotated styler recipe, then run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Commit the generated part and prove regeneration is a no-op before relying on
the wrapper in the public API.

## 3. Recipe shape

```dart
// Pure function of a few enums → memoize; stylers are immutable value objects.
final Map<(Kind, Size, bool), RemixButtonStyler> _styleCache = {};

RemixButtonStyler acmeButtonStyle({Kind kind, Size size, bool loading = false}) {
  final clamped = size.clampTo(Size.sm, Size.x2l);   // worksheet's supported range
  return _styleCache.putIfAbsent((kind, clamped, loading), () {
    final base = _baseStyle(clamped);                 // shared height/padding/label/focus
    return switch (kind) { ... };                     // per-kind fills/borders/states
  });
}
```

- Base style: geometry (height from the size scale, paddings from spacing
  tokens), label typography **via the type token** —
  `TextStyler().style(AcmeTokens.bodyCompact01.mix())` — never hand-copied
  font metrics "kept in sync" with a token.
- States as variants: `.onHovered(...)`, `.onPressed(...)`, `.onFocused(...)`,
  `.onDisabled(...)`, each a small styler merged over the base.
- The widget resolves contextual size with the three-level fallback:
  `explicit ?? LayoutScope.maybeOf(context)?.size ?? <system default>`.

## 4. Remix/Mix gotchas (each has caused a real bug)

### Loading is the disabled state

`RemixButton._isEnabled => enabled && !loading && onPressed != null`. Passing
`loading: true` forces `WidgetState.disabled`, so **the `.onDisabled` variant
styles the loading appearance**. If the design system's loading button keeps
its kind colors (many do), parameterize the recipe on `loading` and build
the disabled variant accordingly:

```dart
final disabledStyle = loading
    ? RemixButtonStyler().color(fill()).spinner(...)   // keep kind visuals
    : _disabledTreatment();                            // real disabled gray
```

Also: pass `enabled: enabled` through untouched — Remix already folds in the
null-`onPressed` case; duplicating the rule in the facade drifts.

### Focus rings: use foregroundDecoration

`onFocused(borderAll(...))` *replaces* the kind's base border and, because
Flutter containers pad by border width, **shifts layout on focus**. Paint the
ring over the content instead — no layout change, base border intact:

```dart
.onFocused(RemixButtonStyler().foregroundDecoration(BoxDecorationMix(
  border: BoxBorderMix.all(BorderSideMix(color: AcmeTokens.focus(), width: 2.0)),
)))
```

### Per-state foreground pairs

When hover/active change the fill, set the matching foreground **in the same
variant**. A classic bug: a pressed fill hardcoded to a neutral token while
hover had already set a white foreground — illegible text on press.
Parameterize shared state helpers on `(hoverFill, hoverText, activeFill,
activeText)` rather than sharing one hardcoded pressed treatment.

### Layout prepends outside the recipe's control

`RemixButton` prepends `mainAxisSize(.min)` to the styler. Shrink-wrapped
buttons ignore `mainAxisAlignment`; it only matters when the parent forces a
width. Set alignment for the width-constrained case if the source system
specifies it, and don't fight the min-size default.

### Misc

- `num.clamp()` returns `num` — `.toInt()` before using as an index.
- Widgets that must work without `MaterialApp` ancestors: check what the
  test harness provides vs. what the example provides.
- Radius/elevation: if the system doesn't define a scale (some systems use
  square corners throughout), **don't invent one** — `Radius.zero` is a
  legitimate design value.

## 5. Component tests

Minimum per component:

```dart
// Rendering + interaction
'renders its label / fires onPressed / disabled when onPressed null'

// The kind × theme matrix builds
'every kind builds across all themes'

// Measured geometry — catches default-size regressions
expect(tester.getSize(find.byType(AcmeButton)).height, 48.0);

// Contextual size inheritance AND the no-scope default (different values!)

// Loading visuals — container fill is the kind color, not disabled gray
// (find the DecoratedBox with a colored BoxDecoration and assert its color)
```

Test harness notes:

- Pump inside the system scope: `AcmeScope(child: MaterialApp(...))` or
  vice versa — put the scope where the example puts it.
- **`pumpAndSettle` hangs forever with an animating spinner** — use
  `tester.pump(const Duration(milliseconds: 100))` in loading tests.
- Prefer asserting on token-derived expected values (a `const Color(...)`
  documented with its token name) so a token regeneration that changes values
  fails visibly with a reviewable diff.
