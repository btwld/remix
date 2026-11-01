import 'dart:io';

import 'package:remix_cli/src/directive_sort.dart';
import 'package:remix_cli/src/icon_registry.dart';
import 'package:remix_cli/src/template_renderer.dart';
import 'package:test/test.dart';

import 'checkout_registry.dart';

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
      File('${findCheckoutRegistry().path}/icons.yaml').readAsStringSync(),
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

    test('schema 1 rejects fallback keys on otherwise valid mappings', () {
      expect(
        () => IconRegistry.parse(
          table(
            lucide: '{remix: update, lucide: loaderCircle, fallback: lucide}',
          ),
        ),
        failsWith('icons.update has unknown keys: fallback'),
      );
    });
  });

  group('icons.yaml schema 2', () {
    String table({String extra = ''}) => '''
schema: 2
libraries:
  remix: {dependency: {remix_ui_icons: ^1.0.0-beta.1}, import: "package:remix_ui_icons/remix_ui_icons.dart", class: RemixIcons}
  lucide: {dependency: {lucide_flutter: ^1.47.0}, import: "package:lucide_flutter/lucide_flutter.dart", class: LucideIcons}
icons:
  magnifyingGlass: {remix: search, lucide: search}
  checkCircled: {lucide: circleCheck, fallback: lucide}
$extra''';

    Matcher failsWith(String message) => throwsA(
      isA<FormatException>().having(
        (error) => error.message,
        'message',
        contains(message),
      ),
    );

    test('a default constant may differ from the canonical name', () {
      final icons = IconRegistry.parse(table());
      expect(icons.schema, 2);
      expect(icons.constant('magnifyingGlass', 'remix'), 'search');
      expect(icons.canonicalFor('remix', 'search'), 'magnifyingGlass');
      expect(icons.canonicalFor('remix', 'magnifyingGlass'), isNull);
    });

    test('an icon a library lacks resolves to its fallback', () {
      final icons = IconRegistry.parse(table());
      expect(icons.resolve('checkCircled', 'remix'), (
        library: 'lucide',
        constant: 'circleCheck',
      ));
      expect(icons.resolve('checkCircled', 'lucide'), (
        library: 'lucide',
        constant: 'circleCheck',
      ));
      expect(icons.fallbacks, {'checkCircled': 'lucide'});
      // A fallback constant stands for the icon only where the default
      // library has none: Lucide's search is magnifyingGlass's, not ours.
      expect(icons.canonicalFor('lucide', 'circleCheck'), 'checkCircled');
      expect(icons.canonicalFor('lucide', 'search'), isNull);
    });

    test('rejects a missing mapping without a fallback', () {
      expect(
        () => IconRegistry.parse(table(extra: '  box: {lucide: box}\n')),
        failsWith('icons.box has no remix mapping'),
      );
    });

    test('rejects a library whose name is reserved for fallbacks', () {
      expect(
        () => IconRegistry.parse(
          table().replaceFirst(
            '  lucide:',
            '  fallback: {dependency: {fallback_icons: ^1.0.0}, '
                'import: package:fallback_icons/icons.dart, class: FallbackIcons}\n'
                '  lucide:',
          ),
        ),
        failsWith('library fallback clashes with the fallback key'),
      );
    });

    test('rejects a fallback that cannot render the icon', () {
      expect(
        () => IconRegistry.parse(
          table(extra: '  box: {lucide: box, fallback: material}\n'),
        ),
        failsWith('icons.box.fallback names material'),
      );
      expect(
        () => IconRegistry.parse(
          table(extra: '  box: {remix: box, fallback: lucide}\n'),
        ),
        failsWith('so icons.box must map lucide'),
      );
      expect(
        () => IconRegistry.parse(
          table(extra: '  box: {remix: box, lucide: box, fallback: lucide}\n'),
        ),
        failsWith('its fallback is never used'),
      );
    });

    test('names the schemas it supports', () {
      expect(
        () =>
            IconRegistry.parse(table().replaceFirst('schema: 2', 'schema: 3')),
        failsWith('remix_cli supports 1 and 2'),
      );
      expect(
        () =>
            IconRegistry.parse(table().replaceFirst('schema: 2', 'schema: 1')),
        failsWith('icons.magnifyingGlass.remix must be magnifyingGlass'),
      );
    });

    test('requires an integer schema rather than a number or string', () {
      for (final schema in ['2.0', '"2"', 'true']) {
        expect(
          () => IconRegistry.parse(
            table().replaceFirst('schema: 2', 'schema: $schema'),
          ),
          failsWith('Unsupported icons.yaml schema'),
          reason: schema,
        );
      }
    });

    test('imports every library a template renders from', () {
      final icons = IconRegistry.parse(table());
      const source = '''
import 'package:flutter/widgets.dart';
{{icon:import}}

const a = {{icon:magnifyingGlass}};
const b = {{icon:checkCircled}};
''';
      expect(
        renderer.render(
          source,
          typePrefix: 'Ui',
          valuePrefix: 'ui',
          icons: icons,
        ),
        '''
import 'package:flutter/widgets.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

const a = RemixIcons.search;
const b = LucideIcons.circleCheck;
''',
      );
      expect(renderer.iconLibraries(source, icons: icons), {'remix', 'lucide'});
      expect(
        renderer.iconLibraries(source, icons: icons, iconLibrary: 'lucide'),
        {'lucide'},
      );
    });

    test('imports only the fallback when every icon falls back', () {
      final icons = IconRegistry.parse(table());
      const source = "{{icon:import}}\nconst b = {{icon:checkCircled}};\n";
      final rendered = renderer.render(
        source,
        typePrefix: 'Ui',
        valuePrefix: 'ui',
        icons: icons,
      );
      expect(rendered, contains('package:lucide_flutter/lucide_flutter.dart'));
      expect(rendered, isNot(contains('remix_ui_icons')));
      expect(renderer.iconLibraries(source, icons: icons), {'lucide'});
      expect(renderer.iconLibraries('{{icon:import}}\n', icons: icons), {
        'remix',
      });
    });

    test('keeps CRLF and orders each generated icon import separately', () {
      final source = [
        "import 'local.dart';",
        "import 'package:middle/icons.dart';",
        '{{icon:import}}',
        "import 'dart:math';",
        '',
        'const search = {{icon:magnifyingGlass}};',
        'const checked = {{icon:checkCircled}};',
        '',
      ].join('\r\n');

      final rendered = renderer.render(
        source,
        typePrefix: 'Ui',
        valuePrefix: 'ui',
        icons: IconRegistry.parse(table()),
      );

      expect(
        rendered,
        [
          "import 'dart:math';",
          '',
          "import 'package:lucide_flutter/lucide_flutter.dart';",
          "import 'package:middle/icons.dart';",
          "import 'package:remix_ui_icons/remix_ui_icons.dart';",
          '',
          "import 'local.dart';",
          '',
          'const search = RemixIcons.search;',
          'const checked = LucideIcons.circleCheck;',
          '',
        ].join('\r\n'),
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

  group('icon placeholders', () {
    final icons = IconRegistry.parse(
      File('${findCheckoutRegistry().path}/icons.yaml').readAsStringSync(),
    );

    test('the swapped import lands in sorted order', () {
      const source = '''
import 'package:flutter/widgets.dart';
{{icon:import}}
import 'package:remix/remix.dart';

const icon = {{icon:bell}};
''';
      final lucide = renderer.render(
        source,
        typePrefix: 'Ui',
        valuePrefix: 'ui',
        icons: icons,
        iconLibrary: 'lucide',
      );
      expect(lucide, '''
import 'package:flutter/widgets.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:remix/remix.dart';

const icon = LucideIcons.bell;
''');
    });

    test(
      'fail without a table, for an unknown icon, or an unknown library',
      () {
        String render(String source, {IconRegistry? table, String? library}) =>
            renderer.render(
              source,
              typePrefix: 'Ui',
              valuePrefix: 'ui',
              icons: table,
              iconLibrary: library ?? 'remix',
            );

        expect(() => render('{{icon:bell}}'), throwsFormatException);
        expect(
          () => render('{{icon:notAnIcon}}', table: icons),
          throwsFormatException,
        );
        expect(
          () => render('{{icon:bell}}', table: icons, library: 'material'),
          throwsFormatException,
        );
      },
    );
  });

  test('keeps a trailing comment with its import while sorting', () {
    const source = '''
import 'package:remix/remix.dart'; // ignore: unused_import
import 'dart:math';

class Example {}
''';
    expect(sortDirectives('template', source), '''
import 'dart:math';

import 'package:remix/remix.dart'; // ignore: unused_import

class Example {}
''');
  });

  test('refuses an import after the import block', () {
    const source = '''
import 'package:remix/remix.dart';
// A comment that ends the block.
import 'dart:math';
''';
    expect(
      () => sortDirectives('template', source),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'message',
          contains("move `import 'dart:math';`"),
        ),
      ),
    );
  });

  test('keeps CRLF line endings while sorting', () {
    const source =
        "import 'package:remix/remix.dart';\r\nimport 'dart:math';\r\n\r\nclass Example {}\r\n";
    expect(
      sortDirectives('template', source),
      "import 'dart:math';\r\n\r\nimport 'package:remix/remix.dart';\r\n\r\nclass Example {}\r\n",
    );
  });

  test('names a remix_cli upgrade for an unknown token', () {
    expect(
      () => renderer.render(
        '{{future:token}}',
        typePrefix: 'Ui',
        valuePrefix: 'ui',
      ),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'message',
          contains('newer remix_cli'),
        ),
      ),
    );
  });
}
