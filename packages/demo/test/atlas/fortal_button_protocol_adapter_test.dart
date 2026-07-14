import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_protocol/mix_protocol.dart';
import 'package:remix/remix.dart';

import 'support/fortal_button_protocol_adapter.dart';
import 'support/fortal_button_component_artifact.dart';

void main() {
  group('Fortal Button protocol adapter', () {
    test('projects real composite sources without restating the recipe', () {
      final projection = projectRemixButtonStyler(
        fortalButtonStyler(
          variant: FortalButtonVariant.surface,
          size: FortalButtonSize.size3,
        ),
      );

      expect(projection.container, isNotNull);
      expect(projection.label, isNotNull);
      expect(projection.icon, isNotNull);
      expect(projection.diagnostics, isEmpty);
      expect(
        projection.container!.$variants!
            .map((variant) => variant.variant)
            .whereType<WidgetStateVariant>()
            .map((variant) => variant.state),
        containsAll({
          WidgetState.hovered,
          WidgetState.focused,
          WidgetState.disabled,
        }),
      );
    });

    test('all projected slots encode as built-in protocol styles', () {
      for (final variant in FortalButtonVariant.values) {
        for (final size in FortalButtonSize.values) {
          final projection = projectRemixButtonStyler(
            fortalButtonStyler(variant: variant, size: size),
          );

          expect(
            mixProtocol.encodeStyle(projection.container!),
            isA<MixProtocolSuccess<Map<String, Object?>>>(),
            reason: '${variant.name}-${size.name} container',
          );
          expect(
            mixProtocol.encodeStyle(projection.label!),
            isA<MixProtocolSuccess<Map<String, Object?>>>(),
            reason: '${variant.name}-${size.name} label',
          );
          expect(
            mixProtocol.encodeStyle(projection.icon!),
            isA<MixProtocolSuccess<Map<String, Object?>>>(),
            reason: '${variant.name}-${size.name} icon',
          );
        }
      }
    });

    test(
      'keeps spinner support explicit instead of projecting custom code',
      () {
        final projection = projectRemixButtonStyler(fortalButtonStyler());

        expect(projection.spinnerSupported, isFalse);
        expect(projection.spinnerDiagnostic.code, 'unsupported_slot_primitive');
        expect(projection.spinnerDiagnostic.path, 'spinner');
      },
    );

    test('builds a deterministic 240-cell portable Button contract', () {
      final first = buildFortalButtonComponentArtifacts();
      final second = buildFortalButtonComponentArtifacts();
      final recipes = first.document['recipes']! as List<Object?>;
      final states = first.document['states']! as List<Object?>;
      final oracles = first.document['oracles']! as List<Object?>;

      expect(recipes, hasLength(20));
      expect(states, hasLength(6));
      expect(oracles, hasLength(2));
      expect(first.totalMatrixCells, 240);
      expect(first.nonLoadingCells, 200);
      expect(first.loadingUnsupportedCells, 40);
      expect(first.styleDocuments, hasLength(60));
      expect(first.supportedContainerRecipes, 20);
      expect(jsonEncode(first.document), jsonEncode(second.document));
      expect(
        jsonEncode(first.styleDocuments),
        jsonEncode(second.styleDocuments),
      );
      for (final recipeValue in recipes) {
        final recipe = recipeValue! as Map<String, Object?>;
        final styles = recipe['styles']! as Map<String, Object?>;
        expect(styles.keys, {
          'container',
          'label',
          'leadingIcon',
          'trailingIcon',
          'spinner',
        });
        final spinner = styles['spinner']! as Map<String, Object?>;
        expect(spinner['status'], 'unsupported');
        final container = styles['container']! as Map<String, Object?>;
        expect(container['status'], 'supported');
        expect(container['document'], endsWith('/container.mix.json'));
      }
    });
  });
}
