#!/usr/bin/env python3
"""Deterministically build the 12-icon Soft calibration pilot.

Run from the pilot root: python source/build.py
Does not write into design/icons/angular/.
"""
from __future__ import annotations

import csv
import hashlib
import json
import sys
from pathlib import Path

from shapely.geometry import MultiPolygon, Polygon

ROOT = Path(__file__).resolve().parents[1]
REPO = ROOT.parents[2]
sys.path.insert(0, str(ROOT))

from source.draw import draw
from source.lookup import icon_svg
from source.seams import (
    APPEARANCES, CANONICAL_IDS, GAP_TARGET, LABELS, MASTERS, PACK, VERSION,
)
from source.svg import path_data, svg_text
from source.validate import parse_svg

ANGULAR_GENERATED = REPO / 'design' / 'icons' / 'angular' / 'generated' / 'angular'


def _sha(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def _components(g):
    return list(g.geoms) if isinstance(g, MultiPolygon) else [g]


def measure_warning() -> list[dict]:
    records = []
    for n in MASTERS:
        for appearance in APPEARANCES:
            g = draw('warning', n, appearance)
            target = GAP_TARGET[n]
            if appearance == 'outline':
                parts = sorted(_components(g), key=lambda p: p.area, reverse=True)
                frame, marks = parts[0], parts[1:]
                mark_union = marks[0] if len(marks) == 1 else marks[0].union(marks[1]) if marks else None
                gap = float(frame.distance(mark_union)) if mark_union is not None else None
                rule = 'meaningful-mark-to-frame-gap'
            else:
                holes = []
                for p in _components(g):
                    holes.extend(Polygon(h) for h in p.interiors)
                if len(holes) >= 2:
                    gap = float(min(holes[i].distance(holes[j])
                                    for i in range(len(holes)) for j in range(i + 1, len(holes))))
                elif holes:
                    gap = None
                else:
                    gap = None
                # Also record the narrowest hole width via bounds as a diagnostic.
                rule = 'negative-punctuation-separation'
            records.append({
                'id': f'warning-{appearance}-{n}',
                'icon': 'warning',
                'pack': PACK,
                'appearance': appearance,
                'nativeSize': n,
                'target': target,
                'measuredApprox': None if gap is None else round(gap, 4),
                'rule': rule,
                'meetsTarget': gap is not None and gap + 1e-6 >= target,
            })
    return records


def build_catalog_html(catalog: dict, paths: dict, inventory: list[dict]) -> None:
    cards = []
    for meta in catalog['icons']:
        icon_id = meta['id']
        cells = []
        for n in MASTERS:
            for appearance in APPEARANCES:
                svg = (ROOT / 'generated' / PACK / appearance / str(n) / f'{icon_id}.svg').read_text()
                # Scale for inspection without changing native files.
                cells.append(
                    f'<figure class="cell native-{n}"><figcaption>{n} {appearance} · shown 2×</figcaption>'
                    f'<div class="stage s{n}">{svg}</div></figure>'
                )
        compare = ''
        if ANGULAR_GENERATED.is_dir():
            a_out = (ANGULAR_GENERATED / 'outline' / '24' / f'{icon_id}.svg').read_text()
            a_fill = (ANGULAR_GENERATED / 'filled' / '24' / f'{icon_id}.svg').read_text()
            s_out = (ROOT / 'generated' / PACK / 'outline' / '24' / f'{icon_id}.svg').read_text()
            s_fill = (ROOT / 'generated' / PACK / 'filled' / '24' / f'{icon_id}.svg').read_text()
            compare = (
                '<div class="compare">'
                f'<figure><figcaption>Angular 24 outline (frozen, read-only)</figcaption><div class="stage s24">{a_out}</div></figure>'
                f'<figure><figcaption>Soft 24 outline</figcaption><div class="stage s24">{s_out}</div></figure>'
                f'<figure><figcaption>Angular 24 filled (frozen, read-only)</figcaption><div class="stage s24">{a_fill}</div></figure>'
                f'<figure><figcaption>Soft 24 filled</figcaption><div class="stage s24">{s_fill}</div></figure>'
                '</div>'
            )
        cards.append(
            f'<article class="card" id="{icon_id}">'
            f'<header><h2>{meta["label"]}</h2><p class="id">{icon_id} · {meta["pairModel"]}</p></header>'
            f'<p class="meaning">{meta["meaning"]}</p>'
            f'<p class="note">{meta["review"]["note"]}</p>'
            f'<div class="matrix">{"".join(cells)}</div>'
            f'{compare}'
            '</article>'
        )
    html = f'''<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Vector UI Soft calibration pack — 12 icons</title>
<style>
:root {{ --ink:#1b1612; --paper:#f6f1ea; --card:#fffaf4; --line:#d9cfc4; --soft:#c45c26; }}
* {{ box-sizing:border-box; }}
body {{ margin:0; font:15px/1.45 "Liberation Sans", "Noto Sans", sans-serif; background:var(--paper); color:var(--ink); }}
header.hero {{ padding:2.2rem 1.5rem 1rem; max-width:1100px; margin:auto; }}
header.hero h1 {{ font-size:1.8rem; letter-spacing:-0.02em; margin:0 0 .4rem; }}
.meta {{ color:#5c534b; }}
main {{ max-width:1100px; margin:auto; padding:0 1.5rem 4rem; }}
.card {{ background:var(--card); border:1px solid var(--line); border-radius:18px; padding:1.1rem 1.1rem 1.3rem; margin:1.1rem 0; }}
.card h2 {{ margin:0; }}
.card .id {{ margin:.15rem 0 .6rem; color:#6a6158; font-size:.92rem; }}
.matrix {{ display:grid; grid-template-columns:repeat(6,minmax(0,1fr)); gap:.6rem; }}
.cell {{ margin:0; text-align:center; }}
figcaption {{ font-size:.75rem; color:#6a6158; margin-bottom:.25rem; }}
.stage {{ display:grid; place-items:center; background:#fff; border-radius:12px; border:1px solid var(--line); }}
.stage svg {{ color:var(--ink); display:block; }}
.s12 {{ height:64px; }} .s12 svg {{ width:24px; height:24px; }}
.s16 {{ height:72px; }} .s16 svg {{ width:32px; height:32px; }}
.s24 {{ height:88px; }} .s24 svg {{ width:48px; height:48px; }}
.compare {{ display:grid; grid-template-columns:repeat(4,minmax(0,1fr)); gap:.6rem; margin-top:1rem; }}
.compare .stage {{ background:#f3eee7; }}
.banner {{ background:#1b1612; color:#f6f1ea; border-radius:14px; padding:1rem 1.1rem; margin:1rem 0 0; }}
.banner strong {{ color:#ffb089; }}
@media (max-width:800px) {{ .matrix, .compare {{ grid-template-columns:repeat(2,minmax(0,1fr)); }} }}
</style>
</head>
<body>
<header class="hero">
<h1>Vector UI Soft — 12-icon calibration pack</h1>
<p class="meta">{VERSION} · {len(CANONICAL_IDS)} IDs × 2 appearances × 3 masters = {len(inventory)} SVGs · private pilot, not a public pack</p>
<p>Same canonical IDs and meanings as Angular. Soft is a separate grammar (capsule terminals, circular nodes, continuous curvature). Angular drawings below are <strong>read-only snapshots</strong> for comparison; this build does not edit them.</p>
<p>Product files are expanded <code>M L Z</code> polylines: round construction is flattened at quad_segs=8. That is the shipping representation. The validator still accepts <code>C Q A</code> so a curve cannot be ignored; products do not emit native arcs.</p>
<div class="banner"><strong>Warning</strong> requires a visible text label in every appearance and native size, including scaled uses of those masters. A tooltip or accessible name is not a substitute. Branch should keep a visible label at 12 px.</div>
</header>
<main>
{''.join(cards)}
</main>
</body>
</html>
'''
    out = ROOT / 'docs' / 'catalog' / 'index.html'
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(html, encoding='utf-8')


def bind_warning_hashes(inventory: list[dict], exceptions: list[dict]) -> None:
    restrictions = json.loads((ROOT / 'catalog' / 'restrictions.json').read_text())
    by_key = {(r['id'], r['appearance'], r['master']): r['sha256'] for r in inventory}
    for record in restrictions['records']:
        if record['icon'] != 'warning':
            continue
        for n in ('12', '16', '24'):
            for appearance in APPEARANCES:
                cell = record['sizes'][n][appearance]
                cell['geometrySha256'] = by_key[('warning', appearance, int(n))]
                cell['exceptionIds'] = [
                    e['id'] for e in exceptions
                    if e['icon'] == 'warning' and e['appearance'] == appearance and e['nativeSize'] == int(n)
                    and not e['meetsTarget']
                ]
    (ROOT / 'catalog' / 'restrictions.json').write_text(
        json.dumps(restrictions, indent=2) + '\n', encoding='utf-8')


def build() -> dict:
    catalog = json.loads((ROOT / 'catalog' / 'icons.json').read_text())
    generated = ROOT / 'generated' / PACK
    paths: dict = {}
    inventory = []
    for meta in catalog['icons']:
        icon_id = meta['id']
        paths[icon_id] = {}
        for appearance in APPEARANCES:
            paths[icon_id][appearance] = {}
            for n in MASTERS:
                geom = draw(icon_id, n, appearance)
                d = path_data(geom)
                rel = f'{PACK}/{appearance}/{n}/{icon_id}.svg'
                text = svg_text(meta['label'], appearance, n, d)
                file = ROOT / 'generated' / rel
                file.parent.mkdir(parents=True, exist_ok=True)
                file.write_text(text, encoding='utf-8')
                try:
                    parse_svg(text)
                except ValueError as exc:
                    raise ValueError(f'Invalid SVG {rel}: {exc}') from exc
                inventory.append({
                    'id': icon_id,
                    'pack': PACK,
                    'appearance': appearance,
                    'master': n,
                    'path': rel,
                    'sha256': _sha(text.encode()),
                })
                paths[icon_id][appearance][str(n)] = d
    (ROOT / 'generated' / 'registry.json').write_text(
        json.dumps({'version': VERSION, 'pack': PACK, 'paths': paths}, indent=2) + '\n')
    (ROOT / 'generated' / 'inventory.json').write_text(json.dumps(inventory, indent=2) + '\n')
    with (ROOT / 'generated' / 'inventory.csv').open('w', newline='') as f:
        wr = csv.DictWriter(f, fieldnames=list(inventory[0]))
        wr.writeheader()
        wr.writerows(inventory)

    warning_raw = measure_warning()
    exceptions = []
    for rec in warning_raw:
        rec['geometrySha256'] = next(
            r['sha256'] for r in inventory
            if r['id'] == 'warning' and r['appearance'] == rec['appearance'] and r['master'] == rec['nativeSize']
        )
        if not rec['meetsTarget']:
            rec['status'] = 'pilot-exception-needs-design-review'
            rec['permittedUse'] = 'visible-label-required'
            rec['reason'] = (
                'Soft Warning punctuation/frame spacing is below the nominal gap target. '
                'The concept-level visible-label restriction remains in force. Do not treat this as a pass.'
            )
            exceptions.append(rec)
        else:
            rec['status'] = 'meets-gap-target'
    (ROOT / 'catalog' / 'exceptions.json').write_text(json.dumps(exceptions, indent=2) + '\n')
    (ROOT / 'reports' / 'warning-gaps.json').parent.mkdir(parents=True, exist_ok=True)
    (ROOT / 'reports' / 'warning-gaps.json').write_text(json.dumps(warning_raw, indent=2) + '\n')
    bind_warning_hashes(inventory, exceptions)

    build_catalog_html(catalog, paths, inventory)

    products = [
        p for p in (ROOT / 'generated').rglob('*')
        if p.is_file() and p.name != 'sha256.json'
    ]
    products += [ROOT / 'docs' / 'catalog' / 'index.html']
    sums = {str(p.relative_to(ROOT)): _sha(p.read_bytes()) for p in sorted(products)}
    (ROOT / 'generated' / 'sha256.json').write_text(json.dumps(sums, indent=2) + '\n')
    print(f'Built {len(paths)} Soft icons / {len(inventory)} SVGs')
    return paths


if __name__ == '__main__':
    build()
