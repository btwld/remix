import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

void main() {
  group('RemixAccordionSpec', () {
    group('Constructor', () {
      test('creates spec with default values when no parameters provided', () {
        const spec = RemixAccordionSpec();

        expect(spec.trigger, isA<StyleSpec<FlexBoxSpec>>());
        expect(spec.leadingIcon, isA<StyleSpec<IconSpec>>());
        expect(spec.title, isA<StyleSpec<TextSpec>>());
        expect(spec.trailingIcon, isA<StyleSpec<IconSpec>>());
        expect(spec.content, isA<StyleSpec<BoxSpec>>());
      });

      test('creates spec with custom values', () {
        final customTrigger = StyleSpec(spec: FlexBoxSpec());
        final customTitle = StyleSpec(spec: TextSpec());

        final spec = RemixAccordionSpec(
          trigger: customTrigger,
          title: customTitle,
        );

        expect(spec.trigger, equals(customTrigger));
        expect(spec.title, equals(customTitle));
      });
    });

    group('copyWith', () {
      test('returns new instance with updated properties', () {
        const originalSpec = RemixAccordionSpec();
        final newTrigger = StyleSpec(spec: FlexBoxSpec());
        final newTitle = StyleSpec(spec: TextSpec());

        final updatedSpec = originalSpec.copyWith(
          trigger: newTrigger,
          title: newTitle,
        );

        expect(updatedSpec, isNot(same(originalSpec)));
        expect(updatedSpec.trigger, equals(newTrigger));
        expect(updatedSpec.title, equals(newTitle));
        expect(updatedSpec.leadingIcon, equals(originalSpec.leadingIcon));
        expect(updatedSpec.trailingIcon, equals(originalSpec.trailingIcon));
        expect(updatedSpec.content, equals(originalSpec.content));
      });

      test(
        'returns new instance with no changes when no parameters provided',
        () {
          const originalSpec = RemixAccordionSpec();

          final updatedSpec = originalSpec.copyWith();

          expect(updatedSpec, isNot(same(originalSpec)));
          expect(updatedSpec.trigger, equals(originalSpec.trigger));
          expect(updatedSpec.title, equals(originalSpec.title));
          expect(updatedSpec.leadingIcon, equals(originalSpec.leadingIcon));
          expect(updatedSpec.trailingIcon, equals(originalSpec.trailingIcon));
          expect(updatedSpec.content, equals(originalSpec.content));
        },
      );

      test('preserves immutability - original spec unchanged', () {
        const originalSpec = RemixAccordionSpec();
        final originalTrigger = originalSpec.trigger;
        final newTrigger = StyleSpec(spec: FlexBoxSpec());

        final updatedSpec = originalSpec.copyWith(trigger: newTrigger);

        expect(originalSpec.trigger, equals(originalTrigger));
        expect(updatedSpec.trigger, equals(newTrigger));
        expect(updatedSpec.trigger, isNot(same(originalTrigger)));
      });
    });

    group('lerp', () {
      test('returns this spec when other is null', () {
        const spec = RemixAccordionSpec();
        const other = null;

        final result = spec.lerp(other, 0.5);

        expect(result, same(spec));
      });

      test('interpolates between two specs at t=0.0', () {
        final spec1 = RemixAccordionSpec(
          trigger: StyleSpec(spec: FlexBoxSpec()),
          title: StyleSpec(spec: TextSpec()),
        );
        final spec2 = RemixAccordionSpec(
          trigger: StyleSpec(spec: FlexBoxSpec()),
          title: StyleSpec(spec: TextSpec()),
        );

        final result = spec1.lerp(spec2, 0.0);

        expect(result, isNot(same(spec1)));
        expect(result, isNot(same(spec2)));
        expect(result, isA<RemixAccordionSpec>());
      });

      test('interpolates between two specs at t=1.0', () {
        final spec1 = RemixAccordionSpec(
          trigger: StyleSpec(spec: FlexBoxSpec()),
          title: StyleSpec(spec: TextSpec()),
        );
        final spec2 = RemixAccordionSpec(
          trigger: StyleSpec(spec: FlexBoxSpec()),
          title: StyleSpec(spec: TextSpec()),
        );

        final result = spec1.lerp(spec2, 1.0);

        expect(result, isNot(same(spec1)));
        expect(result, isNot(same(spec2)));
        expect(result, isA<RemixAccordionSpec>());
      });

      test('interpolates between two specs at t=0.5', () {
        final spec1 = RemixAccordionSpec(
          trigger: StyleSpec(spec: FlexBoxSpec()),
          title: StyleSpec(spec: TextSpec()),
        );
        final spec2 = RemixAccordionSpec(
          trigger: StyleSpec(spec: FlexBoxSpec()),
          title: StyleSpec(spec: TextSpec()),
        );

        final result = spec1.lerp(spec2, 0.5);

        expect(result, isNot(same(spec1)));
        expect(result, isNot(same(spec2)));
        expect(result, isA<RemixAccordionSpec>());
      });
    });

    group('Equality and Props', () {
      test('two specs with same properties are equal', () {
        const spec1 = RemixAccordionSpec();
        const spec2 = RemixAccordionSpec();

        expect(spec1, equals(spec2));
        expect(spec1.hashCode, equals(spec2.hashCode));
      });

      test('specs with different properties are not equal', () {
        const spec1 = RemixAccordionSpec();
        final spec2 = RemixAccordionSpec(
          trigger: StyleSpec(
            spec: FlexBoxSpec(
              box: StyleSpec(
                spec: BoxSpec(
                  decoration: BoxDecoration(color: Colors.red),
                ),
              ),
            ),
          ),
        );

        expect(spec1, isNot(equals(spec2)));
      });

      test('props list contains all properties', () {
        const spec = RemixAccordionSpec();

        expect(spec.props, hasLength(5));
        expect(spec.props, contains(spec.trigger));
        expect(spec.props, contains(spec.leadingIcon));
        expect(spec.props, contains(spec.title));
        expect(spec.props, contains(spec.trailingIcon));
        expect(spec.props, contains(spec.content));
      });
    });

    group('Diagnostic Support', () {
      test('debugFillProperties works without throwing', () {
        const spec = RemixAccordionSpec();

        expect(
          () => spec.debugFillProperties(DiagnosticPropertiesBuilder()),
          returnsNormally,
        );
      });

      test('can be converted to string for debugging', () {
        const spec = RemixAccordionSpec();

        expect(spec.toString(), isA<String>());
        expect(spec.toString(), isNotEmpty);
      });

      test('diagnostic properties are properly formatted', () {
        const spec = RemixAccordionSpec();
        final builder = DiagnosticPropertiesBuilder();

        spec.debugFillProperties(builder);

        final properties = builder.properties;
        expect(properties, hasLength(5));

        final propertyNames = properties.map((p) => p.name).toList();
        expect(propertyNames, contains('trigger'));
        expect(propertyNames, contains('leadingIcon'));
        expect(propertyNames, contains('title'));
        expect(propertyNames, contains('trailingIcon'));
        expect(propertyNames, contains('content'));
      });
    });

    group('Edge Cases', () {
      test('copyWith handles null parameters correctly', () {
        const spec = RemixAccordionSpec();
        final originalTrigger = spec.trigger;

        final updatedSpec = spec.copyWith(trigger: null);

        expect(updatedSpec.trigger, equals(originalTrigger));
      });
    });
  });
}
