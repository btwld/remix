<p align="center">
  <img alt="Remix banner" src="https://jtmo7uveygl6pnag.public.blob.vercel-storage.com/remix_banner.png" width="100%" />
</p>

# Remix

Flutter components with Naked UI behavior and Mix styling.

## Core concepts

- Naked UI owns interaction: focus, keyboard input, interaction state and accessibility.
- Mix owns styling: specs, stylers, tokens, variants and animation.
- Remix composes both: use `Remix*` with your own styles, or install a preset.
- Presets are editable app source: choose one per app. Vanilla is neutral;
  Fortal has its own visual language. The CLI installs items and their dependencies.
- The app owns its UI and host: themes, recipes, state and navigation. Supply
  an Overlay, Navigator or toast scope where the component needs it.
- Registries are pinned: `remix.yaml` records a GitHub commit. Updating that
  pin and adopting changed source are separate actions.
- Author once, generate and check: private `registry_source` produces the
  registries; apps generate adapters. Runtime packages, registry content and
  the CLI release independently.

## Start with a component

This checkout prepares `1.0.0-beta.14`, which is not published yet. The
currently hosted version is `1.0.0-beta.13`; use the matching release docs or
a local path dependency while beta.14 is staged. After publication:

```bash
flutter pub add remix:^1.0.0-beta.14
```

```dart
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

Widget saveButton(VoidCallback save) => RemixButton(
  label: 'Save',
  onPressed: save,
  style: ButtonStyler()
      .color(const Color(0xFF2196F3))
      .padding(.horizontal(16))
      .borderRadius(.circular(8))
      .labelColor(const Color(0xFFFFFFFF)),
);
```

Or install editable theme and component source:

```bash
flutter pub add dev:remix_cli
dart run remix_cli:remix init --preset vanilla
dart run remix_cli:remix add button
```

Place the installed theme above your Navigator in the host's builder before
using its widgets. See [setup and host requirements](skills/using-remix/SKILL.md#place-the-theme-scope).

- [Style components directly](docs/guides/styling-components.mdx).
- [Install, customize and update editable source](open_code/README.md).
- [Component catalog](docs/index.mdx) · [Fortal catalog](docs/fortal/catalog.mdx).
- Examples: [Vanilla playground](apps/playground), [Fortal catalog](apps/demo),
  [dashboard](apps/dashboard).
- [Architecture decisions](ARCHITECTURE.md) preserve rationale and tradeoffs;
  [AGENTS.md](AGENTS.md) routes contributors to source owners and checks.

## Agent skills

Install the [app UI](skills/using-remix/SKILL.md) and
[design-system authoring](skills/building-remix-design-system/SKILL.md) skills:

```bash
npx skills add btwld/remix
```
