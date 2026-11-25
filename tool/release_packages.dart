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
      throw FormatException('Not a release package: $package');
    }
  }

  factory PackageRelease.fromTag(String tag) {
    for (final package in releasePackages) {
      final prefix = _tagPrefix(package);
      if (!tag.startsWith(prefix)) continue;
      final text = tag.substring(prefix.length);
      final Version version;
      try {
        version = Version.parse(text);
      } on FormatException {
        throw FormatException('Invalid version in release tag: $tag');
      }
      final core = '${version.major}.${version.minor}.${version.patch}';
      final precedence = text.split('+').first;
      final prerelease = precedence.startsWith('$core-')
          ? precedence.substring(core.length + 1)
          : null;
      if ((precedence != core && prerelease == null) ||
          (prerelease != null &&
              prerelease.split('.').any(RegExp(r'^0[0-9]+$').hasMatch))) {
        throw FormatException('Invalid version in release tag: $tag');
      }
      return PackageRelease(package, version);
    }
    throw FormatException('Not a release tag for a known package: $tag');
  }

  final String package;
  final Version version;

  static String _tagPrefix(String package) =>
      package == 'remix' ? 'v' : '$package-v';

  String get directory => 'packages/$package';
  String get publishingTagPrefix => _tagPrefix(package);
  String get publishingTag => '$publishingTagPrefix$version';
  String? get melosTag => package == 'remix' ? 'remix-v$version' : null;
  bool get prerelease => version.isPreRelease;
  bool get stableRemix => package == 'remix' && !prerelease;
  String get title => '$package $version';
  String get pubLink => 'https://pub.dev/packages/$package/versions/$version';
  String get changelogLink =>
      'See the [release notes](https://github.com/btwld/remix/releases/tag/$publishingTag).';
}

typedef _ChangelogBody = ({int start, int end, String newline});

_ChangelogBody? _changelogBody(String changelog, Version version) {
  final heading = RegExp(r'^ {0,3}(#{1,2})[ \t]+(.*)$');
  final fenceStart = RegExp(r'^ {0,3}(`{3,}|~{3,})');
  String? fence;
  int? start;
  var newline = '\n';
  for (final match in RegExp(
    r'([^\r\n]*)(\r\n|\n|\r|$)',
  ).allMatches(changelog)) {
    final line = match[1]!;
    if (fence case final openFence?) {
      final closing = line.trimRight();
      final closeMatch = fenceStart.firstMatch(closing);
      if (closeMatch != null &&
          closeMatch.end == closing.length &&
          closeMatch[1]!.startsWith(openFence)) {
        fence = null;
      }
    } else if (fenceStart.firstMatch(line) case final opening?) {
      fence = opening[1];
    } else if (heading.firstMatch(line) case final header?) {
      if (start != null) {
        return (start: start, end: match.start, newline: newline);
      }
      final text = header[2]!
          .replaceFirst(RegExp(r'[ \t]+#+[ \t]*$'), '')
          .trim();
      if (header[1] == '##' && text == '$version') {
        start = match.start + line.length;
        if (match[2]!.isNotEmpty) newline = match[2]!;
      }
    }
  }
  return start == null
      ? null
      : (start: start, end: changelog.length, newline: newline);
}

({String changelog, String draft}) linkChangelog(
  String changelog,
  PackageRelease release,
) {
  final body = _changelogBody(changelog, release.version);
  if (body == null) {
    throw FormatException(
      'Missing CHANGELOG heading: ## ${release.version} (${release.package})',
    );
  }
  final original = changelog.substring(body.start, body.end);
  final draft = original
      .replaceFirst(RegExp(r'^(?:[ \t]*(?:\r\n|\n|\r))+'), '')
      .trimRight();
  if (draft == release.changelogLink) return (changelog: changelog, draft: '');
  final newline = body.newline;
  final updated = changelog.replaceRange(
    body.start,
    body.end,
    '$newline$newline${release.changelogLink}$newline'
    '${body.end < changelog.length ? newline : ''}',
  );
  return (changelog: updated, draft: draft);
}

String? previousPublishingTag(PackageRelease release, Iterable<String> tags) {
  final prefix = release.publishingTagPrefix;
  final current = _semverPrecedence(release.version);
  Version? previousVersion;
  String? previousTag;
  for (final tag in tags.where((tag) => tag.startsWith(prefix))) {
    final Version version;
    try {
      version = _semverPrecedence(PackageRelease.fromTag(tag).version);
    } on FormatException {
      continue;
    }
    if ((release.prerelease || !version.isPreRelease) &&
        version < current &&
        (previousVersion == null || version > previousVersion)) {
      previousVersion = version;
      previousTag = tag;
    }
  }
  return previousTag;
}

List<PackageRelease> newestStableRemixTags(Iterable<String> tags) {
  final newest = <PackageRelease>[];
  Version? highest;
  for (final tag in tags.where((tag) => tag.startsWith('v'))) {
    final PackageRelease candidate;
    try {
      candidate = PackageRelease.fromTag(tag);
    } on FormatException {
      continue;
    }
    if (!candidate.stableRemix) continue;
    final version = _semverPrecedence(candidate.version);
    if (highest != null && version < highest) continue;
    if (highest == null || version > highest) {
      highest = version;
      newest.clear();
    }
    newest.add(candidate);
  }
  return newest;
}

Version _semverPrecedence(Version version) => version.build.isEmpty
    ? version
    : Version.parse('$version'.split('+').first);

Map<String, String> remoteTagCommits(String refs) {
  final tags = <String, String>{};
  final peeled = <String, String>{};
  for (final line in refs.split('\n')) {
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
      case ['validate', final tag]:
        _validateRelease(PackageRelease.fromTag(tag));
      case ['release', final tag]:
        _finalizeRelease(PackageRelease.fromTag(tag));
      case ['link-changelog', final package]:
        _linkPackageChangelog(package);
      default:
        stderr.writeln(
          'Usage: dart run tool/release_packages.dart '
          'validate <tag> | release <tag> | link-changelog <package>',
        );
        exitCode = 64;
    }
  } on Exception catch (error) {
    stderr.writeln(error);
    exitCode = 1;
  }
}

String _taggedCommit(String tag) =>
    _run('git', ['rev-parse', '--verify', 'refs/tags/$tag^{commit}']).trim();

void _validateRelease(PackageRelease release) {
  final tag = release.publishingTag;
  final commit = _taggedCommit(tag);
  final ancestry = [
    'merge-base',
    '--is-ancestor',
    commit,
    'refs/remotes/origin/main',
  ];
  final result = Process.runSync('git', ancestry);
  if (result.exitCode == 1) {
    throw FormatException(
      'Tag $tag points to $commit, which is not on origin/main',
    );
  }
  if (result.exitCode != 0) {
    throw ProcessException(
      'git',
      ancestry,
      'Could not verify that $tag is on origin/main: ${result.stderr}',
      result.exitCode,
    );
  }
  final manifest = '${release.directory}/pubspec.yaml';
  final version = pubspecVersion(_run('git', ['show', '$commit:$manifest']));
  if ('$version' != '${release.version}') {
    throw FormatException(
      'Tag $tag requires version ${release.version}, but $manifest at the tag has $version',
    );
  }
  final changelog = '${release.directory}/CHANGELOG.md';
  if (_changelogBody(_run('git', ['show', '$commit:$changelog']), version) ==
      null) {
    throw FormatException(
      'Missing CHANGELOG heading: ## $version in $changelog at tag $tag',
    );
  }
  stdout.writeln(
    'Validated $tag for ${release.title} at $commit on origin/main.',
  );
}

void _linkPackageChangelog(String package) {
  if (!releasePackages.contains(package)) {
    throw FormatException('Not a release package: $package');
  }
  final path = 'packages/$package';
  final version = pubspecVersion(File('$path/pubspec.yaml').readAsStringSync());
  final release = PackageRelease(package, version);
  final file = File('$path/CHANGELOG.md');
  final original = file.readAsStringSync();
  final updated = linkChangelog(original, release);
  if (updated.changelog != original) file.writeAsStringSync(updated.changelog);
  if (updated.draft.isNotEmpty) stdout.writeln(updated.draft);
}

Map<String, String> _remoteTags([String? tag]) => remoteTagCommits(
  _run('git', [
    'ls-remote',
    '--tags',
    'origin',
    if (tag != null) ...['refs/tags/$tag', 'refs/tags/$tag^{}'],
  ]),
);

void _ensureMelosTag(String tag, String commit) {
  void checkTarget(String existing) {
    if (existing != commit) {
      throw FormatException(
        'Melos alias $tag points to $existing, not $commit; refusing to move it',
      );
    }
    stdout.writeln('Melos alias $tag already points to $commit.');
  }

  if (_remoteTags(tag)[tag] case final existing?) {
    checkTarget(existing);
    return;
  }
  try {
    _run('gh', [
      'api',
      'repos/{owner}/{repo}/git/refs',
      '-f',
      'ref=refs/tags/$tag',
      '-f',
      'sha=$commit',
    ]);
    stdout.writeln('Created Melos alias $tag at $commit.');
  } on ProcessException {
    final existing = _remoteTags(tag)[tag];
    if (existing == null) rethrow;
    checkTarget(existing);
  }
}

void _finalizeRelease(PackageRelease release) {
  final tag = release.publishingTag;
  if (release.melosTag case final alias?) {
    _ensureMelosTag(alias, _taggedCommit(tag));
  }
  final tags = _remoteTags().keys;
  final newest = newestStableRemixTags(tags);
  final latest =
      release.stableRemix &&
      (newest.isEmpty ||
          _semverPrecedence(release.version) >=
              _semverPrecedence(newest.first.version));
  final draft = _releaseIsDraft(tag);
  if (draft == null) {
    _createRelease(release, tags: tags, latest: latest);
  } else {
    _editRelease(release, latest: latest, draft: draft);
  }
  if (!latest) _restoreLatestRemix(newest);
}

void _createRelease(
  PackageRelease release, {
  required Iterable<String> tags,
  required bool latest,
}) {
  final tag = release.publishingTag;
  final previous = previousPublishingTag(release, tags);
  final generated = _run('gh', [
    'api',
    'repos/{owner}/{repo}/releases/generate-notes',
    '-f',
    'tag_name=$tag',
    if (previous != null) ...['-f', 'previous_tag_name=$previous'],
    '--jq',
    '.body',
  ]).trimRight();
  final notes = [
    if (generated.isNotEmpty) generated,
    '[View on pub.dev](${release.pubLink})',
  ].join('\n\n');
  try {
    stdout.write(
      _run('gh', [
        'release',
        'create',
        tag,
        '--verify-tag',
        '--title',
        release.title,
        '--notes',
        notes,
        _latestFlag(latest),
        if (release.prerelease) '--prerelease',
      ]),
    );
  } on ProcessException {
    final draft = _releaseIsDraft(tag);
    if (draft == null) rethrow;
    _editRelease(release, latest: latest, draft: draft);
  }
}

String _latestFlag(bool latest) => latest ? '--latest' : '--latest=false';

void _editRelease(
  PackageRelease release, {
  required bool latest,
  required bool draft,
}) {
  final tag = release.publishingTag;
  stdout.write(
    _run('gh', [
      'release',
      'edit',
      tag,
      if (draft) ...['--draft=false', '--verify-tag', '--tag', tag],
      '--prerelease=${release.prerelease}',
      _latestFlag(latest),
    ]),
  );
}

void _restoreLatestRemix(List<PackageRelease> newest) {
  for (final candidate in newest) {
    if (_releaseIsDraft(candidate.publishingTag) != false) continue;
    _editRelease(candidate, latest: true, draft: false);
    return;
  }
  stdout.writeln(
    'No public GitHub Release for the newest stable Remix version; could not reassign Latest.',
  );
}

bool? _releaseIsDraft(String tag) {
  final args = ['release', 'view', tag, '--json', 'isDraft'];
  final result = Process.runSync('gh', args);
  if (result.exitCode == 0) {
    if (jsonDecode(result.stdout as String) case {
      'isDraft': final bool draft,
    }) {
      return draft;
    }
    throw FormatException('Expected isDraft in the GitHub Release for $tag');
  }
  if ('${result.stderr}'.trim() == 'release not found') return null;
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
