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

/// The MDX pages under `docs/`.
List<File> documentationPages(Directory workspaceRoot) => [
  ...Directory('${workspaceRoot.path}/docs')
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.mdx')),
]..sort((a, b) => a.path.compareTo(b.path));

/// The Markdown files of the published skills. A skill directory that does not
/// exist contributes nothing; `tool/validate_docs.dart` reports it.
List<File> skillMarkdownFiles(Directory workspaceRoot) => [
  for (final relativeDirectory in publishedSkillDirectories)
    if (Directory('${workspaceRoot.path}/$relativeDirectory').existsSync())
      ...Directory('${workspaceRoot.path}/$relativeDirectory')
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.md')),
]..sort((a, b) => a.path.compareTo(b.path));

/// Every document `tool/sync_install_pins.dart` rewrites. `validate_docs.dart`
/// checks the same set by reading [documentationPages], [skillMarkdownFiles],
/// and [consumerDocumentationFiles], so the two cannot drift.
List<File> userFacingDocuments(Directory workspaceRoot) {
  final documents = <File>[
    ...documentationPages(workspaceRoot),
    ...skillMarkdownFiles(workspaceRoot),
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

/// One package named by an install command.
///
/// [start] is where the command begins and [argumentStart] where this
/// package's argument does. [section] is `dev` or `override` when the command
/// says so, through a `dev:` prefix or `--dev`, and null otherwise. It is
/// information only: where `remix_cli` belongs is a documentation convention,
/// not a rule pub enforces, so the pin check does not compare it.
typedef InstallCommand = ({
  String package,
  int start,
  int argumentStart,
  String? section,
  InstallConstraint? constraint,
});

final _packages = pinnedInstallPackages.map(RegExp.escape).join('|');

final _pubAdd = RegExp(r'\bpub add(?=[\s`]|$)');

/// One shell word of a `pub add` command: a quoted word, or a bare word that
/// may end in a quoted descriptor (`remix:'>=1.0.0 <2.0.0'`).
final _pubAddWord = RegExp(
  r'''"[^"\n]*"|'[^'\n]*'|[^\s"'`;&|<>)]+(?:(?<=[:@])(?:"[^"\n]*"|'[^'\n]*'))?''',
);

/// `[section:]package[:descriptor]`, with the whole word or just the
/// descriptor quoted. Groups: 1 outer quote, 2 section, 3 package, 4
/// descriptor quote, 5 descriptor. `@` also separates a descriptor.
final _pubAddPackage = RegExp(
  r'''^(["']?)(?:(dev|override):)?([a-z_][a-z0-9_]*)(?:[:@](["']?)(.*?)\4)?\1$''',
  dotAll: true,
);

/// Options that take their value as the next word.
const _pubAddValueOptions = {
  '-C',
  '--directory',
  '--git-url',
  '--git-ref',
  '--git-path',
  '--hosted-url',
  '--path',
  '--sdk',
};

/// Options that point the package at a path, Git, or another host. Like a
/// `{path: ...}` descriptor, they are not a hosted pin.
const _pubAddSourceOptions = {'--git-url', '--hosted-url', '--path', '--sdk'};

final _globalActivate = RegExp(
  '\\bpub global activate ($_packages)(?:[ \\t]+([\'"]?)(\\^?[0-9][^\\s\'"`]*)\\2)?'
  '(?=[\\s`]|\$)',
);

/// Every pinned package a `pub add` or `pub global activate` installs.
///
/// A `pub add` command reads word by word, so each package argument counts,
/// not only the first. It ends at a line break, a backtick, a shell operator,
/// or the first word that is neither an option nor a package argument, so
/// prose after a command is not read as more packages. Path, Git, SDK, and
/// custom-host installs are skipped. Any other descriptor, including `any` or
/// a range, is returned as the constraint.
List<InstallCommand> installCommands(String source) {
  final commands = <InstallCommand>[
    for (final match in _pubAdd.allMatches(source))
      ..._pubAddCommand(source, match),
    for (final match in _globalActivate.allMatches(source))
      (
        package: match[1]!,
        start: match.start,
        argumentStart: match.start + match[0]!.indexOf(match[1]!),
        section: null,
        constraint: _constraint(
          match.start + match[0]!.lastIndexOf(match[3] ?? ''),
          match[3],
        ),
      ),
  ];
  return commands..sort((a, b) => a.argumentStart.compareTo(b.argumentStart));
}

List<InstallCommand> _pubAddCommand(String source, RegExpMatch command) {
  final installs = <InstallCommand>[];
  var dev = false;
  var hostedPin = true;
  var skipValue = false;
  var position = command.end;
  while (true) {
    position = _skipSpace(source, position);
    final word = _pubAddWord.matchAsPrefix(source, position);
    if (word == null) break;
    position = word.end;
    // Sentence punctuation after a word ends the command.
    final text = word[0]!.replaceFirst(RegExp(r'[.,!?]+$'), '');

    if (skipValue) {
      skipValue = false;
    } else if (text.startsWith('-')) {
      final option = text.split('=').first;
      if (option == '--dev' || option == '-d') dev = true;
      if (_pubAddSourceOptions.contains(option)) hostedPin = false;
      skipValue = _pubAddValueOptions.contains(text);
    } else {
      final argument = _pubAddPackage.firstMatch(text);
      if (argument == null) break;
      final install = _pubAddInstall(command, word.start, text, argument);
      if (install != null) installs.add(install);
    }
    if (text.length != word[0]!.length) break;
  }
  if (!hostedPin) return const [];
  return [
    for (final install in installs)
      (
        package: install.package,
        start: install.start,
        argumentStart: install.argumentStart,
        section: install.section ?? (dev ? 'dev' : null),
        constraint: install.constraint,
      ),
  ];
}

InstallCommand? _pubAddInstall(
  RegExpMatch command,
  int argumentStart,
  String text,
  RegExpMatch argument,
) {
  final package = argument[3]!;
  final descriptor = argument[5];
  // A `{...}` descriptor names a path, Git, SDK, or hosted-URL source.
  if (!pinnedInstallPackages.contains(package) ||
      (descriptor?.startsWith('{') ?? false)) {
    return null;
  }
  return (
    package: package,
    start: command.start,
    argumentStart: argumentStart,
    section: argument[2],
    constraint: _constraint(
      // The descriptor ends the word, before its closing quotes.
      argumentStart +
          text.length -
          argument[1]!.length -
          (argument[4] ?? '').length -
          (descriptor?.length ?? 0),
      descriptor,
    ),
  );
}

/// Skips blanks and backslash line continuations; a bare line break ends the
/// command, so it is left for the word match to refuse.
int _skipSpace(String source, int position) {
  while (position < source.length) {
    final unit = source[position];
    if (unit == ' ' || unit == '\t') {
      position++;
    } else if (source.startsWith('\\\n', position)) {
      position += 2;
    } else if (source.startsWith('\\\r\n', position)) {
      position += 3;
    } else {
      break;
    }
  }
  return position;
}

InstallConstraint? _constraint(int start, String? text) {
  if (text == null || text.isEmpty) return null;
  return (text: text, start: start, end: start + text.length);
}
