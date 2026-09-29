import 'package:flutter_test/flutter_test.dart';

import 'support.dart';
import 'vanilla_spec.dart';

/// Holds every Vanilla recipe to `registry_source/specs/vanilla.md`.
///
/// Each target resolves one recipe under each shipped theme and compares one
/// property with the value shadcn gives it. A target whose phase has not
/// landed is skipped, with the phase in its name, so `flutter test` reports
/// how much of the spec is still ahead. Run every target regardless with
/// `flutter test --dart-define=VANILLA_SPEC_ALL=true test/vanilla`.
void main() {
  const runAll = bool.fromEnvironment('VANILLA_SPEC_ALL');

  test('every target names a phase the plan has', () {
    const phases = {'E', 'F1', 'F2', 'F3', 'F4', 'F5'};

    for (final target in vanillaSpecTargets) {
      expect(
        phases,
        contains(target.phase),
        reason: '${target.component}: ${target.property}',
      );
    }
    expect(enforcedPhases.difference(phases), isEmpty);
  });

  test('target names are unique per component', () {
    final names = [
      for (final target in vanillaSpecTargets)
        '${target.component}: ${target.property}',
    ];

    expect(names.toSet(), hasLength(names.length));
  });

  for (final target in vanillaSpecTargets) {
    group('${target.component}: ${target.property}', () {
      for (final theme in vanillaThemes) {
        final enforced = runAll || target.isEnforced;

        testWidgets(
          enforced ? theme.name : '${theme.name} (pending ${target.phase})',
          (tester) async {
            expect(
              await target.actual(tester, theme.data),
              target.expected(theme.data),
              reason: 'shadcn: ${target.source}',
            );
          },
          skip: !enforced,
        );
      }
    });
  }
}
