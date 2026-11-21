# Upgrade an existing install across the #511 registry renames

[Registry cutover #511](https://github.com/btwld/remix/pull/511) renamed the
items and files below. Fresh installs need no migration. An existing app can
hit the rename without asking for it: `add search_field`, for example, pulls
in `text_field` as a dependency. The two text field files expose the same
public names, so keeping both exports breaks consumers of `ui.dart`.

Paths below are relative to `paths.ui` in `remix.yaml` (`lib/ui` by default).

| Preset | Old item and files | New item and files |
| --- | --- | --- |
| Vanilla, Fortal, HeroUI | `textfield`: `components/textfield.dart`, `components/textfield.g.dart` | `text_field`: `components/text_field.dart`, `components/text_field.g.dart` |
| HeroUI only | `textarea`: `components/textarea.dart`, `components/textarea.g.dart` | `text_area`: `components/text_area.dart`, `components/text_area.g.dart` |

Vanilla and Fortal did not have a separate `textarea` item; their text field
item still provides both widgets.

## Back up and move the pin

1. On a migration branch, save a checkpoint of `remix.yaml`,
   `remix.ownership.json`, `ui.dart`, installed source and adapters, the app's
   code, and dependency and build files. Back up untracked edits too. If
   installed source you want to keep is unrecorded, use
   [legacy adoption](REGISTRIES.md#existing-source-without-an-ownership-record)
   at the old pin before moving it. If you already moved the pin, restore the
   old pin for adoption.
2. Move only the official registry pin. The SHA below is the exact #511
   cutover; use `--ref registry-stable` instead to target a later promoted
   revision. These examples use `@remix`; substitute your namespace if you
   registered the official registry under another name.

   ```shell
   remix registry update @remix --ref 6667e18693b7c3f40e390183e78c9dfce2aba07d
   ```

   `registry update` does not modify installed source. With the migration
   check, `remix add @remix/text_field --diff` reports obsolete managed exports
   or ownership entries before writing anything. `--dry-run` reports the same
   error; `--overwrite` and `--adopt` do not bypass it.

## Remove only the obsolete files, exports, and reservations

These steps apply only to the retired Remix items. If a file at one of these
paths is recorded as belonging to another item, keep it and its export.

1. Once your edits are backed up, remove the old `.dart` file and its
   `.g.dart` adapter. The installer regenerates the adapter at the new path.
2. In `ui.dart`, remove `export 'components/textfield.dart';` and, for HeroUI
   if installed, `export 'components/textarea.dart';`. Keep both
   `remix_cli:exports` markers and every unrelated export. Update any
   app-owned barrels that also exported the old files.
3. In `remix.ownership.json`, remove only those old `.dart` and `.g.dart` keys
   from `targets`. For example, the old Vanilla authored file is recorded as
   `"lib/ui/components/textfield.dart": "btwld/remix/registry#vanilla/textfield"`.
   Confirm the listed owner matches the old item before removing a key. If
   the old item has no entries, skip this step. Do not rename ownership keys
   or remove unrelated reservations.
4. If you installed `dashboard_demo`, also remove the managed exports under
   `recipes/dashboard/` for `dashboard_demo.dart`, `dashboard_overview.dart`,
   and `dashboard_sample_data.dart` (Vanilla and HeroUI) or
   `dashboard_demo_data.dart` (Fortal). These files and their ownership stay
   in place; only their barrel exports changed. Keep the `dashboard_shell`
   export. Import `recipes/dashboard/dashboard_demo.dart` for the widget.
   If you keep the pre-#511 demo source, import constructor types defined in
   the data file directly from `dashboard_demo_data.dart` (Fortal) or
   `dashboard_sample_data.dart` (Vanilla and HeroUI); the old demo does not
   re-export them. Import `dashboard_overview.dart` directly if you use it.

## Reinstall and verify

1. Before installing, update direct imports and exports in app-owned code
   and installed dependents to the new filenames. Check `search_field`,
   `combobox`, `composer_recipe`, and `dashboard_demo`, among others, for old
   imports and any other [API changes in #511](https://github.com/btwld/remix/pull/511#compatibility).
   A plain `add` keeps installed authored files, including dependencies. If
   you prefer to refresh those files instead of patching them, preview and
   explicitly include all affected installed items in the same `add`, then
   run it with `--overwrite` and reapply their saved edits. The installer
   analyzes the UI tree, so it cannot leave old imports for a later refresh.
2. Preview, then install the replacements from the new pin. For HeroUI, add
   `@remix/text_area` to both commands if you installed the old area item,
   so both replacements arrive before analysis.

   ```shell
   remix add @remix/text_field --diff
   remix add @remix/text_field
   ```

3. Compare the saved authored files with the replacements and reapply your
   edits; do not copy the old files or `part` directives back.
4. Check that `ui.dart` exports each replacement once, with no old export,
   and that the ownership record reserves the new authored files and
   adapters. Run `flutter analyze` and `flutter test`, then commit the pin,
   ownership, source, generated adapters and any dependency updates together.
   If you pinned the cutover SHA, future updates need `--ref registry-stable`
   to resume following that branch.

To roll back, restore the whole checkpoint: the old pin, ownership record,
barrel, authored and generated source, and any dependency, build, or app
changes. Remove new files introduced by the migration, restore saved local
edits, and run `flutter pub get` and the app checks again. Restoring only
`remix.yaml` does not restore installed source.
