# Remix CLI Reference

Keeping installed source current, and projects from earlier prereleases.
Commands assume `remix_cli` is a dev dependency.

## Move a registry pin

```bash
dart run remix_cli:remix registry update @remix                  # move to the newest promoted commit
dart run remix_cli:remix registry update @remix --ref <sha|branch>
dart run remix_cli:remix add theme button --diff                 # review what changed
dart run remix_cli:remix add theme button --overwrite            # adopt the new source
```

`registry update` only rewrites the pin in `remix.yaml`; it never touches
installed files. `--overwrite` rewrites only the items named on the command
line — installed dependencies, including `theme`, are always kept as they
are, customized or not. Name every item that should refresh, review with
`--diff`, then adopt with `--overwrite`; there is no automatic merge.
`--diff` always shows your own local edits, whether or not the template
moved — read the hunks, not the exit state. Rolling back is
`git checkout remix.yaml`, which restores the pin but not installed source.

## Projects from an earlier prerelease

`remix.yaml` schema 3 is the only readable configuration; an older file fails
to read with an explicit error. Recover a schema 1 or 2 project by deleting
`remix.yaml`, running `remix init` again with its old `--prefix`/`--preset`/
`--ui-path`, then verifying the installed source's provenance before adoption.

CLI 0.1.0 and beta.0 also wrote schema 3 without target ownership. The current
CLI rejects unknown existing targets before mutation, including `--diff` and
`--dry-run`. After verifying their source, name every existing dependency
explicitly when adopting. For Vanilla Button, that is Theme and Button. Fortal
Button also needs `base_button` when its targets already exist:

```bash
dart run remix_cli:remix add theme button --adopt --diff
dart run remix_cli:remix add theme button --adopt
```

Adoption preserves authored edits and records provenance in
`remix.ownership.json`; commit it with configuration and source. Disjoint
additions remain supported. A known different owner is rejected in every mode,
even `--overwrite` and `--adopt`. An old CLI does not enforce these reservations;
use the upgraded project-local CLI consistently.

The ownership record also binds the prefix, preset, and UI path. If those no
longer match, restore the matching configuration, ownership record, and source.
Renaming identifiers or deleting installed files does not release reservations.
For an intentional context change, initialize a clean installation in a separate
app and reapply edits; do not relabel the ownership record.

## Install from another registry

A project registers another registry under a namespace and names its items
explicitly:

```bash
dart run remix_cli:remix registry add @acme --repository acme/design-system --path registry --ref stable
dart run remix_cli:remix add @acme/button
```

The registry must offer the project's preset, or `registry add` fails. Install
a design-system registry's items instead of, not alongside, the official
items that own the same files (`theme`, the components it replaces). Overlaps
are rejected across separate installs as well as within a single request.
Additive registries with disjoint targets may compose with existing items.

## Choose an icon library

Registry templates resolve icon placeholders from an optional `remix.yaml`
setting:

```yaml
iconLibrary: lucide # remix (default) or lucide
```

The CLI adds `lucide_flutter` instead of `remix_ui_icons` when it is selected.
The choice applies at install. In Vanilla and Fortal four items use icons
(`icons`, `dashboard_shell`, `dashboard_demo`, `support`); in HeroUI three do
(`breadcrumbs`, `close_button`, `search_field`) and there is no `icons` item.
To switch an installed project, change the setting and reinstall every one of
them you have, in one command; `--overwrite` rewrites only the items named:

```bash
remix add icons dashboard_shell dashboard_demo support --diff       # Vanilla, Fortal
remix add icons dashboard_shell dashboard_demo support --overwrite
remix add breadcrumbs close_button search_field --diff              # HeroUI
remix add breadcrumbs close_button search_field --overwrite
```

Icons referenced in application code are not rewritten. The CLI that
resolves these placeholders ships before a registry that uses them.
