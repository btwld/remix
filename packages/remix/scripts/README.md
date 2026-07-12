# Remix Scripts

This directory contains development utilities for the Remix Flutter package.

## Component API documentation

`generate_style_docs.dart` is intentionally disabled. Its legacy syntax-only
parser predates the Remix 1.0 `*Styler` APIs, does not resolve inherited Mix
methods, and writes directly over everything after each component page's
`## Properties` heading. Running it against the 1.0 sources can therefore
remove valid documentation.

Maintain `docs/components/*.mdx` manually for now. Validate documentation
changes with:

```bash
fvm dart doc --dry-run .
fvm flutter analyze --fatal-infos
```

A replacement should resolve analyzer elements rather than hard-code Mix
source paths, render into a temporary directory, preserve hand-authored
sections, and support a read-only `--check` mode before it is allowed to write.
