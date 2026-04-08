import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

void main() {
  group('RemixToggleSpec', () {
    group('Constructor', () {
      test('creates spec with default values when no parameters provided', () {
        const spec = RemixToggleSpec();

        expect(spec.container, isA<StyleSpec<FlexBoxSpec>>());
        expect(spec.label, isA<StyleSpec<TextSpec>>());
        expect(spec.icon, isA<StyleSpec<IconSpec>>());
      });

      test('creates spec with provided parameters', () {
        final container = StyleSpec(spec: FlexBoxSpec());
        final label = StyleSpec(spec: TextSpec());
        final icon = StyleSpec(spec: IconSpec());

        final spec = RemixToggleSpec(
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
      test('returns new instance with updated properties', () {
        const originalSpec = RemixToggleSpec();
        final newContainer = StyleSpec(spec: FlexBoxSpec());

        final updatedSpec = originalSpec.copyWith(container: newContainer);

        expect(updatedSpec, isNot(same(originalSpec)));
        expect(updatedSpec.container, equals(newContainer));
      });

      test('preserves immutability - original spec unchanged', () {
        const originalSpec = RemixToggleSpec();
        final originalContainer = originalSpec.container;
        final newContainer = StyleSpec(spec: FlexBoxSpec());

        final updatedSpec = originalSpec.copyWith(container: newContainer);

        expect(originalSpec.container, equals(originalContainer));
        expect(updatedSpec.container, equals(newContainer));
        expect(updatedSpec.container, isNot(same(originalContainer)));
      });

      test('returns new instance with all properties updated', () {
        const originalSpec = RemixToggleSpec();
        final newContainer = StyleSpec(spec: FlexBoxSpec());
        final newLabel = StyleSpec(spec: TextSpec());
        final newIcon = StyleSpec(spec: IconSpec());

        final updatedSpec = originalSpec.copyWith(
          container: newContainer,
          label: newLabel,
          icon: newIcon,
        );

        expect(updatedSpec.container, equals(newContainer));
        expect(updatedSpec.label, equals(newLabel));
        expect(updatedSpec.icon, equals(newIcon));
      });
    });

    group('lerp', () {
      test('returns spec equal to this when other is null', () {
        const spec = RemixToggleSpec();
        const RemixToggleSpec? other = null;

        final result = spec.lerp(other, 0.5);

        expect(result, equals(spec));
      });

      test('interpolates between two specs at t=0.0', () {
        final spec1 = RemixToggleSpec(
          container: StyleSpec(spec: FlexBoxSpec()),
          label: StyleSpec(spec: TextSpec()),
          icon: StyleSpec(spec: IconSpec()),
        );
        final spec2 = RemixToggleSpec(
          container: StyleSpec(spec: FlexBoxSpec()),
          label: StyleSpec(spec: TextSpec()),
          icon: StyleSpec(spec: IconSpec()),
        );

        final result = spec1.lerp(spec2, 0.0);

        expect(result, isNot(same(spec1)));
        expect(result.container, equals(spec1.container));
        expect(result.label, equals(spec1.label));
        expect(result.icon, equals(spec1.icon));
      });

      test('interpolates between two specs at t=1.0', () {
        final spec1 = RemixToggleSpec(
          container: StyleSpec(spec: FlexBoxSpec()),
          label: StyleSpec(spec: TextSpec()),
          icon: StyleSpec(spec: IconSpec()),
        );
        final spec2 = RemixToggleSpec(
          container: StyleSpec(spec: FlexBoxSpec()),
          label: StyleSpec(spec: TextSpec()),
          icon: StyleSpec(spec: IconSpec()),
        );

        final result = spec1.lerp(spec2, 1.0);

        expect(result, isNot(same(spec2)));
        expect(result.container, equals(spec2.container));
        expect(result.label, equals(spec2.label));
        expect(result.icon, equals(spec2.icon));
      });

      test('interpolates between two specs at t=0.5', () {
        final spec1 = RemixToggleSpec(
          container: StyleSpec(spec: FlexBoxSpec()),
          label: StyleSpec(spec: TextSpec()),
          icon: StyleSpec(spec: IconSpec()),
        );
        final spec2 = RemixToggleSpec(
          container: StyleSpec(spec: FlexBoxSpec()),
          label: StyleSpec(spec: TextSpec()),
          icon: StyleSpec(spec: IconSpec()),
        );

        final result = spec1.lerp(spec2, 0.5);

        expect(result, isNotNull);
        expect(result.container, isNotNull);
        expect(result.label, isNotNull);
        expect(result.icon, isNotNull);
      });
    });

    group('Equality and Props', () {
      test('two specs with same properties are equal', () {
        const spec1 = RemixToggleSpec();
        const spec2 = RemixToggleSpec();

        expect(spec1, equals(spec2));
        expect(spec1.hashCode, equals(spec2.hashCode));
      });

      test('two specs with different properties are not equal', () {
        final spec1 = RemixToggleSpec(
          container: StyleSpec(
            spec: const FlexBoxSpec(),
            animation: AnimationConfig.linear(
              const Duration(milliseconds: 100),
            ),
          ),
        );
        final spec2 = RemixToggleSpec(
          container: StyleSpec(
            spec: const FlexBoxSpec(),
            animation: AnimationConfig.linear(
              const Duration(milliseconds: 200),
            ),
          ),
        );

        expect(spec1, isNot(equals(spec2)));
      });

      test('props list contains all properties', () {
        const spec = RemixToggleSpec();

        expect(spec.props, hasLength(3));
        expect(spec.props, contains(spec.container));
        expect(spec.props, contains(spec.label));
        expect(spec.props, contains(spec.icon));
      });
    });

    group('Diagnostic Support', () {
      test('debugFillProperties works without throwing', () {
        const spec = RemixToggleSpec();

        expect(
          () => spec.debugFillProperties(DiagnosticPropertiesBuilder()),
          returnsNormally,
        );
      });

      test('can be converted to string for debugging', () {
        const spec = RemixToggleSpec();

        expect(spec.toString(), isA<String>());
        expect(spec.toString(), isNotEmpty);
      });
    });

    group('Edge Cases', () {
      test('copyWith handles null parameters correctly', () {
        const spec = RemixToggleSpec();
        final originalContainer = spec.container;

        final updatedSpec = spec.copyWith(container: null);

        expect(updatedSpec.container, equals(originalContainer));
      });

      test('handles empty StyleSpec', () {
        const spec = RemixToggleSpec(
          container: StyleSpec(spec: FlexBoxSpec()),
          label: StyleSpec(spec: TextSpec()),
          icon: StyleSpec(spec: IconSpec()),
        );

        expect(spec.container, isNotNull);
        expect(spec.label, isNotNull);
        expect(spec.icon, isNotNull);
      });
    });

    group('Default Values', () {
      test('provides default values for all properties', () {
        const spec = RemixToggleSpec();

        expect(spec.container, isNotNull);
        expect(spec.label, isNotNull);
        expect(spec.icon, isNotNull);
      });
    });
  });
}
