# Vector UI icon families

Private review pack for two sibling families:

| Family | Icons | SVGs | Construction |
| --- | --- | --- | --- |
| Outline | 77 | 462 | Validated Outline geometry, outline and filled, native 12 / 16 / 24 |
| Rounded | 77 | 462 | Rounded primitives (circles, stadiums, round joins), not an Outline path filter |

The families are **Outline** and **Rounded**.
The appearance names `outline` and `filled` are unchanged.

Shared comparison surface: [`catalog/index.html`](catalog/index.html). It shows Outline and Rounded together, including every Warning cell.

This directory is the source pack. `package.json` is `"private": true`. The license is BSD 3-Clause, copyright Leo Farias. Do not publish it to npm or pub.dev.

`packages/remix_ui_icons` compiles the generated SVG masters of both families into its Flutter icon font, from `packages/remix_ui_icons/tool/icons/manifest.yaml`. Edit drawings here and regenerate that package; never edit its font or Dart constants by hand. A changed, added, or removed master changes the package's API and its codepoint lock, so it needs a package release.

## Warning

Warning requires a visible text label at every native size (12, 16, and 24) and both appearances (outline and filled), in every family, including scaled uses of those masters. A tooltip or accessible name is not a substitute. Gap exceptions do not lift the rule.

Each family's `catalog/exceptions.json` lists active departures from its geometry
rules. Measurements that meet their target belong in ordinary geometry checks,
not the active exception register. Removing a resolved entry does not approve
the design or change a visible-label restriction.

## Build and check

Pinned for this pack: CPython 3.13, Shapely 2.1.2, CairoSVG 2.8.2.

```sh
cd design/icons
python3.13 -m venv .venv
. .venv/bin/activate
python -m pip install -r requirements.txt -r outline/requirements-dev.txt
python -m playwright install --with-deps firefox
python build.py
python tools/run_checks.py
```

`build.py` runs each family's own `source/build.py`, then writes `catalog/index.html`. Family constructors are not shared.

`tools/run_checks.py` runs the pack tests and the Outline and Rounded suites, including Firefox computed-style and raw-renderer boundary regressions. Full browser navigation and certification are separate. The maintained root `vector-ui-icons.yml` workflow runs assets and full Chromium, Firefox, and WebKit checks; reports and captures are external ephemeral evidence, configured with `VECTOR_UI_EVIDENCE_DIR`.

## Where the geometry came from

The drawings were recovered from closed, unmerged pulls and rebuilt as one pack:

- Outline `#244`, `5bcaa375a1b35d23ffc480a05f752fb72945b6d0`
- Rounded `#254`, `c7bdf16848f15d22d4c49115c9399bd73c58aa3f`

Family READMEs describe their maintained construction and usage contracts. Use this file for the combined pack.

## Review and publication

The families have matching product coverage: 77 concepts, each with both
appearances at 12, 16, and 24 px (924 drawings in total). Native-size and
application-context review accompany the compiled Flutter package release.
Label requirements and measured geometry exceptions remain part of the contract;
agent review does not substitute for a human recognition study.

The private authoring pack and its web adapters are separate from the compiled
Flutter package. The authoring pack's web publication gate remains closed until
its own acceptance requirements are met. Historical package identifiers, sprite
IDs, fixture keys and review records retain their compatible spellings.

The archived browser capture `outline/review/pilot-additions.png` predates the
current shape revisions. Use the rebuilt catalogs and native proofs to review
the current drawings.
