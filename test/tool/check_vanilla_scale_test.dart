import 'dart:io';

import 'package:test/test.dart';

import '../../tool/check_vanilla_scale.dart' as checker;

void main() {
  const scaleSource = '''
abstract final class VanillaSpace {
  static const double s1 = 4;
  static const double s1_5 = 6;
  static const double s2 = 8;
}
abstract final class VanillaStroke {
  static const double hairline = 1;
}
''';
  const themeDataSource = '''
  VanillaTokens.textSm: _text(14, 20),
  VanillaTokens.textLg: _text(18, 28),
''';
  final scale = checker.scaleValues(
    scaleSource: scaleSource,
    themeDataSource: themeDataSource,
  );

  List<String> findings(String source) => [
    for (final finding in checker.offScaleLiterals('probe.dart', source, scale))
      '$finding',
  ];

  test('the scale is read from the constants and the text steps', () {
    expect(scale, {0, 4, 6, 8, 1, 14, 20, 18, 28});
  });

  test('the shipped scale parses and holds the spacing and type steps', () {
    final shipped = checker.scaleValues(
      scaleSource: File(checker.scalePath).readAsStringSync(),
      themeDataSource: File(checker.themeDataPath).readAsStringSync(),
    );

    expect(shipped, containsAll(<double>[2, 4, 6, 8, 12, 16, 24, 32, 36, 40]));
    expect(shipped, containsAll(<double>[12, 14, 16, 18, 20, 24, 30, 36]));
  });

  test('reports literals off the scale, with their line', () {
    expect(findings('const a = 13.0;\nconst b = 8.0;\nconst c = 18.4;'), [
      'probe.dart:1 13',
      'probe.dart:3 18.4',
    ]);
  });

  test('passes values on the scale, fractions, and durations', () {
    expect(
      findings('''
const gap = 8;
const alpha = 0.9;
const opacity = 0.5;
const motion = Duration(milliseconds: 150);
const color = Color(0xFF123456);
'''),
      isEmpty,
    );
  });

  test('ignores comments, strings, and identifiers', () {
    expect(
      findings(r'''
/// The old 13px label.
// 44 was the row height.
/* 999 */
const label = 'h-10 px-3 13px';
const raw = r'17';
const multi = """
  21
""";
final text2xl = VanillaSpace.s1_5;
'''),
      isEmpty,
    );
  });

  test('stripping keeps every newline, so lines still line up', () {
    const source = "const a = 'x';\n// y\nconst b = 13;";

    expect(
      '\n'.allMatches(checker.stripCommentsAndStrings(source)),
      hasLength(2),
    );
    expect(findings(source), ['probe.dart:3 13']);
  });

  group('the allowlist', () {
    final found = [
      const checker.ScaleFinding('a.dart', 3, 13),
      const checker.ScaleFinding('a.dart', 9, 13),
      const checker.ScaleFinding('b.dart', 1, 999),
    ];

    test('agrees when every finding is listed exactly', () {
      final allowed = checker.parseAllowlist('''
# comment
a.dart 13 2
b.dart 999 1
''');

      expect(checker.compareWithAllowlist(found, allowed), isEmpty);
    });

    test('rejects a literal it does not list', () {
      final allowed = checker.parseAllowlist('a.dart 13 2');
      final problems = checker.compareWithAllowlist(found, allowed);

      expect(problems, hasLength(1));
      expect(problems.single, contains('b.dart:1 999'));
    });

    test('rejects a count that grew', () {
      final allowed = checker.parseAllowlist('a.dart 13 1\nb.dart 999 1');

      expect(
        checker.compareWithAllowlist(found, allowed).single,
        contains('2 found, 1 allowed'),
      );
    });

    test('rejects an entry the source no longer needs, so it only shrinks', () {
      final allowed = checker.parseAllowlist(
        'a.dart 13 3\nb.dart 999 1\nc.dart 44 1',
      );
      final problems = checker.compareWithAllowlist(found, allowed);

      expect(problems, hasLength(2));
      expect(problems, contains(contains('lower `a.dart 13 3` to 2')));
      expect(problems, contains(contains('remove `c.dart 44 1`')));
    });

    test('refuses malformed and duplicate lines', () {
      expect(() => checker.parseAllowlist('a.dart 13'), throwsFormatException);
      expect(
        () => checker.parseAllowlist('a.dart 13 1\na.dart 13.0 2'),
        throwsFormatException,
      );
    });
  });

  test('the committed allowlist matches the components', () async {
    final result = await Process.run(Platform.resolvedExecutable, [
      'run',
      'tool/check_vanilla_scale.dart',
    ]);

    expect(result.exitCode, 0, reason: '${result.stdout}${result.stderr}');
  });
}
