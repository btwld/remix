# Tutorial assets

These assets belong to [the settings tutorial](../../tutorials/settings-screen.mdx).
Git history preserves the retired standalone presentation.

## Samples and evidence

`sample-projects.zip` contains the complete default and Fortal projects.
Its README explains the local checkout paths and run commands. The documentation build expands
its four source panels directly from the archive, so inline code and downloads
cannot diverge. Do not maintain additional copies of those Dart files.

Screenshots contain actual application/editor captures. `evidence.json` records
the capture checkout, toolchain, image hashes, archive hash, and source hashes.
Keep captions and capture context accurate. The September 7 JPGs are historical
captures; the October 31 PNGs are new captures with separate provenance.
`code-evidence.json` records the current MDX command/first-render blocks.
Git history retains the original content review at `3c63fe44f`. Update evidence only after reviewing a real
source change, never merely to bypass a failing check.

Run `python3 tool/check_tutorial_assets.py` from the repository root, or run
`fvm dart run melos run docs:check` for the full documentation gate and tests.
These checks do not replace a fresh Flutter replay when the samples or CLI change.

On 2026-09-12, the downloadable apps moved to `WidgetsApp` with a Navigator.
Their workflow tests also assert the neutral host. That migration remains
recorded in the evidence history; current archive hashes describe the latest replay. The September JPG hashes
and original capture checkout remain unchanged; those JPGs predate the host
migration. October PNG hashes and host details are recorded separately.

## October 31 replay

The commands and downloadable projects now use checkout and registry revision
`2556203413520874c4e6d7682e8e1737f4b9f360`, Flutter 3.44.0, and Dart 3.12.0.
The real CLI installs Vanilla and Fortal recipes; Fortal uses the Mar palette.
The `default_demo` archive directory is retained, but its preset is `vanilla`.
Both samples pass analysis, their workflow/appearance tests, and release web
builds. The first-render source is compiled separately, and ordinary add is
checked to preserve the 44-pixel Vanilla recipe edit.

`current-default.png` and `current-fortal-dark.png` are actual Flutter
widget-test renderer captures at 1440×1000 with Geist and Material Icons loaded.
The capture host was macOS 27.0.1 (arm64; Flutter test engine x64).
They are not browser screenshots. Browser automation was disabled in Work
settings during this replay; release web builds were checked separately.
`capture_harness_sha256` identifies a local validation artifact (`capture_test.dart`)
retained by the maintainer; not published.
The original September JPGs retain their original bytes and capture provenance.
`evidence.json` keeps that capture checkout separate from `replay.source_checkout`.

`cli-source-evidence.json` receipts every `lib/ui` Dart file from two separate,
fresh public-CLI installs at the declared revision, before customization. The
checker compares the ZIP against those files, allowing only the documented
Vanilla 44-pixel Button edit. It also checks the archive, MDX registry commands,
SDK, CLI receipt, and replay pins together. Constructor drift cannot pass merely
by refreshing archive hashes or retaining a valid enum. To refresh receipts,
repeat clean CLI installs at the new pin and review all differences first.
