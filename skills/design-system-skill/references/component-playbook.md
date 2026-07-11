# Component playbook

How to implement one design-system component on Remix, and the Remix/Mix
behaviors that produced real bugs in carbon's first review. Reference
implementation: `packages/carbon/lib/src/components/button/carbon_button.dart`
and its worksheet `packages/carbon/specs/components/button.yaml`.

## 1. Worksheet first

Create `specs/components/<component>.yaml` before writing code:

```yaml
component: <Upstream name>            # e.g. Button
flutter_name: <Sys><Name>             # e.g. CarbonButton
status: planned | implemented (vertical slice) | complete

source:
  commit: <pinned upstream commit>
  files: [<upstream style/behavior files>]
  docs: <official component page>

anatomy:            # slots, child structure
kinds:              # the system's variants — NEVER Fortal/Remix names
sizes:              # supported range + default + contextual inheritance
states:             # rest/hover/active/focus/disabled/loading/…
tokens:
  role: [...]       # semantic tokens consumed
  component: [...]  # component-scoped tokens consumed
  type: [...]
  layout: [...]
non_token_measurements:   # each with its upstream source — keep this list short
behavior:           # keyboard, focus, pointer, screen reader, RTL
approximations:     # every deviation from upstream, honestly stated
```

The worksheet is the review artifact: a reviewer checks the code against the
worksheet and the worksheet against upstream.

## 2. Wrapper decision rule

Use a generated `@MixWidget` wrapper **only if all of**:

- upstream anatomy matches the Remix component's anatomy;
- the generated constructor reads in the target system's vocabulary;
- no Remix-only public types leak;
- required states already exist in the underlying widget;
- semantics/keyboard behavior match.

Otherwise write a **hand-written facade**: a `StatelessWidget` in the target
vocabulary that builds a `Remix*Styler` recipe and invokes its `.call(...)`.
Carbon's Button is the model. (Note: `@MixWidget` generation from a package
*outside* remix is unproven — run a spike before committing to it.)

## 3. Recipe shape

```dart
// Pure function of a few enums → memoize; stylers are immutable value objects.
final Map<(Kind, Size, bool), RemixButtonStyler> _styleCache = {};

RemixButtonStyler carbonButtonStyle({Kind kind, Size size, bool loading = false}) {
  final clamped = size.clampTo(Size.sm, Size.x2l);   // worksheet's supported range
  return _styleCache.putIfAbsent((kind, clamped, loading), () {
    final base = _baseStyle(clamped);                 // shared height/padding/label/focus
    return switch (kind) { ... };                     // per-kind fills/borders/states
  });
}
```

- Base style: geometry (height from the size scale, paddings from spacing
  tokens), label typography **via the type token** —
  `TextStyler().style(CarbonTokens.bodyCompact01.mix())` — never hand-copied
  font metrics "kept in sync" with a token.
- States as variants: `.onHovered(...)`, `.onPressed(...)`, `.onFocused(...)`,
  `.onDisabled(...)`, each a small styler merged over the base.
- The widget resolves contextual size with the three-level fallback:
  `explicit ?? LayoutScope.maybeOf(context)?.size ?? <system default>`.

## 4. Remix/Mix gotchas (each caused a real carbon bug)

### Loading is the disabled state

`RemixButton._isEnabled => enabled && !loading && onPressed != null`. Passing
`loading: true` forces `WidgetState.disabled`, so **your `.onDisabled` variant
styles the loading appearance**. If the design system's loading button keeps
its kind colors (Carbon does), parameterize the recipe on `loading` and build
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
  border: BoxBorderMix.all(BorderSideMix(color: CarbonTokens.focus(), width: 2.0)),
)))
```

### Per-state foreground pairs

When hover/active change the fill, set the matching foreground **in the same
variant** — the ghost-danger bug was a pressed fill hardcoded to a neutral
token while hover had already set a white foreground (illegible). Parameterize
`_ghostStyle` on `(hoverFill, hoverText, activeFill, activeText)` rather than
sharing one hardcoded pressed treatment.

### Layout prepends you don't control

`RemixButton` prepends `mainAxisSize(.min)` to your styler. Shrink-wrapped
buttons ignore `mainAxisAlignment`; it only matters when the parent forces a
width. Set alignment for the width-constrained case if upstream specifies it
(Carbon uses space-between), and don't fight the min-size default.

### Misc

- `num.clamp()` returns `num` — `.toInt()` before using as an index.
- Widgets that must work without `MaterialApp` ancestors: check what your
  test harness provides vs. what the example provides.
- Radius/elevation: if the system doesn't define a scale (Carbon buttons are
  square), **don't invent one** — `Radius.zero` is a legitimate design value.

## 5. Component tests

Minimum per component (see `packages/carbon/test/components/`):

```dart
// Rendering + interaction
'renders its label / fires onPressed / disabled when onPressed null'

// The kind × theme matrix builds
'every kind builds across all four themes'

// Measured geometry — catches default-size regressions
expect(tester.getSize(find.byType(CarbonButton)).height, 48.0);

// Contextual size inheritance AND the no-scope default (different values!)

// Loading visuals — container fill is the kind color, not disabled gray
// (find the DecoratedBox with a colored BoxDecoration and assert its color)
```

Test harness notes:

- Pump inside the system scope: `CarbonScope(child: MaterialApp(...))` or
  vice versa — put the scope where the example puts it.
- **`pumpAndSettle` hangs forever with an animating spinner** — use
  `tester.pump(const Duration(milliseconds: 100))` in loading tests.
- Prefer asserting on token-derived expected values (`const Color(0xFF0F62FE)`
  documented as `buttonPrimary`) so a token regeneration that changes values
  fails visibly with a reviewable diff.
