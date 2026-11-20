import 'package:path/path.dart' as p;
import 'package:remix_cli/src/icon_registry.dart';
import 'package:remix_cli/src/registry.dart';
import 'package:remix_cli/src/registry_reader.dart';
import 'package:remix_cli/src/template_renderer.dart';

import 'dart_directive_uris.dart';

typedef _TemplateReference = ({String target, String uri, int line});

/// Checks each item against the files and direct runtime dependencies its solo
/// install would supply, without running pub, code generation, or analysis.
Future<List<String>> auditRegistryClosures(
  RegistryReader registry, {
  required String iconLibrary,
}) async {
  final catalog = await registry.catalog();
  const renderer = TemplateRenderer();
  IconRegistry? icons;
  final owners = <String, String>{};
  final sources =
      <
        String,
        ({List<_TemplateReference> references, Set<String> iconPackages})
      >{};

  for (final item in catalog.items.values) {
    final sourceInfo = sources[item.name] = (references: [], iconPackages: {});
    for (final target in item.generated) {
      owners[target] = item.name;
    }
    for (final file in item.files) {
      owners[file.target] = item.name;
      final source = await registry.template(file);
      if (source.contains('{{icon:')) {
        final iconTable = icons ??= IconRegistry.parse(await registry.icons());
        for (final library in renderer.iconLibraries(
          source,
          icons: iconTable,
          iconLibrary: iconLibrary,
        )) {
          sourceInfo.iconPackages.addAll(
            iconTable.library(library).dependencies.keys,
          );
        }
      }
      if (!file.target.endsWith('.dart')) continue;
      final rendered = renderer.render(
        source,
        typePrefix: 'Solo',
        valuePrefix: 'solo',
        icons: icons,
        iconLibrary: iconLibrary,
      );
      for (final (:uri, :line) in dartDirectiveUris(
        rendered,
        path: file.target,
      )) {
        sourceInfo.references.add((target: file.target, uri: uri, line: line));
      }
    }
  }

  final problems = <String>[];
  for (final item in catalog.items.values) {
    final closure = catalog.resolve(item.name);
    final included = closure.map((dependency) => dependency.name).toSet();
    final packages = {
      'flutter',
      for (final dependency in closure) ...dependency.dependencies.keys,
      for (final dependency in closure)
        ...sources[dependency.name]!.iconPackages,
    };
    for (final reference in sources[item.name]!.references) {
      final location = '${item.name} (${reference.target}:${reference.line})';
      final uri = Uri.parse(reference.uri);
      if (uri.scheme == 'dart') continue;
      if (uri.scheme == 'package') {
        final package = uri.pathSegments.firstOrNull;
        if (!packages.contains(package)) {
          problems.add(
            '$location: `${reference.uri}` requires a direct package '
            'declaration in `dependencies` of its install closure.',
          );
        }
        continue;
      }
      if (uri.hasScheme || uri.hasAuthority || uri.hasAbsolutePath) {
        problems.add('$location: `${reference.uri}` is not a relative URI.');
        continue;
      }
      final source = reference.target.substring(uiTargetPrefix.length);
      final relative = p.posix.normalize(
        p.posix.join(p.posix.dirname(source), uri.path),
      );
      if (relative == 'ui.dart') continue;
      final target = '$uiTargetPrefix$relative';
      final owner = owners[target];
      if (owner == null) {
        problems.add(
          '$location: `${reference.uri}` resolves to $target, which no item '
          'provides as an authored or generated file.',
        );
      } else if (!included.contains(owner)) {
        problems.add(
          '$location: `${reference.uri}` resolves to $target from `$owner`, '
          'which is missing from its `registryDependencies` closure.',
        );
      }
    }
  }
  return problems;
}
