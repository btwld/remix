"""Stage the independent Naked UI docs snapshot without changing Remix's docs app.

Usage: python3 tool/prepare_naked_ui_docs.py [output-directory]
Only the selected output is generated; naked_ui_docs/ remains canonical.
"""
import json
from pathlib import Path
import re
import shutil
import sys

SOURCE = re.compile(r'<NakedSource file="([a-z0-9_.]+\.dart)"\s*/>')


def prepare(root, output):
    docs = root / 'naked_ui_docs'
    navigation = json.loads((docs / 'navigation.json').read_text())
    pages = {str(p.relative_to(docs))[:-4] for p in docs.rglob('*.mdx')}
    linked = {p['href'].strip('/') or 'index'
              for g in navigation['sidebar'] for p in g['pages']}
    if pages != linked:
        raise ValueError(f'Navigation coverage differs: missing={pages-linked}, unknown={linked-pages}')
    content = output / 'content'
    if content.exists():
        shutil.rmtree(content)
    content.mkdir(parents=True)
    for path in sorted(docs.rglob('*.mdx')):
        def expand(match):
            source = root / 'apps/naked_ui_example/lib/api' / match[1]
            return f'```dart title="apps/naked_ui_example/lib/api/{match[1]}"\n{source.read_text().rstrip()}\n```'
        text = SOURCE.sub(expand, path.read_text())
        if '<NakedSource' in text:
            raise ValueError(f'Unsupported source include: {path}')
        if re.search(r'\b(?:targetAnchor|followerAnchor)\s*:|\bwidgetStates\b', text):
            raise ValueError(f'Retired API in {path}')
        target = content / path.relative_to(docs)
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(text)
    meta = []
    for group in navigation['sidebar']:
        meta.append(f"---{group['group']}---")
        meta.extend(f"[{p['title']}]({p['href']})" for p in group['pages'])
    (content / 'meta.json').write_text(json.dumps({'pages': meta}, indent=2) + '\n')
    shutil.copyfile(docs / 'LICENSE', output / 'LICENSE')
    shutil.copyfile(docs / 'SOURCES.json', output / 'SOURCES.json')
    print(f'Staged {len(pages)} canonical Naked UI pages.')
    return content


if __name__ == '__main__':
    root = Path(__file__).resolve().parents[1]
    output = Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else root / '.dart_tool/naked-ui-site'
    prepare(root, output)
