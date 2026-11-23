import 'package:pub_semver/pub_semver.dart';
import 'package:test/test.dart';

import '../../tool/release_packages.dart';

void main() {
  final version = Version.parse('1.2.3');
  final remix = PackageRelease('remix', version);
  final pubLink =
      '[View on pub.dev](https://pub.dev/packages/remix/versions/1.2.3)';

  test('reads and validates the top-level pubspec version', () {
    final version = pubspecVersion('''
name: remix
version: "1.2.3-rc.1+build.2" # release version
dependencies:
  example: {version: '9.9.9'}
''');
    expect(version.toString(), '1.2.3-rc.1+build.2');
    for (final invalid in ['name: remix', 'version: false', 'version: 1.2']) {
      expect(() => pubspecVersion(invalid), throwsFormatException);
    }
  });

  test('maps only independently published packages to release tags', () {
    expect(
      releasePackages,
      unorderedEquals([
        'remix',
        'remix_cli',
        'remix_ui_icons',
        'remix_ui_fonts',
        'naked_ui',
      ]),
    );
    expect(remix.tags, ['remix-v1.2.3', 'v1.2.3']);
    expect(remix.publishingTag, 'v1.2.3');
    for (final package in releasePackages.where(
      (package) => package != 'remix',
    )) {
      final release = PackageRelease(package, version);
      expect(release.publishingTag, '$package-v1.2.3');
      expect(release.tags, [release.publishingTag]);
    }
  });

  test(
    'only stable Remix releases are latest; build metadata is not a prerelease',
    () {
      for (final package in releasePackages) {
        final stable = PackageRelease(package, Version.parse('1.2.3+build.1'));
        final candidate = PackageRelease(
          package,
          Version.parse('1.2.3-rc.1+build.1'),
        );
        expect(stable.prerelease, isFalse);
        expect(stable.latest, package == 'remix');
        expect(candidate.prerelease, isTrue);
        expect(candidate.latest, isFalse);
        expect(candidate.title, '$package 1.2.3-rc.1+build.1');
      }
    },
  );

  group('changelog', () {
    test(
      'extracts the exact section through its nested headings and fences',
      () {
        final changelog =
            '''
## 1.2.30
Too new.
## 1.2.3 ###

### Fixes

- Fixed layout.
```md
## Example heading
```

## 1.2.2
Too old.
'''
                .replaceAll('\n', '\r\n');
        expect(changelogSection(changelog, version), '''
### Fixes

- Fixed layout.
```md
## Example heading
```''');
      },
    );

    test(
      'distinguishes an empty matching section from no matching heading',
      () {
        expect(changelogSection('## 1.2.3\n\n## 1.2.2\nOld.', version), '');
        expect(changelogSection('## 1.2.3-rc.1\n### 1.2.3\n', version), isNull);
        expect(changelogSection('~~~md\n## 1.2.3\n~~~\n', version), isNull);
      },
    );

    test('distinguishes a link-only section from written notes', () {
      for (final section in [
        '',
        '  \n',
        '[Release notes](https://example.com/release)',
        'https://example.com/release',
        '- <https://example.com/release>\n- [Changes](https://example.com/compare)',
      ]) {
        expect(hasChangelogNotes(section), isFalse, reason: section);
      }
      expect(
        hasChangelogNotes('Fixed a bug. [Details](https://example.com)'),
        isTrue,
      );
      expect(
        hasChangelogNotes('[PR](https://example.com) fixes layout.'),
        isTrue,
      );
    });
  });

  group('release notes', () {
    String notes({String? custom, String? section}) => releaseNotes(
      custom: custom,
      section: section,
      generate: () => 'GitHub generated notes\n',
      release: remix,
    );

    test('prefers a tag-specific file and appends the exact pub.dev link', () {
      expect(
        notes(custom: 'Curated notes\n', section: 'Changelog'),
        'Curated notes\n\n$pubLink',
      );
      expect(notes(custom: '', section: 'Changelog'), pubLink);
    });

    test('uses a substantive changelog section before generating notes', () {
      expect(notes(section: 'Fixed layout.'), 'Fixed layout.\n\n$pubLink');
      expect(
        notes(section: '[Release notes](https://example.com)'),
        'GitHub generated notes\n\n$pubLink',
      );
      expect(notes(section: ''), 'GitHub generated notes\n\n$pubLink');
      expect(notes(), 'GitHub generated notes\n\n$pubLink');
    });
  });

  group('tag planning', () {
    List<({String tag, bool publish, String? skip})> plan({
      bool dispatch = false,
      Version? previous,
      String? section = 'Changes',
      Map<String, String> remote = const {},
    }) => planTags(
      release: remix,
      dispatch: dispatch,
      previousVersion: previous,
      section: section,
      remoteTags: remote,
      sha: 'reviewed-merge',
    );

    test('a changed version with an empty changelog entry still qualifies', () {
      expect(plan(previous: Version.parse('1.2.2'), section: ''), [
        (tag: 'remix-v1.2.3', publish: false, skip: null),
        (tag: 'v1.2.3', publish: true, skip: null),
      ]);
    });

    test('push skips unchanged versions; dispatch can backfill them', () {
      expect(
        plan(previous: version).map((entry) => entry.skip),
        everyElement('package version did not change'),
      );
      expect(
        plan(dispatch: true, previous: version).map((entry) => entry.skip),
        everyElement(isNull),
      );
    });

    test('never tags without the exact changelog heading', () {
      for (final dispatch in [false, true]) {
        expect(
          plan(dispatch: dispatch, section: null).map((entry) => entry.skip),
          everyElement('missing CHANGELOG heading for 1.2.3'),
        );
      }
    });

    test('skips existing refs and reports where each one points', () {
      final tags = remoteTagCommits('''
old-commit\trefs/tags/v1.2.3^{}
annotated-tag-object\trefs/tags/v1.2.3
reviewed-merge\trefs/tags/remix-v1.2.3
''');
      expect(plan(remote: tags).map((entry) => entry.skip), [
        'remote tag already points to reviewed-merge',
        'remote tag points to old-commit, not reviewed-merge',
      ]);
    });

    test(
      'backfills only the missing Remix alias without dispatching publishing',
      () {
        final due = plan(
          dispatch: true,
          remote: {'v1.2.3': 'reviewed-merge'},
        ).where((entry) => entry.skip == null);
        expect(due.single.tag, 'remix-v1.2.3');
        expect(due.single.publish, isFalse);
      },
    );
  });
}
