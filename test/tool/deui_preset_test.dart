import 'dart:io';

import 'package:test/test.dart';

import '../../tool/check_open_code.dart' as checker;

void main() {
  test('Deui has its own fixture and catalog contract', () {
    final root = Directory.current;
    expect(
      checker.fixtureContractProblem(
        Directory('${root.path}/open_code/deui_fixture'),
        preset: 'deui',
      ),
      isNull,
    );
    expect(checker.registryCoverageProblem(root, preset: 'deui'), isNull);
    expect(
      checker.requiredRuntimeDependenciesForTest('deui'),
      contains('remix_ui_fonts'),
    );
  });
}
