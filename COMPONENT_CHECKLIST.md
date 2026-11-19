# New component checklist

Use this when adding a Naked UI primitive or a Remix component, or moving behavior between them. Copy the checkboxes into the issue or PR. Complete steps 1–3 **before implementing**; a call site, expected result, or test name is better evidence than “matches best practice.” Mark irrelevant items `N/A` with a reason.

## 1. Decide what to build

- [ ] Name a real caller and show its smallest useful usage. What can’t the caller do by composing existing widgets? State what this component will **not** own.
- [ ] Check the Flutter SDK pinned in `.fvmrc`, the nearest Naked UI and Remix siblings, and an applicable accessibility pattern. Link the sources and record intentional differences. An upstream example is not necessarily a shipped API.
- [ ] Choose the smallest owner: reuse a Flutter widget for platform behavior; use a private helper for repeated mechanics; expose a `Naked*` widget for an independently useful interaction; put reusable visual anatomy in Remix and appearance in presets. Don’t add both a `Raw*` and a `Naked*` layer without two distinct jobs.

## 2. Review the public API at the call site

- [ ] Compare names, types, defaults, generics, nullability, and builder arguments with the nearest sibling. Show which parts the caller supplies, what state descendants can observe, and which details stay private.
- [ ] Decide who owns the value. Specify what happens when a controlled owner declines an update, when a callback is absent, and when the widget is disabled or read-only. Write the callback order for one user action; a rebuild must not replay it.
- [ ] Specify controller, focus-node, and listener ownership. Cover switching between supplied and internal objects, updating children, and disposal. For an extraction, identify which existing constructors, callbacks, and defaults must remain compatible.

## 3. Write the interaction and semantics contract

- [ ] For each supported input (pointer, touch, keyboard, assistive action), write **starting state → action → focus, value, callback**. Include Tab/Shift+Tab entry and exit. Decide which keys are handled and which bubble. Add RTL, text composition, scrolling, or dismissal only where relevant.
- [ ] Describe the semantics tree, not just the visible labels: which node owns the role, accessible name, value/state, and action? Which children remain independently actionable? Cover disabled and selected states, duplicate announcements, and `excludeSemantics` where offered. Verify the pinned Flutter SDK can express the intended semantics; document any platform limitation.
- [ ] Include failure cases: empty content, all items disabled, removal or reorder of the focused item, or an overlay closing after focus has moved elsewhere. Choose the cases that could break this component.

## 4. Implement at the owning layer

- [ ] Reuse the established Flutter or Naked UI behavior; don’t install a second gesture handler, focus target, or semantics action in the styled wrapper. Verify the headless component with a `WidgetsApp` host and only the host capabilities it needs.
- [ ] Export the intended public types and keep helpers private. If a preset changes, edit `registry_source/`, not generated templates. For visual anatomy and measurements use the [existing preset worksheet](skills/building-remix-design-system/references/components.md#4-worksheet).

## 5. Prove it works and document it

- [ ] Turn the interaction cases into widget tests; assert callback count/order and focus, not just pixels. Inspect the **merged** semantics tree before and after interaction; exercise a semantic action independently of a tap. See the [select semantics tests](packages/naked_ui/test/semantics/naked_select_semantics_test.dart).
- [ ] On the pinned SDK, run the affected package tests (`flutter test` from the package), not just repository analysis. Run relevant keyboard/focus/semantics tests on Chrome as well. For a new assistive interaction, record a named browser/device and screen reader smoke test, or explicitly say it was not performed. Widget tests alone aren’t that verification.
- [ ] Add a minimal public-import example. For Naked UI, update the package component list, [docs navigation and page](naked_ui_docs/README.md), and run `python3 tool/check_naked_ui_docs.py` with the pinned Flutter and Dart on `PATH`. For Remix or presets, run the applicable docs, generation, registry, and [consumer checks](AGENTS.md#commands).

## 6. Independent review and rollout

- [ ] Someone other than the implementer checks the diff against steps 1–3, exercises a failure case, and records findings with file locations and expected behavior. Fix and recheck blockers. Report commands run, skipped checks, and remaining risks; don’t mark an unperformed review complete.
- [ ] Identify the first adopting consumer and the migration path. If it needs an unpublished dependency, separate the primitive from consumer adoption; follow the [release and dependency-floor workflow](open_code/RELEASING.md). Versions and changelogs belong to the release PR.

### Example acceptance case: proposed multi-select listbox

Ada is selected and focused. **Down** focuses Leo without changing selection or calling `onChanged`. **Space** proposes `{Ada, Leo}` exactly once; if the controlled owner keeps `{Ada}`, Leo stays focused but unselected. **Tab** leaves the list. Verify that assistive technology can distinguish the focused option from the selected ones. This tests what makes the listbox different from a popup select, without prescribing its visual layout.
