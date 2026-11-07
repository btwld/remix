# Maintaining Remix documentation

`docs/` owns content; `docs.json` owns navigation. [The docs app](../apps/docs/README.md)
renders it with the shared Concepta Fumadocs theme.

- Start/setup: `index.mdx` and `getting-started.mdx`.
- Workflows: `guides/styling-components.mdx`, `open-code/install.mdx`,
  `open-code/updating.mdx` and `tutorials/settings-screen.mdx`.
- Explanation: `open-code.mdx`.
- API references: `components/`, `agent/`, `fortal/`, `open-code/catalog.mdx`
  and `open-code/cli.mdx`, whose command and exit-code sections
  `dart run melos run docs:cli` regenerates from the CLI parsers.

The introduction/setup/styling content was adapted from `btwld/website` at
`fb1c11e928144ff8a6e4ad9df22bc55a268d064f`, not mirrored. Local package source
and the analyzer own API accuracy.

## Tutorial evidence

Full application and test panels use build-time `TutorialSource` includes from
`assets/remix-cli-tutorial/sample-projects.zip`. That directory serves only the
tutorial's PNG screenshots and the ZIP.

[`tool/replay_tutorial.py`](../tool/replay_tutorial.py) runs the tutorial's
commands with hosted packages on a real Flutter SDK. It regenerates the
screenshots, the ZIP, and [`tool/tutorial_evidence.json`](../tool/tutorial_evidence.json),
which `tool/check_tutorial_assets.py` verifies:

```bash
python3 tool/replay_tutorial.py --flutter "$(command -v flutter)"
```

Authored sample files (`lib/main.dart` and the tests) live in
`tool/tutorial_samples`. The replay copies them into the archive the docs
include. Edit the tutorial or an authored file, then rerun the replay.
Never hand-edit the evidence to pass a check.

The recorded hash of a tutorial command block ignores the version constraint of
a pinned `remix`, `remix_cli`, or `remix_ui_icons` install, so
`tool/sync_install_pins.dart` repinning on a release does not need a replay.
Any other change to the command does.

## Validation

With the pinned Flutter SDK and Python 3.9+:

```bash
fvm dart run melos run docs:check
```

The gate checks navigation, retired APIs, compilable snippets, catalog drift,
recorded tutorial evidence and selected local links. The tutorial check is not a
fresh replay; rerun the replay when application code or CLI behavior changes.
For site validation run `pnpm typecheck` and `pnpm build` in `apps/docs`.
