/// Fails when a registry release tag is not one `remix init` can discover.
///
/// The release workflow triggers on a broad `registry-v*` pattern, and the
/// published smoke test resolves whatever ref it is handed. Without this, a
/// release such as `registry-v1.0.0+build.1` reports green while remaining
/// invisible to every new project.
library;

import 'dart:io';

import '../packages/remix_cli/lib/src/registry_source.dart';

void main(List<String> arguments) {
  if (arguments.length != 1) {
    stderr.writeln('Usage: dart run tool/check_release_tag.dart <tag>');
    exitCode = 64;
    return;
  }
  final tag = arguments.single;
  if (!isDiscoverableReleaseTag(tag)) {
    stderr.writeln(
      'Release tag "$tag" is not discoverable by remix init. Use '
      'registry-v<major>[.<minor>[.<patch>]], for example registry-v1.2.',
    );
    exitCode = 1;
    return;
  }
  stdout.writeln('Release tag $tag is discoverable by remix init.');
}
