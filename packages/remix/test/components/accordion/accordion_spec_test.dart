import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../lib/remix.dart';

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

      test('creates spec with provided values', () {
        final trigger = StyleSpec(spec: FlexBoxSpec());
        final leadingIcon = StyleSpec(spec: IconSpec());
        final title = StyleSpec(spec: TextSpec());
        final trailingIcon = StyleSpec(spec: IconSpec());
        final content = StyleSpec(spec: BoxSpec());

        final spec = RemixAccordionSpec(
          trigger: trigger,
          leadingIcon: leadingIcon,
          title: title,
          trailingIcon: trailingIcon,
          content: content,
        );

        expect(spec.trigger, equals(trigger));
        expect(spec.leadingIcon, equals(leadingIcon));
        expect(spec.title, equals(title));
        expect(spec.trailingIcon, equals(trailingIcon));
        expect(spec.content, equals(content));
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
          expect(updatedSpec.leadingIcon, equals(originalSpec.leadingIcon));
          expect(updatedSpec.title, equals(originalSpec.title));
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

      test('copyWith updates only specified fields', () {
        const originalSpec = RemixAccordionSpec();
        final newLeadingIcon = StyleSpec(spec: IconSpec());
        final newTrailingIcon = StyleSpec(spec: IconSpec());

        final updatedSpec = originalSpec.copyWith(
          leadingIcon: newLeadingIcon,
          trailingIcon: newTrailingIcon,
        );

        expect(updatedSpec.leadingIcon, equals(newLeadingIcon));
        expect(updatedSpec.trailingIcon, equals(newTrailingIcon));
        expect(updatedSpec.trigger, equals(originalSpec.trigger));
        expect(updatedSpec.title, equals(originalSpec.title));
        expect(updatedSpec.content, equals(originalSpec.content));
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

        expect(result, isA<RemixAccordionSpec>());
      });

      test('lerp interpolates all fields', () {
        final spec1 = RemixAccordionSpec(
          trigger: StyleSpec(spec: FlexBoxSpec()),
          leadingIcon: StyleSpec(spec: IconSpec()),
          title: StyleSpec(spec: TextSpec()),
          trailingIcon: StyleSpec(spec: IconSpec()),
          content: StyleSpec(spec: BoxSpec()),
        );
        final spec2 = RemixAccordionSpec(
          trigger: StyleSpec(spec: FlexBoxSpec()),
          leadingIcon: StyleSpec(spec: IconSpec()),
          title: StyleSpec(spec: TextSpec()),
          trailingIcon: StyleSpec(spec: IconSpec()),
          content: StyleSpec(spec: BoxSpec()),
        );

        final result = spec1.lerp(spec2, 0.5);

        expect(result.trigger, isA<StyleSpec<FlexBoxSpec>>());
        expect(result.leadingIcon, isA<StyleSpec<IconSpec>>());
        expect(result.title, isA<StyleSpec<TextSpec>>());
        expect(result.trailingIcon, isA<StyleSpec<IconSpec>>());
        expect(result.content, isA<StyleSpec<BoxSpec>>());
      });
    });

    group('Equality and Props', () {
      test('specs with same values are equal', () {
        const spec1 = RemixAccordionSpec();
        const spec2 = RemixAccordionSpec();

        expect(spec1, equals(spec2));
      });

      test('specs with different values are not equal', () {
        const spec1 = RemixAccordionSpec();
        final spec2 = RemixAccordionSpec(
          trigger: StyleSpec(spec: FlexBoxSpec()),
        );

        expect(spec1, isNot(equals(spec2)));
      });

      test('props list contains all fields', () {
        const spec = RemixAccordionSpec();

        expect(spec.props.length, equals(5));
        expect(spec.props, contains(spec.trigger));
        expect(spec.props, contains(spec.leadingIcon));
        expect(spec.props, contains(spec.title));
        expect(spec.props, contains(spec.trailingIcon));
        expect(spec.props, contains(spec.content));
      });

      test('hashCode is consistent with equality', () {
        const spec1 = RemixAccordionSpec();
        const spec2 = RemixAccordionSpec();

        expect(spec1.hashCode, equals(spec2.hashCode));
      });
    });

    group('Diagnostic Support', () {
      test('debugFillProperties includes all properties', () {
        const spec = RemixAccordionSpec();
        final builder = DiagnosticPropertiesBuilder();

        spec.debugFillProperties(builder);

        final properties = builder.properties
            .where((p) => p is DiagnosticsProperty)
            .map((p) => p.name)
            .toList();

        expect(properties, contains('trigger'));
        expect(properties, contains('leadingIcon'));
        expect(properties, contains('title'));
        expect(properties, contains('trailingIcon'));
        expect(properties, contains('content'));
      });

      test('debugFillProperties provides meaningful diagnostic info', () {
        final trigger = StyleSpec(spec: FlexBoxSpec());
        final spec = RemixAccordionSpec(trigger: trigger);
        final builder = DiagnosticPropertiesBuilder();

        spec.debugFillProperties(builder);

        expect(builder.properties, isNotEmpty);
      });
    });

    group('Edge Cases', () {
      test('handles null values in lerp gracefully', () {
        const spec = RemixAccordionSpec();

        final result = spec.lerp(null, 0.5);

        expect(result, same(spec));
      });

      test('lerp with extreme t values', () {
        final spec1 = RemixAccordionSpec(
          trigger: StyleSpec(spec: FlexBoxSpec()),
        );
        final spec2 = RemixAccordionSpec(
          title: StyleSpec(spec: TextSpec()),
        );

        final resultNegative = spec1.lerp(spec2, -1.0);
        final resultOverOne = spec1.lerp(spec2, 2.0);

        expect(resultNegative, isA<RemixAccordionSpec>());
        expect(resultOverOne, isA<RemixAccordionSpec>());
      });

      test('copyWith with all null arguments returns equivalent spec', () {
        const originalSpec = RemixAccordionSpec();

        final copiedSpec = originalSpec.copyWith();

        expect(copiedSpec, equals(originalSpec));
        expect(copiedSpec, isNot(same(originalSpec)));
      });

      test('spec with all custom values maintains integrity', () {
        final trigger = StyleSpec(spec: FlexBoxSpec());
        final leadingIcon = StyleSpec(spec: IconSpec());
        final title = StyleSpec(spec: TextSpec());
        final trailingIcon = StyleSpec(spec: IconSpec());
        final content = StyleSpec(spec: BoxSpec());

        final spec = RemixAccordionSpec(
          trigger: trigger,
          leadingIcon: leadingIcon,
          title: title,
          trailingIcon: trailingIcon,
          content: content,
        );

        expect(spec.trigger, equals(trigger));
        expect(spec.leadingIcon, equals(leadingIcon));
        expect(spec.title, equals(title));
        expect(spec.trailingIcon, equals(trailingIcon));
        expect(spec.content, equals(content));
        expect(spec.props.length, equals(5));
      });
    });
  });
}
