#!/usr/bin/env python3
"""Compare native transparent pixels to a reviewed, committed snapshot set.

--create-baseline is an explicit maintainer action, never invoked in CI. Snapshot
agreement detects changes; it does not establish recognition or good design.
"""
import argparse,json,io,sys
from pathlib import Path
from PIL import Image,ImageChops,ImageStat
import cairosvg,cairocffi
R=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(R))
from tools.evidence import snapshot, write_report

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--create-baseline',action='store_true');args=p.parse_args()
    started=snapshot(R)
    (R/'reports/pixel-regression.json').write_text('{"status":"running"}\n')
    root=R/'tests/fixtures/native-pixels';root.mkdir(parents=True,exist_ok=True)
    inv=json.loads((R/'generated/inventory.json').read_text());fail=[];records=[]
    for row in inv:
        image=Image.open(io.BytesIO(cairosvg.svg2png(bytestring=(R/'generated'/row['path']).read_bytes()))).convert('RGBA')
        name=f'{row["id"]}-{row["appearance"]}-{row["master"]}.png';target=root/name
        if args.create_baseline:image.save(target)
        if not target.exists():fail.append({'file':name,'reason':'missing snapshot'});continue
        old=Image.open(target).convert('RGBA')
        if old.size!=image.size:fail.append({'file':name,'reason':'size mismatch'});continue
        # Color inheritance is tested separately. Here compare alpha geometry;
        # very small renderer-edge noise is tolerated but a shifted edge fails.
        delta=ImageChops.difference(old.getchannel('A'),image.getchannel('A'))
        mean=ImageStat.Stat(delta).mean[0];maximum=delta.getextrema()[1]
        record={'file':name,'meanAlphaDelta':round(mean,6),'maximumAlphaDelta':maximum}
        records.append(record)
        if mean>.5 or maximum>8:fail.append(record)
    extras=set(p.name for p in root.glob('*.png'))-set(r['file'] for r in records)
    if extras:fail.append({'unexpectedSnapshots':sorted(extras)})
    report={'status':'failed' if fail else 'passed','nativeSnapshots':len(records),'createdBaseline':args.create_baseline,'renderer':{'CairoSVG':cairosvg.__version__,'Cairo':cairocffi.cairo_version_string()},'tolerance':{'meanAlphaDeltaMax':.5,'singlePixelAlphaDeltaMax':8,'range':'0–255'},'failures':fail,'scope':'Native-size raster regression, not optical or semantic approval.'}
    if args.create_baseline:
        report['status']='baseline-created'
        started=snapshot(R)  # Baseline creation never qualifies as a validation pass.
    report=write_report(R/'reports/pixel-regression.json',report,started,R)
    print(json.dumps({k:v for k,v in report.items() if k!='evidence'},indent=2));return 1 if report['status']=='failed' else 0
if __name__=='__main__':raise SystemExit(main())
