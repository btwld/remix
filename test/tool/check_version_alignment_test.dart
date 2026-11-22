import 'dart:io';

import 'package:test/test.dart';

/// Runs the real checker over a sandbox whose icon table has a chosen floor for
/// each library, because each library declares its own copy of the constraint.
void main() {
  final checker = File('tool/check_version_alignment.dart').absolute.path;
  late Directory sandbox;

  void write(String path, String content) {
    File('${sandbox.path}/$path')
      ..parent.createSync(recursive: true)
      ..writeAsStringSync(content);
  }

  void iconTable({required String remix, required String rounded}) {
    write('registry/icons.yaml', '''
schema: 2
libraries:
  remix:
    dependency:
      remix_ui_icons: $remix
    import: package:remix_ui_icons/remix_ui_icons.dart
    class: RemixIcons
  rounded:
    dependency:
      remix_ui_icons: $rounded
    import: package:remix_ui_icons/remix_ui_icons.dart
    class: RoundedIcons
  lucide:
    dependency:
      lucide_flutter: ^1.47.0
    import: package:lucide_flutter/lucide_flutter.dart
    class: LucideIcons
icons:
  check: {remix: check, rounded: check, lucide: check}
''');
  }

  ProcessResult check([List<String> args = const []]) => Process.runSync(
    Platform.resolvedExecutable,
    [checker, ...args],
    workingDirectory: sandbox.path,
  );

  setUp(() {
    sandbox = Directory.systemTemp.createTempSync('remix_version_alignment_');
    write('packages/remix/pubspec.yaml', 'version: 1.0.0-beta.14\n');
    write('packages/remix_ui_fonts/pubspec.yaml', 'version: 0.1.0\n');
    write('packages/remix_ui_icons/pubspec.yaml', 'version: 2.0.0\n');
    write('registry/vanilla/registry.yaml', '''
items:
  theme:
    dependencies:
      remix: ^1.0.0-beta.14
      remix_ui_fonts: ^0.1.0
''');
  });

  tearDown(() => sandbox.deleteSync(recursive: true));

  test('fails when the Remix manifest still has the previous version', () {
    final result = check(['--expect-remix', '1.0.0-beta.15']);

    expect(result.exitCode, 1);
    expect(
      '${result.stderr}',
      contains(
        'Expected packages/remix/pubspec.yaml to declare 1.0.0-beta.15 '
        'after melos version, but found 1.0.0-beta.14.',
      ),
    );
    expect(
      '${result.stderr}',
      allOf(
        contains('depends on an ignored package with pending changes'),
        contains('see open_code/RELEASING.md for naked_ui'),
        contains('re-dispatch Prepare Version Bump'),
      ),
    );
  });

  test('passes on the requested Remix version before floors are synced', () {
    write('packages/remix/pubspec.yaml', 'version: 1.0.0-beta.15\n');

    final result = check(['--expect-remix', '1.0.0-beta.15']);

    expect(result.exitCode, 0, reason: '${result.stderr}');
  });

  test('prints usage when --expect-remix has no version', () {
    final result = check(['--expect-remix']);

    expect(result.exitCode, 64);
    expect(
      '${result.stderr}',
      contains(
        'Usage: dart run tool/check_version_alignment.dart '
        '[--expect-remix <version>]',
      ),
    );
  });

  test('passes when every remix_ui_icons library floors at the package', () {
    iconTable(remix: '^2.0.0', rounded: '^2.0.0');

    final result = check();

    expect(result.exitCode, 0, reason: '${result.stderr}');
    expect('${result.stdout}', contains('libraries remix, rounded floor'));
  });

  test('fails when only rounded is left behind', () {
    iconTable(remix: '^2.0.0', rounded: '^1.0.0-beta.1');

    final result = check();

    expect(result.exitCode, 1);
    expect('${result.stderr}', contains('for the rounded library'));
    expect('${result.stderr}', isNot(contains('for the remix library')));
  });

  test('fails when only remix is left behind', () {
    iconTable(remix: '^1.0.0-beta.1', rounded: '^2.0.0');

    final result = check();

    expect(result.exitCode, 1);
    expect('${result.stderr}', contains('for the remix library'));
    expect('${result.stderr}', isNot(contains('for the rounded library')));
  });
}
