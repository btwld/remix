import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

void main() {
  group('RadioSpec', () {
    group('Constructor', () {
      test('creates spec with default values when no parameters provided', () {
        const spec = RadioSpec();

        expect(spec.container, isA<StyleSpec<BoxSpec>>());
        expect(spec.indicator, isA<StyleSpec<BoxSpec>>());
        expect(spec.label, isA<StyleSpec<TextSpec>>());
        expect(spec.labelSpacing, 8);
      });

      test('creates spec with provided parameters', () {
        final container = StyleSpec(spec: BoxSpec());
        final indicator = StyleSpec(spec: BoxSpec());
        final label = StyleSpec(spec: TextSpec(maxLines: 2));

        final spec = RadioSpec(
          container: container,
          indicator: indicator,
          label: label,
          labelSpacing: 12,
        );

        expect(spec.container, equals(container));
        expect(spec.indicator, equals(indicator));
        expect(spec.label, equals(label));
        expect(spec.labelSpacing, 12);
      });
    });

    group('copyWith', () {
      test('returns new instance with updated properties', () {
        const originalSpec = RadioSpec();
        final newContainer = StyleSpec(spec: BoxSpec());

        final updatedSpec = originalSpec.copyWith(container: newContainer);

        expect(updatedSpec, isNot(same(originalSpec)));
        expect(updatedSpec.container, equals(newContainer));
      });

      test('preserves immutability - original spec unchanged', () {
        const originalSpec = RadioSpec();
        final originalContainer = originalSpec.container;
        final newContainer = StyleSpec(spec: BoxSpec());

        final updatedSpec = originalSpec.copyWith(container: newContainer);

        expect(originalSpec.container, equals(originalContainer));
        expect(updatedSpec.container, equals(newContainer));
        expect(updatedSpec.container, isNot(same(originalContainer)));
      });

      test('returns new instance with all properties updated', () {
        const originalSpec = RadioSpec();
        final newContainer = StyleSpec(spec: BoxSpec());
        final newIndicator = StyleSpec(spec: BoxSpec());

        final updatedSpec = originalSpec.copyWith(
          container: newContainer,
          indicator: newIndicator,
        );

        expect(updatedSpec.container, equals(newContainer));
        expect(updatedSpec.indicator, equals(newIndicator));
      });
    });

    group('lerp', () {
      test('returns spec equal to this when other is null', () {
        const spec = RadioSpec();
        const RadioSpec? other = null;

        final result = spec.lerp(other, 0.5);

        expect(result, equals(spec));
      });

      test('interpolates between two specs at t=0.0', () {
        final spec1 = RadioSpec(container: StyleSpec(spec: BoxSpec()));
        final spec2 = RadioSpec(container: StyleSpec(spec: BoxSpec()));

        final result = spec1.lerp(spec2, 0.0);

        expect(result, isNot(same(spec1)));
        expect(result.container, equals(spec1.container));
      });

      test('interpolates between two specs at t=1.0', () {
        final spec1 = RadioSpec(container: StyleSpec(spec: BoxSpec()));
        final spec2 = RadioSpec(container: StyleSpec(spec: BoxSpec()));

        final result = spec1.lerp(spec2, 1.0);

        expect(result, isNot(same(spec2)));
        expect(result.container, equals(spec2.container));
      });

      test('interpolates label spacing', () {
        const start = RadioSpec(labelSpacing: 8);
        const end = RadioSpec(labelSpacing: 16);

        expect(start.lerp(end, 0.5).labelSpacing, 12);
      });
    });

    group('Equality and Props', () {
      test('two specs with same properties are equal', () {
        const spec1 = RadioSpec();
        const spec2 = RadioSpec();

        expect(spec1, equals(spec2));
        expect(spec1.hashCode, equals(spec2.hashCode));
      });

      test('two specs with different properties are not equal', () {
        const spec1 = RadioSpec();
        final spec2 = RadioSpec(
          container: StyleSpec(
            spec: const BoxSpec(),
            animation: AnimationConfig.linear(
              const Duration(milliseconds: 100),
            ),
          ),
        );

        expect(spec1, isNot(equals(spec2)));
      });

      test('props list contains all properties', () {
        const spec = RadioSpec();

        expect(spec.props, hasLength(5));
        expect(spec.props, contains(spec.container));
        expect(spec.props, contains(spec.indicator));
        expect(spec.props, contains(spec.label));
        expect(spec.props, contains(spec.labelSpacing));
      });
    });

    group('Diagnostic Support', () {
      test('diagnostics publish RadioSpec fields', () {
        const spec = RadioSpec();
        final builder = DiagnosticPropertiesBuilder();
        spec.debugFillProperties(builder);
        expect(
          builder.properties.map((property) => property.name),
          unorderedEquals([
            'container',
            'indicator',
            'label',
            'labelSpacing',
            'containerEffects',
          ]),
        );
      });
    });

    group('Edge Cases and Error Handling', () {
      test('copyWith handles null parameters correctly', () {
        const spec = RadioSpec();
        final originalContainer = spec.container;

        final updatedSpec = spec.copyWith(container: null);

        expect(updatedSpec.container, equals(originalContainer));
      });
    });
  });
}
