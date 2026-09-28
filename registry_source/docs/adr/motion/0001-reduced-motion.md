# ADR 0001 — Motion and reduced motion

Date: 2026-09-27. Status: proposed.

## Decision

Flutter's `MediaQuery.disableAnimations` is the only reduced-motion signal.
Mix, naked_ui, Remix, and both presets read it with
`MediaQuery.maybeDisableAnimationsOf(context) ?? false`, and none of them
defines a second flag. Flutter fills it from the OS; an application may set it
with a `MediaQuery` override. Animation is on by default and follows the OS.

Each layer owns one part:

| Layer | Owns |
| --- | --- |
| Mix | `StyleAnimationBuilder` honors the signal for every animation config. |
| naked_ui, remix | Each widget that runs its own controller honors the signal. Widget-owned timing stays a Flutter `AnimationStyle` parameter. No theme scope and no motion tokens. |
| Presets | Motion values and the default state transitions in recipes. No scope option. |

### What honoring the signal means

- State changes (Mix curve and spring configs, implicit transitions) land on
  the target in the same frame. Completion callbacks still run, after that
  frame.
- Enter and exit transitions (disclosure, accordion, select, tooltip, toast,
  dialog, sidebar) are skipped. Mounting, unmounting, and semantics stay
  correct.
- Looping decoration (the skeleton pulse, looping Mix phase and keyframe
  configs) holds its resting frame.
- A change to the signal applies from the next transition, without
  remounting. A transition that is already running finishes (tooltip, select,
  toast, dialog, Mix curve and spring configs). Widgets that can land without
  extra state do so at once (disclosure, accordion, sidebar, skeleton). Loops
  stop when the signal turns on and resume when it clears.
- Progress indicators (spinner, the Agent loading glyph) are not decided here.

A widget-owned transition takes its duration from the signal when it starts:
`disabled ? Duration.zero : configured`. A zero-duration `forward()` or
`reverse()` sets the final value and status and returns a completed
`TickerFuture`, so the existing `await reverse()` and
`reverse().whenComplete(hide)` close paths unmount without special cases.
Settling a running transition would need `stop(canceled: false)` and overlay
guards per widget, and the signal changes only when someone changes a setting.
Running transitions last at most 400 ms (the dialog's default enter).
`RawDialogRoute` fixes its durations at push, so the dialog also re-reads the
signal when a pop starts. That re-read only shortens the close: the push read
the caller's context, which can carry an override the root-navigator route
does not see.

Applications set the signal above the Navigator, which covers routes and
root-navigator dialogs:

```dart
builder: (context, child) => MediaQuery(
  data: MediaQuery.of(context).copyWith(disableAnimations: true),
  child: FortalScope(child: child!),
),
```

### Presets

Vanilla's button and icon-button recipes get short default transitions between
their hover, pressed, focus, and disabled states. Fortal's buttons stay
instant: Radix Themes 3.3.0 `base-button.css` declares no transition. Fortal's
card keeps its Radix-derived 120 ms and 40 ms box-shadow transitions.

Motion values are recipe constants, not scope tokens. Mix's `AnimationConfig`
takes a concrete `Duration`, so a token-backed duration would have to be
resolved through `onBuilder` in every animated recipe. Installed recipes are
application source, and the constant is the customization point. This decision
does not adopt Fortal's `transitionFast` and `transitionSlow` tokens: nothing
consumes them and neither has a Radix source.

The preset scopes keep `theme`, `darkTheme`, and `mode`. They do not take a
`reduceMotion` option; see Options considered.

### Order

Mix ships before the presets. Vanilla's button and icon-button transitions,
the `mix` floor that requires the Mix release, and the refreshed installed
copies land only after `StyleAnimationBuilder` honors the signal in a
published release. These transitions are new motion: shipping them earlier
would animate buttons for users who asked for reduced motion. Library work
(naked_ui and Remix widget-owned motion) depends on neither and can land first.

## Context

- Mix `.animate()` ignores the signal. `StyleAnimationBuilder` and its drivers
  are byte-identical in `2.2.0-beta.5`, which Remix resolves, and in Mix
  `origin/main` at 2.2.0. [btwld/mix#1070](https://github.com/btwld/mix/pull/1070)
  fixes this for 2.2.1.
- `StyleAnimationBuilder.didUpdateWidget` recreates the driver with
  `config ?? oldConfig`, so dropping `.animate()` at runtime keeps animating.
- `CurveAnimationDriver` weights its tween by `duration.inMilliseconds`, and
  `TweenSequenceItem` asserts a positive weight. `Duration.zero` fails in debug.
- Flutter scales `AnimationController.forward` and `animateTo` to 5% under the
  OS flag (`animation_controller.dart`, `_animateToInternal`). That does not
  apply to a `MediaQuery` override, to `animateWith` (Mix springs), or to
  `repeat` (loops), so every layer has to read `MediaQuery` itself.
- In the library, 4 of 11 animated widgets honor the signal (disclosure,
  toast, sidebar, skeleton), each in a different way. Accordion (200 ms) and
  select (150 ms) hardcode their timing; tooltip and dialog ignore the signal.
- In the presets, the only `.animate()` is Fortal's card. Vanilla's buttons
  change state without a transition.

## Options considered

| Option | Result |
| --- | --- |
| A flag on the preset scopes only | Mix and the library would have to read a preset type, and each preset duplicates it. Rejected. |
| A switch in `RemixStyleSpecBuilder` | Not implementable. It hands the unresolved style to Mix's `StyleBuilder`, which resolves and animates internally, and neither `StyleSpec.copyWith` nor style merging can clear an animation. It would also put motion policy in unstyled machinery ([agent ADR 0001](../agent/0001-package-boundary.md)). Rejected. |
| A new `MixScope` flag | A second signal beside Flutter's that naked_ui and Remix would also have to read, and that scopes would set alongside `MediaQuery`. Rejected. |
| A preset stopgap: `onBuilder` plus a zero-duration config | Asserts in debug and adds a closure to every animated recipe. Rejected. |
| `MediaQuery` only, no scope option | The smallest API: applications wrap `MediaQuery` in `WidgetsApp.builder`, where the docs already place the scope. Chosen. |
| A `reduceMotion` option on `VanillaThemeScope` and `FortalScope` | Only adds reduction; the inherited theme stores the effective flag and `wrap` reapplies a `MediaQuery` override so root-navigator dialogs see it. Viable, deferred. At the documented root placement it does nothing the `MediaQuery` override does not. Its one extra case, a nested subtree whose reduction must reach root-navigator dialogs, has no consumer. It would also change the scope API cutoff in every installed copy. |
| Settle a running transition when the signal changes | `stop(canceled: false)` completes the close future but leaves the value mid-way, so each overlay needs a guard, and an interrupted close resumed from the middle once motion came back on. Rejected. |

## Consequences

- One switch covers Mix, the library, the presets, and third-party widgets
  that honor Flutter's flag. Tests use the standard `MediaQuery` override.
- Mix changes its default behavior for users with reduced motion on. Its
  changelog has to say so.
- The scope API stays at `theme`, `darkTheme`, and `mode`. Reducing motion
  for a nested subtree needs a `MediaQuery` override there. Dialogs pushed from
  that subtree still skip their transitions, which are read at the call site,
  but content inside a root-navigator dialog does not see that override.
- A transition already running when the signal changes may play to its end.
- Motion cannot be forced on against the OS, including for demos.
- Motion values cannot differ per subtree.
- A recipe transition animates every property that differs between states
  (color, outline, opacity), not only color.
- With the preset step, the `mix` floor rises in `packages/remix`,
  `registry_source`, and the workspace `pubspec.yaml`, and the installed app
  copies are refreshed.

## Reconsider when

- Mix will not honor the signal by default. Add an opt-in `MixScope` flag that
  the preset scopes enable alongside `MediaQuery`.
- A component needs motion that must survive reduced motion. Add a per-config
  escape hatch in Mix.
- `AnimationConfig` accepts token-resolved durations, or a product needs motion
  values per subtree. Move the values into scope tokens.
- Radix Themes adds button transitions. Revisit Fortal's buttons.
- The spinner decision is made. Extend the behavior list above.
- A product needs reduced motion for a nested subtree that must reach
  root-navigator dialogs. Add the deferred scope option.
- A transition that runs long enough to matter after the signal changes, such
  as a looping or multi-second one, is added. Settle it when the signal
  changes, as the skeleton does.
