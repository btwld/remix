import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:remix/remix.dart';

void main() {
  group('RemixAvatarSpec', () {
    group('Constructor', () {
      test('creates spec with default values when no parameters provided', () {
        const spec = RemixAvatarSpec();

        expect(spec.container, isA<StyleSpec<BoxSpec>>());
        expect(spec.text, isA<StyleSpec<TextSpec>>());
        expect(spec.icon, isA<StyleSpec<IconSpec>>());
      });
    });

    group('copyWith', () {
      test('returns new instance with updated properties', () {
        const originalSpec = RemixAvatarSpec();
        final newContainer = StyleSpec(spec: BoxSpec());

        final updatedSpec = originalSpec.copyWith(container: newContainer);

        expect(updatedSpec, isNot(same(originalSpec)));
        expect(updatedSpec.container, equals(newContainer));
        expect(updatedSpec.text, equals(originalSpec.text));
        expect(updatedSpec.icon, equals(originalSpec.icon));
      });

      test('returns new instance with updated text property', () {
        const originalSpec = RemixAvatarSpec();
        final newText = StyleSpec(spec: TextSpec());

        final updatedSpec = originalSpec.copyWith(text: newText);

        expect(updatedSpec, isNot(same(originalSpec)));
        expect(updatedSpec.container, equals(originalSpec.container));
        expect(updatedSpec.text, equals(newText));
        expect(updatedSpec.icon, equals(originalSpec.icon));
      });

      test('returns new instance with updated icon property', () {
        const originalSpec = RemixAvatarSpec();
        final newIcon = StyleSpec(spec: IconSpec());

        final updatedSpec = originalSpec.copyWith(icon: newIcon);

        expect(updatedSpec, isNot(same(originalSpec)));
        expect(updatedSpec.container, equals(originalSpec.container));
        expect(updatedSpec.text, equals(originalSpec.text));
        expect(updatedSpec.icon, equals(newIcon));
      });

      test('returns new instance with multiple updated properties', () {
        const originalSpec = RemixAvatarSpec();
        final newContainer = StyleSpec(spec: BoxSpec());
        final newText = StyleSpec(spec: TextSpec());
        final newIcon = StyleSpec(spec: IconSpec());

        final updatedSpec = originalSpec.copyWith(
          container: newContainer,
          text: newText,
          icon: newIcon,
        );

        expect(updatedSpec, isNot(same(originalSpec)));
        expect(updatedSpec.container, equals(newContainer));
        expect(updatedSpec.text, equals(newText));
        expect(updatedSpec.icon, equals(newIcon));
      });

      test('preserves immutability - original spec unchanged', () {
        const originalSpec = RemixAvatarSpec();
        final originalContainer = originalSpec.container;
        final originalText = originalSpec.text;
        final originalIcon = originalSpec.icon;
        final newContainer = StyleSpec(spec: BoxSpec());

        final updatedSpec = originalSpec.copyWith(container: newContainer);

        expect(originalSpec.container, equals(originalContainer));
        expect(originalSpec.text, equals(originalText));
        expect(originalSpec.icon, equals(originalIcon));
        expect(updatedSpec.container, equals(newContainer));
        expect(updatedSpec.container, isNot(same(originalContainer)));
      });
    });

    group('lerp', () {
      test('returns this spec when other is null', () {
        const spec = RemixAvatarSpec();
        const other = null;

        final result = spec.lerp(other, 0.5);
        expect(result, same(spec));
      });

      test('interpolates between two specs at t=0.0', () {
        final containerSpec1 = StyleSpec(spec: BoxSpec());
        final textSpec1 = StyleSpec(spec: TextSpec());
        final iconSpec1 = StyleSpec(spec: IconSpec());

        final containerSpec2 = StyleSpec(spec: BoxSpec());
        final textSpec2 = StyleSpec(spec: TextSpec());
        final iconSpec2 = StyleSpec(spec: IconSpec());

        final spec1 = RemixAvatarSpec(
          container: containerSpec1,
          text: textSpec1,
          icon: iconSpec1,
        );
        final spec2 = RemixAvatarSpec(
          container: containerSpec2,
          text: textSpec2,
          icon: iconSpec2,
        );

        final result = spec1.lerp(spec2, 0.0);

        expect(result, isNot(same(spec1)));
        expect(result.container, equals(spec1.container));
        expect(result.text, equals(spec1.text));
        expect(result.icon, equals(spec1.icon));
      });

      test('interpolates between two specs at t=1.0', () {
        final containerSpec1 = StyleSpec(spec: BoxSpec());
        final textSpec1 = StyleSpec(spec: TextSpec());
        final iconSpec1 = StyleSpec(spec: IconSpec());

        final containerSpec2 = StyleSpec(spec: BoxSpec());
        final textSpec2 = StyleSpec(spec: TextSpec());
        final iconSpec2 = StyleSpec(spec: IconSpec());

        final spec1 = RemixAvatarSpec(
          container: containerSpec1,
          text: textSpec1,
          icon: iconSpec1,
        );
        final spec2 = RemixAvatarSpec(
          container: containerSpec2,
          text: textSpec2,
          icon: iconSpec2,
        );

        final result = spec1.lerp(spec2, 1.0);

        expect(result, isNot(same(spec2)));
        expect(result.container, equals(spec2.container));
        expect(result.text, equals(spec2.text));
        expect(result.icon, equals(spec2.icon));
      });

      test('interpolates between two specs at t=0.5', () {
        final containerSpec1 = StyleSpec(spec: BoxSpec());
        final textSpec1 = StyleSpec(spec: TextSpec());
        final iconSpec1 = StyleSpec(spec: IconSpec());

        final containerSpec2 = StyleSpec(spec: BoxSpec());
        final textSpec2 = StyleSpec(spec: TextSpec());
        final iconSpec2 = StyleSpec(spec: IconSpec());

        final spec1 = RemixAvatarSpec(
          container: containerSpec1,
          text: textSpec1,
          icon: iconSpec1,
        );
        final spec2 = RemixAvatarSpec(
          container: containerSpec2,
          text: textSpec2,
          icon: iconSpec2,
        );

        final result = spec1.lerp(spec2, 0.5);

        expect(result, isNot(same(spec1)));
        expect(result, isNot(same(spec2)));
        expect(result, isA<RemixAvatarSpec>());
      });
    });

    group('Equality and Props', () {
      test('two specs with same properties are equal', () {
        const spec1 = RemixAvatarSpec();
        const spec2 = RemixAvatarSpec();

        expect(spec1, equals(spec2));
        expect(spec1.hashCode, equals(spec2.hashCode));
      });

      test('two specs with different properties are not equal', () {
        final textSpec1 = StyleSpec(spec: TextSpec());
        final textSpec2 = StyleSpec(
          spec: TextSpec(style: TextStyle(fontSize: 16)),
        );

        final spec1 = RemixAvatarSpec(text: textSpec1);
        final spec2 = RemixAvatarSpec(text: textSpec2);

        expect(spec1, isNot(equals(spec2)));
      });

      test('props list contains all properties', () {
        const spec = RemixAvatarSpec();

        expect(spec.props, hasLength(3));
        expect(spec.props, contains(spec.container));
        expect(spec.props, contains(spec.text));
        expect(spec.props, contains(spec.icon));
      });
    });

    group('Diagnostic Support', () {
      test('debugFillProperties works without throwing', () {
        const spec = RemixAvatarSpec();

        expect(
          () => spec.debugFillProperties(DiagnosticPropertiesBuilder()),
          returnsNormally,
        );
      });

      test('debugFillProperties includes all properties', () {
        const spec = RemixAvatarSpec();
        final builder = DiagnosticPropertiesBuilder();

        spec.debugFillProperties(builder);

        final properties = builder.properties;
        expect(properties, hasLength(3));

        // Check that all expected properties are included
        final propertyNames = properties.map((p) => p.name).toSet();
        expect(propertyNames, contains('container'));
        expect(propertyNames, contains('text'));
        expect(propertyNames, contains('icon'));
      });

      test('can be converted to string for debugging', () {
        const spec = RemixAvatarSpec();

        expect(spec.toString(), isA<String>());
        expect(spec.toString(), isNotEmpty);
      });

      test('toString includes class name', () {
        const spec = RemixAvatarSpec();

        expect(spec.toString(), contains('RemixAvatarSpec'));
      });
    });
  });
}
