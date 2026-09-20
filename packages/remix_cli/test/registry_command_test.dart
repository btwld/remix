import 'package:remix_cli/src/cli.dart';
import 'package:test/test.dart';

void main() {
  for (final (arguments, action) in [
    (
      [
        'registry',
        'add',
        '@company',
        '--repository',
        'owner/repo',
        '--path',
        'nested/registry',
        '--ref',
        'v1',
      ],
      RegistryAction.add,
    ),
    (['registry', 'update', '@company', '--ref', 'v2'], RegistryAction.update),
    (['registry', 'migrate', '--ref', 'registry-v1'], RegistryAction.migrate),
  ]) {
    test('routes registry ${action.name} options', () async {
      RegistryOptions? received;
      expect(
        await runRemixCli(
          arguments,
          writeOut: (_) {},
          writeError: fail,
          onRegistry: (options) async {
            received = options;
          },
        ),
        successExitCode,
      );
      expect(received!.action, action);
      expect(
        received!.namespace,
        action == RegistryAction.migrate ? null : '@company',
      );
      expect(received!.ref, arguments.last);
      if (action == RegistryAction.add) {
        expect(received!.repository, 'owner/repo');
        expect(received!.path, 'nested/registry');
      }
    });
  }
  for (final arguments in [
    ['registry', 'add', '@company'],
    ['registry', 'update'],
    ['registry', 'migrate', '@company'],
    ['registry', 'update', '@company', '--repository', 'different/repo'],
  ]) {
    test(
      'rejects invalid registry invocation ${arguments.join(' ')}',
      () async {
        expect(
          await runRemixCli(
            arguments,
            writeOut: (_) {},
            writeError: (_) {},
            onRegistry: (_) async {
              fail('invalid options reached handler');
            },
          ),
          usageExitCode,
        );
      },
    );
  }
}
