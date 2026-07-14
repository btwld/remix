import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

const _jsonEncoder = JsonEncoder.withIndent('  ');

void main(List<String> arguments) {
  final unknown = arguments.where((argument) => argument != '--check').toList();
  if (unknown.isNotEmpty) {
    stderr.writeln('Unknown arguments: ${unknown.join(' ')}');
    exitCode = 64;

    return;
  }

  final checkOnly = arguments.contains('--check');
  final packageRoot = Directory.current;
  final workspaceRoot = packageRoot.parent.parent;
  final sourceRoot = Directory('${packageRoot.path}/test/atlas/goldens');
  final bundleRoot = Directory('${workspaceRoot.path}/atlas/fortal');
  final flutterVersion = _flutterVersion(workspaceRoot);
  final assets = <({String source, String destination})>[
    (source: 'catalog.json', destination: 'catalog.json'),
    (source: 'light/button.json', destination: 'light/button.json'),
    (source: 'light/button.png', destination: 'light/button.png'),
    (source: 'dark/button.json', destination: 'dark/button.json'),
    (source: 'dark/button.png', destination: 'dark/button.png'),
    (
      source: 'protocol/themes/light.mix.json',
      destination: 'themes/light.mix.json',
    ),
    (
      source: 'protocol/themes/dark.mix.json',
      destination: 'themes/dark.mix.json',
    ),
    (source: 'protocol/coverage.json', destination: 'protocol/coverage.json'),
    (
      source: 'protocol/fixtures/fortal-tokenized-flex-box.mix.json',
      destination: 'protocol/fixtures/fortal-tokenized-flex-box.mix.json',
    ),
  ];
  final files = <({String path, List<int> bytes})>[];
  for (final asset in assets) {
    final source = File('${sourceRoot.path}/${asset.source}');
    if (!source.existsSync()) {
      stderr.writeln('Missing validated Atlas source: ${source.path}');
      exitCode = 1;

      return;
    }
    files.add((path: asset.destination, bytes: source.readAsBytesSync()));
  }
  files.sort((a, b) => a.path.compareTo(b.path));

  final manifest = <String, Object?>{
    'schema': 'mix_atlas/capture/v1',
    'id': 'fortal',
    'producer': {
      'atlas': '0.1.0',
      'mixProtocolVersion': '1.0.0',
      'mixProtocolFormat': 1,
      'flutter': flutterVersion,
    },
    'catalog': 'catalog.json',
    'themes': [
      {'id': 'light', 'document': 'themes/light.mix.json'},
      {'id': 'dark', 'document': 'themes/dark.mix.json'},
    ],
    'protocolCoverage': 'protocol/coverage.json',
    'files': [
      for (final file in files)
        {
          'path': file.path,
          'sha256': sha256.convert(file.bytes).toString(),
          'bytes': file.bytes.length,
        },
    ],
  };
  final manifestBytes = utf8.encode('${_jsonEncoder.convert(manifest)}\n');

  final drift = <String>[];
  for (final file in files) {
    final destination = File('${bundleRoot.path}/${file.path}');
    if (checkOnly) {
      if (!destination.existsSync() ||
          !_bytesEqual(destination.readAsBytesSync(), file.bytes)) {
        drift.add(file.path);
      }
    } else {
      destination.parent.createSync(recursive: true);
      destination.writeAsBytesSync(file.bytes);
    }
  }

  final manifestFile = File('${bundleRoot.path}/capture.json');
  if (checkOnly) {
    if (!manifestFile.existsSync() ||
        !_bytesEqual(manifestFile.readAsBytesSync(), manifestBytes)) {
      drift.add('capture.json');
    }
  } else {
    manifestFile.parent.createSync(recursive: true);
    manifestFile.writeAsBytesSync(manifestBytes);
  }

  if (drift.isNotEmpty) {
    stderr.writeln('Fortal Atlas bundle drift: ${drift.join(', ')}');
    stderr.writeln(
      'Run `fvm dart run tool/package_fortal_atlas.dart` to regenerate it.',
    );
    exitCode = 1;

    return;
  }

  _verifyBundle(bundleRoot, manifest);
  final totalBytes = files.fold<int>(
    manifestBytes.length,
    (total, file) => total + file.bytes.length,
  );
  stdout.writeln(
    '${checkOnly ? 'Verified' : 'Packaged'} Fortal Atlas bundle: '
    '${files.length + 1} files, $totalBytes bytes.',
  );
}

String _flutterVersion(Directory workspaceRoot) {
  final config = jsonDecode(
    File('${workspaceRoot.path}/.fvmrc').readAsStringSync(),
  );
  if (config is! Map<String, Object?> || config['flutter'] is! String) {
    throw const FormatException('.fvmrc must contain a Flutter version.');
  }

  return config['flutter']! as String;
}

void _verifyBundle(Directory root, Map<String, Object?> manifest) {
  final entries = manifest['files'];
  if (entries is! List<Object?>) {
    throw const FormatException('Capture manifest files must be a list.');
  }
  for (final entry in entries) {
    if (entry is! Map<String, Object?>) {
      throw const FormatException('Capture manifest file entry is invalid.');
    }
    final path = entry['path'];
    final expectedHash = entry['sha256'];
    final expectedBytes = entry['bytes'];
    if (path is! String || expectedHash is! String || expectedBytes is! int) {
      throw const FormatException('Capture manifest file metadata is invalid.');
    }
    final bytes = File('${root.path}/$path').readAsBytesSync();
    if (bytes.length != expectedBytes ||
        sha256.convert(bytes).toString() != expectedHash) {
      throw StateError('Packaged Atlas file failed integrity check: $path');
    }
  }
}

bool _bytesEqual(List<int> left, List<int> right) {
  if (left.length != right.length) return false;
  for (var index = 0; index < left.length; index += 1) {
    if (left[index] != right[index]) return false;
  }

  return true;
}
