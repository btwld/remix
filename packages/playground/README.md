# Remix playground and Fortal specimens

The default playground route is the live Fortal specimen viewer. It renders
the production catalog from `lib/specimens/fortal_catalog.dart`; golden tests
import that same catalog, so live and captured sheets cannot drift.

Deep-link a sheet with:

```text
/?specimen=button&theme=fortal-dark
```

Invalid IDs are canonicalized to the first declared specimen or theme. Missing
parameters use those defaults without adding query-string clutter. Existing
direct previews still take precedence through `--dart-define=COMPONENT=...` or
`?component=...`.

## Using another Remix-based design system

Define a production-owned `SpecimenCatalog` under that package's `lib/` tree:

1. Declare its theme wrappers as `SpecimenTheme` values.
2. Declare generic row axes and stable IDs for each public component.
3. Resolve the design system's Mix styles in each cell and pass the resulting
   pre-resolved spec through the component's `styleSpec` parameter.
4. Launch `SpecimenCatalogViewer(catalog: yourCatalog)`.
5. Register the same catalog with `registerSpecimenCatalogGoldens` in tests.

No Fortal or Remix catalog knowledge belongs in `mix_specimen`.

## AI inspection

Start at `test/goldens/catalog.json`, follow a sheet's `metadata` reference to
its JSON sidecar, then open the referenced PNG. The sidecar records stable IDs,
labels, row axes, declared row/scenario order, forced widget states, and props.
Viewer deep links are supplemental browser evidence; PNG + sidecar artifacts
remain the deterministic review source.
