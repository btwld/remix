import 'dart:io';

import 'package:test/test.dart';

import '../../tool/release_packages.dart';

void main() {
  final remix = PackageRelease.fromTag('v1.2.3');
  final cli = PackageRelease.fromTag('remix_cli-v1.2.3-rc.2');

  test('reads the top-level pubspec version', () {
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

  test('maps only publishing tags with versions to packages', () {
    final tags = {
      'v1.2.3': 'remix',
      'remix_cli-v1.2.3': 'remix_cli',
      'remix_ui_icons-v1.2.3': 'remix_ui_icons',
      'remix_ui_fonts-v1.2.3': 'remix_ui_fonts',
      'naked_ui-v1.2.3': 'naked_ui',
    };
    for (final MapEntry(key: tag, value: package) in tags.entries) {
      final release = PackageRelease.fromTag(tag);
      expect(release.package, package);
      expect(release.publishingTag, tag);
      expect(release.melosTag, package == 'remix' ? 'remix-v1.2.3' : isNull);
    }
    for (final invalid in [
      'remix-v1.2.3',
      'registry_source-v1.2.3',
      'v1.2.3wrong',
      'v1.2',
      'v01.2.3',
      'v1.2.3-rc.01',
    ]) {
      expect(() => PackageRelease.fromTag(invalid), throwsFormatException);
    }
  });

  test(
    'finds the newest stable Remix tags by semver, ignoring build metadata',
    () {
      expect(
        newestStableRemixTags([
          'v1.2.9',
          'v1.2.10+build.1',
          'v1.2.10',
          'v1.2.11-rc.1',
          'remix-v2.0.0',
          'vinvalid',
          'remix_cli-v2.0.0',
        ]).map((release) => release.publishingTag),
        ['v1.2.10+build.1', 'v1.2.10'],
      );
      expect(cli.prerelease, isTrue);
    },
  );

  test(
    'picks the highest earlier semver publishing tag of the same package',
    () {
      expect(
        previousPublishingTag(cli, [
          'remix_cli-v1.2.3',
          'remix_cli-v1.2.3-rc.2',
          'remix_cli-v1.2.3-rc.1',
          'remix_cli-v1.2.3-rc.0',
          'remix_cli-v1.2.3-rc.10',
          'remix_cli-v1.2.2',
          'v1.2.3-rc.1',
          'remix_cli-vbad',
        ]),
        'remix_cli-v1.2.3-rc.1',
      );
      expect(
        previousPublishingTag(remix, ['remix-v1.2.2', 'v1.1.9', 'v1.1.10']),
        'v1.1.10',
      );
      expect(
        previousPublishingTag(remix, ['v1.2.2', 'v1.2.3-rc.1', 'v1.2.2-rc.2']),
        'v1.2.2',
      );
      expect(previousPublishingTag(remix, ['v1.2.3-rc.1']), isNull);
      expect(previousPublishingTag(remix, ['remix-v1.2.2']), isNull);
      expect(
        previousPublishingTag(PackageRelease.fromTag('v1.2.3+build.2'), [
          'v1.2.2',
          'v1.2.3+build.1',
        ]),
        'v1.2.2',
      );
    },
  );

  group('link-changelog', () {
    test('returns the full draft and changes only the selected body', () {
      const earlier = '# Changelog\r\n\r\n## 1.2.30\r\nOther heading.\r\n\r\n';
      const body =
          '### Fixes\r\n\r\n```md\r\n## Not a heading\r\n```\r\n\r\n- Fixed a bug.';
      const older = '## 1.2.2\r\n\r\nLegacy notes.  \r\n';
      final result = linkChangelog(
        '$earlier## 1.2.3\r\n\r\n$body\r\n\r\n$older',
        remix,
      );
      expect(result.draft, body);
      expect(
        result.changelog,
        '$earlier## 1.2.3\r\n\r\n'
        'See the [release notes](https://github.com/btwld/remix/releases/tag/v1.2.3).\r\n\r\n'
        '$older',
      );
    });

    test('supports an empty last section and a retry is a no-op', () {
      final result = linkChangelog('## 1.2.3-rc.2', cli);
      expect(result.draft, isEmpty);
      expect(result.changelog, '## 1.2.3-rc.2\n\n${cli.changelogLink}\n');
      expect(linkChangelog(result.changelog, cli), result);
    });

    test('requires a matching second-level heading outside code fences', () {
      for (final changelog in [
        '## 1.2.30\n',
        '### 1.2.3\n',
        '~~~md\n## 1.2.3\n~~~\n',
      ]) {
        expect(() => linkChangelog(changelog, remix), throwsFormatException);
      }
    });
  });

  group(
    'release commands',
    () {
      final script = File('tool/release_packages.dart').absolute.path;
      late Directory repo;
      late File ghLog;
      late String baseline;

      String git(List<String> args) {
        final result = Process.runSync(
          'git',
          args,
          workingDirectory: repo.path,
        );
        expect(result.exitCode, 0, reason: 'git $args: ${result.stderr}');
        return '${result.stdout}'.trim();
      }

      File write(String path, String content) => File('${repo.path}/$path')
        ..parent.createSync(recursive: true)
        ..writeAsStringSync(content);

      void manifest(String package, String version) => write(
        'packages/$package/pubspec.yaml',
        'name: $package\nversion: $version\n',
      );

      String commit(String message, {bool onMain = true}) {
        git(['add', 'packages']);
        git(['-c', 'commit.gpgsign=false', 'commit', '-m', message]);
        final sha = git(['rev-parse', 'HEAD']);
        if (onMain) git(['update-ref', 'refs/remotes/origin/main', sha]);
        return sha;
      }

      void remoteTag(String tag, String sha, {bool annotated = false}) {
        git([
          'tag',
          if (annotated) ...['-a', '-m', 'Release'],
          tag,
          sha,
        ]);
        git(['push', 'origin', 'refs/tags/$tag']);
      }

      void existingRelease(String tag, {bool draft = false}) =>
          write('releases/$tag', '{"isDraft":$draft}\n');

      ProcessResult run(List<String> args) => Process.runSync(
        Platform.resolvedExecutable,
        [script, ...args],
        workingDirectory: repo.path,
        environment: {
          'PATH': '${repo.path}/bin:${Platform.environment['PATH']}',
          'TEST_GH_LOG': ghLog.path,
          'TEST_RELEASE_FIXTURES': '${repo.path}/releases',
        },
      );

      setUp(() {
        repo = Directory.systemTemp.createTempSync('remix_release_test_');
        git(['init', '-b', 'main']);
        git(['init', '--bare', 'origin.git']);
        git(['remote', 'add', 'origin', '${repo.path}/origin.git']);
        git(['config', 'user.name', 'Release Test']);
        git(['config', 'user.email', 'test@example.com']);
        git(['config', 'tag.gpgSign', 'false']);
        manifest('remix', '1.2.3');
        write(
          'packages/remix/CHANGELOG.md',
          '## 1.2.3\n\n${remix.changelogLink}\n',
        );
        baseline = commit('Version bump');
        ghLog = write('gh.log', '');
        write('bin/gh', r'''#!/bin/sh
printf '%s\n' "$*" >> "$TEST_GH_LOG"
case "$1 $2" in
  'release view')
    if [ -f "$TEST_RELEASE_FIXTURES/$3.error" ]; then
      cat "$TEST_RELEASE_FIXTURES/$3.error" >&2
      exit 1
    fi
    if [ -f "$TEST_RELEASE_FIXTURES/$3" ]; then
      cat "$TEST_RELEASE_FIXTURES/$3"
      exit 0
    fi
    printf '%s\n' 'release not found' >&2
    exit 1 ;;
  'api repos/{owner}/{repo}/releases/generate-notes')
    printf '%s\n' 'Generated notes.' ;;
esac
''');
        expect(
          Process.runSync('chmod', ['+x', '${repo.path}/bin/gh']).exitCode,
          0,
        );
      });

      tearDown(() => repo.deleteSync(recursive: true));

      test(
        'validates a link-only changelog at the tagged ancestor of main',
        () {
          remoteTag(remix.publishingTag, baseline, annotated: true);
          manifest('remix', '1.2.4');
          commit('Newer change to main');

          final result = run(['validate', remix.publishingTag]);
          expect(result.exitCode, 0, reason: '${result.stderr}');
          expect(result.stdout, contains('at $baseline on origin/main'));
        },
      );

      test('rejects a tag that is not on origin/main', () {
        write('packages/remix/CHANGELOG.md', '## 1.2.3\n\nDifferent.\n');
        remoteTag(remix.publishingTag, commit('Off main', onMain: false));

        final result = run(['validate', remix.publishingTag]);
        expect(result.exitCode, 1);
        expect(result.stderr, contains('not on origin/main'));
      });

      test('rejects the wrong version and a missing heading', () {
        remoteTag('v1.2.4', baseline);
        final mismatch = run(['validate', 'v1.2.4']);
        expect(mismatch.exitCode, 1);
        expect(mismatch.stderr, contains('at the tag has 1.2.3'));

        write('packages/remix/CHANGELOG.md', '## 1.2.30\n');
        remoteTag(remix.publishingTag, commit('No release heading'));
        final missing = run(['validate', remix.publishingTag]);
        expect(missing.exitCode, 1);
        expect(missing.stderr, contains('Missing CHANGELOG heading: ## 1.2.3'));
      });

      test(
        'the command takes the version from pubspec and prints its draft',
        () {
          manifest('remix_cli', '${cli.version}');
          const older = '## 1.2.2\n\nKeep this.\n';
          final changelog = write(
            'packages/remix_cli/CHANGELOG.md',
            '## ${cli.version}\n\nDraft notes.\n\n$older',
          );

          final result = run(['link-changelog', 'remix_cli']);
          expect(result.exitCode, 0, reason: '${result.stderr}');
          expect(result.stdout, 'Draft notes.\n');
          expect(
            changelog.readAsStringSync(),
            '## ${cli.version}\n\n${cli.changelogLink}\n\n$older',
          );
        },
      );

      test(
        'adds a missing Melos alias and syncs flags without changing notes',
        () {
          remoteTag(remix.publishingTag, baseline, annotated: true);
          manifest('remix', '1.2.4');
          commit('Main has advanced');
          existingRelease(remix.publishingTag);

          final result = run(['release', remix.publishingTag]);
          expect(result.exitCode, 0, reason: '${result.stderr}');
          expect(ghLog.readAsLinesSync(), [
            'api repos/{owner}/{repo}/git/refs -f ref=refs/tags/remix-v1.2.3 -f sha=$baseline',
            'release view v1.2.3 --json isDraft',
            'release edit v1.2.3 --prerelease=false --latest',
          ]);
        },
      );

      test('fails without moving a Melos alias at a different commit', () {
        write('packages/remix/CHANGELOG.md', '## 1.2.3\n\nDifferent.\n');
        final other = commit('Different commit');
        remoteTag(remix.publishingTag, other);
        remoteTag(remix.melosTag!, baseline, annotated: true);

        final result = run(['release', remix.publishingTag]);
        expect(result.exitCode, 1);
        expect(
          result.stderr,
          contains('Melos alias remix-v1.2.3 points to $baseline, not $other'),
        );
        expect(ghLog.readAsStringSync(), isEmpty);
      });

      test(
        'restores Latest to the newest stable release after a stable backfill',
        () {
          remoteTag(remix.publishingTag, baseline);
          remoteTag(remix.melosTag!, baseline);
          remoteTag('v1.2.10', baseline);
          remoteTag('v1.2.11-rc.1', baseline);
          existingRelease(remix.publishingTag);
          existingRelease('v1.2.10');
          existingRelease('v1.2.11-rc.1');

          final result = run(['release', remix.publishingTag]);
          expect(result.exitCode, 0, reason: '${result.stderr}');
          expect(ghLog.readAsLinesSync(), [
            'release view v1.2.3 --json isDraft',
            'release edit v1.2.3 --prerelease=false --latest=false',
            'release view v1.2.10 --json isDraft',
            'release edit v1.2.10 --prerelease=false --latest',
          ]);
        },
      );

      test(
        'publishes an existing draft with corrected flags and preserved notes',
        () {
          remoteTag(cli.publishingTag, baseline);
          remoteTag(remix.publishingTag, baseline);
          existingRelease(cli.publishingTag, draft: true);
          existingRelease(remix.publishingTag);

          final result = run(['release', cli.publishingTag]);
          expect(result.exitCode, 0, reason: '${result.stderr}');
          expect(ghLog.readAsLinesSync(), [
            'release view remix_cli-v1.2.3-rc.2 --json isDraft',
            'release edit remix_cli-v1.2.3-rc.2 --draft=false --verify-tag --tag remix_cli-v1.2.3-rc.2 --prerelease=true --latest=false',
            'release view v1.2.3 --json isDraft',
            'release edit v1.2.3 --prerelease=false --latest',
          ]);
        },
      );

      test('does not promote an older tag or publish an unrelated draft', () {
        remoteTag(remix.publishingTag, baseline);
        remoteTag('v1.2.4', baseline);
        existingRelease(remix.publishingTag);
        existingRelease('v1.2.4', draft: true);
        existingRelease(cli.publishingTag);

        final result = run(['release', cli.publishingTag]);
        expect(result.exitCode, 0, reason: '${result.stderr}');
        expect(result.stdout, contains('could not reassign Latest'));
        expect(ghLog.readAsLinesSync(), [
          'release view remix_cli-v1.2.3-rc.2 --json isDraft',
          'release edit remix_cli-v1.2.3-rc.2 --prerelease=true --latest=false',
          'release view v1.2.4 --json isDraft',
        ]);
      });

      test('a lookup error other than release not found aborts', () {
        write(
          'releases/${cli.publishingTag}.error',
          'HTTP 403: release not found\n',
        );

        final result = run(['release', cli.publishingTag]);
        expect(result.exitCode, 1);
        expect(result.stderr, contains('HTTP 403: release not found'));
        expect(ghLog.readAsLinesSync(), [
          'release view remix_cli-v1.2.3-rc.2 --json isDraft',
        ]);
      });

      test('generates a missing Release with the previous package tag', () {
        remoteTag(remix.publishingTag, baseline);
        remoteTag(remix.melosTag!, baseline, annotated: true);
        remoteTag('v1.2.2', baseline);
        remoteTag('v1.2.3-rc.1', baseline);
        remoteTag('remix_cli-v1.2.3-rc.1', baseline);
        remoteTag('remix_cli-v1.2.3', baseline);

        final stable = run(['release', remix.publishingTag]);
        expect(stable.exitCode, 0, reason: '${stable.stderr}');
        expect(
          ghLog.readAsStringSync(),
          allOf(
            contains('tag_name=v1.2.3 -f previous_tag_name=v1.2.2'),
            contains(
              'release create v1.2.3 --verify-tag --title remix 1.2.3 --notes Generated notes.',
            ),
            contains('[View on pub.dev](${remix.pubLink}) --latest\n'),
            isNot(contains('git/refs')),
          ),
        );

        ghLog.writeAsStringSync('');
        final prerelease = run(['release', cli.publishingTag]);
        expect(prerelease.exitCode, 0, reason: '${prerelease.stderr}');
        expect(
          ghLog.readAsStringSync(),
          allOf(
            contains(
              'tag_name=remix_cli-v1.2.3-rc.2 -f previous_tag_name=remix_cli-v1.2.3-rc.1',
            ),
            contains(
              '[View on pub.dev](${cli.pubLink}) --latest=false --prerelease',
            ),
            isNot(contains('git/refs')),
          ),
        );
      });
    },
    skip: Platform.isWindows ? 'Requires the POSIX gh fixture' : false,
  );
}
