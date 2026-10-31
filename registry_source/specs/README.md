# Specifications and Agent worksheets

[Vanilla](vanilla.md) and [Fortal](fortal.md) own their shipped visual
contracts. Use those specifications and the authored recipes for current
measurements; the presets need not share dimensions.

[`heroui/`](heroui/) owns the HeroUI token inventory and component worksheets,
checked by `tool/heroui_parity/check.dart`.

## Benchmark versus contract

The eight files in `components/` record Agent anatomy and behavior benchmarks.
Their `recipe_measurements` explain where slots came from; they are **not
acceptance dimensions for shipped presets**. A worksheet difference alone does
not justify changing installed visuals.

Shared behavior lives in `lib/src/agent`; styles live in
`lib/src/{default,fortal}/recipes`. Keep benchmark citations intact when a
preset deliberately differs. Architecture rationale lives in
[the decision log](../../ARCHITECTURE.md#agent-behavior-separate-from-preset-appearance-agent-adr-0001).

## Change and verification

- Fix behavior in Agent source and appearance in the owning preset recipe.
- Merge caller overrides last; keep child-control stylers unresolved until
  the child renders its own interactive state.
- Derive with `dart run tool/build_registry.dart`, reinstall affected items,
  and run registry/consumer checks plus the relevant recipe/consumer tests.
- Do not hand-edit templates or consumer mirrors, or rewrite benchmarks to
  claim reference parity. A parity redesign needs an explicit visual contract.

[Installed recipe tests](../../open_code/fixture/test/agent_recipe_contract_test.dart)
exercise overrides and child states; behavioral coverage does not establish
pixel equivalence to reference worksheets.
