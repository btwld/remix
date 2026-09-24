import 'registry.dart';

/// One registry, already pinned, serving one preset.
///
/// A project selects exactly one preset, so a reader is opened for a preset
/// rather than taking one per call. Resolving the preset to a catalog path is
/// the reader's own concern: the published distribution maps presets through
/// `index.yaml`, and a reader is free to lay itself out differently.
abstract interface class RegistryReader {
  /// The parsed catalog for this reader's preset.
  Future<RegistryCatalog> catalog();

  /// The template source for [file], resolved against this registry's root.
  Future<String> template(RegistryFile file);
}
