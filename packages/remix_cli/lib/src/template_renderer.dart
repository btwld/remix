import 'directive_sort.dart';
import 'icon_registry.dart';

/// The placeholder for the chosen icon library's import directive.
const iconImportToken = '{{icon:import}}';

/// The placeholder for [canonical]'s constant in the chosen icon library.
String iconToken(String canonical) => '{{icon:$canonical}}';

final _iconPattern = RegExp(r'\{\{icon:([^{}]+)\}\}');
final _anyToken = RegExp(r'\{\{[^\n{}]*\}\}');

/// Resolves a registry template for one application: its prefixes and its
/// icon library. The registry build renders its own templates back through
/// this to prove each one reverses to the authored source.
final class TemplateRenderer {
  const TemplateRenderer();

  /// The icon libraries [source]'s icons render from for [iconLibrary]:
  /// [iconLibrary] itself, plus the fallback of any icon it does not map.
  ///
  /// A template that imports icons but names none still imports
  /// [iconLibrary].
  Set<String> iconLibraries(
    String source, {
    required IconRegistry icons,
    String iconLibrary = defaultIconLibrary,
  }) {
    final used = <String>{
      for (final match in _iconPattern.allMatches(source))
        if (match[0] != iconImportToken)
          icons.resolve(match[1]!, iconLibrary).library,
    };
    return used.isEmpty && source.contains(iconImportToken)
        ? {iconLibrary}
        : used;
  }

  String render(
    String source, {
    required String typePrefix,
    required String valuePrefix,
    IconRegistry? icons,
    String iconLibrary = defaultIconLibrary,
  }) {
    var rendered = source
        .replaceAll('{{typePrefix}}', typePrefix)
        .replaceAll('{{valuePrefix}}', valuePrefix);
    final importsIcons = rendered.contains(iconImportToken);
    if (rendered.contains('{{icon:')) {
      if (icons == null) {
        throw const FormatException(
          'Template uses icons but registry has no icons.yaml.',
        );
      }
      // One import per library a constant renders from: the chosen library,
      // and the fallback library of any icon it does not have.
      final imports = [
        for (final name in iconLibraries(
          rendered,
          icons: icons,
          iconLibrary: iconLibrary,
        ))
          "import '${icons.library(name).import}';",
      ]..sort();
      rendered = rendered.replaceAllMapped(_iconPattern, (match) {
        if (match[0] == iconImportToken) return imports.join('\n');
        final resolved = icons.resolve(match[1]!, iconLibrary);
        return '${icons.library(resolved.library).className}.'
            '${resolved.constant}';
      });
    }
    final unresolved = _anyToken.firstMatch(rendered);
    if (unresolved != null) {
      throw FormatException(
        'Template contains unsupported token ${unresolved[0]}. The registry '
        'may need a newer remix_cli; upgrade it and try again.',
      );
    }
    // The library's import replaces the placeholder in place; re-sort so it
    // lands where directives_ordering expects. Other files are left as
    // authored, so a template without icons installs byte for byte.
    return importsIcons ? sortDirectives('template', rendered) : rendered;
  }
}
