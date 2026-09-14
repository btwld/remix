import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

import '../../packages/remix_cli/lib/src/registry.dart';
import '../../tool/build_registry.dart';

void main() {
  late Directory sandbox;
  late PresetBuilder builder;

  setUp(() {
    sandbox = Directory.systemTemp.createTempSync('agent_registry_test_');
    final source = Directory('${sandbox.path}/source');
    for (final file in Directory(
      'packages/remix_agent/lib/src',
    ).listSync(recursive: true).whereType<File>()) {
      if (!file.path.endsWith('.dart') || file.path.endsWith('.g.dart'))
        continue;
      _write(
        source,
        p.relative(file.path, from: 'packages/remix_agent/lib/src'),
        file.readAsStringSync(),
      );
    }
    final registry = Directory('${sandbox.path}/default');
    _write(
      registry,
      'registry.yaml',
      File(
        'packages/remix_cli/lib/src/registry/default/registry.yaml',
      ).readAsStringSync(),
    );
    builder = PresetBuilder(
      spec: defaultAgentExtension,
      sourceRoot: source,
      defaultRegistryRoot: registry,
      outputRoot: registry,
      recipeRoot: Directory('open_code/agent_recipes/default').absolute,
    );
  });

  tearDown(() => sandbox.deleteSync(recursive: true));

  test(
    'components and recipes reuse default floors and resolve independently',
    () {
      final output = builder.derive();
      final items = _items(output.files['registry.yaml']!);
      expect(items.keys, [
        'models',
        'support',
        'activity',
        'activity_recipe',
        'answer',
        'answer_recipe',
        'composer',
        'composer_recipe',
        'execution',
        'execution_recipe',
        'message',
        'message_recipe',
        'permission',
        'permission_recipe',
        'plan',
        'plan_recipe',
        'transcript',
        'transcript_recipe',
      ]);
      expect(items['support']['registryDependencies'], ['theme']);
      expect(items['support']['dependencies']['remix_ui_icons'], isNotNull);
      expect(items['support']['exports'], isNull);
      expect(items['models']['exports'], contains('models/statuses.dart'));
      expect(
        output.files.keys.where((path) => path != 'registry.yaml'),
        everyElement(startsWith('templates/agent/')),
      );
      expect(output.files.keys, isNot(anyElement(endsWith('.g.dart.tmpl'))));
      _register(builder, output);
      final catalog = RegistryCatalog.parse(
        File('${builder.outputRoot.path}/registry.yaml').readAsStringSync(),
        preset: 'default',
        rootUri: builder.outputRoot.uri,
      );
      for (final name in items.keys.where(
        (name) => name != 'models' && name != 'support',
      )) {
        final closure = catalog.resolve(name as String);
        expect(
          closure.map((item) => item.name),
          containsAll(['theme', 'support', name]),
        );
        expect(
          closure.where((item) => item.dependencies.containsKey('remix')),
          hasLength(1),
        );
        expect(
          closure.expand((item) => item.dependencies.keys),
          isNot(contains('remix_agent')),
        );
      }
    },
  );

  test('prefix round trips and domain prose is not silently renamed', () {
    final output = builder.derive();
    for (final entry in output.sourceByTemplate.entries) {
      final template = output.files[entry.key]!;
      expect(
        template
            .replaceAll('{{typePrefix}}', 'Agent')
            .replaceAll('{{valuePrefix}}', 'agent'),
        entry.value,
      );
      final rendered = template
          .replaceAll('{{typePrefix}}', 'Acme')
          .replaceAll('{{valuePrefix}}', 'acme');
      expect(rendered, isNot(contains('package:remix_agent/')));
      expect(rendered, isNot(contains('../style/')));
      // Prefixable identifiers and family names remain legal. A lowercase
      // standalone domain noun in authored line comments does not.
      for (final line in entry.value.split('\n')) {
        if (!line.trimLeft().startsWith('//')) continue;
        final prose = line.replaceAll(RegExp(r'\[[^\]]+\]|`[^`]+`'), '');
        expect(
          RegExp(r'\bagent\b').hasMatch(prose),
          isFalse,
          reason: '${entry.key}: $line',
        );
      }
    }
  });

  test(
    'writes and prunes only owned templates, with deterministic read-only checks',
    () {
      final output = builder.derive();
      _register(builder, output);
      _write(builder.outputRoot, 'templates/theme/custom.txt', 'keep theme');
      _write(builder.outputRoot, 'templates/unrelated.txt', 'keep sibling');
      _write(
        builder.outputRoot,
        'templates/agent/stale.dart.tmpl',
        'remove me',
      );
      final registry = File('${builder.outputRoot.path}/registry.yaml');
      final metadata = registry.readAsBytesSync();
      builder.write(output);
      expect(registry.readAsBytesSync(), metadata);
      expect(
        File(
          '${builder.outputRoot.path}/templates/theme/custom.txt',
        ).readAsStringSync(),
        'keep theme',
      );
      expect(
        File(
          '${builder.outputRoot.path}/templates/unrelated.txt',
        ).readAsStringSync(),
        'keep sibling',
      );
      expect(
        File(
          '${builder.outputRoot.path}/templates/agent/stale.dart.tmpl',
        ).existsSync(),
        isFalse,
      );
      final before = _snapshot(builder.outputRoot);
      expect(builder.drift(output), isEmpty);
      builder.write(builder.derive());
      expect(_snapshot(builder.outputRoot), before);
      final template = output.sourceByTemplate.keys.first;
      _write(builder.outputRoot, template, '// changed');
      final readOnly = _snapshot(builder.outputRoot);
      expect(builder.drift(output), contains('changed $template'));
      expect(_snapshot(builder.outputRoot), readOnly);
    },
  );

  test('missing and changed metadata fail without rewriting the registry', () {
    final output = builder.derive();
    _register(builder, output);
    final file = File('${builder.outputRoot.path}/registry.yaml');
    final document =
        jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    document['items'].remove('answer');
    document['items']['plan']['exports'] = ['models/statuses.dart'];
    file.writeAsStringSync(jsonEncode(document));
    final before = _snapshot(builder.outputRoot);
    expect(
      builder.drift(output),
      containsAll([
        'missing registry item answer',
        'changed registry item plan',
      ]),
    );
    expect(() => builder.write(output), throwsStateError);
    expect(_snapshot(builder.outputRoot), before);
  });

  test('map key order and formatting do not cause metadata drift', () {
    final output = builder.derive();
    _register(builder, output);
    builder.write(output);
    final file = File('${builder.outputRoot.path}/registry.yaml');
    final document =
        jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    final plan = document['items']['plan'] as Map<String, dynamic>;
    document['items']['plan'] = {
      for (final key in plan.keys.toList().reversed) key: plan[key],
    };
    file.writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert(document),
    );
    expect(builder.drift(output), isEmpty);
  });

  test('unsafe paths reject the whole write before stale-file deletion', () {
    final output = builder.derive();
    _register(builder, output);
    _write(
      builder.outputRoot,
      'templates/agent/stale.txt',
      'preserve on failure',
    );
    for (final path in [
      '../escape',
      '/tmp/escape',
      r'C:\escape',
      'templates/agent/../theme/escape',
      'templates/theme/escape',
      'templates/agentish/escape',
    ]) {
      final forged = PresetOutput(
        files: {...output.files, path: 'bad'},
        sourceByTemplate: output.sourceByTemplate,
      );
      final before = _snapshot(builder.outputRoot);
      expect(() => builder.write(forged), throwsFormatException, reason: path);
      expect(_snapshot(builder.outputRoot), before);
    }
  });

  test(
    'linked ownership root and nested links cannot escape pruning or writes',
    () {
      final output = builder.derive();
      _register(builder, output);
      final outside = Directory('${sandbox.path}/outside')..createSync();
      _write(outside, 'keep.txt', 'untouched');
      Directory('${builder.outputRoot.path}/templates').createSync();
      final rootLink = Link('${builder.outputRoot.path}/templates/agent')
        ..createSync(outside.path);
      expect(() => builder.write(output), throwsFormatException);
      expect(() => builder.drift(output), throwsFormatException);
      rootLink.deleteSync();
      Directory('${builder.outputRoot.path}/templates/agent').createSync();
      Link(
        '${builder.outputRoot.path}/templates/agent/nested',
      ).createSync(outside.path);
      expect(() => builder.write(output), throwsFormatException);
      expect(File('${outside.path}/keep.txt').readAsStringSync(), 'untouched');
    },
  );

  test('relative imports between shared directories become dependencies', () {
    final file = File(
      '${builder.sourceRoot.path}/support/functional_glyph.dart',
    );
    file.writeAsStringSync(
      "import '../models/statuses.dart';\n${file.readAsStringSync()}",
    );
    final items = _items(builder.derive().files['registry.yaml']!);
    expect(items['support']['registryDependencies'], ['theme', 'models']);
  });

  test(
    'missing relative sources and prefix-sensitive URIs fail derivation',
    () {
      final file = File('${builder.sourceRoot.path}/models/statuses.dart');
      final original = file.readAsStringSync();
      file.writeAsStringSync("import 'missing.dart';\n$original");
      expect(builder.derive, throwsFormatException);
      file.writeAsStringSync(
        "export 'package:unrelated/agent.dart';\n$original",
      );
      expect(builder.derive, throwsFormatException);
    },
  );

  test(
    'shared dependency cycles and existing target collisions are rejected',
    () {
      final models = File('${builder.sourceRoot.path}/models/statuses.dart');
      final support = File(
        '${builder.sourceRoot.path}/support/functional_glyph.dart',
      );
      final original = models.readAsStringSync();
      models.writeAsStringSync(
        "import '../support/functional_glyph.dart';\n$original",
      );
      support.writeAsStringSync(
        "import '../models/statuses.dart';\n${support.readAsStringSync()}",
      );
      expect(builder.derive, throwsFormatException);
      models.writeAsStringSync(original);
      final registry = File('${builder.outputRoot.path}/registry.yaml');
      final document = loadYaml(registry.readAsStringSync()) as Map;
      final items = {...document['items'] as Map};
      items['collision'] = {
        'files': [
          {
            'source': 'templates/collision.dart.tmpl',
            'target': '@ui/components/composer.dart',
          },
        ],
      };
      registry.writeAsStringSync(jsonEncode({'schema': 1, 'items': items}));
      expect(builder.derive, throwsFormatException);
    },
  );

  test('an existing non-owned item name cannot be claimed', () {
    final registry = File('${builder.outputRoot.path}/registry.yaml');
    final items = {
      ..._items(registry.readAsStringSync()),
      'models': {
        'files': [
          {
            'source': 'templates/existing.dart.tmpl',
            'target': '@ui/existing.dart',
          },
        ],
      },
    };
    registry.writeAsStringSync(jsonEncode({'schema': 1, 'items': items}));
    expect(builder.derive, throwsFormatException);
  });
}

Map _items(String registry) => (loadYaml(registry) as Map)['items'] as Map;

void _register(PresetBuilder builder, PresetOutput output) {
  final file = File('${builder.outputRoot.path}/registry.yaml');
  file.writeAsStringSync(
    jsonEncode({
      'schema': 1,
      'items': {
        ..._items(file.readAsStringSync()),
        ..._items(output.files['registry.yaml']!),
      },
    }),
  );
}

void _write(Directory root, String relative, String contents) {
  final file = File(p.join(root.path, relative));
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(contents);
}

Map<String, String> _snapshot(Directory root) => {
  for (final file
      in root.listSync(recursive: true, followLinks: false).whereType<File>())
    p.relative(file.path, from: root.path): file.readAsStringSync(),
};
