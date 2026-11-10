import 'dart:io';

import 'package:path/path.dart' as p;

import 'project_config.dart';
import 'skills.dart';

/// Named after the barrel's `// remix_cli:exports:start|end` markers, the
/// other block this CLI owns inside a file it does not.
const managedSkillsStart = '<!-- remix_cli:skills:start -->';
const managedSkillsEnd = '<!-- remix_cli:skills:end -->';

/// The files a coding agent reads as project instructions, in the order the
/// block is looked for.
///
/// The first entry is where a new block is created. The others exist so that
/// a developer who moves the block (for example into `CLAUDE.md`) keeps it
/// there on every rerun without a flag.
const agentGuidanceFiles = [
  'AGENTS.md',
  'CLAUDE.md',
  '.cursorrules',
  '.github/copilot-instructions.md',
];

/// The managed block, markers included, for [skills] vendored in [directory].
///
/// The text depends only on its two arguments. It carries no revision and no
/// package version, so moving a pin does not change `AGENTS.md`.
String skillsGuidanceBlock({
  required String directory,
  required List<PublishedSkill> skills,
}) => [
  managedSkillsStart,
  '## Remix skills',
  '',
  '`remix skills install` wrote this block and the skill directories it lists.',
  'They are copied from the commit pinned for `@remix` in `remix.yaml`, so they',
  'describe the Remix this project installs. Read the matching `SKILL.md` before',
  'you write or review Remix code, and prefer it over what you remember about',
  'Remix, Mix, or Naked UI.',
  '',
  for (final skill in skills)
    '- `$directory/${skill.name}/SKILL.md`: ${skill.summary}',
  '',
  "Open a skill's `references/` files only when its `SKILL.md` sends you there.",
  'If `revision` in `remix.skills.json` differs from the `@remix` revision in',
  '`remix.yaml`, run `dart run remix_cli:remix skills install` before relying on',
  'the skills. Do not edit the listed skill directories; that command owns them.',
  'It does not manage other skills under `$directory/`.',
  managedSkillsEnd,
].join('\n');

/// [source] with its managed block replaced by [block], or with [block]
/// appended when [source] has no marker.
///
/// Every character outside the marker pair is returned unchanged, and the
/// block uses the line terminator [source] already uses. An appended block is
/// separated from existing text by one blank line, and the file ends with one
/// terminator. Applying the same block twice gives the same text as once.
///
/// The block is appended, not prepended, so a file that opens with its own
/// title keeps it. A developer can move the block; reruns update it where it
/// is.
///
/// A marker is a line that holds only the marker, so prose that quotes one is
/// text. Throws a [FormatException] unless [source] has no marker, or exactly
/// one start marker followed by exactly one end marker.
String updateManagedGuidance(
  String source,
  String block, {
  required String path,
}) {
  final terminator = source.contains('\r\n') ? '\r\n' : '\n';
  final replacement = block.split('\n').join(terminator);
  final starts = <(int, int)>[];
  final ends = <(int, int)>[];
  var offset = 0;
  for (final raw in source.split('\n')) {
    final line = raw.endsWith('\r') ? raw.substring(0, raw.length - 1) : raw;
    final span = (offset, offset + line.length);
    if (line.trim() == managedSkillsStart) starts.add(span);
    if (line.trim() == managedSkillsEnd) ends.add(span);
    offset += raw.length + 1;
  }

  if (starts.isEmpty && ends.isEmpty) {
    final existing = source.replaceFirst(RegExp(r'(\r?\n)+$'), '');
    if (existing.isEmpty) return '$replacement$terminator';
    return '$existing$terminator$terminator$replacement$terminator';
  }
  if (starts.length != 1 ||
      ends.length != 1 ||
      starts.single.$1 > ends.single.$1) {
    throw _malformedMarkers(path);
  }
  return source.replaceRange(starts.single.$1, ends.single.$2, replacement);
}

bool _holdsMarker(String text) => text
    .split('\n')
    .map((line) => line.trim())
    .any((line) => line == managedSkillsStart || line == managedSkillsEnd);

FormatException _malformedMarkers(String path) => FormatException(
  '$path must contain one ordered remix_cli:skills marker pair. Remove the '
  'stray marker, then rerun remix skills install.',
);

enum GuidanceChange { created, updated, preserved }

/// The decision for the agent instruction file. It reads; it does not write.
final class GuidancePlan {
  const GuidancePlan._(
    this.path,
    this.after,
    this.change, {
    required this.claudeImportHint,
  });

  /// Project-relative path of the file that holds, or will hold, the block.
  final String path;

  /// The complete file contents to write. Unused when [change] is
  /// [GuidanceChange.preserved].
  final String after;

  final GuidanceChange change;

  /// Whether to tell the developer that Claude Code will not see the block.
  ///
  /// True when this run writes the block to `AGENTS.md` and a separate
  /// `CLAUDE.md` does not import it with `@AGENTS.md`. The CLI does not edit
  /// `CLAUDE.md`: it owns the block, not the file. A run that leaves the block
  /// unchanged stays quiet, so a team that keeps `CLAUDE.md` separate on
  /// purpose hears it when the block is written, not on every rerun.
  final bool claudeImportHint;

  /// Picks the target and computes its contents.
  ///
  /// Target rule: the one file in [agentGuidanceFiles] that already contains
  /// a marker; otherwise `AGENTS.md`, created when it does not exist. A
  /// candidate that is a symbolic link counts as the file it points to, so a
  /// `CLAUDE.md` linked to `AGENTS.md` is one holder, and a write replaces
  /// the target's contents instead of the link. An absent candidate is not
  /// checked, so a `.github` that links outside the project does not matter
  /// until it holds the block.
  ///
  /// Throws a [FormatException] when two files contain a marker, and for
  /// every case [updateManagedGuidance] rejects.
  static GuidancePlan resolve(Directory root, String block) {
    final canonicalRoot = root.resolveSymbolicLinksSync();
    final contents = <String, String>{};
    final holders = <String>[];
    String? claude;
    var target = agentGuidanceFiles.first;
    for (final candidate in agentGuidanceFiles) {
      final file = File(p.joinAll([root.path, ...p.posix.split(candidate)]));
      if (!file.existsSync()) continue;
      final path = p.posix.joinAll(
        p.split(
          p.relative(
            validateProjectFilePath(root, candidate),
            from: canonicalRoot,
          ),
        ),
      );
      if (candidate == agentGuidanceFiles.first) target = path;
      if (contents.containsKey(path)) continue;
      final text = file.readAsStringSync();
      contents[path] = text;
      if (candidate == 'CLAUDE.md') claude = text;
      if (_holdsMarker(text)) holders.add(path);
    }
    if (holders.length > 1) {
      throw FormatException(
        'remix_cli:skills markers appear in ${holders.join(' and ')}. Keep the '
        'block in one file, then rerun remix skills install.',
      );
    }
    final path = holders.firstOrNull ?? target;
    validateProjectFilePath(root, path);
    final before = contents[path];
    final after = updateManagedGuidance(before ?? '', block, path: path);
    final change = before == null
        ? GuidanceChange.created
        : before == after
        ? GuidanceChange.preserved
        : GuidanceChange.updated;
    return GuidancePlan._(
      path,
      after,
      change,
      claudeImportHint:
          change != GuidanceChange.preserved &&
          path == target &&
          claude != null &&
          !_importsAgents.hasMatch(claude),
    );
  }
}

/// Claude Code's import syntax, which may sit inside a sentence.
final _importsAgents = RegExp(r'(^|\s)@(\./)?AGENTS\.md\b', multiLine: true);
