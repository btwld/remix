# ADR 0001 — Retain the private Fortal authoring package

Date: 2026-09-14. Status: superseded by [ADR 0002](0002-registry-source.md) — the
trigger below fired and the source moved to `registry_source/lib/src/fortal`.

## Historical decision

The decision retained `remix_fortal` as a private workspace authoring and
parity-test package. Consumers received derived, application-owned source from
the Fortal registry, not a new published dependency. This followed the ownership
direction in [the clean-sheet decision](../../../../open_code/CLEAN_SHEET.md)
and [the Fortal preset decision](../../../../open_code/PRESETS.md).

At the time, a directory-only authoring layout did not improve the installed
consumer contract enough to justify moving source during Agent integration.

## Cost and reconsideration trigger

At this decision, 78 Dart files under app `lib/` directories imported the
package: 39 in demo, 30 in dashboard, and 9 in playground. A migration needed to
retarget imports, preserve generated output and parity fixtures, update workspace
and build configuration, and retain one authoring source for derivation. Those
counts measured import sites, not estimated engineering effort.

The trigger for reconsideration was a demonstrated maintenance problem, such as
duplicate source ownership or blocked consumer adoption, together with a concrete
migration showing lower ongoing cost. Matching a directory shape alone was not
sufficient. ADR 0002 records why that trigger was subsequently met.

## Lasting rationale

Authoring tests and Radix parity checks remain useful independently of the
source directory. Private authoring source and workspace imports do not imply a
hosted release. The supported authoring and distribution contract is now ADR
0002; this superseded decision does not prescribe a package-retention or migration
step for current work.
