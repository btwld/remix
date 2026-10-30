# Maintaining Remix documentation

`docs/` owns content; `docs.json` owns navigation. [The docs app](../apps/docs/README.md)
renders it with the shared Concepta Fumadocs theme.

- Start/setup: `index.mdx` and `getting-started.mdx`.
- Workflows: `guides/styling-components.mdx`, `open-code.mdx` and
  `tutorials/settings-screen.mdx`.
- API references: `components/`, `agent/` and `fortal/`.

The introduction/setup/styling content was adapted from `btwld/website` at
`fb1c11e928144ff8a6e4ad9df22bc55a268d064f`, not mirrored. Local package source
and the analyzer own API accuracy.

## Tutorial evidence

Full application/test panels use build-time `TutorialSource` includes from the
checked sample ZIP. Keep screenshots, licenses and capture pins under
[assets/remix-cli-tutorial](assets/remix-cli-tutorial/README.md); that README owns
evidence rules. Do not maintain a second tutorial or relabel historical captures.

## Validation

With the pinned Flutter SDK and Python 3.9+:

```bash
fvm dart run melos run docs:check
```

The gate checks navigation, retired APIs, compilable snippets, catalog drift,
recorded tutorial evidence and selected local links. Recorded tutorial snippets
are not a fresh app replay; replay samples when application code or CLI behavior
changes. For site validation run `pnpm typecheck` and `pnpm build` in `apps/docs`.
