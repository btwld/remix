import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/fortal/theme/theme_data.dart';

const _fortal = 'lib/src/fortal';

final _customizationTokens = {
  'accent9',
  'accentA1',
  'accentA9',
  'accentA10',
  'accentA11',
  'accentA12',
  'grayA1',
  'grayA12',
  for (var step = 1; step <= 12; step++) 'blackA$step',
  for (var step = 2; step <= 12; step++) 'whiteA$step',
  'colorPanelTranslucent',
  'graySurface',
  'grayIndicator',
  'grayTrack',
  'focusA8',
  'error7',
  'error12',
  'shadowStroke',
  'grayStroke3',
  'grayStroke4',
  'grayStroke5',
  'grayStroke7',
  'radiusFull',
  'radiusThumb',
  'shadow1',
  'shadow2',
  'shadow1Layers',
};

const _deprecatedTokens = {
  'transitionFast',
  'transitionSlow',
  'planMaxHeight',
  'messageAvatarSize',
  'composerFieldMinHeight',
};

void main() {
  final declaration = _parse(File('$_fortal/theme/tokens.dart')).declarations
      .whereType<ClassDeclaration>()
      .singleWhere((node) => node.namePart.typeName.lexeme == 'FortalTokens');
  final declared = {
    for (final field
        in (declaration.body as BlockClassBody).members
            .whereType<FieldDeclaration>())
      if (field.isStatic)
        for (final variable in field.fields.variables)
          if (!variable.name.lexeme.startsWith('_'))
            variable.name.lexeme: (
              id: _tokenId(variable),
              deprecated: field.metadata.any(
                (annotation) => annotation.name.name == 'Deprecated',
              ),
            ),
  };

  test('scope token IDs match all public declarations', () {
    final ids = declared.values.map((token) => token.id);
    expect(
      ids.toSet(),
      hasLength(declared.length),
      reason: 'Duplicate token IDs',
    );
    for (final appearance in [
      const FortalThemeData.light(),
      const FortalThemeData.dark(),
    ]) {
      for (final panel in FortalPanelBackground.values) {
        final scope = buildFortalScopeTokens(
          appearance.copyWith(panelBackground: panel),
        );
        expect(
          scope.keys.map((token) => token.name),
          unorderedEquals(ids),
          reason: '${appearance.brightness}, $panel',
        );
      }
    }
  });

  test('every public token is recipe-used, customizable, or deprecated', () {
    final references = _TokenReferences();
    for (final directory in ['components', 'recipes']) {
      for (final file in Directory(
        '$_fortal/$directory',
      ).listSync(recursive: true).whereType<File>()) {
        if (file.path.endsWith('.dart') && !file.path.endsWith('.g.dart')) {
          _parse(file).accept(references);
        }
      }
    }
    final unused = declared.keys.toSet().difference(references.names);
    final classified = {..._customizationTokens, ..._deprecatedTokens};
    expect(
      unused.difference(classified),
      isEmpty,
      reason: 'Unclassified tokens',
    );
    expect(
      classified.difference(unused),
      isEmpty,
      reason: 'Stale classifications',
    );
    expect(_customizationTokens.intersection(_deprecatedTokens), isEmpty);
    expect([
      for (final MapEntry(:key, :value) in declared.entries)
        if (value.deprecated) key,
    ], unorderedEquals(_deprecatedTokens));
  });
}

CompilationUnit _parse(File file) =>
    parseString(path: file.path, content: file.readAsStringSync()).unit;

String _tokenId(VariableDeclaration declaration) {
  final arguments = switch (declaration.initializer) {
    MethodInvocation(:final argumentList) ||
    InstanceCreationExpression(:final argumentList) => argumentList.arguments,
    _ => throw StateError(
      '${declaration.name} must declare a token with a literal ID',
    ),
  };
  return (arguments.single as StringLiteral).stringValue!;
}

class _TokenReferences extends RecursiveAstVisitor<void> {
  final names = <String>{};

  @override
  void visitComment(Comment node) {}

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    if (node.prefix.name == 'FortalTokens') names.add(node.identifier.name);
    super.visitPrefixedIdentifier(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (node.target case SimpleIdentifier(name: 'FortalTokens')) {
      names.add(node.methodName.name);
    }
    super.visitMethodInvocation(node);
  }
}
