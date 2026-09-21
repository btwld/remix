import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  test('schema-1/2 bundled compatibility snapshot is byte-for-byte frozen', () {
    final root = Directory('lib/src/registry');
    final files = root.listSync(recursive: true).whereType<File>().toList()
      ..sort((a, b) => a.path.compareTo(b.path));
    final result = Process.runSync('git', [
      'hash-object',
      '--',
      ...files.map((file) => file.path),
    ]);
    expect(result.exitCode, 0, reason: '${result.stderr}');
    final hashes = (result.stdout as String).trim().split('\n');
    final actual = {
      for (var i = 0; i < files.length; i++)
        p.relative(files[i].path, from: root.path).split(p.separator).join('/'):
            hashes[i],
    };
    final expected = jsonDecode(
      File('test/fixtures/frozen_registry.json').readAsStringSync(),
    );
    expect(
      actual,
      expected,
      reason:
          'Publish component changes to registry/, not the frozen CLI bundles.',
    );
  });
}
