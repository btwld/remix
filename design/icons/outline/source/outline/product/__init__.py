"""Authored constructors for the 29 product-inventory concepts.

Each concept is drawn natively at 12, 16 and 24 px from the family's own
primitives. No external artwork, font outline or scaled master is involved.
"""
from __future__ import annotations

from . import objects, status, symbols, text
from .common import REGISTRY, without_collinear_vertices

NAMES = tuple(REGISTRY)


def draw(name: str, n: int, appearance: str):
    if name not in REGISTRY or n not in (12, 16, 24) or appearance not in ('outline', 'filled'):
        raise ValueError(f'Unsupported drawing: {name}/{appearance}/{n}')
    return without_collinear_vertices(REGISTRY[name](name, n, appearance == 'outline'))
