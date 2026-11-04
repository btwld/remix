"""Check nav/API coverage and analyze every complete Dart example in Naked UI docs.

Run `flutter pub get --enforce-lockfile` first using .fvmrc's SDK. Constructor
signatures and expression fragments are reference excerpts; blocks with imports
are complete compilable examples. Source includes are analyzed too.
"""
from pathlib import Path
import re
import shutil
import subprocess
from prepare_naked_ui_docs import prepare

root = Path(__file__).resolve().parents[1]
content = prepare(root, root / '.dart_tool/naked-ui-site')
checks = root / '.dart_tool/naked-ui-docs-check'
if checks.exists():
    shutil.rmtree(checks)
checks.mkdir(parents=True)
count = 0
references = 0
for page in sorted(content.rglob('*.mdx')):
    for index, block in enumerate(re.findall(r'```dart[^\n]*\n([\s\S]*?)```', page.read_text())):
        if not re.search(r"^import ['\"]package:", block, re.M):
            if not re.match(r'\s*(?:const \w+(?:<[^>]+>)?\(\{|Future<T\?> showNaked\w+<T>\(\{|class NakedDialog |typedef NakedTextFieldBuilder)', block):
                raise ValueError(f'Unverified Dart example: {page} block {index}')
            references += 1
            continue
        block = block.replace("'../src/example_app.dart'", repr((root / 'apps/naked_ui_example/lib/src/example_app.dart').as_uri()))
        name = str(page.relative_to(content)).replace('/', '_').replace('.mdx', '')
        (checks / f'{name}_{index}.dart').write_text(block)
        count += 1
subprocess.run(['dart', 'analyze', '--no-fatal-warnings', str(checks)], cwd=root, check=True)
print(f'Analyzed {count} complete Dart examples; {references} constructor/type reference excerpts remain source-reviewed.')

# The Flutter frontend compiles all imported example libraries against the same
# active workspace package; analysis alone is not the delivery proof.
entry = checks / 'compile.dart'
examples = sorted(checks.glob('*.dart'))
entry.write_text(''.join(f"import '{p.name}' as example{i};\n" for i, p in enumerate(examples)) + 'void main() {}\n')
subprocess.run(['flutter', 'build', 'bundle', '--debug', '--target', str(entry), '--asset-dir', str(root / '.dart_tool/naked-ui-docs-kernel')], cwd=root / 'apps/naked_ui_example', check=True)
print(f'Flutter compiled {count} complete examples against active workspace naked_ui.')
