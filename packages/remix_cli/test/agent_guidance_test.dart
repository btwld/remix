import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:remix_cli/src/agent_guidance.dart';
import 'package:remix_cli/src/skills.dart';
import 'package:test/test.dart';

final _skills = SkillsIndex.parse('''
schema: 1
skills:
  using-remix:
    summary: "Build Flutter UI with Remix"
    files: [SKILL.md]
  building-remix-design-system:
    summary: "Build Remix presets"
    files: [SKILL.md]
''').skills;

final _block = skillsGuidanceBlock(
  directory: '.agents/skills',
  skills: _skills,
);

Matcher _rejects(String message) => throwsA(
  isA<FormatException>().having((error) => error.message, 'message', message),
);

void main() {
  group('skillsGuidanceBlock', () {
    test('names each SKILL.md and the drift check an agent runs', () {
      expect(_block, '''
<!-- remix_cli:skills:start -->
## Remix skills

`remix skills install` wrote this block and the skill directories it lists.
They are copied from the commit pinned for `@remix` in `remix.yaml`, so they
describe the Remix this project installs. Read the matching `SKILL.md` before
you write or review Remix code, and prefer it over what you remember about
Remix, Mix, or Naked UI.

- `.agents/skills/using-remix/SKILL.md`: Build Flutter UI with Remix
- `.agents/skills/building-remix-design-system/SKILL.md`: Build Remix presets

Open a skill's `references/` files only when its `SKILL.md` sends you there.
If `revision` in `remix.skills.json` differs from the `@remix` revision in
`remix.yaml`, run `dart run remix_cli:remix skills install` before relying on
the skills. Do not edit the listed skill directories; that command owns them.
It does not manage other skills under `.agents/skills/`.
<!-- remix_cli:skills:end -->''');
    });

    test('points at the chosen directory', () {
      final block = skillsGuidanceBlock(
        directory: '.claude/skills',
        skills: _skills,
      );
      expect(block, contains('- `.claude/skills/using-remix/SKILL.md`: '));
      expect(block, isNot(contains('.agents/skills')));
    });
  });

  group('updateManagedGuidance', () {
    String update(String source) =>
        updateManagedGuidance(source, _block, path: 'AGENTS.md');

    test('creates the block alone in an empty file', () {
      expect(update(''), '$_block\n');
    });

    test('appends after one blank line and keeps the existing text', () {
      const notes = '# Acme\n\nRun flutter test.\n';
      expect(update(notes), '$notes\n$_block\n');
      expect(update('# Acme'), '# Acme\n\n$_block\n');
      expect(update('# Acme\n\n\n'), '# Acme\n\n$_block\n');
    });

    test('replaces only the block, wherever it is', () {
      const before = '# Acme\n\n';
      const after = '\n\n## Local rules\n\nNever edit *.g.dart.\n';
      final stale =
          '$before$managedSkillsStart\n## Old wording\n$managedSkillsEnd$after';

      expect(update(stale), '$before$_block$after');
    });

    test('keeps CRLF line endings, inside and outside the block', () {
      const notes = '# Acme\r\n\r\nRun flutter test.\r\n';
      final appended = update(notes);
      expect(appended, startsWith(notes));
      expect(appended.replaceAll('\r\n', ''), isNot(contains('\n')));

      final stale =
          '# Acme\r\n$managedSkillsStart\r\nold\r\n$managedSkillsEnd\r\ntail\r\n';
      final replaced = update(stale);
      expect(replaced, startsWith('# Acme\r\n'));
      expect(replaced, endsWith('$managedSkillsEnd\r\ntail\r\n'));
      expect(replaced.replaceAll('\r\n', ''), isNot(contains('\n')));
      expect(replaced.replaceAll('\r\n', '\n'), contains(_block));
    });

    test('is idempotent', () {
      for (final source in ['', '# Acme\n', '# Acme\r\nNotes\r\n']) {
        final once = update(source);
        expect(update(once), once);
      }
    });

    test('rejects a lone, duplicated, or reversed marker', () {
      const message =
          'AGENTS.md must contain one ordered remix_cli:skills marker pair. '
          'Remove the stray marker, then rerun remix skills install.';
      for (final source in [
        '# Acme\n$managedSkillsStart\n',
        '# Acme\n$managedSkillsEnd\n',
        '$managedSkillsStart\n$managedSkillsEnd\n'
            '$managedSkillsStart\n$managedSkillsEnd\n',
        '$managedSkillsEnd\n$managedSkillsStart\n',
      ]) {
        expect(() => update(source), _rejects(message), reason: source);
      }
    });

    test('treats a marker quoted in prose as text', () {
      const notes = 'The CLI owns the `$managedSkillsStart` block.\n';
      expect(update(notes), '$notes\n$_block\n');
    });
  });

  group('GuidancePlan.resolve', () {
    late Directory root;

    setUp(() {
      root = Directory.systemTemp.createTempSync('agent_guidance_');
      addTearDown(() => root.deleteSync(recursive: true));
    });

    File file(String path) => File(p.join(root.path, path));

    test('creates AGENTS.md when no instruction file holds the block', () {
      file('CLAUDE.md').writeAsStringSync('# Claude\n');

      final plan = GuidancePlan.resolve(root, _block);

      expect(plan.path, 'AGENTS.md');
      expect(plan.change, GuidanceChange.created);
      expect(plan.after, '$_block\n');
    });

    test('keeps the block in the file a developer moved it to', () {
      file('AGENTS.md').writeAsStringSync('# Agents\n');
      file('CLAUDE.md').writeAsStringSync('# Claude\n\n$_block\n');

      final plan = GuidancePlan.resolve(root, _block);

      expect(plan.path, 'CLAUDE.md');
      expect(plan.change, GuidanceChange.preserved);
    });

    test('reports a stale block as updated', () {
      file('AGENTS.md').writeAsStringSync(
        '# Agents\n$managedSkillsStart\nold\n$managedSkillsEnd\n',
      );

      final plan = GuidancePlan.resolve(root, _block);

      expect(plan.change, GuidanceChange.updated);
      expect(plan.after, '# Agents\n$_block\n');
    });

    test('rejects markers in two files', () {
      file('AGENTS.md').writeAsStringSync('$_block\n');
      file('.github/copilot-instructions.md')
        ..createSync(recursive: true)
        ..writeAsStringSync('$managedSkillsStart\n');

      expect(
        () => GuidancePlan.resolve(root, _block),
        _rejects(
          'remix_cli:skills markers appear in AGENTS.md and '
          '.github/copilot-instructions.md. Keep the block in one file, then '
          'rerun remix skills install.',
        ),
      );
    });

    test('treats CLAUDE.md linked to AGENTS.md as one file', () {
      file('AGENTS.md').writeAsStringSync('# Agents\n');
      Link(p.join(root.path, 'CLAUDE.md')).createSync('AGENTS.md');

      final plan = GuidancePlan.resolve(root, _block);

      expect(plan.path, 'AGENTS.md');
      expect(plan.change, GuidanceChange.updated);
      expect(plan.claudeImportHint, isFalse);
    });

    test('writes through an AGENTS.md that links to CLAUDE.md', () {
      file('CLAUDE.md').writeAsStringSync('# Claude\n');
      Link(p.join(root.path, 'AGENTS.md')).createSync('CLAUDE.md');

      final plan = GuidancePlan.resolve(root, _block);

      expect(plan.path, 'CLAUDE.md');
      expect(plan.change, GuidanceChange.updated);
    });

    test('ignores markers quoted in other files', () {
      file('AGENTS.md').writeAsStringSync('$_block\n');
      file(
        '.cursorrules',
      ).writeAsStringSync('Never touch $managedSkillsEnd.\n');

      expect(GuidancePlan.resolve(root, _block).path, 'AGENTS.md');
    });

    test('ignores an absent candidate behind a link out of the project', () {
      final outside = Directory.systemTemp.createTempSync('agent_outside_');
      addTearDown(() => outside.deleteSync(recursive: true));
      Link(p.join(root.path, '.github')).createSync(outside.path);

      expect(GuidancePlan.resolve(root, _block).path, 'AGENTS.md');
    });
  });

  group('GuidancePlan.claudeImportHint', () {
    late Directory root;

    setUp(() {
      root = Directory.systemTemp.createTempSync('agent_guidance_');
      addTearDown(() => root.deleteSync(recursive: true));
    });

    bool hint({String? agents, String? claude}) {
      for (final (name, text) in [
        ('AGENTS.md', agents),
        ('CLAUDE.md', claude),
      ]) {
        final file = File(p.join(root.path, name));
        if (text == null) {
          if (file.existsSync()) file.deleteSync();
        } else {
          file.writeAsStringSync(text);
        }
      }
      return GuidancePlan.resolve(root, _block).claudeImportHint;
    }

    test('asks for the import only when CLAUDE.md lacks it', () {
      expect(hint(), isFalse, reason: 'no CLAUDE.md');
      expect(hint(claude: '# Claude\n'), isTrue);
      for (final imports in [
        '# Claude\r\n@AGENTS.md\r\n',
        'Read @AGENTS.md first.\n',
        'See @./AGENTS.md\n',
      ]) {
        expect(hint(claude: imports), isFalse, reason: imports);
      }
    });

    test('stays quiet when the block did not change', () {
      expect(hint(agents: '$_block\n', claude: '# Claude\n'), isFalse);
    });

    test('stays quiet when the block lives in CLAUDE.md', () {
      expect(hint(claude: '$_block\n'), isFalse);
    });
  });
}
