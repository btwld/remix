import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_protocol/mix_protocol.dart';
import 'package:remix/remix.dart';

import 'support/fortal_button_component_artifact.dart';

void main() {
  group('Fortal protocol probe', () {
    for (final brightness in Brightness.values) {
      testWidgets('${brightness.name} theme round-trips canonically', (
        tester,
      ) async {
        final rawTokens = await _captureFortalTokens(tester, brightness);
        final rawErrors = _expectFailure(
          mixProtocol.encodeTheme(MixProtocolTheme(tokens: rawTokens)),
        );
        final tokens = _concretizeFortalShadowTokens(rawTokens);

        final encoded = _expectSuccess(
          mixProtocol.encodeTheme(MixProtocolTheme(tokens: tokens)),
        );
        final decoded = _expectSuccess(mixProtocol.decodeTheme(encoded));
        final reencoded = _expectSuccess(mixProtocol.encodeTheme(decoded));

        expect(rawErrors, hasLength(6));
        expect(
          rawErrors,
          everyElement(
            isA<MixProtocolError>()
                .having(
                  (error) => error.code,
                  'code',
                  MixProtocolErrorCode.constraintViolation,
                )
                .having(
                  (error) => error.path,
                  'path',
                  startsWith('/boxShadows/fortal.shadow.'),
                ),
          ),
        );
        expect(reencoded, encoded);
        expect(decoded.tokens, hasLength(tokens.length));
      });
    }

    test('built-in Fortal-tokenized style round-trips', () {
      final style = FlexBoxStyler(
        decoration: BoxDecorationMix(color: FortalTokens.accent9()),
        padding: EdgeInsetsMix.all(FortalTokens.space3()),
        spacing: FortalTokens.space2(),
      );

      final encoded = _expectSuccess(mixProtocol.encodeStyle(style));
      final decoded = _expectSuccess(
        mixProtocol.decodeStyle<FlexBoxStyler>(encoded),
      );
      final reencoded = _expectSuccess(mixProtocol.encodeStyle(decoded));
      final references = tokenReferencesOf(
        decoded,
      ).map((reference) => '${reference.kind}:${reference.name}').toSet();

      expect(reencoded, encoded);
      expect(references, {
        'colors:fortal.accent.9',
        'spaces:fortal.space.2',
        'spaces:fortal.space.3',
      });
    });

    test('fluent multi-source built-in style round-trips canonically', () {
      final style = FlexBoxStyler()
          .color(FortalTokens.accent9())
          .paddingAll(FortalTokens.space3())
          .spacing(FortalTokens.space2());

      final encoded = _expectSuccess(mixProtocol.encodeStyle(style));
      final decoded = _expectSuccess(
        mixProtocol.decodeStyle<FlexBoxStyler>(encoded),
      );
      final reencoded = _expectSuccess(mixProtocol.encodeStyle(decoded));
      final references = tokenReferencesOf(
        decoded,
      ).map((reference) => '${reference.kind}:${reference.name}').toSet();

      expect(reencoded, encoded);
      expect(references, {
        'colors:fortal.accent.9',
        'spaces:fortal.space.2',
        'spaces:fortal.space.3',
      });
    });

    test('custom ButtonStyler fails with a structured diagnostic', () {
      final errors = _expectFailure(
        mixProtocol.encodeStyle(fortalButtonStyler()),
      );

      expect(
        errors.map((error) => error.code),
        contains(MixProtocolErrorCode.unsupportedEncodeValue),
      );
      expect(errors, everyElement(isA<MixProtocolError>()));
    });

    test('strict theme decode rejects unknown fields', () {
      final errors = _expectFailure(
        mixProtocol.decodeTheme({
          'v': mixProtocolFormatVersion,
          'type': 'theme',
          'unexpected': true,
        }),
      );

      expect(errors.single.code, MixProtocolErrorCode.unknownField);
      expect(errors.single.path, '/unexpected');
    });

    test('theme decode rejects unsupported versions', () {
      final errors = _expectFailure(
        mixProtocol.decodeTheme({'v': 999, 'type': 'theme'}),
      );

      expect(errors.single.code, MixProtocolErrorCode.unsupportedVersion);
      expect(errors.single.path, '/v');
    });

    testWidgets('canonical protocol artifacts match', (tester) async {
      if (autoUpdateGoldenFiles) _resetGeneratedButtonArtifacts();
      final themeCoverage = <Map<String, Object?>>[];

      for (final brightness in Brightness.values) {
        final rawTokens = await _captureFortalTokens(tester, brightness);
        final rawErrors = _expectFailure(
          mixProtocol.encodeTheme(MixProtocolTheme(tokens: rawTokens)),
        );
        final concreteTokens = _concretizeFortalShadowTokens(rawTokens);
        final themeDocument = _expectSuccess(
          mixProtocol.encodeTheme(MixProtocolTheme(tokens: concreteTokens)),
        );

        _expectJsonArtifact(
          'goldens/protocol/themes/${brightness.name}.mix.json',
          themeDocument,
        );
        themeCoverage.add({
          'id': brightness.name,
          'status': 'supported',
          'tokenCount': concreteTokens.length,
          'rawStatus': 'failed',
          'captureTransform': 'concretizeBoxShadowColorTokenReferences',
          'rawDiagnostics': [for (final error in rawErrors) error.toJson()],
        });
      }

      final builtInStyle = FlexBoxStyler(
        decoration: BoxDecorationMix(color: FortalTokens.accent9()),
        padding: EdgeInsetsMix.all(FortalTokens.space3()),
        spacing: FortalTokens.space2(),
      );
      final builtInDocument = _expectSuccess(
        mixProtocol.encodeStyle(builtInStyle),
      );
      final builtInReferences = tokenReferencesOf(builtInStyle).toList()
        ..sort(
          (a, b) => '${a.kind}:${a.name}'.compareTo('${b.kind}:${b.name}'),
        );
      _expectJsonArtifact(
        'goldens/protocol/fixtures/fortal-tokenized-flex-box.mix.json',
        builtInDocument,
      );

      final componentArtifacts = buildFortalButtonComponentArtifacts();
      _expectJsonArtifact(
        'goldens/components/button.component.json',
        componentArtifacts.document,
      );
      final componentStyleEntries =
          componentArtifacts.styleDocuments.entries.toList()
            ..sort((left, right) => left.key.compareTo(right.key));
      for (final entry in componentStyleEntries) {
        _expectJsonArtifact('goldens/${entry.key}', entry.value);
      }
      final componentRecipes =
          componentArtifacts.document['recipes']! as List<Object?>;
      final firstRecipe = componentRecipes.first! as Map<String, Object?>;
      final firstStyles = firstRecipe['styles']! as Map<String, Object?>;
      final firstContainer = firstStyles['container']! as Map<String, Object?>;
      final firstSpinner = firstStyles['spinner']! as Map<String, Object?>;
      final componentDiagnostics = <Object?>[
        ...(firstSpinner['diagnostics']! as List<Object?>),
        if (firstContainer['status'] == 'unsupported')
          ...(firstContainer['diagnostics']! as List<Object?>),
      ];

      final fluentStyle = FlexBoxStyler()
          .color(FortalTokens.accent9())
          .paddingAll(FortalTokens.space3())
          .spacing(FortalTokens.space2());
      final fluentDocument = _expectSuccess(
        mixProtocol.encodeStyle(fluentStyle),
      );
      final fluentRoundTrip = _expectSuccess(
        mixProtocol.decodeStyle<FlexBoxStyler>(fluentDocument),
      );
      final fluentReferences = tokenReferencesOf(fluentRoundTrip).toList()
        ..sort(
          (a, b) => '${a.kind}:${a.name}'.compareTo('${b.kind}:${b.name}'),
        );
      final customErrors = _expectFailure(
        mixProtocol.encodeStyle(fortalButtonStyler()),
      );
      final coverage = <String, Object?>{
        'schema': 'mix_atlas/protocol-coverage/v1',
        'mixProtocolVersion': mixProtocolVersion,
        'mixProtocolFormat': mixProtocolFormatVersion,
        'themes': themeCoverage,
        'styles': [
          {
            'id': 'fortal-tokenized-flex-box-fixture',
            'runtimeType': 'FlexBoxStyler',
            'status': 'supported',
            'tokenReferences': [
              for (final reference in builtInReferences)
                {'kind': reference.kind, 'name': reference.name},
            ],
          },
          {
            'id': 'fortal-tokenized-flex-box-fluent',
            'runtimeType': 'FlexBoxStyler',
            'status': 'supported',
            'tokenReferences': [
              for (final reference in fluentReferences)
                {'kind': reference.kind, 'name': reference.name},
            ],
          },
          {
            'id': 'fortal-button-portable',
            'runtimeType': 'ButtonStyler projection',
            'status': componentArtifacts.supportedContainerRecipes == 20
                ? 'partial'
                : 'unsupported',
            'recipeCount': componentRecipes.length,
            'totalMatrixCells': componentArtifacts.totalMatrixCells,
            'nonLoadingCells': componentArtifacts.nonLoadingCells,
            'loadingUnsupportedCells':
                componentArtifacts.loadingUnsupportedCells,
            'supportedContainerRecipes':
                componentArtifacts.supportedContainerRecipes,
            'diagnostics': componentDiagnostics,
          },
          {
            'id': 'fortal-button',
            'runtimeType': 'ButtonStyler',
            'status': 'unsupported',
            'diagnostics': [for (final error in customErrors) error.toJson()],
          },
        ],
      };
      _expectJsonArtifact('goldens/protocol/coverage.json', coverage);
    });
  });
}

void _resetGeneratedButtonArtifacts() {
  final comparator = goldenFileComparator;
  if (comparator is! LocalFileComparator) {
    fail('Protocol artifacts require Flutter LocalFileComparator.');
  }
  for (final path in ['goldens/components', 'goldens/styles']) {
    final directory = Directory.fromUri(comparator.basedir.resolve(path));
    if (directory.existsSync()) directory.deleteSync(recursive: true);
  }
}

Future<Map<MixToken, Object>> _captureFortalTokens(
  WidgetTester tester,
  Brightness brightness,
) async {
  Map<MixToken, Object>? captured;

  await tester.pumpWidget(
    MaterialApp(
      home: FortalScope(
        brightness: brightness,
        child: Builder(
          builder: (context) {
            captured = Map.unmodifiable(MixScope.of(context).tokens!);

            return const SizedBox.shrink();
          },
        ),
      ),
    ),
  );

  return captured!;
}

Map<MixToken, Object> _concretizeFortalShadowTokens(
  Map<MixToken, Object> tokens,
) {
  return {
    for (final MapEntry(:key, :value) in tokens.entries)
      key: switch (value) {
        List<BoxShadow>() => [
          for (final shadow in value)
            shadow.copyWith(color: _resolveColor(shadow.color, tokens)),
        ],
        _ => value,
      },
  };
}

Color _resolveColor(Color color, Map<MixToken, Object> tokens) {
  final active = <MixToken<dynamic>>{};
  var current = color;

  while (true) {
    final token = tokenFromReferenceValue<Color>(current);
    if (token == null) break;
    if (!active.add(token)) {
      fail('Circular Fortal color token reference: ${token.name}');
    }
    final resolved = tokens[token];
    if (resolved is! Color) {
      fail(
        'Fortal color token ${token.name} resolved to ${resolved.runtimeType}.',
      );
    }
    current = resolved;
  }

  return current;
}

T _expectSuccess<T extends Object>(MixProtocolResult<T> result) {
  return switch (result) {
    MixProtocolSuccess<T>(:final value) => value,
    MixProtocolFailure<T>(:final errors) => fail('Expected success: $errors'),
  };
}

List<MixProtocolError> _expectFailure<T extends Object>(
  MixProtocolResult<T> result,
) {
  return switch (result) {
    MixProtocolFailure<T>(:final errors) => errors,
    MixProtocolSuccess<T>() => fail('Expected protocol failure.'),
  };
}

void _expectJsonArtifact(String path, Map<String, Object?> payload) {
  final canonical = '${const JsonEncoder.withIndent('  ').convert(payload)}\n';
  final comparator = goldenFileComparator;
  if (comparator is! LocalFileComparator) {
    fail('Protocol artifacts require Flutter LocalFileComparator.');
  }
  final file = File.fromUri(comparator.basedir.resolve(path));

  if (autoUpdateGoldenFiles) {
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(canonical);

    return;
  }

  expect(file.existsSync(), isTrue, reason: 'Missing protocol artifact: $path');
  if (!file.existsSync()) return;
  expect(
    file.readAsStringSync(),
    canonical,
    reason: 'Stale protocol artifact: $path',
  );
}
