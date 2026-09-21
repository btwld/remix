import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:remix_cli/src/installer.dart';
import 'package:remix_cli/src/cli.dart';
import 'package:remix_cli/src/project_config.dart';
import 'package:remix_cli/src/registry_reader.dart';
import 'package:remix_cli/src/registry_source.dart';
import 'package:remix_cli/src/process_runner.dart';
import 'package:yaml/yaml.dart';

/// The `remix` constraint the bundled registry declares, read from the file
/// itself rather than restated here.
///
/// These fixtures exercise the frozen schema-1/2 snapshot. They intentionally
/// follow its dependency floor rather than the current remote distribution.
final String registryRemixConstraint = _readRegistryRemixConstraint();

/// The lowest `remix` version [registryRemixConstraint] admits.
///
/// This is the version the frozen bundled templates were authored against;
/// current-source alignment checks apply separately to the remote distribution.
final Version registryRemixFloor =
    (VersionConstraint.parse(registryRemixConstraint) as VersionRange).min!;

String _readRegistryRemixConstraint() {
  // `dart test` runs with the package root as the current directory.
  final document = loadYaml(
    File(
      p.join('lib', 'src', 'registry', 'default', 'registry.yaml'),
    ).readAsStringSync(),
  );
  final items = (document as YamlMap)['items'] as YamlMap;
  for (final item in items.values) {
    final dependencies = (item as YamlMap)['dependencies'];
    if (dependencies is YamlMap && dependencies['remix'] is String) {
      return dependencies['remix'] as String;
    }
  }
  throw StateError('registry.yaml declares no remix constraint.');
}

Directory createFlutterPackage() {
  final root = Directory.systemTemp.createTempSync('remix_cli_test_');
  File(p.join(root.path, 'pubspec.yaml')).writeAsStringSync('''name: consumer
environment:
  sdk: ">=3.12.0 <4.0.0"
dependencies:
  flutter:
    sdk: flutter
''');
  Directory(p.join(root.path, 'lib')).createSync();
  return root;
}

Map<String, List<int>> snapshotFiles(Directory root) {
  final snapshot = <String, List<int>>{};
  for (final entity in root.listSync(recursive: true)) {
    if (entity is File) {
      snapshot[p.relative(entity.path, from: root.path)] = entity
          .readAsBytesSync();
    }
  }
  return snapshot;
}

void writeRequiredPubspec(
  Directory root, {
  String? remix,
  String mixAnnotations = '^2.2.0-beta.1',
  String? mixChart,
  String? remixUiIcons,
  String buildRunner = '^2.10.1',
  String mixGenerator = '^2.2.0-beta.3',
}) {
  final remixUiIconsDependency = remixUiIcons == null
      ? ''
      : '  remix_ui_icons: $remixUiIcons\n';
  final mixChartDependency = mixChart == null ? '' : '  mix_chart: $mixChart\n';
  File(p.join(root.path, 'pubspec.yaml')).writeAsStringSync('''name: consumer
environment:
  sdk: ">=3.12.0 <4.0.0"
dependencies:
  flutter:
    sdk: flutter
  remix: ${remix ?? registryRemixConstraint}
  mix_annotations: $mixAnnotations
$mixChartDependency${remixUiIconsDependency}dev_dependencies:
  build_runner: $buildRunner
  mix_generator: $mixGenerator
''');
}

void writeRequiredLock(
  Directory root, {
  String? remix,
  String mixAnnotations = '2.2.0-beta.1',
  String? mixChart,
  String? remixUiIcons,
  String buildRunner = '2.10.1',
  String mixGenerator = '2.2.0-beta.3',
}) {
  final remixUiIconsPackage = remixUiIcons == null
      ? ''
      : '  remix_ui_icons:\n    version: "$remixUiIcons"\n';
  final mixChartPackage = mixChart == null
      ? ''
      : '  mix_chart:\n    version: "$mixChart"\n';
  File(p.join(root.path, 'pubspec.lock')).writeAsStringSync('''packages:
  remix:
    version: "${remix ?? registryRemixFloor}"
  mix_annotations:
    version: "$mixAnnotations"
$mixChartPackage${remixUiIconsPackage}  build_runner:
    version: "$buildRunner"
  mix_generator:
    version: "$mixGenerator"
''');
}

final class RecordingProcessRunner implements ProcessRunner {
  RecordingProcessRunner(this.handler);

  final Future<ProcessOutput> Function(ProcessInvocation invocation) handler;
  final calls = <ProcessInvocation>[];

  @override
  Future<ProcessOutput> run(ProcessInvocation invocation) {
    calls.add(invocation);
    return handler(invocation);
  }
}

const successProcessOutput = ProcessOutput(exitCode: 0, stdout: '', stderr: '');

String fakeFlutterMachineJson(Directory root) =>
    '{"flutterRoot":"${root.path}","frameworkVersion":"3.44.0"}';

final class RecordingFileWriter implements ProjectFileWriter {
  RecordingFileWriter(this.root);

  final Directory root;
  final paths = <String>[];
  final AtomicProjectFileWriter _delegate = const AtomicProjectFileWriter();

  @override
  void write(File target, String contents) {
    paths.add(p.relative(target.path, from: root.path));
    _delegate.write(target, contents);
  }
}

/// Existing schema-2 consumers remain covered independently of remote init.
extension BundledProjectFixture on Installer {
  Future<void> initializeBundled(InitOptions options) async {
    final config = LegacyProject(
      packageRoot: projectRoot,
      prefix: options.prefix,
      preset: options.preset,
      uiPath: options.uiPath,
    );
    File(
      p.join(projectRoot.path, 'remix.yaml'),
    ).writeAsStringSync(config.encode());
    await initialize(options);
  }
}

/// Serves the frozen bundle as if it were the published distribution, so
/// installer tests get real catalog content without a network.
final class FixtureOfficialResolver implements RegistrySources {
  const FixtureOfficialResolver();

  @override
  Future<RegistrySource> latestOfficial() async => RegistrySource(
    repository: officialRepository,
    path: 'registry',
    ref: 'registry-v1',
    revision: 'a' * 40,
  );

  @override
  Future<RegistrySource> resolve({
    required String repository,
    String path = 'registry',
    String? ref,
  }) async => RegistrySource(
    repository: repository,
    path: path,
    ref: ref ?? 'main',
    revision: 'a' * 40,
  );

  @override
  RegistryReader open(RegistrySource pin, String preset) {
    if (preset != 'vanilla' && preset != 'fortal') {
      throw FormatException('Official registry has no $preset preset.');
    }
    return BundledRegistry(preset == 'vanilla' ? 'default' : preset);
  }
}
