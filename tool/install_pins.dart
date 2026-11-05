import 'dart:io';

import 'package:yaml/yaml.dart';

/// pub.dev treats the stable 0.x line (`remix 0.2.0`, `remix_cli 0.1.0`) as
/// latest, so an unversioned `pub add` of these lands on a release the docs
/// no longer describe.
const pinnedInstallPackages = <String>['remix', 'remix_cli', 'remix_ui_icons'];

const publishedSkillDirectories = <String>[
  'skills/using-remix',
  'skills/building-remix-design-system',
];

const consumerDocumentationFiles = <String>[
  'README.md',
  'packages/remix/README.md',
  'registry_source/docs/fortal/README.md',
  'packages/remix_cli/README.md',
  'open_code/README.md',
  'open_code/CLEAN_SHEET.md',
];

List<File> userFacingDocuments(Directory workspaceRoot) {
  final documents = <File>[
    ...Directory('${workspaceRoot.path}/docs')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.mdx')),
    for (final relativeDirectory in publishedSkillDirectories)
      ...Directory('${workspaceRoot.path}/$relativeDirectory')
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.md')),
    for (final relativeFile in consumerDocumentationFiles)
      File('${workspaceRoot.path}/$relativeFile'),
  ];
  return documents..sort((a, b) => a.path.compareTo(b.path));
}

/// Skill evals teach the install commands, so their pins move with the docs.
List<String> get skillEvalRelativePaths => [
  for (final relativeDirectory in publishedSkillDirectories)
    '$relativeDirectory/evals/evals.json',
];

List<File> skillEvalFiles(Directory workspaceRoot) => [
  for (final relativePath in skillEvalRelativePaths)
    File('${workspaceRoot.path}/$relativePath'),
];

List<File> installPinDocuments(Directory workspaceRoot) {
  final documents = [
    ...userFacingDocuments(workspaceRoot),
    ...skillEvalFiles(workspaceRoot),
  ];
  return documents..sort((a, b) => a.path.compareTo(b.path));
}

/// User-facing docs describe the published release; `open_code/RELEASING.md`
/// owns the candidate (#383).
final _releaseStagingPhrases = <RegExp>[
  RegExp(r'\bunpublished\b', caseSensitive: false),
  RegExp(r'\bnot published yet\b', caseSensitive: false),
  RegExp(r'\bthis checkout\b', caseSensitive: false),
];

void checkInstallPins(
  String source,
  String relativePath,
  Map<String, String> expectedPins,
  List<String> failures,
) {
  for (final command in installCommands(source)) {
    final expected = expectedPins[command.package]!;
    final constraint = command.constraint?.text;
    if (constraint == null) {
      failures.add(
        '$relativePath installs ${command.package} without a version at '
        'offset ${command.start}; pub.dev resolves that to the stable 0.x '
        'line, so pin $expected.',
      );
    } else if (constraint != expected) {
      failures.add(
        '$relativePath pins ${command.package} $constraint at offset '
        '${command.start}; the package is $expected. Run '
        '`dart run tool/sync_install_pins.dart`.',
      );
    }
  }
}

void checkReleaseState(
  String source,
  String relativePath,
  Map<String, String> expectedPins,
  List<String> failures,
) {
  checkInstallPins(source, relativePath, expectedPins, failures);
  for (final phrase in _releaseStagingPhrases) {
    final match = phrase.firstMatch(source);
    if (match != null) {
      failures.add(
        '$relativePath says "${match[0]}" at offset ${match.start}; '
        'user-facing docs describe the published release, not a staged one.',
      );
    }
  }
}

void checkSkillEvalInstallPins(
  Directory workspaceRoot,
  Map<String, String> expectedPins,
  List<String> failures,
) {
  for (final relativePath in skillEvalRelativePaths) {
    final file = File('${workspaceRoot.path}/$relativePath');
    if (!file.existsSync()) continue;
    // Eval prompts may say "this checkout". Only install pins are release state.
    checkInstallPins(
      file.readAsStringSync(),
      relativePath,
      expectedPins,
      failures,
    );
  }
}

String expectedInstallPin(Directory workspaceRoot, String package) {
  final pubspec = File('${workspaceRoot.path}/packages/$package/pubspec.yaml');
  final declared = (loadYaml(pubspec.readAsStringSync()) as YamlMap)['version'];
  if (declared is! String) {
    throw StateError('packages/$package does not declare a version.');
  }
  return '^$declared';
}

typedef InstallConstraint = ({String text, int start, int end});

typedef InstallCommand = ({
  String package,
  int start,
  InstallConstraint? constraint,
});

final _packages = pinnedInstallPackages.map(RegExp.escape).join('|');

final _pubAdd = RegExp(
  '\\bpub add ([\'"]?)(?:dev:)?($_packages)(?::(\\^?[0-9][^\\s\'"`]*))?\\1'
  '(?=[\\s`]|\$)',
);

final _globalActivate = RegExp(
  '\\bpub global activate ($_packages)(?:[ \\t]+([\'"]?)(\\^?[0-9][^\\s\'"`]*)\\2)?'
  '(?=[\\s`]|\$)',
);

List<InstallCommand> installCommands(String source) {
  final commands = <InstallCommand>[
    for (final match in _pubAdd.allMatches(source))
      (
        package: match[2]!,
        start: match.start,
        constraint: _constraint(match, match[3]),
      ),
    for (final match in _globalActivate.allMatches(source))
      (
        package: match[1]!,
        start: match.start,
        constraint: _constraint(match, match[3]),
      ),
  ];
  return commands..sort((a, b) => a.start.compareTo(b.start));
}

InstallConstraint? _constraint(RegExpMatch match, String? text) {
  if (text == null) return null;
  final start = match.start + match[0]!.lastIndexOf(text);
  return (text: text, start: start, end: start + text.length);
}
