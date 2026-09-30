import 'directive_sort.dart';
import 'icon_registry.dart';

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
    if (rendered.contains('{{icon:')) {
      if (icons == null) {
        throw const FormatException(
          'Template uses icons but registry has no icons.yaml.',
        );
      }
      final library = icons.library(iconLibrary);
      final iconPattern = RegExp(r'\{\{icon:([^{}]+)\}\}');
      rendered = rendered.replaceAllMapped(iconPattern, (match) {
        final token = match.group(1)!;
        if (token == 'import') return "import '${library.import}';";
        return '${library.className}.${icons.constant(token, iconLibrary)}';
      });
    }
    final unresolved = RegExp(r'\{\{[^\n{}]*\}\}').firstMatch(rendered);
    if (unresolved != null) {
      throw FormatException(
        'Template contains unsupported token ${unresolved.group(0)}.',
      );
    }
    return sortDirectives('template', rendered);
  }
}
