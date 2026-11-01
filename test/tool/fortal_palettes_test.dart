import 'dart:io';

import 'package:test/test.dart';

/// Runs the real palette CLI, as an application maintainer would.
ProcessResult _generate(List<String> arguments) => Process.runSync(
  Platform.resolvedExecutable,
  ['run', 'registry_source/tool/fortal_palettes/generate.dart', ...arguments],
);

/// Top-level `const name = Type(` declarations, in file order.
List<String> _declarations(String source) => [
  for (final match in RegExp(
    r'^const (\w+) = (\w+)\(',
    multiLine: true,
  ).allMatches(source))
    '${match[1]} ${match[2]}',
];

void main() {
  late Directory temp;

  setUp(() {
    temp = Directory.systemTemp.createTempSync('fortal_palettes_');
    addTearDown(() => temp.deleteSync(recursive: true));
  });

  test('the default built-in run reproduces the committed palettes', () {
    final output = File('${temp.path}/fortal_colors.dart');
    final result = _generate(['--output', output.path]);
    expect(result.exitCode, 0, reason: '${result.stderr}');
    expect(
      result.stdout,
      contains('Generated 7 accent palettes and the semantic error palette'),
    );
    expect(
      output.readAsStringSync(),
      File(
        'registry_source/lib/src/fortal/theme/fortal_colors.dart',
      ).readAsStringSync(),
    );
  });

  test('a prefixed built-in run declares what an installed theme expects', () {
    final output = File('${temp.path}/acme_colors.dart');
    final result = _generate([
      '--type-prefix',
      'Acme',
      '--output',
      output.path,
    ]);
    expect(result.exitCode, 0, reason: '${result.stderr}');
    final generated = output.readAsStringSync();
    expect(generated, contains('const acmeError = AcmeColorTheme('));
    expect(generated, isNot(contains('fortalError')));
    expect(generated, isNot(contains('FortalColor')));
    // The installed theme is the registry template rendered for the prefix;
    // its theme_data.dart and theme.dart read these exact identifiers.
    final installed =
        File('registry/fortal/templates/theme/fortal_colors.dart.tmpl')
            .readAsStringSync()
            .replaceAll('{{typePrefix}}', 'Acme')
            .replaceAll('{{valuePrefix}}', 'acme');
    expect(_declarations(generated), _declarations(installed));
    expect(_declarations(generated), contains('acmeError AcmeColorTheme'));
  });

  test('a custom palette keeps its explicit name under any prefix', () {
    final output = File('${temp.path}/brand_colors.dart');
    final result = _generate([
      '--name',
      'fortalBrand',
      '--seed',
      '#8038CC',
      '--type-prefix',
      'Acme',
      '--output',
      output.path,
    ]);
    expect(result.exitCode, 0, reason: '${result.stderr}');
    expect(result.stdout, contains('Generated the fortalBrand palette'));
    expect(_declarations(output.readAsStringSync()), [
      'fortalBrand AcmeColorTheme',
    ]);
  });

  test('a custom name may not reuse a built-in identifier', () {
    for (final name in ['acmeError', 'serra', 'blackAlpha']) {
      final result = _generate([
        '--name',
        name,
        '--seed',
        '#8038CC',
        '--type-prefix',
        'Acme',
        '--output',
        '${temp.path}/$name.dart',
      ]);
      expect(result.exitCode, 64, reason: name);
      expect(result.stderr, contains('built-in palette identifier'));
      expect(File('${temp.path}/$name.dart').existsSync(), isFalse);
    }
  });
}
