# Remix Playground (Vanilla Dashboard Demo)

Vanilla preset showcase for Remix 2, consuming the full installed `vanilla`
registry catalog (`prefix: Playground`) under `lib/ui/` and mounting
`PlaygroundDashboardDemo` directly at the root.

From the repository root:

```sh
fvm dart run melos bootstrap
cd apps/playground
fvm flutter run -d chrome
```

## Installed registry source

All UI components, Agent surfaces, charts, and the `dashboard_demo` recipe are
installed under `lib/ui/`; `tool/check_consumer_apps.dart` verifies that the
installed tree stays in sync with the `vanilla` registry.

For the Fortal polish board (all sizes, variants, modes, palettes, and states),
see [the Fortal playground](../demo/README.md).
