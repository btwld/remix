import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

void main() {
  group('RemixTabBarSpec', () {
    group('Constructor', () {
      test('creates with default container', () {
        const spec = RemixTabBarSpec();

        expect(spec.container, equals(const StyleSpec(spec: FlexBoxSpec())));
      });

      test('creates with provided container', () {
        final container = StyleSpec(spec: const FlexBoxSpec());
        final spec = RemixTabBarSpec(container: container);

        expect(spec.container, equals(container));
      });
    });

    group('copyWith', () {
      test('returns copy when no parameters provided', () {
        const spec = RemixTabBarSpec();
        final copy = spec.copyWith();

        expect(copy.container, equals(spec.container));
      });

      test('returns copy with new container', () {
        const spec = RemixTabBarSpec();
        final newContainer = StyleSpec(
          spec: const FlexBoxSpec(),
          animation: AnimationConfig.linear(const Duration(milliseconds: 100)),
        );

        final copy = spec.copyWith(container: newContainer);

        expect(copy.container, equals(newContainer));
        expect(copy.container, isNot(equals(spec.container)));
      });
    });

    group('lerp', () {
      test('returns this when other is null', () {
        const spec = RemixTabBarSpec();
        final lerped = spec.lerp(null, 0.5);

        expect(lerped, equals(spec));
      });

      test('interpolates between two specs at t=0', () {
        const spec1 = RemixTabBarSpec();
        const spec2 = RemixTabBarSpec();

        final result = spec1.lerp(spec2, 0.0);

        expect(result.container, isNotNull);
      });

      test('interpolates between two specs at t=1', () {
        const spec1 = RemixTabBarSpec();
        const spec2 = RemixTabBarSpec();

        final result = spec1.lerp(spec2, 1.0);

        expect(result.container, isNotNull);
      });

      test('interpolates between two specs at t=0.5', () {
        const spec1 = RemixTabBarSpec();
        const spec2 = RemixTabBarSpec();

        final result = spec1.lerp(spec2, 0.5);

        expect(result.container, isNotNull);
      });
    });

    group('Equality & Props', () {
      test('two specs with same properties are equal', () {
        const spec1 = RemixTabBarSpec();
        const spec2 = RemixTabBarSpec();

        expect(spec1, equals(spec2));
        expect(spec1.hashCode, equals(spec2.hashCode));
      });

      test('two specs with different properties are not equal', () {
        const spec1 = RemixTabBarSpec();
        final spec2 = RemixTabBarSpec(
          container: StyleSpec(
            spec: const FlexBoxSpec(),
            animation: AnimationConfig.linear(
              const Duration(milliseconds: 100),
            ),
          ),
        );

        expect(spec1, isNot(equals(spec2)));
      });

      test('props includes all relevant properties', () {
        const spec = RemixTabBarSpec();

        expect(spec.props.length, equals(1));
        expect(spec.props, contains(spec.container));
      });
    });

    group('Diagnostic Support', () {
      test('debugFillProperties includes container', () {
        const spec = RemixTabBarSpec();
        final builder = DiagnosticPropertiesBuilder();

        spec.debugFillProperties(builder);

        final properties = builder.properties;
        expect(properties.any((p) => p.name == 'container'), isTrue);
      });
    });
  });

  group('RemixTabViewSpec', () {
    group('Constructor', () {
      test('creates with default container', () {
        const spec = RemixTabViewSpec();

        expect(spec.container, equals(const StyleSpec(spec: BoxSpec())));
      });

      test('creates with provided container', () {
        final container = StyleSpec(spec: const BoxSpec());
        final spec = RemixTabViewSpec(container: container);

        expect(spec.container, equals(container));
      });
    });

    group('copyWith', () {
      test('returns copy when no parameters provided', () {
        const spec = RemixTabViewSpec();
        final copy = spec.copyWith();

        expect(copy.container, equals(spec.container));
      });

      test('returns copy with new container', () {
        const spec = RemixTabViewSpec();
        final newContainer = StyleSpec(
          spec: const BoxSpec(),
          animation: AnimationConfig.linear(const Duration(milliseconds: 100)),
        );

        final copy = spec.copyWith(container: newContainer);

        expect(copy.container, equals(newContainer));
        expect(copy.container, isNot(equals(spec.container)));
      });
    });

    group('lerp', () {
      test('returns this when other is null', () {
        const spec = RemixTabViewSpec();
        final lerped = spec.lerp(null, 0.5);

        expect(lerped, equals(spec));
      });

      test('interpolates between two specs at t=0', () {
        const spec1 = RemixTabViewSpec();
        const spec2 = RemixTabViewSpec();

        final result = spec1.lerp(spec2, 0.0);

        expect(result.container, isNotNull);
      });

      test('interpolates between two specs at t=1', () {
        const spec1 = RemixTabViewSpec();
        const spec2 = RemixTabViewSpec();

        final result = spec1.lerp(spec2, 1.0);

        expect(result.container, isNotNull);
      });

      test('interpolates between two specs at t=0.5', () {
        const spec1 = RemixTabViewSpec();
        const spec2 = RemixTabViewSpec();

        final result = spec1.lerp(spec2, 0.5);

        expect(result.container, isNotNull);
      });
    });

    group('Equality & Props', () {
      test('two specs with same properties are equal', () {
        const spec1 = RemixTabViewSpec();
        const spec2 = RemixTabViewSpec();

        expect(spec1, equals(spec2));
        expect(spec1.hashCode, equals(spec2.hashCode));
      });

      test('two specs with different properties are not equal', () {
        const spec1 = RemixTabViewSpec();
        final spec2 = RemixTabViewSpec(
          container: StyleSpec(
            spec: const BoxSpec(),
            animation: AnimationConfig.linear(
              const Duration(milliseconds: 100),
            ),
          ),
        );

        expect(spec1, isNot(equals(spec2)));
      });

      test('props includes all relevant properties', () {
        const spec = RemixTabViewSpec();

        expect(spec.props.length, equals(1));
        expect(spec.props, contains(spec.container));
      });
    });

    group('Diagnostic Support', () {
      test('debugFillProperties includes container', () {
        const spec = RemixTabViewSpec();
        final builder = DiagnosticPropertiesBuilder();

        spec.debugFillProperties(builder);

        final properties = builder.properties;
        expect(properties.any((p) => p.name == 'container'), isTrue);
      });
    });
  });

  group('RemixTabSpec', () {
    group('Constructor', () {
      test('creates with default properties', () {
        const spec = RemixTabSpec();

        expect(spec.container, equals(const StyleSpec(spec: FlexBoxSpec())));
        expect(spec.label, equals(const StyleSpec(spec: TextSpec())));
        expect(spec.icon, equals(const StyleSpec(spec: IconSpec())));
      });

      test('creates with provided properties', () {
        final container = StyleSpec(spec: const FlexBoxSpec());
        final label = StyleSpec(spec: const TextSpec());
        final icon = StyleSpec(spec: const IconSpec());

        final spec = RemixTabSpec(
          container: container,
          label: label,
          icon: icon,
        );

        expect(spec.container, equals(container));
        expect(spec.label, equals(label));
        expect(spec.icon, equals(icon));
      });
    });

    group('copyWith', () {
      test('returns copy when no parameters provided', () {
        const spec = RemixTabSpec();
        final copy = spec.copyWith();

        expect(copy.container, equals(spec.container));
        expect(copy.label, equals(spec.label));
        expect(copy.icon, equals(spec.icon));
      });

      test('returns copy with new container', () {
        const spec = RemixTabSpec();
        final newContainer = StyleSpec(
          spec: const FlexBoxSpec(),
          animation: AnimationConfig.linear(const Duration(milliseconds: 100)),
        );

        final copy = spec.copyWith(container: newContainer);

        expect(copy.container, equals(newContainer));
        expect(copy.container, isNot(equals(spec.container)));
        expect(copy.label, equals(spec.label));
        expect(copy.icon, equals(spec.icon));
      });

      test('returns copy with new label', () {
        const spec = RemixTabSpec();
        final newLabel = StyleSpec(
          spec: const TextSpec(),
          animation: AnimationConfig.linear(const Duration(milliseconds: 100)),
        );

        final copy = spec.copyWith(label: newLabel);

        expect(copy.label, equals(newLabel));
        expect(copy.label, isNot(equals(spec.label)));
        expect(copy.container, equals(spec.container));
        expect(copy.icon, equals(spec.icon));
      });

      test('returns copy with new icon', () {
        const spec = RemixTabSpec();
        final newIcon = StyleSpec(
          spec: const IconSpec(),
          animation: AnimationConfig.linear(const Duration(milliseconds: 100)),
        );

        final copy = spec.copyWith(icon: newIcon);

        expect(copy.icon, equals(newIcon));
        expect(copy.icon, isNot(equals(spec.icon)));
        expect(copy.container, equals(spec.container));
        expect(copy.label, equals(spec.label));
      });
    });

    group('lerp', () {
      test('returns this when other is null', () {
        const spec = RemixTabSpec();
        final lerped = spec.lerp(null, 0.5);

        expect(lerped, equals(spec));
      });

      test('interpolates between two specs at t=0', () {
        const spec1 = RemixTabSpec();
        const spec2 = RemixTabSpec();

        final result = spec1.lerp(spec2, 0.0);

        expect(result.container, isNotNull);
        expect(result.label, isNotNull);
        expect(result.icon, isNotNull);
      });

      test('interpolates between two specs at t=1', () {
        const spec1 = RemixTabSpec();
        const spec2 = RemixTabSpec();

        final result = spec1.lerp(spec2, 1.0);

        expect(result.container, isNotNull);
        expect(result.label, isNotNull);
        expect(result.icon, isNotNull);
      });

      test('interpolates between two specs at t=0.5', () {
        const spec1 = RemixTabSpec();
        const spec2 = RemixTabSpec();

        final result = spec1.lerp(spec2, 0.5);

        expect(result.container, isNotNull);
        expect(result.label, isNotNull);
        expect(result.icon, isNotNull);
      });
    });

    group('Equality & Props', () {
      test('two specs with same properties are equal', () {
        const spec1 = RemixTabSpec();
        const spec2 = RemixTabSpec();

        expect(spec1, equals(spec2));
        expect(spec1.hashCode, equals(spec2.hashCode));
      });

      test('two specs with different properties are not equal', () {
        const spec1 = RemixTabSpec();
        final spec2 = RemixTabSpec(
          container: StyleSpec(
            spec: const FlexBoxSpec(),
            animation: AnimationConfig.linear(
              const Duration(milliseconds: 100),
            ),
          ),
        );

        expect(spec1, isNot(equals(spec2)));
      });

      test('props includes all relevant properties', () {
        const spec = RemixTabSpec();

        expect(spec.props.length, equals(3));
        expect(spec.props, contains(spec.container));
        expect(spec.props, contains(spec.label));
        expect(spec.props, contains(spec.icon));
      });
    });

    group('Diagnostic Support', () {
      test('debugFillProperties includes all properties', () {
        const spec = RemixTabSpec();
        final builder = DiagnosticPropertiesBuilder();

        spec.debugFillProperties(builder);

        final properties = builder.properties;
        expect(properties.any((p) => p.name == 'container'), isTrue);
        expect(properties.any((p) => p.name == 'label'), isTrue);
        expect(properties.any((p) => p.name == 'icon'), isTrue);
      });
    });
  });
}
