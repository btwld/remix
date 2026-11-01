## 1.0.0-beta.1

The first 1.0 pre-release. It replaces every glyph, so it is a new major
version: `^0.1.0` constraints do not resolve it. Stable `0.1.0` stays
published.

### Breaking changes

- The Radix Icons 1.3.2 glyphs are replaced by the Vector UI pack. The font
  family is still `RemixIcons`, but every drawing is new, and so is every
  codepoint: glyphs start at `0xE200`, and the 0.1.x range `0xE000`–`0xE13D` is
  reserved and never reused.
<!-- generated:1.0.0:begin -->
- 360 glyphs: 48 concepts in Outline (48), Rounded (12), each in outline and filled styles at native 24, 16, and 12 px masters.
- Of the 318 0.1.x names, 27 are unchanged, 19 are deprecated aliases until 2.0.0, and 272 are removed (25 partial matches, 247 with no match). [MIGRATION.md](MIGRATION.md) lists every name with its replacement or closest Lucide icon.
<!-- generated:1.0.0:end -->
- `remixIconsByName` is replaced by `remixIconEntries` in
  `package:remix_ui_icons/icons_index.dart`. Each entry adds the family,
  style, master, tags, deprecated aliases, and whether the glyph needs a
  visible label.

The renamed 0.1.x names still compile, as deprecated aliases of their
replacements, until 2.0.0:

<!-- generated:1.0.0-aliases:begin -->
| 0.1.x name | Use instead |
| --- | --- |
| `RemixIcons.arrowTopRight` | `RemixIcons.arrowUpRight` |
| `RemixIcons.barChart` | `RemixIcons.chart` |
| `RemixIcons.chatBubble` | `RemixIcons.chat` |
| `RemixIcons.cross1` | `RemixIcons.close` |
| `RemixIcons.cross2` | `RemixIcons.close` |
| `RemixIcons.dotsHorizontal` | `RemixIcons.more` |
| `RemixIcons.exclamationTriangle` | `RemixIcons.warning` |
| `RemixIcons.hamburgerMenu` | `RemixIcons.menu` |
| `RemixIcons.infoCircled` | `RemixIcons.info` |
| `RemixIcons.link1` | `RemixIcons.link` |
| `RemixIcons.link2` | `RemixIcons.link` |
| `RemixIcons.lockClosed` | `RemixIcons.lock` |
| `RemixIcons.magnifyingGlass` | `RemixIcons.search` |
| `RemixIcons.mixerHorizontal` | `RemixIcons.sliders` |
| `RemixIcons.pencil1` | `RemixIcons.edit` |
| `RemixIcons.pencil2` | `RemixIcons.edit` |
| `RemixIcons.person` | `RemixIcons.user` |
| `RemixIcons.questionMarkCircled` | `RemixIcons.help` |
| `RemixIcons.reload` | `RemixIcons.refresh` |
<!-- generated:1.0.0-aliases:end -->

### Features

- `OutlineIcons`, `RoundedIcons`, and `MonoIcons` hold each family's glyphs.
  The bare name is the outline style at the 24 px master; `Filled`, `16`, and
  `12` suffixes select the other style and masters, as in `searchFilled16`.
- `RemixIcons` is the default: every `OutlineIcons` glyph under the same name,
  plus the deprecated 0.1.x aliases.
- `package:remix_ui_icons/sized.dart` (opt-in) adds `RemixIconSet` and the
  `OutlineIconSets`, `RoundedIconSets`, and `MonoIconSets` constants, whose
  `at(size)` picks the master for a size at runtime.
- Every constant's documentation shows its drawing and the design contract's
  usage notes. Labels are required per family and master: Warning everywhere,
  the Mono Star and Rounded Branch at every size, and Outline Help, Branch,
  and Focus, Rounded Link, and Mono Link and Branch at 12 px. Mono Search
  carries contextual guidance. `RemixIconEntry` reports them as
  `requiresLabel` and `usage`.

## 0.1.0

- Initial release with the complete 318-glyph Radix Icons 1.3.2 catalog as
  tree-shakable Flutter `IconData` constants.
