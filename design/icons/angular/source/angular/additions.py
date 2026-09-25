"""Authored Angular pilot drawings. No external artwork or font glyphs.

Arrows and chevrons are intentional directional variants. Dimensions listed for
other symbols are native optical decisions; the export never scales a finished
24 px SVG down to manufacture a 12 or 16 px master.
"""
from __future__ import annotations
import math
from shapely import affinity
from shapely.geometry import box
from .baseline import P, U, line, ring, octagon, draw as baseline_draw, OUTLINE, BOLD

NAMES = ('arrow-left','arrow-up','arrow-down','chevron-left','chevron-right',
         'chevron-up','chevron-down','minus','edit','save','refresh','filter','gear','info','help')


def frame_and_mark(name: str, n: int):
    """Inspectable frame and punctuation for critical-region spacing checks."""
    p,cut={12:(1,2),16:(1.5,3),24:(2,4)}[n]
    outer=octagon(p,p,n-p,n-p,cut)
    w=OUTLINE[n]
    if name=='info':
        if n==12:
            marks=U(box(5,3,6,4),box(5,6,6,9))
        elif n==16:
            marks=U(box(7.25,4.5,8.75,6),box(7.25,8,8.75,11.5))
        else:
            marks=U(box(11,6,13,8),box(11,11,13,17))
    elif name=='help':
        if n==12:
            hook=line([(3.75,4.5),(3.75,4.25),(4.5,3.5),(6.5,3.5),(7.5,4.5),(7.5,5),(5.5,6.5)],1)
            dot=box(5,8,6,9)
        elif n==16:
            hook=line([(5.5,7),(5.5,6.5),(7,5.25),(9,5.25),(10.25,6.25),(10.25,6.75),(8,7.5)],1.5)
            dot=box(7.25,10,8.75,11.5)
        else:
            hook=line([(8,9),(8,8),(10,7),(14,7),(16,9),(16,10),(12,12.5),(12,13)],2)
            dot=box(11,16,13,18)
        marks=U(hook,dot)
    else:raise KeyError(name)
    return outer,marks


def gear_shape(n: int):
    # Eight teeth with broad valleys. Use axis-aligned tooth faces. The shape
    # is an octagonal root with eight rectangular radial extensions.
    c=n/2
    root,tip,half,cut={12:(3.75,5,1,1.5),16:(4.75,6.5,1.25,2),24:(7,9.5,2,3)}[n]
    root_shape=octagon(c-root,c-root,c+root,c+root,cut)
    tooth=box(c-half,c-tip,c+half,c-root+1)
    return U(root_shape,*[affinity.rotate(tooth,k*45,origin=(c,c)) for k in range(8)])


def draw(name: str,n: int,appearance: str):
    if name not in NAMES or n not in (12,16,24) or appearance not in ('outline','filled'):
        raise ValueError(f'Unsupported drawing: {name}/{appearance}/{n}')
    outlined=appearance=='outline'; w=OUTLINE[n]; t=w if outlined else BOLD[n]; c=n/2
    if name in ('arrow-left','arrow-up','arrow-down'):
        base=baseline_draw('arrow-right',n,appearance)
        return affinity.rotate(base,{'arrow-left':180,'arrow-up':-90,'arrow-down':90}[name],origin=(c,c))
    if name.startswith('chevron-'):
        pts={12:[(4,2.5),(7.5,6),(4,9.5)],16:[(5.5,3.5),(10,8),(5.5,12.5)],24:[(8,5),(15,12),(8,19)]}[n]
        shape=line(pts,t)
        return affinity.rotate(shape,{'chevron-right':0,'chevron-left':180,'chevron-up':-90,'chevron-down':90}[name],origin=(c,c))
    if name=='minus':
        p={12:1,16:1.5,24:2}[n]
        if n==12 and outlined:c=5.5
        return box(p,c-t/2,n-p,c+t/2)
    if name=='refresh':
        # Open clockwise cycle; no extra circular frame. All slopes are 45°.
        pts={12:[(10,8),(8,10),(4,10),(2,8),(2,4),(4,2),(7.5,2),(9.5,4)],
             16:[(13,10.5),(10.5,13),(5.5,13),(3,10.5),(3,5.5),(5.5,3),(10,3),(12.5,5.5)],
             24:[(20,16),(16,20),(8,20),(4,16),(4,8),(8,4),(15,4),(19,8)]}[n]
        arrow={12:[(9.5,1),(9.5,4),(6.5,4)],16:[(12.5,1.5),(12.5,5.5),(8.5,5.5)],24:[(19,2),(19,8),(13,8)]}[n]
        return U(line(pts,t),line(arrow,t))
    if name=='edit':
        shaft={12:[(2.5,7),(7,2.5),(9.5,5),(5,9.5),(1.5,10.5)],
               16:[(3.25,9.25),(9.25,3.25),(12.75,6.75),(6.75,12.75),(2,14)],
               24:[(5,14),(14,5),(19,10),(10,19),(3,21)]}[n]
        cap={12:[(8,1.5),(8.5,1),(11,3.5),(10.5,4)],
             16:[(11,2),(12,1),(15,4),(14,5)],
             24:[(16,3),(17,2),(22,7),(21,8)]}[n]
        body=P(shaft)
        # The cap is a solid terminal in both variants, not a tiny hollow box.
        return U(ring(body,w) if outlined else body,P(cap))
    if name=='filter':
        pts={12:[(1.5,2),(10.5,2),(10.5,3.5),(7,7),(7,10),(5,11),(5,7),(1.5,3.5)],
             16:[(2,2.5),(14,2.5),(14,4.5),(9.5,9),(9.5,13),(6.5,14.5),(6.5,9),(2,4.5)],
             24:[(3,4),(21,4),(21,7),(14,14),(14,20),(10,22),(10,14),(3,7)]}[n]
        body=P(pts)
        return ring(body,w) if outlined else body
    if name=='save':
        if n==12:
            outer=P([(1,1),(8,1),(11,4),(11,11),(1,11)])
            header=box(3,1,6,4); label=box(3,7,9,9)
            marks=U(line([(3,1),(3,4),(6,4),(6,1)],1),box(3,7,9,8))
        elif n==16:
            outer=P([(2,2),(11,2),(14,5),(14,14),(2,14)])
            header=box(4.5,2,8.5,6); label=box(5,9,11,12)
            marks=U(line([(4.5,2),(4.5,6),(8.5,6),(8.5,2)],1.5),box(5,9.5,11,11))
        else:
            outer=P([(3,3),(17,3),(21,7),(21,21),(3,21)])
            header=box(7,3,13,9); label=box(7,14,17,18)
            marks=U(line([(7,3),(7,9),(13,9),(13,3)],2),box(7,14,17,16))
        # Header opens at the top in BOTH versions; no hidden white fills.
        body=outer.difference(header)
        outline = U(ring(outer,w),header.buffer(w,join_style=2),marks).difference(header).intersection(outer)
        return outline if outlined else body.difference(label)
    if name=='gear':
        body=gear_shape(n)
        if outlined:
            root,cut={12:(3.75,1.5),16:(4.75,2),24:(7,3)}[n]
            hub=octagon(c-root,c-root,c+root,c+root,cut).buffer(-w,join_style=2)
            return body.difference(hub)
        h,cut={12:(2,1),16:(2.5,1.25),24:(4,2)}[n]
        return body.difference(octagon(c-h,c-h,c+h,c+h,cut))
    if name in ('info','help'):
        outer,marks=frame_and_mark(name,n)
        return U(ring(outer,w),marks) if outlined else outer.difference(marks)
    raise KeyError(name)
