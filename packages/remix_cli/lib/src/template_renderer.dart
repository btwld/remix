import 'directive_sort.dart';
import 'icon_registry.dart';

/// The placeholder for the chosen icon library's import directive.
const iconImportToken = '{{icon:import}}';

/// The placeholder for [canonical]'s constant in the chosen icon library.
String iconToken(String canonical) => '{{icon:$canonical}}';

/// Resolves a registry template for one application: its prefixes and its
/// icon library. The registry build renders its own templates back through
/// this to prove each one reverses to the authored source.
final _iconPattern = RegExp(r'\{\{icon:([^{}]+)\}\}');
final _anyToken = RegExp(r'\{\{[^\n{}]*\}\}');

final class TemplateRenderer {
  const TemplateRenderer();

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
      final library = icons.library(iconLibrary);
      rendered = rendered.replaceAllMapped(_iconPattern, (match) {
        if (match[0] == iconImportToken) return "import '${library.import}';";
        return '${library.className}.${icons.constant(match[1]!, iconLibrary)}';
      });
    }
    final unresolved = _anyToken.firstMatch(rendered);
    if (unresolved != null) {
      throw FormatException(
        'Template contains unsupported token ${unresolved[0]}.',
      );
    }
    // The library's import replaces the placeholder in place; re-sort so it
    // lands where directives_ordering expects. Other files are left as
    // authored, so a template without icons installs byte for byte.
    return importsIcons ? sortDirectives('template', rendered) : rendered;
  }
}
