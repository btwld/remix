import 'dart:io';

void main() {
  stderr.writeln(
    'generate_style_docs.dart is disabled: its legacy parser did not support '
    'the Remix 1.0 Styler APIs and could overwrite valid documentation. Update '
    'docs/components manually until a read-only, element-based replacement is '
    'available.',
  );
  exitCode = 64;
}
