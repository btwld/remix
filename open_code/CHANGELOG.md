# Remix registry changelog

Registry revisions ship independently of pub.dev packages. `remix` 1.0.0-rc.6
and `remix_cli` 1.0.0-rc.2 are published. The `registry-stable` promotion at
`81b9c0ae` includes the dependency floors below; the preset sidebar update
merged in the following revision, `987c7aa9`.

## Since Remix 1.0.0-rc.5

### Breaking Changes

Names below use the preset prefixes. Apply the same changes with your configured
prefix. Installed source belongs to the app and is not rewritten by repinning.

| Preset | Previous name or API | Migration |
| --- | --- | --- |
| All | `textfield` item, `components/textfield.dart`, and `components/textfield.g.dart` | Use `text_field`, `components/text_field.dart`, and `components/text_field.g.dart`. The widget class name is unchanged. (#511) |
| HeroUI | `textarea` item, `components/textarea.dart`, and `components/textarea.g.dart` | Use `text_area`, `components/text_area.dart`, and `components/text_area.g.dart`. The widget class name is unchanged. Vanilla and Fortal still install their text area with `text_field`. (#511) |
| All | `dashboard_demo` exports from `ui.dart` | Import `recipes/dashboard/dashboard_demo.dart` directly for the demo. The updated demo re-exports its constructor types; if you keep the old source, import its data types from `dashboard_sample_data.dart` (Vanilla/HeroUI) or `dashboard_demo_data.dart` (Fortal). Import `dashboard_overview.dart` directly if needed. Remove the old demo, overview, and data exports from existing barrels; keep the files and the `dashboard_shell` export. (#511) |
| All | `resolveVanillaChartPalette`, `resolveFortalChartPalette`, `resolveHeroUiChartPalette` | Use `vanillaChartPalette`, `fortalChartPalette`, or `heroUiChartPalette`, respectively. (#511) |
| All | `Calendar.styleFrom` and `RangeCalendar.styleFrom` on the prefixed facades | Construct `CalendarStyler()` directly. (#511) |
| Fortal | `FortalKbdVariant.soft`, `FortalKbd.soft`, `FortalKbd.variant`, and `variant:` on `FortalKbd` and `fortalKbdStyle` | Use the default constructor and recipe without `variant:`. The sole look is unchanged. (#511) |
| Fortal | `FortalSegmentedControlVariant.surface`, `FortalSegmentedControl.surface`, `FortalSegmentedControl.variant`, and `variant:` on `FortalSegmentedControl` and `fortalSegmentedControlStyle` | Use the default constructor and recipe without `variant:`. The sole look is unchanged. (#511) |
| Fortal | `FortalComboboxSize`, `FortalComboboxVariant`, `FortalSurfaceSize`, `FortalTextAreaVariant` | Use `FortalTextFieldSize`, `FortalTextFieldVariant`, `FortalCardSize`, and `FortalTextFieldVariant`, respectively. `FortalTextAreaSize` stays separate. (#511) |
| Fortal | Instantiating, extending, or implementing `FortalTokens` | Use its static members; the class is now `abstract final`. (#511) |
| Fortal | `FortalAccentColor.calcadao` and the `calcadao` palette constant | Use `FortalAccentColor.orla` and `orla`, respectively. (#508) |
| Fortal | Computed theme helpers no longer re-exported by `theme/theme.dart` and `ui.dart` | Import `theme/computed.dart` directly for `buildFortalShadows`, `computeAccentIndicatorContrast`, `computeColorBackground`, `computeColorOverlay`, `computeColorPanelSolid`, `computeColorPanelTranslucent`, `computeColorSurface`, `computeControlBorder`, `computeFocus8`, `computeFocusA5`, `computeFocusA8`, `computeShadowStroke`, and `mixOklabPremultiplied`. (#508) |
| HeroUI | `HeroUiComboboxVariant` | Use `HeroUiTextFieldVariant`. (#511) |
| HeroUI | `HeroUiSwitchGroup.items` and `items:` | Use `options` and `options:`. (#511) |
| HeroUI | `HeroUiFieldLayout.axis` and `axis:` | Use `orientation` and `orientation:`. (#511) |
| Vanilla, Fortal | Treating `VanillaSearchField` or `FortalSearchField` as a `StatefulWidget` | Accept a `Widget` instead: the search field is now a `StatelessWidget`. Its constructors are unchanged; pass a `TextEditingController` or `FocusNode` to control the editor. (#497) |

With `remix_cli` 1.0.0-rc.2, `remix add` stops before writing if a replacement
would sit beside the retired item's managed export or ownership record. This
also applies to `--diff`, `--dry-run`, and installs that pull in the replacement
as a dependency. Follow the [rename migration guide](REGISTRY_511_MIGRATION.md):
back up local edits, remove only the retired item's files, exports, and ownership
entries, and update imports in app code and installed dependents **before**
reinstalling. Add the replacement item, or run `remix add text_field text_area`
if replacing both HeroUI items. Then reapply your edits. (#517, #535)

### Features

- HeroUI `CheckboxGroup` accepts `orientation: Axis.horizontal` for a wrapping
  layout. The existing vertical default and controlled selection are unchanged.
  (#520)
- Generated adapters forward optional `builder` on Vanilla accordion and tab,
  `triggerBuilder` and `transitionBuilder` on Vanilla disclosure,
  `semanticFormatterCallback` on Vanilla slider, and
  `semanticFormatterCallbacks` on all three presets' range sliders. (#510)
- All three presets now require `remix: ^1.0.0-rc.6`. That release exports
  `RemixSidebarLayout` and `RemixSidebarLayoutScope` for inline navigation
  that switches to a modal sheet below a configurable breakpoint. It also adds
  a `.wrap(WidgetModifierConfig)` constructor to 55 generated Remix stylers.
  (#531, #532, #533)
- Items with generated adapters now require `mix_generator: ^2.3.0` as a dev
  dependency. Regenerated adapters keep the widget key on the adapter instead
  of also passing it to the inner widget. In tests, `find.byKey` finds the
  adapter; use a descendant finder for the child. (#532)

### Fixes

- In all three `sidebar_layout` recipes, an open compact sheet picks up host
  rebuilds without replacing its route or losing sidebar state. The recipes use
  `RemixSidebarLayout` but keep their constructor parameters and defaults.
  `VanillaSidebarLayoutScope`, `FortalSidebarLayoutScope`, and
  `HeroUiSidebarLayoutScope` still expose `openCompact()` and `closeCompact()`.
  (#534)
- HeroUI theme dependents, including nested dark scopes, pick up color changes
  when the host edits the same `HeroUiThemeData.colors` map and rebuilds. (#514)
- In Vanilla and Fortal search fields, an Escape press that starts during active
  composition stays with the input method through release. A fresh Escape in a
  read-only field can dismiss its dialog; in Vanilla a collapsed composing range
  no longer prevents Escape from clearing an editable, nonempty query. (#497)
- A custom prefix changes recipe identifiers, IDs, and marked code references
  without changing paths or brand prose such as “Fortal-inspired”. Dependencies
  from every branch of a conditional import or export are included, not just
  the default branch. (#509, #516)
- Dim disabled Fortal tabs, remove extra Agent disclosure padding, keep expanded
  HeroUI Agent triggers left-aligned, and keep the Agent scroll-to-latest button
  opaque in all presets. (#510)
- Clean up Fortal theme and dashboard copy, including palette provenance and the
  demo API-key placeholder. (#508)
- Vanilla `date_picker` and `date_range_picker` install `date_picker_styles`
  without exporting it from `ui.dart`. Caller overrides still win, and a
  standalone `calendar` install does not need the helper. (#518)
- Fortal deprecates five tokens without changing their values: `transitionFast`,
  `transitionSlow`, `planMaxHeight`, `messageAvatarSize`, and
  `composerFieldMinHeight`. Use app-owned durations or sizes instead. (#521)
- The CLI's multi-item help example uses `remix add button card checkbox`,
  which works with all three official presets. (#519)
- A new app still starts from `registry-stable`. If the branch is missing,
  promotion can recreate it after validating the candidate with the published
  CLI; `remix init` itself does not fall back to `main`. (#507, #512)
- Checkout validation checks that each catalog item installs its imports,
  exports, generated adapters, and direct runtime dependencies. The preset
  builder refactor leaves the shipped catalogs and templates unchanged. (#515, #522)
