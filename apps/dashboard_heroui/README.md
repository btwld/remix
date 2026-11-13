# Remix HeroUI Dashboard

The Remix reference dashboard in the HeroUI preset: the same Overview, Chat,
Customers, Orders, and Settings destinations, sample data, and behavior as the
[Vanilla playground](../playground/README.md) and the
[Fortal dashboard](../dashboard/README.md), drawn with HeroUI's components.

From the repository root:

```sh
fvm dart run melos bootstrap
cd apps/dashboard_heroui
fvm flutter run -d chrome
```

## Installed registry source

The app selects the `heroui` preset with prefix `Ui` in `remix.yaml` and
installs the full HeroUI catalog under `lib/ui/`, including the chart, Agent recipes,
`dashboard_shell`, and `dashboard_demo` items. `lib/main.dart` mounts
`UiDashboardDemo` at the root below `UiTheme`, with the Geist face from
`remix_ui_fonts`; it adds nothing else. `tool/check_consumer_apps.dart` checks
that the installed tree still matches the `heroui` registry in this checkout.
Agent widgets and models come from experimental `package:remix/agent.dart`.

HeroUI web 3.2.6 has no dashboard, sidebar, app bar, chart, or Agent surfaces,
so those items are extensions: built from HeroUI's tokens and recipes, with no
upstream reference behind their geometry. The worksheets under
`registry_source/specs/heroui/components/` say so item by item.

`remix.yaml` pins the `main` revision the HeroUI preset first shipped from,
which predates the dashboard items. The consumer check reads this checkout's
registry instead, so the pin only matters to a standalone `remix add`; move it
once the items reach a promoted registry.

Open **Workspace → Chat** to review the Agent surfaces together. No model or
tool service is contacted.

## Screenshots

`tool/capture.mjs` renders every destination at 1440 × 900 and Overview and
Chat at 390 × 844, in light and dark (`<destination>-<mode>-<size>.png`). Chat
is captured with the permission scenario running. Build the app first:

```sh
fvm flutter build web --no-web-resources-cdn
(cd ../../registry_source/tool/heroui_parity/chromium && npm ci --ignore-scripts)
node tool/capture.mjs "$PWD/build/web" /absolute/output/dir
```

Playwright comes from the HeroUI web reference's pinned dependencies, as for
`open_code/heroui_fixture/capture.mjs`; set `CHROME_PATH` to use a browser
other than macOS Google Chrome.
