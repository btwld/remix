"""Check nav/API coverage and analyze every complete Dart example in Naked UI docs.

Run `flutter pub get --enforce-lockfile` first using .fvmrc's SDK. Every block
is either a complete analyzed/frontend-compiled example or an explicit reasoned
reference checked against references.json and active API source bytes.
"""
from pathlib import Path
import re
import json
import hashlib
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
ledger = json.loads((root / 'naked_ui_docs/references.json').read_text())
seen = set()
digest = lambda text: hashlib.sha256(text.encode()).hexdigest()
sdk = Path(shutil.which('flutter')).resolve().parents[1]
for page in sorted(content.rglob('*.mdx')):
    for index, block in enumerate(re.findall(r'```dart[^\n]*\n([\s\S]*?)```', page.read_text())):
        key = str(page.relative_to(content)) + '#' + str(index)
        if not re.search(r"^import ['\"]package:", block, re.M):
            reference = ledger.get(key)
            if not reference or digest(block) != reference['codeSha256']:
                raise ValueError(f'Unaccounted or changed Dart reference: {key}')
            if '{/* dart-excerpt: ' + reference['reason'] + ' */}' not in page.read_text():
                raise ValueError(f'Missing reasoned excerpt marker: {key}')
            source = reference['source']
            source_path = sdk / source.removeprefix('flutter:') if source.startswith('flutter:') else root / source
            if digest(source_path.read_text()) != reference['sourceSha256']:
                raise ValueError(f'API source changed; review reference against active source: {key}')
            seen.add(key)
            references += 1
            continue
        if key in ledger:
            raise ValueError(f'Complete example must compile, not be exempted: {key}')
        block = block.replace("'../src/example_app.dart'", repr((root / 'apps/naked_ui_example/lib/src/example_app.dart').as_uri()))
        name = str(page.relative_to(content)).replace('/', '_').replace('.mdx', '')
        (checks / f'{name}_{index}.dart').write_text(block)
        count += 1
if seen != set(ledger):
    raise ValueError(f'Stale reference ledger entries: {set(ledger) - seen}')
subprocess.run(['dart', 'analyze', '--no-fatal-warnings', str(checks)], cwd=root, check=True)
print(f'Analyzed {count} complete Dart examples; {references} constructor/type reference excerpts remain source-reviewed.')

# The Flutter frontend compiles all imported example libraries against the same
# active workspace package; analysis alone is not the delivery proof.
entry = checks / 'compile.dart'
examples = sorted(checks.glob('*.dart'))
entry.write_text(''.join(f"import '{p.name}' as example{i};\n" for i, p in enumerate(examples)) + 'void main() {}\n')
subprocess.run(['flutter', 'build', 'bundle', '--debug', '--target', str(entry), '--asset-dir', str(root / '.dart_tool/naked-ui-docs-kernel')], cwd=root / 'apps/naked_ui_example', check=True)
print(f'Flutter compiled {count} complete examples against active workspace naked_ui.')
