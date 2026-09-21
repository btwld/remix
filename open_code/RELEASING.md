# Release runtime, registry, and CLI independently

Use the reviewed merge commit as the candidate. Do not infer publication from
checkout version numbers. Runtime package publication, registry publication,
and CLI publication have separate gates. Publishing tags/releases is a release
operator action, not something the builder performs.

## Validate the candidate

With the pinned Flutter 3.44.0 SDK:

```shell
fvm flutter pub get
fvm dart run melos run ci
```

The registry builder and dependency-floor checkers now target `registry/`.
The CLI's bundled trees are frozen schema-1/2 compatibility snapshots, protected
by a separate byte-for-byte regression test. Do not regenerate those bundles
or move their dependency floors with a runtime release.

The isolated consumer checker injects a test-only transport for the committed
`registry/` distribution. It exercises schema 3, the real installer, package
resolution, generation, analysis and consumers without requiring unpublished
content on GitHub. This is not a local-registry feature of the shipped CLI.

## Publish the required runtimes first

Confirm every hosted dependency floor exists on pub.dev. Runtime releases use
the existing package publishing workflows. Remix uses `v<version>` for pub.dev
and `remix-v<version>` for Melos history. Runtime version preparation updates
the remote catalog floor and regenerates both remote presets.

Validate against hosted runtimes, without checkout substitution:

```shell
fvm dart run melos run open-code:release:check
```

## Publish the registry before the GitHub-first CLI

1. Commit generated `registry/index.yaml`, both catalogs, and all templates.
2. Tag the reviewed commit `registry-v1` for bootstrap, or the next unused
   stable `registry-v*` version for later releases.
3. Push that tag and require the **Validate registry release** workflow to pass.
   It checks generation drift, dependency constraints, CLI compatibility, and
   isolated Vanilla/Fortal installs against hosted runtimes.
4. Publish a non-draft, non-prerelease GitHub release for that tag. A tag alone
   is not discoverable by new-project initialization. The tag must read
   `registry-v<major>[.<minor>[.<patch>]]` — `remix init` skips anything else,
   so the release workflow rejects a tag it could not find.
5. Require the release-event smoke checks to pass. They resolve the published
   tag to a commit and read its actual GitHub index, catalogs and templates.

To repeat a published-revision check locally:

```shell
REMIX_REGISTRY_RELEASE_REF=registry-v1 fvm dart run tool/check_open_code.dart --source hosted
REMIX_REGISTRY_RELEASE_REF=registry-v1 fvm dart run tool/check_open_code.dart --preset fortal --source hosted
```

Normal component changes require only a registry release. The same CLI can
install the new release after an explicit `registry update`; existing pins do
not move. Keep schema compatibility with released CLI versions.

## Release the CLI only for installer changes

Before publishing, run `dart pub publish --dry-run` in `packages/remix_cli` and
confirm its archive retains both frozen compatibility bundles. Update its
version, `lib/src/version.dart` and changelog according to the package release
workflow; do not infer a new CLI version from a registry version.

The CLI publish workflow requires a stable published registry release and runs
both consumer presets against its GitHub content with hosted runtime packages.
A missing registry release must fail; do not substitute bundled content to
bypass the bootstrap order.

If the CLI has never been published, the authorized uploader must perform the
first pub.dev publication and configure automated publishing for repository
`conceptadev/remix`, tag pattern `remix_cli-v{{version}}`. Later releases use
that tag pattern. Never republish an existing version.

After publication, verify the exact hosted CLI:

```shell
fvm dart run tool/check_open_code.dart --source hosted --hosted-cli
fvm dart run tool/check_open_code.dart --preset fortal --source hosted --hosted-cli
```

## Rollback and migration

Restore the previously committed `remix.yaml` revision to select an older
registry snapshot. This does not revert installed, application-owned source;
review or restore that source separately through application version control.

Schemas 1 and 2 continue to use their frozen bundled snapshot until an explicit
`remix registry migrate`. See [registry migration and source ownership](REGISTRIES.md).
