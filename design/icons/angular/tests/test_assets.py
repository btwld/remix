"""Release-blocking schema, asset, geometry and baseline checks."""
import unittest,json,hashlib,re,io,sys,importlib.util
import xml.etree.ElementTree as ET
from pathlib import Path
from PIL import Image
import cairosvg,jsonschema
from shapely import affinity, maximum_inscribed_circle
from shapely.geometry import Polygon,MultiPolygon
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT))
from tests.geometry.paths import parse_svg,parse_path
from source.angular import additions,baseline
CAT=json.loads((ROOT/'catalog/icons.json').read_text());INV=json.loads((ROOT/'generated/inventory.json').read_text());REG=json.loads((ROOT/'generated/registry.json').read_text())['paths']

class ManifestTests(unittest.TestCase):
    def test_schema(self):
        jsonschema.validate(CAT,json.loads((ROOT/'catalog/schemas/catalog.schema.json').read_text()))
    def test_unique_identity(self):
        ids=[m['id'] for m in CAT['icons']];self.assertEqual(len(ids),len(set(ids)));self.assertEqual(len(ids),48)
        for m in CAT['icons']:
            self.assertRegex(m['id'],r'^[a-z0-9]+(?:-[a-z0-9]+)*$')
            self.assertIn(m['pairModel'],['weight','silhouette'])
            self.assertEqual(m['aliases'],[])
    def test_declared_matrix_matches_files(self):
        expected={f'angular/{m["id"]}' for m in CAT['icons']};self.assertEqual(len(expected),48)
        files={str(p.relative_to(ROOT/'generated')) for p in (ROOT/'generated/angular').rglob('*.svg')}
        actual={r['path'] for r in INV};self.assertEqual(files,actual);self.assertEqual(len(files),288)
        self.assertEqual(len(REG),48);self.assertEqual(CAT['counts'],{'icons':48,'drawings':288})
        for m in CAT['icons']:
            self.assertEqual(m['availability'],{'angular':{'appearances':['outline','filled'],'opticalSizes':[12,16,24]}})
    def test_unavailable_packs_are_not_shipped(self):
        self.assertFalse(CAT['packs']['rounded']['available']);self.assertFalse((ROOT/'generated/rounded').exists())
        self.assertEqual(CAT['status'],'private-pilot-awaiting-signoff');self.assertFalse(CAT['releaseApproval']['publicReleaseApproved'])
    def test_no_true_alias_collision(self):
        self.assertEqual(json.loads((ROOT/'catalog/aliases.json').read_text()),{})
        for k in ['sliders','gear','filter']:self.assertIn(k,REG)
        self.assertNotIn('settings',REG)

class AssetTests(unittest.TestCase):
    def test_baseline_bytes(self):
        frozen=json.loads((ROOT/'tests/fixtures/baseline-sha256.json').read_text());self.assertEqual(len(frozen),198)
        for p,h in frozen.items():
            with self.subTest(path=p):self.assertEqual(hashlib.sha256((ROOT/'generated/angular'/p).read_bytes()).hexdigest(),h)
    def test_xml_geometry_and_hashes(self):
        measurements=[]
        for r in INV:
            with self.subTest(icon=r['id'],a=r['appearance'],n=r['master']):
                data=(ROOT/'generated'/r['path']).read_text();n,d,g=parse_svg(data)
                self.assertEqual(n,r['master']);self.assertEqual(d,REG[r['id']][r['appearance']][str(n)])
                self.assertEqual(hashlib.sha256(data.encode()).hexdigest(),r['sha256'])
                self.assertGreaterEqual(min(g.bounds),0);self.assertLessEqual(max(g.bounds),n)
                parts=list(g.geoms) if isinstance(g,MultiPolygon) else [g]
                holes=[Polygon(h) for p in parts for h in p.interiors]
                measurements.append({'id':r['id'],'appearance':r['appearance'],'master':n,'bounds':[round(v,4) for v in g.bounds],
                    'area':round(g.area,4),'areaFraction':round(g.area/n/n,4),'centroid':[round(g.centroid.x,4),round(g.centroid.y,4)],
                    'components':len(parts),'holes':len(holes),'minimumHoleDiameter':round(min((2*maximum_inscribed_circle(h,tolerance=.001).length for h in holes),default=0),4) or None,
                    'interpretation':'diagnostic, not a visual-quality score'})
        (ROOT/'reports/geometry-measurements.json').write_text(json.dumps(measurements,indent=2)+'\n')
    def test_native_rasters_and_transparency(self):
        for r in INV:
            with self.subTest(path=r['path']):
                txt=(ROOT/'generated'/r['path']).read_text().replace('currentColor','#d90075')
                b=cairosvg.svg2png(bytestring=txt.encode());im=Image.open(io.BytesIO(b)).convert('RGBA');n=r['master']
                self.assertEqual(im.size,(n,n));alpha=im.getchannel('A');self.assertIsNotNone(alpha.getbbox());self.assertEqual(alpha.getpixel((0,0)),0)
                visible=[p for p in im.get_flattened_data() if p[3]>=128];self.assertTrue(visible)
                # Anti-aliasing legitimately produces no fully opaque pixels on micro diagonals.
                self.assertTrue(all(max(abs(x-y) for x,y in zip(p[:3],(217,0,117)))<=2 for p in visible))
                neutral=Image.open(io.BytesIO(cairosvg.svg2png(bytestring=(ROOT/'generated'/r['path']).read_bytes()))).convert('RGBA')
                self.assertEqual(alpha.tobytes(),neutral.getchannel('A').tobytes())
    def test_sprites_match_registry(self):
        ns={'s':'http://www.w3.org/2000/svg'};all_count=0
        for a in ('outline','filled'):
            for n in (12,16,24):
                root=ET.fromstring((ROOT/f'generated/sprites/angular-{a}-{n}.svg').read_text());symbols=root.findall('s:symbol',ns);self.assertEqual(len(symbols),48)
                for s in symbols:
                    prefix='vui-angular-';suffix=f'-{a}-{n}';name=s.attrib['id'][len(prefix):-len(suffix)]
                    self.assertEqual(s.find('s:path',ns).attrib['d'],REG[name][a][str(n)])
                all_count+=len(symbols)
        combined=ET.fromstring((ROOT/'generated/sprites/angular-all.svg').read_text());ids=[s.attrib['id'] for s in combined]
        self.assertEqual(len(ids),288);self.assertEqual(len(set(ids)),288)
    def test_fail_closed_parser(self):
        for d in ['M0 0C1 2 3 4 5 6Z','M0 0Q1 2 3 4Z','M0 0LNaN 2Z','M0 0L1 1','M0 0L0 0L0 0Z','M0 0L1 1Z<script>']:
            with self.subTest(path=d),self.assertRaises(ValueError):parse_path(d)
    def test_svg_safety_rejects_unexpected_content(self):
        base=(ROOT/'generated/angular/outline/24/home.svg').read_text()
        for bad in [base.replace('<path ', '<image href="https://example.invalid/a"/><path '),
                    base.replace('<path ', '<script>alert(1)</script><path '),
                    base.replace('<path ', '<path onclick="x()" '),
                    base.replace('fill="currentColor"','fill="#fff"'),
                    '<!DOCTYPE svg>'+base]:
            with self.assertRaises(ValueError):parse_svg(bad)
    def test_missing_appearance_is_rejected_by_schema(self):
        clone=json.loads(json.dumps(CAT))
        clone['icons'][0]['availability']['angular']['appearances']=['outline']
        with self.assertRaises(jsonschema.ValidationError):jsonschema.validate(clone,json.loads((ROOT/'catalog/schemas/catalog.schema.json').read_text()))
    def test_generated_fingerprints(self):
        h=json.loads((ROOT/'generated-sha256.json').read_text())
        for p,expected in h.items():self.assertEqual(hashlib.sha256((ROOT/p).read_bytes()).hexdigest(),expected,p)

class OpticalInvariants(unittest.TestCase):
    def test_directional_symmetry(self):
        for n in (12,16,24):
            for a in ('outline','filled'):
                g=parse_path(REG['arrow-right'][a][str(n)])
                for id,angle in [('arrow-left',180),('arrow-up',-90),('arrow-down',90)]:
                    h=parse_path(REG[id][a][str(n)]);self.assertLess(g.symmetric_difference(affinity.rotate(h,-angle,origin=(n/2,n/2))).area,.025)
                g=parse_path(REG['chevron-right'][a][str(n)])
                for id,angle in [('chevron-left',180),('chevron-up',-90),('chevron-down',90)]:
                    h=parse_path(REG[id][a][str(n)]);self.assertLess(g.symmetric_difference(affinity.rotate(h,-angle,origin=(n/2,n/2))).area,.025)
    def test_pair_bounds_for_objects(self):
        for m in CAT['icons']:
            if m['pairModel']!='silhouette':continue
            for n in (12,16,24):
                a=parse_path(REG[m['id']]['outline'][str(n)]);b=parse_path(REG[m['id']]['filled'][str(n)])
                with self.subTest(icon=m['id'],n=n):
                    self.assertTrue(all(abs(x-y)<.002 for x,y in zip(a.bounds,b.bounds)))
                    self.assertGreater(b.area,a.area)
    def test_authored_info_help_gaps(self):
        records=[]
        for id in ('info','help'):
            for n in (12,16,24):
                outer,marks=additions.frame_and_mark(id,n);w=baseline.OUTLINE[n];frame=baseline.ring(outer,w)
                # Validate final serialized polygons too; tolerate only decimal export rounding.
                exported=parse_path(REG[id]['outline'][str(n)])
                self.assertLess(exported.symmetric_difference(frame.union(marks)).area,.02)
                self.assertGreaterEqual(frame.distance(marks),w-1e-8)
                p=list(marks.geoms);self.assertGreaterEqual(p[0].distance(p[1]),w-1e-8)
                records.append({'icon':id,'nativeSize':n,'markToFrame':round(frame.distance(marks),5),'target':w,'status':'meets-authored-region-target'})
        (ROOT/'reports/critical-regions.json').write_text(json.dumps(records,indent=2)+'\n')
    def test_new_icons_have_no_tiny_hole_pockets(self):
        for id in additions.NAMES:
            for a in ('outline','filled'):
                for n in (12,16,24):
                    g=parse_path(REG[id][a][str(n)]);parts=list(g.geoms) if isinstance(g,MultiPolygon) else [g]
                    for p in parts:
                        for h in p.interiors:
                            # Minimum inscribed diameter catches subpixel fold pockets,
                            # without treating every pointed corner as a gap violation.
                            dia=2*maximum_inscribed_circle(Polygon(h),tolerance=.0005).length
                            with self.subTest(icon=id,appearance=a,size=n):self.assertGreaterEqual(dia,.9 if n==12 else 1.35 if n==16 else 1.8)

if __name__=='__main__':unittest.main(verbosity=2)
