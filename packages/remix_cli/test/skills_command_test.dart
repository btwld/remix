import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:remix_cli/src/agent_guidance.dart';
import 'package:remix_cli/src/cli.dart';
import 'package:remix_cli/src/installer.dart';
import 'package:remix_cli/src/registry_reader.dart';
import 'package:remix_cli/src/registry_source.dart';
import 'package:remix_cli/src/skills.dart';
import 'package:test/test.dart';

import 'checkout_registry.dart';
import 'test_support.dart';

final _pin = RegistrySource(
  repository: officialRepository,
  path: 'registry',
  ref: 'registry-stable',
  revision: 'b' * 40,
);

final _index = SkillsIndex.parse('''
schema: 1
skills:
  using-remix:
    summary: "Build Flutter UI with Remix"
    files: [SKILL.md, references/cli.md]
''');

const _pinned = {
  'using-remix/SKILL.md': '# Using Remix\n',
  'using-remix/references/cli.md': '# CLI\n',
};

Matcher _rejects(Object message) => throwsA(
  isA<FormatException>().having((error) => error.message, 'message', message),
);

void main() {
  group('skills install parsing', () {
    Future<(int, List<String>)> parse(
      List<String> arguments, {
      SkillsInstallHandler? onSkillsInstall,
    }) async {
      final errors = <String>[];
      final code = await runRemixCli(
        arguments,
        writeOut: (_) {},
        writeError: errors.add,
        onSkillsInstall:
            onSkillsInstall ?? (_) async => fail('dispatched $arguments'),
      );
      return (code, errors);
    }

    test('passes --dir through, and null when it is absent', () async {
      final received = <String?>[];
      Future<void> record(SkillsInstallOptions options) async =>
          received.add(options.directory);

      expect(
        (await parse(['skills', 'install'], onSkillsInstall: record)).$1,
        successExitCode,
      );
      expect(
        (await parse([
          'skills',
          'install',
          '--dir',
          '.claude/skills',
        ], onSkillsInstall: record)).$1,
        successExitCode,
      );
      expect(received, [null, '.claude/skills']);
    });

    test('rejects bad arguments before dispatch', () async {
      for (final (arguments, message) in [
        (
          ['skills', 'install', 'extra'],
          'skills install accepts no positional arguments.',
        ),
        (
          ['skills', 'install', '--dir', '../shared/skills'],
          '--dir ../shared/skills must be a project-relative directory such '
              'as .agents/skills.',
        ),
        (
          ['skills', 'install', '--dir', '/etc/skills'],
          '--dir /etc/skills must be a project-relative directory such as '
              '.agents/skills.',
        ),
        (
          ['skills', 'install', '--dir', '.claude/skills/'],
          '--dir .claude/skills/ must be a project-relative directory such '
              'as .agents/skills.',
        ),
        (['skills'], 'Missing subcommand for "remix skills".'),
      ]) {
        final (code, errors) = await parse(arguments);
        expect(code, usageExitCode, reason: arguments.join(' '));
        expect(errors.first, message);
      }
    });
  });

  group('remix skills install', () {
    late Directory root;
    late List<String> output;
    late List<String> errors;
    late List<String> progress;
    late RecordingFileWriter writer;

    Future<int> run(
      List<String> arguments, {
      RegistrySources sources = const FixtureOfficialResolver(),
      ProjectFileWriter? fileWriter,
    }) {
      output = [];
      errors = [];
      progress = [];
      writer = RecordingFileWriter(root);
      return runInstallerCli(
        arguments,
        Installer(
          projectRoot: root,
          writeOut: output.add,
          writeProgress: progress.add,
          fileWriter: fileWriter ?? writer,
          sources: sources,
        ),
        writeOut: output.add,
        writeError: errors.add,
      );
    }

    File file(String path) => File(p.join(root.path, path));

    /// Moves the project's @remix pin, as `registry update @remix` would.
    void pinTo(String revision) {
      final config = file('remix.yaml');
      config.writeAsStringSync(
        config.readAsStringSync().replaceAll(
          RegExp(r'"[0-9a-f]{40}"'),
          '"$revision"',
        ),
      );
    }

    setUp(() async {
      root = createFlutterPackage();
      addTearDown(() => root.deleteSync(recursive: true));
      expect(await run(['init']), successExitCode);
    });

    test('first run copies the checkout skills at the pin', () async {
      final checkout = findCheckoutRegistry().parent.path;
      final index = SkillsIndex.parse(
        File(p.join(checkout, skillsIndexPath)).readAsStringSync(),
      );

      expect(
        await run(['skills', 'install']),
        successExitCode,
        reason: '$errors',
      );

      expect(progress, ['Fetching Remix skills at ${'a' * 40}...']);
      expect(output, [
        '@remix skills revision ${'a' * 40}',
        'Added using-remix.',
        'Added building-remix-design-system.',
        'Created AGENTS.md.',
        'Commit .agents/skills, AGENTS.md, and remix.skills.json so every '
            'agent on the project reads the same skills.',
      ]);
      for (final skill in index.skills) {
        for (final name in skill.files) {
          expect(
            file('.agents/skills/${skill.name}/$name').readAsStringSync(),
            File(
              p.join(checkout, skillRepositoryPath(skill.name, name)),
            ).readAsStringSync(),
            reason: '${skill.name}/$name',
          );
        }
      }
      expect(
        Directory(
          p.join(root.path, '.agents/skills/using-remix/evals'),
        ).existsSync(),
        isFalse,
      );
      expect(
        file('AGENTS.md').readAsStringSync(),
        '${skillsGuidanceBlock(directory: '.agents/skills', skills: index.skills)}\n',
      );
      final record = SkillsRecord.read(root)!;
      expect(record.revision, 'a' * 40);
      expect(record.directory, '.agents/skills');
      expect(writer.paths.last, skillsRecordFileName);
    });

    test('a rerun writes nothing and says so', () async {
      expect(await run(['skills', 'install']), successExitCode);
      final before = snapshotFiles(root);

      expect(await run(['skills', 'install']), successExitCode);

      expect(writer.paths, isEmpty);
      expect(writer.deleted, isEmpty);
      expect(snapshotFiles(root), before);
      expect(output, [
        '@remix skills revision ${'a' * 40}',
        'Preserved using-remix.',
        'Preserved building-remix-design-system.',
        'Preserved AGENTS.md.',
      ]);
    });

    test('a pin move updates changed skills and the receipt only', () async {
      final sources = _MemorySkills({
        'a' * 40: _published({
          'using-remix/SKILL.md': '# Using Remix v1\n',
          'other/SKILL.md': '# Other\n',
        }),
        'c' * 40: _published({
          'using-remix/SKILL.md': '# Using Remix v2\n',
          'other/SKILL.md': '# Other\n',
        }),
      });
      expect(
        await run(['skills', 'install'], sources: sources),
        successExitCode,
      );
      final agents = file('AGENTS.md').readAsStringSync();
      pinTo('c' * 40);

      expect(
        await run(['skills', 'install'], sources: sources),
        successExitCode,
      );

      expect(output, [
        '@remix skills revision ${'c' * 40}',
        'Updated using-remix.',
        'Preserved other.',
        'Preserved AGENTS.md.',
        'Commit .agents/skills, AGENTS.md, and remix.skills.json so every '
            'agent on the project reads the same skills.',
      ]);
      expect(writer.paths, [
        '.agents/skills/using-remix/SKILL.md',
        skillsRecordFileName,
      ]);
      expect(
        file('.agents/skills/using-remix/SKILL.md').readAsStringSync(),
        '# Using Remix v2\n',
      );
      expect(file('AGENTS.md').readAsStringSync(), agents);
      expect(SkillsRecord.read(root)!.revision, 'c' * 40);
    });

    test(
      'an edited file stops the run until it is restored or deleted',
      () async {
        expect(await run(['skills', 'install']), successExitCode);
        final edited = file('.agents/skills/using-remix/SKILL.md');
        final pinned = edited.readAsStringSync();
        edited.writeAsStringSync(
          'our team uses AcmeButton\n',
          mode: FileMode.append,
        );
        final before = snapshotFiles(root);

        expect(await run(['skills', 'install']), failureExitCode);

        expect(errors, [
          'These vendored skill files changed since remix skills install wrote '
              'them, or were not written by it:\n'
              '  .agents/skills/using-remix/SKILL.md\n'
              'Restore or delete them, then rerun remix skills install. Keep '
              'project notes outside the skills directory.',
        ]);
        expect(output, isEmpty);
        expect(snapshotFiles(root), before);

        edited.deleteSync();
        expect(await run(['skills', 'install']), successExitCode);
        expect(edited.readAsStringSync(), pinned);
        expect(output, contains('Updated using-remix.'));
      },
    );

    test(
      'a file the pin dropped is deleted with its empty directory',
      () async {
        final sources = _MemorySkills({
          'a' * 40: _published({
            'using-remix/SKILL.md': '# Using Remix\n',
            'using-remix/references/forms.md': '# Forms\n',
          }),
          'c' * 40: _published({'using-remix/SKILL.md': '# Using Remix\n'}),
        });
        expect(
          await run(['skills', 'install'], sources: sources),
          successExitCode,
        );
        pinTo('c' * 40);

        expect(
          await run(['skills', 'install'], sources: sources),
          successExitCode,
        );

        expect(writer.deleted, [
          '.agents/skills/using-remix/references/forms.md',
        ]);
        expect(
          Directory(
            p.join(root.path, '.agents/skills/using-remix/references'),
          ).existsSync(),
          isFalse,
        );
        expect(
          file('.agents/skills/using-remix/SKILL.md').existsSync(),
          isTrue,
        );
        expect(output, contains('Updated using-remix.'));
        expect(SkillsRecord.read(root)!.files.keys, ['using-remix/SKILL.md']);
      },
    );

    test('--dir moves the copy, and later runs remember it', () async {
      expect(await run(['skills', 'install']), successExitCode);

      expect(
        await run(['skills', 'install', '--dir', '.claude/skills']),
        successExitCode,
      );

      expect(Directory(p.join(root.path, '.agents')).existsSync(), isFalse);
      expect(file('.claude/skills/using-remix/SKILL.md').existsSync(), isTrue);
      expect(
        file('AGENTS.md').readAsStringSync(),
        contains('`.claude/skills/using-remix/SKILL.md`'),
      );
      expect(
        file('AGENTS.md').readAsStringSync(),
        isNot(contains('.agents/skills')),
      );
      expect(output, [
        '@remix skills revision ${'a' * 40}',
        'Added using-remix.',
        'Added building-remix-design-system.',
        'Removed the previous copy in .agents/skills.',
        'Updated AGENTS.md.',
        'Commit .claude/skills, AGENTS.md, and remix.skills.json so every '
            'agent on the project reads the same skills.',
      ]);

      expect(await run(['skills', 'install']), successExitCode);
      expect(writer.paths, isEmpty);
      expect(SkillsRecord.read(root)!.directory, '.claude/skills');
    });

    test('a pin that predates skills fails without writing', () async {
      final before = snapshotFiles(root);

      expect(
        await run(['skills', 'install'], sources: _MemorySkills({})),
        failureExitCode,
      );

      expect(errors, [
        'btwld/remix publishes no skills at the @remix pin ${'a' * 40} (no '
            'skills/index.yaml). Move the pin with remix registry update '
            '@remix, then rerun remix skills install.',
      ]);
      expect(snapshotFiles(root), before);
    });

    test('a manifest entry missing at the pin fails without writing', () async {
      final published = _published({
        'using-remix/SKILL.md': '# Using Remix\n',
        'using-remix/references/cli.md': '# CLI\n',
      })..remove('skills/using-remix/references/cli.md');
      final before = snapshotFiles(root);

      expect(
        await run([
          'skills',
          'install',
        ], sources: _MemorySkills({'a' * 40: published})),
        failureExitCode,
      );

      expect(errors, [
        'skills/index.yaml lists skills/using-remix/references/cli.md, which '
            'btwld/remix does not have at ${'a' * 40}. Report it at '
            'https://github.com/btwld/remix/issues.',
      ]);
      expect(snapshotFiles(root), before);
    });

    test('needs remix init first', () async {
      file('remix.yaml').deleteSync();
      final before = snapshotFiles(root);

      expect(await run(['skills', 'install']), failureExitCode);

      expect(errors, ['Run remix init before remix skills install.']);
      expect(snapshotFiles(root), before);
    });

    test(
      'a stray marker in AGENTS.md stops the run before any write',
      () async {
        file('AGENTS.md').writeAsStringSync('# Acme\n$managedSkillsEnd\n');
        final before = snapshotFiles(root);

        expect(await run(['skills', 'install']), failureExitCode);

        expect(errors.single, startsWith('AGENTS.md must contain one ordered'));
        expect(snapshotFiles(root), before);
      },
    );

    test('appends to an existing AGENTS.md and hints at CLAUDE.md', () async {
      file('AGENTS.md').writeAsStringSync('# Acme\n\nRun flutter test.\n');
      file('CLAUDE.md').writeAsStringSync('# Claude\n');

      expect(await run(['skills', 'install']), successExitCode);

      expect(
        file('AGENTS.md').readAsStringSync(),
        startsWith('# Acme\n\nRun flutter test.\n\n$managedSkillsStart\n'),
      );
      expect(file('CLAUDE.md').readAsStringSync(), '# Claude\n');
      expect(output, contains('Updated AGENTS.md.'));
      expect(
        output,
        contains(
          'Claude Code reads CLAUDE.md. Add the line @AGENTS.md to it so the '
          'block applies there.',
        ),
      );
    });

    test('a run that stops partway converges on a rerun', () async {
      final sources = _MemorySkills({
        'a' * 40: _published({
          'using-remix/SKILL.md': '# v1\n',
          'using-remix/references/cli.md': '# CLI v1\n',
        }),
        'c' * 40: _published({
          'using-remix/SKILL.md': '# v2\n',
          'using-remix/references/cli.md': '# CLI v2\n',
        }),
      });
      expect(
        await run(['skills', 'install'], sources: sources),
        successExitCode,
      );
      pinTo('c' * 40);

      expect(
        await run(
          ['skills', 'install'],
          sources: sources,
          fileWriter: _FailingWriter(failOn: 2),
        ),
        failureExitCode,
      );
      expect(
        errors.single,
        endsWith(
          'Rerun remix skills install. It continues from the files already '
          'written.',
        ),
      );
      expect(SkillsRecord.read(root)!.revision, 'a' * 40);

      expect(
        await run(['skills', 'install'], sources: sources),
        successExitCode,
      );
      expect(
        file('.agents/skills/using-remix/SKILL.md').readAsStringSync(),
        '# v2\n',
      );
      expect(
        file('.agents/skills/using-remix/references/cli.md').readAsStringSync(),
        '# CLI v2\n',
      );
      expect(SkillsRecord.read(root)!.revision, 'c' * 40);
    });

    test('registry update says when vendored skills fall behind', () async {
      final sources = _MemorySkills({
        'c' * 40: _published({'using-remix/SKILL.md': '# Using Remix\n'}),
      });
      pinTo('c' * 40);
      expect(
        await run(['skills', 'install'], sources: sources),
        successExitCode,
      );

      expect(await run(['registry', 'update', '@remix']), successExitCode);
      expect(output, [
        '@remix pinned to ${'a' * 40}. Installed source was not changed.',
        'Review an installed item next: remix add @remix/<item> --diff',
        'Update the vendored skills next: remix skills install',
      ]);
    });

    test('registry update stays quiet when skills match the new pin', () async {
      expect(await run(['registry', 'update', '@remix']), successExitCode);
      expect(output, hasLength(2), reason: 'no receipt yet');

      expect(await run(['skills', 'install']), successExitCode);
      expect(await run(['registry', 'update', '@remix']), successExitCode);
      expect(output, hasLength(2), reason: 'the receipt matches the pin');
    });
  });

  group('SkillsIndex.parse', () {
    test('rejects names and paths that could leave the skills directory', () {
      for (final (source, message) in [
        (
          'schema: 1\nskills:\n  ../x:\n    summary: s\n    files: [SKILL.md]\n',
          contains('invalid skill name ../x'),
        ),
        (
          'schema: 1\nskills:\n  a:\n    summary: s\n'
              '    files: [SKILL.md, ../../pubspec.yaml]\n',
          contains('without traversal'),
        ),
        (
          'schema: 1\nskills:\n  a:\n    summary: s\n    files: [/etc/passwd]\n',
          contains('without traversal'),
        ),
      ]) {
        expect(() => SkillsIndex.parse(source), _rejects(message));
      }
    });

    test('names the field that is wrong', () {
      for (final (source, message) in [
        (
          'schema: 2\nskills: {}\n',
          'Unsupported skills index schema; expected schema 1. Upgrade '
              'remix_cli to read this pin.',
        ),
        ('schema: 1\nskills: {}\n', 'skills index lists no skills.'),
        (
          'schema: 1\nskills:\n  a:\n    summary: s\n    files: [README.md]\n',
          'skills.a.files must include SKILL.md.',
        ),
        (
          'schema: 1\nskills:\n  a:\n    summary: s\n'
              '    files: [SKILL.md, SKILL.md]\n',
          'skills.a.files lists SKILL.md more than once.',
        ),
        (
          'schema: 1\nskills:\n  a:\n    summary: "one\\ntwo"\n'
              '    files: [SKILL.md]\n',
          'skills.a.summary must be one line.',
        ),
        (
          'schema: 1\nskills:\n  a:\n    files: [SKILL.md]\n',
          'skills.a is missing summary.',
        ),
      ]) {
        expect(() => SkillsIndex.parse(source), _rejects(message));
      }
    });
  });

  group('SkillsRecord', () {
    late Directory root;

    setUp(() {
      root = Directory.systemTemp.createTempSync('skills_record_');
      addTearDown(() => root.deleteSync(recursive: true));
    });

    test('reads back what it encodes, byte for byte', () {
      final record = SkillsRecord(
        directory: '.claude/skills',
        repository: officialRepository,
        revision: 'b' * 40,
        files: {
          'using-remix/references/cli.md': skillFileDigest('# CLI\n'),
          'using-remix/SKILL.md': skillFileDigest('# Using Remix\n'),
        },
      );
      File(
        p.join(root.path, skillsRecordFileName),
      ).writeAsStringSync(record.encode());

      final read = SkillsRecord.read(root)!;

      expect(read.encode(), record.encode());
      expect(read.directory, '.claude/skills');
      expect(record.encode(), endsWith('}\n'));
      expect(
        record.encode().indexOf('using-remix/SKILL.md'),
        lessThan(record.encode().indexOf('using-remix/references/cli.md')),
      );
    });

    test('is absent before the first install', () {
      expect(SkillsRecord.read(root), isNull);
    });

    test('says to restore a damaged receipt', () {
      for (final contents in [
        '{',
        '{"schema": 1}',
        '{"schema": 1, "directory": "../up", "repository": "btwld/remix", '
            '"revision": "${'b' * 40}", "files": {}}',
        '{"schema": 1, "directory": ".agents/skills", "repository": '
            '"btwld/remix", "revision": "${'b' * 40}", "files": '
            '{"a/SKILL.md": "not-a-digest"}}',
      ]) {
        File(
          p.join(root.path, skillsRecordFileName),
        ).writeAsStringSync(contents);
        expect(
          () => SkillsRecord.read(root),
          _rejects(
            'Unsupported or malformed remix.skills.json. Restore it from '
            'version control.',
          ),
          reason: contents,
        );
      }
    });
  });

  test('skillFileDigest treats a CRLF checkout as the same bytes', () {
    expect(skillFileDigest('a\r\nb\r\n'), skillFileDigest('a\nb\n'));
    expect(skillFileDigest('a\nb\n'), isNot(skillFileDigest('a\nc\n')));
  });

  group('SkillsPlan.resolve', () {
    late Directory root;

    setUp(() {
      root = Directory.systemTemp.createTempSync('skills_plan_');
      addTearDown(() => root.deleteSync(recursive: true));
    });

    void write(String path, String contents) => File(p.join(root.path, path))
      ..createSync(recursive: true)
      ..writeAsStringSync(contents);

    SkillsRecord receipt(
      Map<String, String> files, {
      String directory = '.agents/skills',
    }) => SkillsRecord(
      directory: directory,
      repository: officialRepository,
      revision: 'a' * 40,
      files: {
        for (final MapEntry(:key, :value) in files.entries)
          key: skillFileDigest(value),
      },
    );

    SkillsPlan resolve({
      SkillsRecord? before,
      String directory = '.agents/skills',
    }) => SkillsPlan.resolve(
      root: root,
      directory: directory,
      pin: _pin,
      index: _index,
      contents: _pinned,
      before: before,
    );

    test('writes every missing file and records the pin', () {
      final plan = resolve();

      expect(plan.writes, {
        '.agents/skills/using-remix/SKILL.md': '# Using Remix\n',
        '.agents/skills/using-remix/references/cli.md': '# CLI\n',
      });
      expect(plan.removals, isEmpty);
      expect(plan.changes, {'using-remix': SkillChange.added});
      expect(plan.recordChanged, isTrue);
      expect(plan.record.revision, 'b' * 40);
      expect(plan.record.files, {
        'using-remix/SKILL.md': skillFileDigest('# Using Remix\n'),
        'using-remix/references/cli.md': skillFileDigest('# CLI\n'),
      });
    });

    test('keeps files that already hold the pinned bytes, even as CRLF', () {
      write('.agents/skills/using-remix/SKILL.md', '# Using Remix\r\n');
      write('.agents/skills/using-remix/references/cli.md', '# CLI\n');
      final before = SkillsRecord(
        directory: '.agents/skills',
        repository: officialRepository,
        revision: 'b' * 40,
        files: resolve().record.files,
      );

      final plan = resolve(before: before);

      expect(plan.writes, isEmpty);
      expect(plan.changes, {'using-remix': SkillChange.preserved});
      expect(plan.recordChanged, isFalse);
    });

    test('replaces a file that still holds the previous install', () {
      write('.agents/skills/using-remix/SKILL.md', '# Old\n');
      write('.agents/skills/using-remix/references/cli.md', '# CLI\n');

      final plan = resolve(
        before: receipt({
          'using-remix/SKILL.md': '# Old\n',
          'using-remix/references/cli.md': '# CLI\n',
        }),
      );

      expect(plan.writes, {
        '.agents/skills/using-remix/SKILL.md': '# Using Remix\n',
      });
      expect(plan.changes, {'using-remix': SkillChange.updated});
      expect(plan.recordChanged, isTrue);
    });

    test('stops on an edited or foreign file and names each one', () {
      write('.agents/skills/using-remix/SKILL.md', '# Old\nour notes\n');
      write('.agents/skills/using-remix/references/cli.md', '# Mine\n');

      expect(
        () => resolve(before: receipt({'using-remix/SKILL.md': '# Old\n'})),
        _rejects(
          'These vendored skill files changed since remix skills install '
          'wrote them, or were not written by it:\n'
          '  .agents/skills/using-remix/SKILL.md\n'
          '  .agents/skills/using-remix/references/cli.md\n'
          'Restore or delete them, then rerun remix skills install. Keep '
          'project notes outside the skills directory.',
        ),
      );
    });

    test('removes an untouched file the pin dropped, and only that one', () {
      write('.agents/skills/using-remix/references/forms.md', '# Forms\n');

      final plan = resolve(
        before: receipt({
          'using-remix/references/forms.md': '# Forms\n',
          'using-remix/references/actions.md': '# Already gone\n',
        }),
      );

      expect(plan.removals, ['.agents/skills/using-remix/references/forms.md']);
      expect(plan.record.files.keys, isNot(contains(contains('forms.md'))));
    });

    test('stops instead of removing an edited file the pin dropped', () {
      write('.agents/skills/using-remix/references/forms.md', '# Edited\n');

      expect(
        () => resolve(
          before: receipt({'using-remix/references/forms.md': '# Forms\n'}),
        ),
        _rejects(
          contains('  .agents/skills/using-remix/references/forms.md\n'),
        ),
      );
    });

    test('reports a skill the pin no longer publishes as removed', () {
      write('.agents/skills/old-skill/SKILL.md', '# Old skill\n');

      final plan = resolve(
        before: receipt({'old-skill/SKILL.md': '# Old skill\n'}),
      );

      expect(plan.removals, ['.agents/skills/old-skill/SKILL.md']);
      expect(plan.changes, {
        'using-remix': SkillChange.added,
        'old-skill': SkillChange.removed,
      });
    });

    test('a --dir move removes the old copy and trusts nothing in the new', () {
      write('.agents/skills/using-remix/SKILL.md', '# Using Remix\n');
      write('.agents/skills/using-remix/references/cli.md', '# CLI\n');
      final before = receipt({
        'using-remix/SKILL.md': '# Using Remix\n',
        'using-remix/references/cli.md': '# CLI\n',
      });

      final plan = resolve(before: before, directory: '.claude/skills');

      expect(plan.writes.keys, [
        '.claude/skills/using-remix/SKILL.md',
        '.claude/skills/using-remix/references/cli.md',
      ]);
      expect(plan.removals, [
        '.agents/skills/using-remix/SKILL.md',
        '.agents/skills/using-remix/references/cli.md',
      ]);
      expect(plan.record.directory, '.claude/skills');
    });

    test('the receipt does not vouch for files in a new --dir', () {
      write('.claude/skills/using-remix/SKILL.md', '# Old\n');

      expect(
        () => resolve(
          before: receipt({'using-remix/SKILL.md': '# Old\n'}),
          directory: '.claude/skills',
        ),
        _rejects(contains('  .claude/skills/using-remix/SKILL.md\n')),
      );
    });

    test('refuses a skills directory that links outside the project', () {
      final outside = Directory.systemTemp.createTempSync('skills_outside_');
      addTearDown(() => outside.deleteSync(recursive: true));
      Link(p.join(root.path, '.agents')).createSync(outside.path);

      expect(() => resolve(), _rejects(contains('outside the package root')));
      expect(outside.listSync(), isEmpty);
    });
  });
}

/// A published repository at each revision: `revision` to repository path to
/// text. A revision without `skills/index.yaml` predates skills.
final class _MemorySkills implements RegistrySources {
  const _MemorySkills(this.revisions);

  final Map<String, Map<String, String>> revisions;
  static const _registry = FixtureOfficialResolver();

  @override
  Future<RegistrySource> latestOfficial() => _registry.latestOfficial();

  @override
  Future<RegistrySource> resolve({
    required String repository,
    String path = 'registry',
    String? ref,
  }) => _registry.resolve(repository: repository, path: path, ref: ref);

  @override
  RegistryReader open(RegistrySource pin, String preset) =>
      _registry.open(pin, preset);

  @override
  Future<String?> file(RegistrySource pin, String path) async =>
      revisions[pin.revision]?[path];
}

/// Repository files for [files] (`<skill>/<file>` to text), with the manifest
/// that lists them.
Map<String, String> _published(Map<String, String> files) {
  final bySkill = <String, List<String>>{};
  for (final key in files.keys) {
    final [skill, ...rest] = key.split('/');
    bySkill.putIfAbsent(skill, () => []).add(rest.join('/'));
  }
  return {
    skillsIndexPath: [
      'schema: 1',
      'skills:',
      for (final MapEntry(:key, :value) in bySkill.entries) ...[
        '  $key:',
        '    summary: "The $key skill"',
        '    files: [${value.join(', ')}]',
      ],
    ].join('\n'),
    for (final MapEntry(:key, :value) in files.entries) 'skills/$key': value,
  };
}

/// Fails the [failOn]th write, as a full disk or a locked file would.
final class _FailingWriter implements ProjectFileWriter {
  _FailingWriter({required this.failOn});

  final int failOn;
  var _writes = 0;
  static const _delegate = AtomicProjectFileWriter();

  @override
  void write(File target, String contents) {
    if (++_writes == failOn) {
      throw FileSystemException('No space left on device', target.path);
    }
    _delegate.write(target, contents);
  }

  @override
  void delete(File target, {required Directory within}) =>
      _delegate.delete(target, within: within);
}
