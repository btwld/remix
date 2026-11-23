import 'dart:convert';
import 'dart:io';

import 'package:pub_semver/pub_semver.dart';
import 'package:yaml/yaml.dart';

const releasePackages = [
  'remix',
  'remix_cli',
  'remix_ui_icons',
  'remix_ui_fonts',
  'naked_ui',
];

Version pubspecVersion(String pubspec) {
  final manifest = loadYaml(pubspec);
  final version = manifest is YamlMap ? manifest['version'] : null;
  if (version is! String) {
    throw const FormatException('Expected a version string in pubspec.yaml');
  }
  return Version.parse(version);
}

class PackageRelease {
  PackageRelease(this.package, this.version) {
    if (!releasePackages.contains(package)) {
      throw ArgumentError.value(package, 'package', 'Not a release package');
    }
  }

  final String package;
  final Version version;

  String get directory => 'packages/$package';
  String get publishingTag =>
      package == 'remix' ? 'v$version' : '$package-v$version';
  List<String> get tags => [
    if (package == 'remix') 'remix-v$version',
    publishingTag,
  ];
  bool get prerelease => version.isPreRelease;
  bool get latest => package == 'remix' && !prerelease;
  String get title => '$package $version';
  String get pubLink => 'https://pub.dev/packages/$package/versions/$version';
}

String? changelogSection(String changelog, Version version) {
  final heading = RegExp(r'^ {0,3}(#{1,2})[ \t]+(.*)$');
  final fenceStart = RegExp(r'^ {0,3}(`{3,}|~{3,})');
  String? fence;
  List<String>? section;
  for (final line in const LineSplitter().convert(changelog)) {
    if (fence case final openFence?) {
      final closing = line.trimRight();
      final match = fenceStart.firstMatch(closing);
      if (match != null &&
          match.end == closing.length &&
          match[1]!.startsWith(openFence)) {
        fence = null;
      }
    } else if (fenceStart.firstMatch(line) case final opening?) {
      fence = opening[1];
    } else if (heading.firstMatch(line) case final match?) {
      if (section != null) break;
      final text = match[2]!
          .replaceFirst(RegExp(r'[ \t]+#+[ \t]*$'), '')
          .trim();
      if (match[1] == '##' && text == '$version') section = [];
      continue;
    }
    section?.add(line);
  }
  return section?.join('\n').trim();
}

bool hasChangelogNotes(String section) {
  final linkOnly = RegExp(
    r'^(?:(?:[-+*]|\d+\.)\s+)?(?:\[[^\]]+\]\([^)]+\)|<https?://[^<>\s]+>|https?://\S+)$',
  );
  return const LineSplitter()
      .convert(section)
      .map((line) => line.trim())
      .any((line) => line.isNotEmpty && !linkOnly.hasMatch(line));
}

String releaseNotes({
  required String? custom,
  required String? section,
  required String Function() generate,
  required PackageRelease release,
}) {
  final notes =
      custom ??
      (section != null && hasChangelogNotes(section) ? section : generate());
  return [
    if (notes.trimRight().isNotEmpty) notes.trimRight(),
    '[View on pub.dev](${release.pubLink})',
  ].join('\n\n');
}

List<({String tag, bool publish, String? skip})> planTags({
  required PackageRelease release,
  required bool dispatch,
  required Version? previousVersion,
  required String? section,
  required Map<String, String> remoteTags,
  required String sha,
}) => [
  for (final tag in release.tags)
    (
      tag: tag,
      publish: tag == release.publishingTag,
      skip: switch (remoteTags[tag]) {
        final existing? when existing != sha =>
          'remote tag points to $existing, not $sha',
        _ when !dispatch && previousVersion == release.version =>
          'package version did not change',
        _ when section == null =>
          'missing CHANGELOG heading for ${release.version}',
        final existing? => 'remote tag already points to $existing',
        null => null,
      },
    ),
];

Map<String, String> remoteTagCommits(String refs) {
  final tags = <String, String>{};
  final peeled = <String, String>{};
  for (final line in const LineSplitter().convert(refs)) {
    final parts = line.split('\trefs/tags/');
    if (parts.length != 2) continue;
    final tag = parts.last;
    if (tag.endsWith('^{}')) {
      peeled[tag.substring(0, tag.length - 3)] = parts.first;
    } else {
      tags[tag] = parts.first;
    }
  }
  return {...tags, ...peeled};
}

void main(List<String> args) {
  try {
    switch (args) {
      case ['tag']:
        _tagReleases();
      case ['release', final tag]:
        _createRelease(tag);
      default:
        stderr.writeln(
          'Usage: dart run tool/release_packages.dart tag | release <tag>',
        );
        exitCode = 64;
    }
  } on Exception catch (error) {
    stderr.writeln(error);
    exitCode = 1;
  }
}

Iterable<PackageRelease> _workspaceReleases() sync* {
  for (final package in releasePackages) {
    final manifest = File('packages/$package/pubspec.yaml');
    yield PackageRelease(package, pubspecVersion(manifest.readAsStringSync()));
  }
}

String? _readFile(String path) {
  final file = File(path);
  return file.existsSync() ? file.readAsStringSync() : null;
}

String? _packageSection(PackageRelease release) => changelogSection(
  _readFile('${release.directory}/CHANGELOG.md') ?? '',
  release.version,
);

void _tagReleases() {
  final sha = Platform.environment['GITHUB_SHA'];
  if (sha == null || !_shaPattern.hasMatch(sha)) {
    throw const FormatException('Expected GITHUB_SHA to be a commit SHA');
  }
  final before = Platform.environment['RELEASE_BEFORE'] ?? '';
  final dispatch =
      Platform.environment['GITHUB_EVENT_NAME'] == 'workflow_dispatch';
  final summary = <String>[];
  try {
    if (!dispatch) {
      if (!_shaPattern.hasMatch(before)) {
        throw const FormatException(
          'Expected RELEASE_BEFORE to be the previous commit SHA',
        );
      }
      if (before == '0000000000000000000000000000000000000000') {
        summary.add(
          'Skipped: no previous `main` commit to compare; dispatch manually if needed.',
        );
        return;
      }
      if (Process.runSync('git', [
            'cat-file',
            '-e',
            '$before^{commit}',
          ]).exitCode !=
          0) {
        _run('git', ['fetch', '--no-tags', 'origin', before]);
      }
    }
    final remoteTags = remoteTagCommits(
      _run('git', ['ls-remote', '--tags', 'origin']),
    );
    for (final release in _workspaceReleases()) {
      final path = '${release.directory}/pubspec.yaml';
      final previous =
          dispatch || _run('git', ['ls-tree', before, '--', path]).isEmpty
          ? null
          : pubspecVersion(_run('git', ['show', '$before:$path']));
      final plan = planTags(
        release: release,
        dispatch: dispatch,
        previousVersion: previous,
        section: _packageSection(release),
        remoteTags: remoteTags,
        sha: sha,
      );
      for (final entry in plan) {
        final tag = entry.tag;
        if (entry.skip case final reason?) {
          summary.add('Skipped `$tag`: $reason.');
          continue;
        }
        try {
          final create = Process.runSync('gh', [
            'api',
            'repos/{owner}/{repo}/git/refs',
            '-f',
            'ref=refs/tags/$tag',
            '-f',
            'sha=$sha',
          ]);
          if (create.exitCode != 0) {
            final existing = remoteTagCommits(
              _run('git', [
                'ls-remote',
                '--tags',
                'origin',
                'refs/tags/$tag',
                'refs/tags/$tag^{}',
              ]),
            )[tag];
            if (existing != null) {
              summary.add('Skipped `$tag`: remote tag appeared at $existing.');
              continue;
            }
            throw ProcessException(
              'gh',
              ['api', 'git/refs'],
              '${create.stderr}',
              create.exitCode,
            );
          }
          summary.add('Tagged `$tag` at $sha.');
          if (entry.publish) {
            _run('gh', ['workflow', 'run', 'publish.yml', '--ref', tag]);
            summary.add('Dispatched publishing for `$tag`.');
          }
        } on Exception catch (error) {
          stderr.writeln(error);
          summary.add('Failed to tag or dispatch `$tag`; see the job log.');
          exitCode = 1;
        }
      }
    }
  } finally {
    final report = [
      '### Release tags',
      '',
      ...summary.map((line) => '- $line'),
    ].join('\n');
    stdout.writeln(report);
    if (Platform.environment['GITHUB_STEP_SUMMARY'] case final path?) {
      File(path).writeAsStringSync('$report\n', mode: FileMode.append);
    }
  }
}

final _shaPattern = RegExp(r'^[a-f0-9]{40}$');

void _createRelease(String tag) {
  final matches = _workspaceReleases().where(
    (release) => release.publishingTag == tag,
  );
  if (matches.isEmpty)
    throw FormatException('Not a publishing tag for this checkout: $tag');
  final release = matches.single;
  if (_releaseExists(tag)) {
    stdout.writeln('Release $tag already exists; skipping.');
    return;
  }
  final notes = releaseNotes(
    custom: _readFile('.github/release-notes/$tag.md'),
    section: _packageSection(release),
    generate: () => _run('gh', [
      'api',
      'repos/{owner}/{repo}/releases/generate-notes',
      '-f',
      'tag_name=$tag',
      '--jq',
      '.body',
    ]),
    release: release,
  );
  final temp = Directory.systemTemp.createTempSync('remix_release_');
  try {
    final notesFile = File('${temp.path}/notes.md')..writeAsStringSync(notes);
    try {
      stdout.write(
        _run('gh', [
          'release',
          'create',
          tag,
          '--verify-tag',
          '--title',
          release.title,
          '--notes-file',
          notesFile.path,
          '--latest=${release.latest}',
          if (release.prerelease) '--prerelease',
        ]),
      );
    } on ProcessException {
      if (!_releaseExists(tag)) rethrow;
      stdout.writeln('Release $tag already exists; skipping.');
    }
  } finally {
    temp.deleteSync(recursive: true);
  }
}

bool _releaseExists(String tag) {
  final args = ['release', 'view', tag, '--json', 'tagName'];
  final result = Process.runSync('gh', args);
  if (result.exitCode == 0) return true;
  if ('${result.stderr}'.trim() == 'release not found') return false;
  throw ProcessException('gh', args, '${result.stderr}', result.exitCode);
}

String _run(String executable, List<String> args) {
  final result = Process.runSync(executable, args);
  if (result.exitCode != 0) {
    throw ProcessException(
      executable,
      args,
      '${result.stderr}',
      result.exitCode,
    );
  }
  return result.stdout as String;
}
