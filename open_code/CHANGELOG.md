# Remix registry changelog

Registry revisions ship independently of pub.dev packages. These notes cover
the changes merged since Remix 1.0.0-rc.5; some are already available on
`registry-stable`.

## Next Promotion

### Breaking Changes

Names below use the preset prefixes. Apply the same changes with your configured
prefix. Installed source belongs to the app and is not rewritten by repinning.

| Preset | Previous name or API | Migration |
| --- | --- | --- |
| All | `textfield` item, `components/textfield.dart`, and `components/textfield.g.dart` | Use `text_field`, `components/text_field.dart`, and `components/text_field.g.dart`. The widget class name is unchanged. (#511) |
| HeroUI | `textarea` item, `components/textarea.dart`, and `components/textarea.g.dart` | Use `text_area`, `components/text_area.dart`, and `components/text_area.g.dart`. The widget class name is unchanged. Fortal's text area remains part of `text_field`. (#511) |
| All | `dashboard_demo` exports from `ui.dart` | Import `recipes/dashboard/dashboard_demo.dart` directly for the demo and its constructor types. Import `dashboard_overview.dart` or `dashboard_sample_data.dart` (Vanilla/HeroUI) or `dashboard_demo_data.dart` (Fortal) directly for other symbols. Remove those three old exports from existing barrels. `dashboard_shell` stays exported. (#511) |
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

For a renamed item, back up local edits, then remove the old authored and
generated files, the old `ui.dart` export, and their ownership records in
`remix.ownership.json`. Install the replacement with `remix add text_field`
or, for HeroUI, `remix add text_area`, update direct imports, and reapply local
edits. Installing a replacement alongside its old files leaves duplicate
declarations.

### Features

- HeroUI `CheckboxGroup` accepts `orientation: Axis.horizontal` for a wrapping
  layout. The existing vertical default and controlled selection are unchanged.
  (#520)
- Generated adapters forward optional `builder` on Vanilla accordion and tab,
  `triggerBuilder` and `transitionBuilder` on Vanilla disclosure,
  `semanticFormatterCallback` on Vanilla slider, and
  `semanticFormatterCallbacks` on all three presets' range sliders. (#510)

### Fixes

- Preserve preset names in prose and paths while substituting consumer prefixes
  in template identifiers and IDs. (#509)
- Dim disabled Fortal tabs, remove extra Agent disclosure padding, keep expanded
  HeroUI Agent triggers left-aligned, and keep the Agent scroll-to-latest button
  opaque in all presets. (#510)
- Clean up Fortal theme and dashboard copy, including palette provenance and the
  demo API-key placeholder. (#508)
- Share Vanilla date-picker panel width and styling through a private dependency
  of `date_picker` and `date_range_picker`, without changing public exports,
  caller overrides, or a standalone `calendar` install. (#518)
- Allow the released-CLI compatibility check to bootstrap a missing
  `registry-stable` from the candidate SHA, and document promotion, rollback,
  and release logging. (#507, #512)
