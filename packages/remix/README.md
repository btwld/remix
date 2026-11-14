# Remix

[Website](https://fluttermix.com/remix/) ·
[Documentation](https://fluttermix.com/remix/docs/)

Flutter components combining Naked UI interaction and accessibility with Mix
styling. Remix supplies component anatomy and behavior; your app supplies its
visual language, state and navigation.

Remix is a `1.0.0` prerelease. Pin it, because an unversioned install
resolves the older stable `0.x` line, which these docs do not describe.

```bash
flutter pub add remix:^1.0.0-rc.4
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

Use `Remix*` widgets with your own stylers, or install a neutral Vanilla or
Fortal preset as editable application source:

```bash
dart pub global activate remix_cli '^1.0.0-rc.1'
remix init --preset vanilla
remix add button
```

Install the CLI once globally. The constraint includes the 1.0 release
candidate; `remix.yaml` pins the registry revision used by each project.
Add Pub's `bin` directory to `PATH` if needed; Pub prints the instructions.
For a CLI pinned in the app's lockfile, use
`flutter pub add dev:remix_cli:^1.0.0-rc.1` instead and prefix each command
with `dart run remix_cli:`, for example `dart run remix_cli:remix init`.

The CLI installs a theme and recipes, then generates adapters against your
resolved dependencies. It pins registry content separately from the package
version. Place the installed theme above the Navigator in your host's builder.

Remix works inside Material, Cupertino, Widgets and router-based hosts.
Menus, select, popovers, tooltips and focused text fields need an Overlay;
dialog helpers need a Navigator; toasts need a `RemixToastScope` and overlay.
See [host setup](https://github.com/btwld/remix/blob/main/skills/using-remix/SKILL.md#provide-only-the-host-capabilities-in-use).

- [Getting started](https://fluttermix.com/remix/docs/getting-started/)
- [Styling and states](https://fluttermix.com/remix/docs/guides/styling-components/)
- [Editable-source walkthrough](https://fluttermix.com/remix/docs/open-code/)
- [Component docs](https://fluttermix.com/remix/docs/components/)
- [Fortal catalog](https://fluttermix.com/remix/docs/fortal/catalog/)
- [Examples and core concepts](https://fluttermix.com/remix/)
- [Material dependency boundary](https://github.com/btwld/remix/blob/main/open_code/README.md#material-boundary)

## Experimental agent library

`package:remix/agent.dart` provides agent conversation widgets and behavior.
It is experimental and outside Remix's stability promise. Import it separately;
`remix.dart` does not export it. Presets style it through registry recipes.

Agent skills: run `remix skills install` in a project that has run
`remix init`.
