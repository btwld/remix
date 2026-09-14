import 'package:remix_cli/src/builder_config.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  const first = 'lib/ui/components/activity.dart';
  const second = 'lib/ui/components/message.dart';
  test('new config is narrowly scoped and repeated configuration is stable', () {
    final source = configureSpecStylers('', [first]);
    final builder =
        (loadYaml(source)
            as Map)['targets'][r'$default']['builders'][specStylerBuilder];
    expect(builder['enabled'], isTrue);
    expect(builder['generate_for'], [first]);
    expect(configureSpecStylers(source, [first]), source);
    final updated = configureSpecStylers(source, [first, second]);
    expect(
      (loadYaml(updated)
          as Map)['targets'][r'$default']['builders'][specStylerBuilder]['generate_for'],
      [first, second],
    );
    expect(configureSpecStylers(updated, [first, second]), updated);
  });
  test('preserves comments, unrelated builders, options and custom sources', () {
    const source = '''# Application-owned configuration.
targets:
  \$default:
    sources:
      include: [lib/**]
      exclude: [lib/private/**]
    builders:
      custom:builder:
        options: {keep: true} # untouched
      mix_generator|spec_styler_generator:
        enabled: true
        options: {custom: value}
        generate_for: [lib/custom/**]
''';
    final updated = configureSpecStylers(source, [first]);
    expect(updated, contains('# Application-owned configuration.'));
    expect(updated, contains('options: {keep: true} # untouched'));
    final builder =
        (loadYaml(updated)
            as Map)['targets'][r'$default']['builders']['mix_generator|spec_styler_generator'];
    expect(builder['options'], {'custom': 'value'});
    expect(builder['generate_for'], ['lib/custom/**', first]);
  });
  test('an options-only builder is enabled only for installed source', () {
    const source =
        r'targets: {$default: {builders: {mix_generator:spec_styler_generator: {options: {custom: value}}}}}';
    final updated = configureSpecStylers(source, [first]);
    final builder =
        (loadYaml(updated)
            as Map)['targets'][r'$default']['builders'][specStylerBuilder];
    expect(builder['generate_for'], [first]);
    expect(builder['options'], {'custom': 'value'});
  });
  test('respects existing glob coverage without changing it', () {
    const source = '''targets:
  \$default:
    builders:
      mix_generator:spec_styler_generator:
        enabled: true
        generate_for:
          include: [lib/ui/**]
          exclude: [lib/ui/private/**]
''';
    expect(configureSpecStylers(source, [first]), source);
  });
  test('explicit opt-outs and split targets fail instead of being overwritten', () {
    for (final source in [
      'targets: {custom: {}}',
      r'targets: {$default: {sources: {exclude: [lib/ui/**]}}}',
      r'targets: {$default: {builders: {mix_generator:spec_styler_generator: {enabled: false}}}}',
      r'targets: {$default: {builders: {mix_generator:spec_styler_generator: {generate_for: {exclude: [lib/ui/**]}}}}}',
      '[]',
    ]) {
      expect(
        () => configureSpecStylers(source, [first]),
        throwsFormatException,
        reason: source,
      );
    }
  });
}
