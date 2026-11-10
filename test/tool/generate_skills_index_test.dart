import 'dart:io';

import 'package:remix_cli/src/skills.dart';
import 'package:test/test.dart';

import '../../tool/generate_skills_index.dart';
import '../../tool/install_pins.dart' show publishedSkillDirectories;

void main() {
  test('the committed manifest matches the skill directories', () {
    expect(checkSkillsIndex(Directory.current), isEmpty);
  });

  test('the committed manifest parses with the CLI and names real files', () {
    final index = SkillsIndex.parse(File(skillsIndexPath).readAsStringSync());
    expect(
      index.skills.map((skill) => 'skills/${skill.name}'),
      publishedSkillDirectories,
    );
    for (final skill in index.skills) {
      expect(skill.files.first, 'SKILL.md');
      for (final file in skill.files) {
        expect(
          File(skillRepositoryPath(skill.name, file)).existsSync(),
          isTrue,
        );
        expect(file, isNot(startsWith('evals/')));
      }
    }
  });

  group('a copied workspace', () {
    late Directory workspace;

    setUp(() {
      workspace = Directory.systemTemp.createTempSync('skills_index_');
      addTearDown(() => workspace.deleteSync(recursive: true));
      for (final skillPath in publishedSkillDirectories) {
        _copyDirectory(
          Directory(skillPath),
          Directory('${workspace.path}/$skillPath'),
        );
      }
      File(
        '${workspace.path}/$skillsIndexPath',
      ).writeAsStringSync(renderSkillsIndex(workspace));
    });

    test('passes when freshly rendered', () {
      expect(checkSkillsIndex(workspace), isEmpty);
    });

    test('reports a new reference file as stale', () {
      File(
        '${workspace.path}/skills/using-remix/references/new.md',
      ).writeAsStringSync('# New\n');
      expect(checkSkillsIndex(workspace), [
        contains('skills/index.yaml is stale'),
      ]);
      expect(
        renderSkillsIndex(workspace),
        contains('      - references/new.md\n'),
      );
    });

    test('rejects a skill directory the published list leaves out', () {
      File('${workspace.path}/skills/new-skill/SKILL.md')
        ..createSync(recursive: true)
        ..writeAsStringSync('# New\n');
      expect(checkSkillsIndex(workspace), [
        'skills/new-skill has a SKILL.md but is not in '
            'publishedSkillDirectories in tool/install_pins.dart.',
      ]);
    });

    test('rejects a binary file instead of publishing it', () {
      File(
        '${workspace.path}/skills/using-remix/references/logo.png',
      ).writeAsBytesSync(const [0x89, 0x50, 0x4e, 0x47, 0xff, 0xfe]);
      expect(
        () => renderSkillsIndex(workspace),
        throwsA(
          isA<FormatException>().having(
            (error) => error.message,
            'message',
            contains('references/logo.png is not UTF-8 text'),
          ),
        ),
      );
      expect(checkSkillsIndex(workspace), [contains('logo.png')]);
    });

    test('rejects a skill without a short_description', () {
      File(
        '${workspace.path}/skills/building-remix-design-system/agents/openai.yaml',
      ).writeAsStringSync('interface:\n  display_name: "Building"\n');
      expect(
        () => renderSkillsIndex(workspace),
        throwsA(
          isA<FormatException>().having(
            (error) => error.message,
            'message',
            contains('has no interface.short_description'),
          ),
        ),
      );
    });

    test('rejects a skill without SKILL.md', () {
      File('${workspace.path}/skills/using-remix/SKILL.md').deleteSync();
      expect(
        () => renderSkillsIndex(workspace),
        throwsA(
          isA<FormatException>().having(
            (error) => error.message,
            'message',
            'skills/using-remix has no SKILL.md.',
          ),
        ),
      );
    });

    test('leaves evals out of the manifest', () {
      expect(
        Directory('${workspace.path}/skills/using-remix/evals').existsSync(),
        isTrue,
      );
      expect(renderSkillsIndex(workspace), isNot(contains('evals')));
    });
  });
}

void _copyDirectory(Directory source, Directory target) {
  for (final entity in source.listSync(recursive: true)) {
    if (entity is! File) continue;
    final relative = entity.path.substring(source.path.length + 1);
    File('${target.path}/$relative')
      ..createSync(recursive: true)
      ..writeAsBytesSync(entity.readAsBytesSync());
  }
}
