import 'dart:io';

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
    List<TagPlanEntry> plan({
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
        (tag: 'remix-v1.2.3', publish: false, skip: null, failed: false),
        (tag: 'v1.2.3', publish: true, skip: null, failed: false),
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

    test('does not create a missing Remix tag beside a conflicting one', () {
      for (final tag in remix.tags) {
        final entries = plan(dispatch: true, remote: {tag: 'old-commit'});
        expect(
          entries.singleWhere((entry) => entry.tag == tag).skip,
          'remote tag points to old-commit, not reviewed-merge',
        );
        expect(
          entries.singleWhere((entry) => entry.tag != tag).skip,
          'paired tag `$tag` points to old-commit, not reviewed-merge',
        );
      }
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

  test(
    'previous release is the highest earlier publishing tag for the package',
    () {
      const tags = [
        'v1.2.3-rc.10',
        'v1.2.3-rc.2',
        'v1.2.4',
        'v1.2.3',
        'vtest',
        'remix-v1.2.3-rc.11',
        'remix_cli-v1.2.2',
        'naked_ui-v1.2.3-rc.11',
      ];
      expect(previousPublishingTag(remix, tags), 'v1.2.3-rc.10');
      expect(
        previousPublishingTag(PackageRelease('remix_cli', version), tags),
        'remix_cli-v1.2.2',
      );
      expect(
        previousPublishingTag(PackageRelease('remix_ui_fonts', version), tags),
        isNull,
      );
    },
  );

  group(
    'tag command',
    () {
      final script = File('tool/release_packages.dart').absolute.path;
      late Directory sandbox;
      late File ghLog;
      late String baseline;

      String git(List<String> args) {
        final result = Process.runSync(
          'git',
          args,
          workingDirectory: sandbox.path,
        );
        expect(result.exitCode, 0, reason: 'git $args: ${result.stderr}');
        return '${result.stdout}'.trim();
      }

      File write(String path, String content) => File('${sandbox.path}/$path')
        ..parent.createSync(recursive: true)
        ..writeAsStringSync(content);

      String commit(String subject) {
        git(['add', 'packages']);
        git(['-c', 'commit.gpgsign=false', 'commit', '-m', subject]);
        return git(['rev-parse', 'HEAD']);
      }

      void package(String name, String version, {bool heading = true}) {
        write(
          'packages/$name/pubspec.yaml',
          'name: $name\nversion: $version\n',
        );
        write(
          'packages/$name/CHANGELOG.md',
          heading ? '## $version\n\nChanges.\n' : '## 1.2.2\n',
        );
      }

      void remoteTag(String name, String sha) {
        git(['tag', name, sha]);
        git(['push', 'origin', 'refs/tags/$name']);
      }

      ProcessResult runTags({
        String? before,
        String? packages,
        bool failAlias = false,
      }) => Process.runSync(
        Platform.resolvedExecutable,
        [script, 'tag'],
        workingDirectory: sandbox.path,
        environment: {
          'PATH': '${sandbox.path}/bin:${Platform.environment['PATH']}',
          'GITHUB_SHA': git(['rev-parse', 'HEAD']),
          'GITHUB_EVENT_NAME': packages == null ? 'push' : 'workflow_dispatch',
          'RELEASE_BEFORE': before ?? baseline,
          'RELEASE_PACKAGES': packages ?? '',
          'GITHUB_STEP_SUMMARY': '${sandbox.path}/summary',
          'TEST_GH_LOG': ghLog.path,
          'TEST_FAIL_ALIAS': failAlias ? 'yes' : 'no',
        },
      );

      setUp(() {
        sandbox = Directory.systemTemp.createTempSync('remix_tag_test_');
        git(['init', '-b', 'main']);
        git(['init', '--bare', 'origin.git']);
        git(['remote', 'add', 'origin', '${sandbox.path}/origin.git']);
        git(['config', 'user.name', 'Release test']);
        git(['config', 'user.email', 'release-test@example.com']);
        for (final name in releasePackages) {
          package(name, '1.2.2');
        }
        baseline = commit('Initial packages');
        ghLog = write('gh.log', '');
        write('bin/gh', r'''#!/bin/sh
printf '%s\n' "$*" >> "$TEST_GH_LOG"
if [ "$TEST_FAIL_ALIAS" = yes ] && [ "$4" = ref=refs/tags/remix-v1.2.3 ]; then
  printf '%s\n' 'Could not create alias' >&2
  exit 1
fi
''');
        final chmod = Process.runSync('chmod', [
          '+x',
          '${sandbox.path}/bin/gh',
        ]);
        expect(chmod.exitCode, 0);
      });

      tearDown(() => sandbox.deleteSync(recursive: true));

      test('changed versions fail on conflicting tags and missing headings', () {
        remoteTag('v1.2.3', baseline);
        remoteTag('remix_cli-v1.2.3', baseline);
        package('remix', '1.2.3');
        package('remix_cli', '1.2.3');
        package('naked_ui', '1.2.3', heading: false);
        final target = commit('Bump three versions');

        final result = runTags();
        expect(result.exitCode, 1);
        expect(
          result.stderr,
          allOf(
            contains(
              'Skipped `remix-v1.2.3`: paired tag `v1.2.3` points to $baseline, not $target',
            ),
            contains(
              'Skipped `remix_cli-v1.2.3`: remote tag points to $baseline, not $target',
            ),
            contains(
              'Skipped `naked_ui-v1.2.3`: missing CHANGELOG heading for 1.2.3',
            ),
          ),
        );
        expect(ghLog.readAsLinesSync(), isEmpty);
      });

      test('dispatch selects packages and tags each version-change commit', () {
        package('remix_cli', '1.2.3');
        final cliBump = commit('Bump CLI');
        package('naked_ui', '1.2.4');
        final nakedBump = commit('Bump Naked UI');
        write(
          'packages/remix_cli/pubspec.yaml',
          'name: remix_cli\nversion: "1.2.3"\ndescription: A later edit\n',
        );
        write('packages/naked_ui/CHANGELOG.md', '## 1.2.2\n');
        commit('Edit the manifest and changelog without bumping versions');

        final result = runTags(packages: 'remix_cli, naked_ui');
        expect(result.exitCode, 0, reason: '${result.stderr}');
        expect(ghLog.readAsLinesSync(), [
          'api repos/{owner}/{repo}/git/refs -f ref=refs/tags/remix_cli-v1.2.3 -f sha=$cliBump',
          'workflow run publish.yml --ref remix_cli-v1.2.3',
          'api repos/{owner}/{repo}/git/refs -f ref=refs/tags/naked_ui-v1.2.4 -f sha=$nakedBump',
          'workflow run publish.yml --ref naked_ui-v1.2.4',
        ]);
      });

      test('dispatch rejects an empty or unknown package selection', () {
        for (final input in ['', 'remix, registry_source']) {
          final result = runTags(packages: input);
          expect(result.exitCode, 1);
          expect(
            result.stderr,
            contains('RELEASE_PACKAGES must name one or more'),
          );
        }
        expect(ghLog.readAsLinesSync(), isEmpty);
      });

      test('alias failure never creates the Remix publishing tag', () {
        package('remix', '1.2.3');
        final target = commit('Bump Remix');

        final result = runTags(failAlias: true);
        expect(result.exitCode, 1);
        expect(
          result.stdout,
          contains('Skipped `v1.2.3`: tagging was blocked by `remix-v1.2.3`'),
        );
        expect(ghLog.readAsLinesSync(), [
          'api repos/{owner}/{repo}/git/refs -f ref=refs/tags/remix-v1.2.3 -f sha=$target',
        ]);
      });

      test(
        'unresolvable before SHA checks and tags missing versions at the push SHA',
        () {
          for (final tag in [
            'v1.2.2',
            'remix-v1.2.2',
            'naked_ui-v1.2.2',
            'remix_ui_icons-v1.2.2',
            'remix_ui_fonts-v1.2.2',
          ]) {
            remoteTag(tag, baseline);
          }
          package('remix_cli', '1.2.3');
          final target = commit('Bump CLI');

          final result = runTags(before: 'a' * 40);
          expect(result.exitCode, 0, reason: '${result.stderr}');
          expect(
            result.stdout,
            contains('checking every current package version'),
          );
          expect(ghLog.readAsLinesSync(), [
            'api repos/{owner}/{repo}/git/refs -f ref=refs/tags/remix_cli-v1.2.3 -f sha=$target',
            'workflow run publish.yml --ref remix_cli-v1.2.3',
          ]);
        },
      );
    },
    skip: Platform.isWindows ? 'Requires the POSIX gh fixture' : false,
  );
}
