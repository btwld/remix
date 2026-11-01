# Remix

Flutter components combining Naked UI interaction and accessibility with Mix
styling. Remix supplies component anatomy and behavior; your app supplies its
visual language, state and navigation.

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

Use `Remix*` widgets with your own stylers, or install a neutral Vanilla or
Fortal preset as editable application source:

```bash
flutter pub add dev:remix_cli
dart run remix_cli:remix init --preset vanilla
dart run remix_cli:remix add button
```

The CLI installs a theme and recipes, then generates adapters against your
resolved dependencies. It pins registry content separately from the package
version. Place the installed theme above the Navigator in your host's builder.

Remix works inside Material, Cupertino, Widgets and router-based hosts.
Menus, select, popovers, tooltips and focused text fields need an Overlay;
dialog helpers need a Navigator; toasts need a `RemixToastScope` and overlay.
See [host setup](https://github.com/btwld/remix/blob/main/skills/using-remix/SKILL.md#provide-only-the-host-capabilities-in-use).

- [Getting started](https://github.com/btwld/remix/blob/main/docs/getting-started.mdx)
- [Styling and states](https://github.com/btwld/remix/blob/main/docs/guides/styling-components.mdx)
- [Editable-source walkthrough](https://github.com/btwld/remix/blob/main/open_code/README.md)
- [Component docs](https://github.com/btwld/remix/tree/main/docs/components)
- [Fortal catalog](https://github.com/btwld/remix/blob/main/docs/fortal/catalog.mdx)
- [Examples and core concepts](https://github.com/btwld/remix#remix)
- [Material dependency boundary](https://github.com/btwld/remix/blob/main/open_code/README.md#material-boundary)

Agent skills: `npx skills add btwld/remix`.
