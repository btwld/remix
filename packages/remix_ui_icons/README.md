# remix_ui_icons

`remix_ui_icons` is the [Vector UI](https://github.com/btwld/remix/tree/main/design/icons)
icon pack for Flutter: three families in one icon font, as `const IconData`
constants. Release builds keep only the glyphs an application refers to.

```dart
import 'package:flutter/widgets.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

const search = Icon(RemixIcons.search);
const small = Icon(OutlineIcons.searchFilled16, size: 16);
const rounded = Icon(RoundedIcons.home);
```

## Families

<!-- generated:coverage:begin -->
| Family | Class | Concepts | Glyphs |
| --- | --- | ---: | ---: |
| Outline | `OutlineIcons` | 48 | 288 |
| Rounded | `RoundedIcons` | 12 | 72 |
| Mono | `MonoIcons` | 12 | 72 |
| **Total** | | | **432** |
<!-- generated:coverage:end -->

Rounded and Mono are siblings of Outline, not filters over it: each draws its
concepts from its own primitives. They cover a subset of Outline's concepts.
`RemixIcons` is the default set and is the Outline family under the same names.

## Styles and masters

Every concept is drawn in an outline and a filled style at three native
masters. The masters are separate drawings, not one glyph scaled: a 12 px
master has heavier relative weight and fewer details than the 24 px one.

| Constant | Style | Master |
| --- | --- | --- |
| `search` | outline | 24 px |
| `searchFilled` | filled | 24 px |
| `search16` | outline | 16 px |
| `searchFilled16` | filled | 16 px |
| `search12` | outline | 12 px |
| `searchFilled12` | filled | 12 px |

Use the master closest to the rendered size: up to 12 px use the 12 px master,
up to 16 px the 16 px master, and the 24 px master above that. Sizes below
12 px are not reviewed.

When the size is only known at runtime, opt into `sized.dart`. Each set refers
to all three of its masters, so it keeps three glyphs in a release build:

```dart
import 'package:remix_ui_icons/sized.dart';

Icon(OutlineIconSets.search.at(size), size: size);
```

## Labels

Some glyphs are recognized reliably only with a visible text label. The rules
come from the Vector UI design contract and depend on the family and master:

| Glyphs | Visible text label |
| --- | --- |
| Warning, every family and style | Required at every size. A tooltip or semantic label is not a substitute. |
| Mono Star | Required at every size: the CAD-regular star reads as Favorite only with its label. |
| Rounded Branch | Required at every size. |
| Outline Help, Branch, Focus | Required at 12 px; a contextual label is recommended at 16 and 24 px. |
| Rounded Link; Mono Link and Branch | Required at 12 px. |
| Mono Search | Label it explicitly beside crop, frame, or view tools, where it can read as a viewfinder. |
| Outline Arrow up-right | Keep a visible action label: it opens another destination. |

Each constant's documentation states its rule. In the opt-in index,
`RemixIconEntry.requiresLabel` is `true` for every glyph that requires a label,
and `RemixIconEntry.usage` carries the contract's notes, including the
contextual ones.

No glyph mirrors automatically in right-to-left layouts. Choose the left or
right glyph when the direction carries meaning.

## Catalogs

`package:remix_ui_icons/icons_index.dart` lists every glyph as a
`RemixIconEntry`, with its family, style, master, tags, and deprecated
aliases. It is not exported by the main library, because it refers to every
glyph and so keeps the whole font in a release build. Import it from
galleries and tests, not from application code.

## Migrating from 0.1.x

1.0 replaces the Radix Icons 1.3.2 glyphs of 0.1.x. Names with an exact
replacement are unchanged or remain as deprecated aliases until 2.0.0; the
rest are removed. [MIGRATION.md](MIGRATION.md) lists every 0.1.x name with its
replacement or closest [Lucide](https://pub.dev/packages/lucide_flutter) icon.

## Generation

The font, the Dart constants, and MIGRATION.md are generated from
`tool/icons/manifest.yaml` and the Vector UI masters. See
[`tool/icons/README.md`](tool/icons/README.md).

## License

BSD 3-Clause. The Vector UI drawings are BSD 3-Clause, Copyright (c) 2026,
Leo Farias; see [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
