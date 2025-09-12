import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('extracts Radix component tokens and groups by type', () async {
    final componentsFile = File('radix_components.generated.json');
    if (await componentsFile.exists()) {
      await componentsFile.delete();
    }

    final res = await Process.run(
      'dart',
      [
        'run',
        'scripts/extract_radix_tokens.dart',
      ],
      runInShell: true,
    );

    expect(res.exitCode, 0,
        reason:
            'Script should exit 0. Stdout: ${res.stdout}\nStderr: ${res.stderr}');

    expect(await componentsFile.exists(), isTrue);

    final data = json.decode(await componentsFile.readAsString())
        as Map<String, dynamic>;

    expect(data['components'], isA<Map<String, dynamic>>());

    final components =
        Map<String, dynamic>.from(data['components'] as Map<String, dynamic>);

    // Spot-check some expected groups exist
    expect(components.keys, contains('button'));
    expect(components.keys, contains('card'));
    expect(components.keys, contains('text-field'));
    expect(components.keys, contains('text-area'));
    expect(components.keys, contains('select'));

    // Spot-check a few expected variables under groups
    final textField = Map<String, dynamic>.from(
        components['text-field'] ?? const <String, dynamic>{});
    expect(textField.keys, contains('text-field-height'));
    expect(textField.keys, contains('text-field-border-radius'));

    final button = Map<String, dynamic>.from(
        components['button'] ?? const <String, dynamic>{});
    // Button tokens vary, but height/radius/padding are common
    expect(
      button.keys.any((k) => (k).startsWith('button-')),
      isTrue,
      reason: 'button-* variables should be present',
    );
  }, timeout: const Timeout(Duration(minutes: 2)));
}
