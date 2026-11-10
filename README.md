<p align="center">
  <img alt="Remix banner" src="https://jtmo7uveygl6pnag.public.blob.vercel-storage.com/remix_banner.png" width="100%" />
</p>

# Remix

<p align="center">
  <a href="https://pub.dev/packages/remix"><img alt="pub.dev" src="https://img.shields.io/pub/v/remix.svg?include_prereleases"></a>
  <a href="https://github.com/btwld/remix/actions/workflows/ci.yaml?query=branch%3Amain"><img alt="CI" src="https://github.com/btwld/remix/actions/workflows/ci.yaml/badge.svg?branch=main"></a>
  <a href="https://github.com/btwld/remix/blob/main/LICENSE"><img alt="BSD 3-Clause License" src="https://img.shields.io/github/license/btwld/remix"></a>
</p>

Flutter components with Naked UI behavior and Mix styling.

## Core concepts

- Naked UI owns interaction: focus, keyboard input, interaction state and accessibility.
- Mix owns styling: specs, stylers, tokens, variants and animation.
- Remix composes both: use `Remix*` with your own styles, or install a preset.
- Presets are editable app source: choose one per app. Vanilla is neutral;
  Fortal has its own visual language; HeroUI follows HeroUI web 3.2.6.
  The CLI installs items and their dependencies.
- The app owns its UI and host: themes, recipes, state and navigation. Supply
  an Overlay, Navigator or toast scope where the component needs it.
- Registries are pinned: `remix.yaml` records a GitHub commit. Updating that
  pin and adopting changed source are separate actions.
- Author once, generate and check: private `registry_source` produces the
  registries; apps generate adapters. Runtime packages, registry content and
  the CLI release independently.

## Start with a component

Remix is a `1.0.0` prerelease. Pin it, because an unversioned install
resolves the older stable `0.x` line, which these docs do not describe.

```bash
flutter pub add remix:^1.0.0-beta.18
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
flutter pub add dev:remix_cli:^1.0.0-beta.1
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

Copy the [app UI](skills/using-remix/SKILL.md) and
[design-system authoring](skills/building-remix-design-system/SKILL.md) skills
into a project that has run `remix init`. The copies come from the commit the
project pins, so they describe the Remix the project installs:

```bash
dart run remix_cli:remix skills install
```

To have a coding agent do the whole setup, paste the
[Start with AI prompt](docs/getting-started.mdx#start-with-ai).
