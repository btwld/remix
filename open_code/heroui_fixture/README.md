# HeroUI installed-source gallery

A pre-install app, not a workspace package. `tool/check_open_code.dart` creates
a fresh Flutter app, copies `lib/main.dart`, `test/open_code_test.dart` and
`test/theme_modes_test.dart` from this directory (the files it lists in
`_fixtureAppFiles`, so a new test belongs in one of them), installs every
HeroUI item with the `Acme` prefix (each one alone as `Solo` first), then runs
`flutter analyze` and `flutter test`.

`lib/main.dart` is a review gallery of every installed component, one card per
family, with a header switch between light and dark (`AcmeThemeMode`). Its
"Dashboard shell" card opens `DashboardReview`, a full-window
`AcmeDashboardShell` with sidebar sections, search, a dark mode switch in the
app bar, and a simple overview page. The "Chart" card draws the line, bar and
pie recipes, and "Agent surfaces" a message, a permission request, an answer
and the composer with the HeroUI Agent recipes. The dashboard, chart and Agent
items are extensions with no upstream HeroUI family. It
imports the installed `ui/ui.dart` plus Remix and `mix_chart` for the part
types it passes (`RemixSelectItem`, `RemixMenuItem`, `RemixDataTableColumn`,
chart series, toasts, dialogs). There is no Material. `test/` covers both modes
at desktop and phone widths, every installed widget building below
`AcmeTheme`, a handful of interactions, the Agent recipe overrides, and the
theme API.

From the repository root, with the SDK pinned in `.fvmrc`:

```shell
fvm dart run tool/check_open_code.dart --preset heroui --source checkout --keep
```

Add `--keep` to keep the generated app; its path is printed.

`focused/search_field_*`, `focused/dashboard_shell_*` and
`focused/dashboard_demo_*` replace the gallery for a fresh install of that item
and its dependencies alone. These checks also run `flutter build web`:

```shell
fvm dart run tool/check_open_code.dart --preset heroui --source checkout --item search_field
fvm dart run tool/check_open_code.dart --preset heroui --source checkout --item dashboard_shell
fvm dart run tool/check_open_code.dart --preset heroui --source checkout --item dashboard_demo
```

## Screenshots

Build the retained app for web, then capture it:

```shell
cd <retained app> && fvm flutter build web --no-web-resources-cdn
cd <repository root>/registry_source/tool/heroui_parity/chromium && npm ci --ignore-scripts
node <repository root>/open_code/heroui_fixture/capture.mjs <retained app>/build/web <output dir>
```

It writes the whole gallery in light and dark at 1024 and 375 logical pixels
(`gallery-<mode>-<width>.png`) and the open select, dropdown, popover, tooltip,
modal, and toast (`overlay-<name>-<mode>-<width>.png`). It then opens the
dashboard review at 1440 × 900 and 390 × 844 and writes
`dashboard-<mode>-<size>.png`, the collapsed rail at desktop width
(`dashboard-collapsed-<mode>-1440x900.png`), and the open navigation sheet at
phone width (`dashboard-sheet-<mode>-390x844.png`). Playwright comes from
the HeroUI web reference's pinned dependencies; set `CHROME_PATH` to use a
browser other than macOS Google Chrome.
