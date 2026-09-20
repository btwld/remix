import 'dart:io';
import 'dart:isolate';

import 'registry.dart';

/// One registry, already pinned, serving one preset.
///
/// A project selects exactly one preset, so a reader is opened for a preset
/// rather than taking one per call. The two operations stay separate because
/// preset resolution is layout-specific: the published distribution maps
/// presets through `index.yaml`, and the frozen bundled snapshot has no index
/// at all.
abstract interface class RegistryReader {
  /// The parsed catalog for this reader's preset.
  Future<RegistryCatalog> catalog();

  /// The template source for [file], resolved against this registry's root.
  Future<String> template(RegistryFile file);
}

/// The frozen schema-1/2 snapshot shipped inside this package.
///
/// It predates `index.yaml`: each preset is a sibling directory holding its own
/// `registry.yaml`, so the preset selects the directory directly.
final class BundledRegistry implements RegistryReader {
  BundledRegistry(this.preset) {
    if (!bundledPresets.contains(preset)) {
      throw FormatException(
        'Unknown preset $preset. Bundled presets: '
        '${bundledPresets.join(', ')}.',
      );
    }
  }

  final String preset;

  @override
  Future<RegistryCatalog> catalog() async =>
      RegistryCatalog.parse(await _read('registry.yaml'), preset: preset);

  @override
  Future<String> template(RegistryFile file) => _read(file.source);

  Future<String> _read(String relative) async {
    final uri = Uri.parse('package:remix_cli/src/registry/$preset/$relative');
    final resolved = await Isolate.resolvePackageUri(uri);
    if (resolved == null) {
      throw StateError('Could not resolve bundled registry asset $uri.');
    }
    if (resolved.scheme != 'file') {
      throw StateError('Registry asset $uri did not resolve to a file.');
    }
    return File.fromUri(resolved).readAsString();
  }
}
