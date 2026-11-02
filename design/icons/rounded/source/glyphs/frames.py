"""Glyphs that live in a frame: circles, panels, and windows with positive or cut marks."""
from __future__ import annotations

from source.glyphs.kit import arc, disc, framed, panel, reflect_x, stroke, tokens
from source.primitives import circle, ring, rounded_rect, stadium_line, union
from source.seams import CUT_JOIN


def circle_shape(n, appearance):
    w, t, p, outlined, R, acute = tokens(n, appearance)
    return framed(disc(n), w, outlined)


def square(n, appearance):
    w, t, p, outlined, R, acute = tokens(n, appearance)
    inset = {12: 1.0, 16: 2.0, 24: 3.0}[n]
    return framed(rounded_rect(inset, inset, n - inset, n - inset, R), w, outlined)


def _in_circle(n, appearance, marks):
    w, t, p, outlined, R, acute = tokens(n, appearance)
    return framed(disc(n), w, outlined, marks)


def check_circle(n, appearance):
    # The mark stays clear of the frame by the gap target, at every master.
    w = tokens(n, appearance)[0]
    path = {
        12: [(3.9, 6.0), (5.3, 7.4), (8.0, 4.7)],
        16: [(5.4, 8.0), (7.2, 9.8), (10.3, 6.7)],
        24: [(7.6, 12.0), (10.8, 15.2), (16.3, 9.7)],
    }[n]
    return _in_circle(n, appearance, [stroke(path, w)])


def close_circle(n, appearance):
    w = tokens(n, appearance)[0]
    arm = {12: 1.75, 16: 1.9, 24: 3.4}[n]
    c = n / 2
    return _in_circle(n, appearance, [
        stroke([(c - arm, c - arm), (c + arm, c + arm)], w),
        stroke([(c - arm, c + arm), (c + arm, c - arm)], w),
    ])


def ban(n, appearance):
    # Heavier ring and bar rather than a solid disc: the two counters are the prohibition sign.
    w, t, p, outlined, R, acute = tokens(n, appearance)
    shape = disc(n)
    radius = n / 2 - p
    inner = shape.buffer(-t)
    # Run the slash to the ring's own centreline so it joins the ring and never crosses the keyline.
    reach = (radius - t / 2) * 0.7071
    c = n / 2
    slash = stroke([(c - reach, c - reach), (c + reach, c + reach)], t)
    return union(shape.difference(inner), slash)


# Stem width, dot radius, dot centre, and the stem's two centreline ends.
_INFO = {
    12: (1.5, 0.75, 3.75, 6.25, 8.25),
    16: (1.5, 0.8, 5.3, 8.35, 10.75),
    24: (2.0, 1.25, 8.0, 12.25, 16.0),
}


def info(n, appearance):
    width, r, dot_y, stem_top, stem_bottom = _INFO[n]
    c = n / 2
    return _in_circle(n, appearance, [
        circle(c, dot_y, r), stadium_line(c, stem_top, c, stem_bottom, width)])


# Stroke, hook radius, hook centre y, the stem's end y, dot radius, dot y.
_HELP = {
    12: (1.0, 1.1, 4.6, 6.1, 0.7, 8.3),
    16: (1.35, 1.4, 6.575, 7.975, 0.675, 10.825),
    24: (2.0, 2.35, 9.45, 12.8, 1.1, 16.9),
}


def help_(n, appearance):
    width, r, hook_y, stem_end, dot_r, dot_y = _HELP[n]
    c = n / 2
    hook = stroke([*arc(c, hook_y, r, 195, 400), (c, stem_end)], width)
    return _in_circle(n, appearance, [hook, circle(c, dot_y, dot_r)])


def grid(n, appearance):
    w, t, p, outlined, R, acute = tokens(n, appearance)
    a0, a1, b0, b1, r = {12: (1, 5, 7, 11, 1.25), 16: (1.5, 7, 9, 14.5, 1.6), 24: (3, 11, 13, 21, 2.6)}[n]
    return union(*(
        panel(x0, y0, x1, y1, r, w, outlined)
        for x0, x1 in ((a0, a1), (b0, b1)) for y0, y1 in ((a0, a1), (b0, b1))
    ))


def dashboard(n, appearance):
    # Same gutters as Grid, but the panels differ in height: an overview, not a uniform set.
    w, t, p, outlined, R, acute = tokens(n, appearance)
    a0, a1, b0, b1, tall, short, r = {
        12: (1, 5, 7, 11, 6, 4, 1.25),
        16: (1.5, 7, 9, 14.5, 8, 6, 1.6),
        24: (3, 11, 13, 21, 13, 9, 2.6),
    }[n]
    gutter = b0 - a1
    return union(
        panel(a0, a0, a1, tall, r, w, outlined),
        panel(a0, tall + gutter, a1, b1, r, w, outlined),
        panel(b0, a0, b1, short, r, w, outlined),
        panel(b0, short + gutter, b1, b1, r, w, outlined),
    )


def table(n, appearance):
    # The header band is what separates a table from Grid and Calendar. Filled keeps it solid.
    w, t, p, outlined, R, acute = tokens(n, appearance)
    inset, header, column, row = {
        12: (1.0, 4.5, 5.5, None),
        16: (1.5, 5.75, 7.25, 10.25),
        24: (3.0, 9.0, 11.0, 15.0),
    }[n]
    frame = rounded_rect(inset, inset, n - inset, n - inset, R)
    inner = frame.buffer(-w)
    half = w / 2
    columns = ((inset + w, column - half), (column + half, n - inset - w))
    rows = ((header + half, n - inset - w),) if row is None else (
        (header + half, row - half), (row + half, n - inset - w))
    cells = [
        rounded_rect(x0, y0, x1, y1, CUT_JOIN[n]).intersection(inner)
        for x0, x1 in columns for y0, y1 in rows
    ]
    if outlined:
        return frame.difference(union(rounded_rect(inset + w, inset + w, n - inset - w, header - half, CUT_JOIN[n]).intersection(inner), *cells))
    return frame.difference(union(*cells))


def terminal(n, appearance):
    # A window holding a prompt: chevron and cursor. Code has neither frame nor cursor.
    w, t, p, outlined, R, acute = tokens(n, appearance)
    frame_box, prompt, cursor = {
        12: ((1.0, 2.0, 11.0, 10.0), [(3.5, 4.5), (5.0, 6.0), (3.5, 7.5)], ((6.5, 7.5), (8.5, 7.5))),
        16: ((1.5, 2.5, 14.5, 13.5), [(5.25, 6.25), (7.0, 8.0), (5.25, 9.75)], ((9.5, 9.75), (10.75, 9.75))),
        24: ((2.0, 4.0, 22.0, 20.0), [(7.0, 9.0), (10.0, 12.0), (7.0, 15.0)], ((13.0, 15.0), (17.0, 15.0))),
    }[n]
    (a, b), (c, d) = cursor
    return framed(rounded_rect(*frame_box, R), w, outlined, [
        stroke(prompt, w), stadium_line(a, b, c, d, w)])


def input_(n, appearance):
    # A wide field and a caret at its start. No chevron, so it cannot read as Terminal.
    w, t, p, outlined, R, acute = tokens(n, appearance)
    frame_box, caret = {
        12: ((1.0, 2.0, 11.0, 10.0), (3.5, 4.5, 7.5)),
        16: ((1.5, 3.0, 14.5, 13.0), (5.25, 6.75, 9.25)),
        24: ((2.0, 5.0, 22.0, 19.0), (7.0, 10.0, 14.0)),
    }[n]
    x, y0, y1 = caret
    return framed(rounded_rect(*frame_box, R), w, outlined, [stadium_line(x, y0, x, y1, w)])


# Guide x, guide ends, the two panels' y ranges, and the panels' lengths. Object alignment, not text:
# a shared axis and two selected panels, which is what separates these from Menu.
_ALIGN = {
    12: (1.5, 1.0, 11.0, (2.0, 5.0), (7.0, 10.0), 1.0, 3.0, (8.0, 5.0), 0.9),
    16: (2.25, 1.5, 14.5, (2.25, 6.75), (9.25, 13.75), 1.5, 4.5, (10.0, 6.5), 1.25),
    24: (3.0, 2.0, 22.0, (4.5, 10.5), (13.5, 19.5), 2.0, 6.0, (16.0, 10.0), 1.8),
}


def align_left(n, appearance):
    x, y0, y1, upper, lower, w, start, lengths, r = _ALIGN[n]
    outlined = appearance == 'outline'
    return union(
        stadium_line(x, y0 + w / 2, x, y1 - w / 2, w),
        panel(start, upper[0], start + lengths[0], upper[1], r, w, outlined),
        panel(start, lower[0], start + lengths[1], lower[1], r, w, outlined),
    )


def align_right(n, appearance):
    return reflect_x(align_left(n, appearance), n)


def align_center(n, appearance):
    # The 12 px axis sits on a pixel column, so the two panels are centred on 5.5, not on the canvas.
    x0, y0, y1, upper, lower, w, start, lengths, r = _ALIGN[n]
    outlined = appearance == 'outline'
    axis = 5.5 if n == 12 else n / 2
    wide = 9.0 if n == 12 else {16: 11.0, 24: 16.0}[n]
    narrow = 5.0 if n == 12 else {16: 6.5, 24: 10.0}[n]
    top = rounded_rect(axis - wide / 2, upper[0], axis + wide / 2, upper[1], r)
    bottom = rounded_rect(axis - narrow / 2, lower[0], axis + narrow / 2, lower[1], r)
    # The axis stops at each panel, so no panel counter has a line through it.
    guide = stadium_line(axis, y0 + w / 2, axis, y1 - w / 2, w).difference(union(top, bottom))
    panels = (ring(top, w), ring(bottom, w)) if outlined else (top, bottom)
    return union(guide, *panels)


DRAWERS = {
    'align-left': align_left,
    'align-center': align_center,
    'align-right': align_right,
    'circle': circle_shape,
    'square': square,
    'check-circle': check_circle,
    'close-circle': close_circle,
    'ban': ban,
    'info': info,
    'help': help_,
    'grid': grid,
    'dashboard': dashboard,
    'table': table,
    'terminal': terminal,
    'input': input_,
}
