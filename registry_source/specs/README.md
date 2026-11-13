# Specifications and Agent worksheets

[Vanilla](vanilla.md) and [Fortal](fortal.md) own their shipped visual
contracts. Use those specifications and the authored recipes for current
measurements; the presets need not share dimensions.
[`heroui/`](heroui/) holds HeroUI's token inventory (`tokens.json`) and component
worksheets, checked by `tool/heroui_parity/check.dart`.

## Benchmark versus contract

The eight files in `components/` preserve the previous registry Agent anatomy
and behavior benchmarks. Their old API names are historical; see the
[migration guide](../../docs/agent/migrating.mdx) for current widgets.
Their `recipe_measurements` explain where slots came from; they are **not
acceptance dimensions for shipped presets**. A worksheet difference alone does
not justify changing installed visuals.

Shared behavior now lives in experimental `package:remix/agent.dart`; styles
live in `lib/src/{default,fortal,heroui}/recipes`. Keep benchmark citations intact when a
preset deliberately differs. Architecture rationale lives in
[the decision log](../../ARCHITECTURE.md#agent-behavior-separate-from-preset-appearance-agent-adr-0001).

## Change and verification

- Fix behavior in `packages/remix/lib/src/agent` and appearance in the owning
  preset recipe.
- Merge caller overrides last; keep child-control stylers unresolved until
  the child renders its own interactive state.
- Derive with `dart run tool/build_registry.dart`, reinstall affected items,
  and run registry/consumer checks plus the relevant recipe/consumer tests.
- Do not hand-edit templates or consumer mirrors, or rewrite benchmarks to
  claim reference parity. A parity redesign needs an explicit visual contract.

[Installed recipe tests](../../open_code/fixture/test/agent_recipe_contract_test.dart)
exercise overrides and child states; behavioral coverage does not establish
pixel equivalence to reference worksheets.
