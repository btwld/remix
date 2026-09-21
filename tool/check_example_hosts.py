"""Keep shipped documentation and examples free of MaterialApp constructors."""
from pathlib import Path
import re
import zipfile

CONSTRUCTOR = re.compile(r'\bMaterialApp(?:\s*\.\s*\w+)?\s*\(')

# Every tree whose Dart, Markdown and template sources a consumer reads or
# installs. `registry_source` is here because it is the authoring source the
# bundled presets derive from: a Material host left there is copied into the
# generated templates and from those into consumer applications.
SCANNED = ['docs', 'skills', 'apps', 'packages', 'open_code', 'registry_source']

# naked_ui is headless: it ships behavior and no design system, so its examples
# have to borrow one and they borrow Material. That is the library's premise
# rather than an oversight -- a Material application is a supported naked_ui
# host, and an example showing that integration is doing its job.
#
# The coupling is also structural, not cosmetic. `Scaffold`, `SnackBar` and
# `TextButton` assert a Material ancestor, so the host cannot be swapped
# without rewriting the surrounding example chrome as well.
#
# This guard exists for source a Remix consumer reads or installs. Nothing
# under these two paths is installed by `remix add`.
EXEMPT = {'apps/naked_ui_example', 'packages/naked_ui'}


def violations(name, text):
    return [f'{name}:{text.count(chr(10), 0, match.start()) + 1}: use WidgetsApp, not a Material app host'
            for match in CONSTRUCTOR.finditer(text)]


def check_hosts(root):
    failures = []
    for directory in SCANNED:
        for path in (root / directory).rglob('*'):
            relative = path.relative_to(root)
            if any(part.startswith('.') or part in {'node_modules', 'build', 'out', 'test', 'integration_test'}
                   for part in relative.parts):
                continue
            if any(str(relative).startswith(f'{exempt}/') for exempt in EXEMPT):
                continue
            if path.suffix not in {'.dart', '.md', '.mdx', '.tmpl'}:
                continue
            failures.extend(violations(str(relative), path.read_text()))
    archive = root / 'docs/assets/remix-cli-tutorial/sample-projects.zip'
    with zipfile.ZipFile(archive) as source:
        for name in source.namelist():
            if name.endswith('.dart') and '/test/' not in name:
                failures.extend(violations(f'{archive.relative_to(root)}!{name}', source.read(name).decode()))
    return failures


if __name__ == '__main__':
    failures = check_hosts(Path(__file__).resolve().parents[1])
    if failures:
        raise SystemExit('\n'.join(failures))
    print('Documentation, generator templates, examples, and tutorial downloads use neutral app hosts.')
