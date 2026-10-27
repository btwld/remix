"""Strict expanded-polygon parser for Angular only.

Unknown commands fail closed. This module does NOT claim to validate Rounded.
The independent XML parser checks serialized outputs, not just builder objects.
"""
import re,math
import xml.etree.ElementTree as ET
from shapely.geometry import Polygon,GeometryCollection

TOKEN=re.compile(r'[MLZ]|-?(?:\d+(?:\.\d*)?|\.\d+)')

def parse_path(d):
    if not isinstance(d,str) or not re.fullmatch(r'[MLZ0-9.\-\s]+',d):raise ValueError('Unsupported or unsafe Angular path syntax')
    tokens=TOKEN.findall(d)
    if ''.join(tokens)!=re.sub(r'\s+','',d):raise ValueError('Unparsed path content')
    i=0;g=GeometryCollection();rings=[]
    while i<len(tokens):
        if tokens[i]!='M':raise ValueError('Expected M')
        pts=[];i+=1
        while True:
            if i+1>=len(tokens):raise ValueError('Incomplete point')
            try:x=float(tokens[i]);y=float(tokens[i+1])
            except ValueError as exc:raise ValueError('Expected coordinates') from exc
            if not all(map(math.isfinite,[x,y])):raise ValueError('Non-finite coordinate')
            pts.append((x,y));i+=2
            if i>=len(tokens):raise ValueError('Missing Z')
            command=tokens[i];i+=1
            if command=='Z':break
            if command!='L':raise ValueError('Expected L or Z')
        p=Polygon(pts)
        if not p.is_valid or p.area<=0:raise ValueError('Invalid ring')
        rings.append(p);g=g.symmetric_difference(p)
    if g.is_empty or not g.is_valid:raise ValueError('Empty or invalid final geometry')
    return g


def parse_svg(text):
    """Accept only the standalone expanded Angular SVG export format.

    This is not a general-purpose SVG sanitizer. Unknown presentation, geometry,
    namespace or scripting features are rejected, never silently ignored.
    """
    if not isinstance(text, str) or len(text.encode("utf-8")) > 262144:
        raise ValueError("SVG must be a UTF-8 string under 256 KiB")
    if '<!' in text or '<?' in text:
        raise ValueError('No entities/doctype in icon SVG')
    try:
        parser = ET.XMLParser(target=ET.TreeBuilder(insert_comments=True, insert_pis=True))
        root = ET.fromstring(text, parser=parser)
    except (ET.ParseError, TypeError) as exc:
        raise ValueError('Malformed SVG XML') from exc
    ns = '{http://www.w3.org/2000/svg}'
    if [el.tag for el in root.iter()] != [ns+'svg', ns+'title', ns+'path']:
        raise ValueError('Expected SVG namespace and exact svg/title/path structure')
    allowed = {
        ns+'svg': {'width', 'height', 'viewBox', 'fill', 'fill-rule', 'role', 'focusable'},
        ns+'title': set(),
        ns+'path': {'d'},
    }
    for el in root.iter():
        if set(el.attrib) != allowed[el.tag]:
            raise ValueError('Unexpected or missing attributes on '+el.tag)
        if (el.tag != ns+'title' and (el.text or '').strip()) or (el.tail or '').strip():
            raise ValueError('Unexpected mixed content')
    for key, value in {'fill':'currentColor', 'fill-rule':'evenodd', 'role':'img', 'focusable':'false'}.items():
        if root.get(key) != value:
            raise ValueError('Invalid root attribute value: '+key)
    title, path = list(root)
    if not (title.text or '').strip():
        raise ValueError('Unnamed standalone SVG')
    try:
        vb = [float(v) for v in root.attrib['viewBox'].split()]
    except ValueError as exc:
        raise ValueError('Invalid viewBox') from exc
    valid = next((n for n in (12,16,24) if vb == [0.,0.,n,n]), None)
    if valid is None:
        raise ValueError('Invalid viewBox')
    if root.get('width') != str(valid) or root.get('height') != str(valid):
        raise ValueError('Invalid native size')
    geometry = parse_path(path.attrib['d'])
    if min(geometry.bounds) < 0 or max(geometry.bounds) > valid:
        raise ValueError('Artwork outside the native canvas')
    return valid, path.attrib['d'], geometry
