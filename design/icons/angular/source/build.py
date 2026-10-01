#!/usr/bin/env python3
"""Deterministically build Angular SVGs, sprites, registry and catalog.

Run from the repository root: python source/build.py
Generated files must not be edited by hand.
"""
from __future__ import annotations
import sys, json, hashlib, html, csv, re
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT))
from source.angular import baseline, additions


def svg_text(label: str, appearance: str, n: int, path: str) -> str:
    # Preserve v0.4.1 SVG byte layout for the original 198 files.
    label=html.escape(f'{label} — {appearance}')
    return (f'<svg xmlns="http://www.w3.org/2000/svg" width="{n}" height="{n}" '
            f'viewBox="0 0 {n} {n}" fill="currentColor" fill-rule="evenodd" '
            f'role="img" focusable="false">\n  <title>{label}</title>\n'
            f'  <path d="{path}"/>\n</svg>\n')


def build() -> dict:
    catalog=json.loads((ROOT/'catalog/icons.json').read_text())
    generated=ROOT/'generated'
    paths={}; inventory=[]; all_symbols=[]
    for meta in catalog['icons']:
        id=meta['id'];paths[id]={}
        for a in ('outline','filled'):
            paths[id][a]={}
            for n in (12,16,24):
                g=(additions.draw if id in additions.NAMES else baseline.draw)(id,n,a)
                if not g.is_valid or g.is_empty: raise ValueError(f'Invalid geometry {id}/{a}/{n}')
                path=baseline.path_data(g)
                rel=f'angular/{a}/{n}/{id}.svg'
                file=generated/rel;file.parent.mkdir(parents=True,exist_ok=True)
                txt=svg_text(meta['label'],a,n,path);file.write_text(txt,encoding='utf-8')
                inventory.append({'id':id,'pack':'angular','appearance':a,'master':n,'path':rel,'sha256':hashlib.sha256(txt.encode()).hexdigest()})
                paths[id][a][str(n)]=path
    (generated/'registry.json').write_text(json.dumps({'version':catalog['version'],'paths':paths},indent=2)+'\n')
    sprites=generated/'sprites';sprites.mkdir(exist_ok=True)
    for a in ('outline','filled'):
        for n in (12,16,24):
            syms=[f'<symbol id="vui-angular-{m["id"]}-{a}-{n}" viewBox="0 0 {n} {n}"><path fill="currentColor" fill-rule="evenodd" d="{paths[m["id"]][a][str(n)]}"/></symbol>' for m in catalog['icons']]
            (sprites/f'angular-{a}-{n}.svg').write_text('<svg xmlns="http://www.w3.org/2000/svg">\n'+'\n'.join(syms)+'\n</svg>\n')
            all_symbols.extend(syms)
    (sprites/'angular-all.svg').write_text('<svg xmlns="http://www.w3.org/2000/svg">\n'+'\n'.join(all_symbols)+'\n</svg>\n')
    (generated/'inventory.json').write_text(json.dumps(inventory,indent=2)+'\n')
    with (generated/'inventory.csv').open('w',newline='') as f:
        wr=csv.DictWriter(f,fieldnames=list(inventory[0]));wr.writeheader();wr.writerows(inventory)
    web=ROOT/'packages/web'
    web.mkdir(exist_ok=True)
    (web/'data.mjs').write_text('// GENERATED: do not edit.\nexport const paths = '+json.dumps(paths,separators=(',',':'))+';\nexport const labels = '+json.dumps({m['id']:m['label'] for m in catalog['icons']})+';\n')
    (web/'icons').mkdir(exist_ok=True)
    for meta in catalog['icons']:
        id=meta['id']
        module=("// GENERATED: isolated icon; does not import the full registry.\n"
                "import {renderIcon} from '../render.mjs';\n"
                "export const nativePaths = "+json.dumps(paths[id],separators=(',',':'))+";\n"
                "export default function icon(options = {}) { return renderIcon("+json.dumps(id)+","+json.dumps(meta['label'])+",nativePaths,options); }\n")
        (web/'icons'/f'{id}.mjs').write_text(module)
    from source.restrictions import load_restrictions, write_usage_outputs
    write_usage_outputs(ROOT, catalog, load_restrictions(ROOT))
    from source.build_catalog import build_catalog
    build_catalog(catalog,paths,svg_text)
    # Hash all reproducible products, not test reports or the checksum file itself.
    products=[p for d in [generated,ROOT/'docs/catalog',web] for p in d.rglob('*') if p.is_file()]
    products += [ROOT/'docs/OPTICAL-REVIEW.md', ROOT/'docs/usage-restrictions.md']
    sums={str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(products)}
    (ROOT/'generated-sha256.json').write_text(json.dumps(sums,indent=2)+'\n')
    print(f'Built {len(paths)} icons / {len(inventory)} SVGs / 7 sprites')
    return paths

if __name__=='__main__':build()
