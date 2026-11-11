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
installs the full HeroUI catalog under `lib/ui/`, including the chart, Agent,
`dashboard_shell`, and `dashboard_demo` items. `lib/main.dart` mounts
`UiDashboardDemo` at the root below `UiTheme`, with the Geist face from
`remix_ui_fonts`; it adds nothing else. `tool/check_consumer_apps.dart` checks
that the installed tree still matches the `heroui` registry in this checkout.

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
