# Primary implementation references

Checked 24 September 2026. These inform the implementation; no external icon SVGs were downloaded or traced for the pilot additions.

- IBM Design Language, UI icon design: https://www.ibm.com/design/language/iconography/ui-icons/design/ — grids, padding, key shapes, fine adjustments, and avoiding crowding. Our native sizes and gap targets are project choices, not IBM compliance claims.
- W3C WAI-ARIA APG, Button Pattern: https://www.w3.org/WAI/ARIA/apg/patterns/button/ — accessible names, keyboard operation, and stable labels with aria-pressed.
- W3C WCAG, Non-text Contrast: https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html — required contrast for meaningful graphical controls and states; the guide is not a full conformance audit.
- Playwright Python, Continuous Integration: https://playwright.dev/python/docs/ci — installing browsers/dependencies and running in GitHub Actions. We retain the tested 1.57.0 pin; this is not a claim to use the latest release.
- GitHub, Secure use reference: https://docs.github.com/en/actions/reference/security/secure-use — minimal workflow permissions and immutable action references. Final action SHA pinning remains a public-release gate.

The unresolved requested reference “idea icons” has no assumed source mapping. `catalog/reference-map.json` records that gap. Existing drawings came from the user-supplied v0.4.1 package; its byte hashes are preserved.
