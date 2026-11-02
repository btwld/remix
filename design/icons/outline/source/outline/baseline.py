#!/usr/bin/env python3
"""Construct matched, expanded-path UI icons. Requires shapely>=2.

The three native sizes have independent spacing/detail decisions. Outline and
filled variants share a silhouette for objects; open action glyphs use a
regular/bold weight pair rather than a hollow contour around a thin line.
"""
from __future__ import annotations
import json, math
from pathlib import Path
from shapely import affinity
from shapely.geometry import Polygon, MultiPolygon, GeometryCollection, LineString, box
from shapely.ops import unary_union

ROOT = Path(__file__).resolve().parent.parent
SIZES = (12,16,24)
OUTLINE = {12:1.0,16:1.5,24:2.0}
BOLD = {12:2.0,16:2.5,24:3.0}
PADDING = {12:1,16:1.5,24:2}

def U(*gs):
    return unary_union([g for g in gs if not g.is_empty])
def P(points):
    g = Polygon(points)
    if not g.is_valid: raise ValueError(f'Invalid polygon {points}')
    return g

def line(points, w):
    return LineString(points).buffer(w/2, cap_style=2, join_style=2)

def ring(poly,w):
    return poly.difference(poly.buffer(-w,join_style=2))

def cutbox(x0,y0,x1,y1,cut=0):
    return P([(x0,y0),(x1,y0),(x1,y1-cut),(x1-cut,y1),(x0,y1)])

def octagon(x0,y0,x1,y1,cut):
    return P([(x0+cut,y0),(x1-cut,y0),(x1,y0+cut),(x1,y1-cut),
              (x1-cut,y1),(x0+cut,y1),(x0,y1-cut),(x0,y0+cut)])

def path_data(g):
    if not g.is_valid: raise ValueError('Invalid output geometry')
    if isinstance(g,Polygon): polys=[g]
    elif isinstance(g,MultiPolygon): polys=list(g.geoms)
    else:
        polys=[p for p in g.geoms if isinstance(p,Polygon)]
    def number(x):
        if abs(x)<0.0005:x=0
        return f'{x:.3f}'.rstrip('0').rstrip('.')
    paths=[]
    for poly in sorted(polys,key=lambda x:(x.bounds[0],x.bounds[1],-x.area)):
        for r in [poly.exterior,*poly.interiors]:
            coords=list(r.coords)[:-1]
            paths.append('M'+'L'.join(f'{number(x)} {number(y)}' for x,y in coords)+'Z')
    return ''.join(paths)

# Names remain compatible with v0.2; Star is the one new metaphor.
INFO = [
 ('arrow-right','Arrow right','Actions','weight','Forward or next. Two exact stroke weights on shared centerlines; painted bounds may differ.'),
 ('arrow-up-right','Arrow up right','Actions','weight','Open externally. Shared diagonal; shorter corner arms and exact native stroke weights.'),
 ('plus','Plus','Actions','weight','Add. Open action glyph: regular and bold, not a hollow cross.'),
 ('close','Close','Actions','weight','Dismiss. Diagonals remain centered in both weights.'),
 ('check','Check','Actions','weight','Confirm. The long rising arm is retained at all sizes.'),
 ('menu','Menu','Actions','weight','Menu. Three bars remain solid; the filled variant has heavier bars.'),
 ('play','Play','Actions','silhouette','Run or play. The outlined triangle retains a real transparent center.'),
 ('pause','Pause','Actions','weight','Pause. Use two solid regular or bold bars, not hollow micro rectangles.'),
 ('home','Home','Navigation','silhouette','Home. Shared roof and doorway; the outline keeps the interior open.'),
 ('search','Search','Navigation','weight','Search. Keep the lens transparent in both styles; filled means a heavier lens and handle.'),
 ('grid','Grid','Navigation','silhouette','Apps or grid view. Four equal cells; removed the isolated corner cut from v0.2.'),
 ('sliders','Sliders','Navigation','silhouette','Adjust. Hollow versus solid handles. Two rails at every size; compact 18 × 16 px footprint at 24 px.'),
 ('folder','Folder','Content','silhouette','Folder. Same tab and clipped corner. Filled has a header slit only at 16/24 px.'),
 ('file','File','Content','silhouette','Document. Clipped corner, no internal fold pocket. Two unequal text lines at 24 px only.'),
 ('download','Download','Actions','weight','Download. A matched arrow and baseline; neither becomes an outlined block shape.'),
 ('upload','Upload','Actions','weight','Upload. Shares the baseline and arrow proportions of Download.'),
 ('user','User','People','silhouette','Profile. Octagonal head and cut shoulders. Both outline counters stay open at 12 px.'),
 ('chat','Chat','People','silhouette','Message. Same tail. Omit the content line in the micro master.'),
 ('bell','Bell','People','silhouette','Notifications. Same bell and separated clapper. No ornamental cuts.'),
 ('lock','Lock','System','silhouette','Lock. Shackle stays open in both styles; filled uses a solid body and negative keyhole.'),
 ('shield','Shield','System','silhouette','Protection. Added a truly solid shield; v0.2 used a thick outline.'),
 ('warning','Warning','System','silhouette','Warning. An overshooting triangle gives the punctuation room to clear the frame. Keep a visible label.'),
 ('focus','Focus','System','weight','Focus region. Four corner brackets and a center square, not a star. Use a label for product-specific actions.'),
 ('branch','Branch','System','silhouette','Branch. Same three-node topology; outlined nodes become filled. Label at small sizes.'),
 ('copy','Copy','Content','silhouette','Copy. Rear sheet stays a partial contour; front sheet changes from outlined to solid.'),
 ('trash','Trash','Content','silhouette','Delete. Lid and bin share placement. Slots appear only where there is enough space.'),
 ('bookmark','Bookmark','Content','silhouette','Save. Same bookmark notch. The interior is open in outline and solid in filled.'),
 ('link','Link','Content','weight','Link. Two open hooks interlock on one diagonal axis in regular and bold; no closed counters to fill in.'),
 ('chart','Chart','System','weight','Analytics. Three regular or bold bars, not tiny hollow columns.'),
 ('calendar','Calendar','Content','silhouette','Calendar. Contour-weight bindings and header rail. One off-center date at 16/24 px; none at 12 px.'),
 ('terminal','Terminal','System','silhouette','Terminal. Square window with an open prompt and cursor; positive in outline, negative in filled.'),
 ('more','More','Actions','weight','More actions. Three solid square dots at two weights; hollow dots are too fragile at micro size.'),
 ('star','Star','Content','silhouette','Favorite. A conventional five-point star, distinct from the four-corner Focus reticle.')
]

def warning_parts(n,style):
    """Inspectable frame and punctuation for the gap contract in docs/construction.md.

    A triangle has much less room near its apex than a square, so it overshoots
    the keyline to give the punctuation a real field. At 12/16 px it is built
    around the pixel column left of center: a 1 px mark straddling the center
    would render as two half-strength columns. Filled punctuation has no inner
    contour to clear, so it uses the taller stem and the full negative width.
    """
    apex,x0,x1,base={12:((5.5,0),0,11,11),16:((7.5,.5),0,15,15),24:((12,1),1,23,23)}[n]
    cx=apex[0]
    if style=='outline':
        mw,sy,ey,dy,dh={12:(1,5.5,7,8,9),16:(1,8,10,11,12),24:(2,12,15,17,19)}[n]
    else:
        mw,sy,ey,dy,dh={12:(1,4,7,8,9),16:(1.5,6.5,10.5,12,13.5),24:(2,10,16,18,20)}[n]
    return (P([apex,(x1,base),(x0,base)]),
            U(box(cx-mw/2,sy,cx+mw/2,ey),box(cx-mw/2,dy,cx+mw/2,dh)))

def draw(name,n,style):
    s=n/24; p=PADDING[n]; q=n-p; c=n/2
    w=OUTLINE[n]; b=BOLD[n]; t=w if style=='outline' else b
    outlined=style=='outline'
    def k(v):return v*s
    def r(x0,y0,x1,y1):return box(k(x0),k(y0),k(x1),k(y1))
    def pp(points):return P([(k(x),k(y)) for x,y in points])
    def obj(shape):return ring(shape,w) if outlined else shape
    def ln(points,weight=None):return line([(k(x),k(y)) for x,y in points],t if weight is None else weight)
    # 16 px objects sit on the half-pixel grid. Scaling the 24 px drawing leaves
    # their straight edges on thirds, which rasterize unevenly at 1x and 2x.
    def hk(v):return round(k(v)*2)/2 if n==16 else k(v)
    def hp(points):return P([(hk(x),hk(y)) for x,y in points])

    if name=='arrow-right':
        # Construct the stroke at its final native width. Do not stretch
        # expanded paths to a box: that changes stems and diagonals unequally.
        if n==12 and outlined:  # Odd-width rule: see docs/optical-sizing.md.
            return U(line([(1.5,5.5),(9.5,5.5)],t),line([(6,2),(9.5,5.5),(6,9)],t))
        return U(ln([(3,12),(19,12)]),ln([(12,5),(19,12),(12,19)]))
    if name=='arrow-up-right':
        if n==16:  # Both weights keep their corner edges on the half-pixel grid.
            return U(line([(2.75,13.25),(12.75,3.25)],t),line([(6,3.25),(12.75,3.25),(12.75,10)],t))
        return U(ln([(4,20),(19,5)]),ln([(9,5),(19,5),(19,15)]))
    if name=='plus':
        if n==12 and outlined:c=5.5  # Optical half-pixel correction for a crisp 1px stem.
        return U(box(c-t/2,p,c+t/2,q),box(p,c-t/2,q,c+t/2))
    if name=='close':
        inset=t/(2*math.sqrt(2))
        return U(line([(p+inset,p+inset),(q-inset,q-inset)],t),line([(p+inset,q-inset),(q-inset,p+inset)],t))
    if name=='check':
        return ln([(4,12),(9,17),(20,6)])
    if name=='menu':
        ys=(2.5,5.5,8.5) if n==12 and outlined else (3,6,9) if n==12 else (3.25,8.25,13.25) if n==16 else (k(5),c,k(19))
        return U(*[box(p,y-t/2,q,y+t/2) for y in ys])
    if name=='play':
        shape=pp([(6,3),(22,12),(6,21)])
        return obj(shape)
    if name=='pause':
        # Bars mirror about the canvas center and share one pixel phase.
        centers={12:(3.5,8.5) if outlined else (4,8),16:(4.75,11.25) if outlined else (4.5,11.5),24:(7,17)}[n]
        wt=t if outlined else {12:2,16:3,24:4}[n]
        return U(*[box(x-wt/2,p,x+wt/2,q) for x in centers])
    if name=='home':
        shape=P([(6,1),(11,6),(10,6),(10,11),(2,11),(2,6),(1,6)]) if n==12 else hp([(12,2),(22,11),(20,11),(20,22),(4,22),(4,11),(2,11)])
        door_top=8 if n==12 else k(15)
        door=box(c-hk(2),door_top,c+hk(2),n)
        if not outlined:return shape.difference(door)
        shell=ring(shape,w)
        arch=box(c-hk(2)-w,door_top-w,c+hk(2)+w,hk(22)).difference(door)
        return U(shell,arch).intersection(shape).difference(door)
    if name=='search':
        # Dedicated lens dimensions; micro gets a wider opening than v0.2.
        a,z,corner={12:(1,9,2),16:(1.5,11.5,2.5),24:(2,17,4)}[n]
        shape=octagon(a,a,z,z,corner)
        g=U(ring(shape,t),line([(z-corner/2-t*.2,z-corner/2-t*.2),(q-t*.354,q-t*.354)],t))
        return g
    if name=='grid':
        # Dense groups sit inside the normal maximum keyline, not against it.
        pad={12:1,16:1.5,24:3}[n]; gap={12:2,16:3,24:4}[n]
        l=(n-2*pad-gap)/2
        return U(*[obj(box(x,y,x+l,y+l)) for x in (pad,pad+l+gap) for y in (pad,pad+l+gap)])
    if name=='sliders':
        # Two rows at EVERY native size. Reduce filled handle mass and the
        # overall footprint before changing the nominal rail/contour weight.
        controls,h,pad={12:([(3.5,3.5),(8.5,8.5)],3,1),
                        16:([(5,4.5),(11,11.5)],4.5,2),
                        24:([(8,7),(16,17)],6,3)}[n]
        parts=[]
        for x,y in controls:
            knob=box(x-h/2,y-h/2,x+h/2,y+h/2)
            rail=box(pad,y-w/2,n-pad,y+w/2).difference(knob)
            parts += [rail,ring(knob,w) if outlined else knob]
        return U(*parts)
    if name=='folder':
        shape=P([(1,2),(4,2),(6,4),(11,4),(11,10),(10,11),(1,11)]) if n==12 else hp([(2,4),(9,4),(12,7),(22,7),(22,19),(19,22),(2,22)])
        if outlined:return ring(shape,w)
        if n==12:return shape
        return shape.difference(box(p+w if n==16 else k(4),k(9),q-w if n==16 else k(20),k(9)+w))
    if name=='file':
        # The clipped outer corner is the document cue. Removing the inner
        # folded-corner elbow eliminates the subpixel triangular pocket.
        shape=hp([(4,2),(14,2),(20,8),(20,22),(4,22)])
        g=ring(shape,w) if outlined else shape
        if n==24:
            # Two unequal, left-aligned lines read as text. A single centered
            # bar reads as a file-minus action.
            content=U(box(8,12,16,14),box(8,16,13,18))
            g=U(g,content) if outlined else g.difference(content)
        return g
    if name in ('download','upload'):
        # Space arrows above the heaviest baseline, then use that same
        # skeleton in both styles. The small masters need more clearance.
        left,right,down_tip,down_start,up_tip,up_end={
            12:(3,9,6.5,1,2.5,7.5),
            16:(4,12,8.5,1.5,3.5,9.5),
            24:(6,18,14.5,2,4.5,16)}[n]
        if n==12 and outlined:c,left,right=5.5,2.5,8.5  # Odd-width rule.
        arm=c-left
        if name=='download':
            arrow=U(line([(c,down_start),(c,down_tip)],t),
                    line([(left,down_tip-arm),(c,down_tip),(right,down_tip-arm)],t))
        else:
            arrow=U(line([(c,up_tip),(c,up_end)],t),
                    line([(left,up_tip+arm),(c,up_tip),(right,up_tip+arm)],t))
        return U(arrow,box(p,q-t,q,q))
    if name=='user':
        head=octagon(hk(8),p,hk(16),hk(10),hk(2))
        body=P([(3,7),(9,7),(11,9),(11,11),(1,11),(1,9)]) if n==12 else hp([(7,13),(17,13),(22,18),(22,22),(2,22),(2,18)])
        return U(obj(head),obj(body))
    if name=='chat':
        shape=P([(1,2),(11,2),(11,8),(7,8),(4,11),(4,8),(1,8)]) if n==12 else hp([(2,3),(22,3),(22,17),(13,17),(7,22),(7,17),(2,17)])
        if outlined:
            g=ring(shape,w)
            if n==24:g=U(g,r(6,8,18,10))
        else:
            g=shape
            line_top=6 if n==16 else k(8)  # Centered in the 16 px bubble.
            if n>=16:g=g.difference(box(k(6),line_top,k(18),line_top+w))
        return g
    if name=='bell':
        shape=P([(6.5,1.5),(9.5,1.5),(9.5,2.5),(12,5),(12,9.5),(14,11.5),(14,12),(2,12),(2,11.5),(4,9.5),(4,5),(6.5,2.5)]) if n==16 else pp([(10,2),(14,2),(14,4),(18,8),(18,14),(21,17),(21,18),(3,18),(3,17),(6,14),(6,8),(10,4)])
        clapper=box(c-hk(2),hk(20),c+hk(2),q)
        return U(obj(shape),clapper)
    if name=='lock':
        shackle=octagon(k(6),p,k(18),k(15),k(3))
        shackle=ring(shackle,w).difference(box(0,hk(11),n,n))
        body=cutbox(p,hk(10),q,q,hk(2))
        kw=2 if n==12 else w
        key=box(c-kw/2,hk(14),c+kw/2,hk(18))
        if outlined:
            g=ring(body,w)
            if n==24:g=U(g,key)
        else:
            g=body.difference(key)
        return U(shackle,g)
    if name=='shield':
        shape={12:[(1,1),(11,1),(11,6),(6,11),(1,6)],
               16:[(2,2),(14,2),(14,8),(8,14),(2,8)],
               24:[(3,3),(21,3),(21,12),(12,21),(3,12)]}[n]
        return obj(P(shape))
    if name=='warning':
        shape,marks=warning_parts(n,style)
        return U(ring(shape,w),marks) if outlined else shape.difference(marks)
    if name=='focus':
        pad={12:1,16:2,24:3}[n]; end=n-pad
        arm={12:2.5,16:3.5,24:5}[n]
        wt=w if outlined else {12:1.5,16:2,24:2.5}[n]
        parts=[box(pad,pad,pad+arm,pad+wt),box(pad,pad,pad+wt,pad+arm),
               box(end-arm,pad,end,pad+wt),box(end-wt,pad,end,pad+arm),
               box(pad,end-wt,pad+arm,end),box(pad,end-arm,pad+wt,end),
               box(end-arm,end-wt,end,end),box(end-wt,end-arm,end,end)]
        dot={12:(2,2),16:(2,2.5),24:(2,3)}[n][0 if outlined else 1]
        return U(*parts,box(c-dot/2,c-dot/2,c+dot/2,c+dot/2))
    if name=='branch':
        if n==12:c=5.5  # Align the micro trunk and left-node opening to native pixels.
        pad={12:1,16:2,24:3}[n];end=n-pad
        h={12:3,16:4.5,24:6}[n]
        left=box(pad,c-h/2,pad+h,c+h/2)
        top=box(end-h,pad,end,pad+h)
        bot=box(end-h,end-h,end,end)
        rails=U(line([(pad+h,c),(c,c)],w),
                line([(end-h,pad+h/2),(c,pad+h/2),(c,end-h/2),(end-h,end-h/2)],w))
        nodes=U(left,top,bot)
        return U(rails.difference(nodes),*[ring(x,w) if outlined else x for x in (left,top,bot)])
    if name=='copy':
        front=cutbox(4,4,11,11,1) if n==12 else cutbox(hk(8),hk(7),q,q,hk(2))
        rear=U(box(p,p,hk(15),p+w),box(p,p,p+w,hk(17)))
        return U(rear,obj(front))
    if name=='trash':
        if n==12:
            body=cutbox(3,4,9,11,1);lid=box(1,2,11,3);handle=box(4,1,8,2)
        elif n==16:
            body=cutbox(4,6.5,12,14.5,1);lid=box(1.5,3.5,14.5,5);handle=box(6,1.5,10,3.5)
        else:
            body=cutbox(6,9,18,22,2);lid=box(2,5,22,7);handle=box(9,2,15,5)
        g=ring(body,w) if outlined else body
        # Leave micro/compact outlines empty; one slot is sufficient at 24px.
        if n==24:
            mark=box(11,13,13,18)
            g=U(g,mark) if outlined else g.difference(mark)
        elif n==16 and not outlined:
            g=g.difference(box(7.25,9,8.75,12))
        return U(lid,handle,g)
    if name=='bookmark':
        shape=P([(3,1),(8,1),(9,2),(9,11),(6,8),(3,11)]) if n==12 else P([(3.5,1.5),(11,1.5),(12.5,3),(12.5,14.5),(8,10.5),(3.5,14.5)]) if n==16 else pp([(5,2),(16,2),(19,5),(19,22),(12,16),(5,22)])
        return obj(shape)
    if name=='link':
        # Two open hooks on one 45° axis, each returning into the other's mouth.
        # Open strokes keep the same two-part topology at every size, so no
        # closed counter can fill in at 12 px. Filled 24 px takes the heavier 3 px
        # token so selection stays visible, with its two ends drawn back to hold the
        # 2 px gap. 12/16 px keep lighter strokes, which would otherwise clog.
        hook=line({12:[(5.5,7),(6.5,8),(10.5,4),(10.5,2.5),(9.5,1.5),(8,1.5),(7,2.5)],
                   16:[(7.75,9.75),(9,11),(13.75,6.25),(13.75,3.75),(12.25,2.25),(10.25,2.25),(9,3.5)],
                   24:[(11.5,14.5),(13,16),(21,8),(21,5),(19,3),(16,3),(13.25,5.75)] if outlined else [(11.75,14.75),(13,16),(21,8),(21,5),(19,3),(16,3),(13.5,5.5)]}[n],
                  w if outlined else {12:1.5,16:2,24:3}[n])
        return U(hook,affinity.rotate(hook,180,origin=(c,c)))
    if name=='chart':
        widths={12:(1,2),16:(1.5,3),24:(2,4)}[n]
        wt=widths[0 if outlined else 1]
        xs=(1.5,5.5,9.5) if n==12 and outlined else (3.25,8.25,13.25) if n==16 and outlined else (3,8,13) if n==16 else (k(4),c,k(20)); heights=(4,7,10) if n==12 else (5.5,8.5,13) if n==16 else (k(8),k(13),k(20))
        return U(*[box(x-wt/2,q-h,x+wt/2,q) for x,h in zip(xs,heights)])
    if name=='calendar':
        # A header rail at contour weight says "calendar". Two date marks under
        # no rail read as a face, so one off-center date replaces them, and the
        # micro master keeps only the frame, bindings and rail. Square corners:
        # a single cut corner would compete with the rail.
        x0,y0,x1,y1={12:(1,3,11,11),16:(2,3,14,14),24:(3,5,21,21)}[n]
        body=box(x0,y0,x1,y1)
        tabs=U(*[box(a,y0-{12:2,16:2,24:3}[n],a+w,y0) for a in {12:(3,8),16:(4.5,10),24:(7,15)}[n]])
        rail_top={12:5,16:6,24:9}[n]
        date={16:box(9,9,11,11),24:box(14,14,17,17)}.get(n)
        if outlined:
            return U(ring(body,w),tabs,box(x0,rail_top,x1,rail_top+w),*([date] if date else []))
        solid=U(body,tabs).difference(box(x0+w,rail_top,x1-w,rail_top+w))
        return solid.difference(date) if date else solid
    if name=='terminal':
        # A square window, so the frame cannot read as File's clipped page. The
        # prompt keeps open arms at every size and is always followed by a cursor.
        if n==12:
            shape=box(1,2,11,11)
            mark=U(line([(3.5,4.5),(5.5,6.5),(3.5,8.5)],1),box(7,8,9,9))
        elif n==16:
            shape=box(1,2,15,14)
            mark=U(line([(4.6,5.6),(7,8),(4.6,10.4)],1.5),box(9.5,9.5,12,11))
        else:
            shape=box(3,4,21,20)
            mark=U(line([(8,9),(11,12),(8,15)],2),box(14,14,17,16))
        return U(ring(shape,w),mark) if outlined else shape.difference(mark)
    if name=='more':
        wt={12:(1,2),16:(2,3),24:(3,4)}[n][0 if outlined else 1]
        xs=(1.5,5.5,9.5) if n==12 and outlined else (3,8,13) if n==16 else (k(4),c,k(20))
        if n==12 and outlined:c=5.5
        return U(*[box(x-wt/2,c-wt/2,x+wt/2,c+wt/2) for x in xs])
    if name=='star':
        # Intentional five-point geometry; no 4-point sparkle/reticle ambiguity.
        spec={12:[(6,1),(7.5,4.25),(11,4.65),(8.4,7.05),(9.1,10.65),(6,8.95),(2.9,10.65),(3.6,7.05),(1,4.65),(4.5,4.25)],
              16:[(8,1.5),(10.05,5.85),(14.8,6.4),(11.3,9.65),(12.25,14.5),(8,12.15),(3.75,14.5),(4.7,9.65),(1.2,6.4),(5.95,5.85)],
              24:[(12,2),(15.1,8.5),(22,9.35),(16.95,14.1),(18.35,21.1),(12,17.6),(5.65,21.1),(7.05,14.1),(2,9.35),(8.9,8.5)]}
        shape=P(spec[n])
        return obj(shape)
    raise KeyError(name)
