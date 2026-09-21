import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:remix_cli/src/installer.dart';
import 'package:remix_cli/src/registry_reader.dart';
import 'package:remix_cli/src/registry_source.dart';
import 'package:remix_cli/src/process_runner.dart';
import 'package:yaml/yaml.dart';

import 'checkout_registry.dart';

/// The `remix` constraint the committed Vanilla catalog declares, read from
/// the file itself rather than restated here.
final String registryRemixConstraint = _readRegistryConstraint('remix');

/// The lowest `remix` version [registryRemixConstraint] admits, which is the
/// version the committed templates are authored against.
final Version registryRemixFloor = _floorOf(registryRemixConstraint);

/// The same, for the `mix_chart` release the `chart` item is built against.
final String registryMixChartConstraint = _readRegistryConstraint('mix_chart');
final Version registryMixChartFloor = _floorOf(registryMixChartConstraint);

Version _floorOf(String constraint) =>
    (VersionConstraint.parse(constraint) as VersionRange).min!;

/// The constraint the catalog declares for [package], from the first item that
/// depends on it. Reading it back is what keeps these fixtures honest: a floor
/// raised in `registry/` moves here without an edit.
String _readRegistryConstraint(String package) {
  final document = loadYaml(
    File(
      p.join(findCheckoutRegistry().path, 'vanilla', 'registry.yaml'),
    ).readAsStringSync(),
  );
  final items = (document as YamlMap)['items'] as YamlMap;
  for (final item in items.values) {
    final dependencies = (item as YamlMap)['dependencies'];
    if (dependencies is YamlMap && dependencies[package] is String) {
      return dependencies[package] as String;
    }
  }
  throw StateError('registry.yaml declares no $package constraint.');
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

/// Serves the committed `registry/` tree as if it were the published
/// distribution, so installer tests get real catalog content without a
/// network -- and get the content this checkout is proposing.
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
    return CheckoutRegistry(findCheckoutRegistry(), preset);
  }
}
