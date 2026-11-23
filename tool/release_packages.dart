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
  String get publishingTagPrefix => package == 'remix' ? 'v' : '$package-v';
  String get publishingTag => '$publishingTagPrefix$version';
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

typedef TagPlanEntry = ({String tag, bool publish, String? skip, bool failed});

List<TagPlanEntry> planTags({
  required PackageRelease release,
  required bool dispatch,
  required Version? previousVersion,
  required String? section,
  required Map<String, String> remoteTags,
  required String sha,
  bool comparisonUnavailable = false,
}) {
  final targets = release.tags.map((tag) => remoteTags[tag]).toSet();
  final settled =
      comparisonUnavailable && targets.length == 1 && targets.single != null;
  final unchanged = !dispatch && previousVersion == release.version;
  final conflict = release.tags
      .where((tag) => remoteTags[tag] != null && remoteTags[tag] != sha)
      .firstOrNull;
  return release.tags.map((tag) {
    final (String? skip, bool failed) = switch (remoteTags[tag]) {
      final existing? when settled => (
        'release tags already exist at $existing',
        false,
      ),
      final existing? when existing != sha => (
        'remote tag points to $existing, not $sha',
        !unchanged,
      ),
      _ when unchanged => ('package version did not change', false),
      final existing? => ('remote tag already points to $existing', false),
      null when conflict != null => (
        'paired tag `$conflict` points to ${remoteTags[conflict]}, not $sha',
        true,
      ),
      null when section == null => (
        'missing CHANGELOG heading for ${release.version}',
        true,
      ),
      null => (null, false),
    };
    return (
      tag: tag,
      publish: tag == release.publishingTag,
      skip: skip,
      failed: failed,
    );
  }).toList();
}

String? previousPublishingTag(PackageRelease release, Iterable<String> tags) {
  final prefix = release.publishingTagPrefix;
  Version? previousVersion;
  String? previousTag;
  for (final tag in tags.where((tag) => tag.startsWith(prefix))) {
    final Version version;
    try {
      version = Version.parse(tag.substring(prefix.length));
    } on FormatException {
      continue;
    }
    if (version < release.version &&
        (previousVersion == null || version > previousVersion)) {
      previousVersion = version;
      previousTag = tag;
    }
  }
  return previousTag;
}

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

Iterable<PackageRelease> _workspaceReleases([
  Iterable<String> packages = releasePackages,
]) sync* {
  for (final package in packages) {
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

Set<String> _dispatchPackages(String input) {
  final packages = input.split(',').map((package) => package.trim()).toSet();
  if (packages.any((package) => !releasePackages.contains(package))) {
    throw FormatException(
      'RELEASE_PACKAGES must name one or more of ${releasePackages.join(', ')}; got "$input".',
    );
  }
  return packages;
}

String? _readAt(String commit, String path) =>
    _run('git', ['ls-tree', commit, '--', path]).isEmpty
    ? null
    : _run('git', ['show', '$commit:$path']);

String _versionCommit(PackageRelease release, String sha, String path) {
  final history = _run('git', [
    'log',
    '--first-parent',
    '--format=%H',
    sha,
    '--',
    path,
  ]);
  String? target;
  for (final commit in const LineSplitter().convert(history)) {
    final manifest = _readAt(commit, path);
    if (manifest == null || pubspecVersion(manifest) != release.version) break;
    target = commit;
  }
  if (target == null) {
    throw FormatException(
      'Could not find the main commit that set ${release.title}.',
    );
  }
  return target;
}

bool _hasCommit(String sha) =>
    Process.runSync('git', ['cat-file', '-e', '$sha^{commit}']).exitCode == 0;

String? _pushBaseline(String before, List<String> summary) {
  if (!_shaPattern.hasMatch(before)) {
    throw const FormatException(
      'Expected RELEASE_BEFORE to be the previous commit SHA',
    );
  }
  if (before != '0000000000000000000000000000000000000000') {
    if (_hasCommit(before)) return before;
    final fetch = Process.runSync('git', [
      'fetch',
      '--no-tags',
      'origin',
      before,
    ]);
    if (fetch.exitCode == 0 && _hasCommit(before)) return before;
  }
  summary.add(
    'Could not resolve previous commit `$before`; checking every current package version.',
  );
  return null;
}

Map<String, String> _remoteTags() =>
    remoteTagCommits(_run('git', ['ls-remote', '--tags', 'origin']));

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
    final packages = dispatch
        ? _dispatchPackages(Platform.environment['RELEASE_PACKAGES'] ?? '')
        : releasePackages;
    final baseline = dispatch ? null : _pushBaseline(before, summary);
    final remoteTags = _remoteTags();
    for (final release in _workspaceReleases(packages)) {
      final path = '${release.directory}/pubspec.yaml';
      final previous = baseline == null ? null : _readAt(baseline, path);
      final target = dispatch ? _versionCommit(release, sha, path) : sha;
      final plan = planTags(
        release: release,
        dispatch: dispatch,
        previousVersion: previous == null ? null : pubspecVersion(previous),
        section: changelogSection(
          _readAt(target, '${release.directory}/CHANGELOG.md') ?? '',
          release.version,
        ),
        remoteTags: remoteTags,
        sha: target,
        comparisonUnavailable: !dispatch && baseline == null,
      );
      String? publishingTag;
      String? blockedBy;
      for (final entry in plan) {
        final tag = entry.tag;
        if (entry.skip case final reason?) {
          final message = 'Skipped `$tag`: $reason.';
          if (entry.failed) {
            stderr.writeln(message);
            exitCode = 1;
          }
          summary.add(message);
          continue;
        }
        if (blockedBy != null) {
          summary.add('Skipped `$tag`: tagging was blocked by `$blockedBy`.');
          continue;
        }
        try {
          final create = Process.runSync('gh', [
            'api',
            'repos/{owner}/{repo}/git/refs',
            '-f',
            'ref=refs/tags/$tag',
            '-f',
            'sha=$target',
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
              if (existing == target) {
                summary.add('Skipped `$tag`: remote tag appeared at $target.');
              } else {
                summary.add(
                  'Skipped `$tag`: remote tag appeared at $existing, not $target.',
                );
                blockedBy = tag;
                exitCode = 1;
              }
              continue;
            }
            throw ProcessException(
              'gh',
              ['api', 'git/refs'],
              '${create.stderr}',
              create.exitCode,
            );
          }
          summary.add('Tagged `$tag` at $target.');
          if (entry.publish) publishingTag = tag;
        } on Exception catch (error) {
          stderr.writeln(error);
          summary.add('Failed to tag `$tag`; see the job log.');
          blockedBy = tag;
          exitCode = 1;
        }
      }
      if (publishingTag == null) continue;
      if (blockedBy != null) {
        summary.add(
          'Did not dispatch `$publishingTag`: tagging was blocked by `$blockedBy`.',
        );
        continue;
      }
      try {
        _run('gh', ['workflow', 'run', 'publish.yml', '--ref', publishingTag]);
        summary.add('Dispatched publishing for `$publishingTag`.');
      } on Exception catch (error) {
        stderr.writeln(error);
        summary.add('Failed to dispatch `$publishingTag`; see the job log.');
        exitCode = 1;
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
  if (matches.isEmpty) {
    throw FormatException('Not a publishing tag for this checkout: $tag');
  }
  final release = matches.single;
  if (_releaseExists(tag)) {
    stdout.writeln('Release $tag already exists; skipping.');
    return;
  }
  final notes = releaseNotes(
    custom: _readFile('.github/release-notes/$tag.md'),
    section: _packageSection(release),
    generate: () {
      final previous = previousPublishingTag(release, _remoteTags().keys);
      return _run('gh', [
        'api',
        'repos/{owner}/{repo}/releases/generate-notes',
        '-f',
        'tag_name=$tag',
        if (previous != null) ...['-f', 'previous_tag_name=$previous'],
        '--jq',
        '.body',
      ]);
    },
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
