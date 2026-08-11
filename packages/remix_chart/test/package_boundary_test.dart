import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Fortal integration does not import the private chart renderer', () {
    final sources = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));

    for (final source in sources) {
      expect(
        source.readAsStringSync(),
        isNot(contains('package:fl_chart')),
        reason: '${source.path} crosses the mix_chart renderer boundary',
      );
    }
  });

  test('package keeps chart dependencies out of core Remix', () {
    final integrationPubspec = File('pubspec.yaml').readAsStringSync();
    final remixPubspec = File('../remix/pubspec.yaml').readAsStringSync();

    expect(
      integrationPubspec,
      contains(RegExp(r'^name: remix_chart$', multiLine: true)),
    );
    expect(
      integrationPubspec,
      contains(RegExp(r'^  mix_chart:', multiLine: true)),
    );
    expect(integrationPubspec, contains(RegExp(r'^  remix:', multiLine: true)));
    expect(remixPubspec, isNot(contains('mix_chart:')));
  });
}
