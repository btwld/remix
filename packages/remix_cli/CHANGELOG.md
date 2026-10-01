## 0.1.0

Initial release: a project-local CLI that installs editable Remix design-system
source into a Flutter application. Requires Flutter 3.44 (Dart 3.12) or later.

### Projects and registries

- `remix init` writes a schema 3 `remix.yaml` with a prefix, a preset
  (`vanilla` by default, or `fortal`), a UI path, and the official `@remix`
  registry pinned to a full commit of the CI-promoted `registry-stable`
  branch. Repeating the same command is safe; a different configuration is
  refused instead of silently rewriting the project.
- `remix registry add` registers another GitHub registry and `remix registry
  update` moves a pin to the newest commit. Registries are resolved as one
  dependency graph before any write; cycles, conflicting targets, and
  incompatible package requirements are rejected.
- The optional `iconLibrary: remix|lucide` key chooses the icon library that
  installed items import. Registry templates name icons through placeholders
  resolved from the registry's `icons.yaml`. Omitting the key keeps Remix
  icons.
- The prefixes `Remix` and `Mix` are reserved for runtime dependencies.

### Installing items

- `remix add` installs one or several items as a single ordered unit: shared
  dependencies are written once, and dependency resolution, formatting, code
  generation, and analysis each run once for the batch. An unknown or
  repeated item fails before any write.
- Missing compatible hosted dependencies are added; existing hosted, path,
  Git, custom-hosted, and override declarations are preserved. A misplaced or
  duplicated declaration fails before any process runs, naming the package and
  the section to move it to.
- Generation runs only for declared adapters and always includes previously
  installed ones, so a new dependency cannot remove earlier generated parts.
  Mix's spec-styler builder is enabled only where installed source needs it.
- `--dry-run` reports what would change, `--diff` compares an item with the
  pinned registry source, and `--overwrite` replaces only the requested items'
  authored files, never a dependency pulled in behind them.
- `add` reports when the resolved `remix` is newer than the version the
  registry snapshot was authored against.
- Uses the Flutter SDK's Dart executable on Windows, and supports explicit,
  glob, and nested workspace members.

### Presets

- `vanilla`: a neutral, shadcn-style theme set in Geist from `remix_ui_fonts`,
  with light and dark themes and a component recipe for every styled Remix
  surface.
- `fortal`: application-owned source derived from Radix Themes 3.3.0, with a
  prefixed token theme and the full component catalog, and no direct
  dependency on `remix_fortal`, `mix`, or `naked_ui`.
- Both presets generate `theme`, `darkTheme`, and `mode` scope parameters
  that follow the system appearance by default, and ship `sidebar`,
  `sidebar_layout`, `toast`, `dashboard_shell`, `dashboard_demo`, an opt-in
  `icons` seam, an optional `chart` item backed by `mix_chart`, and the
  unstyled Agent items with opt-in `<component>_recipe` stylers.
- Generated adapters require Remix `^1.0.0-beta.10`.
