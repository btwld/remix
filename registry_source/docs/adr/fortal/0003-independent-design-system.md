# 0003 — An independent Fortal design system

Status: accepted. Date: 2026-10-29.

## Decision

The Fortal Refresh brief replaces the former Radix Themes visual-parity
contract. Keep the registry architecture from 0002, the existing Remix/Naked UI
behavior, twelve fixed-role steps, theme radius/scaling/appearance options,
high contrast, Geist, and the independent Remix Icons package.

Use our own deterministic OKLCH generator and seven city-named palettes.
Calçadão is the default accent, sole gray, and step-1 page background. Mar is
the signature accent, not the default. Surface fields become filled; panels
default to solid. Remove the twelve classic control/card/inline variants in
one step, without migration aliases, since Fortal is unreleased.

The brief is the design source. `specs/fortal.md` and `fortal_catalog.json`
are the maintained contract; contrast tests and Fortal-owned widget/golden
tests replace external fixtures. Delete the old gate only after these pass.
Equal lightness applies to common background/border/text stops; seed-led
solid fills are an explicit exception so neutral basalt, yellow Sol, and
sand Duna retain their identities while meeting text contrast.

## Consequences

Fortal can evolve without upstream exceptions. Apps can generate a custom
brand palette from one seed and supply it to the theme without enum aliases.
Visual changes ship through registry promotion after reviewed merge to main;
registry-only changes require no runtime/CLI package version bump.
Full Fortaleza branding, Anton, and cobogó patterns remain deferred.
