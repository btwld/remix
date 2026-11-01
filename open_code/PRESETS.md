# Presets: application-owned source

The living preset contract is now in
[REGISTRIES.md](REGISTRIES.md#preset-and-generation-contract), including
one-preset ownership, scoped code generation and fixed-filename exceptions.

Rationale: [One analyzed authoring tree](../ARCHITECTURE.md#one-analyzed-authoring-tree-fortal-adr-0002).
Usage: [Install and customize source](README.md).
Workspace consumers: [REGISTRIES.md](REGISTRIES.md#repository-consumers).

For a new first-party design language, follow [Adding a preset](ADDING_PRESETS.md):
source pinning, appearance evidence, and builder, consumer, and CI integration.
The checkout derives `vanilla`, `fortal`, and `heroui`; the served stable index
gains a new preset only after registry promotion.

`open_code/heroui_fixture` is the installed-source gallery for HeroUI. Run the
consumer checker with `--preset heroui --source checkout --keep`; the retained
app uses the `Acme` prefix. Worksheets live in `registry_source/specs/heroui/`
and upstream evidence in `registry_source/reference/heroui_3_2_6/`.
