import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import 'project_config.dart';
import 'registry_source.dart';
import 'yaml_fields.dart';

/// Where the manifest lives in a repository, relative to its root.
///
/// `tool/generate_skills_index.dart` writes this path and imports this
/// constant, so the generator and the reader cannot disagree.
const skillsIndexPath = 'skills/index.yaml';

/// The only registry that publishes skills. Third-party registries have no
/// `skills/` convention, so the command does not take a namespace.
const skillsNamespace = '@remix';

/// The agent-neutral project directory that `npx skills add` and most agents
/// use. `--dir` overrides it, and the receipt remembers the override.
const defaultSkillsDirectory = '.agents/skills';

const skillsRecordFileName = 'remix.skills.json';

const _supportedIndexSchema = 1;

final _skillName = RegExp(r'^[a-z][a-z0-9-]*$');

/// The repository path of [file] in [skill], for `RegistrySources.file`.
String skillRepositoryPath(String skill, String file) => 'skills/$skill/$file';

/// One skill that a pinned commit publishes.
final class PublishedSkill {
  const PublishedSkill._(this.name, this.summary, this.files);

  /// The directory name under `skills/`, which is also the `name` in the
  /// skill's frontmatter.
  final String name;

  /// One line that tells an agent when to read the skill. It appears in the
  /// managed guidance block, so it stays short.
  final String summary;

  /// Skill-relative paths in manifest order: non-empty, without duplicates,
  /// containing `SKILL.md`, each accepted by [validateRegistryPath].
  final List<String> files;
}

/// `skills/index.yaml` at one commit, parsed and validated.
///
/// This is the trust boundary for remote file names. After [parse] returns,
/// every name is safe to join into a repository path and a project path.
final class SkillsIndex {
  const SkillsIndex._(this.skills);

  /// Skills in manifest order, which is the order the guidance block lists.
  final List<PublishedSkill> skills;

  /// Throws a [FormatException] that names the field when [source] is not a
  /// schema 1 index. An unknown schema says to upgrade `remix_cli`, because a
  /// newer pin may publish a layout this build predates.
  static SkillsIndex parse(String source) {
    final document = yamlMap(loadYaml(source), 'skills index');
    requireYamlKeys(document, 'skills index', required: {'schema', 'skills'});
    if (document['schema'] != _supportedIndexSchema) {
      throw const FormatException(
        'Unsupported skills index schema; expected schema '
        '$_supportedIndexSchema. Upgrade remix_cli to read this pin.',
      );
    }
    final entries = yamlMap(document['skills'], 'skills index skills');
    if (entries.isEmpty) {
      throw const FormatException('skills index lists no skills.');
    }
    final skills = <PublishedSkill>[];
    for (final MapEntry(:key, :value) in entries.entries) {
      if (key is! String || !_skillName.hasMatch(key)) {
        throw FormatException(
          'skills index has invalid skill name $key; use lowercase letters, '
          'digits, and hyphens.',
        );
      }
      final label = 'skills.$key';
      final entry = yamlMap(value, label);
      requireYamlKeys(entry, label, required: {'summary', 'files'});
      final summary = yamlString(entry['summary'], '$label.summary');
      if (summary.contains('\n') || summary.contains('\r')) {
        throw FormatException('$label.summary must be one line.');
      }
      final files = yamlStringList(entry['files'], '$label.files');
      final seen = <String>{};
      for (final file in files) {
        validateRegistryPath(file);
        if (!seen.add(file)) {
          throw FormatException('$label.files lists $file more than once.');
        }
      }
      if (!seen.contains('SKILL.md')) {
        throw FormatException('$label.files must include SKILL.md.');
      }
      skills.add(PublishedSkill._(key, summary, List.unmodifiable(files)));
    }
    return SkillsIndex._(List.unmodifiable(skills));
  }
}

/// The receipt for the last successful `remix skills install`.
///
/// It records what the CLI wrote, not what the CLI may write. That is why it
/// is separate from `remix.ownership.json`, which reserves targets under
/// `paths.ui` and holds no digests.
final class SkillsRecord {
  const SkillsRecord({
    required this.directory,
    required this.repository,
    required this.revision,
    required this.files,
  });

  /// Project-relative directory that holds the vendored skills.
  final String directory;

  /// The source of the vendored bytes: [repository] at [revision], the value
  /// an agent compares with `remix.yaml`.
  final String repository;
  final String revision;

  /// `<skill>/<file>`, relative to [directory], to the digest of the bytes
  /// the CLI wrote. See [skillFileDigest].
  final Map<String, String> files;

  static const _malformed = FormatException(
    'Unsupported or malformed $skillsRecordFileName. Restore it from version '
    'control.',
  );

  /// The receipt in [root], or null when the project has none.
  static SkillsRecord? read(Directory root) {
    validateProjectFilePath(root, skillsRecordFileName);
    final file = File(p.join(root.path, skillsRecordFileName));
    if (!file.existsSync()) return null;
    final Object? document;
    try {
      document = jsonDecode(file.readAsStringSync());
    } on FormatException {
      throw _malformed;
    }
    if (document
        case {
          'schema': 1,
          'directory': final String directory,
          'repository': final String repository,
          'revision': final String revision,
          'files': final Map<String, Object?> files,
        }
        when document.length == 5 &&
            _isRelativePath(directory) &&
            repository.isNotEmpty &&
            RegExp(r'^[0-9a-f]{40}$').hasMatch(revision)) {
      return SkillsRecord(
        directory: directory,
        repository: repository,
        revision: revision,
        files: _digests(files),
      );
    }
    throw _malformed;
  }

  static Map<String, String> _digests(Map<String, Object?> files) {
    final digests = <String, String>{};
    for (final MapEntry(:key, :value) in files.entries) {
      if (value is! String ||
          !RegExp(r'^[0-9a-f]{64}$').hasMatch(value) ||
          !_isRelativePath(key)) {
        throw _malformed;
      }
      digests[key] = value;
    }
    return digests;
  }

  /// Indented JSON with sorted file keys and a trailing newline, so a rerun
  /// that changes nothing produces the same bytes.
  String encode() {
    final sorted = Map.fromEntries(
      files.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
    final document = {
      'schema': 1,
      'directory': directory,
      'repository': repository,
      'revision': revision,
      'files': sorted,
    };
    return '${const JsonEncoder.withIndent('  ').convert(document)}\n';
  }
}

/// Whether [value] is relative, normalized, without traversal, and in the
/// characters a registry path allows, so it joins safely onto the project.
bool _isRelativePath(String value) {
  try {
    validateRegistryPath(value);
    return true;
  } on FormatException {
    return false;
  }
}

/// Throws a [FormatException] when [directory] cannot hold vendored skills.
void validateSkillsDirectory(String directory) {
  if (!_isRelativePath(directory)) {
    throw FormatException(
      '$directory must be a project-relative directory such as '
      '$defaultSkillsDirectory.',
    );
  }
}

/// SHA-256 of [contents] with CRLF folded to LF.
///
/// Git on Windows can check a vendored file out with CRLF endings. Folding
/// keeps that checkout equal to the bytes the CLI wrote, so a teammate's
/// rerun does not report every file as edited.
String skillFileDigest(String contents) =>
    sha256.convert(utf8.encode(contents.replaceAll('\r\n', '\n'))).toString();

/// What a run did to one skill, in the verbs `remix add` already prints.
enum SkillChange { added, updated, preserved, removed }

/// The complete decision for one run. It reads the disk and writes nothing.
///
/// Building a plan performs every rejection. If [resolve] returns, the writes
/// that follow can fail only for filesystem reasons, and a rerun converges.
final class SkillsPlan {
  const SkillsPlan._({
    required this.writes,
    required this.removals,
    required this.record,
    required this.recordChanged,
    required this.changes,
  });

  /// Project-relative path to the pinned bytes, for files that are missing
  /// or still hold the bytes of the previous install.
  final Map<String, String> writes;

  /// Project-relative paths the previous install wrote and this run no
  /// longer keeps: the pin dropped them, or `--dir` moved away from them.
  final List<String> removals;

  /// The receipt to write after every file write and removal succeeds.
  final SkillsRecord record;
  final bool recordChanged;

  /// One entry per skill, in manifest order, then removed skills.
  final Map<String, SkillChange> changes;

  /// Decides the run.
  ///
  /// [contents] maps `<skill>/<file>` to the bytes at [pin] for every file in
  /// [index]. [before] is the current receipt, or null on a first install.
  ///
  /// Each target is classified by comparing digests:
  ///
  /// | disk                      | decision                                 |
  /// | ------------------------- | ---------------------------------------- |
  /// | missing                   | write                                    |
  /// | equals the pinned bytes   | keep (no write)                          |
  /// | equals the receipt digest | write (the CLI wrote it; safe to replace)|
  /// | anything else             | conflict                                 |
  ///
  /// A path in [before] that the new layout does not contain is removed when
  /// the disk still matches its receipt digest or the file is already gone,
  /// and is a conflict otherwise.
  ///
  /// Throws one [FormatException] that lists every conflict. There is no
  /// `--overwrite`: deleting the file is the explicit act.
  static SkillsPlan resolve({
    required Directory root,
    required String directory,
    required RegistrySource pin,
    required SkillsIndex index,
    required Map<String, String> contents,
    required SkillsRecord? before,
  }) {
    // After a `--dir` move the new location has no receipt, so a file already
    // there that differs from the pin was not written by this command.
    final receipt = before != null && before.directory == directory
        ? before.files
        : const <String, String>{};
    final writes = <String, String>{};
    final removals = <String>[];
    final conflicts = <String>[];
    final digests = <String, String>{};
    final touched = <String>{};
    final existed = <String>{};
    final targets = <String>{};

    for (final skill in index.skills) {
      for (final file in skill.files) {
        final key = '${skill.name}/$file';
        final target = p.posix.join(directory, key);
        targets.add(target);
        final pinned = contents[key]!;
        digests[key] = skillFileDigest(pinned);
        final onDisk = _diskDigest(root, target);
        if (onDisk == null) {
          writes[target] = pinned;
          touched.add(skill.name);
          continue;
        }
        existed.add(skill.name);
        if (onDisk == digests[key]) continue;
        if (onDisk == receipt[key]) {
          writes[target] = pinned;
          touched.add(skill.name);
        } else {
          conflicts.add(target);
        }
      }
    }

    final removed = <String>{};
    if (before != null) {
      final published = {for (final skill in index.skills) skill.name};
      for (final MapEntry(:key, :value) in before.files.entries) {
        final skill = key.split('/').first;
        if (!published.contains(skill)) removed.add(skill);
        final previous = p.posix.join(before.directory, key);
        if (targets.contains(previous)) continue;
        final onDisk = _diskDigest(root, previous);
        if (onDisk != null && onDisk != value) {
          conflicts.add(previous);
          continue;
        }
        // An already-deleted file is still removed, so the delete prunes the
        // directories the developer's deletion left empty.
        removals.add(previous);
        if (onDisk != null) touched.add(skill);
      }
    }

    if (conflicts.isNotEmpty) {
      throw FormatException(
        [
          'These vendored skill files changed since remix skills install '
              'wrote them, or were not written by it:',
          for (final conflict in conflicts) '  $conflict',
          'Restore or delete them, then rerun remix skills install. Keep '
              'project notes outside the skills directory.',
        ].join('\n'),
      );
    }

    final record = SkillsRecord(
      directory: directory,
      repository: pin.repository,
      revision: pin.revision,
      files: digests,
    );
    return SkillsPlan._(
      writes: writes,
      removals: removals,
      record: record,
      recordChanged: before == null || before.encode() != record.encode(),
      changes: {
        for (final skill in index.skills)
          skill.name: !existed.contains(skill.name)
              ? SkillChange.added
              : touched.contains(skill.name)
              ? SkillChange.updated
              : SkillChange.preserved,
        for (final skill in removed.toList()..sort())
          skill: SkillChange.removed,
      },
    );
  }

  /// The digest of [relative] on disk, or null when it does not exist.
  ///
  /// Malformed UTF-8 is decoded leniently: such a file cannot equal pinned
  /// text, so it lands in the conflict list rather than failing the run.
  static String? _diskDigest(Directory root, String relative) {
    validateProjectFilePath(root, relative);
    final file = File(p.joinAll([root.path, ...p.posix.split(relative)]));
    if (!file.existsSync()) return null;
    return skillFileDigest(
      utf8.decode(file.readAsBytesSync(), allowMalformed: true),
    );
  }
}
