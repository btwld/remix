"""Registry and shared measurements for the product constructors."""
from __future__ import annotations

from shapely.geometry import box

REGISTRY = {}
CANVAS = {12: (1, 11), 16: (1.5, 14.5), 24: (2, 22)}


def icon(*names):
    """Register one constructor, called as fn(name, n, outlined), per concept."""
    def register(fn):
        for name in names:
            if name in REGISTRY:
                raise ValueError(f'Duplicate constructor: {name}')
            REGISTRY[name] = fn
        return fn
    return register


def rects(*specs):
    """Axis-aligned rectangles given as (x0, y0, x1, y1)."""
    return [box(*spec) for spec in specs]
