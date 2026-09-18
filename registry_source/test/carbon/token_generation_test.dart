import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('generated token libraries are deterministic ordinary Dart files', () {
    final result = Process.runSync('node', [
      'tool/carbon/verify_generated.mjs',
    ]);
    expect(result.exitCode, 0, reason: '${result.stdout}\n${result.stderr}');

    final generated = Directory(
      'lib/src/carbon/theme/generated',
    ).listSync().whereType<File>().map((file) => file.path).toList();
    expect(generated, hasLength(8));
    expect(generated, everyElement(endsWith('.dart')));
    expect(generated, everyElement(isNot(endsWith('.g.dart'))));
  });

  test('normalized provenance matches the pinned source lock', () {
    final snapshot =
        jsonDecode(
              File(
                'tool/carbon/tokens/carbon-tokens.normalized.json',
              ).readAsStringSync(),
            )
            as Map<String, Object?>;
    final lock =
        jsonDecode(
              File(
                'tool/carbon/upstream/carbon-source-lock.json',
              ).readAsStringSync(),
            )
            as Map<String, Object?>;
    final provenance = snapshot['provenance']! as Map<String, Object?>;

    expect(provenance['carbonCommit'], lock['carbonCommit']);
    expect(provenance['carbonCommitDate'], lock['carbonCommitDate']);
    expect(provenance['license'], lock['license']);
    expect(provenance['packages'], lock['pinnedVersions']);
  });
}
