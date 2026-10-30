# Fortal playground

The Widgetbook entrypoint is `lib/main.dart`. The standalone polish board is:

```sh
fvm flutter run -d chrome -t lib/polish_main.dart
```

It reviews all 39 Fortal families, every size and variant, paired light/dark
panels, all seven palettes, and hover/pressed/focus/disabled states on a 4px
grid. URL query parameters `accent=mar&group=Inputs` select a focused view.

Checklist: padding fits height; icons and gaps follow size; text is centered;
interactive hit regions are at least 40px; state changes are visible in both modes.

Golden captures use the checked-in Geist fonts for reproducible typography;
production Fortal leaves font choice to the application. Refresh and compare:

```sh
fvm flutter test test/polish_board_golden_test.dart --update-goldens
fvm flutter test test/polish_board_golden_test.dart
```

The opt-in `--dart-define=FORTAL_REVIEW=true` exports every palette/family and
interaction-state board to the repository's `.context/fortal-review/` directory.
All installed UI source is refreshed through `tool/registry_consumer_cli.dart`,
never hand-edited. The Vanilla playground remains in `apps/playground`.
