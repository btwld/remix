import 'package:remix_cli/src/registry_source.dart';
import 'package:test/test.dart';

void main() {
  // The release workflow triggers on a broad `registry-v*` pattern and the
  // smoke test resolves whatever ref it is handed, so a tag outside this
  // grammar could report green while no new project could ever find it.
  test('accepts the tags remix init discovers', () {
    for (final tag in ['registry-v1', 'registry-v1.2', 'registry-v1.2.3']) {
      expect(isDiscoverableReleaseTag(tag), isTrue, reason: tag);
    }
  });

  test('rejects tags init would skip', () {
    for (final tag in [
      'registry-v',
      'registry-v1-beta',
      'registry-v1.0.0+build.1',
      'registry-vlatest',
      'registry-1',
      'v1.2.3',
      '',
    ]) {
      expect(isDiscoverableReleaseTag(tag), isFalse, reason: tag);
    }
  });
}
