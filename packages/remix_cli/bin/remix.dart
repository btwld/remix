import 'dart:io';

import 'package:remix_cli/src/installer.dart';

Future<void> main(List<String> arguments) async {
  exitCode = await runInstallerCli(
    arguments,
    Installer(
      projectRoot: Directory.current,
      writeOut: stdout.writeln,
      writeProgress: stderr.writeln,
    ),
    writeOut: stdout.writeln,
    writeError: stderr.writeln,
  );
}
