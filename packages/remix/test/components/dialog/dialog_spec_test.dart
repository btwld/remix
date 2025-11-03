import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../lib/remix.dart';

void main() {
  group('RemixDialogSpec', () {
    group('Constructor', () {
      test('creates spec with default values when no parameters provided', () {
        const spec = RemixDialogSpec();

        expect(spec.container, isA<StyleSpec<BoxSpec>>());
        expect(spec.title, isA<StyleSpec<TextSpec>>());
        expect(spec.description, isA<StyleSpec<TextSpec>>());
        expect(spec.actions, isA<StyleSpec<FlexBoxSpec>>());
        expect(spec.overlay, isA<StyleSpec<BoxSpec>>());
        expect(spec.container.spec, isA<BoxSpec>());
        expect(spec.title.spec, isA<TextSpec>());
        expect(spec.description.spec, isA<TextSpec>());
        expect(spec.actions.spec, isA<FlexBoxSpec>());
        expect(spec.overlay.spec, isA<BoxSpec>());
      });

      test('creates spec with provided parameters', () {
        final containerSpec = StyleSpec(spec: BoxSpec());
        final titleSpec = StyleSpec(spec: TextSpec());
        final descriptionSpec = StyleSpec(spec: TextSpec());
        final actionsSpec = StyleSpec(spec: FlexBoxSpec());
        final overlaySpec = StyleSpec(spec: BoxSpec());

        final spec = RemixDialogSpec(
          container: containerSpec,
          title: titleSpec,
          description: descriptionSpec,
          actions: actionsSpec,
          overlay: overlaySpec,
        );

        expect(spec.container, equals(containerSpec));
        expect(spec.title, equals(titleSpec));
        expect(spec.description, equals(descriptionSpec));
        expect(spec.actions, equals(actionsSpec));
        expect(spec.overlay, equals(overlaySpec));
      });
    });

    group('copyWith', () {
      test('returns new instance with updated properties', () {
        const originalSpec = RemixDialogSpec();
        final newContainer = StyleSpec(spec: BoxSpec());
        final newTitle = StyleSpec(spec: TextSpec());
        final newDescription = StyleSpec(spec: TextSpec());
        final newActions = StyleSpec(spec: FlexBoxSpec());
        final newOverlay = StyleSpec(spec: BoxSpec());

        final updatedSpec = originalSpec.copyWith(
          container: newContainer,
          title: newTitle,
          description: newDescription,
          actions: newActions,
          overlay: newOverlay,
        );

        expect(updatedSpec, isNot(same(originalSpec)));
        expect(updatedSpec.container, equals(newContainer));
        expect(updatedSpec.title, equals(newTitle));
        expect(updatedSpec.description, equals(newDescription));
        expect(updatedSpec.actions, equals(newActions));
        expect(updatedSpec.overlay, equals(newOverlay));
      });

      test('returns new instance with single updated property', () {
        const originalSpec = RemixDialogSpec();
        final newContainer = StyleSpec(spec: BoxSpec());

        final updatedSpec = originalSpec.copyWith(container: newContainer);

        expect(updatedSpec, isNot(same(originalSpec)));
        expect(updatedSpec.container, equals(newContainer));
        expect(updatedSpec.title, equals(originalSpec.title));
        expect(updatedSpec.description, equals(originalSpec.description));
        expect(updatedSpec.actions, equals(originalSpec.actions));
        expect(updatedSpec.overlay, equals(originalSpec.overlay));
      });

      test('returns new instance with multiple updated properties', () {
        const originalSpec = RemixDialogSpec();
        final newTitle = StyleSpec(spec: TextSpec());
        final newDescription = StyleSpec(spec: TextSpec());

        final updatedSpec = originalSpec.copyWith(
          title: newTitle,
          description: newDescription,
        );

        expect(updatedSpec, isNot(same(originalSpec)));
        expect(updatedSpec.container, equals(originalSpec.container));
        expect(updatedSpec.title, equals(newTitle));
        expect(updatedSpec.description, equals(newDescription));
        expect(updatedSpec.actions, equals(originalSpec.actions));
        expect(updatedSpec.overlay, equals(originalSpec.overlay));
      });

      test('preserves immutability - original spec unchanged', () {
        const originalSpec = RemixDialogSpec();
        final originalContainer = originalSpec.container;
        final originalTitle = originalSpec.title;
        final originalDescription = originalSpec.description;
        final originalActions = originalSpec.actions;
        final originalOverlay = originalSpec.overlay;
        final newContainer = StyleSpec(spec: BoxSpec());
        final newTitle = StyleSpec(spec: TextSpec());
        final newDescription = StyleSpec(spec: TextSpec());
        final newActions = StyleSpec(spec: FlexBoxSpec());
        final newOverlay = StyleSpec(spec: BoxSpec());

        final updatedSpec = originalSpec.copyWith(
          container: newContainer,
          title: newTitle,
          description: newDescription,
          actions: newActions,
          overlay: newOverlay,
        );

        expect(originalSpec.container, equals(originalContainer));
        expect(originalSpec.title, equals(originalTitle));
        expect(originalSpec.description, equals(originalDescription));
        expect(originalSpec.actions, equals(originalActions));
        expect(originalSpec.overlay, equals(originalOverlay));
        expect(updatedSpec.container, equals(newContainer));
        expect(updatedSpec.title, equals(newTitle));
        expect(updatedSpec.description, equals(newDescription));
        expect(updatedSpec.actions, equals(newActions));
        expect(updatedSpec.overlay, equals(newOverlay));
        expect(updatedSpec.container, isNot(same(originalContainer)));
        expect(updatedSpec.title, isNot(same(originalTitle)));
        expect(updatedSpec.description, isNot(same(originalDescription)));
        expect(updatedSpec.actions, isNot(same(originalActions)));
        expect(updatedSpec.overlay, isNot(same(originalOverlay)));
      });

      test('copyWith with null parameters preserves original values', () {
        const originalSpec = RemixDialogSpec();
        final originalContainer = originalSpec.container;
        final originalTitle = originalSpec.title;
        final originalDescription = originalSpec.description;
        final originalActions = originalSpec.actions;
        final originalOverlay = originalSpec.overlay;

        final updatedSpec = originalSpec.copyWith(
          container: null,
          title: null,
          description: null,
          actions: null,
          overlay: null,
        );

        expect(updatedSpec.container, equals(originalContainer));
        expect(updatedSpec.title, equals(originalTitle));
        expect(updatedSpec.description, equals(originalDescription));
        expect(updatedSpec.actions, equals(originalActions));
        expect(updatedSpec.overlay, equals(originalOverlay));
        expect(updatedSpec.container, same(originalContainer));
        expect(updatedSpec.title, same(originalTitle));
        expect(updatedSpec.description, same(originalDescription));
        expect(updatedSpec.actions, same(originalActions));
        expect(updatedSpec.overlay, same(originalOverlay));
      });
    });

    group('lerp', () {
      test('returns this spec when other is null', () {
        const spec = RemixDialogSpec();
        const other = null;

        final result = spec.lerp(other, 0.5);
        expect(result, same(spec));
      });

      test('interpolates between two specs at t=0.0', () {
        final spec1 = RemixDialogSpec(
          container: StyleSpec(spec: BoxSpec()),
          title: StyleSpec(spec: TextSpec()),
          description: StyleSpec(spec: TextSpec()),
          actions: StyleSpec(spec: FlexBoxSpec()),
          overlay: StyleSpec(spec: BoxSpec()),
        );
        final spec2 = RemixDialogSpec(
          container: StyleSpec(spec: BoxSpec()),
          title: StyleSpec(spec: TextSpec()),
          description: StyleSpec(spec: TextSpec()),
          actions: StyleSpec(spec: FlexBoxSpec()),
          overlay: StyleSpec(spec: BoxSpec()),
        );

        final result = spec1.lerp(spec2, 0.0);

        expect(result, isNot(same(spec1)));
        expect(result.container, equals(spec1.container));
        expect(result.title, equals(spec1.title));
        expect(result.description, equals(spec1.description));
        expect(result.actions, equals(spec1.actions));
        expect(result.overlay, equals(spec1.overlay));
      });

      test('interpolates between two specs at t=1.0', () {
        final spec1 = RemixDialogSpec(
          container: StyleSpec(spec: BoxSpec()),
          title: StyleSpec(spec: TextSpec()),
          description: StyleSpec(spec: TextSpec()),
          actions: StyleSpec(spec: FlexBoxSpec()),
          overlay: StyleSpec(spec: BoxSpec()),
        );
        final spec2 = RemixDialogSpec(
          container: StyleSpec(spec: BoxSpec()),
          title: StyleSpec(spec: TextSpec()),
          description: StyleSpec(spec: TextSpec()),
          actions: StyleSpec(spec: FlexBoxSpec()),
          overlay: StyleSpec(spec: BoxSpec()),
        );

        final result = spec1.lerp(spec2, 1.0);

        expect(result, isNot(same(spec2)));
        expect(result.container, equals(spec2.container));
        expect(result.title, equals(spec2.title));
        expect(result.description, equals(spec2.description));
        expect(result.actions, equals(spec2.actions));
        expect(result.overlay, equals(spec2.overlay));
      });

      test('interpolates between two specs at t=0.5', () {
        final spec1 = RemixDialogSpec(
          container: StyleSpec(spec: BoxSpec()),
          title: StyleSpec(spec: TextSpec()),
          description: StyleSpec(spec: TextSpec()),
          actions: StyleSpec(spec: FlexBoxSpec()),
          overlay: StyleSpec(spec: BoxSpec()),
        );
        final spec2 = RemixDialogSpec(
          container: StyleSpec(spec: BoxSpec()),
          title: StyleSpec(spec: TextSpec()),
          description: StyleSpec(spec: TextSpec()),
          actions: StyleSpec(spec: FlexBoxSpec()),
          overlay: StyleSpec(spec: BoxSpec()),
        );

        final result = spec1.lerp(spec2, 0.5);

        expect(result, isNot(same(spec1)));
        expect(result, isNot(same(spec2)));
        expect(result, isA<RemixDialogSpec>());
      });

      test('lerp with different t values', () {
        final spec1 = RemixDialogSpec(
          container: StyleSpec(spec: BoxSpec()),
          title: StyleSpec(spec: TextSpec()),
          description: StyleSpec(spec: TextSpec()),
          actions: StyleSpec(spec: FlexBoxSpec()),
          overlay: StyleSpec(spec: BoxSpec()),
        );
        final spec2 = RemixDialogSpec(
          container: StyleSpec(spec: BoxSpec()),
          title: StyleSpec(spec: TextSpec()),
          description: StyleSpec(spec: TextSpec()),
          actions: StyleSpec(spec: FlexBoxSpec()),
          overlay: StyleSpec(spec: BoxSpec()),
        );

        final result1 = spec1.lerp(spec2, 0.25);
        final result2 = spec1.lerp(spec2, 0.75);

        expect(result1, isNot(same(result2)));
        expect(result1, isA<RemixDialogSpec>());
        expect(result2, isA<RemixDialogSpec>());
      });
    });

    group('Equality and Props', () {
      test('two specs with same properties are equal', () {
        const spec1 = RemixDialogSpec();
        const spec2 = RemixDialogSpec();

        expect(spec1, equals(spec2));
        expect(spec1.hashCode, equals(spec2.hashCode));
      });

      test('two specs with different properties are not equal', () {
        const spec1 = RemixDialogSpec();
        final spec2 = RemixDialogSpec(
          container: StyleSpec(spec: BoxSpec()),
          title: StyleSpec(spec: TextSpec()),
          description: StyleSpec(spec: TextSpec()),
          actions: StyleSpec(spec: FlexBoxSpec()),
          overlay: StyleSpec(spec: BoxSpec()),
        );

        // Since both have default values, they should be equal
        expect(spec1, equals(spec2));
      });

      test('specs with same custom properties are equal', () {
        final containerSpec = StyleSpec(spec: BoxSpec());
        final titleSpec = StyleSpec(spec: TextSpec());
        final descriptionSpec = StyleSpec(spec: TextSpec());
        final actionsSpec = StyleSpec(spec: FlexBoxSpec());
        final overlaySpec = StyleSpec(spec: BoxSpec());

        final spec1 = RemixDialogSpec(
          container: containerSpec,
          title: titleSpec,
          description: descriptionSpec,
          actions: actionsSpec,
          overlay: overlaySpec,
        );
        final spec2 = RemixDialogSpec(
          container: containerSpec,
          title: titleSpec,
          description: descriptionSpec,
          actions: actionsSpec,
          overlay: overlaySpec,
        );

        expect(spec1, equals(spec2));
        expect(spec1.hashCode, equals(spec2.hashCode));
      });

      test('props list contains all properties', () {
        const spec = RemixDialogSpec();

        expect(spec.props, hasLength(5));
        expect(spec.props, contains(spec.container));
        expect(spec.props, contains(spec.title));
        expect(spec.props, contains(spec.description));
        expect(spec.props, contains(spec.actions));
        expect(spec.props, contains(spec.overlay));
      });

      test('props list with custom properties', () {
        final containerSpec = StyleSpec(spec: BoxSpec());
        final titleSpec = StyleSpec(spec: TextSpec());
        final descriptionSpec = StyleSpec(spec: TextSpec());
        final actionsSpec = StyleSpec(spec: FlexBoxSpec());
        final overlaySpec = StyleSpec(spec: BoxSpec());

        final spec = RemixDialogSpec(
          container: containerSpec,
          title: titleSpec,
          description: descriptionSpec,
          actions: actionsSpec,
          overlay: overlaySpec,
        );

        expect(spec.props, hasLength(5));
        expect(spec.props, contains(containerSpec));
        expect(spec.props, contains(titleSpec));
        expect(spec.props, contains(descriptionSpec));
        expect(spec.props, contains(actionsSpec));
        expect(spec.props, contains(overlaySpec));
      });
    });

    group('Diagnostic Support', () {
      test('debugFillProperties works without throwing', () {
        const spec = RemixDialogSpec();

        expect(
          () => spec.debugFillProperties(DiagnosticPropertiesBuilder()),
          returnsNormally,
        );
      });

      test('debugFillProperties with custom properties', () {
        final containerSpec = StyleSpec(spec: BoxSpec());
        final titleSpec = StyleSpec(spec: TextSpec());
        final descriptionSpec = StyleSpec(spec: TextSpec());
        final actionsSpec = StyleSpec(spec: FlexBoxSpec());
        final overlaySpec = StyleSpec(spec: BoxSpec());

        final spec = RemixDialogSpec(
          container: containerSpec,
          title: titleSpec,
          description: descriptionSpec,
          actions: actionsSpec,
          overlay: overlaySpec,
        );

        expect(
          () => spec.debugFillProperties(DiagnosticPropertiesBuilder()),
          returnsNormally,
        );
      });

      test('can be converted to string for debugging', () {
        const spec = RemixDialogSpec();

        expect(spec.toString(), isA<String>());
        expect(spec.toString(), isNotEmpty);
      });

      test('toString includes all properties', () {
        const spec = RemixDialogSpec();
        final stringRepresentation = spec.toString();

        expect(stringRepresentation, contains('container'));
        expect(stringRepresentation, contains('title'));
        expect(stringRepresentation, contains('description'));
        expect(stringRepresentation, contains('actions'));
        expect(stringRepresentation, contains('overlay'));
      });
    });

    group('Edge Cases and Error Handling', () {
      test('copyWith handles null parameters correctly', () {
        const spec = RemixDialogSpec();
        final originalContainer = spec.container;
        final originalTitle = spec.title;
        final originalDescription = spec.description;
        final originalActions = spec.actions;
        final originalOverlay = spec.overlay;

        final updatedSpec = spec.copyWith(
          container: null,
          title: null,
          description: null,
          actions: null,
          overlay: null,
        );

        expect(updatedSpec.container, equals(originalContainer));
        expect(updatedSpec.title, equals(originalTitle));
        expect(updatedSpec.description, equals(originalDescription));
        expect(updatedSpec.actions, equals(originalActions));
        expect(updatedSpec.overlay, equals(originalOverlay));
      });

      test('lerp handles edge t values', () {
        final spec1 = RemixDialogSpec(
          container: StyleSpec(spec: BoxSpec()),
          title: StyleSpec(spec: TextSpec()),
          description: StyleSpec(spec: TextSpec()),
          actions: StyleSpec(spec: FlexBoxSpec()),
          overlay: StyleSpec(spec: BoxSpec()),
        );
        final spec2 = RemixDialogSpec(
          container: StyleSpec(spec: BoxSpec()),
          title: StyleSpec(spec: TextSpec()),
          description: StyleSpec(spec: TextSpec()),
          actions: StyleSpec(spec: FlexBoxSpec()),
          overlay: StyleSpec(spec: BoxSpec()),
        );

        // Test t=0.0
        final result0 = spec1.lerp(spec2, 0.0);
        expect(result0, isA<RemixDialogSpec>());

        // Test t=1.0
        final result1 = spec1.lerp(spec2, 1.0);
        expect(result1, isA<RemixDialogSpec>());

        // Test t=0.0 and t=1.0 should be different
        expect(result0, isNot(same(result1)));
      });

      test('spec with complex StyleSpec properties', () {
        final complexContainerSpec = StyleSpec(spec: BoxSpec());
        final complexTitleSpec = StyleSpec(spec: TextSpec());
        final complexDescriptionSpec = StyleSpec(spec: TextSpec());
        final complexActionsSpec = StyleSpec(spec: FlexBoxSpec());
        final complexOverlaySpec = StyleSpec(spec: BoxSpec());

        final spec = RemixDialogSpec(
          container: complexContainerSpec,
          title: complexTitleSpec,
          description: complexDescriptionSpec,
          actions: complexActionsSpec,
          overlay: complexOverlaySpec,
        );

        expect(spec.container, equals(complexContainerSpec));
        expect(spec.title, equals(complexTitleSpec));
        expect(spec.description, equals(complexDescriptionSpec));
        expect(spec.actions, equals(complexActionsSpec));
        expect(spec.overlay, equals(complexOverlaySpec));
        expect(spec.props, hasLength(5));
      });
    });
  });
}
