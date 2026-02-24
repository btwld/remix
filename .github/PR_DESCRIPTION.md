## Description

This PR replaces the function-based theme scope APIs with a widget-based API and removes deprecated helpers.

### 1. `createFortalScope` → `FortalScope` widget

- **Removed** the `createFortalScope(...)` function from `packages/remix/lib/src/fortal/fortal_theme.dart`.
- **Added** a `FortalScope` `StatelessWidget` with the same parameters (`accent`, `gray`, `brightness`, `orderOfModifiers`, `child`). Token resolution is implemented via a private `_buildFortalScopeTokens` helper; `FortalScope.build()` returns a `MixScope` with that token map.
- **Updated** `FortalThemeConfig.createScope()` to return `FortalScope(...)` (and later removed `RemixThemeConfig`; see below).
- **Updated** all usages to the widget form: example apps, demo, test helpers, playground component registry, and docs (README, `docs/index.mdx`). Doc references to “Must be used within [createFortalScope]” now point to `[FortalScope]`.

**Before:** `createFortalScope(accent: …, gray: …, brightness: …, child: MyApp())`  
**After:** `FortalScope(accent: …, gray: …, brightness: …, child: MyApp())`

### 2. Remove `createRemixScope`

- **Removed** `createRemixScope` from `packages/remix/lib/src/theme/remix_theme.dart`. It had only wrapped brightness resolution and delegated to `FortalScope`.
- **Replaced** every call site with `FortalScope`:
  - **Tests** (`test_helpers.dart`): `FortalScope(child: MaterialApp(...))` with default brightness.
  - **Demo** (`preview_helper.dart`): `MaterialApp` with `home: Builder(builder: (context) => FortalScope(brightness: Theme.of(context).brightness, child: Scaffold(...)))` so scope brightness follows the app theme.
  - **Playground** (`component_registry.dart`): each component builder uses `FortalScope(brightness: Theme.of(context).brightness, child: PreviewShell(...))`.
- **Kept** `resolveRemixBrightness` and `resolveRemixBrightnessValues` (with `@visibleForTesting`) for tests and for any code that needs theme-adaptive brightness before building `FortalScope`.
- **Updated** PREVIEW.md and the preview_shell comment to describe the new pattern.

### 3. Remove `RemixThemeConfig`

- **Removed** the deprecated `RemixThemeConfig` class from `remix_theme.dart`. It had only provided `createScope()` (which used `createRemixScope` / `FortalScope` with `resolveRemixBrightness`). Call sites should use `FortalScope` directly (with `Builder` + `Theme.of(context).brightness` or `resolveRemixBrightness` when theme-adaptive brightness is needed).

**Motivation:** Align with the friction-log recommendation (2026-02-20): a dedicated `FortalScope` widget improves discoverability, makes scope boundaries explicit in the widget tree, and keeps a single, evolvable API for token scope behavior.

## Related Issues

*N/A – implements recommendation from `docs/friction-log.md` (createFortalScope API Shape).*

---

## Checklist

**Note**: Updating the `pubspec.yaml` and `CHANGELOG.md` is not required. These are handled automatically during the release process.

- [x] My PR includes unit or integration tests for *all* changed/updated/fixed behaviors.
- [x] I have updated or added relevant documentation (doc comments with `///`).
- [x] I am prepared to follow up on review comments in a timely manner.

## Breaking Change

Does this PR require users of the package to manually update their code?

- [x] Yes, this is a breaking change.
- [ ] No, this is *not* a breaking change.

**Migration:**

- **`createFortalScope(...)`** → **`FortalScope(...)`** (same named arguments; `child` is required).
- **`createRemixScope(child: ...)`** → **`FortalScope(child: ...)`**. For theme-adaptive brightness, wrap in a `Builder` and pass `brightness: Theme.of(context).brightness` (or use `resolveRemixBrightness(context)` from `package:remix/src/theme/remix_theme.dart` if you need override support).
- **`RemixThemeConfig`** → use **`FortalScope`** with the desired `accent`, `gray`, and `brightness` (and `Builder` + brightness resolution when following theme).
