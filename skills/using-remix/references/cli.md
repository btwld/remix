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
`--ui-path`, then re-adopting installed source with `add <item> --diff`.

## Install from another registry

A project registers another registry under a namespace and names its items
explicitly:

```bash
dart run remix_cli:remix registry add @acme --repository acme/design-system --path registry --ref stable
dart run remix_cli:remix add @acme/button
```

The registry must offer the project's preset, or `registry add` fails. Install
a design-system registry's items instead of, not alongside, the official
items that own the same files (`theme`, the components it replaces).
