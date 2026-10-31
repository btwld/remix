# Tutorial assets

These assets belong to [the settings tutorial](../../tutorials/settings-screen.mdx).
Git history preserves the retired standalone presentation.

## Samples and evidence

`sample-projects.zip` contains the complete default and Fortal projects.
Its README explains the local checkout paths and run commands. The app expands
its four source panels directly from the archive, so inline code and downloads
cannot diverge. Do not maintain additional copies of those Dart files.

Screenshots contain actual application/editor captures. `evidence.json` records
the capture checkout, toolchain, image hashes, archive hash, and source hashes.
Keep captions and capture context accurate; these are not new captures.
`code-evidence.json` records the approved MDX command/first-render blocks from
the content review at `3c63fe44f`. Update evidence only after reviewing a real
source change, never merely to bypass a failing check.

Run `python3 tool/check_tutorial_assets.py` from the repository root, or run
`fvm dart run melos run docs:check` for the full documentation gate and tests.
These checks do not replace a fresh Flutter replay when the samples or CLI change.

On 2026-09-12, the downloadable apps moved to `WidgetsApp` with a Navigator.
Their workflow tests also assert the neutral host. Source and archive hashes
record that revision; the screenshot hashes and original capture checkout remain
unchanged. Those screenshots predate the host migration.
