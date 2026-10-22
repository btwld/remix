## Unreleased

### Fixes

- Make fewer GitHub API requests, which GitHub limits to 60 an hour without a
  token. A registry pinned to a full commit SHA now resolves with no API
  request, and a branch or tag with one instead of two. A missing repository
  and a missing ref are still reported separately.

## 0.1.0

Initial release of `remix_cli`: a command-line tool that installs editable Remix
design-system source into Flutter applications. Requires Flutter 3.44 (Dart 3.12)
or later.

### Projects and registries

- `remix init` writes a schema 3 `remix.yaml` configuration file. The file sets
  the component prefix, preset (`vanilla` by default, or `fortal`), UI path, and
  pins the official `@remix` registry to a `registry-stable` commit.
- Repeating `remix init` with matching options is safe. The command rejects
  conflicting configurations without modifying existing files.
- `remix registry add` adds an external GitHub registry. `remix registry update`
  advances a pinned registry to its latest commit.
- The CLI resolves all registries in a single dependency graph before writing
  files. It rejects cycles, conflicting target paths, and incompatible package
  requirements.
- Optional `iconLibrary: remix|lucide` selects the icon package for installed
  components. Registry templates resolve icon placeholders from `icons.yaml`.
  Omitting the key defaults to Remix icons.
- The prefixes `Remix` and `Mix` are reserved for runtime dependencies.

### Installing items

- `remix add` installs requested components and shared dependencies in a single
  batch. Dependency resolution, code generation, formatting, and analysis each run
  once per batch.
- Unknown or duplicate items cause the command to fail before writing files.
- `remix add` adds missing compatible dependencies to `pubspec.yaml` and preserves
  existing dependency declarations. Misplaced or duplicate entries cause the
  command to fail before execution, reporting the package name and target section.
- Code generation runs only for declared adapters and preserves existing
  adapters. New dependencies cannot remove previously generated code.
- Enables Mix's spec-styler builder only when installed components require it.
- Inspection and overwrite flags:
  - `--dry-run` previews planned changes.
  - `--diff` compares local component source against pinned registry source.
  - `--overwrite` replaces authored files for requested items without modifying
    shared dependencies.
- `remix add` warns when the resolved `remix` version is newer than the version
  recorded in the registry snapshot.
- Uses the Flutter SDK's Dart executable on Windows.
- Supports explicit, glob, and nested workspace members in monorepos.

### Presets

- `vanilla`: a neutral, shadcn-style theme set in Geist from `remix_ui_fonts`,
  with light and dark themes and a component recipe for every styled Remix
  surface.
- `fortal`: application-owned source derived from Radix Themes 3.3.0, with a
  prefixed token theme, the full component catalog, and no direct dependency on
  `remix_fortal`, `mix`, or `naked_ui`.
- Both presets generate `theme`, `darkTheme`, and `mode` scope parameters that
  follow the system appearance by default.
- Both presets include `app_bar`, `sidebar`, `sidebar_layout`, `toast`,
  `dashboard_shell`, `dashboard_demo`, an opt-in `icons` seam, an optional `chart`
  component backed by `mix_chart`, and unstyled Agent items with opt-in
  `<component>_recipe` stylers.
- Generated adapters require Remix `^1.0.0-beta.11`.
