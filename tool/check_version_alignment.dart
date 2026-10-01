import 'dart:io';

import 'package:pub_semver/pub_semver.dart';
import 'package:yaml/yaml.dart';

import '../packages/remix_cli/lib/src/icon_registry.dart';

/// The registry file whose package constraints must floor at the versions of
/// the workspace packages they name.
const _registryPath = 'registry/vanilla/registry.yaml';

/// A workspace package the registry pins, and how to repair a drifted floor.
typedef _Pinned = ({String package, String fix});

/// Every workspace package a registry item depends on. `remix_ui_fonts` is
/// declared by the Vanilla theme item, which sets its type in Geist.
const _pinned = <_Pinned>[
  (package: 'remix', fix: 'Run `dart run tool/sync_registry_remix.dart`.'),
  (
    package: 'remix_ui_fonts',
    fix:
        'Set the theme item\'s remix_ui_fonts constraint in '
        '$_registryPath to the new version, then run '
        '`dart run tool/build_registry.dart`.',
  ),
];

void main() {
  final workspaceRoot = Directory.current.absolute;
  final failures = <String>[];
  for (final pinned in _pinned) {
    final version = _packageVersion(workspaceRoot, pinned.package, failures);
    if (version != null) {
      _checkRegistryFloor(workspaceRoot, pinned, version, failures);
    }
  }
  final icons = _packageVersion(workspaceRoot, 'remix_ui_icons', failures);
  if (icons != null) _checkIconTableFloor(workspaceRoot, icons, failures);

  if (failures.isEmpty) return;

  stderr.writeln('Version alignment validation failed:');
  for (final failure in failures) {
    stderr.writeln('- $failure');
  }
  exitCode = 1;
}

Version? _packageVersion(
  Directory workspaceRoot,
  String package,
  List<String> failures,
) {
  final path = 'packages/$package/pubspec.yaml';
  final file = File('${workspaceRoot.path}/$path');
  if (!file.existsSync()) {
    failures.add('$path is missing');
    return null;
  }
  final declared = (loadYaml(file.readAsStringSync()) as YamlMap)['version'];
  if (declared is! String) {
    failures.add('$package does not declare a version');
    return null;
  }
  try {
    return Version.parse(declared);
  } on FormatException {
    failures.add('$package declares an unparseable version "$declared"');
    return null;
  }
}

/// Holds the remote registry constraint on [pinned] to its released version.
///
/// The registry is data, not a pubspec dependency, so `melos version` never
/// rewrites it. Left alone, `remix: ^1.0.0-beta.7` would keep admitting every
/// later beta while the templates were only ever tested against the floor —
/// and nothing would say so. This is the coupling that makes the floor mean
/// "the version this snapshot was authored against", which is what the
/// installer's drift notice reports.
///
/// Equality is strict on purpose. Accepting `floor <= remix` would let a
/// hand-run bump drift the two apart with no failure to stop it.
void _checkRegistryFloor(
  Directory workspaceRoot,
  _Pinned pinned,
  Version version,
  List<String> failures,
) {
  final package = pinned.package;
  final registryFile = File('${workspaceRoot.path}/$_registryPath');
  if (!registryFile.existsSync()) {
    failures.add('$_registryPath is missing');
    return;
  }

  final document = loadYaml(registryFile.readAsStringSync());
  final items = document is YamlMap ? document['items'] : null;
  if (items is! YamlMap) {
    failures.add('$_registryPath is not in the expected shape');
    return;
  }

  // Every item but one inherits the constraint through `registryDependencies`,
  // so a second declaration would be a second thing to keep in step.
  final declaring = <String, String>{};
  for (final entry in items.entries) {
    final dependencies = (entry.value as YamlMap)['dependencies'];
    if (dependencies is! YamlMap) continue;
    final constraint = dependencies[package];
    if (constraint is String) declaring['${entry.key}'] = constraint;
  }
  if (declaring.length != 1) {
    failures.add(
      'the registry declares $package in ${declaring.length} items '
      '(${declaring.keys.join(', ')}); exactly one item must declare it so '
      'there is a single constraint to keep aligned',
    );
    return;
  }

  final item = declaring.keys.single;
  final declared = declaring.values.single;
  final VersionConstraint constraint;
  try {
    constraint = VersionConstraint.parse(declared);
  } on FormatException {
    failures.add(
      '$_registryPath item $item declares an unparseable $package '
      'constraint "$declared"',
    );
    return;
  }

  final floor = constraint is VersionRange ? constraint.min : null;
  if (floor == null) {
    failures.add(
      '$_registryPath item $item declares $package "$declared", which has no '
      'lower bound. The floor is what records the tested version, so the '
      'constraint must name one.',
    );
    return;
  }
  if (floor != version) {
    failures.add(
      '$_registryPath item $item declares $package "$declared", flooring at '
      '$floor, but packages/$package is $version. ${pinned.fix}',
    );
    return;
  }

  stdout.writeln(
    'Registry floor aligned: remote item $item declares $package '
    '"$declared" against $package $version.',
  );
}

/// The icon table that pins the default library's package for every item.
const _iconTablePath = 'registry/icons.yaml';

/// Holds the icon table's `remix_ui_icons` constraint to the released
/// package, for the same reason as [_checkRegistryFloor]: the table is data
/// that no version bump rewrites.
void _checkIconTableFloor(
  Directory workspaceRoot,
  Version version,
  List<String> failures,
) {
  final file = File('${workspaceRoot.path}/$_iconTablePath');
  if (!file.existsSync()) {
    failures.add('$_iconTablePath is missing');
    return;
  }
  final IconRegistry table;
  try {
    table = IconRegistry.parse(file.readAsStringSync());
  } on FormatException catch (error) {
    failures.add(error.message);
    return;
  }
  final constraint = table
      .library(defaultIconLibrary)
      .dependencies['remix_ui_icons'];
  final floor = constraint is VersionRange ? constraint.min : null;
  if (floor != version) {
    failures.add(
      '$_iconTablePath pins remix_ui_icons "$constraint", but '
      'packages/remix_ui_icons is $version. Set the '
      '$defaultIconLibrary library\'s dependency to the new version.',
    );
    return;
  }
  stdout.writeln(
    'Icon table floor aligned: $_iconTablePath declares remix_ui_icons '
    '"$constraint" against remix_ui_icons $version.',
  );
}
