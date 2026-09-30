import 'dart:io';

import 'package:remix_cli/src/directive_sort.dart';
import 'package:remix_cli/src/icon_registry.dart';
import 'package:remix_cli/src/template_renderer.dart';
import 'package:test/test.dart';

void main() {
  const renderer = TemplateRenderer();

  test('renders Ui and Acme identifiers everywhere literally', () {
    const source = '''/// {{typePrefix}}Button calls {{valuePrefix}}ButtonStyle.
class {{typePrefix}}Button {}
void {{valuePrefix}}ButtonStyle() {}
''';

    expect(
      renderer.render(source, typePrefix: 'Ui', valuePrefix: 'ui'),
      contains('class UiButton'),
    );
    final acme = renderer.render(
      source,
      typePrefix: 'Acme',
      valuePrefix: 'acme',
    );
    expect(acme, contains('AcmeButton calls acmeButtonStyle'));
    expect(acme, isNot(contains('{{')));
  });

  test('rejects every unsupported or unresolved token', () {
    for (final source in [
      '{{unknown}}',
      '{{ typePrefix }}',
      '{{condition}}body{{/condition}}',
    ]) {
      expect(
        () => renderer.render(source, typePrefix: 'Ui', valuePrefix: 'ui'),
        throwsFormatException,
      );
    }
  });

  test('resolves icon placeholders to the selected library', () {
    final icons = IconRegistry.parse(
      File('../../registry/icons.yaml').readAsStringSync(),
    );
    const source = "{{icon:import}}\nicon: {{icon:bell}},\n";

    final remix = renderer.render(
      source,
      typePrefix: 'Ui',
      valuePrefix: 'ui',
      icons: icons,
    );
    expect(remix, contains("package:remix_ui_icons/remix_ui_icons.dart"));
    expect(remix, contains('RemixIcons.bell'));

    final lucide = renderer.render(
      source,
      typePrefix: 'Ui',
      valuePrefix: 'ui',
      icons: icons,
      iconLibrary: 'lucide',
    );
    expect(lucide, contains("package:lucide_flutter/lucide_flutter.dart"));
    expect(lucide, contains('LucideIcons.bell'));
    expect(lucide, isNot(contains('remix_ui_icons')));
    expect(lucide, isNot(contains('RemixIcons')));
    expect(
      renderer.render(
        'icon: {{icon:reload}}, {{icon:update}}',
        typePrefix: 'Ui',
        valuePrefix: 'ui',
        icons: icons,
        iconLibrary: 'lucide',
      ),
      'icon: LucideIcons.rotateCcw, LucideIcons.loaderCircle',
    );
  });

  group('icons.yaml', () {
    String table({String lucide = '{remix: update, lucide: loaderCircle}'}) =>
        '''
schema: 1
libraries:
  remix: {dependency: {remix_ui_icons: ^0.1.0}, import: "package:remix_ui_icons/remix_ui_icons.dart", class: RemixIcons}
  lucide: {dependency: {lucide_flutter: ^1.47.0}, import: "package:lucide_flutter/lucide_flutter.dart", class: LucideIcons}
icons:
  reload: {remix: reload, lucide: rotateCcw}
  update: $lucide
''';

    Matcher failsWith(String message) => throwsA(
      isA<FormatException>().having(
        (error) => error.message,
        'message',
        contains(message),
      ),
    );

    test('parses a complete table', () {
      final icons = IconRegistry.parse(table());
      expect(icons.library('lucide').className, 'LucideIcons');
      expect(icons.constant('update', 'lucide'), 'loaderCircle');
    });

    test('rejects a constant claimed by two names', () {
      expect(
        () => IconRegistry.parse(
          table(lucide: '{remix: update, lucide: rotateCcw}'),
        ),
        failsWith('maps lucide.rotateCcw to both reload and update'),
      );
    });

    test('names the field that is missing, unknown, or malformed', () {
      expect(
        () => IconRegistry.parse(table(lucide: '{remix: update}')),
        failsWith('icons.update is missing lucide'),
      );
      expect(
        () => IconRegistry.parse(
          table(lucide: '{remix: update, lucide: x, material: y}'),
        ),
        failsWith('icons.update has unknown keys: material'),
      );
      expect(
        () => IconRegistry.parse(
          table(lucide: '{remix: renamed, lucide: loaderCircle}'),
        ),
        failsWith('icons.update.remix must be update'),
      );
      expect(
        () => IconRegistry.parse(
          table().replaceFirst('{lucide_flutter: ^1.47.0}', '{}'),
        ),
        failsWith('libraries.lucide.dependency must name one package'),
      );
    });
  });

  test('leaves a template without icons exactly as authored', () {
    // Relative imports out of directives_ordering order stay put: only a
    // substituted icon import triggers a re-sort.
    const source = '''
import 'package:remix/remix.dart';

import 'base_button.dart';
import '../theme/theme.dart';
''';
    expect(
      renderer.render(source, typePrefix: 'Ui', valuePrefix: 'ui'),
      source,
    );
  });

  test('sorts a multi-line import without dropping the show clause', () {
    const source = '''
import 'package:remix/remix.dart'
    show MixToken;

import 'dart:math' as math;

class Example {}
''';
    final sorted = sortDirectives('template', source);
    expect(sorted, contains("import 'dart:math' as math;"));
    expect(sorted, contains('    show MixToken;'));
    expect(
      sorted.indexOf('dart:math'),
      lessThan(sorted.indexOf('package:remix')),
    );
    expect(sorted, contains('class Example {}'));
  });
}
