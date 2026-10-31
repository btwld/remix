# Presets: application-owned source

The living preset contract is now in
[REGISTRIES.md](REGISTRIES.md#preset-and-generation-contract), including
one-preset ownership, scoped code generation and fixed-filename exceptions.

Rationale: [One analyzed authoring tree](../ARCHITECTURE.md#one-analyzed-authoring-tree-fortal-adr-0002).
Usage: [Install and customize source](README.md).
Workspace consumers: [REGISTRIES.md](REGISTRIES.md#repository-consumers).

For a new first-party preset, follow [Adding a preset](ADDING_PRESETS.md). The
checkout derives `vanilla`, `fortal`, and `heroui`; the stable registry serves a
new preset only after promotion.

HeroUI's installed-source review gallery is `open_code/heroui_fixture`. Run
`dart run tool/check_open_code.dart --preset heroui --source checkout --keep`
to retain an `Acme` consumer. Worksheets live in
`registry_source/specs/heroui/` and evidence in
`registry_source/reference/heroui_3_2_6/`.
